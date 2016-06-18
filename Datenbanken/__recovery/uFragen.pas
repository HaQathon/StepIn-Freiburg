unit uFragen;

interface

uses
  Uni,
  UTableBase,
  System.Generics.Collections;
type
  TFragen = class(TEntityBase)
  private // Felder private, durch property veröffentlichen
    fId: Integer;
    fFrage: String;

  public
    property id: integer read fID write fID;
    property Frage: String read fFrage write fFrage;

    procedure fillFields(query: TUniQuery);
    procedure addToDatabase;

    procedure fillParamsOfQuery(query: TUniQuery); override;
  end;

  TFragenDatenbank = class(TTableBase)
  public
    constructor Create(const Database: string);
//    procedure addToDatabase(Attribut: TAttribut);
    procedure updateByFragenID(AttributRel: TFragen);
    function sucheEintraege(Suche: String): TObjectList<TFragen>;
    function getAllFragen: TList<TFragen>;
    procedure deleteByFrageID(contentRelId: integer);
    function getLastFrage: TFragen;
    function get(const ID: Integer): TFragen;

    function getTableName: String;override;
    procedure getColumnNames(columnList: TList<String>);override;

    const cTABLE_NAME = 'Fragen';
    const cID = 'id';
    const cFragen = 'frage';
  end;

var FragenDatenbank: TFragenDatenbank;


implementation

uses uSQLConnection,System.SysUtils,System.IOUtils;

const
  AUTHORITY = '';
  BASE_PATH_TASKCONTENTREL = 'AttributRel';
  CONTENT_URI_TASKCONTENTREL= BASE_PATH_TASKCONTENTREL ;

{ ============================================================================ }

constructor TFragenDatenbank.Create(const Database: string);
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
       cFragen+ ' TEXT NOT NULL )' );
  end;

{ ============================================================================ }

procedure TFragenDatenbank.getColumnNames(columnList: TList<String>);
   begin
    columnList.Add(cID);
    columnList.Add(cFragen);
   end;

{ ============================================================================ }

function TFragenDatenbank.getTableName: String;
   begin
    result := cTABLE_NAME;
   end;

{ ============================================================================ }

procedure TFragen.fillFields(query: TUniQuery);
   begin
    id := query.FieldByName(FragenDatenbank.cID).AsInteger;
    Frage := query.FieldByName(FragenDatenbank.cFragen).AsString;
   end;

{ ============================================================================ }

procedure TFragen.fillParamsOfQuery(query: TUniQuery);
   begin
    //query.ParamByName(FragenDatenbank.cID).AsInteger := id;
    query.ParamByName(FragenDatenbank.cFragen).AsString := Frage;
   end;

{ ============================================================================ }

procedure TFragenDatenbank.updateByFragenID(AttributRel: TFragen);
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

function TFragenDatenbank.sucheEintraege(Suche: String): TObjectList<TFragen>;
  var
    query: TUniQuery;
    tmpObj: TFragen;
    tmpSQL: String;
   begin
    result := TObjectList<TFragen>.Create(True);
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
        tmpObj := TFragen.Create;
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

function TFragenDatenbank.get(const ID: Integer): TFragen;
   var
    List: TList<TFragen>;
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

function TFragenDatenbank.getAllFragen: TList<TFragen>;
   begin
    result := sucheEintraege('');
   end;

{ ============================================================================ }

procedure TFragen.addToDatabase;
   var
    tmpTaskContentRel: TFragen;
   begin
    FragenDatenbank.addToDatabase(Self);
    tmpTaskContentRel := FragenDatenbank.getLastFrage;
    try
      id := tmpTaskContentRel.id;
    finally
      tmpTaskContentRel.Free;
    end;
   end;

{ ============================================================================ }

procedure TFragenDatenbank.deleteByFrageID(contentRelId: integer);
   begin
    Delete(cID+'='+#39+contentRelId.ToString+#39);
   end;

{ ============================================================================ }

function TFragenDatenbank.getLastFrage: TFragen;
   var
    query: TUniQuery;
  begin
    result := TFragen.Create;
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
  FragenDatenbank := TFragenDatenbank.Create(TPath.Combine(getHomePath(), CONTENT_URI_TASKCONTENTREL));

{ ============================================================================ }


finalization
  FragenDatenbank.Free;


end.

