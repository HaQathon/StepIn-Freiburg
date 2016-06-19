unit uTableBase;

interface

uses
  uSQLConnection,

  Uni,

  System.SysUtils,
  System.Generics.Collections,

  REST.Json.Types;


type
  TEntityBase = class
    procedure fillParamsOfQuery(query: TUniQuery); virtual; abstract;
  end;


  TTableBase = class abstract(TInterfacedObject)
  protected
    fSQLConnection: TSQLConnection;
    constructor Create(SQLCon: TSQLConnection);
    class function buildWhere(keyValueList: TDictionary<String, String>): String;


    function getAllColumnNames: String;
    function getAllColumnParams: String;
    function getInsertSQL: String;
    function getAllColumnsWithParams: String;

    // Abstract Functions
    function getTableName: String; virtual;abstract;
//    procedure fillParamsOfQuery(query: TUniQuery); virtual;abstract;
  public
//    procedure fillFields(query: TUniQuery); virtual;abstract;
    procedure getColumnNames(columnList: TList<String>); virtual;abstract;

    procedure Delete(Where: String);
    procedure addToDatabase(Entity: TEntityBase);
//    procedure insertEntity();
//    procedure updateEntity();

    // Class Functions
    class function getInstance<T: class, constructor>(const connection
       : TSQLConnection): T;
//    class function findLast<T: class, constructor>(SQLConnection
//       : TSQLConnection): T;
//    class function search<T: class, constructor>(keyValueDictionary
//      : TDictionary<String, String>; SQLConnection: TSQLConnection): TList<T>;
//    class function searchText<T: class, constructor>(Suche: String; SQLConnection: TSQLConnection): TList<T>;
//    class function searchFirstText<T: class, constructor>(Suche: String; SQLConnection: TSQLConnection): T;
  end;

implementation

uses
  RTTI;

{ ============================================================================ }

constructor TTableBase.Create(SQLCon: TSQLConnection);
   begin
    fSQLConnection := SQLCon;
   end;

{ ============================================================================ }

function TTableBase.getInsertSQL: String;
  begin
    result := 'INSERT INTO ' + getTableName() + ' (' + getAllColumnNames() +
       ') values(' + getAllColumnParams() + ');';
  end;

{ ============================================================================ }

procedure TTableBase.addToDatabase(Entity: TEntityBase);
   var
    query: TUniQuery;
   begin

    query := TUniQuery.Create(nil);
    query.connection := fSQLConnection;
    try
      query.SQL.Text := getInsertSQL;
      query.Prepare;

      Entity.fillParamsOfQuery(query);

      query.Execute;
    finally
      query.Close;
      query.Free;
    end;
   end;

{ ============================================================================ }

procedure TTableBase.Delete(Where: String);
  var
    query: TUniQuery;
    tmpSQL: String;
   begin
    query := TUniQuery.Create(nil);
    try
      query.connection := FSQLConnection;
      tmpSQL := 'Delete From ' + getTableName;
      if Where<>'' then
        tmpSQL := tmpSQL + ' WHERE ' + Where;

      query.SQL.Text := tmpSQL;
      query.ExecSQL;

      query.Execute;
    finally
      query.Close;
      query.Free;
    end;
   end;

//procedure TTableBase.insertEntity();
//  var
//    query: TUniQuery;
//  begin
//
//    query := TUniQuery.Create(nil);
//    query.connection := fSQLConnection;
//
//    try
//      query.SQL.Text := getInsertSQL;
//      query.Prepare;
//
//      fillParamsOfQuery(query);
//
//      query.Execute;
//    finally
//      query.Close;
//      query.Free;
//    end;
//  end;

{ ============================================================================ }

function TTableBase.getAllColumnsWithParams: String;
  var
    columnList: TList<String>;
    i1: Integer;
  begin
    columnList := TList<String>.Create;
    try
      result := '';
      getColumnNames(columnList);
      for i1 := 1 to pred(columnList.Count) do
      begin
        result := result + columnList[i1] + '=:' + columnList[i1];
        if (i1 < pred(columnList.Count)) then
        begin
          result := result + ',';
        end;
      end;
    finally
      columnList.Free;
    end;
  end;

{ ============================================================================ }

function TTableBase.getAllColumnNames: String;
  var
    columnList: TList<String>;
    i1: Integer;
  begin
    columnList := TList<String>.Create;
    try
      result := '';
      getColumnNames(columnList);

      // From 1 because without clientID (is set automatically)
      for i1 := 1 to pred(columnList.Count) do
      begin
        result := result + columnList[i1];
        if (i1 < pred(columnList.Count)) then
        begin
          result := result + ',';
        end;
      end;
    finally
      columnList.Free;
    end;
  end;

{ ============================================================================ }

