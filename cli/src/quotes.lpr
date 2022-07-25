program quotes;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this }, fpjson, jsonparser, jsonscanner, QuoteRepository;

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
        Quote:=TQuoteRepository.GetSpecificQuote(StrToInt(GetOptionValue('i','id')), JsonData);
        WriteQuote(Quote);
        Terminate;
        Exit;
      end
      else if HasOption('s','search') then
      begin
        QuotesArray:=TQuoteRepository.GetSearchQuote(GetOptionValue('s','search'), JsonData);
        for i:=0 to Length(QuotesArray)-1 do
        begin
          WriteQuote(QuotesArray[i]);
        end;
        Terminate;
        Exit;
      end
      else if HasOption('r','random') then
      begin
        Quote:=TQuoteRepository.GetRandomQuote(JsonData);
        WriteQuote(Quote);
        Terminate;
        Exit;
      end
      else
      begin
       WriteHelp;
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
  writeln('Citation aléatoire : -r ou --random');
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

