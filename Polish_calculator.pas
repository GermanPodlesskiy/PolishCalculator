unit Polish_calculator;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.ImageList,
  Vcl.ImgList, Vcl.Controls, Vcl.StdActns, System.Classes, System.Actions,
  Vcl.ActnList, Vcl.Menus, Vcl.StdCtrls, System.Variants,  Vcl.Graphics,
  Vcl.Forms, Vcl.Dialogs,Vcl.ExtCtrls, Vcl.WinXPanels, Vcl.Touch.Keyboard, System.Math,
  Vcl.ComCtrls;

type
  TPolish_calculator1 = class(TForm)
    btnZero: TButton;
    btnOne: TButton;
    btnTwo: TButton;
    btnFour: TButton;
    btnFive: TButton;
    btnThree: TButton;
    btnSix: TButton;
    btnSeven: TButton;
    btnEight: TButton;
    btnNine: TButton;
    btnEqually: TButton;
    btnSum: TButton;
    btnMinus: TButton;
    btnMultiplay: TButton;
    btnDiv: TButton;
    btnPower: TButton;
    btnBrackedL: TButton;
    btnBrackedR: TButton;
    btnClean: TButton;
    btnErase: TButton;
    mmoForInputExpression: TMemo;
    mmMainMenu: TMainMenu;
    File1: TMenuItem;
    aboutthedeveloper1: TMenuItem;
    aboutthedeveloper2: TMenuItem;
    btnDot: TButton;
    actlst1: TActionList;
    il1: TImageList;
    FileOpen: TFileOpen;
    SaveAs: TFileSaveAs;
    FileExit1: TFileExit;
    �����: TMenuItem;
    chk1: TCheckBox;
    btnHistory: TButton;
    udRound: TUpDown;
    edtRound: TEdit;
    lblRound: TLabel;
    procedure btnZeroClick(Sender: TObject);
    procedure btnOneClick(Sender: TObject);
    procedure btnTwoClick(Sender: TObject);
    procedure btnThreeClick(Sender: TObject);
    procedure btnSixClick(Sender: TObject);
    procedure btnSevenClick(Sender: TObject);
    procedure btnEightClick(Sender: TObject);
    procedure btnNineClick(Sender: TObject);
    procedure btnBrackedLClick(Sender: TObject);
    procedure btnBrackedRClick(Sender: TObject);
    procedure btnPowerClick(Sender: TObject);
    procedure btnDivClick(Sender: TObject);
    procedure btnMultiplayClick(Sender: TObject);
    procedure btnMinusClick(Sender: TObject);
    procedure btnSumClick(Sender: TObject);
    procedure mmoForInputExpressionChange(Sender: TObject);
    procedure btnCleanClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure aboutthedeveloper2Click(Sender: TObject);
    procedure btnFourClick(Sender: TObject);
    procedure btnFiveClick(Sender: TObject);
    procedure btnEraseClick(Sender: TObject);
    procedure btnEquallyClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnDotClick(Sender: TObject);
    procedure btnHistoryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TStack =^Stack;
  Stack = record
    data: Char;
    next: TStack;
    end;


var
  Polish_calculator1: TPolish_calculator1;

implementation

uses
  Unit1, Unit2;


{$R *.dfm}

procedure showHistory(name: string);
type
  TShortString = string[255];

var
  history: file of TShortString;
  outputString: TShortString;

begin
    Form2.mmoHistory.Text := '';
    AssignFile(history,name);
    if ( FileExists(name)) then
    begin
      Reset(history);

      while not Eof(history) do
      begin
        read(history,outputString);
        Form2.mmoHistory.Lines.Add(outputString);
        form2.mmoHistory.Lines.Add('');
      end;
      CloseFile(history);
    end;
end;

function searchErrorsMemo(searchString: TMemo):Boolean;

var
  i: Integer;
  valueNumbers: Byte;
  numberOperation: Byte;
  errors: Boolean;

