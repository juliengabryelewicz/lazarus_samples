unit testimccalc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, ImcCalc;

type

  TTestImcCalc= class(TTestCase)
  private
    FImcCalc: TImcCalc;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure CheckSize;
    procedure CheckWeight;
    procedure CalculateImc;
  end;

implementation

procedure TTestImcCalc.SetUp;
begin
  FImcCalc:= TImcCalc.Create;
end;

procedure TTestImcCalc.TearDown;
begin
  FImcCalc.Destroy;
end;

procedure  TTestImcCalc.CheckSize;
begin
  AssertEquals(TImcCalc.CheckSize(''), 'Vous devez donner une taille au format nombre');
  AssertEquals(TImcCalc.CheckSize('test'), 'Vous devez donner une taille au format nombre');
  AssertEquals(TImcCalc.CheckSize('120cm'), 'Vous devez donner une taille au format nombre');
  AssertEquals(TImcCalc.CheckSize('35'), 'Merci de donner une taille comprise entre 50 et 300 cm');
  AssertEquals(TImcCalc.CheckSize('350'), 'Merci de donner une taille comprise entre 50 et 300 cm');
  AssertEquals(TImcCalc.CheckSize('120'), '');
end;

procedure  TTestImcCalc.CheckWeight;
begin
  AssertEquals(TImcCalc.CheckWeight(''), 'Vous devez donner un poids au format nombre');
  AssertEquals(TImcCalc.CheckWeight('test'), 'Vous devez donner un poids au format nombre');
  AssertEquals(TImcCalc.CheckWeight('120kg'), 'Vous devez donner un poids au format nombre');
  AssertEquals(TImcCalc.CheckWeight('15'), 'Merci de donner un poids compris entre 30 et 600 kg');
  AssertEquals(TImcCalc.CheckWeight('650'), 'Merci de donner un poids compris entre 30 et 600 kg');
  AssertEquals(TImcCalc.CheckWeight('120'), '');
end;

procedure  TTestImcCalc.CalculateImc;
begin
  FImcCalc.Size:=180.0;
  FImcCalc.Weight:=45.0;
  AssertEquals(FImcCalc.CalculateImc(), 'Vous êtes en insuffisance pondérale');

  FImcCalc.Weight:=75.0;
  AssertEquals(FImcCalc.CalculateImc(), 'Vous avez une corpulence normale');

  FImcCalc.Weight:=90.0;
  AssertEquals(FImcCalc.CalculateImc(), 'Vous avez en surpoids');

  FImcCalc.Weight:=110.0;
  AssertEquals(FImcCalc.CalculateImc(), 'Vous êtes en obésité modérée');

  FImcCalc.Weight:=120.0;
  AssertEquals(FImcCalc.CalculateImc(), 'Vous êtes en obésité sévère');

  FImcCalc.Weight:=245.0;
  AssertEquals(FImcCalc.CalculateImc(), 'Vous êtes en obésité morbide');

  FImcCalc.Weight:=1000000000.0;
  AssertEquals(FImcCalc.CalculateImc(), 'Une erreur a eu lieu dans le calcul. Veuillez vérifier vos valeurs');
end;

initialization

  RegisterTest(TTestImcCalc);
end.

