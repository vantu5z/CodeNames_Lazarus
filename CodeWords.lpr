program CodeWords;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main_board, capitan_board, timeout_dialog, winer_dialog
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm_main_board, Form_main_board);
  Application.CreateForm(TForm_capitan_board, Form_capitan_board);
  Application.CreateForm(TForm_timeout, Form_timeout);
  Application.CreateForm(TForm_winer, Form_winer);
  Application.Run;
end.