begin
  valueNumbers := 0;
  numberOperation := 0;
  errors := False;
  if (searchString.Text = '') or (not '0123456789('.Contains(searchString.Text[1])) then
  begin
    ShowMessage('������� �������� ���������, ��������� ����!!!');
    errors := True;
    Result := errors;
    exit
  end
  else
    for i := 1 to Length(searchString.Text) do
    begin
      if ('0123456789('.Contains(searchString.Text[i])) then
      begin
        Inc(valueNumbers);
        numberOperation := 0;
      end
      else
        if ('+-*/^'.Contains(searchString.Text[i])) then
        begin
          valueNumbers := 0;
          Inc(numberOperation);
        end
        else
          if (searchString.Text[i] = ' ') then
          begin
            valueNumbers := 0;
            numberOperation := 0;
          end;


      if ((valueNumbers > 10) or (numberOperation > 1)) then
      begin
        ShowMessage('������� �������� ���������, ��������� ����!!!');
        errors := True;
        Result := errors;
        Exit
      end;
    end;

  if (not errors) then
  begin
    for i := 0 to Length(searchString.Text) do
      if (searchString.Text[i] = '=') then
      begin
        searchString.Clear;
        errors := True;
        ShowMessage('���� �� �������, ��������� ����!!!');
        Result := errors;
        Exit
      end;
     valueNumbers := 0;
     for i := 0 to Length(searchString.Text) do
     begin
      case searchString.Text[i] of
        '(': Inc(valueNumbers);
        ')': Dec(valueNumbers);
      end;
     end;
     if (valueNumbers<>0) then
     begin
       ShowMessage('������� �������� ���������, ��������� ����!!!');
       errors := True;
       Result := errors;
       Exit
     end;
  end;

  if ((errors) and (not '0123456789'.Contains(searchString.Text[Length(searchString.Text)])))  then
  begin
    ShowMessage('������� �������� ���������, ��������� ����!!!');
    errors := True;
  end;


  Result := errors;
end;

function priority(symb: Char):Byte;
begin
  case symb of
    '+','-' : Result := 2;
    '*','/' : Result := 3;
    '^' : Result := 4;
    '(' : Result := 0;
    ')' : Result := 1
  else
    Result := 0;
  end;
end;

procedure inputStack (var stack: TStack;symbl: char);
var
  x: TStack;
begin
  New(x);
  x^.data := symbl;
  x^.next := stack;
  stack := x;
end;

procedure ifBracket (var inputString: string);
var
  i: Integer;
begin
  while inputString[1] = ' ' do
    Delete(inputString,1,1);

  while inputString[Length(inputString)] = ' ' do
    Delete(inputString,Length(inputString),1);

  for i:= 1 to Length(inputString) do
    if ((inputString[i] = '(') or (inputString[i] = ')'))then
      Delete(inputString,i,1);
  for i := 3 to Length(inputString) do
    if ((inputString[i-1] = ' ') and (inputString[i] = ' ')) then
      Delete(inputString,i,1);
end;

procedure stacktToStr(var inputString: string; var stack: TStack);
begin
  inputString := inputString + ' ' + stack^.data + ' ';
  stack := stack^.next;
end;

function polishEntry (inputString: string):string;

var
  outString: string;
  i: Byte;
  symblStack: TStack;
  moreTop,clearStack,bracked: Boolean;

