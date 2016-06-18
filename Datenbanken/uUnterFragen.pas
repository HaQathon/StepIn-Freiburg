unit uUnterFragen;

interface

uses
  Uni,
  UTableBase,
  System.Generics.Collections;
type
  TUnterFrage = class(TEntityBase)
  private // Felder private, durch property veröffentlichen
    fId: Integer;
    fHauptfrageID: Integer;
    fAttributeID: Integer;
    fFrage      : String;

  public
    property id: integer read fID write fID;
    property HauptfrageID: integer read fHauptfrageID write fHauptfrageID;
    property AttributeID: integer read fAttributeID write fAttributeID;
    property Fragen: String read fFrage write fFrage;

    procedure fillFields(query: TUniQuery);
    procedure addToDatabase;

    procedure fillParamsOfQuery(query: TUniQuery); override;
  end;

  TUnterFragenDatenbank = class(TTableBase)
  public
    constructor Create(const Database: string);
//    procedure addToDatabase(Attribut: TAttribut);
    procedure updateByUnterFragenID(unterFrage: TUnterFrage);
    function sucheEintraege(Suche: String): TObjectList<TUnterFrage>;
    function getAllUnterFragen: TList<TUnterFrage>;
    procedure deleteByUnterFragenID(contentRelId: integer);
    function getLastUnterFragen: TUnterFrage;
    function get(const ID: Integer): TUnterFrage;

    function getTableName: String;override;
    procedure getColumnNames(columnList: TList<String>);override;

    const cTABLE_NAME = 'UnterFragen';
    const cID = 'id';
    const cHauptfrageID = 'HauptfrageID';
    const cAttributeID = 'attributeID';
    const cFragen      = 'fragen';
  end;

var unterFragenDatenbank: TUnterFragenDatenbank;


implementation

uses uSQLConnection,System.SysUtils,System.IOUtils;

const
  AUTHORITY = '';
  BASE_PATH_TASKCONTENTREL = 'UnterFragen';
  CONTENT_URI_TASKCONTENTREL= BASE_PATH_TASKCONTENTREL ;

{ ============================================================================ }

constructor TUnterFragenDatenbank.Create(const Database: string);
   begin
    FSQLConnection := TSQLConnection.Create(ctSQLite);
    FSQLConnection.Database := Database;
    if not FileExists(FSQLConnection.Database) then
       begin
        FSQLConnection.SpecificOptions.Add('ForceCreateDatabase=true');
       end;
    FSQLConnection.Open;

    FSQLConnection.ExecSQL('CREATE TABLE IF NOT EXISTS ' + cTABLE_NAME + ' ( ' +
       cID + ' INTEGER PRIMARY KEY AUTOINCREMENT, ' +
       cHauptfrageID+ ' INTEGER NOT NULL, ' +
       cAttributeID + ' INTEGER NOT NULL' + ')');
  end;

{ ============================================================================ }

procedure TUnterFragenDatenbank.getColumnNames(columnList: TList<String>);
   begin
    columnList.Add(cID);
    columnList.Add(cHauptfrageID);
    columnList.Add(cAttributeID);
   end;

{ ============================================================================ }

function TUnterFragenDatenbank.getTableName: String;
   begin
    result := cTABLE_NAME;
   end;

{ ============================================================================ }

procedure TUnterFrage.fillFields(query: TUniQuery);
   begin
    id := query.FieldByName(unterFragenDatenbank.cID).AsInteger;
    HauptfrageID := query.FieldByName(unterFragenDatenbank.cHauptfrageID).AsInteger;
    AttributeID  := query.FieldByName(unterFragenDatenbank.cAttributeID).AsInteger;
    Fragen       := query.FieldByName(unterFragenDatenbank.cFragen).AsString;

   end;

{ ============================================================================ }

