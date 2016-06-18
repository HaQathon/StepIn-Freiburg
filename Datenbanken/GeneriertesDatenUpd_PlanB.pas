unit GeneriertesDatenUpd_PlanB;

{================================================================}
interface
{================================================================}

uses 
  DatenUpd_PlanB;

type
  TGeneriertesDatenUpd_PlanB = class(TDatenUpdatePlanB)
    private
      function CreateTableSystemStrings: Boolean;
      function CreateTableStrings: Boolean;
      function CreateTableTask: Boolean;
      function CreateTableAttribute: Boolean;
      function CreateTableTaskAttributeRel: Boolean;
      function CreateTableTaskContentRel: Boolean;
      function CreateTableContent: Boolean;
      function CheckTableSystemStrings: Boolean;
      function CheckTableStrings: Boolean;
      function CheckTableTask: Boolean;
      function CheckTableAttribute: Boolean;
      function CheckTableTaskAttributeRel: Boolean;
      function CheckTableTaskContentRel: Boolean;
      function CheckTableContent: Boolean;
      function UpdateTableSystemStrings: Boolean;
      function UpdateTableStrings: Boolean;
      function UpdateTableTask: Boolean;
      function UpdateTableAttribute: Boolean;
      function UpdateTableTaskAttributeRel: Boolean;
      function UpdateTableTaskContentRel: Boolean;
      function UpdateTableContent: Boolean;
      //DA-START:TGeneriertesDatenUpd_PlanB.additional.private.members.in.class:DA-START
      //DA-ELSE:TGeneriertesDatenUpd_PlanB.additional.private.members.in.class:DA-ELSE
      //DA-END:TGeneriertesDatenUpd_PlanB.additional.private.members.in.class:DA-END
    
    private
      //DA-START:TGeneriertesDatenUpd_PlanB.additional.strict.private.members.in.class:DA-START
      //DA-ELSE:TGeneriertesDatenUpd_PlanB.additional.strict.private.members.in.class:DA-ELSE
      //DA-END:TGeneriertesDatenUpd_PlanB.additional.strict.private.members.in.class:DA-END
    
    protected
      //DA-START:TGeneriertesDatenUpd_PlanB.additional.protected.members.in.class:DA-START
      //DA-ELSE:TGeneriertesDatenUpd_PlanB.additional.protected.members.in.class:DA-ELSE
      //DA-END:TGeneriertesDatenUpd_PlanB.additional.protected.members.in.class:DA-END
    
    protected
      //DA-START:TGeneriertesDatenUpd_PlanB.additional.strict.protected.members.in.class:DA-START
      //DA-ELSE:TGeneriertesDatenUpd_PlanB.additional.strict.protected.members.in.class:DA-ELSE
      // add additional code in the above developer area 
      //DA-END:TGeneriertesDatenUpd_PlanB.additional.strict.protected.members.in.class:DA-END
    
    public
      //DA-START:TGeneriertesDatenUpd_PlanB.additional.public.members.in.class:DA-START
      //DA-ELSE:TGeneriertesDatenUpd_PlanB.additional.public.members.in.class:DA-ELSE
      //DA-END:TGeneriertesDatenUpd_PlanB.additional.public.members.in.class:DA-END
    
    published
      //DA-START:TGeneriertesDatenUpd_PlanB.additional.published.members.in.class:DA-START
      //DA-ELSE:TGeneriertesDatenUpd_PlanB.additional.published.members.in.class:DA-ELSE
      //DA-END:TGeneriertesDatenUpd_PlanB.additional.published.members.in.class:DA-END
    
  end;
  

const
  //DA-START:GeneriertesDatenUpd_PlanB.constant.ptk_dataupd:DA-START
  //DA-ELSE:GeneriertesDatenUpd_PlanB.constant.ptk_dataupd:DA-ELSE
  PTK_DATAUPD = 'DATAUPD';
  //DA-END:GeneriertesDatenUpd_PlanB.constant.ptk_dataupd:DA-END

function CheckDatenUpdate(Datenstand: Integer = -1): Boolean;


{================================================================}
implementation
{================================================================}

uses 
  GeneriertesDatenDef_PlanB, 
  highQPTK, 
  SysUtils, 
  BSysGlob;

