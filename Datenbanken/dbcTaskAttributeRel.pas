unit dbcTaskAttributeRel;



//  **************************************************************
//   Projekt         : PLANB
//   Modul           : dbcTaskAttributeRel
//  --------------------------------------------------------------
//   Autor(en)       : 
//   Beginn-Datum    : 17.06.2016
//   Generierung     : 17.06.2016 um 15:30 Uhr
//  --------------------------------------------------------------
//   Beschreibung    : 
//  --------------------------------------------------------------
//   copyright (c) 2016 ff. highQ Computerl�sungen GmbH
//   Alle Rechte vorbehalten.
//  **************************************************************


//  **************************************************************
//   �nderungs-Protokoll:
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
  
  TTaskAttributeRelRec = record
    
      IDTaskAttribute: Integer;
      IDTask: Integer;
      AttributeID: Integer;
    
  end;
  
  TTaskAttributeRel = class
    private
      taskAttributeRelRec: TTaskAttributeRelRec;
      //DA-START:TTaskAttributeRel.additional.private.members.in.class:DA-START
      //DA-ELSE:TTaskAttributeRel.additional.private.members.in.class:DA-ELSE
      //DA-END:TTaskAttributeRel.additional.private.members.in.class:DA-END
    
    strict private
      //DA-START:TTaskAttributeRel.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TTaskAttributeRel.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TTaskAttributeRel.additional.strict.private.members.in.class:DA-END
    
    protected
      //DA-START:TTaskAttributeRel.additional.protected.members.in.class:DA-START
      //DA-ELSE:TTaskAttributeRel.additional.protected.members.in.class:DA-ELSE
      //DA-END:TTaskAttributeRel.additional.protected.members.in.class:DA-END
    
    strict protected
      //DA-START:TTaskAttributeRel.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TTaskAttributeRel.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TTaskAttributeRel.additional.strict.protected.members.in.class:DA-END
    
    public
      constructor Create;
      property IDTaskAttribute : Integer read taskAttributeRelRec.IDTaskAttribute write taskAttributeRelRec.IDTaskAttribute;
      property IDTask : Integer read taskAttributeRelRec.IDTask write taskAttributeRelRec.IDTask;
      property AttributeID : Integer read taskAttributeRelRec.AttributeID write taskAttributeRelRec.AttributeID;
      //DA-START:TTaskAttributeRel.additional.public.members.in.class:DA-START
      //DA-ELSE:TTaskAttributeRel.additional.public.members.in.class:DA-ELSE
      //DA-END:TTaskAttributeRel.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TTaskAttributeRel.additional.published.members.in.class:DA-START
      //DA-ELSE:TTaskAttributeRel.additional.published.members.in.class:DA-ELSE
      //DA-END:TTaskAttributeRel.additional.published.members.in.class:DA-END
    
  end;
  
  TdbTaskAttributeRel = class
    private
      fDBFieldIDTaskAttribute: TField;
      fDBFieldIDTask: TField;
      fDBFieldAttributeID: TField;
      function getQuery: IHQDataset;
      function getNextID: Integer;
      procedure SetDBFieldVariables(query: IHQDataset);
      procedure closeAndClearQuery(var query: IHQDataset);
      //DA-START:TdbTaskAttributeRel.additional.private.members.in.class:DA-START
      //DA-ELSE:TdbTaskAttributeRel.additional.private.members.in.class:DA-ELSE
      //DA-END:TdbTaskAttributeRel.additional.private.members.in.class:DA-END
    
    strict private
      //DA-START:TdbTaskAttributeRel.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TdbTaskAttributeRel.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TdbTaskAttributeRel.additional.strict.private.members.in.class:DA-END
    
    protected
      procedure setzeQueryFelderFromRec(query: IHQDataset; taskattributerel: TTaskAttributeRel);
      //DA-START:TdbTaskAttributeRel.additional.protected.members.in.class:DA-START
      //DA-ELSE:TdbTaskAttributeRel.additional.protected.members.in.class:DA-ELSE
      //DA-END:TdbTaskAttributeRel.additional.protected.members.in.class:DA-END
    
    strict protected
      //DA-START:TdbTaskAttributeRel.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TdbTaskAttributeRel.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TdbTaskAttributeRel.additional.strict.protected.members.in.class:DA-END
    
    public
      function laden: IHQDataset;
      procedure setzeRecFromFelder(taskattributerel: TTaskAttributeRel);
      function speichern(taskattributerel: TTaskAttributeRel): Boolean;
      function loeschen(IDTaskAttribute: Integer): Boolean;
      function ladenZu(IDTaskAttribute: Integer): IHQDataset;
      //DA-START:TdbTaskAttributeRel.additional.public.members.in.class:DA-START
      //DA-ELSE:TdbTaskAttributeRel.additional.public.members.in.class:DA-ELSE
      //DA-END:TdbTaskAttributeRel.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TdbTaskAttributeRel.additional.published.members.in.class:DA-START
      //DA-ELSE:TdbTaskAttributeRel.additional.published.members.in.class:DA-ELSE
      //DA-END:TdbTaskAttributeRel.additional.published.members.in.class:DA-END
    
  end;
  

