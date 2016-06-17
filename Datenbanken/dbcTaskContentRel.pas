unit dbcTaskContentRel;



//  **************************************************************
//   Projekt         : PLANB
//   Modul           : dbcTaskContentRel
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
  
  TTaskContentRelRec = record
    
      IDContent: Integer;
      Inhalt: string;
    
  end;
  
  TTaskContentRel = class
    private
      taskContentRelRec: TTaskContentRelRec;
      //DA-START:TTaskContentRel.additional.private.members.in.class:DA-START
      //DA-ELSE:TTaskContentRel.additional.private.members.in.class:DA-ELSE
      //DA-END:TTaskContentRel.additional.private.members.in.class:DA-END
    
    strict private
      //DA-START:TTaskContentRel.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TTaskContentRel.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TTaskContentRel.additional.strict.private.members.in.class:DA-END
    
    protected
      //DA-START:TTaskContentRel.additional.protected.members.in.class:DA-START
      //DA-ELSE:TTaskContentRel.additional.protected.members.in.class:DA-ELSE
      //DA-END:TTaskContentRel.additional.protected.members.in.class:DA-END
    
    strict protected
      //DA-START:TTaskContentRel.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TTaskContentRel.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TTaskContentRel.additional.strict.protected.members.in.class:DA-END
    
    public
      constructor Create;
      property IDContent : Integer read taskContentRelRec.IDContent write taskContentRelRec.IDContent;
      property Inhalt : string read taskContentRelRec.Inhalt write taskContentRelRec.Inhalt;
      //DA-START:TTaskContentRel.additional.public.members.in.class:DA-START
      //DA-ELSE:TTaskContentRel.additional.public.members.in.class:DA-ELSE
      //DA-END:TTaskContentRel.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TTaskContentRel.additional.published.members.in.class:DA-START
      //DA-ELSE:TTaskContentRel.additional.published.members.in.class:DA-ELSE
      //DA-END:TTaskContentRel.additional.published.members.in.class:DA-END
    
  end;
  
  TdbTaskContentRel = class
    private
      fDBFieldIDContent: TField;
      fDBFieldInhalt: TField;
      function getQuery: IHQDataset;
      function getNextID: Integer;
      procedure SetDBFieldVariables(query: IHQDataset);
      procedure closeAndClearQuery(var query: IHQDataset);
      //DA-START:TdbTaskContentRel.additional.private.members.in.class:DA-START
      //DA-ELSE:TdbTaskContentRel.additional.private.members.in.class:DA-ELSE
      //DA-END:TdbTaskContentRel.additional.private.members.in.class:DA-END
    
    strict private
      //DA-START:TdbTaskContentRel.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TdbTaskContentRel.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TdbTaskContentRel.additional.strict.private.members.in.class:DA-END
    
    protected
      procedure setzeQueryFelderFromRec(query: IHQDataset; taskcontentrel: TTaskContentRel);
      //DA-START:TdbTaskContentRel.additional.protected.members.in.class:DA-START
      //DA-ELSE:TdbTaskContentRel.additional.protected.members.in.class:DA-ELSE
      //DA-END:TdbTaskContentRel.additional.protected.members.in.class:DA-END
    
    strict protected
      //DA-START:TdbTaskContentRel.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TdbTaskContentRel.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TdbTaskContentRel.additional.strict.protected.members.in.class:DA-END
    
    public
      function laden: IHQDataset;
      procedure setzeRecFromFelder(taskcontentrel: TTaskContentRel);
      function speichern(taskcontentrel: TTaskContentRel): Boolean;
      function loeschen(IDContent: Integer): Boolean;
      function ladenZu(IDContent: Integer): IHQDataset;
      //DA-START:TdbTaskContentRel.additional.public.members.in.class:DA-START
      //DA-ELSE:TdbTaskContentRel.additional.public.members.in.class:DA-ELSE
      //DA-END:TdbTaskContentRel.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TdbTaskContentRel.additional.published.members.in.class:DA-START
      //DA-ELSE:TdbTaskContentRel.additional.published.members.in.class:DA-ELSE
      //DA-END:TdbTaskContentRel.additional.published.members.in.class:DA-END
    
  end;
  

const
  (*   TODO: Tabellennamen evtl. projektspezifisch anpassen
   *)
  //DA-START:dbcTaskContentRel.constant.tab_taskcontentrel:DA-START
  //DA-ELSE:dbcTaskContentRel.constant.tab_taskcontentrel:DA-ELSE
  TAB_TASKCONTENTREL = 'TAB_TaskContentRel';
  //DA-END:dbcTaskContentRel.constant.tab_taskcontentrel:DA-END


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
constructor TTaskContentRel.Create;
   begin
     taskContentRelRec.IDContent := -1;
     taskContentRelRec.Inhalt := '';
   end;


