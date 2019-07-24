unit spectrum_comparator;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TALegendPanel, TASeries,
  TATransformations, TATools, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Grids, filters, Types;

type

  { TFormSpectrumComparator }

  TFormSpectrumComparator = class(TForm)
    Button1: TButton;
    Button3: TButton;
    Button5: TButton;
    Button7: TButton;
    Button9: TButton;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Chart1LineSeries3: TLineSeries;
    Chart1LineSeries4: TLineSeries;
    Chart1LineSeries5: TLineSeries;
    Chart1LineSeries6: TLineSeries;
    ChartAxisTransformations1: TChartAxisTransformations;
    ChartAxisTransformations1LinearAxisTransform1: TLinearAxisTransform;
    ChartAxisTransformations2: TChartAxisTransformations;
    ChartAxisTransformations2LogarithmAxisTransform1: TLogarithmAxisTransform;
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointCrosshairTool1: TDataPointCrosshairTool;
    ChartToolset1ZoomDragTool1: TZoomDragTool;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    ColorButton1: TColorButton;
    ColorButton2: TColorButton;
    ColorButton3: TColorButton;
    ColorButton4: TColorButton;
    ColorButton5: TColorButton;
    Label1: TLabel;
    LabelEnergy: TLabel;
    LabelElement: TLabel;
    LabelSeries: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    RadioK: TRadioButton;
    RadioL: TRadioButton;
    RadioM: TRadioButton;
    RadioGroup1: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure ChartToolset1DataPointCrosshairTool1Draw(
      ASender: TDataPointDrawTool);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure CheckBox7Change(Sender: TObject);
    procedure CheckBox8Change(Sender: TObject);
    procedure ColorButton1Click(Sender: TObject);
    procedure ColorButton2Click(Sender: TObject);
    procedure ColorButton3Click(Sender: TObject);
    procedure ColorButton4Click(Sender: TObject);
    procedure ColorButton5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabelElementClick(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure RadioKChange(Sender: TObject);
    procedure RadioLChange(Sender: TObject);
    procedure RadioMChange(Sender: TObject);
  private

  public

  end;
  Element = record
    number: integer;
    name: string;
    KAlpha1: double;
    KBeta1: double;
    LAlpha1: double;
    LBeta1: double;
    MAlpha1: double;
    MBeta1: double;
  end;
  ElementArray = array [3..95] of Element;

var
  FormSpectrumComparator: TFormSpectrumComparator;
  d1,d2,d3,d4,d5,maximums: PointArray;
  elm: ElementArray;
implementation
 uses mainform;
{$R *.lfm}

 function get_maximums(data: PointArray): PointArray;
var i, n:integer;
  output: PointArray;
  dYi,dYj: double;
begin
   if Length(data)>0 then
   begin
      n:=1;
      SetLength(output,n);
      output[n-1]:=data[0];
      for i:=1 to Length(data)-2 do
      begin
        dYi:=(data[i].y-data[i-1].y)/(data[i].x-data[i-1].x);
        dYj:=(data[i+1].y-data[i].y)/(data[i+1].x-data[i].x);
        if (dYi>0)and(dYj<0) then
        begin
          n+=1;
          SetLength(output,n);
          output[n-1]:=data[i];
        end;
      end;
      n+=1;
      SetLength(output,n);
      output[n-1]:=data[Length(data)-1];
   end;

get_maximums:=output;
end;
 procedure marks_first_plot;
 var i,j: integer;
 lbl: string;
begin
   //   Маркування
   with FormSpectrumComparator do
   begin
     if (CheckBox7.Checked) and (CheckBox1.Checked ) then
     begin
        if RadioK.Checked then
        begin
          maximums:=get_maximums(d1);
          Chart1LineSeries6.Clear;
          for i:=0 to Length(maximums)-1 do
          begin
            for j:=3 to 95 do
            begin
              if (abs(maximums[i].x/58.7781- elm[j].KAlpha1) < 0.05)and(elm[j].KAlpha1>0) then
               lbl:= elm[j].name + ' α';

              if (abs(maximums[i].x/58.7781- elm[j].KBeta1) < 0.05)and(elm[j].KBeta1>0) then
                lbl:= elm[j].name + ' β';

              end;
              if (i<Length(maximums)-1)and(abs(maximums[i].x/58.7781-maximums[i+1].x/58.7781)>0.05) then
              if maximums[i].y > 100 then Chart1LineSeries6.AddXY(maximums[i].x, maximums[i].y, lbl, clRed);
               lbl:='';
          end;
        end;

        if RadioL.Checked then
        begin
          maximums:=get_maximums(d1);
          Chart1LineSeries6.Clear;
          for i:=0 to Length(maximums)-1 do
          begin
              for j:=3 to 95 do
              begin

              if (abs(maximums[i].x/58.7781- elm[j].LAlpha1) < 0.05)and(elm[j].LAlpha1>0) then
               lbl:= elm[j].name + ' α';

               if (abs(maximums[i].x/58.7781- elm[j].LBeta1) < 0.05)and(elm[j].LBeta1>0) then
                lbl:= elm[j].name + ' β';
              end;
              if (i<Length(maximums)-1)and(abs(maximums[i].x/58.7781-maximums[i+1].x/58.7781)>0.05) then
              if maximums[i].y > 100 then Chart1LineSeries6.AddXY(maximums[i].x, maximums[i].y, lbl, clRed);
               lbl:='';
          end;
        end;

        if RadioM.Checked then
        begin
          maximums:=get_maximums(d1);
          Chart1LineSeries6.Clear;
          for i:=0 to Length(maximums)-1 do
          begin
            for j:=3 to 95 do
            begin
            if (abs(maximums[i].x/58.7781- elm[j].MAlpha1) < 0.05)and(elm[j].MAlpha1>0) then
             lbl:= elm[j].name + ' α';

             if (abs(maximums[i].x/58.7781- elm[j].MBeta1) < 0.05)and(elm[j].MBeta1>0) then
              lbl:= elm[j].name + ' β';
            end;
            if (i<Length(maximums)-1)and(abs(maximums[i].x/58.7781-maximums[i+1].x/58.7781)>0.05) then
            if maximums[i].y > 100 then Chart1LineSeries6.AddXY(maximums[i].x, maximums[i].y, lbl, clRed);
             lbl:='';
          end;
        end;
     end
      else Chart1LineSeries6.Clear;
   end;
end;

{ TFormSpectrumComparator }
 procedure plot(data: PointArray; series: TLineSeries; checkbox: TCheckBox);
 var i:integer;
 begin
 series.Clear;
   if (checkbox.Checked)and(Length(data)>0) then
   begin
     for i:=0 to Length(data)-1 do
     begin
       if data[i].y>0 then
       series.AddXY(data[i].x,data[i].y);
     end;
   end;
 end;

procedure TFormSpectrumComparator.ColorButton1Click(Sender: TObject);
begin
  Chart1LineSeries1.SeriesColor:=ColorButton1.ButtonColor;
  plot(d1,Chart1LineSeries1,CheckBox1);
end;

procedure TFormSpectrumComparator.ColorButton2Click(Sender: TObject);
begin
  Chart1LineSeries2.SeriesColor:=ColorButton2.ButtonColor;
  plot(d2,Chart1LineSeries2,CheckBox2);
end;

procedure TFormSpectrumComparator.ColorButton3Click(Sender: TObject);
begin
  Chart1LineSeries3.SeriesColor:=ColorButton3.ButtonColor;
  plot(d3,Chart1LineSeries3,CheckBox3);
end;

procedure TFormSpectrumComparator.ColorButton4Click(Sender: TObject);
begin
   Chart1LineSeries4.SeriesColor:=ColorButton4.ButtonColor;
  plot(d4,Chart1LineSeries4,CheckBox4);
end;

procedure TFormSpectrumComparator.ColorButton5Click(Sender: TObject);
begin
   Chart1LineSeries5.SeriesColor:=ColorButton5.ButtonColor;
  plot(d5,Chart1LineSeries5,CheckBox5);
end;

procedure TFormSpectrumComparator.FormCreate(Sender: TObject);
var buffer: TStringGrid;
j,el_num: integer;
begin
  Chart1LineSeries1.AxisIndexY:=0;
  Chart1LineSeries2.AxisIndexY:=0;
  Chart1LineSeries3.AxisIndexY:=0;
  Chart1LineSeries4.AxisIndexY:=0;
  Chart1LineSeries5.AxisIndexY:=0;
  Chart1LineSeries6.AxisIndexY:=0;

  DecimalSeparator:=',';
  if FileExists('db.csv') then
   begin
    buffer:=TStringGrid.Create(nil);
    buffer.LoadFromCSVFile('db.csv',';');
        for j:=1 to buffer.RowCount-1 do
         begin

           if Length(buffer.Cells[0,j])>0 then
           begin
             el_num:=strToInt(buffer.Cells[0,j]);
             elm[el_num].number:=el_num;
             elm[el_num].name:=buffer.Cells[1,j];

             if Length(buffer.Cells[2,j])>0 then
                 elm[el_num].KAlpha1:=StrToFloat(buffer.Cells[2,j]);

             if Length(buffer.Cells[3,j])>0 then
                 elm[el_num].KBeta1:=StrToFloat(buffer.Cells[3,j]);

              if Length(buffer.Cells[4,j])>0 then
                 elm[el_num].LAlpha1:=StrToFloat(buffer.Cells[4,j]);

              if Length(buffer.Cells[5,j])>0 then
                 elm[el_num].LBeta1:=StrToFloat(buffer.Cells[5,j]);

              if Length(buffer.Cells[6,j])>0 then
                 elm[el_num].MAlpha1:=StrToFloat(buffer.Cells[6,j]);

              if Length(buffer.Cells[6,j])>0 then
                 elm[el_num].MBeta1:=StrToFloat(buffer.Cells[7,j]);

           end;
         end;
    buffer.Destroy;
   end
  else
  ShowMessage('Warning! Failed load database file.');
end;

procedure TFormSpectrumComparator.LabelElementClick(Sender: TObject);
begin

end;

procedure TFormSpectrumComparator.Panel1Click(Sender: TObject);
begin

end;

procedure TFormSpectrumComparator.RadioKChange(Sender: TObject);
begin
  marks_first_plot;
end;

procedure TFormSpectrumComparator.RadioLChange(Sender: TObject);
begin
  marks_first_plot;
end;

procedure TFormSpectrumComparator.RadioMChange(Sender: TObject);
begin
  marks_first_plot;
end;


procedure TFormSpectrumComparator.Button3Click(Sender: TObject);
var fname: string;
begin
    if OpenDialog1.Execute then
    begin
      fname:=OpenDialog1.FileName;
      Chart1LineSeries2.Title:=ExtractFileName(fname);
      Chart1LineSeries2.SeriesColor:=ColorButton2.ButtonColor;
      d2:=getDataFromFile(fname);
      plot(d2,Chart1LineSeries2,CheckBox2);
    end;

end;


procedure TFormSpectrumComparator.Button1Click(Sender: TObject);
var fname: string;
begin
    if OpenDialog1.Execute then
    begin
      fname:=OpenDialog1.FileName;
      Chart1LineSeries1.Title:=ExtractFileName(fname);
      Chart1LineSeries1.SeriesColor:=ColorButton1.ButtonColor;
      d1:=getDataFromFile(fname);
      plot(d1,Chart1LineSeries1,CheckBox1);
      if CheckBox7.Checked then
      marks_first_plot;
     end;
end;



procedure TFormSpectrumComparator.Button5Click(Sender: TObject);
var fname: string;
begin
    if OpenDialog1.Execute then
    begin
      fname:=OpenDialog1.FileName;
      Chart1LineSeries3.Title:=ExtractFileName(fname);
      Chart1LineSeries3.SeriesColor:=ColorButton3.ButtonColor;
      d3:=getDataFromFile(fname);
      plot(d3,Chart1LineSeries3,CheckBox3);

    end;

end;


procedure TFormSpectrumComparator.Button7Click(Sender: TObject);
var fname: string;
begin
    if OpenDialog1.Execute then
    begin
      fname:=OpenDialog1.FileName;
      Chart1LineSeries4.Title:=ExtractFileName(fname);
      Chart1LineSeries4.SeriesColor:=ColorButton4.ButtonColor;
      d4:=getDataFromFile(fname);
      plot(d4,Chart1LineSeries4,CheckBox4);
    end;

end;


procedure TFormSpectrumComparator.Button9Click(Sender: TObject);
var fname: string;
begin
    if OpenDialog1.Execute then
    begin
      fname:=OpenDialog1.FileName;
      Chart1LineSeries5.Title:=ExtractFileName(fname);
      Chart1LineSeries5.SeriesColor:=ColorButton5.ButtonColor;
      d5:=getDataFromFile(fname);
      plot(d5,Chart1LineSeries5,CheckBox5);
    end;

end;


procedure TFormSpectrumComparator.ChartToolset1DataPointCrosshairTool1Draw(
  ASender: TDataPointDrawTool);
var i: integer;
begin
  LabelElement.Caption:='';
  LabelEnergy.Caption:='';
  LabelSeries.Caption:='';
   if RadioK.Checked then
   begin

     for i:=3 to 95 do
      begin
        if (abs(ASender.NearestGraphPoint.X/58.7781- elm[i].KAlpha1) <= 0.05)and(elm[i].KAlpha1>0) then
        begin
         LabelElement.Caption:= elm[i].name;
         LabelEnergy.Caption:= FloatToStr(elm[i].KAlpha1)+' keV';
         LabelSeries.Caption:='Kα1';
        end;

         if (abs(ASender.NearestGraphPoint.X/58.7781- elm[i].KBeta1) <= 0.05)and(elm[i].KBeta1>0) then
        begin
         LabelElement.Caption:= elm[i].name;
         LabelEnergy.Caption:= FloatToStr(elm[i].KBeta1)+' keV';
         LabelSeries.Caption:='Kβ1';
        end;
      end;
     end;


   if RadioL.Checked then
   begin
     for i:=3 to 95 do
      begin
        if (abs(ASender.NearestGraphPoint.X/58.7781- elm[i].LAlpha1) <= 0.05)and(elm[i].LAlpha1>0) then
         begin
         LabelElement.Caption:= elm[i].name;
         LabelEnergy.Caption:= FloatToStr(elm[i].LAlpha1)+' keV';
          LabelSeries.Caption:='Lα1';
        end;

        if (abs(ASender.NearestGraphPoint.X/58.7781- elm[i].LBeta1) <= 0.05)and(elm[i].LBeta1>0) then
         begin
         LabelElement.Caption:= elm[i].name;
         LabelEnergy.Caption:= FloatToStr(elm[i].LBeta1)+' keV';
         LabelSeries.Caption:='Lβ1';
        end;
      end;
   end;

   if RadioM.Checked then
   begin
     for i:=3 to 95 do
      begin
        if (abs(ASender.NearestGraphPoint.X/58.7781- elm[i].MAlpha1) <= 0.05)and(elm[i].MAlpha1>0) then
       begin
         LabelElement.Caption:= elm[i].name;
         LabelEnergy.Caption:= FloatToStr(elm[i].MAlpha1)+' keV';
         LabelSeries.Caption:='Mα1';

        end;

        if (abs(ASender.NearestGraphPoint.X/58.7781- elm[i].MBeta1) <= 0.05)and(elm[i].MBeta1>0) then
        begin
         LabelElement.Caption:= elm[i].name;
         LabelEnergy.Caption:= FloatToStr(elm[i].MBeta1)+' keV';
         LabelSeries.Caption:='Mβ1';
        end;

      end;
   end;

end;



procedure TFormSpectrumComparator.CheckBox1Change(Sender: TObject);
begin
    plot(d1,Chart1LineSeries1,CheckBox1);
    marks_first_plot;
end;

procedure TFormSpectrumComparator.CheckBox2Change(Sender: TObject);
begin
    plot(d2,Chart1LineSeries2,CheckBox2);
end;

procedure TFormSpectrumComparator.CheckBox3Change(Sender: TObject);
begin
  plot(d3,Chart1LineSeries3,CheckBox3);
end;

procedure TFormSpectrumComparator.CheckBox4Change(Sender: TObject);
begin
   plot(d4,Chart1LineSeries4,CheckBox4);
end;

procedure TFormSpectrumComparator.CheckBox5Change(Sender: TObject);
begin
  plot(d5,Chart1LineSeries5,CheckBox5);
end;

procedure TFormSpectrumComparator.CheckBox6Change(Sender: TObject);
begin
  if CheckBox6.Checked then
  ChartAxisTransformations2LogarithmAxisTransform1.Enabled:=True
  else
    ChartAxisTransformations2LogarithmAxisTransform1.Enabled:=False;

end;

procedure TFormSpectrumComparator.CheckBox7Change(Sender: TObject);
begin
   marks_first_plot;
end;

procedure TFormSpectrumComparator.CheckBox8Change(Sender: TObject);
begin
  if CheckBox8.Checked then
  Chart1.Legend.Visible:=true
  else Chart1.Legend.Visible:=false;
end;

end.

