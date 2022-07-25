program testpassword;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, PasswordTest;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

