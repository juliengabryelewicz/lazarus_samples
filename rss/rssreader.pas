unit RssReader;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Dom, XMLRead, fphttpclient, opensslsockets;

const
  RSS_LIST : array of string = ('https://www.challenges.fr/rss.xml','https://www.historia.fr/flux-rss.xml','https://www.jeuxvideo.com/rss/rss.xml','https://www.lexpress.fr/rss/alaune.xml','https://www.lefigaro.fr/rss/figaro_actualites.xml','https://www.lemonde.fr/rss/une.xml','https://www.marianne.net/rss.xml');
  RSS_ITEM = 'item';
  RSS_TITLE = 'title';
  RSS_DESCRIPTION = 'description';
  RSS_PUBDATE = 'pubdate';

type
  TNews = record
  	title,description, pubdate : string;
  end;
  NewsArray = array of TNews;
  TRssReader = class
  private
    news : array of TNews;
    procedure FillNews(link: string);
  public
    procedure ChangeRss(index: Integer);
    function GetAllNews: NewsArray;
    function GetNews(index: LongInt): TNews;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

  constructor TRssReader.Create;
  begin

  end;

  destructor TRssReader.Destroy;
  begin
       inherited Destroy;
  end;

  function TRssReader.GetAllNews: NewsArray;
  begin
       Result:=Self.news;
  end;

  function TRssReader.GetNews(index: LongInt): TNews;
  begin
       Result:=Self.news[index];
  end;

  procedure TRssReader.ChangeRss(index: Integer);
  begin
       Self.FillNews(RSS_LIST[index]);
  end;

  procedure TRssReader.FillNews(link: string);
  var
      httpclient: TFPHTTPClient;
      xml : String;
      stream : TStringStream;
      content : TXMLDocument;
      rootNews : TDOMElement;
      listNews, lst : TDOMNodeList;
      sizeNews, etaille, i, j : LongWord;
      elementNews : TNews;
  begin
       httpclient := TFPHttpClient.Create(Nil);
       try
         xml := httpclient.SimpleGet(link);
       finally
         httpclient.Free;
       end;
       stream:= TStringStream.Create(xml);
       ReadXMLFile(content,stream);
       stream.Free;
       rootNews:=content.DocumentElement;
       listNews:=rootNews.GetElementsByTagName(RSS_ITEM);
       sizeNews:= listNews.Count;
       SetLength(Self.news,sizeNews);
       for i:=0 to sizeNews-1 do
         begin
          lst:=listNews.Item[i].GetChildNodes;
          etaille := lst.count;
          for j:=0 to etaille-1 do
          begin
           case LowerCase(lst.item[j].nodeName) of
              RSS_TITLE : elementNews.title:=UTF8Decode(lst.item[j].TextContent);
              RSS_DESCRIPTION: elementNews.description:=UTF8Decode(lst.item[j].TextContent);
              RSS_PUBDATE: elementNews.pubdate:=UTF8Decode(lst.item[j].TextContent);
           end;
          end;
          Self.news[i] := elementNews;
         end;
  end;

end.

