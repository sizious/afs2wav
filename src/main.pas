unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, JvRichEdit, XPMan,
  JvBaseDlg, JvBrowseFolder, Scrute, TFlatHintUnit, ShellApi, Menus,
  XPMenu, ImgList;

type
  TMain_Form = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    bAddFile: TBitBtn;
    bAddDir: TBitBtn;
    bAbout: TBitBtn;
    bExit: TBitBtn;
    bConvert: TBitBtn;
    Bevel1: TBevel;
    cbExtractAll: TCheckBox;
    cbWave: TCheckBox;
    XPManifest: TXPManifest;
    Image1: TImage;
    lbAFS: TListBox;
    bDelete: TBitBtn;
    odFile: TOpenDialog;
    fdAddDir: TJvBrowseForFolderDialog;
    fdOutput: TJvBrowseForFolderDialog;
    ScruteDossier: TScruteDossier;
    bAbort: TBitBtn;
    Image2: TImage;
    Image3: TImage;
    Image5: TImage;
    Panel2: TPanel;
    reOutput: TListBox;
    Image4: TImage;
    Image6: TImage;
    Image7: TImage;
    pbar: TProgressBar;
    FlatHint: TFlatHint;
    PopupMenu: TPopupMenu;
    ImageList: TImageList;
    XPMenu: TXPMenu;
    Adddir1: TMenuItem;
    Addfile1: TMenuItem;
    N1: TMenuItem;
    Delete1: TMenuItem;
    Startconversion1: TMenuItem;
    Abortconversion1: TMenuItem;
    N2: TMenuItem;
    Clearall1: TMenuItem;
    pmDebug: TPopupMenu;
    Savedebugto1: TMenuItem;
    Cleardebuglog1: TMenuItem;
    SaveDialog: TSaveDialog;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure bAddFileClick(Sender: TObject);
    procedure ScruteDossierFichier(Sender: TObject; Nom: String);
    procedure bAddDirClick(Sender: TObject);
    procedure bDeleteClick(Sender: TObject);
    procedure bExitClick(Sender: TObject);
    procedure bConvertClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bAbortClick(Sender: TObject);
    procedure TraiteMessage(var Msg: TMsg; var Handled: boolean);
    procedure lbAFSContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Adddir1Click(Sender: TObject);
    procedure Addfile1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Startconversion1Click(Sender: TObject);
    procedure Abortconversion1Click(Sender: TObject);
    procedure Clearall1Click(Sender: TObject);
    procedure lbAFSKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Cleardebuglog1Click(Sender: TObject);
    procedure Savedebugto1Click(Sender: TObject);
    procedure bAboutClick(Sender: TObject); // Dans FormCreate, on a mis Application.OnMessage := TraiteMessage;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Main_Form: TMain_Form;
  InProgress : boolean = False;
  MustStop   : boolean = False;

implementation

uses utils, sh_listb, about;

{$R *.dfm}
{$R adxutil.RES}

procedure TMain_Form.TraiteMessage(var Msg: TMsg; var Handled: boolean); // Dans FormCreate, on a mis Application.OnMessage := TraiteMessage;
// c'est donc cette procédure qui est appelée à chaque fois que se déclenche l'évènement OnMessage (c'est à dire à chaque fois que Windows envoie un message à l'application)
// faire attention cette procédure est appelé très souvent par Windows d'où le if dés le départ.
var
  NombreDeFichiers, i : integer;   // Size
  NomDuFichierStr     : string;
  NomDuFichier        : array[0..255] of Char;
  //PointDuLache        : TPoint; // point du laché

begin
  if Msg.Message = WM_DROPFILES then
  begin
    if bDelete.Enabled = False then Exit; //Si delete est désactivé, on se tire.
    
    NombreDeFichiers := DragQueryFile(Msg.wParam, $FFFFFFFF, NomDuFichier, SizeOf(NomDuFichier));// récupération du nombre de fichiers

    for i := 0 to NombreDeFichiers - 1 do
    begin
      //Size :=
      DragQueryFile(Msg.wParam, i, NomDuFichier, SizeOf(NomDuFichier));// récupération du nom du fichier
      NomDuFichierStr := NomDuFichier; // tansformation du tableau de char en string

      //Si c'est un AFS, et si il est pas déjà dans le truc
      if UpperCase(ExtractFileExt(NomDuFichierStr)) = '.AFS' then
        if ChercheExact_ListBox(NomDuFichierStr, Main_Form.lbAFS) = -1 then
          Main_Form.lbAFS.Items.Add(NomDuFichierStr);

      //DragQueryPoint(Msg.wParam,PointDuLache); // récupération du point de laché
      //Memo1.Lines.add(NomDuFichierStr+' X='+IntToStr(PointDuLache.x)+' Y='+ IntToStr(PointDuLache.y));
      //DessineIcone(NomDuFichier,PointDuLache);
    end;
    
  end;
