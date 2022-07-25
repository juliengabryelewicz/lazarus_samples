unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    EditorContainer: TMemo;
    FileMenu: TMenuItem;
    CloseItem: TMenuItem;
    AboutItem: TMenuItem;
    OpenFileItem: TMenuItem;
    SaveFileItem: TMenuItem;
    HelpItem: TMenuItem;
    OpenFileDialog: TOpenDialog;
    SaveFileDialog: TSaveDialog;
    procedure AboutItemClick(Sender: TObject);
    procedure CloseItemClick(Sender: TObject);
    procedure OpenFileItemClick(Sender: TObject);
    procedure SaveFileItemClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.OpenFileItemClick(Sender: TObject);
begin
  if OpenFileDialog.Execute then
     EditorContainer.Lines.LoadFromFile(OpenFileDialog.FileName);
end;

procedure TForm1.CloseItemClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.AboutItemClick(Sender: TObject);
begin
  ShowMessage('Éditeur de texte vous permettant de sauvegarder et modifier vos fichiers texte');
end;

procedure TForm1.SaveFileItemClick(Sender: TObject);
begin
  if SaveFileDialog.Execute then
     EditorContainer.Lines.SaveToFile(SaveFileDialog.FileName);
end;

end.

