unit SQL;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

    ISQLSyntax = interface
    ['{AD085F92-EAF5-410B-8C1B-0B205984B74E}']
        function SelectionClassesToutes : String;
      (* Requête de sélection de toutes les classes *)
        function SelectionMatieresToutes : String;
      (* Requête de sélection de toutes les classes *)
        function FormatDate : TFormatSettings;
        function SelectionElevesFiltre(const Search : String) : String;
        function InsertionEleve (
        const AIdClasse : Integer;
        const APrenom : String;
        const ANom : String;
        const ADateNaissance : TDateTime;
        const ACommentaire: String
        ) : String;
        function ModificationEleve (
        const AIdEleve : Integer;
        const AIdClasse : Integer;
        const APrenom : String;
        const ANom : String;
        const ADateNaissance : TDateTime;
        const ACommentaire: String
        ) : String;
        function SuppressionEleve (
        const AIdEleve : Integer
        ) : String;
        function SelectionNotesFiltre(Search : Integer) : String;
        function InsertionNote (
        const AIdMatiere, AIdEleve : Integer;
        const ANomExamen, ANote : String;
        const ADateExamen : TDateTime;
        const ACommentaire: String
        ) : String;
        function ModificationNote (const AIdNote, AIdEleve, AIdMatiere : Integer;
        const ANomExamen, ANote : String;
        const ADateExamen : TDateTime;
        const ACommentaire : String) : String;
        function SuppressionNote (const AIdNote : Integer) : String;
        function SelectionMoyenneEleve (
        const AIdEleve : Integer
        ) : String;
    end;

    TMySQLSyntax = class(TInterfacedObject, ISQLSyntax)
      function SelectionClassesToutes : String;
      function SelectionMatieresToutes : String;
      function FormatDate : TFormatSettings;
      function SelectionElevesFiltre(const Search : String) : String;
      function InsertionEleve (
      const AIdClasse : Integer;
      const APrenom : String;
      const ANom : String;
      const ADateNaissance : TDateTime;
      const ACommentaire: String
      ) : String;
      function ModificationEleve (
      const AIdEleve : Integer;
      const AIdClasse : Integer;
      const APrenom : String;
      const ANom : String;
      const ADateNaissance : TDateTime;
      const ACommentaire: String
      ) : String;
      function SuppressionEleve (
      const AIdEleve : Integer
      ) : String;
      function SelectionNotesFiltre(Search : Integer) : String;
      function InsertionNote (
        const AIdMatiere, AIdEleve : Integer;
        const ANomExamen, ANote : String;
        const ADateExamen : TDateTime;
        const ACommentaire: String
        ) : String;
      function ModificationNote (const AIdNote, AIdEleve, AIdMatiere : Integer;
        const ANomExamen, ANote : String;
        const ADateExamen : TDateTime;
        const ACommentaire : String) : String;
      function SuppressionNote (const AIdNote : Integer) : String;
      function SelectionDetailEleve (
      const AIdEleve : Integer
      ) : String;
      function SelectionMoyenneEleve (
      const AIdEleve : Integer
      ) : String;
    end;

var
  MySQLSyntax : TMySQLSyntax;
