unit Matieres;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, DBCtrls,
  StdCtrls, DataAccess, SQL;

type

  { TMatieresForm }

  TMatieresForm = class(TForm)
    btnAnnuler: TButton;
    btnEnregistrer: TButton;
    dbeNom: TDBEdit;
    dbgMatieres: TDBGrid;
    dbnMatieres: TDBNavigator;
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
  MatieresForm: TMatieresForm;

implementation

{$R *.lfm}

{ TMatieresForm }

procedure TMatieresForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
(* Demande de confirmation de fermeture sans enregistrer *)
begin
  if Enregistre
     then
       CanClose := True
     else
       CanClose := (MessageDlg('Voulez-vous fermer sans enregistrer ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
end;

procedure TMatieresForm.btnAnnulerClick(Sender: TObject);
begin
  Close;
end;

procedure TMatieresForm.btnEnregistrerClick(Sender: TObject);
begin
  Enregistre := DataModule1.SauvegardeMatieres;
  Close;
end;

procedure TMatieresForm.FormShow(Sender: TObject);
begin
  Enregistre := False;
  DataModule1.ChargementMatieres;
end;

procedure TMatieresForm.SetEnregistre(AValue: Boolean);
begin
  if FEnregistre = AValue
     then
       Exit;
  FEnregistre := AValue;
end;

end.

