unit TestQuotes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,
  fpjson, jsonparser, jsonscanner,
  QuoteRepository in '../src/quoterepository.pas';

type

  TTestQuotes= class(TTestCase)
  private
    JsonContent : TJSONData;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSpecificQuote;
    procedure TestSearchQuote;
    procedure TestRandomQuote;
  end;

implementation

procedure TTestQuotes.TestSpecificQuote;
var
  Quote: TJSONObject;
begin
  Quote:=TQuoteRepository.GetSpecificQuote(2, JsonContent);
  AssertEquals(Quote.Integers['id'], 2);
  Quote:=TQuoteRepository.GetSpecificQuote(4, JsonContent);
  AssertEquals(Quote.Strings['auteur'], 'Nietzche');
end;

procedure TTestQuotes.TestSearchQuote;
var
  QuotesArray : TQuotesArray;
begin
  QuotesArray:=TQuoteRepository.GetSearchQuote('Jules', JsonContent);
  AssertEquals(Length(QuotesArray), 1);
  QuotesArray:=TQuoteRepository.GetSearchQuote('jules', JsonContent);
  AssertEquals(Length(QuotesArray), 1);
  QuotesArray:=TQuoteRepository.GetSearchQuote('anticonstituonellement', JsonContent);
  AssertEquals(Length(QuotesArray), 0);
end;

procedure TTestQuotes.TestRandomQuote;
var
  Quote: TJSONObject;
begin
  Quote:=TQuoteRepository.GetRandomQuote(JsonContent);
  if (Quote.integers['id'] < 1) or (Quote.integers['id'] > 8) then
  begin
    Fail('id incorrect');
  end;
end;

procedure TTestQuotes.SetUp;
var
  Flux : TFileStream;
  Parseur : TJSONParser;
begin
  Flux := TFileStream.Create('citations_test.json', fmopenRead);
  try
    Parseur := TJSONParser.Create(Flux, [joUTF8,joStrict,joComments,joIgnoreTrailingComma]);
    JsonContent := Parseur.Parse;
  finally
    FreeAndNil(Parseur);
    Flux.Destroy;
  end;
end;

procedure TTestQuotes.TearDown;
begin
end;

initialization

  RegisterTest(TTestQuotes);
end.

