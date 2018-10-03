program afs_adx;

uses
  Forms,
  main in 'main.pas' {Main_Form},
  utils in 'utils.pas',
  sh_listb in 'sh_listb.pas',
  about in 'About.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain_Form, Main_Form);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
