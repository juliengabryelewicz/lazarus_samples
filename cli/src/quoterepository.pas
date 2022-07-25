unit QuoteRepository;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, jsonscanner;

type
  TQuotesArray = array of TJSONObject;
  TQuoteRepository = class
    public
      class function GetSpecificQuote(Id:integer;JsonData:TJSONData): TJSONObject; virtual;
      class function GetRandomQuote(JsonData:TJSONData): TJSONObject; virtual;
      class function GetSearchQuote(Search: string; JsonData:TJSONData): TQuotesArray; virtual;
  end;

implementation

class function TQuoteRepository.GetSpecificQuote(Id: integer; JsonData:TJSONData): TJSONObject;
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

class function TQuoteRepository.GetRandomQuote(JsonData:TJSONData): TJSONObject;
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

class function TQuoteRepository.GetSearchQuote(Search: string; JsonData:TJSONData): TQuotesArray;
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

end.

