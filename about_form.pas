unit about_form;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TFormAbout }

  TFormAbout = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Memo1: TMemo;
    StaticText1: TStaticText;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.lfm}

{ TFormAbout }

procedure TFormAbout.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

