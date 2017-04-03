// ����� �������� ��� ���������� �������������� ������ ���� � ������.
// ������ ��� Borland Delphi 7 (��������� Win32).
// �����: ������� �.�.

{$LONGSTRINGS ON}

unit sdpConvert;

interface

uses
  sdpBigint;

type
  TStrBin = String[64];                         // �������� ������������� �����
  TStrHex = String[16];                // ����������������� ������������� �����

// ������� ��������� �������� ������������� ��������� X
function OrdToBin(X: Byte): TStrBin; overload;
function OrdToBin(X: Shortint): TStrBin; overload;
function OrdToBin(X: Word): TStrBin; overload;
function OrdToBin(X: Smallint): TStrBin; overload;
function OrdToBin(X: Cardinal): TStrBin; overload;
function OrdToBin(X: Integer): TStrBin; overload;
function OrdToBin(X: Int64): TStrBin; overload;
function OrdToBin(const X: TBigint): String; overload;

// ������� ��������� ����������������� ������������� ��������� X
function OrdToHex(X: Byte): TStrHex; overload;
function OrdToHex(X: Shortint): TStrHex; overload;
function OrdToHex(X: Word): TStrHex; overload;
function OrdToHex(X: Smallint): TStrHex; overload;
function OrdToHex(X: Cardinal): TStrHex; overload;
function OrdToHex(X: Integer): TStrHex; overload;
function OrdToHex(X: Int64): TStrHex; overload;
function OrdToHex(const X: TBigint): String; overload;

// �������������� ���� TBigint � AnsiString, ���������� ��� ���������� �������,
// � �������� ��������������.
function BigintToStr(const X: TBigint): AnsiString;
procedure StrToBigint(const S: AnsiString; var X: TBigint);

// �������������� � ������������ �����. ���� X ����� ��� String, �� ��� ������
// ������ ��������� ������ ����� � ���������� ������� ��������� � �����
// ���������� �� ����� '+' ��� '-'. �������� �� ������������
// ���������� �� ������������.
procedure IntToBigint(X: Cardinal; var Bigint: TBigint); overload;
procedure IntToBigint(X: Integer; var Bigint: TBigint); overload;
procedure IntToBigint(X: Int64; var Bigint: TBigint); overload;
procedure IntToBigint(const X: String; var Bigint: TBigint); overload;

// �������������� ������������� ������ � ����������� ����. � ������
// �������������� � Cardinal ��� Integer ��������� ���������� � �������� X
// ������ ������� ���� �����, � ��� ��������� �������������. � ������
// �������������� � String, ����������� �������� ���������� ������ �����.
function BigintToInt(X: TBigint): Cardinal; overload;
procedure BigintToInt(const Bigint: TBigint; var X: Integer); overload;
procedure BigintToInt(const Bigint: TBigint; var X: String); overload;

implementation

uses
  SysUtils;

type
  PCardinal = ^Cardinal;
  PInteger = ^Integer;

//    � ������������ ������������� ���������� ��������� ������������ �������
// std. �� ���� ��������� ��� ����������� ��������� ��������� �� �������������
// �������������� ����������� �������� ����� �����������, � ������������, ���
// �� ��������� �������� ����� 0, �. �. ��������� �������� �������������.
// ������� ����� ���������� ������ �� �������� ���������� ��������� cld.
//   � ����� ��������� ������������� ��������������, ������� ���������
// ������������ ����������������, ��������� ��������� ���� �����������
// ��������� ��� ������ ����, ����� ���������� ��� ��������� ���������.
// ��������, � ������������� ��������� ����� ����
//                       Result := OrdToBin(�ardinal(X));
// ��������� ��������� ��������������� ����, �� ������� ���������� � �����
// ����������.

function OrdToBin(X: Byte): TStrBin;
asm
  push  edi
  mov   edi, @Result                              // ��������� ����� ����������
  movzx edx, X
  bsr   ecx, edx                        // ecx = ����� �������� ���������� ����
  jnz   @NonZero
  mov   byte ptr [edi], 0
  jmp   @Exit
@NonZero:
  inc   ecx                                   // ecx = ���������� ����� � �����
  mov   [edi], cl                                   // ���������� ������ ������
  add   edi, ecx               // ���������� ��������� �� ��������� ���� ������
  std                                         // ��������� �������� �����������
@NextBit:
  xor   al, al
  shr   edx, 1                                                       // edx = X
  adc   al, $30                                                   // #30h = '0'
  stosb
  loop  @NextBit
  cld
@Exit:
  pop   edi
end;

function OrdToBin(X: Shortint): TStrBin;
asm
  push  edi
  mov   edi, @Result                              // ��������� ����� ����������
  movzx edx, X
  bsr   ecx, edx                        // ecx = ����� �������� ���������� ����
  jnz   @NonZero
  mov   byte ptr [edi], 0
  jmp   @Exit
