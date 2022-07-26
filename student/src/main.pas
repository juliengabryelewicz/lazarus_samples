unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, Forms, Controls, Graphics, Dialogs, Menus, DBGrids,
  StdCtrls, DBCtrls, ExtCtrls, EditBtn, Buttons, Spin, LR_Class, LR_DBSet,
  DataAccess, ClassesEleve, Matieres, SQL, Eleves;

type

  { TMainForm }

  TMainForm = class(TForm)
    btnSearch: TButton;
    btnAjouterEleve: TButton;
    btnModifierEleve: TButton;
    btnSupprimerEleve: TButton;
    btnAnnuler: TButton;
    btnEnregistrer: TButton;
    btnBulletin: TButton;
    cbMatieres: TComboBox;
    deDate: TDateEdit;
    dbgMain: TDBGrid;
    dbgNotes: TDBGrid;
    dbnNotes: TDBNavigator;
    edNom: TEdit;
    edSearch: TEdit;
    edNote: TFloatSpinEdit;
    lMatiere: TLabel;
    lDate: TLabel;
    lCommentaire: TLabel;
    lNote: TLabel;
    lNom: TLabel;
    lSearch: TLabel;
    MainMenu: TMainMenu;
    FichierMenu: TMenuItem;
    ClassesMenu: TMenuItem;
    MatieresMenu: TMenuItem;
    mCommentaire: TMemo;
    panNotes: TPanel;
    BtnAjouterNote: TSpeedButton;
    btnModifierNote: TSpeedButton;
    btnSupprimerNote: TSpeedButton;
    procedure btnAjouterEleveClick(Sender: TObject);
    procedure BtnAjouterNoteClick(Sender: TObject);
    procedure btnAnnulerClick(Sender: TObject);
    procedure btnBulletinClick(Sender: TObject);
    procedure btnEnregistrerClick(Sender: TObject);
    procedure btnModifierEleveClick(Sender: TObject);
    procedure btnModifierNoteClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnSupprimerEleveClick(Sender: TObject);
    procedure btnSupprimerNoteClick(Sender: TObject);
    procedure ClassesMenuClick(Sender: TObject);
    procedure edNoteChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MatieresMenuClick(Sender: TObject);
  strict private
    FEnregistre : Boolean;
    FIndexMatiere : Integer;
    FIdNote : Integer;
  private
    procedure SetEnregistre (AValue : Boolean);
    procedure SetIdNote (AValue : Integer);
    procedure SetIndexMatiere (AValue : Integer);
    procedure UpdateUI;
    function VerifFields : Boolean;
  public
    property Enregistre : Boolean read FEnregistre write SetEnregistre;
    property IdNote : Integer read FIdNote write SetIdNote;
    property IndexMatiere : Integer read FIndexMatiere write SetIndexMatiere;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
(* Fermeture de la connexion à la base de données *)
begin
  MySQLSyntax.Free;
  DataModule1.Logoff;
end;

procedure TMainForm.ClassesMenuClick(Sender: TObject);
(* Gestion de la liste des classes *)
var
  LClassesForm : TClassesForm;   (* Dialogue de gestion des classes *)
begin
  LClassesForm := TClassesForm.Create(Self);
  try
    LClassesForm.ShowModal;
  finally
    FreeAndNil(LClassesForm);
    (* Mise à jour de la liste *)
    DataModule1.ChargementEleves(MySQLSyntax.SelectionElevesFiltre(edSearch.Text));
  end;
end;

procedure TMainForm.edNoteChange(Sender: TObject);
begin

end;

procedure TMainForm.btnSearchClick(Sender: TObject);
begin
   DataModule1.ChargementEleves(MySQLSyntax.SelectionElevesFiltre(edSearch.Text));
end;

