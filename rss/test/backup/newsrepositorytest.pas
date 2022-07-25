unit NewsRepositoryTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,
  NewsRepository in '../src/newsrepository.pas';

const

  RSS_CONTENT = '<?xml version="1.0" encoding="UTF-8"?><rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:content="http://purl.org/rss/1.0/modules/content/"><channel><title>Jeu de test</title><item><title><![CDATA[Mon premier titre]]></title><pubDate>Mon, 25 Jul 2022 13:59:54 +0200</pubDate><description><![CDATA[Contenu de mon premier titre]]></description></item><item><title><![CDATA[Mon deuxième titre]]></title><pubDate>Mon, 25 Jul 2022 13:59:54 +0200</pubDate><description><![CDATA[Contenu de mon deuxième titre]]></description></item><item><title><![CDATA[Mon troisième titre]]></title><pubDate>Mon, 25 Jul 2022 13:59:54 +0200</pubDate><description><![CDATA[Contenu de mon troisième titre]]></description></item></channel></rss>';

type

  TTestNewsRepository= class(TTestCase)
  private
    FnewsRepository: TNewsRepository;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestGetAllNews;
    procedure TestGetNews;
  end;

implementation

procedure TTestNewsRepository.TestGetAllNews;
var
  newsList: array of TNews;
begin
  newsList:=FnewsRepository.GetAllNews();
  AssertEquals(Length(newsList), 3);
  AssertEquals(newsList[1].title, 'Mon deuxième titre');
end;

procedure TTestNewsRepository.TestGetNews;
var
  news: TNews;
begin
  news:=FnewsRepository.GetNews(0);
  AssertEquals(news.title, 'Mon premier titre');
  news:=FnewsRepository.GetNews(1);
  AssertEquals(news.pubdate, 'Mon, 25 Jul 2022 13:59:54 +0200');
  news:=FnewsRepository.GetNews(2);
  AssertEquals(news.pubdate, 'Mon, 25 Jul 2022 13:59:54 +0200');
end;

procedure TTestNewsRepository.SetUp;
begin
     FnewsRepository:= TNewsRepository.Create;
     FnewsRepository.FillNews(RSS_CONTENT);
end;

procedure TTestNewsRepository.TearDown;
begin
     FnewsRepository.Destroy;
end;

initialization

  RegisterTest(TTestNewsRepository);
end.

