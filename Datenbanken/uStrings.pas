unit uStrings;

interface


uses
  Uni,
  UTableBase,
  System.Generics.Collections;
type
  TString = class(TEntityBase)
  private // Felder private, durch property veröffentlichen
    fId: Integer;
    fStringKey: string;
    fTextDE: string;
    fTextEN: string;
    fTextFR: string;
  public
    property id: integer read fID write fID;
    property StringKey: string read fStringKey write fStringKey;
    property textDE: string read fTextDE write fTextDE;
    property textEN: string read fTextEN write fTextEN;
    property textFR: string read fTextFR write fTextFR;

    procedure fillFields(query: TUniQuery);
    procedure addToDatabase;

    procedure fillParamsOfQuery(query: TUniQuery); override;
  end;

  TStringDatenbank = class(TTableBase)
  public
    constructor Create(const Database: string);
//    procedure addToDatabase(Attribut: TAttribut);
    procedure updateByStringId(str: TString);
    function sucheEintraege(Suche: String): TObjectList<TString>;
    function getAllAttribute: TList<TString>;
    procedure deleteByStringKey(stringKey: string);
    function getLastString: TString;
    function get(const stringKey: string): TString;

    function getTableName: String; override;
    procedure getColumnNames(columnList: TList<String>);override;

    const cTABLE_NAME = 'Strings';
    const cID = 'id';
    const cSTRINGKEY = 'stringkey';
    const cTEXTDE = 'textDE';
    const cTEXTEN = 'textEN';
    const cTEXTFR = 'textFR';
  end;

var StringDatenbank: TStringDatenbank;


implementation

uses uSQLConnection,System.SysUtils,System.IOUtils;

const
  AUTHORITY = '';
  BASE_PATH_STRINGS = 'Strings';
  CONTENT_URI_STRINGS = BASE_PATH_STRINGS ;

{ ============================================================================ }

constructor TStringDatenbank.Create(const Database: string);
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
       cSTRINGKEY + ' TEXT NOT NULL, ' +
       cTEXTDE+ ' TEXT NOT NULL, ' +
       cTEXTEN+ ' TEXT NOT NULL, ' +
       cTEXTFR+ ' TEXT NOT NULL' + ')');
  end;

{ ============================================================================ }

procedure TStringDatenbank.getColumnNames(columnList: TList<String>);
   begin
    columnList.Add(cID);
    columnList.Add(cSTRINGKEY);
    columnList.Add(cTEXTDE);
    columnList.Add(cTEXTEN);
    columnList.Add(cTEXTFR);

   end;

{ ============================================================================ }

function TStringDatenbank.getTableName: String;
   begin
    result := cTABLE_NAME;
   end;

{ ============================================================================ }

procedure TString.fillFields(query: TUniQuery);
   begin
    id := query.FieldByName(StringDatenbank.cID).AsInteger;
    stringKey := query.FieldByName(StringDatenbank.cSTRINGKEY).AsString;
    textDE := query.FieldByName(StringDatenbank.cTEXTDE).AsString;
    textEN := query.FieldByName(StringDatenbank.cTEXTEN).AsString;
    textFR := query.FieldByName(StringDatenbank.cTEXTFR).AsString;

   end;

{ ============================================================================ }

procedure TString.fillParamsOfQuery(query: TUniQuery);
   begin
    query.ParamByName(StringDatenbank.cID).asInteger := id;
    query.ParamByName(StringDatenbank.cSTRINGKEY).asString := stringKey;
    query.ParamByName(StringDatenbank.cTEXTDE).asString := textDE;
    query.ParamByName(StringDatenbank.cTEXTDE).asString := textEN;
    query.ParamByName(StringDatenbank.cTEXTDE).asString := textFR;
   end;

{ ============================================================================ }

procedure TStringDatenbank.updateByStringId(str: TString);
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

function TStringDatenbank.sucheEintraege(Suche: String): TObjectList<TString>;
  var
    query: TUniQuery;
    tmpObj: TString;
    tmpSQL: String;
   begin
    result := TObjectList<TString>.Create(True);
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
        tmpObj := TString.Create;
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

function TStringDatenbank.get(const stringKey: string): TString;
   var
    List: TList<TString>;
   begin
    List := sucheEintraege(cSTRINGKEY + '=' + stringKey);
    try
      if List.Count = 1 then result := List.Extract(List.First)
      else result := nil;
    finally
      List.Free;
    end;
   end;

{ ============================================================================ }

function TStringDatenbank.getAllAttribute: TList<TString>;
   begin
    result := sucheEintraege('');
   end;

{ ============================================================================ }

procedure TString.addToDatabase;
   var
    tmpAttribut: TString;
   begin
    StringDatenbank.addToDatabase(Self);
    tmpAttribut := StringDatenbank.getLasTString;
    try
      id := tmpAttribut.id;
    finally
      tmpAttribut.Free;
    end;
   end;

{ ============================================================================ }

procedure TStringDatenbank.DeleteByStringKey(stringKey: string);
   begin
    Delete(cSTRINGKEY+'='+#39+stringKey+#39);
   end;

{ ============================================================================ }

function TStringDatenbank.getLastString: TString;
   var
    query: TUniQuery;
  begin
    result := TString.Create;
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
  StringDatenbank := TStringDatenbank.Create(TPath.Combine(getHomePath(), CONTENT_URI_STRINGS));

{ ============================================================================ }


finalization
  StringDatenbank.Free;


end.