@NonZero:
  inc   ecx                                   // ecx = ���������� ����� � �����
  mov   [edi], cl                                   // ���������� ������ ������
  add   edi, ecx               // ���������� ��������� �� ��������� ���� ������
  std                                         // ��������� �������� �����������
@NextBit:
  xor   al, al
  shr   edx, 1                                                       // edx = X
  adc   al, $30                                                   // #30h = '0'
  stosb
  loop  @NextBit
  cld
@Exit:
  pop   edi
end;

function OrdToBin(X: Word): TStrBin;
asm
  push  edi
  mov   edi, @Result                              // ��������� ����� ����������
  movzx edx, X
  bsr   ecx, edx                        // ecx = ����� �������� ���������� ����
  jnz   @NonZero
  mov   byte ptr [edi], 0
  jmp   @Exit
@NonZero:
  inc   ecx                                   // ecx = ���������� ����� � �����
  mov   [edi], cl                                   // ���������� ������ ������
  add   edi, ecx               // ���������� ��������� �� ��������� ���� ������
  std                                         // ��������� �������� �����������
@NextBit:
  xor   al, al
  shr   edx, 1                                                       // edx = X
  adc   al, $30                                                   // #30h = '0'
  stosb
  loop  @NextBit
  cld
@Exit:
  pop   edi
end;

function OrdToBin(X: Smallint): TStrBin;
asm
  push  edi
  mov   edi, @Result                              // ��������� ����� ����������
  movzx edx, X
  bsr   ecx, edx                        // ecx = ����� �������� ���������� ����
  jnz   @NonZero
  mov   byte ptr [edi], 0
  jmp   @Exit
@NonZero:
  inc   ecx                                   // ecx = ���������� ����� � �����
  mov   [edi], cl                                   // ���������� ������ ������
  add   edi, ecx               // ���������� ��������� �� ��������� ���� ������
  std                                         // ��������� �������� �����������
@NextBit:
  xor   al, al
  shr   edx, 1                                                       // edx = X
  adc   al, $30                                                   // #30h = '0'
  stosb
  loop  @NextBit
  cld
@Exit:
  pop   edi
end;

function OrdToBin(X: Cardinal): TStrBin;
asm
  push edi
  mov  edi, @Result                               // ��������� ����� ����������
  mov  edx, X
  bsr  ecx, edx                         // ecx = ����� �������� ���������� ����
  jnz  @NonZero
  mov  byte ptr [edi], 0
  jmp  @Exit
@NonZero:
  inc  ecx                                    // ecx = ���������� ����� � �����
  mov  [edi], cl                                    // ���������� ������ ������
  add  edi, ecx                // ���������� ��������� �� ��������� ���� ������
  std                                         // ��������� �������� �����������
@NextBit:
  xor  al, al
  shr  edx, 1                                                        // edx = X
  adc  al, $30                                                    // #30h = '0'
  stosb
  loop @NextBit
  cld
@Exit:
  pop  edi
end;

function OrdToBin(X: Integer): TStrBin;
asm
  push edi
  mov  edi, @Result                               // ��������� ����� ����������
  mov  edx, X
  bsr  ecx, edx                         // ecx = ����� �������� ���������� ����
  jnz  @NonZero
  mov  byte ptr [edi], 0
  jmp  @Exit
@NonZero:
  inc  ecx                                    // ecx = ���������� ����� � �����
  mov  [edi], cl                                    // ���������� ������ ������
  add  edi, ecx                // ���������� ��������� �� ��������� ���� ������
  std                                         // ��������� �������� �����������
@NextBit:
  xor  al, al
  shr  edx, 1                                                        // edx = X
  adc  al, $30                                                    // #30h = '0'
  stosb
  loop @NextBit
  cld
@Exit:
  pop  edi
end;

function OrdToBin(X: Int64): TStrBin;
begin
end;

function OrdToBin(const X: TBigint): String;
begin
end;

// ****************************************************************************

function OrdToHex(X: Byte): TStrHex;
begin
end;

function OrdToHex(X: Shortint): TStrHex;
begin
end;

function OrdToHex(X: Word): TStrHex;
begin
end;

function OrdToHex(X: Smallint): TStrHex;
begin
end;

function OrdToHex(X: Cardinal): TStrHex;
begin
end;

function OrdToHex(X: Integer): TStrHex;
begin
end;

function OrdToHex(X: Int64): TStrHex;
begin
end;

function OrdToHex(const X: TBigint): String;
begin
end;

// ****************************************************************************

function BigintToStr(const X: TBigint): AnsiString;
var
  LocX: TBigint;
  D: Cardinal;
  IsZero: Boolean;
  Zeroes, S: String[9];
