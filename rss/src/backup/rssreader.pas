unit RssReader;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, opensslsockets;

const
  RSS_LIST : array of string = ('https://www.challenges.fr/rss.xml','https://www.historia.fr/flux-rss.xml','https://www.jeuxvideo.com/rss/rss.xml','https://www.lexpress.fr/rss/alaune.xml','https://www.lefigaro.fr/rss/figaro_actualites.xml','https://www.lemonde.fr/rss/une.xml','https://www.marianne.net/rss.xml');

type
  TRssReader = class
  private
  public
    function GetRssContent(index: Integer): string;
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

  function TRssReader.GetRssContent(index: Integer): string;
  var
      httpclient: TFPHTTPClient;
      xml : String;
  begin
       httpclient := TFPHttpClient.Create(Nil);
       try
         xml := httpclient.SimpleGet(link);
       finally
         httpclient.Free;
       end;
       Result:=xml;
  end;

end.

