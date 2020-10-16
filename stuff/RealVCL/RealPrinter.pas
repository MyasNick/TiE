// -----------------------------------------------------------
//
// RealPrinter version 1.0 visual component
// (c) 2002-2004 Nikolaj Masnikov
//
// Based on freeware TUCLinePrinter by Ulli Conrad / UCSoft 
// Refer to RealPrinter.txt for more information.
// 
// -----------------------------------------------------------

unit RealPrinter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
TNextPageEvent = procedure(Sender : TObject;PageNo,TotalPages : integer) of object;

type
TRealPrinterUnit = (mm,Inch);

type
TRealPrinterMargins = class(TPersistent)
  private
    FTop  : string;
    FLeft : string;
    FBottom : string;
    FRight : string;
    FUnit : TRealPrinterUnit;
    procedure SetMarginUnit(Value : TRealPrinterUnit);
    function GetTopValue : Double;
    function GetLeftValue : Double;
    function GetBottomValue : Double;
    function GetRightValue : Double;
    procedure SetTopValue(Value : Double);
    procedure SetLeftValue(Value : Double);
    procedure SetBottomValue(Value : Double);
    procedure SetRightValue(Value : Double);
  published
    property Top : Double read GetTopValue  write SetTopValue;
    property Left : Double read GetLeftValue write SetLeftValue;
    property Bottom : Double read GetBottomValue write SetBottomValue;
    property Right : Double read GetRightValue write SetRightValue;
    property MarginUnit : TRealPrinterUnit read FUnit write SetMarginUnit;
end;

type
  TPrintTitlePlacement = (Nowhere,TopOfPage,BottomOfPage);

type
  TRealPrinter = class(TComponent)
  private
    FWordWrap : boolean;
    FLines : TStrings;
    FFont : TFont;
    FMargins : TRealPrinterMargins;
    FOnNextPage : TNextPageEvent;
    FOnStartPrint : TNotifyEvent;
    FOnEndPrint : TNotifyEvent;
    FPrintTitle : string;
    FPrintPageNumbers : boolean;
    FTitleOnPrintout : TPrintTitlePlacement;
    procedure SetLines(Value: TStrings);
    procedure SetFont(Value: TFont);
    procedure SetMargins(Value : TRealPrinterMargins);
    procedure SetPrintTitle(Value : string);
    procedure CalcPrinterMargins(var MarginsRect : TRect);
    procedure WrapLines(Src,Dest : TStrings;LineWidth : integer);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Print;
  published
    property Font: TFont read FFont write SetFont;
    property WordWrap : boolean read FWordWrap write FWordWrap;
    property Lines : TStrings read FLines write SetLines;
    property Margins : TRealPrinterMargins read FMargins write SetMargins;
    property PrintPageNumbers : boolean read FPrintPageNumbers write FPrintPageNumbers;
    property PrintTitle : string read FPrintTitle write SetPrintTitle;
    property TitleOnPrintout : TPrintTitlePlacement read FTitleOnPrintout write FTitleOnPrintout;
    property OnNextPage : TNextPageEvent read FOnNextPage write FOnNextPage;
    property OnStartPrint : TNotifyEvent read FOnStartPrint write FOnStartPrint;
    property OnEndPrint : TNotifyEvent read FOnEndPrint write FOnEndPrint;
  end;

procedure Register;

implementation
uses Printers;

//{$R *.RES}

{ ============== TRealPrinterMargin =============== }
const
STR_MARGINFORMAT      = '0.00';
mmPerInch             = 25.4;

function TRealPrinterMargins.GetTopValue : Double;
begin
  Result:=StrToFloat(FTop);
end;

function TRealPrinterMargins.GetLeftValue : Double;
begin
  Result:=StrToFloat(FLeft);
end;

function TRealPrinterMargins.GetBottomValue : Double;
begin
  Result:=StrToFloat(FBottom);
end;

