// ����� �������� ��� ���������� ���������� �������� ��� ����������� ������.
// ������ ��� Delphi 5 � 32-� ��������� �����������.
// �����: ������� �.�.

unit sdpLogic;

interface

uses
  sdpBigint;

// ���������� ����� �������� ���������� ���� (��������� ���������� � 0).
// ���� X = 0, �� ���������� -1.
function HighestBit(X: Byte): Integer; overload;
function HighestBit(X: Shortint): Integer; overload;
function HighestBit(X: Word): Integer; overload;
function HighestBit(X: Smallint): Integer; overload;
function HighestBit(X: Cardinal): Integer; overload;
function HighestBit(X: Integer): Integer; overload;
function HighestBit(X: Int64): Integer; overload;
function HighestBit(const X: TBigint): Integer; overload;

// ���������� ����� �������� ���������� ���� (��������� ���������� � 0).
// ���� X = 0, �� ���������� -1.
function LowestBit(X: Shortint): Integer; overload;
function LowestBit(X: Byte): Integer; overload;
function LowestBit(X: Smallint): Integer; overload;
function LowestBit(X: Word): Integer; overload;
function LowestBit(X: Integer): Integer; overload;
function LowestBit(X: Cardinal): Integer; overload;
function LowestBit(X: Int64): Integer; overload;
function LowestBit(const X: TBigint): Integer; overload;

procedure ShiftLeft(var X: TBigint; N: Byte);

// ��������� ���������� �� ���������� ��������. ��������� ����� 1 ���� A>B,
// 0 - A=B, -1 - A<B.
function CompareAbs(A, B: Shortint): Shortint; overload;
function CompareAbs(A, B: Smallint): Shortint; overload;
function CompareAbs(A, B: Integer): Shortint; overload;
function CompareAbs(A, B: Int64): Shortint; overload;
function CompareAbs(const A, B: TBigint): Shortint; overload;
function CompareAbs(const A: TBigint; B: Cardinal): Shortint; overload;

// ��������� ����������. ��������� ����� 1 ���� A>B, 0 - A=B, -1 - A<B.
function Compare(A, B: Byte): Shortint; overload;
function Compare(A, B: Shortint): Shortint; overload;
function Compare(A, B: Word): Shortint; overload;
function Compare(A, B: Smallint): Shortint; overload;
function Compare(A, B: Cardinal): Shortint; overload;
function Compare(A, B: Integer): Shortint; overload;
function Compare(A, B: Int64): Shortint; overload;
function Compare(const A, B: TBigint): Shortint; overload;

implementation

const
  BytesInWord     = SizeOf(Word);
  BytesInSmallint = SizeOf(Smallint);
  BytesInCardinal = SizeOf(Cardinal);
  BytesInInteger  = SizeOf(Integer);
  BytesInInt64    = SizeOf(Int64);

  BitsInByte     = 8;
  BitsInShortint = SizeOf(Shortint)*BitsInByte;
  BitsInWord     = BytesInWord*BitsInByte;
  BitsInSmallint = BytesInSmallint*BitsInByte;
  BitsInCardinal = BytesInCardinal*BitsInByte;
  BitsInInteger  = BytesInInteger*BitsInByte;
  BitsInInt64    = BytesInInt64*BitsInByte;

type
  PCardinal = ^Cardinal;

//    � ����� ��������� ������������� ��������������, ������� ���������
// ������������ ����������������, ��������� ��������� ���� �����������
// ��������� ��� ������ ����, ����� ���������� ��� ��������� ���������.

function HighestBit(X: Byte): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsr   eax, ecx
end;

function HighestBit(X: Shortint): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsr   eax, ecx
end;

function HighestBit(X: Word): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsr   eax, ecx
end;

function HighestBit(X: Smallint): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsr   eax, ecx
end;

function HighestBit(X: Cardinal): Integer;
asm
  mov ecx, X
  mov eax, -1
  bsr eax, ecx
end;

function HighestBit(X: Integer): Integer;
asm
  mov ecx, X
  mov eax, -1
  bsr eax, ecx
end;

function HighestBit(X: Int64): Integer;
asm
  push esi
  lea  esi, X+BytesInCardinal               // esi = ��������� �� ������� �����
  mov  eax, -1
  bsr  eax, [esi]
  jz   @ZeroDWord                                          // ������� ����� = 0
  add  eax, BitsInCardinal
  jmp  @Exit
@ZeroDWord:
  sub  esi, BytesInCardinal                 // esi = ��������� �� ������� �����
  bsr  eax, [esi]
@Exit:
  pop  esi
end;

function HighestBit(const X: TBigint): Integer;
asm
  push  esi
  mov   esi, X+ofPtrDigits                   // esi = ��������� �� ������� ����
  movzx ecx, byte ptr (X+ofMSB)              // ecx = ���������� ������ � �����
  dec   ecx
  shl   ecx, 2              // ecx := ecx*4 - ���������� ���� �� �������� �����
  add   esi, ecx                             // esi = ��������� �� ������� ����
  mov   eax, -1
  bsr   eax, [esi]
  jz    @Exit                                     // ������� ���� = 0, �� X = 0
  shl   ecx, 3               // ecx := ecx*8 - ���������� ��� �� �������� �����
  add   eax, ecx
@Exit:
  pop esi
end;

// ****************************************************************************

function LowestBit(X: Shortint): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsf   eax, ecx
end;

function LowestBit(X: Byte): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsf   eax, ecx
end;