function TTableBase.getAllColumnParams: String;
  var
    columnList: TList<String>;
    i1: Integer;
  begin
    columnList := TList<String>.Create;
    try
      result := '';
      getColumnNames(columnList);

      // From 1 because without clientID (is set automatically)
      for i1 := 1 to pred(columnList.Count) do
      begin
        result := result + ':' + columnList[i1];
        if (i1 < pred(columnList.Count)) then
        begin
          result := result + ',';
        end;
      end;
    finally
      columnList.Free;
    end;
  end;

{ ============================================================================ }

class function TTableBase.getInstance<T>(const connection: TSQLConnection): T;
  var
    Context: TRttiContext;
    ClassType: TRttiType;
  begin
    Context := TRttiContext.Create;
    try
      ClassType := Context.GetType(T);

      result := T(ClassType.GetMethod('Create')
         .Invoke(ClassType.AsInstance.MetaclassType, [connection]).AsObject);
    finally
      Context.Free;
    end;
  end;

{ ============================================================================ }

class function TTableBase.buildWhere(keyValueList
   : TDictionary<String, String>): String;
  var
    res: String;
    i1: Integer;
    key: String;
  begin
    res := '';
    i1 := 0;
    for key in keyValueList.Keys do
    begin
      res := res + key + '=' + keyValueList[key];
      if (i1 < pred(keyValueList.Count)) then
      begin
        res := res + ' AND ';
      end;
      inc(i1);
    end;
    result := res;
  end;

{ ============================================================================ }

//class function TTableBase.findLast<T>(SQLConnection: TSQLConnection): T;
//  var
//    query: TUniQuery;
//    res: T;
//  begin
//    res := getInstance<T>(SQLConnection);
//    query := TUniQuery.Create(nil);
//
//    try
//      query.connection := SQLConnection;
//      query.SQL.Text := 'SELECT * FROM ' + TTableBase(res).getTableName +
//         ' ORDER BY ID DESC LIMIT 1';
//      query.Open;
//
//      if query.RecordCount = 1 then
//      begin
//        TTableBase(res).fillFields(query);
//      end
//      else
//        FreeAndNil(res);
//
//      result := res;
//    finally
//      query.Close;
//      query.Free;
//    end;
//  end;

{ ============================================================================ }

//class function TTableBase.search<T>(keyValueDictionary
//   : TDictionary<String, String>; SQLConnection: TSQLConnection): TList<T>;
//  var
//   text :String;
//  begin
//   text := '';
//   if Assigned(keyValueDictionary) then
//     text := buildWhere(keyValueDictionary);
//
//   result := searchText<T>(text, SQLConnection);
//
//  end;
//
//
//{ ============================================================================ }
//class function TTableBase.searchText<T>(Suche: String; SQLConnection: TSQLConnection): TList<T>;
//  var
//    query: TUniQuery;
//    tmpObj: T;
//    tmp: T;
//    tmpSQL: String;
//   begin
//    result := TList<T>.Create;
//    query := TUniQuery.Create(nil);
//    tmp := getInstance<T>(SQLConnection);
//
//    try
//      query.connection := SQLConnection;
//      tmpSQL := 'SELECT * FROM ' + TTableBase(tmp).getTableName;
//      if Suche<>'' then
//        tmpSQL := tmpSQL + ' WHERE ' + Suche;
//
//
//      query.SQL.Text := tmpSQL;
//      query.Open;
//
//      while not(query.Eof) do
//      begin
//        tmpObj := getInstance<T>(SQLConnection);
//        TTableBase(tmpObj).fillFields(query);
//        result.Add(tmpObj);
//        query.Next;
//      end;
//    finally
//      tmp.Free;
//      query.Close;
//      query.Free;
//    end;
//   end;
//
//{ ============================================================================ }
//
//class function TTableBase.searchFirstText<T>(Suche: String; SQLConnection: TSQLConnection): T;
//  var
//    query: TUniQuery;
//    tmp: T;
//    tmpSQL: String;
//   begin
////    result := T.Create; // Um wenn nicht gefunden auf Assigned prüfen zu können
//    query := TUniQuery.Create(nil);
//    tmp := getInstance<T>(SQLConnection);
//
//    try
//      query.connection := SQLConnection;
//      tmpSQL := 'SELECT * FROM ' + TTableBase(tmp).getTableName;
//      if Suche<>'' then
//        tmpSQL := tmpSQL + ' WHERE ' + Suche + ' LIMIT 1';
//
//
//      query.SQL.Text := tmpSQL;
//      query.Open;
//
//      if not(query.Eof) then
//      begin
//        result := getInstance<T>(SQLConnection);
//        TTableBase(result).fillFields(query);
//      end;
//    finally
//      tmp.Free;
//      query.Close;
//      query.Free;
//    end;
//   end;

{ ============================================================================ }




end.