//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Stellt Query (projektspezifisch) bereit, die für DB-Kommunikation verwendet wird
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbTaskContentRel.getQuery: IHQDataset;
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
function TdbTaskContentRel.getNextID: Integer;
var query : IHQDataset;
   begin
    Result := -1;
    query := getQuery;
    try
      closeAndClearQuery(query);
      query.SQL.Text  := 'select max(IDContent) from ' + TAB_TASKCONTENTREL;
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
procedure TdbTaskContentRel.SetDBFieldVariables(query: IHQDataset);
   begin
    fDBFieldIDContent :=  query.FieldByName('IDContent');
    fDBFieldInhalt :=  query.FieldByName('Inhalt');
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Schließt die query und leert den SQL-Text
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
procedure TdbTaskContentRel.closeAndClearQuery(var query: IHQDataset);
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
procedure TdbTaskContentRel.setzeQueryFelderFromRec(query: IHQDataset; taskcontentrel: TTaskContentRel);
   begin
    query.ParamByName('IDContent').AsInteger := taskcontentrel.IDContent;
    query.ParamByName('Inhalt').AsString := taskcontentrel.Inhalt;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : liefert eine geöffnete Query zurück, die alle Datensätze enthält.  
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbTaskContentRel.laden: IHQDataset;
var query : IHQDataset;
   begin
    query := getQuery;
    closeAndClearQuery(query);
    query.SQL.Text := 'SELECT * FROM ' +  TAB_TASKCONTENTREL;
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
procedure TdbTaskContentRel.setzeRecFromFelder(taskcontentrel: TTaskContentRel);
   begin
    taskcontentrel.IDContent := fDBFieldIDContent.AsInteger;
    taskcontentrel.Inhalt := fDBFieldInhalt.AsString;
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
function TdbTaskContentRel.speichern(taskcontentrel: TTaskContentRel): Boolean;

const SQL_INSERT = 'INSERT INTO ' + TAB_TASKCONTENTREL 
                 + ' ( IDCONTENT,  INHALT) '
                 + ' VALUES '
                 + ' ( :IDContent,  :Inhalt) ';

const SQL_UPDATE = 'UPDATE ' + TAB_TASKCONTENTREL 
					+ ' SET ' 
					+ ' INHALT = :Inhalt  ' 
         	  		+ ' WHERE IDContent = :IDContent ';

var query : IHQDataset;
   begin
    query := getQuery;
    try
      closeAndClearQuery(query);
      if taskcontentrel.IDContent < 0 then
         begin
          taskcontentrel.IDContent := getNextID;
          query.SQL.Text := SQL_INSERT;
         end
      else
         begin
          query.SQL.Text := SQL_UPDATE;
         end;

      setzeQueryFelderFromRec(query, taskcontentrel);
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
function TdbTaskContentRel.loeschen(IDContent: Integer): Boolean;

const SQL = 'DELETE FROM ' + TAB_TASKCONTENTREL + ' WHERE 	IDContent = :IDContent' ;
var query : IHQDataset;
   begin
    query := getQuery;
    Result := False;
    try
      if ( (IDContent <> -1)) then
         begin
          closeAndClearQuery(query);
          query.SQL.Text := SQL;
          query.ParamByName('IDContent').AsInteger := IDContent;

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
function TdbTaskContentRel.ladenZu(IDContent: Integer): IHQDataset;
var query : IHQDataset;
   begin
    query := getQuery;
    closeAndClearQuery(query);
    query.SQL.Text := 'SELECT * FROM ' +  TAB_TASKCONTENTREL + ' WHERE ';
    query.SQL.Text := query.SQL.Text + 'IDContent  =: IDContent ';
    query.ParamByName('IDContent').AsInteger := IDContent;

    query.Open;
    SetDBFieldVariables(query);
    Result := query;
   end;


initialization
  //DA-START:dbcTaskContentRel.additional.initializations.in.unit:DA-START
  //DA-ELSE:dbcTaskContentRel.additional.initializations.in.unit:DA-ELSE
  //DA-END:dbcTaskContentRel.additional.initializations.in.unit:DA-END
finalization
  //DA-START:dbcTaskContentRel.additional.finalizations.in.unit:DA-START
  //DA-ELSE:dbcTaskContentRel.additional.finalizations.in.unit:DA-ELSE
  //DA-END:dbcTaskContentRel.additional.finalizations.in.unit:DA-END
end.
