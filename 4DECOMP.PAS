uses crt;
var from,fto:file;

procedure getheader; { EB BE}
var a:word;
begin
  writeln('source: getting header ...');
  seek(from,0);
  blockread(from,a,2);
  if a<>$BEEB then begin
    writeln('source: not a valid compressed .BTM file. halt.');
    halt(1);
  end;
end;

var len,outp:word;

procedure getlength;
begin
  writeln('source: getting length of original batch-file ...');
  seek(from,2);
  blockread(from,len,2);
  outp:=0;
end;

var token:array[2..$1F] of byte;

procedure gettoken;
begin
  writeln('source: getting list of 32 most frequently used chars ...');
  seek(from,4);
  blockread(from,token,$1E);
end;

var pos:word;
    lower:boolean;
    posval:byte;

function getnextnibble:byte;
begin
  if lower then begin
    inc(pos);
    blockread(from,posval,1);
    getnextnibble:=posval shr 4;
  end else begin
    getnextnibble:=posval and $F;
  end;
  lower:=not lower;
end;

procedure convert;
var n,v:byte;
    line:word;
begin
  line:=1;
  pos:=$21;
  lower:=true;
  while not (outp=len) do begin
    n:=getnextnibble;
    case n of
      0: begin
	   v:=getnextnibble;
           v:=v+(getnextnibble shl 4);
	 end;
      1: v:=token[$10+getnextnibble];
      else v:=token[n];
    end;
    blockwrite(fto,v,1);
    if v=$0d then begin
      v:=$0a;
      blockwrite(fto,v,1);
      writeln('converted line ',line);
      inc(line);
      gotoxy(1,wherey-1);
    end;
    inc(outp);
  end;
  writeln;
end;

begin
  writeln('4DECOMP - (c) 1993 by Akisoft, Vienna');
  writeln('decompresses 4DOS 5.0 .BTM-files compressed with BATCOMP');
  writeln;
  if paramcount<2 then begin
    writeln('usage: DECOMP file1 file2');
    halt;
  end;
  assign(from,paramstr(1));
  assign(fto,paramstr(2));
  reset(from,1);
  rewrite(fto,1);
  getheader;
  getlength;
  gettoken;
  convert;
  writeln('closing files ...');
  close(from);
  close(fto);
  writeln('finished!');
end.
