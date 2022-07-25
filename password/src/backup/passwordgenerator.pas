unit PasswordGenerator;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  SelectedArray = Array [0..4] of Boolean;
  TPasswordGenerator = class
  private
    fSelValues: SelectedArray;
    fLenPassword: Shortint;
  public
    property Selected: SelectedArray read fSelValues;
    procedure SetSelected(SelectedIndex: byte; SelectedValue:Boolean);
    procedure SetLength(LenPassword: Shortint);
    function GeneratePassword: string;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TPasswordGenerator.Create;
begin
     fSelValues[0]:=false;
     fSelValues[1]:=false;
     fSelValues[2]:=false;
     fSelValues[3]:=false;
     fSelValues[4]:=false;
end;

destructor TPasswordGenerator.Destroy;
begin
     inherited Destroy;
end;

procedure TPasswordGenerator.SetSelected(SelectedIndex: byte; SelectedValue:Boolean);
begin
     fSelValues[SelectedIndex]:=SelectedValue;
end;

procedure TPasswordGenerator.SetLength(LenPassword: Shortint);
begin
     fLenPassword:=LenPassword;
end;

function TPasswordGenerator.GeneratePassword: string;
var
  Password, PasswordChars, AddChars: String;
  RandomInt: Integer;
  i: Shortint;
begin
     Password := '';
     PasswordChars := '';
     AddChars := '';
     Randomize;
     For i := 0 to Length(fSelValues) do
     begin
       If fSelValues[i] then
       begin
         Case i of
           0 : AddChars := 'abcdefghijklmnopqrstuvwxyz';
           1 : AddChars := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
           2 : AddChars := '0123456789';
           3 : AddChars := ' ';
           4 : AddChars := '!#%$&@?-_|])([';
         end;
         PasswordChars := PasswordChars + AddChars;
       end;
     end;
     For i := 0 to (fLenPassword - 1) do
     begin
       RandomInt := Random(Length(PasswordChars)) + 1;
       Password := Password + pwdChars[RandomInt];
     end;
     Result := Password;
end;

end.

