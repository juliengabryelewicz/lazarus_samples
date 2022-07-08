unit ImcCalc;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Math;

type

  TImcCalc = class
  private
    fSize: real;
    fWeight: real;
  public
    class function CheckSize(Size: string): string;
    class function CheckWeight(Weight: string): string;
    procedure SetSize(Size: real);
    procedure SetWeight(Weight: real);
    function CalculateImc: string;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TImcCalc.Create;
begin

end;

destructor TImcCalc.Destroy;
begin
     inherited Destroy;
end;

procedure TImcCalc.SetSize(Size: real);
begin
     fSize:=Size;
end;

procedure TImcCalc.SetWeight(Weight: real);
begin
     fWeight:=Weight;
end;

class function TImcCalc.CheckSize(Size: string): string;
var
  MessageTxt:string;
  Flt: Extended;
begin
     MessageTxt:='';
     if not TryStrToFloat(Size,Flt) then
     begin
        MessageTxt:='Vous devez donner une taille au format nombre ';
     end
     else if (StrToFloat(Size) < 50.0) or (StrToFloat(Size) > 300.0) then
     begin
        MessageTxt:='Merci de donner une taille comprise entre 50 et 300 cm ';
     end;

     Result:=MessageTxt;
end;

class function TImcCalc.CheckWeight(Weight: string): string;
var
  MessageTxt:string;
  Flt: Extended;
begin
     MessageTxt:='';
     if not TryStrToFloat(Weight, Flt) then
     begin
        MessageTxt:='Vous devez donner un poids au format nombre';
     end
     else if (StrToFloat(Weight) < 30.0) or (StrToFloat(Weight) > 600.0) then
     begin
        MessageTxt:='Merci de donner un poids compris entre 30 et 600 kg';
     end;

     Result:=MessageTxt;
end;

function TImcCalc.CalculateImc: string;
var
  MessageTxt:string;
  ImcValue:real;
begin
   MessageTxt:='';
   ImcValue:= Self.fWeight/(Power((Self.fSize/100), 2.0));

   if InRange(ImcValue,0.0,18.5) then
   begin
        MessageTxt:='Vous êtes en insuffisance pondérale';
   end
   else if InRange(ImcValue,18.5,25.0) then
   begin
        MessageTxt:='Vous avez une corpulence normale';
   end
   else if InRange(ImcValue,25.0,30.0) then
   begin
        MessageTxt:='Vous avez en surpoids';
   end
   else if InRange(ImcValue,30.0,35.0) then
   begin
        MessageTxt:='Vous êtes en obésité modérée';
   end
   else if InRange(ImcValue,35.0,40.0) then
   begin
        MessageTxt:='Vous êtes en obésité sévère';
   end
   else if InRange(ImcValue,40.0,256.0) then
   begin
        MessageTxt:='Vous êtes en obésité morbide';
   end
   else
   begin
     MessageTxt:='Une erreur a eu lieu dans le calcul. Veuillez vérifier vos valeurs';
   end;

  Result:=MessageTxt;

end;

end.

