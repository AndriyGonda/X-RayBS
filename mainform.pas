unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TATools, TANavigation,
  TATransformations, TASeries, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, StdCtrls, IniPropStorage, Spin, filters, minimal_intensity_form,
  settings, average_filter_form, savizkyform, TAChartUtils,background_processing, about_form, unit_ppm_calculator,
  spectrum_comparator;

type

  { TFormMain }

  TFormMain = class(TForm)
    Button2: TButton;
    ButtonFindMinimums: TButton;
    ButtonInterpolate: TButton;
    Chart: TChart;
    ChartAxisTransformations: TChartAxisTransformations;
    ChartAxisTransformationsLinearAxisTransform: TLinearAxisTransform;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    IniPropStorageSettings: TIniPropStorage;
    MenuItemTools: TMenuItem;
    MenuItemPPMCalculator: TMenuItem;
    MenuItemSpectrumComparator: TMenuItem;
    MenuItemAbout: TMenuItem;
    MenuItemReset: TMenuItem;
    MenuItemSavitzkyFilter: TMenuItem;
    MenuItemAverageFilter: TMenuItem;
    MenuItemSettings: TMenuItem;
    MenuItemAppereance: TMenuItem;
    MenuItemFiltering: TMenuItem;
    MenuItemMinIntensity: TMenuItem;
    PanelBackgroundProcessing: TPanel;
    RadioCrossMinimums: TRadioButton;
    RadioFindMinimums: TRadioButton;
    RadioGroup1: TRadioGroup;
    SaveDialog1: TSaveDialog;
    ShowExperimental: TCheckBox;
    ShowFiltered: TCheckBox;
    ShowBackground: TCheckBox;
    CheckGroup1: TCheckGroup;
    ExperimentalDataSeries: TLineSeries;
    FilteredDataSeries: TLineSeries;
    BackgroundDataSeries: TLineSeries;
    ChartToolsetDataPointDragTool: TDataPointDragTool;
    ChartToolsetZoomDragTool: TZoomDragTool;
    ChartVertScroll: TChartNavScrollBar;
    ChartHorScroll: TChartNavScrollBar;
    ChartToolset: TChartToolset;
    MainMenu: TMainMenu;
    MenuItemFileOpen: TMenuItem;
    MenuItemFileSave: TMenuItem;
    MenuItemExit: TMenuItem;
    MenuItemFile: TMenuItem;
    OpenFileDialog: TOpenDialog;
    Panel: TPanel;
    SpinEdit1: TSpinEdit;
    procedure ButtonInterpolateClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ButtonFindMinimumsClick(Sender: TObject);
    procedure ChartToolsetDataPointDragToolDrag(ASender: TDataPointDragTool;
      var AGraphPoint: TDoublePoint);
    procedure ChartToolsetDataPointDragToolDragStart(
      ASender: TDataPointDragTool; var AGraphPoint: TDoublePoint);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure MenuItemAppereanceClick(Sender: TObject);
    procedure MenuItemAverageFilterClick(Sender: TObject);
    procedure MenuItemExitClick(Sender: TObject);
    procedure MenuItemFileOpenClick(Sender: TObject);
    procedure MenuItemFileSaveClick(Sender: TObject);
    procedure MenuItemMinIntensityClick(Sender: TObject);
    procedure MenuItemPPMCalculatorClick(Sender: TObject);
    procedure MenuItemResetClick(Sender: TObject);
    procedure MenuItemSavitzkyFilterClick(Sender: TObject);
    procedure MenuItemSpectrumComparatorClick(Sender: TObject);
    procedure RadioCrossMinimumsChange(Sender: TObject);
    procedure RadioFindMinimumsChange(Sender: TObject);
    procedure ShowBackgroundChange(Sender: TObject);
    procedure ShowExperimentalChange(Sender: TObject);
    procedure ShowFilteredChange(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
  private

  public

  end;

var
  FormMain: TFormMain;
  raw_data,filtered_data,background_data: PointArray;
  live_time,input_fname: string;
  procedure plot_filtered(data: PointArray);
  procedure plot_experimental(data: PointArray);
  procedure plot_background(data: PointArray);
  function getDataFromFile(filename: string): PointArray;
implementation
{$R *.lfm}

{ TFormMain }

function getDataFromFile(filename: string): PointArray;
var
 Buffer: TStringList;
 data: PointArray;
 count: integer;
 i: integer;
begin
    Buffer:=TStringList.Create;
    Buffer.LoadFromFile(filename);
    input_fname:=filename;
    live_time:=Buffer[0];
    Buffer.Delete(0);
    Buffer.Delete(1);
    Buffer[0]:='0';
    count:=Buffer.Count;
    SetLength(data,0);
    SetLength(data, count);
    for i:=0 to count-1 do
    begin
      data[i].y := StrToInt(Buffer[i]);
      data[i].x:=i;
    end;
 getDataFromFile:=data;
end;
procedure save_to_file(filename: string);
var output: TStringList;
 i,j: integer;
begin
  output:=TStringList.Create;
  if (Length(filtered_data)>0)and(Length(live_time)>0) then
  begin
    output.Append(live_time);
    output.Append('');
     for i:=2 to 2049 do output.Append('0');
    for j:=0 to Length(filtered_data)-1 do
       begin
          output[Round(filtered_data[j].x)+2]:=IntToStr(round(filtered_data[j].y))
       end;
     output.SaveToFile(filename);
  end;
  output.Destroy;
end;
 procedure plot_experimental(data: PointArray);
 var i,count: integer;
 begin
    count := Length(data);
    FormMain.ExperimentalDataSeries.Clear;
    if (count>0)and(FormMain.ShowExperimental.Checked) then
    begin
      for i:=0 to count-1 do
      begin
        if data[i].y>0 then
        FormMain.ExperimentalDataSeries.AddXY(data[i].x, data[i].y);
      end;
    end;
 end;
procedure plot_filtered(data: PointArray);
  var i,count: integer;
 begin
    count := Length(data);
    FormMain.FilteredDataSeries.Clear;
    if (count>0)and(FormMain.ShowFiltered.Checked) then
    begin
      for i:=0 to count-1 do
      begin
        if data[i].y>0 then
        FormMain.FilteredDataSeries.AddXY(data[i].x, data[i].y);
      end;
    end;
 end;

procedure plot_background(data: PointArray);
  var i,count: integer;
 begin
    count := Length(data);
    FormMain.BackgroundDataSeries.Clear;
    if (count>0)and(FormMain.ShowBackground.Checked) then
    begin
      for i:=0 to count-1 do
      begin
        if data[i].y>0 then
        FormMain.BackgroundDataSeries.AddXY(data[i].x, data[i].y);
      end;
    end;
 end;

procedure TFormMain.MenuItemFileOpenClick(Sender: TObject);
begin
 if OpenFileDialog.Execute then
 begin
    raw_data:=getDataFromFile(OpenFileDialog.FileName);
    input_fname:=OpenFileDialog.FileName;
    FilteredDataSeries.Clear;
    BackgroundDataSeries.Clear;
    SetLength(filtered_data,0);
    SetLength(background_data,0);
   plot_experimental(raw_data);
   Chart.Title.Visible:=True;
   Chart.Title.Text.Clear;
   Chart.Title.Text.Add(ExtractFileName(input_fname));
   if Length(raw_data)>0 then
   begin
     MenuItemFileSave.Enabled:=True;
     MenuItemFiltering.Enabled:=True;
   end
   else
    begin
     MenuItemFileSave.Enabled:=False;
     MenuItemFiltering.Enabled:=False;
   end;

    ShowExperimental.Checked:=True;
   if Length(filtered_data)>0 then  begin
     FormMain.PanelBackgroundProcessing.Enabled:=True;
      MenuItemFileSave.Enabled:=True;
      GroupBox1.Enabled:=True;
      GroupBox2.Enabled:=True;
   end
  else
  begin
    FormMain.PanelBackgroundProcessing.Enabled:=False;
    MenuItemFileSave.Enabled:=False;
    GroupBox1.Enabled:=False;
    GroupBox2.Enabled:=False;
  end;

 end;
end;

procedure TFormMain.MenuItemFileSaveClick(Sender: TObject);
var fstr: string;
begin
 fstr:=ExtractFileName(input_fname);
 fstr:=ExtractFileNameWithoutExt(fstr);
 SaveDialog1.FileName:=fstr+'_changed.txt';
 if SaveDialog1.Execute then
 begin
  save_to_file(SaveDialog1.FileName);
 end;
end;

procedure TFormMain.MenuItemMinIntensityClick(Sender: TObject);
begin
    FormMinIntensity.Show;
end;

procedure TFormMain.MenuItemPPMCalculatorClick(Sender: TObject);
begin
   FormPPMCalculator.Show;
end;

procedure TFormMain.MenuItemResetClick(Sender: TObject);
begin
  SetLength(filtered_data, 0);
  SetLength(background_data,0);
  plot_background(background_data);
  plot_filtered(filtered_data);
  ShowExperimental.Checked:=True;
   if Length(filtered_data)>0 then  begin
     FormMain.PanelBackgroundProcessing.Enabled:=True;
      MenuItemFileSave.Enabled:=True;
      GroupBox1.Enabled:=True;
      GroupBox2.Enabled:=True;
   end
  else
  begin
    FormMain.PanelBackgroundProcessing.Enabled:=False;
    MenuItemFileSave.Enabled:=False;
    GroupBox1.Enabled:=False;
    GroupBox2.Enabled:=False;
  end;
end;

procedure TFormMain.MenuItemSavitzkyFilterClick(Sender: TObject);
begin
   FormSavitzky.Show;
end;

procedure TFormMain.MenuItemSpectrumComparatorClick(Sender: TObject);
begin
  FormSpectrumComparator.Show;
end;


procedure TFormMain.RadioCrossMinimumsChange(Sender: TObject);
begin
  if RadioCrossMinimums.Checked then
  begin
    GroupBox1.Visible:=True;
    GroupBox2.Visible:=False;
  end
  else
   begin
    GroupBox1.Visible:=False;
    GroupBox2.Visible:=True;
   end;
end;

procedure TFormMain.RadioFindMinimumsChange(Sender: TObject);
begin
  if RadioFindMinimums.Checked
  then
  begin
    GroupBox1.Visible:=False;
    GroupBox2.Visible:=True;
  end
  else
  begin
    GroupBox1.Visible:=True;
    GroupBox2.Visible:=False;
  end;
end;

procedure TFormMain.ShowBackgroundChange(Sender: TObject);
begin
  plot_background(background_data);
end;

procedure TFormMain.ShowExperimentalChange(Sender: TObject);
begin
  plot_experimental(raw_data);
end;

procedure TFormMain.ShowFilteredChange(Sender: TObject);
begin
  plot_filtered(filtered_data);
end;

procedure TFormMain.SpinEdit1Change(Sender: TObject);
begin
   if Length(filtered_data)>0 then background_data:=cross_minimums(filtered_data, SpinEdit1.Value)
   else background_data:=cross_minimums(raw_data, SpinEdit1.Value);
   plot_background(background_data);
   ButtonInterpolate.Enabled:=True;
end;

procedure TFormMain.MenuItemExitClick(Sender: TObject);
begin
  FormMain.Close;
end;

procedure TFormMain.MenuItemAppereanceClick(Sender: TObject);
begin
    FormSettings.Show;
end;

procedure TFormMain.ButtonFindMinimumsClick(Sender: TObject);
begin
   if Length(filtered_data)>0 then background_data:=get_minimums(filtered_data)
   else background_data:=get_minimums(raw_data);
   plot_background(background_data);
   ButtonInterpolate.Enabled:=True;
end;

procedure TFormMain.ChartToolsetDataPointDragToolDrag(
  ASender: TDataPointDragTool; var AGraphPoint: TDoublePoint);
var i:integer;
begin
  AGraphPoint.X := ASender.Origin.X;
   BackgroundDataSeries.ListSource.Sort;
   SetLength(background_data,BackgroundDataSeries.Count);
      for i:=0 to BackgroundDataSeries.Count-1 do
      begin
       background_data[i].x:=BackgroundDataSeries.GetXValue(i);
       background_data[i].y:=BackgroundDataSeries.GetYValue(i);
      end;
end;

procedure TFormMain.ButtonInterpolateClick(Sender: TObject);
var data: PointArray;
    i,l: integer;
begin
   if Length(background_data)>0 then
   begin
     if Length(filtered_data)>0 then
      begin
        GroupBox1.Enabled:=False;
        GroupBox2.Enabled:=False;
        ButtonInterpolate.Enabled:=False;
        Button2.Enabled:=True;
        SetLength(data, Length(filtered_data));
        for i:=0 to Length(filtered_data)-1 do
        begin
          l:=1;
          while (filtered_data[i].x>background_data[l].x)and(l<Length(background_data)-1) do l += 1;
          data[i].x:=filtered_data[i].x;
          data[i]:=linear_interpolation(data[i].x, background_data[l-1], background_data[l]);
        end;
        background_data:=data;
        plot_background(data);
      end
     else
     if Length(raw_data)>0 then
      begin
        SetLength(data, Length(raw_data));
        for i:=0 to Length(raw_data)-1 do
        begin
          l:=1;
          while (raw_data[i].x>background_data[l].x)and(l<Length(background_data)) do l += 1;
          data[i].x:=raw_data[i].x;
          data[i]:=linear_interpolation(data[i].x, background_data[l-1], background_data[l]);
        end;
        background_data:=data;
        plot_background(data);
      end;
   end;
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  if Length(filtered_data)>0 then
     filtered_data:=substract_background(filtered_data,background_data)
  else
    filtered_data:=substract_background(raw_data,background_data);

  SetLength(background_data,0);
  plot_background(background_data);
  plot_filtered(filtered_data);
  PanelBackgroundProcessing.Enabled:=False;
  Button2.Enabled:=False;
end;

procedure TFormMain.ChartToolsetDataPointDragToolDragStart(
  ASender: TDataPointDragTool; var AGraphPoint: TDoublePoint);
begin
   if ASender.Series.Index <> BackgroundDataSeries.Index then ASender.Handled;
end;

procedure TFormMain.MenuItemAboutClick(Sender: TObject);
begin
  FormAbout.Show;
end;

procedure TFormMain.MenuItemAverageFilterClick(Sender: TObject);
begin
  FormAverage.Show;
end;

end.

