unit dbcTask;



//  **************************************************************
//   Projekt         : PLANB
//   Modul           : dbcTask
//  --------------------------------------------------------------
//   Autor(en)       : 
//   Beginn-Datum    : 17.06.2016
//   Generierung     : 17.06.2016 um 15:30 Uhr
//  --------------------------------------------------------------
//   Beschreibung    : 
//  --------------------------------------------------------------
//   copyright (c) 2016 ff. highQ Computerlösungen GmbH
//   Alle Rechte vorbehalten.
//  **************************************************************


//  **************************************************************
//   Änderungs-Protokoll:
//  --------------------------------------------------------------
//   wann                 wer   was
//  --------------------------------------------------------------



{================================================================}
interface
{================================================================}

uses 
  DB, 
  PlanBKEPServer;

type
  
  TTaskRec = record
    
      IDTask: Integer;
      TaskName: string;
      TaskInfo: string;
      Erledigt: Boolean;
    
  end;
  
  TTask = class
    private
      taskRec: TTaskRec;
      //DA-START:TTask.additional.private.members.in.class:DA-START
      //DA-ELSE:TTask.additional.private.members.in.class:DA-ELSE
      //DA-END:TTask.additional.private.members.in.class:DA-END
    
    strict private
      //DA-START:TTask.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TTask.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TTask.additional.strict.private.members.in.class:DA-END
    
    protected
      //DA-START:TTask.additional.protected.members.in.class:DA-START
      //DA-ELSE:TTask.additional.protected.members.in.class:DA-ELSE
      //DA-END:TTask.additional.protected.members.in.class:DA-END
    
    strict protected
      //DA-START:TTask.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TTask.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TTask.additional.strict.protected.members.in.class:DA-END
    
    public
      constructor Create;
      property IDTask : Integer read taskRec.IDTask write taskRec.IDTask;
      property TaskName : string read taskRec.TaskName write taskRec.TaskName;
      property TaskInfo : string read taskRec.TaskInfo write taskRec.TaskInfo;
      property Erledigt : Boolean read taskRec.Erledigt write taskRec.Erledigt;
      //DA-START:TTask.additional.public.members.in.class:DA-START
      //DA-ELSE:TTask.additional.public.members.in.class:DA-ELSE
      //DA-END:TTask.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TTask.additional.published.members.in.class:DA-START
      //DA-ELSE:TTask.additional.published.members.in.class:DA-ELSE
      //DA-END:TTask.additional.published.members.in.class:DA-END
    
  end;
  
  TdbTask = class
    private
      fDBFieldIDTask: TField;
      fDBFieldTaskName: TField;
      fDBFieldTaskInfo: TField;
      fDBFieldErledigt: TField;
      function getQuery: IHQDataset;
      function getNextID: Integer;
      procedure SetDBFieldVariables(query: IHQDataset);
      procedure closeAndClearQuery(var query: IHQDataset);
      //DA-START:TdbTask.additional.private.members.in.class:DA-START
      //DA-ELSE:TdbTask.additional.private.members.in.class:DA-ELSE
      //DA-END:TdbTask.additional.private.members.in.class:DA-END
    
    strict private
      //DA-START:TdbTask.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TdbTask.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TdbTask.additional.strict.private.members.in.class:DA-END
    
    protected
      procedure setzeQueryFelderFromRec(query: IHQDataset; task: TTask);
      //DA-START:TdbTask.additional.protected.members.in.class:DA-START
      //DA-ELSE:TdbTask.additional.protected.members.in.class:DA-ELSE
      //DA-END:TdbTask.additional.protected.members.in.class:DA-END
    
    strict protected
      //DA-START:TdbTask.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TdbTask.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TdbTask.additional.strict.protected.members.in.class:DA-END
    
    public
      function laden: IHQDataset;
      procedure setzeRecFromFelder(task: TTask);
      function speichern(task: TTask): Boolean;
      function loeschen(IDTask: Integer): Boolean;
      function ladenZu(IDTask: Integer): IHQDataset;
      //DA-START:TdbTask.additional.public.members.in.class:DA-START
      //DA-ELSE:TdbTask.additional.public.members.in.class:DA-ELSE
      //DA-END:TdbTask.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TdbTask.additional.published.members.in.class:DA-START
      //DA-ELSE:TdbTask.additional.published.members.in.class:DA-ELSE
      //DA-END:TdbTask.additional.published.members.in.class:DA-END
    
  end;
  

const
  (*   TODO: Tabellennamen evtl. projektspezifisch anpassen
   *)
  //DA-START:dbcTask.constant.tab_task:DA-START
  //DA-ELSE:dbcTask.constant.tab_task:DA-ELSE
  TAB_TASK = 'TAB_Task';
  //DA-END:dbcTask.constant.tab_task:DA-END


{================================================================}
implementation
{================================================================}

uses 
  SysUtils;


//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Initialisiert das Record mit (-1) Integer bzw. '' String
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
constructor TTask.Create;
   begin
     taskRec.IDTask := -1;
     taskRec.TaskName := '';
     taskRec.TaskInfo := '';
     taskRec.Erledigt := False;
   end;


//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Stellt Query (projektspezifisch) bereit, die für DB-Kommunikation verwendet wird
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbTask.getQuery: IHQDataset;
   begin
    Result := Bollserver.neuePlanBQuery();
    if not assigned(Result) then
       begin
        //Exception
       end;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Ermittelt die nächste ID aus der DB-Tabelle (TODO: ggf. projektspezifisch anpassen)
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbTask.getNextID: Integer;
var query : IHQDataset;
   begin
    Result := -1;
    query := getQuery;
    try
      closeAndClearQuery(query);
      query.SQL.Text  := 'select max(IDTask) from ' + TAB_TASK;
      query.Open;
      query.First;
      if not query.Eof then
         begin
          Result := Succ(query.Fields[0].AsInteger);
         end;
    finally
      query.Close;
    end;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : setzt die Felder aus der übergebenen Query - 
