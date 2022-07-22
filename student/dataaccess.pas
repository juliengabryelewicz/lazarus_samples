unit DataAccess;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, mysql80conn, SQLDB, DB, Dialogs, SQL, StdCtrls, LR_Class,
  LR_DBSet,INIFiles;

type

    { TCBClasse }

    TCBClasse = class
    (* Données invisibles d'un élément de combobox contenant la liste des classes *)
    strict private
      FIdClasse : Integer;
    public
      property IdClasse : Integer read FIdClasse;
      constructor Create (const AIdClasse : Integer);
     end;

     { TCBMatiere }

    TCBMatiere = class
    (* Données invisibles d'un élément de combobox contenant la liste des matières *)
    strict private
      FIdMatiere : Integer;
    public
      property IdMatiere : Integer read FIdMatiere;
      constructor Create (const AIdMatiere : Integer);
     end;

    { TEleve }

    TEleve = class
      (* Données initiales d'un élève à modifier *)
      strict private
        FIdEleve : Integer;
        FIdClasse : Integer;
        FPrenom : String;
        FNom : String;
        FDateNaissance : TDateTime;
        FCommentaire: String;
      public
        property IdEleve : Integer read FIdEleve;
        property IdClasse : Integer read FIdClasse;
        property Prenom : String read FPrenom;
        property Nom : String read FNom;
        property DateNaissance : TDateTime read FDateNaissance;
        property Commentaire : String read FCommentaire;
        constructor Create (const AIdEleve : Integer;
                            const AIdClasse : Integer;
                            const APrenom, ANom : String;
                            const ADateNaissance : TDateTime;
                            const ACommentaire : String);
    end;

    { TNote }

    TNote = class
      (* Données initiales d'une note à modifier *)
      strict private
        FIdNote : Integer;
        FIdEleve : Integer;
        FIdMatiere : Integer;
        FNom : String;
        FNote : String;
        FDateNote : TDateTime;
        FCommentaire: String;
      public
        property IdNote : Integer read FIdNote;
        property IdEleve : Integer read FIdEleve;
        property IdMatiere : Integer read FIdMatiere;
        property Nom : String read FNom;
        property Note : String read FNote;
        property DateNote : TDateTime read FDateNote;
        property Commentaire : String read FCommentaire;
        constructor Create (const AIdNote, AIdEleve, AIdMatiere : Integer;
                            const ANom, ANote : String;
                            const ADateNote : TDateTime;
                            const ACommentaire : String);
    end;

  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    DataSourceTempEleves: TDataSource;
    DataSourceTempNotes: TDataSource;
    DataSourceNotes: TDataSource;
    DataSourceMain: TDataSource;
    DataSourceMatieres: TDataSource;
    DataSourceClasses: TDataSource;
    frDBDataSet1: TfrDBDataSet;
    frDBDataSet2: TfrDBDataSet;
    frReport1: TfrReport;
    SQLConnection: TMySQL80Connection;
    SQLQueryTempEleves: TSQLQuery;
    SQLQueryTempNotes: TSQLQuery;
    SQLQueryNotes: TSQLQuery;
    SQLQueryMain: TSQLQuery;
    SQLQueryMatieres: TSQLQuery;
    SQLQueryClasses: TSQLQuery;
    SQLTransaction: TSQLTransaction;
    procedure DataSourceMainDataChange(Sender: TObject; Field: TField);
  private
    function Commit : Boolean;
  public
    function Login : Boolean;
    procedure Logoff;
    procedure ChargementClasses;
    function SauvegardeClasses : Boolean;
    procedure ChargementMatieres;
    function SauvegardeMatieres : Boolean;
    procedure ChargementEleves(const Requete: String);
    function SauvegardeEleves (const Requete : String) : Boolean;
    procedure ChargementCBClasses (var ComboBox : TComboBox);
    procedure ChargementCBMatieres (var ComboBox : TComboBox);
    procedure ChargementNotes(const Requete: String);
    function SauvegardeNotes (const Requete : String) : Boolean;
    procedure CreerBulletin;
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.lfm}

constructor TCBClasse.Create (const AIdClasse : Integer);
(* Initialisation des champs *)
begin
  FIdClasse := AIdClasse;
end;

constructor TCBMatiere.Create (const AIdMatiere : Integer);
(* Initialisation des champs *)
begin
  FIdMatiere := AIdMatiere;
end;

constructor TEleve.Create (const AIdEleve : Integer;
                              const AIdClasse : Integer;
                              const APrenom, ANom : String;
                              const ADateNaissance : TDateTime;
                              const ACommentaire : String);
(* Initialisation des champs *)
begin
  FIdEleve := AIdEleve;
  FIdClasse := AIdClasse;
  FPrenom := APrenom;
  FNom := ANom;
  FDateNaissance := ADateNaissance;
  FCommentaire := ACommentaire;
end;

constructor TNote.Create (const AIdNote, AIdEleve, AIdMatiere : Integer;
                    const ANom, ANote : String;
                    const ADateNote : TDateTime;
                    const ACommentaire : String);
(* Initialisation des champs *)
begin
  FIdNote := AIdNote;
  FIdEleve := AIdEleve;
  FIdMatiere := AIdMatiere;
  FNom := ANom;
  FNote := ANote;
  FDateNote:= ADateNote;
  FCommentaire := ACommentaire;
end;

function TDataModule1.Login: Boolean;
(* Demande du mot de passe et connexion à la base de données *)
var
  INI:TINIFile;
begin
  Result := True;
  INI := TINIFile.Create('db.ini');
  SQLConnection.HostName := INI.ReadString('INIDB','HostName','');
  SQLConnection.DatabaseName := INI.ReadString('INIDB','DatabaseName','');
  SQLConnection.UserName := INI.ReadString('INIDB','UserName','');
  SQLConnection.Password := INI.ReadString('INIDB','Password','');
   try
     SQLConnection.Connected := True;
     SQLTransaction.Active := True;
   except
     on e : ESQLDatabaseError do
       begin   (* Erreur renvoyée par MySQL : fin de programme *)
         MessageDlg('Erreur de connexion à la base de données :'#10#10#13 +
                    IntToStr(e.ErrorCode) + ' : ' + e.Message +
                    #10#10#13'Fin de programme.', mtError, [mbOk], 0);
         Result := False;
       end;
     on e : EDatabaseError do
       begin   (* Erreur de connexion : fin de programme *)
         MessageDlg('Erreur de connexion à la base de données.'#10#10#13'Fin de programme.', mtError, [mbOk], 0);
         Result := False;
       end;
   end;
end;
procedure TDataModule1.Logoff;
(* Déconnexion de la base de données *)
begin
  if SQLTransaction.Active
     then
       SQLTransaction.Active := False;
  if SQLConnection.Connected
     then
       SQLConnection.Connected := False;
end;

procedure TDataModule1.DataSourceMainDataChange(Sender: TObject; Field: TField);
begin
  ChargementNotes(MySQLSyntax.SelectionNotesFiltre(SQLQueryMain.FieldByName('id').AsInteger));
end;

function TDataModule1.Commit: Boolean;
(* Sauvegarde des changements dans la base de données *)
begin
  Result := True;
  if SQLTransaction.Active
     then
       try
         SQLTransaction.CommitRetaining;
       except
         on e: ESQLDatabaseError do
             begin   (* Erreur renvoyée par MySQL *)
               MessageDlg('Erreur n° ' +
                          IntToStr(e.ErrorCode) + ' : ' + e.Message,
                          mtError, [mbOk], 0);
               Result := False;
             end;
         on e: EDatabaseError do
           begin   (* Erreur générale *)
             MessageDlg('Erreur de sauvegarde des données', mtError, [mbOk], 0);
             Result := False;
           end;
       end
     else
       Result := False;
end;
procedure TDataModule1.ChargementClasses;
(* Chargement des classes *)
begin
  with SQLQueryClasses do
    begin
      Close;
      SQL.Text := MySQLSyntax.SelectionClassesToutes;
      Open;
    end;
end;
function TDataModule1.SauvegardeClasses: Boolean;
(* Sauvegarde de la table classes *)
begin
  SQLQueryClasses.ApplyUpdates;
  Result := Commit;
end;


procedure TDataModule1.ChargementMatieres;
(* Chargement des matieres *)
begin
  with SQLQueryMatieres do
    begin
      Close;
      SQL.Text := MySQLSyntax.SelectionMatieresToutes;
      Open;
    end;
end;
function TDataModule1.SauvegardeMatieres: Boolean;
(* Sauvegarde de la table matieres *)
begin
  SQLQueryMatieres.ApplyUpdates;
  Result := Commit;
end;

procedure TDataModule1.ChargementEleves(const Requete: String);
(* Charge la table des élèves *)
begin
  SQLQueryMain.Close;
  SQLQueryMain.SQL.Text := Requete;
  SQLQueryMain.Open;
end;

procedure TDataModule1.ChargementNotes(const Requete: String);
(* Charge la table des notes *)
begin
  SQLQueryNotes.Close;
  SQLQueryNotes.SQL.Text := Requete;
  SQLQueryNotes.Open;
end;

function TDataModule1.SauvegardeNotes (const Requete : String) : Boolean;
(* Sauvegarde de la table notes *)
begin
  SQLQueryNotes.Close;
  SQLQueryNotes.SQL.Clear;
  SQLQueryNotes.SQL.Add(Requete);
  SQLQueryNotes.ExecSQL;
  Result := Commit;
end;

procedure TDataModule1.ChargementCBClasses (var ComboBox : TComboBox);
var
  LNom : String;   (* Texte visible d'un élément *)
begin
  ChargementClasses;
  with SQLQueryClasses do
    while not EOF do
      begin
        LNom := FieldByName('nom').AsString;
        ComboBox.AddItem(LNom, TCBClasse.Create(FieldByName('id').AsInteger));
        Next;
      end;
end;

procedure TDataModule1.ChargementCBMatieres (var ComboBox : TComboBox);
var
  LNom : String;   (* Texte visible d'un élément *)
begin
  ChargementMatieres;
  with SQLQueryMatieres do
    while not EOF do
      begin
        LNom := FieldByName('nom').AsString;
        ComboBox.AddItem(LNom, TCBMatiere.Create(FieldByName('id').AsInteger));
        Next;
      end;
end;

function TDataModule1.SauvegardeEleves (const Requete : String) : Boolean;
(* Sauvegarde de la table eleves *)
begin
  SQLQueryMain.Close;
  SQLQueryMain.SQL.Clear;
  SQLQueryMain.SQL.Add(Requete);
  SQLQueryMain.ExecSQL;
  Result := Commit;
end;

procedure TDataModule1.CreerBulletin;
begin
  SQLQueryTempNotes.Close;
  SQLQueryTempNotes.SQL.Text := MySQLSyntax.SelectionMoyenneEleve(SQLQueryMain.FieldByName('id').AsInteger);
  SQLQueryTempNotes.Open;
  SQLQueryTempEleves.Close;
  SQLQueryTempEleves.SQL.Text := MySQLSyntax.SelectionDetailEleve(SQLQueryMain.FieldByName('id').AsInteger);
  SQLQueryTempEleves.Open;
  frReport1.LoadFromFile('bulletin.lrf');
  frReport1.PrepareReport;
  frReport1.ShowReport;
end;

end.