function CheckDatenUpdate(Datenstand: Integer = -1): Boolean;
   var tmpDatenUpdate : TGeneriertesDatenUpd_PlanB;
   begin
    result := false;
    tmpDatenUpdate := TGeneriertesDatenUpd_PlanB.Create();
      try
        if Datenstand >= -1 then
           begin
            try  
              if (not tmpDatenUpdate.CheckTableSystemStrings) then
                 begin
{x}               exit;
                 end;
            except
              on e: exception do
                 begin 
                  VProt(PTK_DATAUPD, 'Tabelle SystemStrings konnte nicht erstellt werden!' + e.Message);
                 end;
            end; {ofTry}
           end; {ofIf} 
        if Datenstand >= -1 then
           begin
            try  
              if (not tmpDatenUpdate.CheckTableStrings) then
                 begin
{x}               exit;
                 end;
            except
              on e: exception do
                 begin 
                  VProt(PTK_DATAUPD, 'Tabelle Strings konnte nicht erstellt werden!' + e.Message);
                 end;
            end; {ofTry}
           end; {ofIf} 
        if Datenstand >= -1 then
           begin
            try  
              if (not tmpDatenUpdate.CheckTableTask) then
                 begin
{x}               exit;
                 end;
            except
              on e: exception do
                 begin 
                  VProt(PTK_DATAUPD, 'Tabelle Task konnte nicht erstellt werden!' + e.Message);
                 end;
            end; {ofTry}
           end; {ofIf} 
        if Datenstand >= -1 then
           begin
            try  
              if (not tmpDatenUpdate.CheckTableAttribute) then
                 begin
{x}               exit;
                 end;
            except
              on e: exception do
                 begin 
                  VProt(PTK_DATAUPD, 'Tabelle Attribute konnte nicht erstellt werden!' + e.Message);
                 end;
            end; {ofTry}
           end; {ofIf} 
        if Datenstand >= -1 then
           begin
            try  
              if (not tmpDatenUpdate.CheckTableTaskAttributeRel) then
                 begin
{x}               exit;
                 end;
            except
              on e: exception do
                 begin 
                  VProt(PTK_DATAUPD, 'Tabelle TaskAttributeRel konnte nicht erstellt werden!' + e.Message);
                 end;
            end; {ofTry}
           end; {ofIf} 
        if Datenstand >= -1 then
           begin
            try  
              if (not tmpDatenUpdate.CheckTableTaskContentRel) then
                 begin
{x}               exit;
                 end;
            except
              on e: exception do
                 begin 
                  VProt(PTK_DATAUPD, 'Tabelle TaskContentRel konnte nicht erstellt werden!' + e.Message);
                 end;
            end; {ofTry}
           end; {ofIf} 
        if Datenstand >= -1 then
           begin
            try  
              if (not tmpDatenUpdate.CheckTableContent) then
                 begin
{x}               exit;
                 end;
            except
              on e: exception do
                 begin 
                  VProt(PTK_DATAUPD, 'Tabelle Content konnte nicht erstellt werden!' + e.Message);
                 end;
            end; {ofTry}
           end; {ofIf} 

      finally
        freeAndNil(tmpDatenUpdate);
      end; {ofTry}
    { Datenstand ok }
    Result := true;
   end;


function TGeneriertesDatenUpd_PlanB.CreateTableSystemStrings: Boolean;
   begin
    result := createNewTable(TD_SYSTEMSTRINGS);
   end;
   

function TGeneriertesDatenUpd_PlanB.CreateTableStrings: Boolean;
   begin
    result := createNewTable(TD_STRINGS);
   end;
   

function TGeneriertesDatenUpd_PlanB.CreateTableTask: Boolean;
   begin
    result := createNewTable(TD_TASK);
   end;
   

function TGeneriertesDatenUpd_PlanB.CreateTableAttribute: Boolean;
   begin
    result := createNewTable(TD_ATTRIBUTE);
   end;
   

function TGeneriertesDatenUpd_PlanB.CreateTableTaskAttributeRel: Boolean;
   begin
    result := createNewTable(TD_TASKATTRIBUTEREL);
   end;
   

function TGeneriertesDatenUpd_PlanB.CreateTableTaskContentRel: Boolean;
   begin
    result := createNewTable(TD_TASKCONTENTREL);
   end;
   

function TGeneriertesDatenUpd_PlanB.CreateTableContent: Boolean;
   begin
    result := createNewTable(TD_CONTENT);
   end;
   

function TGeneriertesDatenUpd_PlanB.CheckTableSystemStrings: Boolean;
   begin
    result := checkTableVersion(TAB_SYSTEMSTRINGS, 0, 'IDSYSTEMSTRINGS', createTableSystemStrings);
   end;
   

