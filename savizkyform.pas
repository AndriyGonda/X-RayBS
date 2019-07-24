unit savizkyform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, filters;

type

  { TFormSavitzky }

  TFormSavitzky = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FormSavitzky: TFormSavitzky;

implementation
 uses mainform;
{$R *.lfm}

{ TFormSavitzky }

procedure TFormSavitzky.Button1Click(Sender: TObject);
begin
  plot_filtered(filtered_data);
  Close;
  if Length(filtered_data)>0 then  begin
     FormMain.PanelBackgroundProcessing.Enabled:=True;
      FormMain.MenuItemFileSave.Enabled:=True;
       FormMain.GroupBox1.Enabled:=True;
      FormMain.GroupBox2.Enabled:=True;
   end
  else
  begin
    FormMain.PanelBackgroundProcessing.Enabled:=False;
    FormMain.MenuItemFileSave.Enabled:=False;
    FormMain.GroupBox1.Enabled:=False;
    FormMain.GroupBox2.Enabled:=False;
  end;
end;

procedure TFormSavitzky.Button2Click(Sender: TObject);
var level:integer;
begin
 level:=StrToInt(ComboBox1.Items[ComboBox1.ItemIndex]);
   if Length(filtered_data)>0 then filtered_data:=SavitzkyGolayFilter(filtered_data, level)
  else filtered_data:=SavitzkyGolayFilter(raw_data, level);
  plot_filtered(filtered_data);
  Close;
 if Length(filtered_data)>0 then  begin
     FormMain.PanelBackgroundProcessing.Enabled:=True;
      FormMain.MenuItemFileSave.Enabled:=True;
       FormMain.GroupBox1.Enabled:=True;
      FormMain.GroupBox2.Enabled:=True;
   end
  else
  begin
    FormMain.PanelBackgroundProcessing.Enabled:=False;
    FormMain.MenuItemFileSave.Enabled:=False;
    FormMain.GroupBox1.Enabled:=False;
    FormMain.GroupBox2.Enabled:=False;
  end;
end;

procedure TFormSavitzky.ComboBox1Change(Sender: TObject);
var level: integer;
    tmp_data: PointArray;
begin
  level:=StrToInt(ComboBox1.Items[ComboBox1.ItemIndex]);
   if Length(filtered_data)>0 then tmp_data:=SavitzkyGolayFilter(filtered_data, level)
  else tmp_data:=SavitzkyGolayFilter(raw_data, level);
  plot_filtered(tmp_data);
end;

procedure TFormSavitzky.FormShow(Sender: TObject);
var level: integer;
    tmp_data: PointArray;
begin
  level:=StrToInt(ComboBox1.Items[ComboBox1.ItemIndex]);
   if Length(filtered_data)>0 then tmp_data:=SavitzkyGolayFilter(filtered_data, level)
  else tmp_data:=SavitzkyGolayFilter(raw_data, level);
  plot_filtered(tmp_data);
end;

end.