procedure TMainForm.btnSupprimerEleveClick(Sender: TObject);
(* Suppression de l'élève sélectionné *)
begin
  if MessageDlg('Faut-il supprimer l''élève ? Toutes ses notes seront supprimées', mtConfirmation, [mbYes, mbNo], 0) = mrYes
     then
       DataModule1.SauvegardeEleves(MySQLSyntax.SuppressionEleve(DataModule1.SQLQueryMain.FieldByName('id').AsInteger));
  (* Mise à jour de la liste *)
  DataModule1.ChargementEleves(MySQLSyntax.SelectionElevesFiltre(edSearch.Text));
end;

procedure TMainForm.btnSupprimerNoteClick(Sender: TObject);
(* Suppression de la note sélectionnée *)
begin
    if MessageDlg('Faut-il supprimer la note ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
     then
       DataModule1.SauvegardeNotes(MySQLSyntax.SuppressionNote(DataModule1.SQLQueryNotes.FieldByName('id').AsInteger));
  (* Mise à jour de la liste *)
  DataModule1.ChargementNotes(MySQLSyntax.SelectionNotesFiltre(DataModule1.SQLQueryMain.FieldByName('id').AsInteger));
end;

procedure TMainForm.btnAjouterEleveClick(Sender: TObject);
var
  LNewEleveForm : TNewEleveForm;
begin
  LNewEleveForm := TNewEleveForm.Create(Self);
  try
    LNewEleveForm.ShowModal;
  finally
    FreeAndNil(LNewEleveForm);
  end;
  (* Mise à jour de la liste des élèves *)
  DataModule1.ChargementEleves(MySQLSyntax.SelectionElevesFiltre(edSearch.Text));
end;

procedure TMainForm.BtnAjouterNoteClick(Sender: TObject);
begin
     panNotes.Visible:=True;
     MainForm.IdNote:=0;
     edNom.Text := '';
     edNote.Text := '';
     deDate.Date := now;
     mCommentaire.Text := '';
     UpdateUI;
end;

procedure TMainForm.btnAnnulerClick(Sender: TObject);
begin
     panNotes.Visible:=False;
     UpdateUI;
end;

procedure TMainForm.btnBulletinClick(Sender: TObject);
begin
  DataModule1.CreerBulletin;
end;

procedure TMainForm.btnEnregistrerClick(Sender: TObject);
begin
    if VerifFields then
    begin
      if MainForm.IdNote = 0 then
        begin
          Enregistre := DataModule1.SauvegardeNotes(MySQLSyntax.InsertionNote(
                TCBMatiere(cbMatieres.Items.Objects[cbMatieres.ItemIndex]).IdMatiere,
                DataModule1.SQLQueryMain.FieldByName('id').AsInteger,
                edNom.Text, FloatToStr(edNote.Value), deDate.Date, mCommentaire.Text));
        end
        else
        begin
          Enregistre := DataModule1.SauvegardeNotes(MySQLSyntax.ModificationNote(
                MainForm.IdNote, DataModule1.SQLQueryMain.FieldByName('id').AsInteger,
                TCBMatiere(cbMatieres.Items.Objects[cbMatieres.ItemIndex]).IdMatiere,
                edNom.Text, FloatToStr(edNote.Value), deDate.Date, mCommentaire.Text));
        end;
        DataModule1.ChargementNotes(MySQLSyntax.SelectionNotesFiltre(DataModule1.SQLQueryMain.FieldByName('id').AsInteger));
        panNotes.Visible:=False;
        UpdateUI;
    end;
end;

procedure TMainForm.btnModifierEleveClick(Sender: TObject);
(* Modification de l'élève sélectionné *)
var
  LUpdateEleveForm : TUpdateEleveForm;   (* Dialogue de modification *)
  LEleveAModifier : TEleve;            (* Données à modifier *)
begin
  LUpdateEleveForm := TUpdateEleveForm.Create(Self);
  try
    (* Récolte des données de l'élément à modifier *)
    with DataModule1.SQLQueryMain do
      LEleveAModifier := TEleve.Create(FieldByName('id').AsInteger,
                                          FieldByName('id_classe').AsInteger,
                                             FieldByName('prenom').AsString,
                                             FieldByName('nom').AsString,
                                             FieldByName('date_naissance').AsDateTime,
                                             FieldByName('commentaire').AsString);
    LUpdateEleveForm.EleveAModifier := LEleveAModifier;
    (* Exécution du dialogue *)
    LUpdateEleveForm.ShowModal;
  finally
    FreeAndNil(LUpdateEleveForm);
    LEleveAModifier.Free;
  end;
  (* Mise à jour de la liste des élèves affichée *)
  DataModule1.ChargementEleves(MySQLSyntax.SelectionElevesFiltre(edSearch.Text));
end;

procedure TMainForm.btnModifierNoteClick(Sender: TObject);
var
  LNoteAModifier : TNote;
  Li : Integer;
  LTrouve : Boolean;
begin
  panNotes.Visible:=True;
  UpdateUI;
  try
    (* Récolte des données de l'élément à modifier *)
    with DataModule1.SQLQueryNotes do
      LNoteAModifier := TNote.Create(FieldByName('id').AsInteger,
                                     DataModule1.SQLQueryMain.FieldByName('id').AsInteger,
                                     FieldByName('id_matiere').AsInteger,
                                     FieldByName('nom').AsString,
                                     FieldByName('note').AsString,
                                     FieldByName('date_note').AsDateTime,
                                     FieldByName('commentaire').AsString);

      edNom.Text := LNoteAModifier.Nom;
      edNote.Text := LNoteAModifier.Note;
      deDate.Date := LNoteAModifier.DateNote;
      mCommentaire.Text := LNoteAModifier.Commentaire;
      MainForm.IdNote := LNoteAModifier.IdNote;
      LTrouve := False;
      Li := 0;
      while (Li < cbMatieres.Items.Count) and not LTrouve do
        if TCBMatiere(cbMatieres.Items.Objects[Li]).IdMatiere = LNoteAModifier.IdMatiere
           then
             begin
               cbMatieres.ItemIndex := Li;
               LTrouve := True;
             end
           else
             Inc(Li);

  finally
    LNoteAModifier.Free;
  end;
end;

procedure TMainForm.MatieresMenuClick(Sender: TObject);
(* Gestion de la liste des matières *)
var
  LMatieresForm : TMatieresForm;   (* Dialogue de gestion des matières *)
begin
  LMatieresForm := TMatieresForm.Create(Self);
  try
    LMatieresForm.ShowModal;
  finally
    FreeAndNil(LMatieresForm);
    DataModule1.ChargementNotes(MySQLSyntax.SelectionNotesFiltre(DataModule1.SQLQueryMain.FieldByName('id').AsInteger));
    DataModule1.ChargementCBMatieres(cbMatieres);
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
if DataModule1.Login
   then
     begin
       MySQLSyntax := TMySQLSyntax.Create;
       DataModule1.ChargementEleves(MySQLSyntax.SelectionElevesFiltre(edSearch.Text));
       DataModule1.ChargementNotes(MySQLSyntax.SelectionNotesFiltre(DataModule1.SQLQueryMain.FieldByName('id').AsInteger));
       DataModule1.ChargementCBMatieres(cbMatieres);
       IndexMatiere := 0;
       cbMatieres.ItemIndex := IndexMatiere;
     end
   else
     Close;
end;

procedure TMainForm.SetIndexMatiere(AValue : Integer);
(* Setter de la propriété IndexMatiere *)
begin
  if FIndexMatiere = AValue
     then
       Exit;
  FIndexMatiere := AValue;
end;

procedure TMainForm.SetEnregistre (AValue : Boolean);
(* Setter de la propriété Enregistre *)
begin
  if FEnregistre = AValue
     then
       Exit;
  FEnregistre := AValue;
end;

procedure TMainForm.SetIdNote(AValue : Integer);
(* Setter de la propriété IndexClasse *)
begin
  if FIdNote = AValue
     then
       Exit;
  FIdNote := AValue;
end;

procedure TMainForm.UpdateUI;
var
  Visibility : Boolean;
begin
  Visibility := (not panNotes.Visible);
  dbgNotes.Enabled := Visibility;
  dbnNotes.Enabled := Visibility;
  dbgMain.Enabled := Visibility;
  btnAjouterNote.Enabled := Visibility;
  btnModifierNote.Enabled := Visibility;
  btnSupprimerNote.Enabled := Visibility;
  btnAjouterEleve.Enabled := Visibility;
  btnModifierEleve.Enabled := Visibility;
  btnSupprimerEleve.Enabled := Visibility;
  btnBulletin.Enabled := Visibility;
  edSearch.Enabled := Visibility;
  btnSearch.Enabled := Visibility;
end;

function TMainForm.VerifFields : Boolean;
begin
  if Trim(edNom.Text) = '' then
  begin
    ShowMessage('Le nom de l''examen est obligatoire');
    edNom.SetFocus;
    Result:=False;
  end
  else if Trim(edNote.Text) = '' then
  begin
    ShowMessage('La note est obligatoire');
    edNote.SetFocus;
    Result:=False;
  end
  else if Trim(deDate.Text) = '' then
  begin
    ShowMessage('La date est obligatoire');
    deDate.SetFocus;
    Result:=False;
  end
  else
  begin
    Result:=True;
  end;

end;

end.