implementation

  function TMySQLSyntax.SelectionClassesToutes : String;
  (* Requête de sélection de toutes les classes *)
  begin
    Result := 'SELECT * FROM classes ORDER BY classes.nom ASC;';
  end;

  function TMySQLSyntax.SelectionMatieresToutes : String;
  (* Requête de sélection de toutes les matières *)
  begin
    Result := 'SELECT * FROM matieres ORDER BY matieres.nom ASC;';
  end;

  function TMySQLSyntax.FormatDate: TFormatSettings;
  (* Formats de date et de séparateur compatibles avec le SGBD *)
  begin
    Result.DateSeparator := '-';
    Result.ShortDateFormat := 'yyyy-mm-dd';
  end;

  function TMySQLSyntax.SelectionElevesFiltre (const Search : String) : String;
  (* Requête de sélection d'élèves avec critères *)
  begin
    Result := 'SELECT * FROM eleves' +
              ' INNER JOIN classes ON eleves.id_classe = classes.id' +
              ' WHERE eleves.nom LIKE ''%'+ Search +'%''' +
              ' OR eleves.prenom LIKE ''%'+ Search +'%''' +
              ' ORDER BY eleves.nom ASC';

  end;

  function TMySQLSyntax.InsertionEleve (
        const AIdClasse : Integer;
        const APrenom, ANom : String;
        const ADateNaissance : TDateTime;
        const ACommentaire: String
        ) : String;
  (* Requête d'insertion d'une nouvel élève *)
  begin
    Result := 'INSERT INTO eleves VALUES (NULL, ''' + APrenom + ''', ''' + ANom + ''', ''' +
              DateToStr(ADateNaissance, FormatDate) + ''', ''' +
              ACommentaire + ''', ''' + IntToStr(AIdClasse) + ''');';
  end;

  function TMySQLSyntax.ModificationEleve (const AIdEleve, AIdClasse : Integer;
                                              const APrenom, ANom : String;
                                              const ADateNaissance : TDateTime;
                                              const ACommentaire : String) : String;
  (* Requête de modification d'un élève *)
  begin
    Result := 'UPDATE eleves SET id_classe = ''' + IntToStr(AIdClasse) + ''', prenom = ''' + APrenom +
              ''', nom = ''' + ANom +
              ''', date_naissance = ''' + DateToStr(ADateNaissance, FormatDate) + ''', commentaire = ''' + ACommentaire + '''';
    Result := Result + ' WHERE id = ''' + IntToStr(AIdEleve) + ''';';
  end;

  function TMySQLSyntax.SuppressionEleve (const AIdEleve : Integer) : String;
  (* Requête de suppression d'un élève *)
  begin
    Result := 'DELETE FROM eleves WHERE id = ''' + IntToStr(AIdEleve) + ''';';
  end;

  function TMySQLSyntax.SelectionNotesFiltre (Search : Integer) : String;
  (* Requête de sélection de locations avec critères *)
  begin
    Result := 'SELECT notes.*, matieres.nom FROM notes' +
              ' INNER JOIN matieres ON notes.id_matiere = matieres.id' +
              ' WHERE notes.id_eleve=''' + IntToStr(Search) + ''' ORDER BY notes.date_note DESC;';

  end;

  function TMySQLSyntax.InsertionNote (
        const AIdMatiere, AIdEleve : Integer;
        const ANomExamen, ANote : String;
        const ADateExamen : TDateTime;
        const ACommentaire: String
        ) : String;
  (* Requête d'insertion d'une nouvelle note *)
  begin
    Result := 'INSERT INTO notes VALUES (NULL, ''' + ANomExamen + ''', ''' + ANote + ''', ''' +
              ACommentaire + ''', ''' +
              DateToStr(ADateExamen, FormatDate) + ''', ''' + IntToStr(AIdEleve) + ''', ''' +
              IntToStr(AIdMatiere) + ''');';
  end;

  function TMySQLSyntax.ModificationNote (const AIdNote, AIdEleve, AIdMatiere : Integer;
                                              const ANomExamen, ANote : String;
                                              const ADateExamen : TDateTime;
                                              const ACommentaire : String) : String;
  (* Requête de modification d'une note *)
  begin
    Result := 'UPDATE notes SET id_eleve = ''' + IntToStr(AIdEleve) + ''', id_matiere = ''' + InttoStr(AIdMatiere) +
              ''', nom = ''' + ANomExamen +
              ''', note = ''' + ANote + ''', date_note = ''' + DateToStr(ADateExamen, FormatDate) +
              ''', commentaire = ''' + ACommentaire + '''';
    Result := Result + ' WHERE id = ''' + IntToStr(AIdNote) + ''';';
  end;

  function TMySQLSyntax.SuppressionNote (const AIdNote : Integer) : String;
  (* Requête de suppression d'une note *)
  begin
    Result := 'DELETE FROM notes WHERE id = ''' + IntToStr(AIdNote) + ''';';
  end;

  function TMySQLSyntax.SelectionMoyenneEleve (const AIdEleve : Integer) : String;
  (* Requête de récupération des moyenne d'un élève par matière *)
  begin
    Result := 'SELECT matieres.nom, AVG(notes.note) AS moyenne FROM notes' +
    ' INNER JOIN matieres ON notes.id_matiere=matieres.id' +
    ' WHERE notes.id_eleve=''' + IntToStr(AIdEleve) + '''' +
    ' GROUP BY notes.id_matiere;';
  end;

  function TMySQLSyntax.SelectionDetailEleve (const AIdEleve : Integer) : String;
  (* Requête des informations d'un élève spécifique *)
  begin
    Result := 'SELECT * FROM eleves' +
    ' INNER JOIN classes ON eleves.id_classe=classes.id' +
    ' WHERE eleves.id=''' + IntToStr(AIdEleve) + ''';';
  end;

end.