function TRealPrinterMargins.GetRightValue : Double;
begin
  Result:=StrToFloat(FRight);
end;

procedure TRealPrinterMargins.SetTopValue(Value : Double);
begin
  FTop:=FormatFloat(STR_MARGINFORMAT, Value);
end;

procedure TRealPrinterMargins.SetLeftValue(Value : Double);
begin
  FLeft:=FormatFloat(STR_MARGINFORMAT, Value);
end;

procedure TRealPrinterMargins.SetBottomValue(Value : Double);
begin
  FBottom:=FormatFloat(STR_MARGINFORMAT, Value);
end;

procedure TRealPrinterMargins.SetRightValue(Value : Double);
begin
  FRight:=FormatFloat(STR_MARGINFORMAT, Value);
end;

procedure TRealPrinterMargins.SetMarginUnit(Value : TRealPrinterUnit);
begin
  if Value<>FUnit then
  begin
    case Value of
      mm   : begin
               Left:=Left*mmPerInch;
               Top:=Top*mmPerInch;
               Bottom:=Bottom*mmPerInch;
               Right:=Right*mmPerInch;
             end;
      Inch : begin
               Left:=Left/mmPerInch;
               Top:=Top/mmPerInch;
               Bottom:=Bottom/mmPerInch;
               Right:=Right/mmPerInch;
             end;
    end;
    FUnit:=Value;
  end;
end;

{ ============== TRealPrinter =============== }
constructor TRealPrinter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLines:=TStringList.Create;
  FFont:=TFont.Create;
  FWordWrap:=true;
  FMargins:=TRealPrinterMargins.Create;
  FMargins.Left:=15;
  FMargins.Top:=15;
  FMargins.Bottom:=15;
  FMargins.Right:=15;
  FPrintPageNumbers:=false;
end;

procedure TRealPrinter.SetLines(Value: TStrings);
begin
  FLines.Assign(Value);
end;

procedure TRealPrinter.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

destructor TRealPrinter.Destroy;
begin
  FLines.Free;
  FFont.Free;
  FMargins.Free;
  inherited Destroy;
end;

procedure TRealPrinter.Print;
  var
  tm : TTextMetric;
  i : integer;
  x,y : integer;
  LineIncrement : integer;
  PageNo,TotalPages : integer;
  PrinterMargins : TRect;
  PrintoutLines : TStringList;
  TitlePos : integer;
  cr : TRect;
  LinesPerPage : integer;
  CurLine : integer;
  pt : string;

