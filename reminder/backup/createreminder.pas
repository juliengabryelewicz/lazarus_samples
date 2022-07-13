unit CreateReminder;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TFormCreation }

  TFormCreation = class(TForm)
    btnAdd: TBitBtn;
    btnCancel: TBitBtn;
    editText: TEdit;
    lText: TLabel;
    lHourSelect: TLabel;
    lMinuteSelect: TLabel;
    lSelectedTime: TLabel;
    lShowSelectedTime: TLabel;
    lsHours: TListBox;
    lsMinutes: TListBox;
    procedure btnAddClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lsHoursSelectionChange(Sender: TObject; User: boolean);
    procedure lsMinutesSelectionChange(Sender: TObject; User: boolean);
  private

  public

  end;

var
  FormCreation: TFormCreation;

implementation

{$R *.lfm}

{ TFormCreation }

procedure TFormCreation.FormShow(Sender: TObject);
var
  parts: TStringArray;
begin

  editText.Text := '';
  parts := FormatDateTime('hh:nn', Time).Split(':');
  lsHours.Selected[StrToInt(parts[0])] := True;
  lsMinutes.Selected[StrToInt(parts[1])] := True;

end;

procedure TFormCreation.btnAddClick(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

procedure TFormCreation.btnCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TFormCreation.lsHoursSelectionChange(Sender: TObject; User: boolean);
begin
  lShowSelectedTime.Caption := lsHours.GetSelectedText + ':' + lsMinutes.GetSelectedText;
end;

procedure TFormCreation.lsMinutesSelectionChange(Sender: TObject; User: boolean);
begin
  lShowSelectedTime.Caption := lsHours.GetSelectedText + ':' + lsMinutes.GetSelectedText;
end;


end.

