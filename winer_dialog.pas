unit winer_dialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm_winer }

  TForm_winer = class(TForm)
    Button_ok: TButton;
    Label_winer: TLabel;
    procedure Button_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form_winer: TForm_winer;

implementation

{$R *.lfm}

{ TForm_winer }

procedure TForm_winer.Button_okClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_winer.FormShow(Sender: TObject);
begin
  Form_winer.Position:=poScreenCenter;
end;

end.

