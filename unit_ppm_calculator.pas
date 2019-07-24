unit unit_ppm_calculator;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ExtCtrls, Grids, math;

type

  { TFormPPMCalculator }

  TFormPPMCalculator = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    FloatSpinEdit1: TFloatSpinEdit;
    FloatSpinEdit3: TFloatSpinEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelElement: TLabel;
    LabelIntensity: TLabel;
    LabelPPM: TLabel;
    LabelTime: TLabel;
    LabelVoltage: TLabel;
    LabeledEdit1: TLabeledEdit;
    OpenDialog1: TOpenDialog;
    SpinEdit1: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;
  Element = record
    name: string;
    ppm: double;
    intensity: integer;
  end;

ElementArray = array of Element;

var
  FormPPMCalculator: TFormPPMCalculator;
  Fname: string;
  live_time: integer;
  voltage: double;
  elements: ElementArray;
  element_selected: Element;
implementation

{$R *.lfm}

{ TFormPPMCalculator }
function load_reference_data(filename: string): ElementArray;
var
  elem: ElementArray;
  csv_loader : TStringGrid;
  var i:integer;
begin
    csv_loader:=TStringGrid.Create(nil);
    csv_loader.LoadFromCSVFile(filename,';');
    SetLength(elem,csv_loader.RowCount-1);
    live_time:= StrToInt(csv_loader.Cells[3,1]);
    voltage:= StrToFloat(csv_loader.Cells[4,1]);
    for i:=0 to Length(elem)-1 do
    begin
      elem[i].name:=csv_loader.Cells[0,i+1];
      elem[i].ppm:=StrToFloat(csv_loader.Cells[1,i+1]);
      elem[i].intensity:=StrToInt(csv_loader.Cells[2,i+1]);
    end;
    csv_loader.Destroy;
  load_reference_data:=elem;
end;

procedure TFormPPMCalculator.Button1Click(Sender: TObject);
var int_val, lt_val,etal_ppm, mass_val,exp_ppm: double;
begin
  lt_val:= live_time/FloatSpinEdit3.Value; // live time coefficient
  int_val:= SpinEdit1.Value/element_selected.intensity; // intensity coefficient
  mass_val:=FloatSpinEdit1.Value; // mass coefficient
  etal_ppm:=element_selected.ppm;
  exp_ppm:=(int_val*lt_val*etal_ppm)/mass_val;
  LabeledEdit1.Text:=FloatToStr(RoundTo(exp_ppm,-2));
end;

procedure TFormPPMCalculator.Button2Click(Sender: TObject);
var
     i: integer;

begin
  If OpenDialog1.Execute then
  begin
    Fname:=OpenDialog1.FileName;
    elements:=load_reference_data(Fname);

    if Length(elements)>0 then
    begin
        FormPPMCalculator.Caption:='PPM Calculator | ' + ExtractFileName(Fname) ;
        ComboBox1.Items.Clear;
        LabelVoltage.Caption:='Voltage: ' + FloatToStr(voltage)+ ' keV';
        LabelTime.Caption:= 'Live time(seconds): '+IntToStr(live_time);
        ComboBox1.Enabled:=True;
        for i:=0 to Length(elements)-1 do
        begin
          ComboBox1.Items.Append(elements[i].name);
        end;
        ComboBox1.ItemIndex:=0;
        element_selected:=elements[ComboBox1.ItemIndex];
        LabelIntensity.Caption:='Intensity: ' + IntToStr(element_selected.intensity);
        LabelPPM.Caption:='ppm: ' + FloatToStr(element_selected.ppm);
    end;
  end;
end;

procedure TFormPPMCalculator.ComboBox1Change(Sender: TObject);
begin
  element_selected:=elements[ComboBox1.ItemIndex];
  LabelIntensity.Caption:='Intensity: ' + IntToStr(element_selected.intensity);
  LabelPPM.Caption:='ppm: ' + FloatToStr(element_selected.ppm);
end;

procedure TFormPPMCalculator.FormCreate(Sender: TObject);
var i:integer;
begin
   ComboBox1.Enabled:=False;
    Fname:='etalon_5_multi_40kV.csv';
    if FileExists('etalon_5_multi_40kV.csv')  then
    begin
      elements:=load_reference_data(Fname);
      FormPPMCalculator.Caption:='PPM Calculator | ' + Fname ;
      if Length(elements)>0 then
      begin
          ComboBox1.Items.Clear;
          LabelVoltage.Caption:='Voltage: ' + FloatToStr(voltage)+ ' keV';
          LabelTime.Caption:= 'Live time(seconds): '+IntToStr(live_time);
          ComboBox1.Enabled:=True;
          for i:=0 to Length(elements)-1 do
          begin
            ComboBox1.Items.Append(elements[i].name);
          end;
          ComboBox1.ItemIndex:=0;
          element_selected:=elements[ComboBox1.ItemIndex];
          LabelIntensity.Caption:='Intensity: ' + IntToStr(element_selected.intensity);
          LabelPPM.Caption:='ppm: ' + FloatToStr(element_selected.ppm);
      end;
    end;
end;

procedure TFormPPMCalculator.FormShow(Sender: TObject);
begin
  if Length(elements)>0 then
   element_selected:=elements[ComboBox1.ItemIndex];
end;

end.

