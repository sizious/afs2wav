unit utils;

interface

uses
  Windows, SysUtils, Classes, Forms; //, DIALOGS;

procedure AddAFSFile(FileName : string);
procedure AddAFSDir(Directory : string);
procedure DeleteSelected;
procedure LaunchConverting;
procedure ExtractFile(Chemin, Ressource, Extension :string);
function GetTempDir : String;
procedure ExtractProgram;
procedure DeleteProgram;
procedure AddDebug(Line : string);
procedure DisactiveAll;
procedure ActiveAll;
procedure StopProcedure;
function MsgBox(Handle : HWND ; Message, Caption : string ; Flags : integer) : integer;

implementation

uses main, sh_listb;

//---RunAndWait---
function RunAndWait(FileName : string) : boolean;
var
  StartInfo : TStartupInfo;
  ProcessInformation : TProcessInformation;
  
begin
  Result := True;
  ZeroMemory(@StartInfo, SizeOf(StartInfo)); // remplie de 0 StartInfo

  with StartInfo do
  begin
    CB := SizeOf(StartInfo);
    wShowWindow := SW_HIDE;
    lpReserved := nil;
    lpDesktop := nil;
    lpTitle := nil;
    dwFlags := STARTF_USESHOWWINDOW;
    cbReserved2 := 0;
    lpReserved2 := nil;
  end;

  if CreateProcess(nil, PChar(FileName), nil, nil, True, 0, nil, nil, StartInfo,
    ProcessInformation)
  then WaitForSingleObject(ProcessInformation.hProcess, INFINITE)
  // WaitForSingleObject attend que l'application désignée par le handle
  //ProcessInformation.hProcess soit terminée
  else Result := False;
end;

//---ExtractProgram---
procedure ExtractProgram;
begin
  if FileExists(GetTempDir + 'ADXUTIL.EXE') = True then DeleteFile(GetTempDir + 'ADXUTIL.EXE');
  ExtractFile(GetTempDir, 'ADXUTIL', 'EXE');
end;

//---DeleteProgram---
procedure DeleteProgram;
begin
  if FileExists(GetTempDir + 'ADXUTIL.EXE') = True then DeleteFile(GetTempDir + 'ADXUTIL.EXE');
end;

//---MsgBox---
function MsgBox(Handle : HWND ; Message, Caption : string ; Flags : integer) : integer;
begin
  Result := MessageBoxA(Handle, PChar(Message), PChar(Caption), Flags);
end;

//---AddAFSFile---
procedure AddAFSFile(FileName : string);
begin
  if FileName = '' then Exit;
  if FileExists(FileName) = False then Exit;
  if ChercheExact_ListBox(FileName, Main_Form.lbAFS) <> -1 then Exit;
  Main_Form.lbAFS.Items.Add(FileName);
end;

//---AddAFSDir---
procedure AddAFSDir(Directory : string);
begin
  if Directory = '' then Exit;
  if DirectoryExists(Directory) = False then Exit;
  Main_Form.ScruteDossier.Dossier := Directory;
  Main_Form.ScruteDossier.Execute;
end;

//---DeleteSelected---
procedure DeleteSelected;
begin
  if (Main_Form.lbAFS.ItemIndex = -1) or
     (Main_Form.lbAFS.Items.Count = 0) or
     (Main_Form.lbAFS.ItemIndex >= Main_Form.lbAFS.Items.Count) then
  begin
    MsgBox(Main_Form.Handle, 'Please select a valid item!', 'Warning', 48);
    Exit;
  end;
     
  Main_Form.lbAFS.DeleteSelected;
end;

//---StopProcedure---
procedure StopProcedure;
var
  Rep : integer;

begin
  Rep := MsgBox(Main_Form.Handle, 'Are you sure to stop ?', 'Warning', MB_YESNO + 48 + MB_DEFBUTTON2);
  if Rep = IDNO then Exit;

  AddDebug('Stopped.');
  MustStop := True;
  ActiveAll;
  //Main_Form.lbAFS.Clear;
end;

//---DisactiveAll---
procedure DisactiveAll;
begin
  Main_Form.bAddDir.Enabled := False;
  Main_Form.bAddFile.Enabled := False;
  Main_Form.bDelete.Enabled := False;
  Main_Form.bAbout.Enabled := False;
  Main_Form.cbExtractAll.Enabled := False;
  Main_Form.cbWave.Enabled := False;
  Main_Form.bConvert.Enabled := False;
  Main_Form.bAbort.Visible := True;

  //menu click droit
  Main_Form.Abortconversion1.Enabled := True;
  Main_Form.Adddir1.Enabled := False;
  Main_Form.Addfile1.Enabled := False;
  Main_Form.Delete1.Enabled := False;
  Main_Form.Clearall1.Enabled := False;
  Main_Form.Startconversion1.Enabled := False;

  InProgress := True;
