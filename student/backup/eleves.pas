unit Eleves;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn, DataAccess, SQL;

type

  { TNewEleveForm }

  TNewEleveForm = class(TForm)
    btnAnnuler: TButton;
    btnEnregistrer: TButton;
    cbClasses: TComboBox;
    deDateNaissance: TDateEdit;
    edPrenom: TEdit;
    edNom: TEdit;
    lCommentary: TLabel;
    lClasse: TLabel;
    lPrenom: TLabel;
    lNom: TLabel;
    lDateNaissance: TLabel;
    mCommentaire: TMemo;
    procedure btnAnnulerClick(Sender: TObject);
    procedure btnEnregistrerClick(Sender: TObject);
    procedure cbClassesChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
  strict private
    FEnregistre : Boolean;
    FIndexClasse : Integer;
  private
     procedure SetEnregistre (AValue : Boolean);
     procedure SetIndexClasse (AValue : Integer);
     function VerifFields : Boolean;
  public
     property Enregistre : Boolean read FEnregistre write SetEnregistre;
     property IndexClasse : Integer read FIndexClasse write SetIndexClasse;
  end;

  TUpdateEleveForm = class(TNewEleveForm)
      procedure FormShow(Sender: TObject);
      procedure btnEnregistrerClick(Sender: TObject);
  strict private
    FEleveAModifier : TEleve;
  private
    procedure SetEleveAModifier (AValue : TEleve);
  public
    property EleveAModifier : TEleve read FEleveAModifier write SetEleveAModifier;
  end;

var
  NewEleveForm: TNewEleveForm;

implementation

{$R *.lfm}

{ TUpdateEleveForm }

procedure TUpdateEleveForm.SetEleveAModifier (AValue : TEleve);
(* Setter de la location à modifier *)
begin
  if FEleveAModifier = AValue
     then
       Exit;
  FEleveAModifier := AValue;
end;

procedure TUpdateEleveForm.FormShow(Sender: TObject);
(* Initialisation des contrôles *)
var
  Li : Integer;        (* Indice dans une combobox *)
  LTrouve : Boolean;   (* classe à modifier trouvé dans sa combobox *)
begin
  (* Initialisation par défaut des contrôles *)
  inherited FormShow(Sender);
  (* Adaptation des contrôles aux données à modifier *)
  deDateNaissance.Date := EleveAModifier.DateNaissance;
  edNom.Text := EleveAModifier.Nom;
  edPrenom.Text := EleveAModifier.Prenom;
  mCommentaire.Text := EleveAModifier.Commentaire;
  LTrouve := False;
  Li := 0;
  while (Li < cbClasses.Items.Count) and not LTrouve do
    if TCBClasse(cbClasses.Items.Objects[Li]).IdClasse = EleveAModifier.IdClasse
       then
         begin
           cbClasses.ItemIndex := Li;
           LTrouve := True;
         end
       else
         Inc(Li);
end;

procedure TUpdateEleveForm.btnEnregistrerClick(Sender: TObject);
begin
  if VerifFields then
  begin
        Enregistre := DataModule1.SauvegardeEleves(MySQLSyntax.ModificationEleve(
                EleveAModifier.IdEleve, TCBClasse(cbClasses.Items.Objects[cbClasses.ItemIndex]).IdClasse,
                edPrenom.Text, edNom.Text, deDateNaissance.Date, mCommentaire.Text));
        Close;
  end;
end;

{ TNewEleveForm }

procedure TNewEleveForm.FormShow(Sender: TObject);
begin
  Enregistre := False;
  DataModule1.ChargementCBClasses(cbClasses);
  IndexClasse := 0;
  cbClasses.ItemIndex := IndexClasse;
end;

procedure TNewEleveForm.SetEnregistre (AValue : Boolean);
(* Setter de la propriété Enregistre *)
begin
  if FEnregistre = AValue
     then
       Exit;
  FEnregistre := AValue;
end;

procedure TNewEleveForm.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
var
  Li : Integer;
begin
  for Li := 0 to (cbClasses.Items.Count - 1) do
    TCBClasse(cbClasses.Items.Objects[Li]).Free;
end;

procedure TNewEleveForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    if Enregistre
     then
       CanClose := True
     else
       CanClose := (MessageDlg('Voulez-vous fermer sans enregistrer ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
end;

procedure TNewEleveForm.cbClassesChange(Sender: TObject);
begin
  IndexClasse := cbClasses.ItemIndex;
end;

procedure TNewEleveForm.btnEnregistrerClick(Sender: TObject);
begin
  if VerifFields then
  begin
    Enregistre := DataModule1.SauvegardeEleves(MySQLSyntax.InsertionEleve(
                  TCBClasse(cbClasses.Items.Objects[cbClasses.ItemIndex]).IdClasse,
                  edPrenom.Text, edNom.Text, deDateNaissance.Date, mCommentaire.Text));
    Close;
  end;
end;

procedure TNewEleveForm.btnAnnulerClick(Sender: TObject);
(* Fermeture du dialogue *)
begin
  Close;
end;

procedure TNewEleveForm.SetIndexClasse(AValue : Integer);
(* Setter de la propriété IndexClasse *)
begin
  if FIndexClasse = AValue
     then
       Exit;
  FIndexClasse := AValue;
end;

function TNewEleveForm.VerifFields : Boolean;
begin
  if Trim(edPrenom.Text) = '' then
  begin
    ShowMessage('Le prénom est obligatoire');
    edPrenom.SetFocus;
    Result:=False;
  end
  else if Trim(edNom.text) = '' then
  begin
    ShowMessage('Le nom est obligatoire');
    edNom.SetFocus;
    Result:=False;
  end
  else if Trim(deDateNaissance.text) = '' then
  begin
    ShowMessage('La date de naissance est obligatoire');
    deDateNaissance.SetFocus;
    Result:=False;
  end
  else
  begin
    Result:=True;
  end;

end;

end.

