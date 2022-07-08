unit testimccalc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, ImcCalc;

type

  TTestImcCalc= class(TTestCase)
  private
    FImcCalc: TImcCalc;
  published
    procedure CheckSize;
    procedure CheckWeight;
    procedure CalculateImc;
  end;

implementation

procedure  TTestImcCalc.CheckSize;
begin
  AssertEquals(FImcCalc.CheckSize(''), 'Vous devez donner une taille au format nombre ');
  AssertEquals(FImcCalc.CheckSize('test'), 'Vous devez donner une taille au format nombre ');
  AssertEquals(FImcCalc.CheckSize('120cm'), 'Vous devez donner une taille au format nombre ');
  AssertEquals(FImcCalc.CheckSize('35'), 'Merci de donner une taille comprise entre 50 et 300 cm ');
  AssertEquals(FImcCalc.CheckSize('350'), 'Merci de donner une taille comprise entre 50 et 300 cm ');
  AssertEquals(FImcCalc.CheckSize('120'), '');
end;

procedure  TTestImcCalc.CheckWeight;
begin
  AssertEquals(FImcCalc.CheckWeight(''), 'Vous devez donner un poids au format nombre');
  AssertEquals(FImcCalc.CheckWeight('test'), 'Vous devez donner un poids au format nombre';
  AssertEquals(FImcCalc.CheckWeight('120kg'), 'Vous devez donner un poids au format nombre');
  AssertEquals(FImcCalc.CheckWeight('15'), 'Merci de donner un poids compris entre 30 et 600 kg');
  AssertEquals(FImcCalc.CheckWeight('650'), 'Merci de donner un poids compris entre 30 et 600 kg');
  AssertEquals(FImcCalc.CheckWeight('120'), '');
end;

initialization

  RegisterTest(TTestImcCalc);
end.

