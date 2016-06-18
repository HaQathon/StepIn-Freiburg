unit uTaskContentRel;

interface

uses
  Uni,
  UTableBase,
  System.Generics.Collections,
  uAttribut;
type
  TTaskContentRel = class(TEntityBase)
  private // Felder private, durch property veröffentlichen
    fId: Integer;
    fTaskID: Integer;
    fAttributID: Integer;

  public
    property id: integer read fID write fID;
    property taskID: integer read fTaskID write fTaskID;
    property attributID: integer read fAttributID write fAttributID;

    procedure fillFields(query: TUniQuery);
    procedure addToDatabase;

    procedure fillParamsOfQuery(query: TUniQuery); override;
  end;

  TTaskContentRelDatenbank = class(TTableBase)
  public
    constructor Create(const Database: string);
//    procedure addToDatabase(Attribut: TAttribut);
    procedure updateByAttributRelId(AttributRel: TTaskContentRel);
    function sucheEintraege(Suche: String): TObjectList<TTaskContentRel>;
    function getAllAttribute: TList<TTaskContentRel>;
    procedure deleteByAttributRelId(attributRelId: integer);
    function getLastAttributRel: TTaskContentRel;
    function get(const ID: Integer): TTaskContentRel;

    function getTableName: String;override;
    procedure getColumnNames(columnList: TList<String>);override;

    const cTABLE_NAME = 'AttributRel';
    const cID = 'id';
    const cTASK_ID = 'taskID';
    const cATTRIBUT_ID = 'attributID';
  end;

var taskContentRelDatenbank: TTaskContentRelDatenbank;


implementation

uses uSQLConnection,System.SysUtils,System.IOUtils;

const
  AUTHORITY = '';
  BASE_PATH_ATTRIBUTREL = 'AttributRel';
  CONTENT_URI_ATTRIBUTREL = BASE_PATH_ATTRIBUTREL ;

{ ============================================================================ }

constructor TTaskContentRelDatenbank.Create(const Database: string);
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
       cTASK_ID+ ' INTEGER NOT NULL, ' +
       cATTRIBUT_ID + ' INTEGER NOT NULL' + ')');
  end;

{ ============================================================================ }

procedure TTaskContentRelDatenbank.getColumnNames(columnList: TList<String>);
   begin
    columnList.Add(cID);
    columnList.Add(cTASK_ID);
    columnList.Add(cATTRIBUT_ID);
   end;

{ ============================================================================ }

function TTaskContentRelDatenbank.getTableName: String;
   begin
    result := cTABLE_NAME;
   end;

{ ============================================================================ }

procedure TTaskContentRel.fillFields(query: TUniQuery);
   begin
    id := query.FieldByName(taskContentRelDatenbank.cID).AsInteger;
    taskID := query.FieldByName(taskContentRelDatenbank.cTASK_ID).AsInteger;
    attributID := query.FieldByName(taskContentRelDatenbank.cATTRIBUT_ID).AsInteger;

   end;

{ ============================================================================ }

procedure TTaskContentRel.fillParamsOfQuery(query: TUniQuery);
   begin
    query.ParamByName(taskContentRelDatenbank.cID).AsInteger := id;
    query.ParamByName(taskContentRelDatenbank.cTASK_ID).AsInteger := taskID;
    query.ParamByName(taskContentRelDatenbank.cATTRIBUT_ID).AsInteger := attributID;
   end;

{ ============================================================================ }

procedure TTaskContentRelDatenbank.updateByAttributRelId(AttributRel: TTaskContentRel);
  var
    query: TUniQuery;
  begin

    query := TUniQuery.Create(nil);
    query.connection := fSQLConnection;

    try
      query.SQL.Text := 'UPDATE ' + cTABLE_NAME + ' SET ' + getAllColumnsWithParams +
       ' WHERE ' + cID + '=:' + cID;;
      query.Prepare;

      query.ParamByName(cID).AsInteger := AttributRel.id;
      AttributRel.fillParamsOfQuery(query);

      query.Execute;
    finally
      query.Close;
      query.Free;
    end;
  end;

{ ============================================================================ }

function TTaskContentRelDatenbank.sucheEintraege(Suche: String): TObjectList<TTaskContentRel>;
  var
    query: TUniQuery;
    tmpObj: TTaskContentRel;
    tmpSQL: String;
   begin
    result := TObjectList<TTaskContentRel>.Create(True);
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
        tmpObj := TTaskContentRel.Create;
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

function TTaskContentRelDatenbank.get(const ID: Integer): TTaskContentRel;
   var
    List: TList<TTaskContentRel>;
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

function TTaskContentRelDatenbank.getAllAttribute: TList<TTaskContentRel>;
   begin
    result := sucheEintraege('');
   end;

{ ============================================================================ }

procedure TTaskContentRel.addToDatabase;
   var
    tmpTaskContentRel: TTaskContentRel;
   begin
    taskContentRelDatenbank.addToDatabase(Self);
    tmpTaskContentRel := taskContentRelDatenbank.getLastAttributRel;
    try
      id := tmpTaskContentRel.id;
    finally
      tmpTaskContentRel.Free;
    end;
   end;

{ ============================================================================ }

procedure TTaskContentRelDatenbank.DeleteByAttributRelId(attributRelId: integer);
   begin
    Delete(cID+'='+#39+attributRelId.ToString+#39);
   end;

{ ============================================================================ }

function TTaskContentRelDatenbank.getLastAttributRel: TTaskContentRel;
   var
    query: TUniQuery;
  begin
    result := TTaskContentRel.Create;
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
  taskContentRelDatenbank := TTaskContentRelDatenbank.Create(TPath.Combine(getHomePath(), CONTENT_URI_ATTRIBUTREL));

{ ============================================================================ }


finalization
  taskContentRelDatenbank.Free;


end.