end;

//---ActiveAll---
procedure ActiveAll;
begin
  Main_Form.bAddDir.Enabled := True;
  Main_Form.bAddFile.Enabled := True;
  Main_Form.bDelete.Enabled := True;
  Main_Form.bAbout.Enabled := True;
  Main_Form.cbExtractAll.Enabled := True;
  Main_Form.cbWave.Enabled := True;
  Main_Form.bConvert.Enabled := True;
  Main_Form.bAbort.Visible := False;

  //menu click droit
  Main_Form.Abortconversion1.Enabled := False;
  Main_Form.Adddir1.Enabled := True;
  Main_Form.Addfile1.Enabled := True;
  Main_Form.Delete1.Enabled := True;
  Main_Form.Clearall1.Enabled := True;
  Main_Form.Startconversion1.Enabled := True;

  InProgress := False;
  //MustStop := False;
  Main_Form.pbar.Position := 0;
end;

//---LaunchConverting---
procedure LaunchConverting;

//^^PerformConverting^^
procedure PerformConverting(FileName : string ; DestinationDir : string);
var
  ExtractAll,
  ConvertToWave : string;
  
begin
  if FileExists(FileName) = False then Exit;
  
  if Main_Form.cbExtractAll.Checked = True then ExtractAll := ' -all '
    else ExtractAll := '';

  if Main_Form.cbWave.Checked = True then ConvertToWave := ' -wave '
    else ConvertToWave := '';

  //Launch conversion
  SetCurrentDir(DestinationDir);  
  AddDebug('Converting "' + FileName + '"...');
  Application.ProcessMessages;
  RunAndWait('"' + GetTempDir + 'ADXUTIL.EXE" "' + FileName + '"' + ExtractAll + ConvertToWave);
end;

//^^Main Function^^
var
  i : integer;
  FileName : string;

begin
  if Main_Form.lbAFS.Items.Count = 0 then
  begin
    MsgBox(Main_Form.Handle, 'Nothing to convert.', 'Warning', 48);
    Exit;
  end;

  DisactiveAll;
  Main_Form.pbar.Max := Main_Form.lbAFS.Items.Count;
  //ShowMessage(IntToStr(Main_Form.pbar.Max));
  
  InProgress := True;
  MustStop := False;
  
  if Main_Form.fdOutput.Execute = True then
  begin

    AddDebug('Target directory : ' + Main_Form.fdOutput.Directory);

    for i := 0 to Main_Form.lbAFS.Items.Count - 1 do
    begin
      Application.ProcessMessages;

      if MustStop = True then
      begin
        //MsgBox(0, 'MERDE', '', 0);
        InProgress := False;
        Exit;
      end;

      if i = 0 then Main_Form.pbar.Position := Main_Form.pbar.Position + 1
      else Main_Form.pbar.Position := i;
      //ShowMessage(IntToStr(Main_Form.pbar.Position));

      //FileName := Main_Form.lbAFS.Items.Strings[i];
      FileName := Main_Form.lbAFS.Items.Strings[0];
      Main_Form.lbAFS.Items.Delete(0); //effacer le fichier converti

      if FileExists(FileName) = False then Exit;
      Application.ProcessMessages;
      PerformConverting(FileName, Main_Form.fdOutput.Directory);
    end;

    Main_Form.lbAFS.Clear;
    AddDebug('Done.');
  end;

  { if Main_Form.DosCommand.Active = True then
  begin
    Goto Retry;
    Application.ProcessMessages;
  end else Retry : AddDebug('Conversion all done.'); }
  
  //ActiveAll;
  //SetCurrentDir(GetTempDir);
  ActiveAll;
end;

//---GetTempDir---
function GetTempDir : String;
var
  Dossier: array[0..MAX_PATH] of char;
begin
  result:='';
  if GetTempPath(SizeOf(Dossier), Dossier)<>0 then Result := StrPas(Dossier);
end;

//---ExtractFile---
procedure ExtractFile(Chemin, Ressource, Extension :string);
var
 StrNomFichier : string;
 ResourceStream : TResourceStream;
 FichierStream  : TFileStream;

begin
  StrNomFichier := Chemin + '\' + Ressource + '.' + Extension;
  ResourceStream := TResourceStream.Create(hInstance, Ressource, RT_RCDATA);

  try
    FichierStream := TFileStream.Create(StrNomFichier, fmCreate);
    try
      FichierStream.CopyFrom(ResourceStream, 0);
    finally
      FichierStream.Free;
    end;
  finally
    ResourceStream.Free;
  end;
end;

//---AddDebug---
procedure AddDebug(Line : string);
begin
  Main_Form.reOutput.Items.Add(DateToStr(Date) + ' | ' + TimeToStr(Time) + ' : ' + Line);
  Main_Form.reOutput.ItemIndex := Main_Form.reOutput.Items.Count - 1;
end;

end.