begin
  if FLines.Count=0 then
    Exit;

  PageNo:=1;
  Printer.Title:=FPrintTitle;
  Printer.BeginDoc;
  Printer.Canvas.Font:=FFont;
  GetTextMetrics(Printer.Canvas.Handle,tm);
  LineIncrement:=tm.tmHeight+tm.tmExternalLeading;

  CalcPrinterMargins(PrinterMargins);
  y:=PrinterMargins.Top;
  x:=PrinterMargins.Left;

  // Convert word wrapped lines
  PrintoutLines:=TStringList.Create;
  if FWordWrap then
    WrapLines(FLines,PrintoutLines,PrinterMargins.Right-PrinterMargins.Left)
  else
    PrintoutLines.Assign(FLines);

  //Calculate total Pages
  LinesPerPage:=Trunc((PrinterMargins.Bottom-PrinterMargins.Top)/LineIncrement);
  if FTitleOnPrintout<>Nowhere then
    Dec(LinesPerPage,2);
  TotalPages:=PrintoutLines.Count div LinesPerPage;
  if PrintoutLines.Count mod LinesPerPage<>0 then
    inc(TotalPages);

  // Start printing
  if Assigned(FOnStartPrint) then
    FOnStartPrint(self);
  if Assigned(FOnNextPage) then
    FOnNextPage(self,PageNo,TotalPages);

  cr:=PrinterMargins;

  if FTitleOnPrintout=TopOfPage then
  begin
    pt:=FPrintTitle;
    if FPrintPageNumbers then
      pt:=pt+' ('+IntToStr(PageNo)+'/'+IntToStr(TotalPages)+')';
    TitlePos:=PrinterMargins.Left+Round(((PrinterMargins.Right-PrinterMargins.Left)-Printer.Canvas.TextWidth(pt))/2);
    Printer.Canvas.TextRect(cr,TitlePos,y,pt);
    inc(y,LineIncrement*2);
  end;
  Printer.Canvas.TextFlags:= Printer.Canvas.TextFlags + ETO_OPAQUE;
  curLine:=1;
  for i:=0 to PrintoutLines.Count-1 do
  begin
    cr.Top:=y;
    Printer.Canvas.TextRect(cr,x,y,PrintoutLines.Strings[i]);
    inc(y,LineIncrement);
    inc(curLine);
    if curLine>LinesPerPage then
    begin
      if FTitleOnPrintout=BottomOfPage then
      begin
        pt:=FPrintTitle;
        if FPrintPageNumbers then
          pt:=pt+' ('+IntToStr(PageNo)+'/'+IntToStr(TotalPages)+')';
        TitlePos:=PrinterMargins.Left+Round(((PrinterMargins.Right-PrinterMargins.Left)-Printer.Canvas.TextWidth(pt))/2);
        Printer.Canvas.TextRect(cr,TitlePos,PrinterMargins.Bottom-LineIncrement,pt);
      end;
      inc(PageNo);
      if Assigned(FOnNextPage) then
        FOnNextPage(self,PageNo,TotalPages);
      Printer.NewPage;
      y:=PrinterMargins.top;
      cr.Top:=y;
      if FTitleOnPrintout=TopOfPage then
      begin
        pt:=FPrintTitle;
        if FPrintPageNumbers then
          pt:=pt+' ('+IntToStr(PageNo)+'/'+IntToStr(TotalPages)+')';
        TitlePos:=PrinterMargins.Left+Round(((PrinterMargins.Right-PrinterMargins.Left)-Printer.Canvas.TextWidth(pt))/2);
        Printer.Canvas.TextRect(cr,TitlePos,y,pt);
        inc(y,LineIncrement*2);
      end;
      CurLine:=1;
    end;
  end;
  if FTitleOnPrintout=BottomOfPage then
  begin
    pt:=FPrintTitle;
    if FPrintPageNumbers then
      pt:=pt+' ('+IntToStr(PageNo)+'/'+IntToStr(TotalPages)+')';
    TitlePos:=PrinterMargins.Left+Round(((PrinterMargins.Right-PrinterMargins.Left)-Printer.Canvas.TextWidth(pt))/2);
    Printer.Canvas.TextRect(cr,TitlePos,PrinterMargins.Bottom-LineIncrement,pt);
  end;
  Printer.EndDoc;
  if Assigned(FOnEndPrint) then
    FOnEndPrint(self);
  PrintOutLines.Free;
end;

procedure TRealPrinter.SetMargins(Value : TRealPrinterMargins);
begin
  FMargins.Assign(Value);
end;

procedure TRealPrinter.SetPrintTitle(Value : string);
begin
  if FPrintTitle<>Value then
    FPrintTitle:=Value;
end;

procedure TRealPrinter.CalcPrinterMargins(var MarginsRect : TRect);
  var
  lm,tm,bm,rm : double;

