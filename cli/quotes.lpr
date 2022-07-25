program quotes;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this }, fpjson, jsonparser, jsonscanner;

type

  TQuotesArray = array of TJSONObject;
  { TQuotes }

  TQuotes = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
    function GetSpecificQuote(Id:integer;JsonData:TJSONData): TJSONObject; virtual;
    function GetRandomQuote(JsonData:TJSONData): TJSONObject; virtual;
    function GetSearchQuote(Search: string; JsonData:TJSONData): TQuotesArray; virtual;
    procedure WriteQuote(Quote: TJSONObject); virtual;
  end;

{ TQuotes }

procedure TQuotes.DoRun;
var
  Flux : TFileStream;
  Parseur : TJSONParser;
  JsonData : TJSONData;
  ErrorMsg: String;
  Quote: TJSONObject;
  QuotesArray : TQuotesArray;
  i : Integer;
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
        Quote:=GetSpecificQuote(StrToInt(GetOptionValue('i','id')), JsonData);
        WriteQuote(Quote);
        Terminate;
        Exit;
      end
      else if HasOption('s','search') then
      begin
        QuotesArray:=GetSearchQuote(GetOptionValue('s','search'), JsonData);
        for i:=0 to Length(QuotesArray)-1 do
        begin
          WriteQuote(QuotesArray[i]);
        end;
        Terminate;
        Exit;
      end
      else
      begin
        Quote:=GetRandomQuote(JsonData);
        WriteQuote(Quote);
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
  writeln('Chercher une citation spécifique par son identifiant: -i ou --id');
  writeln('Rechercher par mot-clé: -s ou --search');
  writeln('Ne rien mettre pour avoir une citation aléatoire');
end;

function TQuotes.GetSpecificQuote(Id: integer; JsonData:TJSONData): TJSONObject;
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
     Result:=quote;
   end;
  end;
end;

function TQuotes.GetRandomQuote(JsonData:TJSONData): TJSONObject;
var
  quotes : TJSONObject;
  tab : TJSONArray;
  i : integer;
begin
  Randomize;
  quotes := TJSONObject(JsonData);
  tab:=quotes.Arrays['citations'];
  i:=Random(quotes.Arrays['citations'].Count);
  Result:= tab.Objects[i];
end;

function TQuotes.GetSearchQuote(Search: string; JsonData:TJSONData): TQuotesArray;
var
  quote, quotes : TJSONObject;
  tab : TJSONArray;
  i, j : integer;
  quotesArray : TQuotesArray;
begin
  quotes := TJSONObject(JsonData);
  tab:=quotes.Arrays['citations'];
  j:=0;
  SetLength(quotesArray,tab.Count);
  for i:=0 to tab.Count-1 do
  begin
   quote:= tab.Objects[i];
   if (pos(LowerCase(Search), LowerCase(quote.Strings['citation'])) <> 0) or (pos(LowerCase(Search), LowerCase(quote.Strings['auteur'])) <> 0) then
   begin
     quotesArray[j]:=quote;
     j:=j+1;
   end;
  end;
  SetLength(quotesArray,j);
  Result:=quotesArray;
end;

procedure TQuotes.WriteQuote(Quote: TJSONObject);
begin
  writeln(UTF8Encode(Quote.Strings['citation']));
  writeln('Auteur : '+UTF8Encode(Quote.Strings['auteur']));
end;

var
  Application: TQuotes;
begin
  Application:=TQuotes.Create(nil);
  Application.Title:='Citations';
  Application.Run;
  Application.Free;
end.

