unit rTask;

interface

uses
  XSuperObject,
  uTask,
  uRessource;

type
  TRessource_Task = class(TRessource, IRessource)
  private

  public
    function GetRessourceName: string;

    function GET(const id: string; jsonResponse: ISuperObject): Boolean;
    function POST(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function PUT(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function DELETE(const id: string; jsonResponse: ISuperObject): Boolean;

    const RESSOURCENAME = 'tasks';
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils,

  Winapi.ActiveX,
  System.Generics.Collections,
  Xml.XMLIntf,
  Xml.XMLDoc;

{ TRessource_Attribute }

function TRessource_Task.DELETE(const id: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

function TRessource_Task.GET(const id: string; jsonResponse: ISuperObject): Boolean;
   var
    taskList: TList<TTask>;
    dbTask : TTaskDatenbank;
    Tasks: ISuperObject;
    task:  TTask;
   begin
    dbTask := TTaskDatenbank.Create('StepIn');
    try
      if id.IsEmpty then
       begin
        taskList := dbTask.getAllTasks;
        try
          for task in taskList do
             begin
              Tasks := SO();
              Tasks := task.AsJSONObject;

              jsonResponse.O['data'].A['tasks'].Add(Tasks);
             end;
          result := True;
        finally
          taskList.Free;
        end;
       end
    else
       begin
        task := dbTask.get(strtointdef(id,0));
        if assigned(task) then
           begin
              Tasks := SO();
              Tasks := task.AsJSONObject;

              jsonResponse.O['data'].A['tasks'].Add(Tasks);
            result := True;
           end;
       end;
    finally
     dbTask.Free;
    end;
   end;

function TRessource_Task.GetRessourceName: string;
   begin
    result := RESSOURCENAME;
   end;

function TRessource_Task.POST(const id, payload: string; jsonResponse: ISuperObject): Boolean;
   var
    jsonRequest: ISuperObject;
   begin
    jsonRequest := SO(payload);

    if jsonRequest.Null['data'] = jAssigned then
       begin
        CoInitialize(NIL);


       end
    else
       begin
        jsonResponse.S['errorMsg'] := 'No data provided';
       end;
   end;

function TRessource_Task.PUT(const id, payload: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

end.