const
  (*   TODO: Tabellennamen evtl. projektspezifisch anpassen
   *)
  //DA-START:dbcTaskAttributeRel.constant.tab_taskattributerel:DA-START
  //DA-ELSE:dbcTaskAttributeRel.constant.tab_taskattributerel:DA-ELSE
  TAB_TASKATTRIBUTEREL = 'TAB_TaskAttributeRel';
  //DA-END:dbcTaskAttributeRel.constant.tab_taskattributerel:DA-END


{================================================================}
implementation
{================================================================}

uses 
  SysUtils;


//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Initialisiert das Record mit (-1) Integer bzw. '' String
//  �nderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
constructor TTaskAttributeRel.Create;
   begin
     taskAttributeRelRec.IDTaskAttribute := -1;
     taskAttributeRelRec.IDTask := -1;
     taskAttributeRelRec.AttributeID := -1;
   end;


//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Stellt Query (projektspezifisch) bereit, die f�r DB-Kommunikation verwendet wird
//  �nderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbTaskAttributeRel.getQuery: IHQDataset;
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
//  Beschreibung : Ermittelt die n�chste ID aus der DB-Tabelle (TODO: ggf. projektspezifisch anpassen)
//  �nderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbTaskAttributeRel.getNextID: Integer;
var query : IHQDataset;
   begin
    Result := -1;
    query := getQuery;
    try
      closeAndClearQuery(query);
      query.SQL.Text  := 'select max(IDTaskAttribute) from ' + TAB_TASKATTRIBUTEREL;
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
//  Beschreibung : setzt die Felder aus der �bergebenen Query - 
//  	dient zur Performance-Optimierung und macht wiederholtes 
//  	Aufrufen von FieldByName �berfl�ssig
//  �nderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
procedure TdbTaskAttributeRel.SetDBFieldVariables(query: IHQDataset);
   begin
    fDBFieldIDTaskAttribute :=  query.FieldByName('IDTaskAttribute');
    fDBFieldIDTask :=  query.FieldByName('IDTask');
    fDBFieldAttributeID :=  query.FieldByName('AttributeID');
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Schlie�t die query und leert den SQL-Text
//  �nderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
procedure TdbTaskAttributeRel.closeAndClearQuery(var query: IHQDataset);
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
//  �nderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
procedure TdbTaskAttributeRel.setzeQueryFelderFromRec(query: IHQDataset; taskattributerel: TTaskAttributeRel);
   begin
    query.ParamByName('IDTaskAttribute').AsInteger := taskattributerel.IDTaskAttribute;
    query.ParamByName('IDTask').AsInteger := taskattributerel.IDTask;
    query.ParamByName('AttributeID').AsInteger := taskattributerel.AttributeID;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : liefert eine ge�ffnete Query zur�ck, die alle Datens�tze enth�lt.  
//  �nderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbTaskAttributeRel.laden: IHQDataset;
var query : IHQDataset;
   begin
    query := getQuery;
    closeAndClearQuery(query);
    query.SQL.Text := 'SELECT * FROM ' +  TAB_TASKATTRIBUTEREL;
	query.Open;
	SetDBFieldVariables(query);
	Result := query;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Setzt Record Felder aus vorher gef�llten Feldern
