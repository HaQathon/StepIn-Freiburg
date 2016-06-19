unit dbcSystemStrings;



//  **************************************************************
//   Projekt         : PLANB
//   Modul           : dbcSystemStrings
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
  
  TSystemStringsRec = record
    
      IDSystemStrings: Integer;
      key: string;
      Text_de: string;
      Text_en: string;
      Text_fr: string;
    
  end;
  
  TSystemStrings = class
    private
      systemStringsRec: TSystemStringsRec;
      //DA-START:TSystemStrings.additional.private.members.in.class:DA-START
      //DA-ELSE:TSystemStrings.additional.private.members.in.class:DA-ELSE
      //DA-END:TSystemStrings.additional.private.members.in.class:DA-END
    
    strict private
      //DA-START:TSystemStrings.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TSystemStrings.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TSystemStrings.additional.strict.private.members.in.class:DA-END
    
    protected
      //DA-START:TSystemStrings.additional.protected.members.in.class:DA-START
      //DA-ELSE:TSystemStrings.additional.protected.members.in.class:DA-ELSE
      //DA-END:TSystemStrings.additional.protected.members.in.class:DA-END
    
    strict protected
      //DA-START:TSystemStrings.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TSystemStrings.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TSystemStrings.additional.strict.protected.members.in.class:DA-END
    
    public
      constructor Create;
      property IDSystemStrings : Integer read systemStringsRec.IDSystemStrings write systemStringsRec.IDSystemStrings;
      property key : string read systemStringsRec.key write systemStringsRec.key;
      property Text_de : string read systemStringsRec.Text_de write systemStringsRec.Text_de;
      property Text_en : string read systemStringsRec.Text_en write systemStringsRec.Text_en;
      property Text_fr : string read systemStringsRec.Text_fr write systemStringsRec.Text_fr;
      //DA-START:TSystemStrings.additional.public.members.in.class:DA-START
      //DA-ELSE:TSystemStrings.additional.public.members.in.class:DA-ELSE
      //DA-END:TSystemStrings.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TSystemStrings.additional.published.members.in.class:DA-START
      //DA-ELSE:TSystemStrings.additional.published.members.in.class:DA-ELSE
      //DA-END:TSystemStrings.additional.published.members.in.class:DA-END
    
  end;
  
  TdbSystemStrings = class
    private
      fDBFieldIDSystemStrings: TField;
      fDBFieldkey: TField;
      fDBFieldText_de: TField;
      fDBFieldText_en: TField;
      fDBFieldText_fr: TField;
      function getQuery: IHQDataset;
      function getNextID: Integer;
      procedure SetDBFieldVariables(query: IHQDataset);
      procedure closeAndClearQuery(var query: IHQDataset);
      //DA-START:TdbSystemStrings.additional.private.members.in.class:DA-START
      //DA-ELSE:TdbSystemStrings.additional.private.members.in.class:DA-ELSE
      //DA-END:TdbSystemStrings.additional.private.members.in.class:DA-END
    
    strict private
      //DA-START:TdbSystemStrings.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TdbSystemStrings.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TdbSystemStrings.additional.strict.private.members.in.class:DA-END
    
    protected
      procedure setzeQueryFelderFromRec(query: IHQDataset; systemstrings: TSystemStrings);
      //DA-START:TdbSystemStrings.additional.protected.members.in.class:DA-START
      //DA-ELSE:TdbSystemStrings.additional.protected.members.in.class:DA-ELSE
      //DA-END:TdbSystemStrings.additional.protected.members.in.class:DA-END
    
    strict protected
      //DA-START:TdbSystemStrings.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TdbSystemStrings.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TdbSystemStrings.additional.strict.protected.members.in.class:DA-END
    
    public
      function laden: IHQDataset;
      procedure setzeRecFromFelder(systemstrings: TSystemStrings);
      function speichern(systemstrings: TSystemStrings): Boolean;
      function loeschen(IDSystemStrings: Integer): Boolean;
      function ladenZu(IDSystemStrings: Integer): IHQDataset;
      //DA-START:TdbSystemStrings.additional.public.members.in.class:DA-START
      //DA-ELSE:TdbSystemStrings.additional.public.members.in.class:DA-ELSE
      //DA-END:TdbSystemStrings.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TdbSystemStrings.additional.published.members.in.class:DA-START
      //DA-ELSE:TdbSystemStrings.additional.published.members.in.class:DA-ELSE
      //DA-END:TdbSystemStrings.additional.published.members.in.class:DA-END
    
  end;
  

const
  (*   TODO: Tabellennamen evtl. projektspezifisch anpassen
   *)
  //DA-START:dbcSystemStrings.constant.tab_systemstrings:DA-START
  //DA-ELSE:dbcSystemStrings.constant.tab_systemstrings:DA-ELSE
  TAB_SYSTEMSTRINGS = 'TAB_SystemStrings';
  //DA-END:dbcSystemStrings.constant.tab_systemstrings:DA-END


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
constructor TSystemStrings.Create;
   begin
     systemStringsRec.IDSystemStrings := -1;
     systemStringsRec.key := '';
     systemStringsRec.Text_de := '';
     systemStringsRec.Text_en := '';
     systemStringsRec.Text_fr := '';
   end;


