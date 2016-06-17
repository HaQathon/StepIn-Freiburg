unit dbcAttribute;



//  **************************************************************
//   Projekt         : PLANB
//   Modul           : dbcAttribute
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
  
  TAttributeRec = record
    
      IDAttribute: Integer;
      Verwendet: Boolean;
      AttributName: Integer;
    
  end;
  
  TAttribute = class
    private
      attributeRec: TAttributeRec;
      //DA-START:TAttribute.additional.private.members.in.class:DA-START
      //DA-ELSE:TAttribute.additional.private.members.in.class:DA-ELSE
      //DA-END:TAttribute.additional.private.members.in.class:DA-END
    
    strict private
      //DA-START:TAttribute.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TAttribute.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TAttribute.additional.strict.private.members.in.class:DA-END
    
    protected
      //DA-START:TAttribute.additional.protected.members.in.class:DA-START
      //DA-ELSE:TAttribute.additional.protected.members.in.class:DA-ELSE
      //DA-END:TAttribute.additional.protected.members.in.class:DA-END
    
    strict protected
      //DA-START:TAttribute.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TAttribute.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TAttribute.additional.strict.protected.members.in.class:DA-END
    
    public
      constructor Create;
      property IDAttribute : Integer read attributeRec.IDAttribute write attributeRec.IDAttribute;
      property Verwendet : Boolean read attributeRec.Verwendet write attributeRec.Verwendet;
      property AttributName : Integer read attributeRec.AttributName write attributeRec.AttributName;
      //DA-START:TAttribute.additional.public.members.in.class:DA-START
      //DA-ELSE:TAttribute.additional.public.members.in.class:DA-ELSE
      //DA-END:TAttribute.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TAttribute.additional.published.members.in.class:DA-START
      //DA-ELSE:TAttribute.additional.published.members.in.class:DA-ELSE
      //DA-END:TAttribute.additional.published.members.in.class:DA-END
    
  end;
  
  TdbAttribute = class
    private
      fDBFieldIDAttribute: TField;
      fDBFieldVerwendet: TField;
      fDBFieldAttributName: TField;
      function getQuery: IHQDataset;
      function getNextID: Integer;
      procedure SetDBFieldVariables(query: IHQDataset);
      procedure closeAndClearQuery(var query: IHQDataset);
      //DA-START:TdbAttribute.additional.private.members.in.class:DA-START
      //DA-ELSE:TdbAttribute.additional.private.members.in.class:DA-ELSE
      //DA-END:TdbAttribute.additional.private.members.in.class:DA-END
    
    strict private
      //DA-START:TdbAttribute.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TdbAttribute.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TdbAttribute.additional.strict.private.members.in.class:DA-END
    
    protected
      procedure setzeQueryFelderFromRec(query: IHQDataset; attribute: TAttribute);
      //DA-START:TdbAttribute.additional.protected.members.in.class:DA-START
      //DA-ELSE:TdbAttribute.additional.protected.members.in.class:DA-ELSE
      //DA-END:TdbAttribute.additional.protected.members.in.class:DA-END
    
    strict protected
      //DA-START:TdbAttribute.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TdbAttribute.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TdbAttribute.additional.strict.protected.members.in.class:DA-END
    
    public
      function laden: IHQDataset;
      procedure setzeRecFromFelder(attribute: TAttribute);
      function speichern(attribute: TAttribute): Boolean;
      function loeschen(IDAttribute: Integer): Boolean;
      function ladenZu(IDAttribute: Integer): IHQDataset;
      //DA-START:TdbAttribute.additional.public.members.in.class:DA-START
      //DA-ELSE:TdbAttribute.additional.public.members.in.class:DA-ELSE
      //DA-END:TdbAttribute.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TdbAttribute.additional.published.members.in.class:DA-START
      //DA-ELSE:TdbAttribute.additional.published.members.in.class:DA-ELSE
      //DA-END:TdbAttribute.additional.published.members.in.class:DA-END
    
  end;
  

const
  (*   TODO: Tabellennamen evtl. projektspezifisch anpassen
   *)
  //DA-START:dbcAttribute.constant.tab_attribute:DA-START
  //DA-ELSE:dbcAttribute.constant.tab_attribute:DA-ELSE
  TAB_ATTRIBUTE = 'TAB_Attribute';
  //DA-END:dbcAttribute.constant.tab_attribute:DA-END


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
constructor TAttribute.Create;
   begin
     attributeRec.IDAttribute := -1;
     attributeRec.Verwendet := False;
     attributeRec.AttributName := -1;
   end;


