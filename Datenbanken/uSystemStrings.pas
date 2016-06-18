unit uSystemStrings;

interface


uses
  Uni,
  UTableBase,
  System.Generics.Collections;
type
  TSystemString = class(TEntityBase)
  private // Felder private, durch property veröffentlichen
    fId: Integer;
    fKey: string;
    fTextDE: string;
    fTextEN: string;
    fTextFR: string;
  public
    property id: integer read fID write fID;
    property key: string read fKey write fKey;
    property textDE: string read fTextDE write fTextDE;
    property textEN: string read fTextEN write fTextEN;
    property textFR: string read fTextFR write fTextFR;

    procedure fillFields(query: TUniQuery);
    procedure addToDatabase;

    procedure fillParamsOfQuery(query: TUniQuery); override;
  end;

  TSystemStringDatenbank = class(TTableBase)
  public
    constructor Create(const Database: string);
//    procedure addToDatabase(Attribut: TAttribut);
    procedure updateBySystemStringId(str: TSystemString);
    function sucheEintraege(Suche: String): TObjectList<TSystemString>;
    function getAllAttribute: TList<TSystemString>;
    procedure deleteBySystemStringKey(key: string);
    function getLasTSystemString: TSystemString;
    function get(const key: string): TSystemString;

    function getTableName: String; override;
    procedure getColumnNames(columnList: TList<String>);override;

    const cTABLE_NAME = 'SystemStrings';
    const cID = 'id';
    const cKEY = 'key';
    const cTEXTDE = 'textDE';
    const cTEXTEN = 'textEN';
    const cTEXTFR = 'textFR';
  end;

var SystemStringDatenbank: TSystemStringDatenbank;


implementation

uses uSQLConnection,System.SysUtils,System.IOUtils;

const
  AUTHORITY = '';
  BASE_PATH_SYSTEMSTRINGS = 'SystemStrings';
  CONTENT_URI_SYSTEMSTRINGS = BASE_PATH_SYSTEMSTRINGS ;

{ ============================================================================ }

constructor TSystemStringDatenbank.Create(const Database: string);
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
       cKEY + ' TEXT NOT NULL, ' +
       cTEXTDE+ ' TEXT NOT NULL, ' +
       cTEXTEN+ ' TEXT NOT NULL, ' +
       cTEXTFR+ ' TEXT NOT NULL' + ')');
  end;

{ ============================================================================ }

procedure TSystemStringDatenbank.getColumnNames(columnList: TList<String>);
   begin
    columnList.Add(cID);
    columnList.Add(cKEY);
    columnList.Add(cTEXTDE);
    columnList.Add(cTEXTEN);
    columnList.Add(cTEXTFR);

   end;

{ ============================================================================ }

function TSystemStringDatenbank.getTableName: String;
   begin
    result := cTABLE_NAME;
   end;

{ ============================================================================ }

procedure TSystemString.fillFields(query: TUniQuery);
   begin
    id := query.FieldByName(SystemStringDatenbank.cID).AsInteger;
    key := query.FieldByName(SystemStringDatenbank.cKEY).AsString;
    textDE := query.FieldByName(SystemStringDatenbank.cTEXTDE).AsString;
    textEN := query.FieldByName(SystemStringDatenbank.cTEXTEN).AsString;
    textFR := query.FieldByName(SystemStringDatenbank.cTEXTFR).AsString;

   end;

{ ============================================================================ }

procedure TSystemString.fillParamsOfQuery(query: TUniQuery);
   begin
    query.ParamByName(SystemStringDatenbank.cID).asInteger := id;
    query.ParamByName(SystemStringDatenbank.cKEY).asString := key;
    query.ParamByName(SystemStringDatenbank.cTEXTDE).asString := textDE;
    query.ParamByName(SystemStringDatenbank.cTEXTDE).asString := textEN;
    query.ParamByName(SystemStringDatenbank.cTEXTDE).asString := textFR;
   end;

{ ============================================================================ }

procedure TSystemStringDatenbank.updateBySystemStringId(str: TSystemString);
  var
    query: TUniQuery;
  begin

    query := TUniQuery.Create(nil);
    query.connection := fSQLConnection;

    try
      query.SQL.Text := 'UPDATE ' + cTABLE_NAME + ' SET ' + getAllColumnsWithParams +
       ' WHERE ' + cID + '=:' + cID;;
      query.Prepare;

      query.ParamByName(cID).AsInteger := str.id;
      str.fillParamsOfQuery(query);

      query.Execute;
    finally
      query.Close;
      query.Free;
    end;
  end;

{ ============================================================================ }

function TSystemStringDatenbank.sucheEintraege(Suche: String): TObjectList<TSystemString>;
  var
    query: TUniQuery;
    tmpObj: TSystemString;
    tmpSQL: String;
   begin
    result := TObjectList<TSystemString>.Create(True);
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
        tmpObj := TSystemString.Create;
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

function TSystemStringDatenbank.get(const key: string): TSystemString;
   var
    List: TList<TSystemString>;
   begin
    List := sucheEintraege(cKEY + '=' + key);
    try
      if List.Count = 1 then result := List.Extract(List.First)
      else result := nil;
    finally
      List.Free;
    end;
   end;

{ ============================================================================ }

function TSystemStringDatenbank.getAllAttribute: TList<TSystemString>;
   begin
    result := sucheEintraege('');
   end;

{ ============================================================================ }

procedure TSystemString.addToDatabase;
   var
    tmpSystemString: TSystemString;
   begin
    SystemStringDatenbank.addToDatabase(Self);
    tmpSystemString := SystemStringDatenbank.getLastSystemString;
    try
      id := tmpSystemString.id;
    finally
      tmpSystemString.Free;
    end;
   end;

{ ============================================================================ }

procedure TSystemStringDatenbank.DeleteBySystemStringKey(key: string);
   begin
    Delete(cKEY+'='+#39+key+#39);
   end;

{ ============================================================================ }

function TSystemStringDatenbank.getLastSystemString: TSystemString;
   var
    query: TUniQuery;
  begin
    result := TSystemString.Create;
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
  SystemStringDatenbank := TSystemStringDatenbank.Create(TPath.Combine(extractFilePath(paramStr(0)), CONTENT_URI_SYSTEMSTRINGS));

{ ============================================================================ }


finalization
  SystemStringDatenbank.Free;


end.

