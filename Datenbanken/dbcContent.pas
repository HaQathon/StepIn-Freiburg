unit dbcContent;



//  **************************************************************
//   Projekt         : PLANB
//   Modul           : dbcContent
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
  
  TContentRec = record
    
      IDTaskContent: Integer;
      IDContent: Integer;
      IDTask: Integer;
    
  end;
  
  TContent = class
    private
      contentRec: TContentRec;
      //DA-START:TContent.additional.private.members.in.class:DA-START
      //DA-ELSE:TContent.additional.private.members.in.class:DA-ELSE
      //DA-END:TContent.additional.private.members.in.class:DA-END
    
    strict private
      //DA-START:TContent.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TContent.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TContent.additional.strict.private.members.in.class:DA-END
    
    protected
      //DA-START:TContent.additional.protected.members.in.class:DA-START
      //DA-ELSE:TContent.additional.protected.members.in.class:DA-ELSE
      //DA-END:TContent.additional.protected.members.in.class:DA-END
    
    strict protected
      //DA-START:TContent.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TContent.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TContent.additional.strict.protected.members.in.class:DA-END
    
    public
      constructor Create;
      property IDTaskContent : Integer read contentRec.IDTaskContent write contentRec.IDTaskContent;
      property IDContent : Integer read contentRec.IDContent write contentRec.IDContent;
      property IDTask : Integer read contentRec.IDTask write contentRec.IDTask;
      //DA-START:TContent.additional.public.members.in.class:DA-START
      //DA-ELSE:TContent.additional.public.members.in.class:DA-ELSE
      //DA-END:TContent.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TContent.additional.published.members.in.class:DA-START
      //DA-ELSE:TContent.additional.published.members.in.class:DA-ELSE
      //DA-END:TContent.additional.published.members.in.class:DA-END
    
  end;
  
  TdbContent = class
    private
      fDBFieldIDTaskContent: TField;
      fDBFieldIDContent: TField;
      fDBFieldIDTask: TField;
      function getQuery: IHQDataset;
      function getNextID: Integer;
      procedure SetDBFieldVariables(query: IHQDataset);
      procedure closeAndClearQuery(var query: IHQDataset);
      //DA-START:TdbContent.additional.private.members.in.class:DA-START
      //DA-ELSE:TdbContent.additional.private.members.in.class:DA-ELSE
      //DA-END:TdbContent.additional.private.members.in.class:DA-END
    
    strict private
      //DA-START:TdbContent.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TdbContent.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TdbContent.additional.strict.private.members.in.class:DA-END
    
    protected
      procedure setzeQueryFelderFromRec(query: IHQDataset; content: TContent);
      //DA-START:TdbContent.additional.protected.members.in.class:DA-START
      //DA-ELSE:TdbContent.additional.protected.members.in.class:DA-ELSE
      //DA-END:TdbContent.additional.protected.members.in.class:DA-END
    
    strict protected
      //DA-START:TdbContent.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TdbContent.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TdbContent.additional.strict.protected.members.in.class:DA-END
    
    public
      function laden: IHQDataset;
      procedure setzeRecFromFelder(content: TContent);
      function speichern(content: TContent): Boolean;
      function loeschen(IDTaskContent: Integer): Boolean;
      function ladenZu(IDTaskContent: Integer): IHQDataset;
      //DA-START:TdbContent.additional.public.members.in.class:DA-START
      //DA-ELSE:TdbContent.additional.public.members.in.class:DA-ELSE
      //DA-END:TdbContent.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TdbContent.additional.published.members.in.class:DA-START
      //DA-ELSE:TdbContent.additional.published.members.in.class:DA-ELSE
      //DA-END:TdbContent.additional.published.members.in.class:DA-END
    
  end;
  

const
  (*   TODO: Tabellennamen evtl. projektspezifisch anpassen
   *)
  //DA-START:dbcContent.constant.tab_content:DA-START
  //DA-ELSE:dbcContent.constant.tab_content:DA-ELSE
  TAB_CONTENT = 'TAB_Content';
  //DA-END:dbcContent.constant.tab_content:DA-END


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
constructor TContent.Create;
   begin
     contentRec.IDTaskContent := -1;
     contentRec.IDContent := -1;
     contentRec.IDTask := -1;
   end;


