program imctest;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, testimccalc;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

