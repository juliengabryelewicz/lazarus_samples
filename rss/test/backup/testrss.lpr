program testrss;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, RssTest;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

