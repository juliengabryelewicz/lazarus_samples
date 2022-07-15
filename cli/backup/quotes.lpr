program quotes;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this }, fpjson, jsonparser, jsonscanner;

type

  { TQuotes }

  TQuotes = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
    procedure WriteSpecificQuote(Id:integer;JsonData:TJSONData); virtual;
    procedure WriteRandomQuote(JsonData:TJSONData); virtual;
    procedure WriteSearchQuote(Search: string; JsonData:TJSONData); virtual;
  end;

{ TQuotes }

procedure TQuotes.DoRun;
var
  Flux : TFileStream;
  Parseur : TJSONParser;
  JsonData : TJSONData;
  ErrorMsg: String;
begin
  Flux := TFileStream.Create('citations.json', fmopenRead);
  try
    Parseur := TJSONParser.Create(Flux, [joUTF8,joStrict,joComments,joIgnoreTrailingComma]);
    JsonData := Parseur.Parse;
    try

      if HasOption('h', 'help') then
      begin
        WriteHelp;
        Terminate;
        Exit;
      end
      else if HasOption('i','id') then
      begin
        WriteSpecificQuote(StrToInt(GetOptionValue('i','id')), JsonData);
        Terminate;
        Exit;
      end
      else if HasOption('s','search') then
      begin
        WriteSearchQuote(GetOptionValue('s','search'), JsonData);
        Terminate;
        Exit;
      end
      else
      begin
        WriteRandomQuote(JsonData);
        Terminate;
        Exit;
      end;
    finally
      FreeAndNil(JsonData);
      FreeAndNil(Parseur);
    end;
  finally
    Flux.Destroy;
  end;

  Terminate;
end;

constructor TQuotes.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TQuotes.Destroy;
begin
  inherited Destroy;
end;

procedure TQuotes.WriteHelp;
begin
  writeln('Aide: -h ou --help');
  writeln('Chercher une citation spécifique par son identifiant: -i ou --id');
  writeln('Rechercher par mot-clé: -s ou --search');
  writeln('Ne rien mettre pour avoir une citation aléatoire');
end;

procedure TQuotes.WriteSpecificQuote(Id: integer; JsonData:TJSONData);
var
  quote, quotes : TJSONObject;
  tab : TJSONArray;
  i : integer;
begin
  quotes := TJSONObject(JsonData);
  tab:=quotes.Arrays['citations'];
  for i:=0 to tab.Count-1 do
  begin
   quote:= tab.Objects[i];
   if quote.Integers['id'] = Id then
   begin
     writeln(UTF8Encode(quote.Strings['citation']));
     writeln('Auteur : '+UTF8Encode(quote.Strings['auteur']));
   end;
  end;
end;

procedure TQuotes.WriteRandomQuote(JsonData:TJSONData);
var
  quote, quotes : TJSONObject;
  tab : TJSONArray;
  i : integer;
begin
  Randomize;
  quotes := TJSONObject(JsonData);
  tab:=quotes.Arrays['citations'];
  i:=Random(quotes.Arrays['citations'].Count);
  quote:= tab.Objects[i];
  writeln(UTF8Encode(quote.Strings['citation']));
  writeln('Auteur : '+UTF8Encode(quote.Strings['auteur']));
end;

procedure TQuotes.WriteSearchQuote(Search: string; JsonData:TJSONData);
var
  quote, quotes : TJSONObject;
  tab : TJSONArray;
  i : integer;
begin
  quotes := TJSONObject(JsonData);
  tab:=quotes.Arrays['citations'];
  for i:=0 to tab.Count-1 do
  begin
   quote:= tab.Objects[i];
   if (pos(Search, quote.Strings['citation']) <> 0) or (pos(Search, quote.Strings['auteur']) <> 0) then
   begin
     writeln(UTF8Encode(quote.Strings['citation']));
     writeln('Auteur : '+UTF8Encode(quote.Strings['auteur']));
   end;
  end;
end;

var
  Application: TQuotes;
begin
  Application:=TQuotes.Create(nil);
  Application.Title:='Citations';
  Application.Run;
  Application.Free;
end.

