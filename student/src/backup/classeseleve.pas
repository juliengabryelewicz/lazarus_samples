unit ClassesEleve;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, DBCtrls,
  StdCtrls, DataAccess;

type

  { TClassesForm }

  TClassesForm = class(TForm)
    btnAnnuler: TButton;
    btnEnregistrer: TButton;
    dbeNom: TDBEdit;
    dbgClasses: TDBGrid;
    dbnClasses: TDBNavigator;
    lNom: TLabel;
    procedure btnAnnulerClick(Sender: TObject);
    procedure btnEnregistrerClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
  strict private
      FEnregistre : Boolean;
  private
      procedure SetEnregistre (AValue : Boolean);
  public
      property Enregistre : Boolean read FEnregistre write SetEnregistre;
  end;

var
  ClassesForm: TClassesForm;

implementation

{$R *.lfm}

{ TClassesForm }

procedure TClassesForm.FormShow(Sender: TObject);
begin
  Enregistre := False;
  DataModule1.ChargementClasses;
end;

procedure TClassesForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
(* Demande de confirmation de fermeture sans enregistrer *)
begin
  if Enregistre
     then
       CanClose := True
     else
       CanClose := (MessageDlg('Voulez-vous fermer sans enregistrer ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
end;

procedure TClassesForm.btnEnregistrerClick(Sender: TObject);
begin
  Enregistre := DataModule1.SauvegardeClasses;
  Close;
end;

procedure TClassesForm.btnAnnulerClick(Sender: TObject);
begin
  Close;
end;

procedure TClassesForm.SetEnregistre(AValue: Boolean);
begin
  if FEnregistre = AValue
     then
       Exit;
  FEnregistre := AValue;
end;

end.

