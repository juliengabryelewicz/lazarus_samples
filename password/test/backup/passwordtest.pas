unit PasswordTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,
  PasswordGenerator in '../src/passwordgenerator.pas';

const
  LC_LETTERS = ['a'..'z'];
  UC_LETTERS = ['A'..'Z'];
  NUMERALS = ['0'..'9'];
  SP_LETTERS = ['!','#','%','$','&','@','?','-','_','|',']',')','(','['];
type

  TTestPassword= class(TTestCase)
  private
    FPasswordGenerator: TPasswordGenerator;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestLowerPassword;
    procedure TestUpperPassword;
    procedure TestNumberPassword;
    procedure TestMixPassword;
    procedure TestMixTwoPassword;
    procedure TestSpacePassword;
    procedure TestSpecialCharPassword;
  end;

implementation

procedure TTestPassword.TestLowerPassword;
var
  Password: string;
begin
  FPasswordGenerator.SetSelected(0,true);
  FPasswordGenerator.SetSelected(1,false);
  FPasswordGenerator.SetSelected(2,false);
  FPasswordGenerator.SetSelected(3,false);
  FPasswordGenerator.SetSelected(4,false);
  FPasswordGenerator.SetLength(12);
  Password:=FPasswordGenerator.GeneratePassword;
  AssertEquals(LowerCase(Password), Password);
end;

procedure TTestPassword.TestUpperPassword;
var
  Password: string;
begin
  FPasswordGenerator.SetSelected(0,false);
  FPasswordGenerator.SetSelected(1,true);
  FPasswordGenerator.SetSelected(2,false);
  FPasswordGenerator.SetSelected(3,false);
  FPasswordGenerator.SetSelected(4,false);
  FPasswordGenerator.SetLength(12);
  Password:=FPasswordGenerator.GeneratePassword;
  AssertEquals(UpperCase(Password), Password);
end;

procedure TTestPassword.TestNumberPassword;
var
  I:Integer;
begin
  FPasswordGenerator.SetSelected(0,false);
  FPasswordGenerator.SetSelected(1,false);
  FPasswordGenerator.SetSelected(2,true);
  FPasswordGenerator.SetSelected(3,false);
  FPasswordGenerator.SetSelected(4,false);
  FPasswordGenerator.SetLength(12);
  if not TryStrToInt(FPasswordGenerator.GeneratePassword, I) then
  begin
     Fail('Invalid number.')
  end;
end;

procedure TTestPassword.TestMixPassword;
var
  c: char;
begin
  FPasswordGenerator.SetSelected(0,true);
  FPasswordGenerator.SetSelected(1,false);
  FPasswordGenerator.SetSelected(2,true);
  FPasswordGenerator.SetSelected(3,false);
  FPasswordGenerator.SetSelected(4,false);
  FPasswordGenerator.SetLength(12);
  for c in FPasswordGenerator.GeneratePassword do
  begin
    if (c in UC_LETTERS) or (c in SP_LETTERS) then
    begin
      Fail('Incorrect character');
    end;
  end;
end;

procedure TTestPassword.TestMixTwoPassword;
var
  c: char;
begin
  FPasswordGenerator.SetSelected(0,false);
  FPasswordGenerator.SetSelected(1,true);
  FPasswordGenerator.SetSelected(2,true);
  FPasswordGenerator.SetSelected(3,false);
  FPasswordGenerator.SetSelected(4,false);
  FPasswordGenerator.SetLength(12);
  for c in FPasswordGenerator.GeneratePassword do
  begin
    if (c in LC_LETTERS) or (c in SP_LETTERS) then
    begin
      Fail('Incorrect character');
    end;
  end;
end;

procedure TTestPassword.TestSpacePassword;
begin
  FPasswordGenerator.SetSelected(0,false);
  FPasswordGenerator.SetSelected(1,false);
  FPasswordGenerator.SetSelected(2,false);
  FPasswordGenerator.SetSelected(3,true);
  FPasswordGenerator.SetSelected(4,false);
  FPasswordGenerator.SetLength(40);
  if pos(' ',FPasswordGenerator.GeneratePassword) <= 0 then
  begin
       Fail('No Space');
  end;
end;

procedure TTestPassword.TestSpecialCharPassword;
var
  c: char;
begin
  FPasswordGenerator.SetSelected(0,false);
  FPasswordGenerator.SetSelected(1,false);
  FPasswordGenerator.SetSelected(2,false);
  FPasswordGenerator.SetSelected(3,false);
  FPasswordGenerator.SetSelected(4,true);
  FPasswordGenerator.SetLength(40);
  for c in FPasswordGenerator.GeneratePassword do
  begin
    if (c in LC_LETTERS) or (c in SP_LETTERS) or (c in NUMERALS) then
    begin
      Fail('Incorrect character');
    end;
  end;
end;

procedure TTestPassword.SetUp;
begin
  FPasswordGenerator:= TPasswordGenerator.Create;
end;

procedure TTestPassword.TearDown;
begin
  FPasswordGenerator.Destroy;
end;

initialization

  RegisterTest(TTestPassword);
end.

