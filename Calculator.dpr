program Calculator;

uses
  Vcl.Forms,
  Polish_calculator in 'Polish_calculator.pas' {Polish_calculator1},
  Unit1 in 'Unit1.pas' {AboutTheProgram},
  Vcl.Themes,
  Vcl.Styles,
  Unit2 in 'Unit2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Onyx Blue');
  Application.CreateForm(TPolish_calculator1, Polish_calculator1);
  Application.CreateForm(TAboutTheProgram, AboutTheProgram);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
