unit RssTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,
  RssReader in '../src/rssreader.pas';

type

  TTestRss= class(TTestCase)
  private
    FrssReader: TRssReader;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestGetRssContent;
  end;

implementation

procedure TTestRss.TestGetRssContent;
var
  xmlRss: string;
begin
  try
    xmlRss:=FrssReader.GetRssContent(0);
    if xmlRss='' then
    begin
      Fail('Content must not be empty');
    end;
  except
  on e: exception do
    begin
         Fail('Error during connection and rss reception');
    end;
  end;
end;

procedure TTestRss.SetUp;
begin
     FrssReader:= TRssReader.Create;
end;

procedure TTestRss.TearDown;
begin
     FrssReader.Destroy;
end;

initialization

  RegisterTest(TTestRss);
end.