end;


procedure TMain_Form.bAddFileClick(Sender: TObject);
begin
  if odFile.Execute = True then
    AddAFSFile(odFile.FileName);
end;

procedure TMain_Form.ScruteDossierFichier(Sender: TObject; Nom: String);
begin
  if UpperCase(ExtractFileExt(Nom)) = '.AFS' then
  begin
    if ChercheExact_ListBox(Nom, Main_Form.lbAFS) = -1 then
      AddAFSFile(Nom);
  end;
end;

procedure TMain_Form.bAddDirClick(Sender: TObject);
begin
  if fdAddDir.Execute = True then
    AddAFSDir(fdAddDir.Directory);
end;

procedure TMain_Form.bDeleteClick(Sender: TObject);
begin
  if bDelete.Enabled = False then Exit;
  DeleteSelected;
end;

procedure TMain_Form.bExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMain_Form.bConvertClick(Sender: TObject);
begin
  LaunchConverting;
end;

procedure TMain_Form.FormCreate(Sender: TObject);
begin
  Application.Title := Main_Form.Caption;
  DragAcceptFiles(lbAFS.Handle, True);
  Application.OnMessage := TraiteMessage; // c'est la procédure TraiteMessage qui va traiter les messages
  ExtractProgram;
end;

procedure TMain_Form.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DeleteProgram;
end;

procedure TMain_Form.bAbortClick(Sender: TObject);
begin
  if InProgress = False then
  begin
    ActiveAll;
    MustStop := False;
    InProgress := False;
    Exit;
  end;

  StopProcedure;
end;

procedure TMain_Form.lbAFSContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  Point : TPoint;

begin
  //Avec MousePos de cette procedure, ca marche pas.
  //Pas compris pourquoi...

  //On prend les coordonnées du curseur de souris...
  GetCursorPos(Point);

  //Cette ensemble de procédure permet de simuler le click.
  //Un click gauche est constitué de deux clicks : quand le
  //bouton est en haut, et quand le bouton est en bas.
  Mouse_Event(MOUSEEVENTF_LEFTDOWN, Point.X, Point.Y, 0, 0);
  Mouse_Event(MOUSEEVENTF_LEFTUP, Point.X, Point.Y, 0, 0);

  //Permet "d'activer" la sélection. Sinon ca sélectionne pas.
  //En fait, ca rend la main a Windows.
  Application.ProcessMessages;

  //On déroule avec du code pour dérouler si seulement la
  //CheckBox est cochée. Vous pouvez enlever ca, et mettre
  //AutoPopup à True dans le PopupMenu.
  //PopUpMenu.Popup(Point.X, Point.Y);
end;

procedure TMain_Form.Adddir1Click(Sender: TObject);
begin
  bAddDir.Click;  
end;

procedure TMain_Form.Addfile1Click(Sender: TObject);
begin
  bAddFile.Click;
end;

procedure TMain_Form.Delete1Click(Sender: TObject);
begin
  bDelete.Click;
end;

procedure TMain_Form.Startconversion1Click(Sender: TObject);
begin
  bConvert.Click;
end;

procedure TMain_Form.Abortconversion1Click(Sender: TObject);
begin
  bAbort.Click;
end;

procedure TMain_Form.Clearall1Click(Sender: TObject);
var
  CanDo : integer;

begin
  CanDo := MsgBox(Handle, 'Are you sure to clear the list ?', 'Question', 32 + MB_YESNO + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;
  Main_Form.lbAFS.Clear;
end;

procedure TMain_Form.lbAFSKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //if Key = VK_CLEAR then showmessage('yo');
  //if Key = Chr(VK_DELETE) then Showmessage('YO');
  if Key = VK_DELETE then bDelete.Click//Showmessage('YO');
  
  //if key = 'a' then showmessage('yo');
  //ShowMessage(IntToStr(Ord(VK_DELETE)));
end;

procedure TMain_Form.Cleardebuglog1Click(Sender: TObject);
var
  CanDo : integer;

begin
  CanDo := MsgBox(Handle, 'Are you sure to clear the debug log ?', 'Question', 32 + MB_YESNO + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;
  Main_Form.reOutput.Clear;
end;

procedure TMain_Form.Savedebugto1Click(Sender: TObject);
begin
  if SaveDialog.Execute = True then
    Main_Form.reOutput.Items.SaveToFile(SaveDialog.FileName);
end;

procedure TMain_Form.bAboutClick(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

end.
