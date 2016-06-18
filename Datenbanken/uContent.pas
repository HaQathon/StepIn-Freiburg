unit uContent;

interface

uses
  Uni,
  UTableBase,
  System.Generics.Collections;
type
  TContent = class(TEntityBase)
  private // Felder private, durch property veröffentlichen
    fId: Integer;
    fTaskID: Integer;
    fcontent: String;

  public
    property id: integer read fID write fID;
    property taskID: integer read fTaskID write fTaskID;
    property content: String read fcontent write fcontent;

    procedure fillFields(query: TUniQuery);
    procedure addToDatabase;

    procedure fillParamsOfQuery(query: TUniQuery); override;
  end;

  TContentDatenbank = class(TTableBase)
  public
    constructor Create(const Database: string);
//    procedure addToDatabase(Attribut: TAttribut);
    procedure updateByContentId(TaskContent: TContent);
    function sucheEintraege(Suche: String): TObjectList<TContent>;
    function getAllContent: TList<TContent>;
    procedure deleteByContentId(contentId: integer);
    function getLastTaskContentRel: TContent;
    function get(const ID: Integer): TContent;

    function getTableName: String;override;
    procedure getColumnNames(columnList: TList<String>);override;

    const cTABLE_NAME = 'Content';
    const cID = 'id';
    const cTASK_ID = 'taskID';
    const cContent = 'content';
  end;

var ContentDatenbank: TContentDatenbank;


implementation

uses uSQLConnection,System.SysUtils,System.IOUtils;

const
  AUTHORITY = '';
  BASE_PATH_TASKCONTENTREL = 'Content';
  CONTENT_URI_TASKCONTENTREL= BASE_PATH_TASKCONTENTREL ;

{ ============================================================================ }

constructor TContentDatenbank.Create(const Database: string);
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
       cContent + ' Text NOT NULL' + ')');
  end;

{ ============================================================================ }

procedure TContentDatenbank.getColumnNames(columnList: TList<String>);
   begin
    columnList.Add(cID);
    columnList.Add(cTASK_ID);
    columnList.Add(cContent);
   end;

{ ============================================================================ }

function TContentDatenbank.getTableName: String;
   begin
    result := cTABLE_NAME;
   end;

{ ============================================================================ }

procedure TContent.fillFields(query: TUniQuery);
   begin
    id := query.FieldByName(ContentDatenbank.cID).AsInteger;
    taskID := query.FieldByName(ContentDatenbank.cTASK_ID).AsInteger;
    content := query.FieldByName(ContentDatenbank.cContent).AsString;

   end;

{ ============================================================================ }

procedure TContent.fillParamsOfQuery(query: TUniQuery);
   begin
    query.ParamByName(ContentDatenbank.cID).AsInteger := id;
    query.ParamByName(ContentDatenbank.cTASK_ID).AsInteger := taskID;
    query.ParamByName(ContentDatenbank.cContent).AsString  := content;
   end;

{ ============================================================================ }

procedure TContentDatenbank.updateByContentId(TaskContent: TContent);
  var
    query: TUniQuery;
  begin

    query := TUniQuery.Create(nil);
    query.connection := fSQLConnection;

    try
      query.SQL.Text := 'UPDATE ' + cTABLE_NAME + ' SET ' + getAllColumnsWithParams +
       ' WHERE ' + cID + '=:' + cID;;
      query.Prepare;

      query.ParamByName(cID).AsInteger := TaskContent.id;
      TaskContent.fillParamsOfQuery(query);

      query.Execute;
    finally
      query.Close;
      query.Free;
    end;
  end;

{ ============================================================================ }

function TContentDatenbank.sucheEintraege(Suche: String): TObjectList<TContent>;
  var
    query: TUniQuery;
    tmpObj: TContent;
    tmpSQL: String;
   begin
    result := TObjectList<TContent>.Create(True);
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
        tmpObj := TContent.Create;
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

function TContentDatenbank.get(const ID: Integer): TContent;
   var
    List: TList<TContent>;
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

function TContentDatenbank.getAllContent: TList<TContent>;
   begin
    result := sucheEintraege('');
   end;

{ ============================================================================ }

procedure TContent.addToDatabase;
   var
    tmpTaskContentRel: TContent;
   begin
    ContentDatenbank.addToDatabase(Self);
    tmpTaskContentRel := ContentDatenbank.getLastTaskContentRel;
    try
      id := tmpTaskContentRel.id;
    finally
      tmpTaskContentRel.Free;
    end;
   end;

{ ============================================================================ }

procedure TContentDatenbank.deleteByContentId(contentId: integer);
   begin
    Delete(cID+'='+#39+contentId.ToString+#39);
   end;

{ ============================================================================ }

function TContentDatenbank.getLastTaskContentRel: TContent;
   var
    query: TUniQuery;
  begin
    result := TContent.Create;
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
  ContentDatenbank := TContentDatenbank.Create(TPath.Combine(getHomePath(), CONTENT_URI_TASKCONTENTREL));

{ ============================================================================ }


finalization
  ContentDatenbank.Free;


end.