//  �nderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
procedure TdbTaskAttributeRel.setzeRecFromFelder(taskattributerel: TTaskAttributeRel);
   begin
    taskattributerel.IDTaskAttribute := fDBFieldIDTaskAttribute.AsInteger;
    taskattributerel.IDTask := fDBFieldIDTask.AsInteger;
    taskattributerel.AttributeID := fDBFieldAttributeID.AsInteger;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Speichert den angegebenen Datensatz in der DB. 
//		Falls ein Datensatz mit entsprechendem primary key schon in der Datenbank vorhanden ist, wird der UPDATE-Befehl ausgef�hrt,
//		falls die noch kein Datensatz mit diesem primary key vorhanden bzw. die ID = -1 ist, wird ein neuer Datensatz mit INSERT erzeugt.
//  �nderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbTaskAttributeRel.speichern(taskattributerel: TTaskAttributeRel): Boolean;

const SQL_INSERT = 'INSERT INTO ' + TAB_TASKATTRIBUTEREL 
                 + ' ( IDTASKATTRIBUTE,  IDTASK,  ATTRIBUTEID) '
                 + ' VALUES '
                 + ' ( :IDTaskAttribute,  :IDTask,  :AttributeID) ';

const SQL_UPDATE = 'UPDATE ' + TAB_TASKATTRIBUTEREL 
					+ ' SET ' 
					+ ' IDTASK = :IDTask ,  ' 
					+ ' ATTRIBUTEID = :AttributeID  ' 
         	  		+ ' WHERE IDTaskAttribute = :IDTaskAttribute ';

var query : IHQDataset;
   begin
    query := getQuery;
    try
      closeAndClearQuery(query);
      if taskattributerel.IDTaskAttribute < 0 then
         begin
          taskattributerel.IDTaskAttribute := getNextID;
          query.SQL.Text := SQL_INSERT;
         end
      else
         begin
          query.SQL.Text := SQL_UPDATE;
         end;

      setzeQueryFelderFromRec(query, taskattributerel);
      query.ExecSQL;
      Result := True;
    finally
      query.Close;
    end;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : L�scht den Datensatz zur angegebenen ID aus der Datenbank
//  �nderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbTaskAttributeRel.loeschen(IDTaskAttribute: Integer): Boolean;

const SQL = 'DELETE FROM ' + TAB_TASKATTRIBUTEREL + ' WHERE 	IDTaskAttribute = :IDTaskAttribute' ;
var query : IHQDataset;
   begin
    query := getQuery;
    Result := False;
    try
      if ( (IDTaskAttribute <> -1)) then
         begin
          closeAndClearQuery(query);
          query.SQL.Text := SQL;
          query.ParamByName('IDTaskAttribute').AsInteger := IDTaskAttribute;

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
//  Beschreibung : liefert eine ge�ffnete Query zur�ck, die alle Datens�tze zu den angegeben Kriterien enth�lt. 
//  �nderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbTaskAttributeRel.ladenZu(IDTaskAttribute: Integer): IHQDataset;
var query : IHQDataset;
   begin
    query := getQuery;
    closeAndClearQuery(query);
    query.SQL.Text := 'SELECT * FROM ' +  TAB_TASKATTRIBUTEREL + ' WHERE ';
    query.SQL.Text := query.SQL.Text + 'IDTaskAttribute  =: IDTaskAttribute ';
    query.ParamByName('IDTaskAttribute').AsInteger := IDTaskAttribute;

    query.Open;
    SetDBFieldVariables(query);
    Result := query;
   end;


initialization
  //DA-START:dbcTaskAttributeRel.additional.initializations.in.unit:DA-START
  //DA-ELSE:dbcTaskAttributeRel.additional.initializations.in.unit:DA-ELSE
  //DA-END:dbcTaskAttributeRel.additional.initializations.in.unit:DA-END
finalization
  //DA-START:dbcTaskAttributeRel.additional.finalizations.in.unit:DA-START
  //DA-ELSE:dbcTaskAttributeRel.additional.finalizations.in.unit:DA-ELSE
  //DA-END:dbcTaskAttributeRel.additional.finalizations.in.unit:DA-END
end.