begin
  if X.Sign = 0 then
  begin
    Result := '0';
    Exit;
  end;
  Result := '';
  CreateBigint(LocX, X.MSB);                     // ��������� ����� ��������� X
  CopyBigint(X, LocX);
  LocX.Sign := 1;                           // ��������� |X|; �������� |X| <> 0
  Zeroes := '000000000';
  repeat
    D := DivBigint(LocX, 1000000000, LocX);
    IsZero := (LocX.Sign = 0);
    S := IntToStr(D);
    if (Length(S) < 9) and (not IsZero) then   // ���� ��� �� ��������� �������
    begin
      Zeroes[0] := Chr(9-Length(S));
      S := Zeroes + S;
    end;
    Result := S + Result;
  until IsZero;
  if X.Sign < 0 then Result := '-' + Result;  
  DestroyBigint(LocX);
end;

procedure StrToBigint(const S: AnsiString; var X: TBigint);
var
  Len, I: Integer;
  FirstSym, Count: Byte;
  C: Cardinal;
begin
  Len := Length(S);
  // ��������������� ����� �� 9 ����, ������� �� ������� ��������. ������ ����
  // ����� ���� ��������.
  if S[1] in ['+','-'] then
  begin
    FirstSym := 2;                             // ������ �������� ������ ������
    Count := (Len-1) mod 9;                             // ������ ������� �����
  end
  else
  begin
    FirstSym := 1;                             // ������ �������� ������ ������
    Count := Len mod 9;                                 // ������ ������� �����
  end;
  if Count = 0 then Count := 9;    // ����� ������ ������ 9; ������ ���� ������
  C := StrToInt(Copy(S, FirstSym, Count));
  IntToBigint(C, X);
  I := FirstSym + Count;
  while I <= Len do
  begin
    MulBigint(X, Cardinal(1000000000), X);
    C := StrToInt(Copy(S, I, 9));
    AddBigint(X, C, X);
    I := I + 9;
  end;
  if S[1] = '-' then X.Sign := -1;
end;

// ****************************************************************************

procedure IntToBigint(X: Cardinal; var Bigint: TBigint);
begin
  with Bigint do
  begin
    MSB := 1;
    if X = 0 then Sign := 0 else Sign := 1;
    PCardinal(PtrDigits)^ := X;
  end;
end;

procedure IntToBigint(X: Integer; var Bigint: TBigint);
begin
  with Bigint do
  begin
    MSB := 1;
    if X < 0 then
    begin
      Sign := -1;
      X := -X;
    end
    else
      if X = 0 then Sign := 0 else Sign := 1;
    PInteger(PtrDigits)^ := X;
  end;
end;

procedure IntToBigint(X: Int64; var Bigint: TBigint);
begin
end;

procedure IntToBigint(const X: String; var Bigint: TBigint);
var
  Len: Word;
  ResSign: Shortint;
  FirstSym: Byte;
  Count: Byte;
  C: Cardinal;
  I: Word;
begin
  Len := Length(X);
  if X[1] in ['+','-'] then
  begin
    case X[1] of
      '-': ResSign := -1;
      '+': ResSign := 1;
    end;
    FirstSym := 2;
    Count := (Len-1) mod 9;
  end
  else
  begin
    ResSign := 1;
    FirstSym := 1;
    Count := Len mod 9;
  end;
  // ��������������� ����� �� 9 ����, ������� �� ������� ��������. ������ ����
  // ����� ���� ��������.
  if Count = 0 then Count := 9;                        // ����� ������ ������ 9
  C := StrToInt(Copy(X, FirstSym, Count));
  IntToBigint(C, Bigint);
  I := FirstSym + Count;
  while I <= Len do
  begin
    MulBigint(Bigint, Cardinal(1000000000), Bigint);
    C := StrToInt(Copy(X, I, 9));
    AddBigint(Bigint, C, Bigint);                
    I := I + 9;
  end;
  Bigint.Sign := ResSign;
end;

// ****************************************************************************

function BigintToInt(X: TBigint): Cardinal;
asm
  mov eax, X.PtrDigits
  mov eax, [eax]
end;

procedure BigintToInt(const Bigint: TBigint; var X: Integer);
begin
end;

procedure BigintToInt(const Bigint: TBigint; var X: String);
var
  A: TBigint;
  D: Cardinal;
  IsZero: Boolean;
  S, Zeroes: String[9];
begin
  case Bigint.Sign of
    -1: X := '';
    1: X := '';
  else
    X := '0';
    Exit;
  end;
  Zeroes := '000000000';
  CreateBigint(A);                          // ��������� ����� ��������� Bigint
  CopyBigint(Bigint, A);
  if A.Sign < 0 then A.Sign := 1;
  repeat
    D := DivBigint(A, 1000000000, A);
    IsZero := (A.Sign = 0);
    S := IntToStr(D);
    if (Length(S) < 9) and (not IsZero) then   // ���� ��� �� ��������� �������
    begin
      Zeroes[0] := Chr(9-Length(S));
      S := Zeroes + S;
    end;
    X := S + X;
  until IsZero;
  if Bigint.Sign < 0 then X := '-' + X;
  DestroyBigint(A);
end;

end.