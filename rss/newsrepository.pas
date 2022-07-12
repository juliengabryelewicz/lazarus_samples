unit NewsRepository;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Dom, XMLRead;

const
  RSS_ITEM = 'item';
  RSS_TITLE = 'title';
  RSS_DESCRIPTION = 'description';
  RSS_PUBDATE = 'pubdate';

type
  TNews = record
  	title,description, pubdate : string;
  end;
  NewsArray = array of TNews;
  TNewsRepository = class
  private
    news : array of TNews;
  public
    procedure FillNews(xml: string);
    function GetAllNews: NewsArray;
    function GetNews(index: LongInt): TNews;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

  constructor TNewsRepository.Create;
  begin

  end;

  destructor TNewsRepository.Destroy;
  begin
       inherited Destroy;
  end;

  function TNewsRepository.GetAllNews: NewsArray;
  begin
       Result:=Self.news;
  end;

  function TNewsRepository.GetNews(index: LongInt): TNews;
  begin
       Result:=Self.news[index];
  end;

  procedure TNewsRepository.FillNews(xml: string);
  var
      stream : TStringStream;
      content : TXMLDocument;
      rootNews : TDOMElement;
      listNews, lst : TDOMNodeList;
      sizeNews, etaille, i, j : LongWord;
      elementNews : TNews;
  begin
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

