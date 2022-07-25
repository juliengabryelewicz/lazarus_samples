unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ImcCalc;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnCalculerImc: TButton;
    EditSize: TEdit;
    EditWeight: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnCalculerImcClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  public
    ImcCalc: TImcCalc;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnCalculerImcClick(Sender: TObject);
var
  MessageErrorTxt: string;
begin
  MessageErrorTxt:='';

  MessageErrorTxt:= TImcCalc.CheckSize(EditSize.Text);
  MessageErrorTxt:= MessageErrorTxt+TImcCalc.CheckWeight(EditWeight.Text);

  if MessageErrorTxt <> '' then
  begin
     ShowMessage(MessageErrorTxt);
     exit;
  end;

  ImcCalc.Size:=StrToFloat(EditSize.Text);
  ImcCalc.Weight:=StrToFloat(EditWeight.Text);

  ShowMessage(ImcCalc.CalculateImc());

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ImcCalc:= TImcCalc.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ImcCalc.Destroy;
end;

end.

