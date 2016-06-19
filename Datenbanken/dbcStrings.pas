unit dbcStrings;



//  **************************************************************
//   Projekt         : PLANB
//   Modul           : dbcStrings
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
  
  TStringsRec = record
    
      IDStrings: Integer;
      key: string;
      Text_de: string;
      Text_en: string;
      Text_fr: string;
    
  end;
  
  TStrings = class
    private
      stringsRec: TStringsRec;
      //DA-START:TStrings.additional.private.members.in.class:DA-START
      //DA-ELSE:TStrings.additional.private.members.in.class:DA-ELSE
      //DA-END:TStrings.additional.private.members.in.class:DA-END
    
    strict private
      //DA-START:TStrings.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TStrings.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TStrings.additional.strict.private.members.in.class:DA-END
    
    protected
      //DA-START:TStrings.additional.protected.members.in.class:DA-START
      //DA-ELSE:TStrings.additional.protected.members.in.class:DA-ELSE
      //DA-END:TStrings.additional.protected.members.in.class:DA-END
    
    strict protected
      //DA-START:TStrings.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TStrings.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TStrings.additional.strict.protected.members.in.class:DA-END
    
    public
      constructor Create;
      property IDStrings : Integer read stringsRec.IDStrings write stringsRec.IDStrings;
      property key : string read stringsRec.key write stringsRec.key;
      property Text_de : string read stringsRec.Text_de write stringsRec.Text_de;
      property Text_en : string read stringsRec.Text_en write stringsRec.Text_en;
      property Text_fr : string read stringsRec.Text_fr write stringsRec.Text_fr;
      //DA-START:TStrings.additional.public.members.in.class:DA-START
      //DA-ELSE:TStrings.additional.public.members.in.class:DA-ELSE
      //DA-END:TStrings.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TStrings.additional.published.members.in.class:DA-START
      //DA-ELSE:TStrings.additional.published.members.in.class:DA-ELSE
      //DA-END:TStrings.additional.published.members.in.class:DA-END
    
  end;
  
  TdbStrings = class
    private
      fDBFieldIDStrings: TField;
      fDBFieldkey: TField;
      fDBFieldText_de: TField;
      fDBFieldText_en: TField;
      fDBFieldText_fr: TField;
      function getQuery: IHQDataset;
      function getNextID: Integer;
      procedure SetDBFieldVariables(query: IHQDataset);
      procedure closeAndClearQuery(var query: IHQDataset);
      //DA-START:TdbStrings.additional.private.members.in.class:DA-START
      //DA-ELSE:TdbStrings.additional.private.members.in.class:DA-ELSE
      //DA-END:TdbStrings.additional.private.members.in.class:DA-END
    
    strict private
      //DA-START:TdbStrings.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TdbStrings.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TdbStrings.additional.strict.private.members.in.class:DA-END
    
    protected
      procedure setzeQueryFelderFromRec(query: IHQDataset; strings: TStrings);
      //DA-START:TdbStrings.additional.protected.members.in.class:DA-START
      //DA-ELSE:TdbStrings.additional.protected.members.in.class:DA-ELSE
      //DA-END:TdbStrings.additional.protected.members.in.class:DA-END
    
    strict protected
      //DA-START:TdbStrings.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TdbStrings.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TdbStrings.additional.strict.protected.members.in.class:DA-END
    
    public
      function laden: IHQDataset;
      procedure setzeRecFromFelder(strings: TStrings);
      function speichern(strings: TStrings): Boolean;
      function loeschen(IDStrings: Integer): Boolean;
      function ladenZu(IDStrings: Integer): IHQDataset;
      //DA-START:TdbStrings.additional.public.members.in.class:DA-START
      //DA-ELSE:TdbStrings.additional.public.members.in.class:DA-ELSE
      //DA-END:TdbStrings.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TdbStrings.additional.published.members.in.class:DA-START
      //DA-ELSE:TdbStrings.additional.published.members.in.class:DA-ELSE
      //DA-END:TdbStrings.additional.published.members.in.class:DA-END
    
  end;
  

const
  (*   TODO: Tabellennamen evtl. projektspezifisch anpassen
   *)
  //DA-START:dbcStrings.constant.tab_strings:DA-START
  //DA-ELSE:dbcStrings.constant.tab_strings:DA-ELSE
  TAB_STRINGS = 'TAB_Strings';
  //DA-END:dbcStrings.constant.tab_strings:DA-END


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
constructor TStrings.Create;
   begin
     stringsRec.IDStrings := -1;
     stringsRec.key := '';
     stringsRec.Text_de := '';
     stringsRec.Text_en := '';
     stringsRec.Text_fr := '';
   end;


