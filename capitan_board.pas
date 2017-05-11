unit capitan_board;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm_capitan_board }

  TForm_capitan_board = class(TForm)
    GroupBox_cards: TGroupBox;
    word_1_1: TLabel;
    word_1_2: TLabel;
    word_1_3: TLabel;
    word_1_4: TLabel;
    word_1_5: TLabel;
    word_2_1: TLabel;
    word_2_2: TLabel;
    word_2_3: TLabel;
    word_2_4: TLabel;
    word_2_5: TLabel;
    word_3_1: TLabel;
    word_3_2: TLabel;
    word_3_3: TLabel;
    word_3_4: TLabel;
    word_3_5: TLabel;
    word_4_1: TLabel;
    word_4_2: TLabel;
    word_4_3: TLabel;
    word_4_4: TLabel;
    word_4_5: TLabel;
    word_5_1: TLabel;
    word_5_2: TLabel;
    word_5_3: TLabel;
    word_5_4: TLabel;
    word_5_5: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }

    { установка цвета карты }
    procedure SetCardColor(_card_name: string; _color: TColor);

    { установка текста карты }
    procedure SetCardText(_card_name: string; _text: String);

  public
    { public declarations }

    { раскрашивание (обновление) поля для капитанов }
    procedure ShowCards();

    { очистка игрового поля для капитанов }
    procedure Clear_table();

  end;

var
  Form_capitan_board: TForm_capitan_board;

implementation

uses main_board;

{$R *.lfm}

{ TForm_capitan_board }

procedure TForm_capitan_board.FormResize(Sender: TObject);
var
  card_width: integer;
  card_height: integer;
  indent: integer = 10;
begin
  card_width:= round((GroupBox_cards.Width - indent*8)/5);
  card_height:= round((GroupBox_cards.Height - indent*10)/5);

  // ширина карт
  word_1_1.Width:= card_width;
  word_1_2.Width:= card_width;
  word_1_3.Width:= card_width;
  word_1_4.Width:= card_width;
  word_1_5.Width:= card_width;

  // высота карт
  word_1_1.Height:= card_height;
  word_2_1.Height:= card_height;
  word_3_1.Height:= card_height;
  word_4_1.Height:= card_height;
  word_5_1.Height:= card_height;

  // расположение по горизонтали
  word_1_1.Left:= GroupBox_cards.Left + indent;
  word_1_2.Left:= word_1_1.Left + card_width + indent;
  word_1_3.Left:= word_1_2.Left + card_width + indent;
  word_1_4.Left:= word_1_3.Left + card_width + indent;
  word_1_5.Left:= word_1_4.Left + card_width + indent;

  // расположение по вертикали
  word_1_1.Top:= GroupBox_cards.Top;
  word_2_1.Top:= word_1_1.Top + card_height + indent;
  word_3_1.Top:= word_2_1.Top + card_height + indent;
  word_4_1.Top:= word_3_1.Top + card_height + indent;
  word_5_1.Top:= word_4_1.Top + card_height + indent;
end;

procedure TForm_capitan_board.FormShow(Sender: TObject);
begin
  Clear_table();
end;

procedure TForm_capitan_board.FormClose(Sender: TObject;
                                        var CloseAction: TCloseAction);
begin
  Form_main_board.Button_show_cards_form.Visible:= True;
end;

procedure TForm_capitan_board.SetCardColor(_card_name: string; _color: TColor);
begin
  (FindComponent(_card_name) as Tlabel).Color:= _color;

  // зачеркиваем текст на открытых картах
  if (Form_main_board.FindComponent(_card_name) as Tlabel).Caption = ''
    then
      begin
        (FindComponent(_card_name) as Tlabel).Font.Style:= [fsStrikeOut];
        (FindComponent(_card_name) as Tlabel).Font.Color:= $000000;
        (FindComponent(_card_name) as Tlabel).OptimalFill:=False;
        (FindComponent(_card_name) as Tlabel).OptimalFill:=True;
      end
    else
      begin
        (FindComponent(_card_name) as Tlabel).Font.Style:= [];
        (FindComponent(_card_name) as Tlabel).Font.Color:= clDefault;
      end;
end;

procedure TForm_capitan_board.SetCardText(_card_name: string; _text: String);
begin
  (FindComponent(_card_name) as Tlabel).Caption:= _text;
end;

procedure TForm_capitan_board.ShowCards;
var
  i,j: integer;
begin
  for i:=0 to 4 do
   begin
     for j:=0 to 4 do
      begin
        if cards_pos[i][j] = 0
        then SetCardColor('word_' +inttostr(i+1)+ '_' + inttostr(j+1), $656565);
        if cards_pos[i][j] = 1
        then SetCardColor('word_' +inttostr(i+1)+ '_' +inttostr(j+1), clMaroon);
        if cards_pos[i][j] = 2
        then SetCardColor('word_' + inttostr(i+1)+ '_' + inttostr(j+1), clNavy);
        if cards_pos[i][j] = 3
        then SetCardColor('word_' +inttostr(i+1)+ '_' + inttostr(j+1), clBlack);
        SetCardText('word_'+inttostr(i+1)+'_'+inttostr(j+1), cards_words[i][j]);
      end;
   end;
end;

procedure TForm_capitan_board.Clear_table;
var
  i,j: integer;
begin
  // текст
  for i:=0 to 4 do
   begin
     for j:=0 to 4 do
      begin
        SetCardText('word_' + inttostr(i+1) + '_' + inttostr(j+1), '');
      end;
   end;

  // цвет
  for i:=0 to 4 do
   begin
     for j:=0 to 4 do
      begin
        SetCardColor('word_' + inttostr(i+1) + '_' + inttostr(j+1), clGreen);
      end;
   end;
end;

end.

