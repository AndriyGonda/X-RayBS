unit background_processing;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,filters;
function get_minimums(data: PointArray): PointArray;
function cross_minimums(data: PointArray; number_of_minima: integer): PointArray;
function linear_interpolation(x: double; p1,p2: Point): Point;
function substract_background(data, background: PointArray):PointArray;
implementation

function get_minimums(data: PointArray): PointArray;
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
        if (dYi<0)and(dYj>0) then
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

get_minimums:=output;
end;

function cross_minimums(data: PointArray; number_of_minima: integer): PointArray;
var i, l,dl,o_count:integer;
  output: PointArray;
  min_x, min_y: double;
begin
   if Length(data)>0 then
   begin
    dl:= Length(data) div number_of_minima;
    o_count:=number_of_minima+1;
    SetLength(output, o_count);
    for l:=0 to o_count-1 do
    begin
      min_x:=data[l*dl].x;
      min_y:=data[l*dl].y;
      for i:=l*dl to (l+1)*dl-1 do
      begin
        if data[i].y<min_y then
        begin
         min_x:=data[i].x;
         min_y:=data[i].y;
        end;
      end;
      output[l].x:=min_x;
      output[l].y:=min_y;
    end;
      output[number_of_minima]:=data[Length(data)-1];
   end;
cross_minimums:=output;
end;
  function linear_interpolation(x: double; p1,p2: Point): Point;
  var p:Point;
  begin
    p.y:=((p2.y-p1.y)/(p2.x-p1.x))*(x-p1.x) + p1.y;
    p.x:=x;
    linear_interpolation:=p;
  end;
  function substract_background(data, background: PointArray):PointArray;
  var output: PointArray;
    i:integer;
  begin
    if Length(data) = Length(background) then
    begin
     SetLength(output, Length(data));
      for i:=0 to Length(data)-1 do
      begin
        if data[i].y-background[i].y > 0 then
        begin
          output[i].y:=round(data[i].y-background[i].y);
          output[i].x:=data[i].x;
        end
        else
        begin
         output[i].y:=0;
         output[i].x:=data[i].x;
        end;
      end;
    end;
  substract_background:=output;
  end;

end.

