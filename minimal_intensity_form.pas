unit minimal_intensity_form;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Spin, StdCtrls,filters;

type

  { TFormMinIntensity }

  TFormMinIntensity = class(TForm)
    Button1: TButton;
    Button2: TButton;
    LabelMinIntensity: TLabel;
    SpinEditMinIntensity: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpinEditMinIntensityChange(Sender: TObject);
  private

  public

  end;

var
  FormMinIntensity: TFormMinIntensity;

implementation
uses mainform;
{$R *.lfm}

{ TFormMinIntensity }


procedure TFormMinIntensity.Button1Click(Sender: TObject);
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

procedure TFormMinIntensity.Button2Click(Sender: TObject);
begin

  if Length(filtered_data)>0 then filtered_data:=minimal_intensity_filter(filtered_data,SpinEditMinIntensity.Value)
  else filtered_data:=minimal_intensity_filter(raw_data,SpinEditMinIntensity.Value);
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


procedure TFormMinIntensity.FormShow(Sender: TObject);
var tmp_data: PointArray;
begin
   if Length(filtered_data)>0 then tmp_data:=minimal_intensity_filter(filtered_data,SpinEditMinIntensity.Value)
  else tmp_data:=minimal_intensity_filter(raw_data,SpinEditMinIntensity.Value);
   plot_filtered(tmp_data);
end;


procedure TFormMinIntensity.SpinEditMinIntensityChange(Sender: TObject);
var tmp_data: PointArray;
begin
   if Length(filtered_data)>0 then tmp_data:=minimal_intensity_filter(filtered_data,SpinEditMinIntensity.Value)
  else tmp_data:=minimal_intensity_filter(raw_data,SpinEditMinIntensity.Value);
   plot_filtered(tmp_data);
end;

end.

