unit main_board;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, Spin, capitan_board, timeout_dialog, winer_dialog;

type

  { TForm_main_board }

  TForm_main_board = class(TForm)
    Button_start_timer: TButton;
    Button_show_cards_form: TButton;
    Button_new_game: TButton;
    Button_end_move: TButton;
    Button_generate: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox_timers: TGroupBox;
    GroupBox_cards: TGroupBox;
    Label_pl_move: TLabel;
    Memo_words: TMemo;
    ProgressBar_timer: TProgressBar;
    SpinEdit_time: TSpinEdit;
    Timer_game: TTimer;
    word_1_1: TLabel;
    Label_pl_1: TLabel;
    Label_pl_2: TLabel;
    word_3_1: TLabel;
    word_2_5: TLabel;
    word_1_2: TLabel;
    word_1_3: TLabel;
    word_1_4: TLabel;
    word_1_5: TLabel;
    word_2_1: TLabel;
    word_2_2: TLabel;
    word_2_3: TLabel;
    word_2_4: TLabel;
    word_5_1: TLabel;
    word_4_5: TLabel;
    word_3_5: TLabel;
    word_3_4: TLabel;
    word_3_3: TLabel;
    word_3_2: TLabel;
    word_4_1: TLabel;
    word_4_2: TLabel;
    word_4_3: TLabel;
    word_4_4: TLabel;
    word_5_5: TLabel;
    word_5_4: TLabel;
    word_5_3: TLabel;
    word_5_2: TLabel;
    procedure Button_end_moveClick(Sender: TObject);
    procedure Button_generateClick(Sender: TObject);
    procedure Button_new_gameClick(Sender: TObject);
    procedure Button_show_cards_formClick(Sender: TObject);
    procedure Button_start_timerClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ClickOnCard(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer_gameTimer(Sender: TObject);

  private
    { private declarations }

    { очистка игрового поля }
    procedure Clear_board();

    { установка цвета карты }
    procedure SetCardColor(_card_name: string; _color: TColor);

    { установка текста карты }
    procedure SetCardText(_card_name: string; _text: String);

    { установка текста всех карт }
    procedure SetAllCardText();

    { открытие карты }
    procedure OpenCard(_line, _row: integer);

    { смена игрока (переход хода) }
    procedure ChangePlayer();

    { проверка на завершение игры }
    function CheckEndGame(_player: integer; var _player_win: integer): boolean;

  public
    { public declarations }
  end;

var
  Form_main_board: TForm_main_board;

  cards_pos: array [0..4, 0..4] of integer;    // расположение карт на поле
  cards_words: array [0..4, 0..4] of string;   // слова на картах

  cards_count: integer = 8;   // количество карт для игрока

{ TODO: доделать цвета карт, чтобы можно было менять их от сюда
        и запилить поддержку тем }
//  color_pl_1_card: TColor = clMaroon;
//  color_pl_2_card: TColor = clNavy;
//  color_bad_card: TColor = clBlack;
//  color_default_card = clGreen;

implementation

{$R *.lfm}

{ TForm_main_board }

procedure TForm_main_board.Button_generateClick(Sender: TObject);
var
  i,j: integer;
  player_1: integer = 0;     // количество карт заданных для игрока 1
  player_2: integer = 0;     // количество карт заданных для игрока 2
  empty: integer = 0;        // количество нейтральных карт
  bad_card: integer = 0;     // установлена ли плохая карта
  rand_val: integer;         // сгенерированное значение
  word_n: integer;           // номер слова в словаре

  pl_1: integer;
  pl_2: integer;
begin
  Memo_words.Lines.LoadFromFile('words');
  Randomize;

// выбор кто первый ходит
// у первого на одну карту больше
  if random(2) = 0 then
    begin
      pl_1:=1;
      pl_2:=2;
      Label_pl_move.Color:= clMaroon;
    end
  else
    begin
      pl_1:=2;
      pl_2:=1;
      Label_pl_move.Color:= clNavy;
    end;

  for i:=0 to 4 do
   begin
     for j:=0 to 4 do
     begin
       while true do
         begin
         rand_val:= Random(4);

         // нейтральнеые
         if (rand_val = 0) and (empty < (25-cards_count*2-2)) then
           begin
             cards_pos[i][j]:= 0;
             inc(empty);
             break;
           end;

         // первый игрок
         if (rand_val = 1) and (player_1 < cards_count+1) then
           begin
             cards_pos[i][j]:= pl_1;
             inc(player_1);
             break;
           end;

         // второй игрок
         if (rand_val = 2) and (player_2 < cards_count) then
           begin
             cards_pos[i][j]:= pl_2;
             inc(player_2);
             break;
           end;

         // плохая карта
         if (rand_val = 3) and (bad_card = 0) then
           begin
             cards_pos[i][j]:= 3;
             inc(bad_card);
             break;
           end;
         end;
       // получение слова из словаря и привязка к карте
       word_n:= random(Memo_words.Lines.Count-2);
       cards_words[i][j]:= Memo_words.Lines[word_n];
       Memo_words.Lines.Delete(word_n);        // удаляем для избежания повторов
     end;
   end;

  Clear_board;
  SetAllCardText();
  Form_capitan_board.ShowCards();  // обновление поля для капитанов
end;

procedure TForm_main_board.Button_end_moveClick(Sender: TObject);
begin
  Form_main_board.ChangePlayer();
end;

procedure TForm_main_board.Button_new_gameClick(Sender: TObject);
begin
  Button_generateClick(Sender);
  Label_pl_1.Caption:='0';
  Label_pl_2.Caption:='0';
end;

procedure TForm_main_board.Button_show_cards_formClick(Sender: TObject);
begin
  Button_show_cards_form.Visible:=False;
  Form_capitan_board.Show;
end;

procedure TForm_main_board.Button_start_timerClick(Sender: TObject);
begin
  ProgressBar_timer.Position:=0;
  if Timer_game.Enabled = True then
    begin
      Timer_game.Enabled:=False;
      Button_start_timer.Caption:='Старт';
    end
  else
    begin
      ProgressBar_timer.Max:=integer(SpinEdit_time.Value*60);// таймер в минутах
      Timer_game.Enabled:=True;
      Button_start_timer.Caption:='Стоп';
    end;
end;

procedure TForm_main_board.FormResize(Sender: TObject);
var
  card_width: integer;
  card_height: integer;
  indent: integer = 10;  // зазор между картами
begin
  // подсчёт размера карты
  card_width:= round((GroupBox_cards.Width - indent*8)/5);
  card_height:= round((GroupBox_cards.Height - indent*10)/5);

  // расставляем верхнюю строку и первый столбц, остальные привязаны к ним

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

procedure TForm_main_board.ClickOnCard(Sender: TObject);
var
  i,j: integer;
  card_line: integer;
  card_row: integer;
  player_activ: integer;
  player_win: integer;
  player_name: string;
  pl_1_score: integer;
  pl_2_score: integer;
begin
  // если карта уже перевёрнута - не обрабатываем нажатие
  if (Sender as Tlabel).Caption = '' then exit;

  // поиск координат карты на которую нажали
  for i:=0 to 4 do
   begin
     for j:=0 to 4 do
      begin
        if (Sender as Tlabel).Name = 'word_' +inttostr(i+1)+ '_' + inttostr(j+1)
        then
          begin
            card_line:=i;
            card_row:=j;
          end;
      end;
   end;
  OpenCard(card_line, card_row);

  // определение текущего игрока
  if Label_pl_move.Color = clMaroon then player_activ:=1
                                    else player_activ:=2;

  // вывод сообщения о победе команды
  if CheckEndGame(player_activ, player_win) then
    begin
      if player_win = 1
        then
          begin
            player_name:= 'КРАСНЫХ!';
            pl_1_score:=strtoint(Label_pl_1.Caption);
            inc(pl_1_score);
            Label_pl_1.Caption:=inttostr(pl_1_score);
          end
        else
          begin
            player_name:= 'СИНИХ!';
            pl_2_score:=strtoint(Label_pl_2.Caption);
            inc(pl_2_score);
            Label_pl_2.Caption:=inttostr(pl_2_score);
          end;
      Form_winer.Label_winer.Caption:='Выиграла команда ' + player_name;
      Form_winer.ShowModal;
    end;

  // переход хода, если карта не цвета игрока
  if (Sender as Tlabel).Color <> Label_pl_move.Color
    then ChangePlayer();

  // обновление поля капитанов
  Form_capitan_board.ShowCards();
end;

procedure TForm_main_board.FormShow(Sender: TObject);
begin
  Form_capitan_board.Show;
  Clear_board;
end;

procedure TForm_main_board.Timer_gameTimer(Sender: TObject);
begin
  ProgressBar_timer.Position:= ProgressBar_timer.Position+1;
  if ProgressBar_timer.Position = ProgressBar_timer.Max then
    begin
      Timer_game.Enabled:=False;
      Button_start_timer.Caption:='Старт';
      Form_timeout.ShowModal;
    end;
end;

procedure TForm_main_board.Clear_board;
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

procedure TForm_main_board.SetCardColor(_card_name: string; _color: TColor);
begin
  (FindComponent(_card_name) as Tlabel).Color:= _color;
end;

procedure TForm_main_board.SetCardText(_card_name: string; _text: String);
begin
  (FindComponent(_card_name) as Tlabel).Caption:= _text;
end;

procedure TForm_main_board.SetAllCardText;
var
  i,j: integer;
begin
  for i:=0 to 4 do
   begin
     for j:=0 to 4 do
      begin
        SetCardText('word_' + inttostr(i+1) + '_' + inttostr(j+1),
                    cards_words[i][j]);
      end;
   end;
end;

procedure TForm_main_board.OpenCard(_line, _row: integer);
var
  card_name: string;
begin
  card_name:= 'word_' + inttostr(_line+1) + '_' + inttostr(_row+1);

  // устаноовка цвета карты
  if cards_pos[_line][_row] = 0 then SetCardColor(card_name, $F0F0F0);
  if cards_pos[_line][_row] = 1 then SetCardColor(card_name, clMaroon);
  if cards_pos[_line][_row] = 2 then SetCardColor(card_name, clNavy);
  if cards_pos[_line][_row] = 3 then SetCardColor(card_name, clBlack);
  // очистка текста карты
  SetCardText(card_name, '');
end;

procedure TForm_main_board.ChangePlayer;
begin
  if Label_pl_move.Color = clMaroon
    then Label_pl_move.Color:= clNavy
    else Label_pl_move.Color:= clMaroon;
end;

function TForm_main_board.CheckEndGame(_player: integer;
                                       var _player_win: integer): boolean;
var
  i,j: integer;
  pl_1_opened: integer = 0;
  pl_2_opened: integer = 0;
  pl_1_count: integer = 0;
  pl_2_count: integer = 0;
  card_name: string;
  bad_opened: boolean = False;
begin
  for i:=0 to 4 do
   begin
     for j:=0 to 4 do
      begin
        // подсчитываем общее количество карт игрока
        if cards_pos[i][j] = 1 then inc(pl_1_count);
        if cards_pos[i][j] = 2 then inc(pl_2_count);
        // количество открытых карт игрока
        card_name:= 'word_' + inttostr(i+1) + '_' + inttostr(j+1);
        if (FindComponent(card_name) as Tlabel).Caption = '' then
          begin
            if cards_pos[i][j] = 1 then inc(pl_1_opened);
            if cards_pos[i][j] = 2 then inc(pl_2_opened);
            if cards_pos[i][j] = 3 then bad_opened:= true;
          end;
      end;
   end;

  result:= False;

  // все карты первого игрока открыты
  if pl_1_count = pl_1_opened then
    begin
      _player_win:= 1;
      result:= True;
    end;

  // все карты второго игрока открыты
  if pl_2_count = pl_2_opened then
    begin
      _player_win:= 2;
      result:= True;
    end;

  // открыта плохая карта
  if bad_opened then
    begin
      if _player = 1 then _player_win:= 2
                     else _player_win:= 1;
      result:= True;
    end;
end;

end.

