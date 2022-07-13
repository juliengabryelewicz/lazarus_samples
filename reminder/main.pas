unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls,
  ExtCtrls, CreateReminder;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnAdd: TBitBtn;
    btnRemove: TBitBtn;
    lsReminders: TListBox;
    TimerRemind: TTimer;
    TrayIcon1: TTrayIcon;
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure TimerRemindTimer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.TimerRemindTimer(Sender: TObject);
var
  i: Integer;
  TimeStamp: string;
  ReminderData: TStringArray;
begin
  TimeStamp := FormatDateTime('hh:nn', Time);
  for i := 0 to lsReminders.Items.Count - 1 do
  begin
    if i < lsReminders.Items.Count then
    begin
      ReminderData := lsReminders.Items[i].Split('-');
      if Trim(ReminderData[0]) = TimeStamp then
      begin
        ShowMessage('Attention!' + 'Il est : ' + ReminderData[0] + sLineBreak + 'Rappel: ' + ReminderData[1]);
      end;
    end;
  end;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  WindowState := wsNormal;
  Visible := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  If FileExists(Application.Location + DirectorySeparator + 'reminderlist.dat') Then
     lsReminders.Items.LoadFromFile(Application.Location + DirectorySeparator + 'reminderlist.dat');
  TimerRemindTimer(Sender);
end;

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
  Visible := not (WindowState = wsMinimized);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  lsReminders.Items.SaveToFile(Application.Location + DirectorySeparator + 'reminderlist.dat');
end;

procedure TForm1.btnAddClick(Sender: TObject);
begin
    if FormCreation.ShowModal = mrOK then
    begin
      lsReminders.Items.Add(FormCreation.lsHours.GetSelectedText + ':'+ FormCreation.lsMinutes.GetSelectedText + ' - ' + FormCreation.editText.Text);
    end;
end;

procedure TForm1.btnRemoveClick(Sender: TObject);
begin
  lsReminders.DeleteSelected;
end;

end.