begin
  // Convert margins to inch
  if FMargins.MarginUnit=mm then
  begin
    lm:=FMargins.Left/mmPerInch;
    tm:=FMargins.Top/mmPerInch;
    bm:=FMargins.Bottom/mmPerInch;
    rm:=FMargins.Right/mmPerInch;
  end
  else
  begin
    lm:=FMargins.Left;
    tm:=FMargins.Top;
    bm:=FMargins.Bottom;
    rm:=FMargins.Right;
  end;

  with MarginsRect do
  begin
    Left:=Round(lm*GetDeviceCaps(Printer.Handle,LOGPIXELSX));
    Top:=Round(tm*GetDeviceCaps(Printer.Handle,LOGPIXELSY));
    Right:=GetDeviceCaps(Printer.Handle,PHYSICALWIDTH)-Round(rm*GetDeviceCaps(Printer.Handle,LOGPIXELSX));
    Bottom:=GetDeviceCaps(Printer.Handle,PHYSICALHEIGHT)-Round(bm*GetDeviceCaps(Printer.Handle,LOGPIXELSY));

    // Consider unprintable range
    Left:=Left-GetDeviceCaps(Printer.Handle,PHYSICALOFFSETX);
    Top:=Top-GetDeviceCaps(Printer.Handle,PHYSICALOFFSETY);
    Right:=Right-GetDeviceCaps(Printer.Handle,PHYSICALOFFSETX);
    Bottom:=Bottom-GetDeviceCaps(Printer.Handle,PHYSICALOFFSETY);

    // Check if outside unprintable range
    if Left<=GetDeviceCaps(Printer.Handle,PHYSICALOFFSETX) then
      Left:=GetDeviceCaps(Printer.Handle,PHYSICALOFFSETX)+1;
    if Top<=GetDeviceCaps(Printer.Handle,PHYSICALOFFSETY) then
      Top:=GetDeviceCaps(Printer.Handle,PHYSICALOFFSETY)+1;
    if Right>=Left+GetDeviceCaps(Printer.Handle,HORZRES) then
      Right:=(Left+GetDeviceCaps(Printer.Handle,HORZRES))-1;
    if Bottom>=Top+GetDeviceCaps(Printer.Handle,VERTRES) then
      Bottom:=(Top+GetDeviceCaps(Printer.Handle,VERTRES))-1;
  end;
end;

procedure TRealPrinter.WrapLines(Src,Dest : TStrings;LineWidth : integer);

  procedure WrapLine(Unwrapped : string;Lines : TStrings);
  // Recursive procedure for line wrapping
    var
    lw,tw : integer;
    rs,nl,ws,s : string;
    crp : integer;

  begin
    s:=Unwrapped;  // Copy of original string
    rs:='';        // Initialize remaining string
    tw:=Printer.Canvas.TextWidth(s);

    if tw>=LineWidth then
    begin

      lw:=tw;
      // Search for last character in line
      while lw>=LineWidth do
      begin
        Delete(s,Length(s),2);
        lw:=Printer.Canvas.TextWidth(s);
      end;
      ws:=WrapText(Unwrapped,#13#10,['.',' ','-',#9],Length(s));
      crp:=Pos(#13#10,ws);  // Find wrap position
      if crp>=1 then nl:=Copy(ws,1,crp-1) // Get first part of wrapped line
                else nl:=ws;
      Lines.Add(nl);        // Add first part of wrapped line

      if crp>=1 then rs:=Copy(ws,crp+2,Length(ws)); // Get remaining string


      while Pos(#13#10,rs)<>0 do        // Remove line breaks from remaining string
        Delete(rs,Pos(#13#10,rs),2);

{      while Pos(#13,rs)<>0 do        // Remove line breaks from remaining string
        Delete(rs,Pos(#13,rs),1);
      while Pos(#10,rs)<>0 do        // Remove line breaks from remaining string
        Delete(rs,Pos(#10,rs),1);
}
    end
    else
      Lines.Add(s);

    if rs<>'' then
    begin
      tw:=Printer.Canvas.TextWidth(rs);
      if tw>=LineWidth then
        WrapLine(rs,Lines)    // Recursive call for remaining string
      else
        Lines.Add(rs);
    end;
  end;

  var
  i : integer;

begin
  for i:=0 to Src.Count-1 do
    WrapLine(Src.Strings[i],Dest);
end;

{ ============== Register =============== }

procedure Register;
begin
  RegisterComponents('Real', [TRealPrinter]);
end;

end.
