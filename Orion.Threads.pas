unit Orion.Threads;

interface

uses
  Orion.Threads.Interfaces,
  System.SysUtils,
  System.Threading;

type
  TOrionThreads = class(TInterfacedObject, iOrionThreads)
  private

  public
    constructor Create;
    destructor Destroy; override;
    class function New : iOrionThreads;

    function CustomThread(aOnStart, aOnProcess, aOnFinish : TProc; aOnException: TProc<Exception>): iOrionThreads;
  end;

implementation

uses
  System.Classes;

{ TOrionThreads }

constructor TOrionThreads.Create;
begin

end;

function TOrionThreads.CustomThread(aOnStart, aOnProcess, aOnFinish : TProc; aOnException: TProc<Exception>): iOrionThreads;
var
  lThread : TThread;
begin
  lThread := TThread.CreateAnonymousThread(
  procedure
  var
    LDoComplete : boolean;
    lError : Boolean;
  begin
    try
      lDoComplete := True;
      lError      := False;
      try
        if (Assigned(aOnStart)) then
        begin
          TThread.Synchronize(TThread.CurrentThread,
          procedure
          begin
            aOnStart;
          end);
        end;

        if (Assigned(aOnProcess)) then
          aOnProcess;


      except on E: Exception do
        begin
          lError := True;

          if Assigned(aOnException) then
          begin
            TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
              aOnException(E);
            end);
          end;
        end;
      end;
    finally
      if not (lError) then
      begin
        if Assigned(aOnFinish) then
        begin
          TThread.Synchronize(TThread.CurrentThread,
          procedure
          begin
            aOnFinish;
          end);
        end
      end;
    end;
  end);

  lThread.FreeOnTerminate := True;
  lThread.Start;
end;

destructor TOrionThreads.Destroy;
begin

  inherited;
end;

class function TOrionThreads.New: iOrionThreads;
begin
  Result := Self.Create;
end;

end.