begin
  new(symblStack);
  symblStack^.next := nil;
  outString := '';
  clearStack := True;
  i := 1;
  while i <= Length(inputString) do
  begin
    outString := outString + inputString[i];

    if (inputString[i] = '(') then
    begin
      inputStack(symblStack,inputstring[i]);
      bracked := True
    end
    else
      bracked := false;

     if (not ('01234567890'.Contains(inputString[i])) and (not bracked) and  (inputString[i] <> ',')) then
    begin

      Delete(outString,Length(outString),1);
      outString := outString + ' ';
      if (symblStack^.next = nil) then
      begin
        inputStack(symblStack,inputString[i]);
        clearStack := False;
      end;

      moreTop := False;
      if (inputstring[i] = ')') then
      begin
        while (symblStack^.data <> '(')  do
        begin
          stacktToStr(outString,symblStack)
        end;
        symblStack := symblStack^.next;
        clearStack := False;
      end
      else
        while (priority(inputString[i])<=priority(symblStack^.data)) and (clearStack) do
        begin
          stacktToStr(outString,symblStack);
          moreTop := True;
          if (symblStack^.next = nil) then
            clearStack := False;
        end;

      if ((moreTop) and (inputString[i] <> ')')) then
        inputStack(symblStack,inputString[i]);

      if ((not moreTop) and (clearStack)) then
      begin
        inputStack(symblStack,inputString[i]);
      end;
      clearStack := True;
    end;
    Inc(i);
  end;

  while  symblStack^.next <> nil do
  begin
    stacktToStr(outString,symblStack);
  end;
  ifBracket(outString);
  Result := outString;
end;

function evalutionExpression(inputString: string):String;
type
  TStack = ^stack;
  stack = record
    date: Extended;
    next: TStack;
    end;

var
  oneOperand,twoOperand: Extended;
  stackNumber,bufStack: TStack;
  operandString: string;
  i: Integer;
begin
  operandString := '';
  New(stackNumber);
  stackNumber^.date := StrToFloat(copy(inputString,1,Pos(' ',inputString)-1));
  Delete(inputString,1,Pos(' ',inputString));
  while (Pos(' ',inputString)>0)  do
  begin
    operandString := copy(inputString,1,Pos(' ',inputString)-1);
    Delete(inputString,1,Pos(' ',inputString));
    twoOperand := 0;
    if ('+-*/^'.Contains(operandString[1])) then
    begin

      twoOperand := stackNumber^.date;
      stackNumber := stackNumber^.next;
      oneOperand := stackNumber^.date;
      stackNumber := stackNumber^.next;
      try
        if  ((operandString[1] = '/') and (twoOperand = 0)) then
        begin
          ShowMessage('������� �� ����.');
          break
        end
        else
          case operandString[1] of

            '+': oneOperand := oneOperand + twoOperand;
            '-': oneOperand := oneOperand - twoOperand;
            '*': oneOperand := oneOperand * twoOperand;
            '/': oneOperand := oneOperand / twoOperand;
            '^': oneOperand := Power(oneOperand,twoOperand);

          end;
      except
        ShowMessage('������� �������� ���������, ��������� ����!!!');
        result := 'nil';
        exit
      end;
      New(bufStack);
      bufStack^.date := oneOperand;
      bufStack^.next := stackNumber;
      stackNumber := bufStack;
    end
    else
    begin
      New(bufStack);
      bufStack^.date := strToFloat(operandString);
      bufStack^.next := stackNumber;
      stackNumber := bufStack;
    end;

    for i := 0 to 1 do
      if ((Length(inputString)>0) and (inputString[1]=' ')) then
          Delete(inputString,1,1)
  end;
  if  ((operandString[1] = '/') and (twoOperand = 0)) then
    Result := 'nil'
  else
    Result := FloatToStr(stackNumber^.date);
end;

procedure TPolish_calculator1.aboutthedeveloper2Click(Sender: TObject);
begin
  AboutTheProgram.Show;
end;

procedure TPolish_calculator1.btnBrackedLClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '(';
end;

procedure TPolish_calculator1.btnBrackedRClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + ')';
end;

procedure TPolish_calculator1.btnCleanClick(Sender: TObject);
begin
  mmoForInputExpression.Clear;
end;

procedure TPolish_calculator1.btnDivClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '/';
end;

procedure TPolish_calculator1.btnDotClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + ',';
end;

procedure TPolish_calculator1.btnEightClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '8';
end;

procedure TPolish_calculator1.btnEquallyClick(Sender: TObject);
type
  TShortString = string[255];
