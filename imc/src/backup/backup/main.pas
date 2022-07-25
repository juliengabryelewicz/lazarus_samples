unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ImcCalc;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnCalculerImc: TButton;
    EditTaille: TEdit;
    EditPoids: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnCalculerImcClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnCalculerImcClick(Sender: TObject);
var
  MessageErrorTxt: string;
  ImcCalc: TImcCalc;
begin
  MessageErrorTxt:='';

  MessageErrorTxt:= TImcCalc.CheckSize(EditTaille.Text);
  MessageErrorTxt:= MessageErrorTxt+TImcCalc.CheckWeight(EditPoids.Text);

  if MessageErrorTxt <> '' then
  begin
     ShowMessage(MessageErrorTxt);
     exit;
  end;

  ImcCalc:= TImcCalc.Create(StrToFloat(EditTaille.Text), StrToFloat(EditPoids.Text));
  ShowMessage(ImcCalc.CalculateImc());
  ImcCalc.Destroy;
end;

end.