//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Stellt Query (projektspezifisch) bereit, die für DB-Kommunikation verwendet wird
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbSystemStrings.getQuery: IHQDataset;
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
function TdbSystemStrings.getNextID: Integer;
var query : IHQDataset;
   begin
    Result := -1;
    query := getQuery;
    try
      closeAndClearQuery(query);
      query.SQL.Text  := 'select max(IDSystemStrings) from ' + TAB_SYSTEMSTRINGS;
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
procedure TdbSystemStrings.SetDBFieldVariables(query: IHQDataset);
   begin
    fDBFieldIDSystemStrings :=  query.FieldByName('IDSystemStrings');
    fDBFieldkey :=  query.FieldByName('key');
    fDBFieldText_de :=  query.FieldByName('Text_de');
    fDBFieldText_en :=  query.FieldByName('Text_en');
    fDBFieldText_fr :=  query.FieldByName('Text_fr');
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Schließt die query und leert den SQL-Text
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
procedure TdbSystemStrings.closeAndClearQuery(var query: IHQDataset);
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
procedure TdbSystemStrings.setzeQueryFelderFromRec(query: IHQDataset; systemstrings: TSystemStrings);
   begin
    query.ParamByName('IDSystemStrings').AsInteger := systemstrings.IDSystemStrings;
    query.ParamByName('key').AsString := systemstrings.key;
    query.ParamByName('Text_de').AsString := systemstrings.Text_de;
    query.ParamByName('Text_en').AsString := systemstrings.Text_en;
    query.ParamByName('Text_fr').AsString := systemstrings.Text_fr;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : liefert eine geöffnete Query zurück, die alle Datensätze enthält.  
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbSystemStrings.laden: IHQDataset;
var query : IHQDataset;
   begin
    query := getQuery;
    closeAndClearQuery(query);
    query.SQL.Text := 'SELECT * FROM ' +  TAB_SYSTEMSTRINGS;
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
procedure TdbSystemStrings.setzeRecFromFelder(systemstrings: TSystemStrings);
   begin
    systemstrings.IDSystemStrings := fDBFieldIDSystemStrings.AsInteger;
    systemstrings.key := fDBFieldkey.AsString;
    systemstrings.Text_de := fDBFieldText_de.AsString;
    systemstrings.Text_en := fDBFieldText_en.AsString;
    systemstrings.Text_fr := fDBFieldText_fr.AsString;
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
function TdbSystemStrings.speichern(systemstrings: TSystemStrings): Boolean;

const SQL_INSERT = 'INSERT INTO ' + TAB_SYSTEMSTRINGS 
                 + ' ( IDSYSTEMSTRINGS,  KEY,  TEXT_DE,  TEXT_EN,  TEXT_FR) '
                 + ' VALUES '
                 + ' ( :IDSystemStrings,  :key,  :Text_de,  :Text_en,  :Text_fr) ';

const SQL_UPDATE = 'UPDATE ' + TAB_SYSTEMSTRINGS 
					+ ' SET ' 
					+ ' KEY = :key ,  ' 
					+ ' TEXT_DE = :Text_de ,  ' 
					+ ' TEXT_EN = :Text_en ,  ' 
					+ ' TEXT_FR = :Text_fr  ' 
         	  		+ ' WHERE IDSystemStrings = :IDSystemStrings ';

var query : IHQDataset;
   begin
    query := getQuery;
    try
      closeAndClearQuery(query);
      if systemstrings.IDSystemStrings < 0 then
         begin
          systemstrings.IDSystemStrings := getNextID;
          query.SQL.Text := SQL_INSERT;
         end
      else
         begin
          query.SQL.Text := SQL_UPDATE;
         end;

      setzeQueryFelderFromRec(query, systemstrings);
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
function TdbSystemStrings.loeschen(IDSystemStrings: Integer): Boolean;

const SQL = 'DELETE FROM ' + TAB_SYSTEMSTRINGS + ' WHERE 	IDSystemStrings = :IDSystemStrings' ;
var query : IHQDataset;
   begin
    query := getQuery;
    Result := False;
    try
      if ( (IDSystemStrings <> -1)) then
         begin
          closeAndClearQuery(query);
          query.SQL.Text := SQL;
          query.ParamByName('IDSystemStrings').AsInteger := IDSystemStrings;

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
function TdbSystemStrings.ladenZu(IDSystemStrings: Integer): IHQDataset;
var query : IHQDataset;
   begin
    query := getQuery;
    closeAndClearQuery(query);
    query.SQL.Text := 'SELECT * FROM ' +  TAB_SYSTEMSTRINGS + ' WHERE ';
    query.SQL.Text := query.SQL.Text + 'IDSystemStrings  =: IDSystemStrings ';
    query.ParamByName('IDSystemStrings').AsInteger := IDSystemStrings;

    query.Open;
    SetDBFieldVariables(query);
    Result := query;
   end;


initialization
  //DA-START:dbcSystemStrings.additional.initializations.in.unit:DA-START
  //DA-ELSE:dbcSystemStrings.additional.initializations.in.unit:DA-ELSE
  //DA-END:dbcSystemStrings.additional.initializations.in.unit:DA-END
finalization
  //DA-START:dbcSystemStrings.additional.finalizations.in.unit:DA-START
  //DA-ELSE:dbcSystemStrings.additional.finalizations.in.unit:DA-ELSE
  //DA-END:dbcSystemStrings.additional.finalizations.in.unit:DA-END
end.
