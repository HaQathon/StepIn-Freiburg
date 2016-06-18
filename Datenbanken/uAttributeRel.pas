unit uAttributeRel;

interface

uses
  Uni,
  UTableBase,
  System.Generics.Collections,
  uAttribut;
type
  TAttributRel = class(TEntityBase)
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

  TAttributRelDatenbank = class(TTableBase)
  public
    constructor Create(const Database: string);
//    procedure addToDatabase(Attribut: TAttribut);
    procedure updateByAttributRelId(AttributRel: TAttributRel);
    function sucheEintraege(Suche: String): TObjectList<TAttributRel>;
    function getAllAttribute: TList<TAttributRel>;
    procedure deleteByAttributRelId(attributRelId: integer);
    function getLastAttributRel: TAttributRel;
    function get(const ID: Integer): TAttributRel;

    function getTableName: String;override;
    procedure getColumnNames(columnList: TList<String>);override;

    const cTABLE_NAME = 'AttributRel';
    const cID = 'id';
    const cTASK_ID = 'taskID';
    const cATTRIBUT_ID = 'attributID';
  end;

var AttributRelDatenbank: TAttributRelDatenbank;


implementation

uses uSQLConnection,System.SysUtils,System.IOUtils;

const
  AUTHORITY = '';
  BASE_PATH_ATTRIBUTREL = 'AttributRel';
  CONTENT_URI_ATTRIBUTREL = BASE_PATH_ATTRIBUTREL ;

{ ============================================================================ }

constructor TAttributRelDatenbank.Create(const Database: string);
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

procedure TAttributRelDatenbank.getColumnNames(columnList: TList<String>);
   begin
    columnList.Add(cID);
    columnList.Add(cTASK_ID);
    columnList.Add(cATTRIBUT_ID);
   end;

{ ============================================================================ }

function TAttributRelDatenbank.getTableName: String;
   begin
    result := cTABLE_NAME;
   end;

{ ============================================================================ }

procedure TAttributRel.fillFields(query: TUniQuery);
   begin
    id := query.FieldByName(AttributRelDatenbank.cID).AsInteger;
    taskID := query.FieldByName(AttributRelDatenbank.cTASK_ID).AsInteger;
    attributID := query.FieldByName(AttributRelDatenbank.cATTRIBUT_ID).AsInteger;

   end;

{ ============================================================================ }

procedure TAttributRel.fillParamsOfQuery(query: TUniQuery);
   begin
    query.ParamByName(AttributRelDatenbank.cID).AsInteger := id;
    query.ParamByName(AttributRelDatenbank.cTASK_ID).AsInteger := taskID;
    query.ParamByName(AttributRelDatenbank.cATTRIBUT_ID).AsInteger := attributID;
   end;

{ ============================================================================ }

procedure TAttributRelDatenbank.updateByAttributRelId(AttributRel: TAttributRel);
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

function TAttributRelDatenbank.sucheEintraege(Suche: String): TObjectList<TAttributRel>;
  var
    query: TUniQuery;
    tmpObj: TAttributRel;
    tmpSQL: String;
   begin
    result := TObjectList<TAttributRel>.Create(True);
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
        tmpObj := TAttributRel.Create;
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

function TAttributRelDatenbank.get(const ID: Integer): TAttributRel;
   var
    List: TList<TAttributRel>;
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

function TAttributRelDatenbank.getAllAttribute: TList<TAttributRel>;
   begin
    result := sucheEintraege('');
   end;

{ ============================================================================ }

procedure TAttributRel.addToDatabase;
   var
    tmpAttributRel: TAttributRel;
   begin
    AttributRelDatenbank.addToDatabase(Self);
    tmpAttributRel := AttributRelDatenbank.getLastAttributRel;
    try
      id := tmpAttributRel.id;
    finally
      tmpAttributRel.Free;
    end;
   end;

{ ============================================================================ }

procedure TAttributRelDatenbank.DeleteByAttributRelId(attributRelId: integer);
   begin
    Delete(cID+'='+#39+attributRelId.ToString+#39);
   end;

{ ============================================================================ }

function TAttributRelDatenbank.getLastAttributRel: TAttributRel;
   var
    query: TUniQuery;
  begin
    result := TAttributRel.Create;
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
  AttributRelDatenbank := TAttributRelDatenbank.Create(TPath.Combine(extractFilePath(paramStr(0)), CONTENT_URI_ATTRIBUTREL));

{ ============================================================================ }


finalization
  AttributRelDatenbank.Free;


end.

