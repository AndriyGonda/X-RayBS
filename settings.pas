unit settings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls;

type

  { TFormSettings }

  TFormSettings = class(TForm)
    Button1: TButton;
    ColorButton1: TColorButton;
    ColorButton2: TColorButton;
    ColorButton3: TColorButton;
    ColorButton4: TColorButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure ColorButton1ColorChanged(Sender: TObject);
    procedure ColorButton2ColorChanged(Sender: TObject);
    procedure ColorButton3ColorChanged(Sender: TObject);
    procedure ColorButton4ColorChanged(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
  private

  public

  end;

var
  FormSettings: TFormSettings;

implementation
uses mainform;
{$R *.lfm}

{ TFormSettings }

procedure TFormSettings.Button1Click(Sender: TObject);
begin
  FormSettings.Close;
end;


procedure TFormSettings.ColorButton1ColorChanged(Sender: TObject);
begin
   FormMain.ExperimentalDataSeries.SeriesColor:=ColorButton1.ButtonColor;
   plot_experimental(raw_data);
end;

procedure TFormSettings.ColorButton2ColorChanged(Sender: TObject);
begin
  FormMain.FilteredDataSeries.SeriesColor:=ColorButton2.ButtonColor;
  plot_filtered(filtered_data);
end;

procedure TFormSettings.ColorButton3ColorChanged(Sender: TObject);
begin
  FormMain.BackgroundDataSeries.SeriesColor:=ColorButton3.ButtonColor;
  plot_background(background_data);
end;

procedure TFormSettings.ColorButton4ColorChanged(Sender: TObject);
begin
  FormMain.BackgroundDataSeries.Pointer.Brush.Color:=ColorButton4.ButtonColor;
  FormMain.BackgroundDataSeries.Pointer.Pen.Color:=ColorButton4.ButtonColor;
  plot_background(background_data);
end;

procedure TFormSettings.FormShow(Sender: TObject);
begin
  ColorButton1.ButtonColor := FormMain.ExperimentalDataSeries.SeriesColor;
  ColorButton2.ButtonColor := FormMain.FilteredDataSeries.SeriesColor;
  ColorButton3.ButtonColor := FormMain.BackgroundDataSeries.SeriesColor;
  ColorButton4.ButtonColor := FormMain.BackgroundDataSeries.Pointer.Brush.Color;
  TrackBar1.Position := FormMain.ExperimentalDataSeries.LinePen.Width;
  TrackBar2.Position := FormMain.FilteredDataSeries.LinePen.Width;
  TrackBar3.Position := FormMain.BackgroundDataSeries.LinePen.Width;
  TrackBar4.Position := FormMain.BackgroundDataSeries.Pointer.HorizSize;
end;

procedure TFormSettings.TrackBar1Change(Sender: TObject);
begin
  FormMain.ExperimentalDataSeries.LinePen.Width:=TrackBar1.Position;
  plot_experimental(raw_data);
end;

procedure TFormSettings.TrackBar2Change(Sender: TObject);
begin
  FormMain.FilteredDataSeries.LinePen.Width:=TrackBar2.Position;
  plot_filtered(filtered_data);
end;

procedure TFormSettings.TrackBar3Change(Sender: TObject);
begin
  FormMain.BackgroundDataSeries.LinePen.Width:=TrackBar3.Position;
  plot_background(background_data);
end;

procedure TFormSettings.TrackBar4Change(Sender: TObject);
begin
  FormMain.BackgroundDataSeries.Pointer.HorizSize:=TrackBar4.Position;
  FormMain.BackgroundDataSeries.Pointer.VertSize:=TrackBar4.Position;
  plot_background(background_data);
end;

end.

