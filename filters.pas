unit filters;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  Point = record
    x,y: double;
  end;
 PointArray = array of Point;
 function minimal_intensity_filter(input:PointArray; intensity: double):PointArray;
 function average_filter(input: PointArray; n: integer): PointArray;
 function SavitzkyGolayFilter(input: PointArray; level: integer): PointArray;
 function sort_points(input:PointArray):PointArray;
implementation

 function minimal_intensity_filter(input:PointArray; intensity: double):PointArray;
 var i,n:integer;
    output: PointArray;
 begin
    if Length(input)>0 then
    begin
      n:=0;
      for i:=0 to Length(input)-1 do
      begin
        if input[i].y>intensity then
        begin
          n+=1;
          SetLength(output,n);
          output[n-1].x:=input[i].x;
          output[n-1].y:=input[i].y;

        end;
      end;
    end;
 minimal_intensity_filter:=output;
 end;

function average_filter(input: PointArray; n: integer): PointArray;
var output: PointArray;
    i,k: integer;
    sum: double;
begin
   if Length(input) > 0 then
   begin
     SetLength(output, Length(input));
     for k:=0 to Length(input)-1 do
      begin
        output[k]:=input[k];
        if (k-n>=0)and(k+n<Length(input)) then
         begin
           sum:=0;
           for i:=-n to n do sum += input[k+i].y;
           output[k].y:=sum/(2*n+1);
         end;
      end;
   end;
average_filter:=output;
end;

function SavitzkyGolayFilter(input: PointArray; level: integer): PointArray;
var
 A5: array [-2..2] of double = (-3, 12, 17, 12, 3);
 A7: array [-3..3] of double = (-2, 3, 6, 7, 6, 3, -2);
 A9: array [-4..4] of double = (-21, 14, 39, 54, 59, 54, 39, 14, -21);
 A11: array [-5..5] of double = (-36, 9, 44,69, 84,89, 84, 69, 44, 9, -36);
 output: PointArray;
 k,i: integer;
 sum, sumA: double;
begin
  SetLength(output, Length(input));
  case level of
   5:
     begin
      sumA:=0;
      for i:=-2 to 2 do sumA += A5[i];
       for k:=0 to Length(input)-1 do
       begin
         output[k]:=input[k];

           if (k-2>=0)and(k+2<Length(input)) then
           begin
              sum:=0;
              for i:=-2 to 2 do
               begin
                sum += A5[i]*input[k+i].y;
               end;
              output[k].y := sum/sumA;
           end;
       end;
     end;

   7:
     begin
      sumA:=0;
      for i:=-2 to 2 do sumA += A7[i];
       for k:=0 to Length(input)-1 do
       begin
         output[k]:=input[k];

           if (k-3>=0)and(k+3<Length(input)) then
           begin
              sum:=0;
              for i:=-3 to 3 do
               begin
                sum += A7[i]*input[k+i].y;
               end;
              output[k].y := sum/sumA;
           end;
       end;
     end;

   9:
     begin
      sumA:=0;
      for i:=-2 to 2 do sumA += A9[i];
       for k:=0 to Length(input)-1 do
       begin
         output[k]:=input[k];

           if (k-4>=0)and(k+4<Length(input)) then
           begin
              sum:=0;
              for i:=-4 to 4 do
               begin
                sum += A9[i]*input[k+i].y;
               end;
              output[k].y := sum/sumA;
           end;
       end;
     end;

   11:
     begin
      sumA:=0;
      for i:=-2 to 2 do sumA += A11[i];
       for k:=0 to Length(input)-1 do
       begin
         output[k].x:=input[k].x;

           if (k-5>=0)and(k+5<Length(input)) then
           begin
              sum:=0;
              for i:=-5 to 5 do
               begin
                sum += A11[i]*input[k+i].y;
               end;
              output[k].y := sum/sumA;
           end;
       end;
     end;

  end;
  SavitzkyGolayFilter:=output;
end;
function sort_points(input:PointArray):PointArray;
var i,j:integer;
    output:PointArray;
begin
    SetLength(output, Length(input));

    for i:=0 to Length(input)-1 do
     begin
      for j:=0 to Length(input)-1 do
       begin
        if input[i].y/input[i].x > input[j].y/input[j].x then
        output[j]:=input[i];
       end;
     end;
 sort_points:=output;
end;

end.

