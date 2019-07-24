unit average_filter_form;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls,filters;

type

  { TFormAverage }

  TFormAverage = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private

  public

  end;

var
  FormAverage: TFormAverage;

implementation
 uses mainform;
{$R *.lfm}

{ TFormAverage }

procedure TFormAverage.TrackBar1Change(Sender: TObject);
var tmp_data: PointArray;
begin
  if Length(filtered_data)>0 then tmp_data:=average_filter(filtered_data, TrackBar1.Position)
  else tmp_data:=average_filter(raw_data, TrackBar1.Position);
  plot_filtered(tmp_data);

end;

procedure TFormAverage.Button1Click(Sender: TObject);
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

procedure TFormAverage.Button2Click(Sender: TObject);
begin
  if Length(filtered_data)>0 then filtered_data:=average_filter(filtered_data, TrackBar1.Position)
  else filtered_data:=average_filter(raw_data, TrackBar1.Position);
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

procedure TFormAverage.FormShow(Sender: TObject);
var tmp_data: PointArray;
begin
  if Length(filtered_data)>0 then tmp_data:=average_filter(filtered_data, TrackBar1.Position)
  else tmp_data:=average_filter(raw_data, TrackBar1.Position);
  plot_filtered(tmp_data);
end;

end.