function TGeneriertesDatenUpd_PlanB.CheckTableStrings: Boolean;
   begin
    result := checkTableVersion(TAB_STRINGS, 0, 'IDSTRINGS', createTableStrings);
   end;
   

function TGeneriertesDatenUpd_PlanB.CheckTableTask: Boolean;
   begin
    result := checkTableVersion(TAB_TASK, 0, 'IDTASK', createTableTask);
   end;
   

function TGeneriertesDatenUpd_PlanB.CheckTableAttribute: Boolean;
   begin
    result := checkTableVersion(TAB_ATTRIBUTE, 0, 'IDATTRIBUTE', createTableAttribute);
   end;
   

function TGeneriertesDatenUpd_PlanB.CheckTableTaskAttributeRel: Boolean;
   begin
    result := checkTableVersion(TAB_TASKATTRIBUTEREL, 0, 'IDTASKATTRIBUTE', createTableTaskAttributeRel);
   end;
   

function TGeneriertesDatenUpd_PlanB.CheckTableTaskContentRel: Boolean;
   begin
    result := checkTableVersion(TAB_TASKCONTENTREL, 0, 'IDCONTENT', createTableTaskContentRel);
   end;
   

function TGeneriertesDatenUpd_PlanB.CheckTableContent: Boolean;
   begin
    result := checkTableVersion(TAB_CONTENT, 0, 'IDTASKCONTENT', createTableContent);
   end;
   

function TGeneriertesDatenUpd_PlanB.UpdateTableSystemStrings: Boolean;
   begin
    Result := True;
    //Result := UpdateTableVersion('TAB_SYSTEMSTRINGS', '', 'ALTER TABLE ' + TAB_SYSTEMSTRINGS + ' ADD ({neuesFeld}, {neuerFeldTyp}));
   end;


function TGeneriertesDatenUpd_PlanB.UpdateTableStrings: Boolean;
   begin
    Result := True;
    //Result := UpdateTableVersion('TAB_STRINGS', '', 'ALTER TABLE ' + TAB_STRINGS + ' ADD ({neuesFeld}, {neuerFeldTyp}));
   end;


function TGeneriertesDatenUpd_PlanB.UpdateTableTask: Boolean;
   begin
    Result := True;
    //Result := UpdateTableVersion('TAB_TASK', '', 'ALTER TABLE ' + TAB_TASK + ' ADD ({neuesFeld}, {neuerFeldTyp}));
   end;


function TGeneriertesDatenUpd_PlanB.UpdateTableAttribute: Boolean;
   begin
    Result := True;
    //Result := UpdateTableVersion('TAB_ATTRIBUTE', '', 'ALTER TABLE ' + TAB_ATTRIBUTE + ' ADD ({neuesFeld}, {neuerFeldTyp}));
   end;


function TGeneriertesDatenUpd_PlanB.UpdateTableTaskAttributeRel: Boolean;
   begin
    Result := True;
    //Result := UpdateTableVersion('TAB_TASKATTRIBUTEREL', '', 'ALTER TABLE ' + TAB_TASKATTRIBUTEREL + ' ADD ({neuesFeld}, {neuerFeldTyp}));
   end;


function TGeneriertesDatenUpd_PlanB.UpdateTableTaskContentRel: Boolean;
   begin
    Result := True;
    //Result := UpdateTableVersion('TAB_TASKCONTENTREL', '', 'ALTER TABLE ' + TAB_TASKCONTENTREL + ' ADD ({neuesFeld}, {neuerFeldTyp}));
   end;


function TGeneriertesDatenUpd_PlanB.UpdateTableContent: Boolean;
   begin
    Result := True;
    //Result := UpdateTableVersion('TAB_CONTENT', '', 'ALTER TABLE ' + TAB_CONTENT + ' ADD ({neuesFeld}, {neuerFeldTyp}));
   end;


initialization
  //DA-START:GeneriertesDatenUpd_PlanB.additional.initializations.in.unit:DA-START
  //DA-ELSE:GeneriertesDatenUpd_PlanB.additional.initializations.in.unit:DA-ELSE
  //DA-END:GeneriertesDatenUpd_PlanB.additional.initializations.in.unit:DA-END
finalization
  //DA-START:GeneriertesDatenUpd_PlanB.additional.finalizations.in.unit:DA-START
  //DA-ELSE:GeneriertesDatenUpd_PlanB.additional.finalizations.in.unit:DA-ELSE
  //DA-END:GeneriertesDatenUpd_PlanB.additional.finalizations.in.unit:DA-END
end.