var
  inputString,outString: string;
  i: Byte;
  resultNumber:Extended;
  history: file of TShortString;
  expression: TShortString;
begin
  if (not searchErrorsMemo(mmoForInputExpression))  then
  begin
    inputString := '';
    i := 1;
    while mmoForInputExpression.Text[i] <> #0 do
    begin
      inputString := inputString + mmoForInputExpression.Text[i];
      Inc(i);
    end;

    outString := polishEntry(inputString);
    ifBracket(outString);
    outString := outString + ' ';

    if (evalutionExpression(outString) <> 'nil') then
    begin
      if (chk1.Checked = True) then
        mmoForInputExpression.Text := mmoForInputExpression.Text+' = '+outString;

      resultNumber := StrToFloat(evalutionExpression(outString));
      i := StrToInt(edtRound.Text);
      mmoForInputExpression.Text := mmoForInputExpression.Text + ' = '+FloatToStrF(resultNumber,ffNumber,18,i);

      // ������ � ����
      AssignFile(history,'History');
      if (not FileExists('History')) then
        Rewrite(history);

      Reset(history);
      while (not Eof(history))  do
        read(history,expression);

      expression := mmoForInputExpression.Text;
      Write(history,expression);
      CloseFile(history);
    end
  end;
end;

procedure TPolish_calculator1.btnEraseClick(Sender: TObject);
var
  str: string;
begin
  Str := mmoForInputExpression.Text;
  delete(str, length(str), 1);
  mmoForInputExpression.Text := str;
end;

procedure TPolish_calculator1.btnFiveClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '5';
end;

procedure TPolish_calculator1.btnFourClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '4';
end;

procedure TPolish_calculator1.btnHistoryClick(Sender: TObject);
begin
  Form2.Show;
  showHistory('History');
end;

procedure TPolish_calculator1.btnMinusClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '-';
end;

procedure TPolish_calculator1.btnMultiplayClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '*';
end;

procedure TPolish_calculator1.btnNineClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '9';
end;

procedure TPolish_calculator1.btnOneClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '1';
end;

procedure TPolish_calculator1.btnPowerClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '^';
end;

procedure TPolish_calculator1.btnSevenClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '7';
end;

procedure TPolish_calculator1.btnSixClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '6';
end;

procedure TPolish_calculator1.btnSumClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '+';
end;

procedure TPolish_calculator1.btnThreeClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '3';
end;

procedure TPolish_calculator1.btnTwoClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '2';
end;

procedure TPolish_calculator1.btnZeroClick(Sender: TObject);
begin
  mmoForInputExpression.Text := mmoForInputExpression.Text + '0';
end;

procedure TPolish_calculator1.Exit1Click(Sender: TObject);
begin
  Polish_calculator1.Close;
end;


procedure TPolish_calculator1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 8) then
     btnErase.Click
end;


procedure TPolish_calculator1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    '(': btnBrackedL.Click;
    ')': btnBrackedR.Click;
    '^': btnPower.Click;
    '+': btnSum.Click;
    '-': btnMinus.Click;
    '*': btnMultiplay.Click;
    '/': btnDiv.Click;
    '0': btnZero.Click;
    '1': btnOne.Click;
    '2': btnTwo.Click;
    '3': btnThree.Click;
    '4': btnFour.Click;
    '5': btnFive.Click;
    '6': btnSix.Click;
    '7': btnSeven.Click;
    '8': btnEight.Click;
    '9': btnNine.Click;
    '.': btnDot.Click;
  end;
end;

procedure TPolish_calculator1.mmoForInputExpressionChange(Sender: TObject);
var
  s: string;
begin
  if mmoForInputExpression.Lines[0] = '���� ���������:' then
  begin
    s := mmoForInputExpression.Lines[1];
    mmoForInputExpression.Clear;
    mmoForInputExpression.Text :=  s;
  end;
  mmoForInputExpression.SelStart := Length(mmoForInputExpression.Text);
  mmoForInputExpression.SelLength := 1;
end;
end.
