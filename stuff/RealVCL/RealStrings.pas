// -----------------------------------------------------------
//
// RealStrings version 1.0 visual component
// © 2009 Nikolaj Masnikov
//
// Features:
//
// -----------------------------------------------------------

unit RealStrings;

interface

uses
  Windows, Messages, SysUtils, Classes;

type
  TOnReadItem = procedure(Sender: TObject; Index: integer) of object;

  TRealStrings = class(TComponent)
  private
    FStrings         : TStringList;
    FReadOnly        : boolean;
    FOnReadItem      : TOnReadItem;
    function  GetString  (Index: integer ): string;
    procedure SetString  (Index: integer; const Value: string);
    procedure SetStrings (Value: TStringList);
    function  GetCount: integer;
  public
    property    Items [Index: Integer]: string read GetString write SetString; default;
    constructor Create  (AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    property Strings: TStringList read FStrings write SetStrings;
    property Count: integer read GetCount;
    property ReadOnly: boolean read FReadOnly write FReadOnly default false;
    property OnReadItem: TOnReadItem read FOnReadItem write FOnReadItem;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Real', [TRealStrings]);
end;

constructor TRealStrings.Create(AOwner: TComponent);
begin
  inherited;
  FStrings := TStringList.Create;
end;

destructor TRealStrings.Destroy;
begin
  FStrings.Free;
  inherited;
end;

function TRealStrings.GetString(Index: integer): string;
begin
  if Assigned(FOnReadItem) then FOnReadItem(self, Index);
  Result := FStrings[Index];
end;

procedure TRealStrings.SetString(Index: integer; const Value: string);
begin
  if not FReadOnly then FStrings[Index] := Value;
end;

procedure TRealStrings.SetStrings(Value: TStringList);
begin
  FStrings.Assign(Value);
end;

function TRealStrings.GetCount: integer;
begin
  Result := FStrings.Count;
end;


end.
