unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, PasswordGenerator,Clipbrd;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnCopy: TButton;
    CheckGroup1: TCheckGroup;
    CheckMaj: TCheckBox;
    CheckMin: TCheckBox;
    CheckNum: TCheckBox;
    CheckSym: TCheckBox;
    CheckSpa: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    lPassword: TLabel;
    TrackLen: TTrackBar;
    procedure btnCopyClick(Sender: TObject);
    procedure CheckMajClick(Sender: TObject);
    procedure CheckMinClick(Sender: TObject);
    procedure CheckNumClick(Sender: TObject);
    procedure CheckSpaClick(Sender: TObject);
    procedure CheckSymClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SetTrackLenStatus;
    procedure TrackLenChange(Sender: TObject);
  private

  public
     PasswordGenerator: TPasswordGenerator;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.SetTrackLenStatus;
var
  TrackEnabled, CheckSelected:boolean;
begin
     TrackEnabled:=false;
     for CheckSelected in PasswordGenerator.Selected do
     if CheckSelected=true then
     begin
      TrackEnabled:=true;
     end;
     TrackLen.enabled:=TrackEnabled;
end;

procedure TForm1.CheckSpaClick(Sender: TObject);
begin
  PasswordGenerator.SetSelected(3, CheckSpa.Checked);
  SetTrackLenStatus;
  lPassword.Caption:=PasswordGenerator.GeneratePassword;
end;

procedure TForm1.CheckNumClick(Sender: TObject);
begin
  PasswordGenerator.SetSelected(2, CheckNum.Checked);
  SetTrackLenStatus;
  lPassword.Caption:=PasswordGenerator.GeneratePassword;
end;

procedure TForm1.CheckMinClick(Sender: TObject);
begin
  PasswordGenerator.SetSelected(0, CheckMin.Checked);
  SetTrackLenStatus;
  lPassword.Caption:=PasswordGenerator.GeneratePassword;
end;

procedure TForm1.CheckMajClick(Sender: TObject);
begin
  PasswordGenerator.SetSelected(1, CheckMaj.Checked);
  SetTrackLenStatus;
  lPassword.Caption:=PasswordGenerator.GeneratePassword;
end;

procedure TForm1.btnCopyClick(Sender: TObject);
begin
  Clipboard.AsText := lPassword.Caption;
  ShowMessage('Mot de passe copié');
end;

procedure TForm1.CheckSymClick(Sender: TObject);
begin
  PasswordGenerator.SetSelected(4, CheckSym.Checked);
  SetTrackLenStatus;
  lPassword.Caption:=PasswordGenerator.GeneratePassword;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PasswordGenerator:= TPasswordGenerator.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  PasswordGenerator.Destroy;
end;

procedure TForm1.TrackLenChange(Sender: TObject);
begin
   PasswordGenerator.SetLength(TrackLen.Position);
   lPassword.Caption:=PasswordGenerator.GeneratePassword;
end;

end.

