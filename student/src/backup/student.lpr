program student;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Main, DataAccess, ClassesEleve, Matieres, SQL
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TClassesForm, ClassesForm);
  Application.CreateForm(TMatieresForm, MatieresForm);
  Application.CreateForm(TNewEleveForm, NewEleveForm);
  Application.Run;
end.

