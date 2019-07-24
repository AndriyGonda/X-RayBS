program SRF;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, mainform, tachartlazaruspkg, filters, minimal_intensity_form, settings,
  average_filter_form, savizkyform, background_processing, about_form,
  unit_ppm_calculator, spectrum_comparator
  { you can add units after this };

{$R *.res}

begin
  Application.Title:=' X-Ray Fluorescence Background Substractor ';
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormMinIntensity, FormMinIntensity);
  Application.CreateForm(TFormSettings, FormSettings);
  Application.CreateForm(TFormAverage, FormAverage);
  Application.CreateForm(TFormSavitzky, FormSavitzky);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TFormPPMCalculator, FormPPMCalculator);
  Application.CreateForm(TFormSpectrumComparator, FormSpectrumComparator);
  Application.Run;
end.