function LowestBit(X: Smallint): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsf   eax, ecx
end;

function LowestBit(X: Word): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsf   eax, ecx
end;

function LowestBit(X: Integer): Integer;
asm
  mov ecx, X
  mov eax, -1
  bsf eax, ecx
end;

function LowestBit(X: Cardinal): Integer;
asm
  mov ecx, X
  mov eax, -1
  bsf eax, ecx
end;

function LowestBit(X: Int64): Integer;
asm
  push esi
  lea  esi, X                               // esi = ��������� �� ������� �����
  mov  eax, -1
  bsf  eax, dword ptr [esi]
  jnz  @Exit                                              // ������� ����� <> 0
  add  esi, BytesInCardinal                 // esi = ��������� �� ������� �����
  bsf  eax, dword ptr [esi]
  jz   @Exit                                               // ������� ����� = 0
  add  eax, BitsInCardinal
@Exit:
  pop  esi
end;

function LowestBit(const X: TBigint): Integer;
asm
  push  esi
  mov   esi, X+ofPtrDigits                   // esi = ��������� �� ������� ����
  movzx ecx, byte ptr (X+ofMSB)              // ecx = ���������� ������ � �����
  mov   eax, -1
  xor   edx, edx                                  // ������� ������������ �����
@NextBlock:
  bsf   eax, [esi]
  jnz   @BreakLoop                                       // ������ ������� ����
  add   esi, BytesInCardinal
  add   edx, BitsInCardinal
  loop  @NextBlock
  cmp   eax, -1                                                       // X = 0?
  je    @Exit
@BreakLoop:
  add   eax, edx
@Exit:
  pop   esi
end;

// ****************************************************************************

procedure ShiftLeft(var X: TBigint; N: Byte);
begin
//  HighestBit(TDigits(X.PtrDigits^)[X.MSB]);
end;

// ****************************************************************************

function CompareAbs(A, B: Shortint): Shortint;
begin
  A := Abs(A);
  B := Abs(B);
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function CompareAbs(A, B: Smallint): Shortint;
begin
  A := Abs(A);
  B := Abs(B);
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function CompareAbs(A, B: Integer): Shortint;
begin
  A := Abs(A);
  B := Abs(B);
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function CompareAbs(A, B: Int64): Shortint;
begin
  A := Abs(A);
  B := Abs(B);
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function CompareAbs(const A, B: TBigint): Shortint;
var
  PtrFirst, PtrSecond: PCardinal;
  Count: Byte;
begin
  // ����� ��� �� ����������, ������� ��������� �����
  if A.MSB = B.MSB then                                // ��������� ����� �����
  begin
    PtrFirst := A.PtrDigits;
    PtrSecond := B.PtrDigits;
    Count := A.MSB;
    // ������������� ��������� �� ������� �������� ����
    Inc(PtrFirst, Count-1);
    Inc(PtrSecond, Count-1);
    // ���������� ��������� ���������
    while (PtrFirst^ = PtrSecond^) and (Count > 0) do
    begin
      Dec(PtrFirst);
      Dec(PtrSecond);
      Count := Count - 1;
    end;
    if Count = 0 then                           // ������� �������� ���� ������
      Result := 0
    else                                        // ��������� ��� ����� �� �����
      if PtrFirst^ > PtrSecond^ then Result := 1 else Result := -1;
  end
  else                     // ��������� ������ �����, ������� �������� �� �����
    if A.MSB > B.MSB then Result := 1 else Result := -1;
end;

function CompareAbs(const A: TBigint; B: Cardinal): Shortint;
begin
  // ���� ��� �� ����������, ��������� �����
  if A.MSB = 1 then                                    // ��������� ����� �����
  begin
    if PCardinal(A.PtrDigits)^ > B then
      Result := 1
    else
      if PCardinal(A.PtrDigits)^ = B then Result := 0 else Result := -1;
  end
  else                    // ��������� ������ �����, ������� �������� |A| > |B|
    Result := 1;
end;

// ****************************************************************************

function Compare(A, B: Byte): Shortint;
begin
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function Compare(A, B: Shortint): Shortint;
begin
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function Compare(A, B: Word): Shortint;
begin
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function Compare(A, B: Smallint): Shortint;
begin
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function Compare(A, B: Cardinal): Shortint;
begin
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function Compare(A, B: Integer): Shortint;
begin
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function Compare(A, B: Int64): Shortint;
begin
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function Compare(const A, B: TBigint): Shortint;
begin
  // ��������� ����� ����������
  if A.Sign > B.Sign then
  begin
    Result := 1;
    Exit;
  end;
  if A.Sign < B.Sign then
  begin
    Result := -1;
    Exit;
  end;
  // ��������� ������ �����, ��������� �����
  if A.MSB = B.MSB then                                // ��������� ����� �����
  begin
    if A.Sign = -1 then                                         // A < 0, B < 0
      Result := -CompareAbs(A, B)
    else                                     // A = 0, B = 0 ����� A > 0, B > 0
      if A.Sign = 0 then Result := 0 else Result := CompareAbs(A, B);
  end
  else                                                // ��������� ������ �����
  begin
    // �������� A.Sign <> 0, ����� �� ������� � ����� ����������
    if A.Sign = -1 then                                         // A < 0, B < 0
      if A.MSB < B.MSB then Result := 1 else Result := -1
    else                                                        // A > 0, B > 0
      if A.MSB > B.MSB then Result := 1 else Result := -1;
  end;
end;

end.
