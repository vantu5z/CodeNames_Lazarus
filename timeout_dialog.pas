unit timeout_dialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm_timeout }

  TForm_timeout = class(TForm)
    Button_ok: TButton;
    Label1: TLabel;
    procedure Button_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form_timeout: TForm_timeout;

implementation

{$R *.lfm}

{ TForm_timeout }

procedure TForm_timeout.Button_okClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_timeout.FormShow(Sender: TObject);
begin
  Form_timeout.Position:=poScreenCenter;
end;

end.