//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Stellt Query (projektspezifisch) bereit, die für DB-Kommunikation verwendet wird
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbAttribute.getQuery: IHQDataset;
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
function TdbAttribute.getNextID: Integer;
var query : IHQDataset;
   begin
    Result := -1;
    query := getQuery;
    try
      closeAndClearQuery(query);
      query.SQL.Text  := 'select max(IDAttribute) from ' + TAB_ATTRIBUTE;
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
procedure TdbAttribute.SetDBFieldVariables(query: IHQDataset);
   begin
    fDBFieldIDAttribute :=  query.FieldByName('IDAttribute');
    fDBFieldVerwendet :=  query.FieldByName('Verwendet');
    fDBFieldAttributName :=  query.FieldByName('AttributName');
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : Schließt die query und leert den SQL-Text
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
procedure TdbAttribute.closeAndClearQuery(var query: IHQDataset);
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
procedure TdbAttribute.setzeQueryFelderFromRec(query: IHQDataset; attribute: TAttribute);
   begin
    query.ParamByName('IDAttribute').AsInteger := attribute.IDAttribute;
    query.ParamByName('Verwendet').AsBoolean := attribute.Verwendet;
    query.ParamByName('AttributName').AsInteger := attribute.AttributName;
   end;



//******************************************************************************
//  Autor(en)    : 
//  Beginn-Datum : 17.06.2016 
//  Beschreibung : liefert eine geöffnete Query zurück, die alle Datensätze enthält.  
//  Änderungen   :
//   tt.mm.jjjj   hh:mm   wer   was
//******************************************************************************
function TdbAttribute.laden: IHQDataset;
var query : IHQDataset;
   begin
    query := getQuery;
    closeAndClearQuery(query);
    query.SQL.Text := 'SELECT * FROM ' +  TAB_ATTRIBUTE;
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
procedure TdbAttribute.setzeRecFromFelder(attribute: TAttribute);
   begin
    attribute.IDAttribute := fDBFieldIDAttribute.AsInteger;
    attribute.Verwendet := fDBFieldVerwendet.AsVariant;
    attribute.AttributName := fDBFieldAttributName.AsInteger;
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
function TdbAttribute.speichern(attribute: TAttribute): Boolean;

const SQL_INSERT = 'INSERT INTO ' + TAB_ATTRIBUTE 
                 + ' ( IDATTRIBUTE,  VERWENDET,  ATTRIBUTNAME) '
                 + ' VALUES '
                 + ' ( :IDAttribute,  :Verwendet,  :AttributName) ';

const SQL_UPDATE = 'UPDATE ' + TAB_ATTRIBUTE 
					+ ' SET ' 
					+ ' VERWENDET = :Verwendet ,  ' 
					+ ' ATTRIBUTNAME = :AttributName  ' 
         	  		+ ' WHERE IDAttribute = :IDAttribute ';

var query : IHQDataset;
   begin
    query := getQuery;
    try
      closeAndClearQuery(query);
      if attribute.IDAttribute < 0 then
         begin
          attribute.IDAttribute := getNextID;
          query.SQL.Text := SQL_INSERT;
         end
      else
         begin
          query.SQL.Text := SQL_UPDATE;
         end;

      setzeQueryFelderFromRec(query, attribute);
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
function TdbAttribute.loeschen(IDAttribute: Integer): Boolean;

const SQL = 'DELETE FROM ' + TAB_ATTRIBUTE + ' WHERE 	IDAttribute = :IDAttribute' ;
var query : IHQDataset;
   begin
    query := getQuery;
    Result := False;
    try
      if ( (IDAttribute <> -1)) then
         begin
          closeAndClearQuery(query);
          query.SQL.Text := SQL;
          query.ParamByName('IDAttribute').AsInteger := IDAttribute;

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
function TdbAttribute.ladenZu(IDAttribute: Integer): IHQDataset;
var query : IHQDataset;
   begin
    query := getQuery;
    closeAndClearQuery(query);
    query.SQL.Text := 'SELECT * FROM ' +  TAB_ATTRIBUTE + ' WHERE ';
    query.SQL.Text := query.SQL.Text + 'IDAttribute  =: IDAttribute ';
    query.ParamByName('IDAttribute').AsInteger := IDAttribute;

    query.Open;
    SetDBFieldVariables(query);
    Result := query;
   end;


initialization
  //DA-START:dbcAttribute.additional.initializations.in.unit:DA-START
  //DA-ELSE:dbcAttribute.additional.initializations.in.unit:DA-ELSE
  //DA-END:dbcAttribute.additional.initializations.in.unit:DA-END
finalization
  //DA-START:dbcAttribute.additional.finalizations.in.unit:DA-START
  //DA-ELSE:dbcAttribute.additional.finalizations.in.unit:DA-ELSE
  //DA-END:dbcAttribute.additional.finalizations.in.unit:DA-END
end.