//  	dient zur Performance-Optimierung und macht wiederholtes 
//  	Aufrufen von FieldByName überflüssig
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
procedure TdbTask.SetDBFieldVariables(query: IHQDataset);
   begin
    fDBFieldIDTask :=  query.FieldByName('IDTask');
    fDBFieldTaskName :=  query.FieldByName('TaskName');
    fDBFieldTaskInfo :=  query.FieldByName('TaskInfo');
    fDBFieldErledigt :=  query.FieldByName('Erledigt');
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Schließt die query und leert den SQL-Text
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
procedure TdbTask.closeAndClearQuery(var query: IHQDataset);
   begin      
    if query.Active then 
       begin
        query.Close;
       end;
    query.SQL.Clear;
   end;


//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : setzt Query-Felder aus gegebenem Record 
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
procedure TdbTask.setzeQueryFelderFromRec(query: IHQDataset; task: TTask);
   begin
    query.ParamByName('IDTask').AsInteger := task.IDTask;
    query.ParamByName('TaskName').AsString := task.TaskName;
    query.ParamByName('TaskInfo').AsString := task.TaskInfo;
    query.ParamByName('Erledigt').AsBoolean := task.Erledigt;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : liefert eine geöffnete Query zurück, die alle Datensätze enthält.  
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbTask.laden: IHQDataset;
var query : IHQDataset;
   begin
    query := getQuery;
    closeAndClearQuery(query);
    query.SQL.Text := 'SELECT * FROM ' +  TAB_TASK;
	query.Open;
	SetDBFieldVariables(query);
	Result := query;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Setzt Record Felder aus vorher gefüllten Feldern
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
procedure TdbTask.setzeRecFromFelder(task: TTask);
   begin
    task.IDTask := fDBFieldIDTask.AsInteger;
    task.TaskName := fDBFieldTaskName.AsString;
    task.TaskInfo := fDBFieldTaskInfo.AsString;
    task.Erledigt := fDBFieldErledigt.AsVariant;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Speichert den angegebenen Datensatz in der DB. 
//		Falls ein Datensatz mit entsprechendem primary key schon in der Datenbank vorhanden ist, wird der UPDATE-Befehl ausgeführt,
//		falls die noch kein Datensatz mit diesem primary key vorhanden bzw. die ID = -1 ist, wird ein neuer Datensatz mit INSERT erzeugt.
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbTask.speichern(task: TTask): Boolean;

const SQL_INSERT = 'INSERT INTO ' + TAB_TASK 
                 + ' ( IDTASK,  TASKNAME,  TASKINFO,  ERLEDIGT) '
                 + ' VALUES '
                 + ' ( :IDTask,  :TaskName,  :TaskInfo,  :Erledigt) ';

const SQL_UPDATE = 'UPDATE ' + TAB_TASK 
					+ ' SET ' 
					+ ' TASKNAME = :TaskName ,  ' 
					+ ' TASKINFO = :TaskInfo ,  ' 
					+ ' ERLEDIGT = :Erledigt  ' 
         	  		+ ' WHERE IDTask = :IDTask ';

var query : IHQDataset;
   begin
    query := getQuery;
    try
      closeAndClearQuery(query);
      if task.IDTask < 0 then
         begin
          task.IDTask := getNextID;
          query.SQL.Text := SQL_INSERT;
         end
      else
         begin
          query.SQL.Text := SQL_UPDATE;
         end;

      setzeQueryFelderFromRec(query, task);
      query.ExecSQL;
      Result := True;
    finally
      query.Close;
    end;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Löscht den Datensatz zur angegebenen ID aus der Datenbank
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbTask.loeschen(IDTask: Integer): Boolean;

const SQL = 'DELETE FROM ' + TAB_TASK + ' WHERE 	IDTask = :IDTask' ;
var query : IHQDataset;
   begin
    query := getQuery;
    Result := False;
    try
      if ( (IDTask <> -1)) then
         begin
          closeAndClearQuery(query);
          query.SQL.Text := SQL;
          query.ParamByName('IDTask').AsInteger := IDTask;

          query.ExecSQL;
          Result := True;
         end;
    finally
      query.Close;
    end;
   end;


//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : liefert eine geöffnete Query zurück, die alle Datensätze zu den angegeben Kriterien enthält. 
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbTask.ladenZu(IDTask: Integer): IHQDataset;
var query : IHQDataset;
   begin
    query := getQuery;
    closeAndClearQuery(query);
    query.SQL.Text := 'SELECT * FROM ' +  TAB_TASK + ' WHERE ';
    query.SQL.Text := query.SQL.Text + 'IDTask  =: IDTask ';
    query.ParamByName('IDTask').AsInteger := IDTask;

    query.Open;
    SetDBFieldVariables(query);
    Result := query;
   end;


initialization
  //DA-START:dbcTask.additional.initializations.in.unit:DA-START
  //DA-ELSE:dbcTask.additional.initializations.in.unit:DA-ELSE
  //DA-END:dbcTask.additional.initializations.in.unit:DA-END
finalization
  //DA-START:dbcTask.additional.finalizations.in.unit:DA-START
  //DA-ELSE:dbcTask.additional.finalizations.in.unit:DA-ELSE
  //DA-END:dbcTask.additional.finalizations.in.unit:DA-END
end.