//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Stellt Query (projektspezifisch) bereit, die für DB-Kommunikation verwendet wird
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbContent.getQuery: IHQDataset;
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
function TdbContent.getNextID: Integer;
var query : IHQDataset;
   begin
    Result := -1;
    query := getQuery;
    try
      closeAndClearQuery(query);
      query.SQL.Text  := 'select max(IDTaskContent) from ' + TAB_CONTENT;
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
procedure TdbContent.SetDBFieldVariables(query: IHQDataset);
   begin
    fDBFieldIDTaskContent :=  query.FieldByName('IDTaskContent');
    fDBFieldIDContent :=  query.FieldByName('IDContent');
    fDBFieldIDTask :=  query.FieldByName('IDTask');
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Schließt die query und leert den SQL-Text
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
procedure TdbContent.closeAndClearQuery(var query: IHQDataset);
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
procedure TdbContent.setzeQueryFelderFromRec(query: IHQDataset; content: TContent);
   begin
    query.ParamByName('IDTaskContent').AsInteger := content.IDTaskContent;
    query.ParamByName('IDContent').AsInteger := content.IDContent;
    query.ParamByName('IDTask').AsInteger := content.IDTask;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : liefert eine geöffnete Query zurück, die alle Datensätze enthält.  
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbContent.laden: IHQDataset;
var query : IHQDataset;
   begin
    query := getQuery;
    closeAndClearQuery(query);
    query.SQL.Text := 'SELECT * FROM ' +  TAB_CONTENT;
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
procedure TdbContent.setzeRecFromFelder(content: TContent);
   begin
    content.IDTaskContent := fDBFieldIDTaskContent.AsInteger;
    content.IDContent := fDBFieldIDContent.AsInteger;
    content.IDTask := fDBFieldIDTask.AsInteger;
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
function TdbContent.speichern(content: TContent): Boolean;

const SQL_INSERT = 'INSERT INTO ' + TAB_CONTENT 
                 + ' ( IDTASKCONTENT,  IDCONTENT,  IDTASK) '
                 + ' VALUES '
                 + ' ( :IDTaskContent,  :IDContent,  :IDTask) ';

const SQL_UPDATE = 'UPDATE ' + TAB_CONTENT 
					+ ' SET ' 
					+ ' IDCONTENT = :IDContent ,  ' 
					+ ' IDTASK = :IDTask  ' 
         	  		+ ' WHERE IDTaskContent = :IDTaskContent ';

var query : IHQDataset;
   begin
    query := getQuery;
    try
      closeAndClearQuery(query);
      if content.IDTaskContent < 0 then
         begin
          content.IDTaskContent := getNextID;
          query.SQL.Text := SQL_INSERT;
         end
      else
         begin
          query.SQL.Text := SQL_UPDATE;
         end;

      setzeQueryFelderFromRec(query, content);
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
function TdbContent.loeschen(IDTaskContent: Integer): Boolean;

const SQL = 'DELETE FROM ' + TAB_CONTENT + ' WHERE 	IDTaskContent = :IDTaskContent' ;
var query : IHQDataset;
   begin
    query := getQuery;
    Result := False;
    try
      if ( (IDTaskContent <> -1)) then
         begin
          closeAndClearQuery(query);
          query.SQL.Text := SQL;
          query.ParamByName('IDTaskContent').AsInteger := IDTaskContent;

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
function TdbContent.ladenZu(IDTaskContent: Integer): IHQDataset;
var query : IHQDataset;
   begin
    query := getQuery;
    closeAndClearQuery(query);
    query.SQL.Text := 'SELECT * FROM ' +  TAB_CONTENT + ' WHERE ';
    query.SQL.Text := query.SQL.Text + 'IDTaskContent  =: IDTaskContent ';
    query.ParamByName('IDTaskContent').AsInteger := IDTaskContent;

    query.Open;
    SetDBFieldVariables(query);
    Result := query;
   end;


initialization
  //DA-START:dbcContent.additional.initializations.in.unit:DA-START
  //DA-ELSE:dbcContent.additional.initializations.in.unit:DA-ELSE
  //DA-END:dbcContent.additional.initializations.in.unit:DA-END
finalization
  //DA-START:dbcContent.additional.finalizations.in.unit:DA-START
  //DA-ELSE:dbcContent.additional.finalizations.in.unit:DA-ELSE
  //DA-END:dbcContent.additional.finalizations.in.unit:DA-END
end.
