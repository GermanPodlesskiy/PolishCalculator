unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Polish_calculator, Vcl.StdCtrls;

type
  TAboutTheProgram = class(TForm)
    lblInfo: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutTheProgram: TAboutTheProgram;

implementation

{$R *.dfm}


procedure TAboutTheProgram.FormShow(Sender: TObject);
var
  str: string[50];
  text: TextFile;
begin
  AssignFile(text,'About.txt');
  Reset(text);
  while Eof(text)do
  begin
    read(text,str);
    lblInfo.Caption := str;
  end;
end;

end.

