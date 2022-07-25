unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls, NewsRepository, RssReader;

type

  { TForm1 }

  TForm1 = class(TForm)
    cbRss: TComboBox;
    lTitle: TLabel;
    lDate: TLabel;
    lDescription: TLabel;
    lTtitleNews: TLabel;
    ListNews: TListBox;
    procedure cbRssSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListNewsSelectionChange(Sender: TObject; User: boolean);
  private
    procedure CleanElements;
  public
      NewsRepository: TNewsRepository;
      RssReader: TRssReader;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.cbRssSelect(Sender: TObject);
var
  newsList: array of TNews;
  newsSize, i : LongWord;
  xmlRss: string;
begin
    Self.CleanElements;
    try
       xmlRss:=RssReader.ChangeRss(cbRss.ItemIndex);
       NewsRepository.FillNews(xmlRss);
    except
    on e: exception do
      begin
           Writeln('Une erreur est apparue : ' + e.Message);
      end;
    end;
    newsList:=NewsRepository.GetAllNews();
    newsSize:= Length(newsList);
    if newsSize=0 then
    begin
      ShowMessage('Aucune nouvelle trouvée');
    end;

    for i:=0 to newsSize-1 do
    begin
        ListNews.Items.Add(newsList[i].title);
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    NewsRepository:= TNewsRepository.Create;
    RssReader:= TRssReader.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     NewsRepository.Destroy;
     RssReader.Destroy;
end;

procedure TForm1.ListNewsSelectionChange(Sender: TObject; User: boolean);
var
  news: TNews;
begin
      news:=NewsRepository.GetNews(ListNews.ItemIndex);
      lTitle.Caption:=news.title;
      lDate.Caption:=news.pubdate;
      lDescription.Caption:=news.description;
end;

procedure TForm1.CleanElements;
begin
     lTitle.Caption:='';
     lDate.Caption:='';
     lDescription.Caption:='';
     ListNews.Items.Clear;
     ListNews.ItemIndex:=-1;
end;

end.

