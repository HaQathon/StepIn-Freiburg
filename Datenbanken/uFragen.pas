unit uAttribut;
                                   
interface

uses
  Uni,
  UTableBase,
  System.Generics.Collections;
type
  TAttribut = class(TEntityBase)
  private // Felder private, durch property veröffentlichen
    fId: Integer;
    fAttributName: string;
    fVerwendet: Boolean;
  public
    property id: integer read fID write fID;
    property AttributName: string read fAttributname write fAttributName;
    property Verwendet: Boolean read fVerwendet write fVerwendet;

    procedure fillFields(query: TUniQuery);
    procedure addToDatabase;
    function Copy: TAttribut;

    procedure fillParamsOfQuery(query: TUniQuery); override;
  end;

  TAttributDatenbank = class(TTableBase)
  public
    constructor Create(const Database: string);
//    procedure addToDatabase(Attribut: TAttribut);
    procedure updateByAttributId(Attribut: TAttribut);
    function sucheEintraege(Suche: String): TObjectList<TAttribut>;
    function getAllAttribute: TList<TAttribut>;
    procedure deleteByAttributId(attributId: integer);
    function getLasTAttribut: TAttribut;
    function get(const ID: Integer): TAttribut;

    function getTableName: String;override;
    procedure getColumnNames(columnList: TList<String>);override;

    const cTABLE_NAME = 'Attribute';
    const cID = 'id';
    const cATTRIBUT_NAME = 'attributName';
    const cVERWENDET = 'verwendet';
  end;

var AttributDatenbank: TAttributDatenbank;


implementation

uses uSQLConnection,System.SysUtils,System.IOUtils;

const
  AUTHORITY = '';
  BASE_PATH_Attribut = 'Attribut';
  CONTENT_URI_ATTRIBUT = BASE_PATH_ATTRIBUT ;

{ ============================================================================ }

constructor TAttributDatenbank.Create(const Database: string);
   begin
{$ifdef Webservice}
    FSQLConnection := TSQLConnection.Create(ctmySQL);
{$else}
    FSQLConnection := TSQLConnection.Create(ctSQLite);
{$endif}
    FSQLConnection.Database := Database;

{$ifdef Webservice}

{$else}
    if not FileExists(FSQLConnection.Database) then
       begin
        FSQLConnection.SpecificOptions.Add('ForceCreateDatabase=true');
       end;
{$endif}

    FSQLConnection.Open;
{$ifdef Webservice}

{$else}
    FSQLConnection.ExecSQL('CREATE TABLE IF NOT EXISTS ' + cTABLE_NAME + ' ( ' +
       cID + ' INTEGER PRIMARY KEY AUTOINCREMENT, ' +
       cATTRIBUT_NAME + ' TEXT NOT NULL, ' +
       cVERWENDET + ' INTEGER NOT NULL' + ')');
{$endif}

  end;

{ ============================================================================ }

procedure TAttributDatenbank.getColumnNames(columnList: TList<String>);
   begin
    columnList.Add(cID);
    columnList.Add(cAttribut_NAME);
    columnList.Add(cVerwendet);
   end;

{ ============================================================================ }

function TAttributDatenbank.getTableName: String;
   begin
    result := cTABLE_NAME;
   end;

{ ============================================================================ }

procedure TAttribut.fillFields(query: TUniQuery);
   begin
    id := query.FieldByName(AttributDatenbank.cID).AsInteger;
    AttributName := query.FieldByName(AttributDatenbank.cAttribut_NAME).AsString;
{$ifdef Webservice}
    //brauchts aufm server net
{$else}
    Verwendet := query.FieldByName(AttributDatenbank.cVerwendet).AsBoolean;
{$endif}

   end;

{ ============================================================================ }

procedure TAttribut.fillParamsOfQuery(query: TUniQuery);
   begin
    query.ParamByName(AttributDatenbank.cID).AsInteger := id;
    query.ParamByName(AttributDatenbank.cAttribut_NAME).asString := AttributName;
{$ifdef Webservice}
    //brauchts aufm server net
{$else}
    query.ParamByName(AttributDatenbank.cVerwendet).AsBoolean := Verwendet;
{$endif}

   end;

{ ============================================================================ }

procedure TAttributDatenbank.updateByAttributId(Attribut: TAttribut);
  var
    query: TUniQuery;
  begin

    query := TUniQuery.Create(nil);
    query.connection := fSQLConnection;

    try
      query.SQL.Text := 'UPDATE ' + cTABLE_NAME + ' SET ' + getAllColumnsWithParams +
       ' WHERE ' + cID + '=:' + cID;;
      query.Prepare;

      query.ParamByName(cID).asinteger := Attribut.id;
      Attribut.fillParamsOfQuery(query);

      query.Execute;
    finally
      query.Close;
      query.Free;
    end;
  end;

{ ============================================================================ }

function TAttributDatenbank.sucheEintraege(Suche: String): TObjectList<TAttribut>;
  var
    query: TUniQuery;
    tmpObj: TAttribut;
    tmpSQL: String;
   begin
    result := TObjectList<TAttribut>.Create(True);
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
        tmpObj := TAttribut.Create;
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

function TAttributDatenbank.get(const ID: Integer): TAttribut;
   var
    List: TList<TAttribut>;
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

function TAttributDatenbank.getAllAttribute: TList<TAttribut>;
   begin
    result := sucheEintraege('');
   end;

{ ============================================================================ }

procedure TAttribut.addToDatabase;
   var
    tmpAttribut: TAttribut;
   begin
    AttributDatenbank.addToDatabase(Self);
    tmpAttribut := AttributDatenbank.getLastAttribut;
    try
      id := tmpAttribut.id;
    finally
      tmpAttribut.Free;
    end;
   end;

{ ============================================================================ }

procedure TAttributDatenbank.DeleteByAttributId(attributId: integer);
   begin
    Delete(cID+'='+#39+attributId.ToString+#39);
   end;

{ ============================================================================ }

function TAttributDatenbank.getLastAttribut: TAttribut;
   var
    query: TUniQuery;
  begin
    result := TAttribut.Create;
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

function TAttribut.Copy: TAttribut;
   begin
    result := TAttribut.Create;
    result.id := id;
    result.AttributName := AttributName;
    result.Verwendet := Verwendet;

   end;

{ ============================================================================ }

initialization
{$ifdef Webservice}
    AttributDatenbank := TAttributDatenbank.Create('STEPIN');
{$else}
    AttributDatenbank := TAttributDatenbank.Create(TPath.Combine(extractFilePath(paramStr(0)), CONTENT_URI_ATTRIBUT));
{$endif}

{ ============================================================================ }


finalization
  AttributDatenbank.Free;


end.

