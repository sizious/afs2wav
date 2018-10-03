unit about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, StdCtrls, ShellApi;

type
  TAboutBox = class(TForm)
    Image_Panel: TPanel;
    Sizious_Image: TImage;
    Bevel: TBevel;
    OKButton: TButton;
    Address: TLabel;
    Label1: TLabel;
    procedure AddressMouseEnter(Sender: TObject);
    procedure AddressMouseLeave(Sender: TObject);
    procedure AddressClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

procedure TAboutBox.AddressMouseEnter(Sender: TObject);
begin
  AboutBox.Address.Font.Style := [fsUnderline];
  AboutBox.Address.Font.Color := clBlue;
  AboutBox.Address.Cursor := crHandPoint;
end;

procedure TAboutBox.AddressMouseLeave(Sender: TObject);
begin
  AboutBox.Address.Font.Style := [];
  AboutBox.Address.Font.Color := clBlack;
  AboutBox.Address.Cursor := crDefault;
end;

procedure TAboutBox.AddressClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'http://www.sbibuilder.fr.st/', '', '', 0);
end;

procedure TAboutBox.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
    Key := #0;
  end;
end;

end.