//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Stellt Query (projektspezifisch) bereit, die für DB-Kommunikation verwendet wird
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbStrings.getQuery: IHQDataset;
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
function TdbStrings.getNextID: Integer;
var query : IHQDataset;
   begin
    Result := -1;
    query := getQuery;
    try
      closeAndClearQuery(query);
      query.SQL.Text  := 'select max(IDStrings) from ' + TAB_STRINGS;
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
procedure TdbStrings.SetDBFieldVariables(query: IHQDataset);
   begin
    fDBFieldIDStrings :=  query.FieldByName('IDStrings');
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
procedure TdbStrings.closeAndClearQuery(var query: IHQDataset);
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
procedure TdbStrings.setzeQueryFelderFromRec(query: IHQDataset; strings: TStrings);
   begin
    query.ParamByName('IDStrings').AsInteger := strings.IDStrings;
    query.ParamByName('key').AsString := strings.key;
    query.ParamByName('Text_de').AsString := strings.Text_de;
    query.ParamByName('Text_en').AsString := strings.Text_en;
    query.ParamByName('Text_fr').AsString := strings.Text_fr;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : liefert eine geöffnete Query zurück, die alle Datensätze enthält.  
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbStrings.laden: IHQDataset;
var query : IHQDataset;
   begin
    query := getQuery;
    closeAndClearQuery(query);
    query.SQL.Text := 'SELECT * FROM ' +  TAB_STRINGS;
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
procedure TdbStrings.setzeRecFromFelder(strings: TStrings);
   begin
    strings.IDStrings := fDBFieldIDStrings.AsInteger;
    strings.key := fDBFieldkey.AsString;
    strings.Text_de := fDBFieldText_de.AsString;
    strings.Text_en := fDBFieldText_en.AsString;
    strings.Text_fr := fDBFieldText_fr.AsString;
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
function TdbStrings.speichern(strings: TStrings): Boolean;

const SQL_INSERT = 'INSERT INTO ' + TAB_STRINGS 
                 + ' ( IDSTRINGS,  KEY,  TEXT_DE,  TEXT_EN,  TEXT_FR) '
                 + ' VALUES '
                 + ' ( :IDStrings,  :key,  :Text_de,  :Text_en,  :Text_fr) ';

const SQL_UPDATE = 'UPDATE ' + TAB_STRINGS 
					+ ' SET ' 
					+ ' KEY = :key ,  ' 
					+ ' TEXT_DE = :Text_de ,  ' 
					+ ' TEXT_EN = :Text_en ,  ' 
					+ ' TEXT_FR = :Text_fr  ' 
         	  		+ ' WHERE IDStrings = :IDStrings ';

var query : IHQDataset;
   begin
    query := getQuery;
    try
      closeAndClearQuery(query);
      if strings.IDStrings < 0 then
         begin
          strings.IDStrings := getNextID;
          query.SQL.Text := SQL_INSERT;
         end
      else
         begin
          query.SQL.Text := SQL_UPDATE;
         end;

      setzeQueryFelderFromRec(query, strings);
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
function TdbStrings.loeschen(IDStrings: Integer): Boolean;

const SQL = 'DELETE FROM ' + TAB_STRINGS + ' WHERE 	IDStrings = :IDStrings' ;
var query : IHQDataset;
   begin
    query := getQuery;
    Result := False;
    try
      if ( (IDStrings <> -1)) then
         begin
          closeAndClearQuery(query);
          query.SQL.Text := SQL;
          query.ParamByName('IDStrings').AsInteger := IDStrings;

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
function TdbStrings.ladenZu(IDStrings: Integer): IHQDataset;
var query : IHQDataset;
   begin
    query := getQuery;
    closeAndClearQuery(query);
    query.SQL.Text := 'SELECT * FROM ' +  TAB_STRINGS + ' WHERE ';
    query.SQL.Text := query.SQL.Text + 'IDStrings  =: IDStrings ';
    query.ParamByName('IDStrings').AsInteger := IDStrings;

    query.Open;
    SetDBFieldVariables(query);
    Result := query;
   end;


initialization
  //DA-START:dbcStrings.additional.initializations.in.unit:DA-START
  //DA-ELSE:dbcStrings.additional.initializations.in.unit:DA-ELSE
  //DA-END:dbcStrings.additional.initializations.in.unit:DA-END
finalization
  //DA-START:dbcStrings.additional.finalizations.in.unit:DA-START
  //DA-ELSE:dbcStrings.additional.finalizations.in.unit:DA-ELSE
  //DA-END:dbcStrings.additional.finalizations.in.unit:DA-END
end.
