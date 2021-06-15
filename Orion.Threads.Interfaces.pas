unit Orion.Threads.Interfaces;

interface

uses
  System.SysUtils;

type
  iOrionThreads = interface
    ['{C8880ED8-1CEE-45C3-A392-E3B394A88B59}']
    function CustomThread(aOnStart, aOnProcess, aOnFinish : TProc; aOnException: TProc<Exception>) : iOrionThreads;
  end;
implementation

end.