procedure TUnterFrage.fillParamsOfQuery(query: TUniQuery);
   begin
    query.ParamByName(unterFragenDatenbank.cID).AsInteger := id;
    query.ParamByName(unterFragenDatenbank.cHauptfrageID).AsInteger :=  HauptfrageID;
    query.ParamByName(unterFragenDatenbank.cAttributeID).AsInteger   :=  AttributeID;
    query.ParamByName(unterFragenDatenbank.cFragen).AsString    :=  Fragen;
   end;

{ ============================================================================ }

procedure TUnterFragenDatenbank.updateByUnterFragenID(unterFrage: TUnterFrage);
  var
    query: TUniQuery;
  begin

    query := TUniQuery.Create(nil);
    query.connection := fSQLConnection;

    try
      query.SQL.Text := 'UPDATE ' + cTABLE_NAME + ' SET ' + getAllColumnsWithParams +
       ' WHERE ' + cID + '=:' + cID;;
      query.Prepare;

      query.ParamByName(cID).AsInteger := unterFrage.id;
      unterFrage.fillParamsOfQuery(query);

      query.Execute;
    finally
      query.Close;
      query.Free;
    end;
  end;

{ ============================================================================ }

function TUnterFragenDatenbank.sucheEintraege(Suche: String): TObjectList<TUnterFrage>;
  var
    query: TUniQuery;
    tmpObj: TUnterFrage;
    tmpSQL: String;
   begin
    result := TObjectList<TUnterFrage>.Create(True);
    query := TUniQuery.Create(nil);
    try
      query.connection := FSQLConnection;
      tmpSQL := 'SELECT * FROM ' + cTABLE_NAME;
      if Suche<>'' then
        tmpSQL := tmpSQL + ' WHERE ' + Suche;

      query.SQL.Text := tmpSQL;
      query.Open;

      while not(query.Eof) do
      begin
        tmpObj := TUnterFrage.Create;
        tmpObj.fillFields(query);
        result.Add(tmpObj);
        query.Next;
      end;
    finally
      query.Close;
      query.Free;
    end;
   end;

{ ============================================================================ }

function TUnterFragenDatenbank.get(const ID: Integer): TUnterFrage;
   var
    List: TList<TUnterFrage>;
   begin
    List := sucheEintraege(cID + '=' + ID.ToString());
    try
      if List.Count = 1 then result := List.Extract(List.First)
      else result := nil;
    finally
      List.Free;
    end;
   end;

{ ============================================================================ }

function TUnterFragenDatenbank.getAllUnterFragen: TList<TUnterFrage>;
   begin
    result := sucheEintraege('');
   end;

{ ============================================================================ }

procedure TUnterFrage.addToDatabase;
   var
    tmpUnterFrage: TUnterFrage;
   begin
    unterFragenDatenbank.addToDatabase(Self);
    tmpUnterFrage := unterFragenDatenbank.getLastUnterFragen;
    try
      id := tmpUnterFrage.id;
    finally
      tmpUnterFrage.Free;
    end;
   end;

{ ============================================================================ }

procedure TUnterFragenDatenbank.deleteByUnterFragenID(contentRelId: integer);
   begin
    Delete(cID+'='+#39+contentRelId.ToString+#39);
   end;

{ ============================================================================ }

function TUnterFragenDatenbank.getLastUnterFragen: TUnterFrage;
   var
    query: TUniQuery;
  begin
    result := TUnterFrage.Create;
    query := TUniQuery.Create(nil);

    try
      query.connection := fSQLConnection;
      query.SQL.Text := 'SELECT * FROM ' + cTABLE_NAME +
         ' ORDER BY '+cID+' DESC LIMIT 1';
      query.Open;

      if query.RecordCount = 1 then
      begin
        result.fillFields(query);
      end
      else
        FreeAndNil(result);

    finally
      query.Close;
      query.Free;
    end;

   end;

{ ============================================================================ }

initialization
  unterFragenDatenbank := TUnterFragenDatenbank.Create(TPath.Combine(getHomePath(), CONTENT_URI_TASKCONTENTREL));

{ ============================================================================ }


finalization
  unterFragenDatenbank.Free;


end.

