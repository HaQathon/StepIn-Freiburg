unit uTask;

interface

uses
  Uni,
  UTableBase,
  System.Generics.Collections;
type
  TTask = class(TEntityBase)
  private // Felder private, durch property veröffentlichen
    fId: Integer;
    fTaskName: string;
    fTaskInfo: string;
    fErledigt: integer;
  public
    property id: integer read fID write fID;
    property taskName: string read fTaskname write fTaskName;
    property taskInfo: string read fTaskInfo write fTaskInfo;
    property erledigt: integer read fErledigt write fErledigt;

    procedure fillFields(query: TUniQuery);
    procedure addToDatabase;
    function Copy: TTask;

    procedure fillParamsOfQuery(query: TUniQuery);
  end;

  TTaskDatenbank = class(TTableBase)
  public
    constructor Create(const Database: string);
//    procedure addToDatabase(Task: TTask);
    procedure updateByTaskId(task: TTask);
    function sucheEintraege(Suche: String): TObjectList<TTask>;
    function getAllTasks: TList<TTask>;
    procedure deleteByTaskId(TaskId: integer);
    function getLasTTask: TTask;
    function get(const ID: Integer): TTask;

    function getTableName: String;override;
    procedure getColumnNames(columnList: TList<String>);override;

    const cTABLE_NAME = 'Tasks';
    const cID = 'id';
    const cTASK_NAME = 'taskName';
    const cTASK_INFO = 'taskInfo';
    const cERLEDIGT = 'erledigt';
  end;

var
  TaskDatenbank: TTaskDatenbank;


implementation

uses
  uSQLConnection,
  System.SysUtils,
  System.IOUtils;

const
  AUTHORITY = '';
  BASE_PATH_TASK = 'task';
  CONTENT_URI_TASK = BASE_PATH_TASK;

{ ============================================================================ }

constructor TTaskDatenbank.Create(const Database: string);
var str: string;
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
       cTASK_NAME + ' TEXT NOT NULL, ' +
       cTASK_INFO + ' TEXT NOT NULL, ' +
       cERLEDIGT + ' INTEGER NOT NULL' + ')');
  end;

{ ============================================================================ }

procedure TTaskDatenbank.getColumnNames(columnList: TList<String>);
   begin
    columnList.Add(cID);
    columnList.Add(cTASK_NAME);
    columnList.Add(cTASK_INFO);
    columnList.Add(cERLEDIGT);
   end;

{ ============================================================================ }

function TTaskDatenbank.getTableName: String;
   begin
    result := cTABLE_NAME;
   end;

{ ============================================================================ }

procedure TTask.fillFields(query: TUniQuery);
   begin
    id := query.FieldByName(TaskDatenbank.cID).AsInteger;
    taskName := query.FieldByName(TaskDatenbank.cTASK_NAME).AsString;
    taskInfo := query.FieldByName(TaskDatenbank.cTASK_INFO).asString;
    erledigt := query.FieldByName(TaskDatenbank.cERLEDIGT).asInteger;

   end;

{ ============================================================================ }

procedure TTask.fillParamsOfQuery(query: TUniQuery);
   begin
    query.ParamByName(TaskDatenbank.cID).AsInteger := id;
    query.ParamByName(TaskDatenbank.cTASK_NAME).AsString := taskName;
    query.ParamByName(TaskDatenbank.cTASK_INFO).asString := taskInfo;
    query.ParamByName(TaskDatenbank.cERLEDIGT).asInteger := erledigt;
   end;

{ ============================================================================ }

procedure TTaskDatenbank.updateByTaskId(task: TTask);
  var
    query: TUniQuery;
  begin

    query := TUniQuery.Create(nil);
    query.connection := fSQLConnection;

    try
      query.SQL.Text := 'UPDATE ' + cTABLE_NAME + ' SET ' + getAllColumnsWithParams +
       ' WHERE ' + cID + '=:' + cID;;
      query.Prepare;

      query.ParamByName(cID).asInteger := task.id;
      task.fillParamsOfQuery(query);

      query.Execute;
    finally
      query.Close;
      query.Free;
    end;
  end;

{ ============================================================================ }

function TTaskDatenbank.sucheEintraege(Suche: String): TObjectList<TTask>;
  var
    query: TUniQuery;
    tmpObj: TTask;
    tmpSQL: String;
   begin
    result := TObjectList<TTask>.Create(True);
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
        tmpObj := TTask.Create;
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

function TTaskDatenbank.get(const ID: Integer): TTask;
   var
    List: TList<TTask>;
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

function TTaskDatenbank.getAllTasks: TList<TTask>;
   begin
    result := sucheEintraege('');
   end;

{ ============================================================================ }

procedure TTask.addToDatabase;
   var
    tmpTask: TTask;
   begin
    TaskDatenbank.addToDatabase(Self);
    tmpTask := TaskDatenbank.getLasTTask;
    try
      id := tmpTask.id;
    finally
      tmpTask.Free;
    end;
   end;

{ ============================================================================ }

procedure TTaskDatenbank.deleteByTaskId(taskId: integer);
   begin
    Delete(cID+'='+#39+taskId.ToString+#39);
   end;

{ ============================================================================ }

function TTaskDatenbank.getLastTask: TTask;
   var
    query: TUniQuery;
  begin
    result := TTask.Create;
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

function TTask.Copy: TTask;
   begin
    result := TTask.Create;
    result.id := id;
    result.taskName := taskName;
    result.taskInfo := taskInfo;
    result.erledigt := erledigt;

   end;

{ ============================================================================ }

initialization
  TaskDatenbank := TTaskDatenbank.Create(TPath.Combine(getHomePath(), CONTENT_URI_TASK));

{ ============================================================================ }


finalization
  TaskDatenbank.Free;


end.

