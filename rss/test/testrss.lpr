program testrss;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, RssTest, NewsRepositoryTest;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

