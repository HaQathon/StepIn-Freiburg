unit uSQLConnection;

interface

uses
  Uni;

type
  TConnectionType = (ctSQLite, ctIBLite, ctMySQL);

  TSQLConnection = class(TUniConnection)
  private
    procedure OnBeforeConnect(Sender: TObject);
    procedure OnAfterConnect(Sender: TObject);
  public
    constructor Create(ConnectionType: TConnectionType = ctSQLite); reintroduce;
  end;

implementation

uses
  System.SysUtils,
  UniProvider, SqLiteUniProvider, MySQLUniProvider;

{ TSQLConnection }

{ ============================================================================ }

constructor TSQLConnection.Create(ConnectionType: TConnectionType);
  begin
    inherited Create(NIL);

    case ConnectionType of
      ctSQLite:
        begin
          ProviderName := 'SQLite';
        end;
      ctMySQL:
        begin
          ProviderName := 'MySQL';
          Username := 'StepIn';
          Password := 'stepin';
        end;
    else
      raise Exception.Create('Unbekannter ConnectionType!');
    end;

    BeforeConnect := OnBeforeConnect;
    AfterConnect := OnAfterConnect;

    Connected := True;
  end;

{ ============================================================================ }

procedure TSQLConnection.OnBeforeConnect(Sender: TObject);
  begin
    // Params.Values['ServerCharSet'] := 'UTF8';
  end;

{ ============================================================================ }

procedure TSQLConnection.OnAfterConnect(Sender: TObject);
  begin

  end;

{ ============================================================================ }

end.


