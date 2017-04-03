// ������ ��������� �������� � "��������" �������.
// ������ ��� Borland Delphi 7 (��������� Win32).
// �����: ������� �. �.

unit sdpBigint;

interface

const
  // ��������� ���������. �� ��������!!!
  BlockSize   = 4;            // ������ ������ ����� (����) = ������� ���������
  ofSize      = $00;                // �������� ���� Size ������ ������ TBigint
  ofMSB       = $01;                 // �������� ���� MSB ������ ������ TBigint
  ofPtrDigits = $02;           // �������� ���� PtrDigits ������ ������ TBigint
  ofSign      = $06;                // �������� ���� Sign ������ ������ TBigint

  MinSizeBigint: Byte = 10;                         // ����������� ������ �����

type
  // ������������ ����� ����� �� ������
  TBigint = packed record
    Size: Byte;                                      // ������ ����� (� ������)
    MSB: Byte;      // ����� �������� ���������� ����� (Most Significant Block)
    PtrDigits: Pointer;              // ��������� �� ������ ������ (��� "����")
    Sign: Shortint;                                               // ���� �����
  end;

// ���������. ���� � ������� MSB ������ ������� �� ����, ����� ������ �����
// ����� ����� ����. ������ ����������� ����������� MSB <= Size.

// ���������. �������� ���� Sign ���������� ��������� �������: -1 - �����
// �������������, 0 - ����� ����, +1 - ����� �������������. ������� ���������
// ���� ������ ��-�� ����, ��� �������� ������������� ��� +0, ��� � -0.

  TDigits = array [1..255] of Cardinal;

// ���������. ��� TDigits ������ ��� ��������� ����� � ������������ ������ ���
// ������� � ������ ������������� ������ �����.

// ****************************************************************************
// **********                ��������� �������������                 **********
// ****************************************************************************

// �������� ��� ����� ������ �������� StartSize ������ � ����������� �����
// �������� 0. ��� ���� ���������� ������ ������� ���� �����. ���� StartSize
// ����������� ��� ��� ������, ��� MinSizeBigint, �� ���������� MinSizeBigint
// ������.
procedure CreateBigint(var A: TBigint; StartSize: Byte = 0);

// ����������� ������, ���������� ������.
procedure DestroyBigint(var A: TBigint);

// ****************************************************************************
// **********           ���������� ��������, ������������            **********
// ****************************************************************************

// ������������� ������ ����� ������ NewSize ������. ���� ������ ������ �����
// ��� ������ ��� NewSize, �� ��� ������� ����� �������������. ����
// NewSize < MinSizeBigint, �� ��������������� ������, ������ MinSizeBigint.
procedure SetSizeBigint(var A: TBigint; NewSize: Byte);

// ������� ���������� �������������� �����, �� ������ ����� �� ����� ����
// ������, ��� MinSizeBigint ������.
procedure PackBigint(var A: TBigint);

// ��������� A := 0 � �������� ��� ������, ���������� ��� �����. ����
// ���������� ��������� ������ ������������ A := 0, �� �������������
// ��������������� ���������� ����������� IntToBigint �� ������ sdpConvert.
procedure SetZeroBigint(var A: TBigint);

// �������� A � B, �� ���� ��������� B := A.
procedure CopyBigint(const A: TBigint; var B: TBigint);

// ���������� A � B, �� ���� ��������� B := A � A := 0. �����������, ���
// CopyBigint, �������� ��� ����� ������� �����.
procedure MoveBigint(var A, B: TBigint);

// ****************************************************************************
// **********            �������� �������������� ��������            **********
// ****************************************************************************

// ��������� C := A + B
procedure AddBigint(const A, B: TBigint; var C: TBigint); overload;
procedure AddBigint(const A: TBigint; B: Cardinal; var C: TBigint); overload;

// ��������� A := A + Delta, ������������ AddBigint(A, Delta, A).
procedure IncBigint(var A: TBigint; Delta: Cardinal);

// ��������� C := A - B
procedure SubBigint(const A, B: TBigint; var C: TBigint); overload;
procedure SubBigint(const A: TBigint; B: Cardinal; var C: TBigint); overload;

// ��������� A := A - Delta, ������������ SubBigint(A, Delta, A).
procedure DecBigint(var A: TBigint; Delta: Cardinal);

// ��������� C := A * B
procedure MulBigint(const A, B: TBigint; var C: TBigint); overload;
procedure MulBigint(const A: TBigint; B: Cardinal; var C: TBigint); overload;

// ��������� C := A div B, D := A mod B.
procedure DivBigint(const A, B: TBigint; var C, D: TBigint); overload;
function DivBigint(const A: TBigint; B: Cardinal; var C: TBigint): Cardinal; overload;

// ****************************************************************************
// **********         �������������� �������������� ��������         **********
// ****************************************************************************

// ��������� B := A*(Base^N), ��� Base - ��������� ������� ���������, � �
// ������ ������ ����� 2^32. ����������, �������� ����� ����� �� N ������.
procedure MulByPowerBase(A: TBigint; N: Byte; var B: TBigint);

// ��������� Y := X^N mod M. ������������ �������� ����� "S � X".
procedure PowerMod(const X, N, M: TBigint; var Y: TBigint);

// ���������� �������� ������� A*B + C*D = G = GCD(A,B)
procedure ExtEuclidGCD(const A, B: TBigint; var G, C, D: TBigint);
procedure EuclidGCD(const A, B: TBigint; var C: TBigint);

procedure SqrBigint(const A: TBigint; var B: TBigint);

// ****************************************************************************
// **********         �������������� �������������� ��������         **********
// ****************************************************************************

// ��������� C := |A|+|B|. ����������� �������������� ��������. ���� C.MSB
// ��������������� ��������������� �������. ��� ��������� ���� ����������
// �������� �����������. ��������� ������ ������������� ��������� ��������
// (�������� �� ������������ ���������� �� ������������):
// 1) A.MSB >= B.MSB.
// 2) ��������� �������� ������ ���������� � C.
procedure LowLevelAdd(const A, B: TBigint; var C: TBigint);

// ��������� C := |A|-|B|. ����������� �������������� ���������. ���� C.MSB
// ��������������� ��������������� �������. ��� ��������� ���� ����������
// �������� �����������. ��������� ������ ������������� ��������� ��������
// (�������� �� ������������ ���������� �� ������������):
// 1) |A| > |B|, �. �. ��������� �������� ������ ���� �������������. � ������,
//    ���� |A| = |B|, ��������� ��������� C.MSB = 0.
// 2) ��������� �������� ������ ���������� � C.
procedure LowLevelSub(const A, B: TBigint; var C: TBigint);

// ��������� C := |A|*|B|. ����������� �������������� ��������� "���������".
// ���� C.MSB ��������������� ��������������� �������. ��� ��������� ����
// ���������� �������� �����������. ��������� ������ ������������� ���������
// �������� (�������� �� ������������ ���������� �� ������������):
// 1) C.Digits ������ ��������� ���� �� ���� ������.
// 2) ������� � �������� ��������� ��������� �� �����.
// 3) ��������� �������� ������ ���������� � C.
procedure LowLevelMul(const A, B: TBigint; var C: TBigint);

implementation

uses
  SysUtils, Math, sdpConvert, sdpLogic;

type
  PCardinal = ^Cardinal;

// ****************************************************************************
// **********                ��������� �������������                 **********
// ****************************************************************************

procedure CreateBigint(var A: TBigint; StartSize: Byte = 0);
begin
  if StartSize < MinSizeBigint then StartSize := MinSizeBigint;
  with A do
  begin
    Size := StartSize;
    MSB := 1;
    GetMem(PtrDigits, Size*BlockSize);
    PCardinal(PtrDigits)^ := 0;
    Sign := 0;
  end;
end;

procedure DestroyBigint(var A: TBigint);
begin
  with A do FreeMem(PtrDigits, Size*BlockSize);
end;

// ****************************************************************************
// **********           ���������� ��������, ������������            **********
// ****************************************************************************

procedure SetSizeBigint(var A: TBigint; NewSize: Byte);
begin
  if NewSize < MinSizeBigint then NewSize := MinSizeBigint;
  with A do
  begin
    Size := NewSize;
    if MSB > Size then MSB := Size;
    ReallocMem(PtrDigits, Size*BlockSize);
  end;
end;

procedure PackBigint(var A: TBigint);
var
  NewSize: Byte;
begin
  with A do
  begin
    if MSB <= MinSizeBigint then NewSize := MinSizeBigint else NewSize := MSB;
    Size := NewSize;
    ReallocMem(PtrDigits, Size*BlockSize);
  end;
end;

procedure SetZeroBigint(var A: TBigint);
asm                                                            // eax = Addr(A)
  push  edi
  mov   A.MSB, 1                                            // ���������� A.MSB
  mov   A.Sign, 0                                          // ���������� A.Sign
  mov   edi, A.PtrDigits                                   // edi = A.PtrDigits
  movzx ecx, A.Size                                             // ecx = A.Size
  xor   eax, eax
  cld
  rep stosd                                       // �������� ���������� ������
  pop   edi
end;

procedure CopyBigint(const A: TBigint; var B: TBigint);
begin
  with B do
  begin
    if Size < A.MSB then SetSizeBigint(B, A.MSB);
    MSB := A.MSB;
    Move(A.PtrDigits^, PtrDigits^, MSB*BlockSize);
    Sign := A.Sign;
  end;
end;

procedure MoveBigint(var A, B: TBigint);
var
  B_PtrDigits: Pointer;
  B_Size: Byte;
begin
  with B do
  begin
    B_PtrDigits := PtrDigits;
    B_Size := Size;
    Size := A.Size;
    MSB := A.MSB;
    PtrDigits := A.PtrDigits;
    Sign := A.Sign;
  end;
  with A do
  begin
    Size := B_Size;
    PtrDigits := B_PtrDigits;
  end;
  IntToBigint(Cardinal(0), A);
end;

// ****************************************************************************
// **********                �������������� ��������                 **********
// ****************************************************************************

procedure AddBigint(const A, B: TBigint; var C: TBigint);
var
  MaxMSB: Byte;
begin
  // ��������� ��������� �� ��������� ����
  if A.Sign = 0 then                                             // A=0, �� C=B
  begin
    CopyBigint(B, C);
    Exit;
  end;
  if B.Sign = 0 then                                    // A<>0, �� B=0, �� C=A
  begin
    CopyBigint(A, C);
    Exit;
  end;
  // A <> 0 � B <> 0, �� ��������� ����� � �����
  MaxMSB := Max(A.MSB, B.MSB);
  if A.Sign = B.Sign then                             // ��������� ������ �����
  begin
    C.Sign := A.Sign;
    if C.Size <= MaxMSB then SetSizeBigint(C, MaxMSB+1);
    if A.MSB >= B.MSB then LowLevelAdd(A, B, C) else LowLevelAdd(B, A, C);
  end
  else                                               // ��������� ������ ������
  begin
    if C.Size < MaxMSB then SetSizeBigint(C, MaxMSB);
    case CompareAbs(A, B) of
     -1:                                                           // |A| < |B|
       begin
         if A.Sign > B.Sign then C.Sign := -1 else C.Sign := 1;
         LowLevelSub(B, A, C);
       end;
     0: IntToBigint(Cardinal(0), C);                               // |A| = |B|
     1:                                                            // |A| > |B|
       begin
         if A.Sign > B.Sign then C.Sign := 1 else C.Sign := -1;
         LowLevelSub(A, B, C);
       end;
    end;
  end;
end;

procedure AddBigint(const A: TBigint; B: Cardinal; var C: TBigint);
var
  MaxMSB: Byte;
begin
  // ��������� ��������� �� ��������� ����
  if A.Sign = 0 then                                        // A = 0, �� C := B
  begin
    IntToBigint(B, C);
    Exit;
  end;
  if B = 0 then                                  // A <> 0, �� B = 0, �� C := A
  begin
    CopyBigint(A, C);
    Exit;
  end;
  // A <> 0 � B <> 0
  MaxMSB := A.MSB;
  if A.Sign > 0 then                      // A > 0, B > 0 => ��������� ��������
  begin
    C.Sign := 1;
    if C.Size <= MaxMSB then SetSizeBigint(C, MaxMSB+1);
    // ��������� �������� � ���������� ���� C.MSB
    asm
      push  esi
      push  edi
      push  ebx
      mov   eax, A
      mov   esi, [eax+ofPtrDigits]     // esi = A.PtrDigits
      movzx ecx, byte ptr [eax+ofMSB]  // ecx = A.Size
      push  ecx                        // ��������� A.Size
      mov   ebx, C
      mov   edi, [ebx+ofPtrDigits]     // edi = C.PtrDigits
      mov   eax, [esi]                 // ��������� ����� �� ������� �����
      add   eax, B
      mov   [edi], eax                 // ������� � ���������
      dec   ecx
      jz    @LastCarry
      mov   edx, 1
@NextDigit:
      mov   eax, [esi+edx*4]           // ��������� ����� �� ������� �����
      adc   eax, 0
      mov   [edi+edx*4], eax           // ������� � ���������
      inc   edx
      dec   ecx
      jnz   @NextDigit
@LastCarry:
      pop   ecx                       // ������������ ���������� "����" � ������ �����
      jnc   @Exit                     // ������� ���� ��� �������� � ��������� ������
      inc   ecx
@Exit:
      mov   byte ptr [ebx+ofMsb], cl
      mov   dword ptr [edi+edx*4], 1
      pop   ebx
      pop   edi
      pop   esi
    end;
  end
  else                                   // A < 0, B > 0 => ��������� ���������
  begin
    if C.Size < MaxMSB then SetSizeBigint(C, MaxMSB);
    case CompareAbs(A, B) of
      -1:                                                          // |A| < |B|
        begin
          C.MSB := 1;
          C.Sign := 1;
          PCardinal(C.PtrDigits)^ := B - PCardinal(A.PtrDigits)^;
        end;
      0: IntToBigint(Cardinal(0), C);                              // |A| = |B|
      1:                                                           // |A| > |B|
        begin
          C.Sign := -1;
          // ��������� ��������� � ���������� ���� C.MSB
          asm
            push  esi
            push  ebx
            mov   eax, A
            mov   esi, [eax+ofPtrDigits]           // esi = ����� ������� �����
            movzx ecx, byte ptr [eax+ofMSB] // ecx = ���-�� ���� � ������ �����
            mov   edx, C
            mov   ebx, [edx+ofPtrDigits]              // ebx = ����� ����������
            push  edx                               // ��������� ��������� �� C
            xor   edx, edx
            mov   eax, [esi]                // ��������� ����� �� ������� �����
            inc   esi
            inc   esi
            inc   esi
            inc   esi
            sub   eax, B
            inc   dl                        // dl - ������� ������������ ������
            mov   dh, dl                // dh - ����� �������� ���������� �����
            mov   [ebx], eax                             // ������� � ���������
            inc   ebx
            inc   ebx
            inc   ebx
            inc   ebx
            dec   ecx
            jcxz  @Exit
@NextDigit:
            mov   eax, [esi]                // ��������� ����� �� ������� �����
            inc   esi
            inc   esi
            inc   esi
            inc   esi
            sbb   eax, 0
            inc   dl                        // dl - ������� ������������ ������
            jz    @ZeroBlock
            mov   dh, dl                // dh - ����� �������� ���������� �����
@ZeroBlock:
            mov   [ebx], eax                             // ������� � ���������
            inc   ebx
            inc   ebx
            inc   ebx
            inc   ebx
            loop  @NextDigit
@Exit:
            pop  eax                             // ������������ ��������� �� C
            mov  [eax+ofMsb], dh                       // ���������� ���� C.MSB
            pop  ebx
            pop  esi
          end;
        end;
    end;
  end;
end;

procedure IncBigint(var A: TBigint; Delta: Cardinal);
begin

end;

procedure SubBigint(const A, B: TBigint; var C: TBigint);
var
  MaxMSB: Byte;
begin
  // ��������� ��������� �� ��������� ����
  if A.Sign = 0 then                                          // A=0, �� C = -B
  begin
    CopyBigint(B, C);
    C.Sign := -C.Sign;
    Exit;
  end;
  if B.Sign = 0 then                                    // A<>0, �� B=0, �� C=A
  begin
    CopyBigint(A, C);
    Exit;
  end;
  // A <> 0 � B <> 0, �� ��������� ����� � �����
  MaxMSB := Max(A.MSB, B.MSB);
  if A.Sign = B.Sign then                             // ��������� ������ �����
  begin
    if C.Size < MaxMSB then SetSizeBigint(C, MaxMSB);
    case CompareAbs(A, B) of
     -1:                                                           // |A| < |B|
       begin
         if A.Sign = 1 then C.Sign := -1 else C.Sign := 1;
         LowLevelSub(B, A, C);
       end;
     0: IntToBigint(Cardinal(0), C);                               // |A| = |B|
     1:                                                            // |A| > |B|
       begin
         if A.Sign = 1 then C.Sign := 1 else C.Sign := -1;
         LowLevelSub(A, B, C);
       end;
    end;
  end
  else                                               // ��������� ������ ������
  begin
    C.Sign := A.Sign;
    if C.Size <= MaxMSB then SetSizeBigint(C, MaxMSB+1);
    if A.MSB >= B.MSB then LowLevelAdd(A, B, C) else LowLevelAdd(B, A, C);
  end;
end;

procedure SubBigint(const A: TBigint; B: Cardinal; var C: TBigint);
var
  LocB: TBigint;
begin
  // ��������� ��������� �� ��������� ����
  if A.Sign = 0 then                                          // A=0, �� C = -B
  begin
    IntToBigint(B, C);
    C.Sign := -C.Sign;
    Exit;
  end;
  if B = 0 then                                         // A<>0, �� B=0, �� C=A
  begin
    CopyBigint(A, C);
    Exit;
  end;
  // A <> 0 � B <> 0
  CreateBigint(LocB);
  IntToBigint(B, LocB);
  SubBigint(A, LocB, C);
  DestroyBigint(LocB);
end;

procedure DecBigint(var A: TBigint; Delta: Cardinal);
begin

end;

procedure MulBigint(const A, B: TBigint; var C: TBigint);
var
  LocA, LocB, LocC: TBigint;
begin
  // ��������� ��������� �� ��������� ����
  if (A.Sign = 0) or (B.Sign = 0) then
  begin
    IntToBigint(Cardinal(0), C);
    Exit;
  end;
  // A <> 0 � B <> 0, �� ��������� �����
  CreateBigint(LocA);
  CreateBigint(LocB);
  CreateBigint(LocC, A.MSB+B.MSB);
  CopyBigint(A, LocA);
  CopyBigint(B, LocB);
  LowLevelMul(LocA, LocB, LocC);
  CopyBigint(LocC, C);
  if LocA.Sign = LocB.Sign then C.Sign := 1 else C.Sign := -1;
  DestroyBigint(LocA);
  DestroyBigint(LocB);
  DestroyBigint(LocC);
end;

procedure MulBigint(const A: TBigint; B: Cardinal; var C: TBigint);
var
  LocC: TBigint;
begin
  // ��������� ��������� �� ��������� ����
  if (A.Sign = 0) or (B = 0) then
  begin
    IntToBigint(Cardinal(0), C);
    Exit;
  end;
  // A <> 0 � B <> 0
  CreateBigint(LocC, A.MSB+1);                   // �������� ����� �� ���������
  asm
    push  esi
    push  edi
    push  ebx
    mov   eax, A
    mov   esi, [eax+ofPtrDigits]                   // esi = ����� ������� �����
    movzx ecx, byte ptr [eax+ofMSB]                              // ecx = A.MSB
    push  ecx                                                // ��������� A.MSB
    mov   edi, LocC.PtrDigits                         // edi = ����� ����������
    xor   ebx, ebx
@NextDigit:
    mov   eax, [esi+ebx*4]                  // ��������� ����� �� ������� �����
    mul   B
    add   [edi+ebx*4], eax
    adc   [edi+ebx*4+4], edx
    inc   ebx
    dec   ecx
    jnz   @NextDigit
    pop   ecx                                             // ������������ A.MSB
    cmp   edx, 0
    je    @Exit
    inc   ecx
@Exit:
    mov   LocC.MSB, cl
    pop   ebx
    pop   edi
    pop   esi
  end;
  LocC.Sign := A.Sign;
  MoveBigint(LocC, C);
  DestroyBigint(LocC);
end;

procedure DivBigint(const A, B: TBigint; var C, D: TBigint);
type
  TDig = array [0..255] of Cardinal;
var
  LocA, LocB, LocBB: TBigint;
  Temp1, Temp2, Temp3, Temp4: TBigint;
  Lambda: Cardinal;
  n, t: Byte;
  i: Integer;
  Sign_A, Sign_B: Shortint;
begin
  if A.Sign = 0 then
  begin
    IntToBigint(Cardinal(0), C);
    IntToBigint(Cardinal(0), D);
    Exit;
  end;
  CreateBigint(LocA);
  CreateBigint(LocB);
  CreateBigint(LocBB);
  CreateBigint(Temp1);
  CreateBigint(Temp2);
  CreateBigint(Temp3);
  CreateBigint(Temp4);
  CopyBigint(A, LocA);
  CopyBigint(B, LocB);
  CopyBigint(B, LocBB);
  Sign_A := A.Sign;
  Sign_B := B.Sign;
  LocA.Sign := 1;                                          // LocA := Abs(LocA)
  LocB.Sign := 1;                                          // LocB := Abs(LocB)
  LocBB.Sign := 1;
  // ������������
  Lambda := 1 shl (31 - HighestBit(TDigits(LocB.PtrDigits^)[LocB.MSB]));
  MulBigint(LocA, Lambda, LocA);
  MulBigint(LocB, Lambda, LocB);
  n := LocA.MSB-1;
  t := LocB.MSB-1;
  if C.Size < n-t then SetSizeBigint(C, n-t);
  SetZeroBigint(C);
  MulByPowerBase(LocB, n-t, Temp1);    // Temp1 := LocB * b^(n-t), ��� b = 2^32
  while Compare(LocA, Temp1) > -1 do
  begin
    TDig(C.PtrDigits^)[n-t] := TDig(C.PtrDigits^)[n-t] + 1;
    SubBigint(LocA, Temp1, LocA);
  end;
  for i := n downto (t+1) do
  begin
    if TDig(LocA.PtrDigits^)[i] = TDig(LocB.PtrDigits^)[t] then
      TDig(C.PtrDigits^)[i-t-1] := $FFFFFFFF
    else
    begin
      IntToBigint(TDig(LocA.PtrDigits^)[i], Temp1);
      MulByPowerBase(Temp1, 1, Temp1);
      if (i-1) >= 0 then AddBigint(Temp1, TDig(LocA.PtrDigits^)[i-1], Temp1);
      DivBigint(Temp1, TDig(LocB.PtrDigits^)[t], Temp1);
    end;
    IntToBigint(Cardinal(1), Temp2);
    IntToBigint(Cardinal(0), Temp3);
    while Compare(Temp2, Temp3) > 0 do
    begin
      IntToBigint(TDig(LocB.PtrDigits^)[t], Temp2);
      MulByPowerBase(Temp2, 1, Temp2);
      if (t-1) >= 0 then AddBigint(Temp2, TDig(LocB.PtrDigits^)[t-1], Temp2);
      MulBigint(Temp2, Temp1, Temp2);
      IntToBigint(TDig(LocA.PtrDigits^)[i], Temp3);
      MulByPowerBase(Temp3, 2, Temp3);
      if (i-1) >= 0 then
        IntToBigint(TDig(LocA.PtrDigits^)[i-1], Temp4)
      else
        IntToBigint(Cardinal(0), Temp4);
      MulByPowerBase(Temp4, 1, Temp4);
      AddBigint(Temp3, Temp4, Temp3);
      if (i-2) >= 0 then AddBigint(Temp3, TDig(A.PtrDigits^)[i-2], Temp3);
      if Compare(Temp2, Temp3) > 0 then SubBigint(Temp1, 1, Temp1);
    end;
    MulByPowerBase(LocB, i-t-1, Temp2);
    MulBigint(Temp2, Temp1, Temp2);
    SubBigint(LocA, Temp2, LocA);
    if LocA.Sign = -1 then
    begin
      MulByPowerBase(LocB, i-t-1, Temp2);
      AddBigint(LocA, Temp2, LocA);
      SubBigint(Temp1, 1, Temp1);
    end;
    TDig(C.PtrDigits^)[i-t-1] := TDig(Temp1.PtrDigits^)[0];
  end;
  n:=n+1;
  t:=t+1;
  if TDigits(C.PtrDigits^)[n-t+1] <> 0 then C.MSB := n-t+1 else C.MSB := n-t;
  if C.MSB = 0 then
  begin
    C.MSB := 1;
    C.Sign := 0;
  end
  else
    C.Sign := 1;
  DivBigint(LocA, Lambda, LocA);
  CopyBigint(LocA, D);
  if (Sign_A < 0) and (Sign_B > 0) then
  begin
    if D.Sign <> 0 then
    begin
      AddBigint(C, 1, C);
      SubBigint(LocBB, D, D);
    end;
    C.Sign := -1;
  end;
  if (Sign_A > 0) and (Sign_B < 0) then
  begin
    if D.Sign <> 0 then
    begin
      AddBigint(C, 1, C);
      SubBigint(D, LocBB, D);
    end;
    C.Sign := -1;
  end;
  if (Sign_A < 0) and (Sign_B < 0) then
  begin
    if D.Sign <> 0 then D.Sign := -1;
  end;
  DestroyBigint(LocA);
  DestroyBigint(LocB);
  DestroyBigint(LocBB);
  DestroyBigint(Temp1);
  DestroyBigint(Temp2);
  DestroyBigint(Temp3);
  DestroyBigint(Temp4);
end;

// ������������ ��������, ����������� � ����� (���. 322 ���������� 16; ����� ��
// ���. 684): ���� �. ��������� ����������������, ��� 2. �������������
// ���������, 3-� ���., 2000.
function DivBigint(const A: TBigint; B: Cardinal; var C: TBigint): Cardinal;
var
  A_Sign: Shortint;
begin
  Result := 0;
  if A.Sign = 0 then
  begin
    IntToBigint(Cardinal(0), C);
    Exit;
  end;
  if B = 1 then
  begin
    CopyBigint(A, C);
    Exit;
  end;
  // �������������� ����������� A � C ������� ���������, �. �. ��������, ���
  // ��� ��������� �� ���� � �� �� ������, �. �. ������� � �������� ���������
  // ���������. � ����� ������ ������������� ����� ����� �������� ����
  // C.PtrDigits, � ������ � A.PtrDigits.
  if C.Size < A.MSB then SetSizeBigint(C, A.MSB);
  A_Sign := A.Sign;
  // ���������� ������� Abs(A)/B � ���������� ���� C.MSB � C.Sign
  asm
    push  esi
    push  edi
    mov   edx, A
    mov   esi, [edx+ofPtrDigits]               // ��������� ����� ������� �����
    movzx ecx, byte ptr [edx+ofMSB]         // ���������� "����" � ������ �����
    mov   eax, ecx
    dec   eax
    shl   eax, 2
    add   esi, eax             // esi = ��������� �� ������� ���� ������� �����
    mov   edx, C
    mov   [edx+ofMSB], cl                      // ���������� C.MSB �� ���������
    mov   edi, [edx+ofPtrDigits]                    // ��������� ����� ��������
    add   edi, eax                  // edi = ��������� �� ������� ���� ��������
    push  edx
    push  edi
    xor   edx, edx
@NextDigit:
    mov   eax, [esi]
    sub   esi, 4
    div   B
    mov   [edi], eax
    sub   edi, 4
    loop  @NextDigit
    mov   @Result, edx
    pop   edi
    pop   edx
    mov   byte ptr [edx+ofSign], 1                               // C.Sign := 1
    cmp   dword ptr [edi], 0
    jne   @Exit
    cmp   byte ptr [edx+ofMSB], 1
    je    @ZeroResult
    dec   byte ptr [edx+ofMSB]
    jmp   @Exit
@ZeroResult:
    mov   byte ptr [edx+ofSign], 0                               // C.Sign := 0
@Exit:
    pop   edi
    pop   esi
  end;
  if A_Sign < 0 then
  begin
    AddBigint(C, 1, C);
    C.Sign := -1;
    Result := B - Result;
  end;
end;

// ****************************************************************************
// **********         �������������� �������������� ��������         **********
// ****************************************************************************

procedure MulByPowerBase(A: TBigint; N: Byte; var B: TBigint);
var
  ResMSB: Byte;
  I: Byte;
begin
  if A.Sign = 0 then                                        // A = 0, �� B := 0
  begin
    IntToBigint(Cardinal(0), B);
    Exit;
  end;
  if N = 0 then                                             // N = 0, �� B := A
  begin
    CopyBigint(A, B);
    Exit;
  end;
  ResMSB := A.MSB + N;
  if B.Size < ResMSB then SetSizeBigint(B, ResMSB);
  B.MSB := ResMSB;
  for I := A.MSB downto 1 do TDigits(B.PtrDigits^)[I+N] := TDigits(A.PtrDigits^)[I];
  for I := 1 to N do TDigits(B.PtrDigits^)[I] := 0;
  B.Sign := A.Sign;
end;

procedure PowerMod(const X, N, M: TBigint; var Y: TBigint);
var
  LocN, Z: TBigint;
  Temp: TBigint;
  Carry: Cardinal;
begin
  CreateBigint(LocN);
  CreateBigint(Z);
  CreateBigint(Temp);
  CopyBigint(N, LocN);
  CopyBigint(X, Z);
  IntToBigint(Cardinal(1), Y);
  while LocN.Sign <> 0 do
  begin
    Carry := DivBigint(LocN, 2, LocN);
    if Carry = 1 then
    begin
      MulBigint(Y, Z, Y);   // Y := Y*Z
      DivBigint(Y, M, Temp, Y); // Y := Y mod M
    end;
    MulBigint(Z, Z, Z); // Z := Z*Z
    DivBigint(Z, M, Temp, Z); // Z := Z mod M
  end;
  DestroyBigint(LocN);
  DestroyBigint(Z);
  DestroyBigint(Temp);
end;

procedure ExtEuclidGCD(const A, B: TBigint; var G, C, D: TBigint);
var
  U1, U2, U3: TBigint;
  V1, V2, V3: TBigint;
  T1, T2, T3: TBigint;
  Q, R: TBigint;
begin
  CreateBigint(U1);
  CreateBigint(U2);
  CreateBigint(U3);
  CreateBigint(V1);
  CreateBigint(V2);
  CreateBigint(V3);
  CreateBigint(T1);
  CreateBigint(T2);
  CreateBigint(T3);
  CreateBigint(Q);
  CreateBigint(R);
  // ��������� ���������
  IntToBigint(Cardinal(1), U1);
  IntToBigint(Cardinal(0), U2);
  CopyBigint(A, U3);
  IntToBigint(Cardinal(0), V1);
  IntToBigint(Cardinal(1), V2);
  CopyBigint(B, V3);
  while V3.Sign <> 0 do
  begin
    DivBigint(U3, V3, Q, R);
    MulBigint(V1, Q, T1);
    SubBigint(U1, T1, T1);
    MulBigint(V2, Q, T2);
    SubBigint(U2, T2, T2);
    MulBigint(V3, Q, T3);
    SubBigint(U3, T3, T3);
    CopyBigint(V1, U1);
    CopyBigint(V2, U2);
    CopyBigint(V3, U3);
    CopyBigint(T1, V1);
    CopyBigint(T2, V2);
    CopyBigint(T3, V3);
  end;
  CopyBigint(U1, C);
  CopyBigint(U2, D);
  CopyBigint(U3, G);
  DestroyBigint(U1);
  DestroyBigint(U2);
  DestroyBigint(U3);
  DestroyBigint(V1);
  DestroyBigint(V2);
  DestroyBigint(V3);
  DestroyBigint(T1);
  DestroyBigint(T2);
  DestroyBigint(T3);
  DestroyBigint(Q);
  DestroyBigint(R);
end;

procedure EuclidGCD(const A, B: TBigint; var C: TBigint);
var
  LocA, LocB: TBigint;
  Q, R: TBigint;
begin
  CreateBigint(LocA);
  CreateBigint(LocB);
  CreateBigint(Q);
  CreateBigint(R);
  CopyBigint(A, LocA);
  CopyBigint(B, LocB);
  while LocB.Sign <> 0 do
  begin
    DivBigint(LocA, LocB, Q, R);
    CopyBigint(LocB, LocA);
    CopyBigint(R, LocB);
  end;
  CopyBigint(LocA, C);
  DestroyBigint(LocA);
  DestroyBigint(LocB);
  DestroyBigint(Q);
  DestroyBigint(R);
end;

procedure SqrBigint(const A: TBigint; var B: TBigint);
begin
  if B.Size < 2*A.Size then SetSizeBigint(B, 2*A.Size);
  SetZeroBigint(B);
  asm
    push  esi
    push  edi
    push  ebx
    mov   eax, A
    mov   esi, [eax+ofPtrDigits]                   // esi = ����� ������� �����
    movzx ecx, byte ptr [eax+ofMSB]   // ecx = ���������� "����" � ������ �����
    xor   ebx, ebx
@Next:
    mov   eax, [esi+4*ebx]
    mul   eax
    add   eax, [edi+2*4*ebx]
    adc   edx, 0
    mov   [edi+2*4*ebx], eax
    inc   ebx
    loop  @Next
    pop   ebx
    pop   edi
    pop   esi
  end;
end;

// ****************************************************************************
// **********         �������������� �������������� ��������         **********
// ****************************************************************************

procedure LowLevelAdd(const A, B: TBigint; var C: TBigint);
asm                              // eax = Addr(A), edx = Addr(B), ecx = Addr(C)
  push  esi
  push  edi
  push  ebx
  push  ecx                                         // ��������� ��������� �� C
  mov   esi, A+ofPtrDigits                     // ��������� ����� ������� �����
  mov   edi, B+ofPtrDigits                     // ��������� ����� ������� �����
  mov   ebx, C+ofPtrDigits                        // ��������� ����� ����������
  movzx ecx, byte ptr [A+ofMSB]                                  // ecx = A.MSB
  push  ecx                                                  // ��������� A.MSB
  sub   cl, byte ptr [B+ofMSB]                             // ecx = A.MSB-B.MSB
  push  ecx                                            // ��������� A.MSB-B.MSB
  mov   cl, byte ptr [B+ofMSB]                                   // ecx = B.MSB
  clc
  xor   edx, edx
@NextDigit1:
  mov   eax, [esi+edx*4]                    // ��������� ����� �� ������� �����
  adc   eax, [edi+edx*4]    // ������� � ������ ������� ����� � ������ ��������
  mov   [ebx+edx*4], eax                                 // ������� � ���������
  inc   edx
  dec   ecx
{$IFDEF Pentium3}
  jz    @FinalDigit
  mov   eax, [esi+edx*4]                    // ��������� ����� �� ������� �����
  adc   eax, [edi+edx*4]    // ������� � ������ ������� ����� � ������ ��������
  mov   [ebx+edx*4], eax                                 // ������� � ���������
  inc   edx
  dec   ecx
{$ENDIF}  
  jnz   @NextDigit1
@FinalDigit:  
  pop   ecx                                         // ������������ A.MSB-B.MSB
  jcxz  @LastCarry             // A.MSB = B.MSB, �� ��������� ��������� �������
@NextDigit2:
  mov   eax, [esi+edx*4]                    // ��������� ����� �� ������� �����
  adc   eax, 0                                     // ������� � ������ ��������
  mov   [ebx+edx*4], eax                                 // ������� � ���������
  inc   edx
  dec   ecx
  jnz   @NextDigit2
@LastCarry:
  pop   eax                                               // ������������ A.MSB
  jnc   @Exit
  mov   dword ptr [ebx+edx*4], 1
  inc   eax
@Exit:
  pop   ecx                                      // ������������ ��������� �� C
  mov   byte ptr [C+ofMSB], al                              // ���������� C.MSB
  pop   ebx
  pop   edi
  pop   esi
end;

procedure LowLevelSub(const A, B: TBigint; var C: TBigint);
asm                              // eax = Addr(A), edx = Addr(B), ecx = Addr(C)
  push  edi
  push  esi
  push  ebx
  push  ecx                                         // ��������� ��������� �� C
  mov   esi, A+ofPtrDigits                     // ��������� ����� ������� �����
  mov   edi, B+ofPtrDigits                     // ��������� ����� ������� �����
  mov   ebx, C+ofPtrDigits                        // ��������� ����� ����������
  movzx ecx, byte ptr [A+ofMSB]                                  // ecx = A.MSB
  sub   cl, byte ptr [B+ofMSB]                             // ecx = A.MSB-B.MSB
  push  ecx                                            // ��������� A.MSB-B.MSB
  mov   cl, byte ptr [B+ofMSB]                                   // ecx = B.MSB
  clc
  xor   edx, edx
@NextDigit1:
  mov   eax, [esi+edx*4]                    // ��������� ����� �� ������� �����
  sbb   eax, [edi+edx*4]                // ������� � ������ ����� ������� �����
  mov   [ebx+edx*4], eax                                 // ������� � ���������
  inc   edx
  dec   ecx
  jnz   @NextDigit1
  pop   ecx                                         // ������������ A.MSB-B.MSB
  jcxz  @Exit                                                  // A.MSB = B.MSB
@NextDigit2:
  mov   eax, [esi+edx*4]                    // ��������� ����� �� ������� �����
  sbb   eax, 0                             // ������� � ������ ���������� �����
  mov   [ebx+edx*4], eax                                 // ������� � ���������
  inc   edx
  dec   ecx
  jnz   @NextDigit2
@Exit:
  pop   ecx                                      // ������������ ��������� �� C
@NextDigit3:
  dec   edx
  cmp   dword ptr [ebx+edx*4], 0
  jz    @NextDigit3
  inc   edx                            // edx = ����� �������� ���������� �����
  mov   byte ptr [C+ofMSB], dl                              // ���������� C.MSB
  pop   ebx
  pop   esi
  pop   edi
end;

procedure LowLevelMul(const A, B: TBigint; var C: TBigint);
asm                              // eax = Addr(A), edx = Addr(B), ecx = Addr(C)
  push  edi
  push  esi
  push  ebx
  mov   bl, byte ptr (A+ofMSB)
  add   bl, byte ptr (B+ofMSB)
  mov   byte ptr (C+ofMSB), bl  // �������������� ���������� C.MSB �� ���������
  push  ecx                                         // ��������� ��������� �� C
  mov   esi, A+ofPtrDigits                     // ��������� ����� ������� �����
  mov   edi, B+ofPtrDigits                     // ��������� ����� ������� �����
  mov   ebx, C+ofPtrDigits                        // ��������� ����� ����������
  push  ebx                                 // ��������� ��������� �� ���������
  movzx ecx, byte ptr (B+ofMSB)              // ���������� ���� �� ������ �����
@NextDigit2:
  mov   edx, [edi]                          // ��������� ����� �� ������� �����
  add   edi, 4                       // ���������� ��������� �� ��������� �����
  push  ecx                                 // ��������� ������� �������� �����
  push  ebx              // ��������� ��������� �� ������� ������� � ����������
  push  esi                              // ��������� ��������� �� ������ �����
  push  eax                                         // ��������� ��������� �� A
  mov   cl, byte ptr (A+ofMSB)                // ���������� ���� � ������ �����
@NextDigit1:
  push  edx                                               // ��������� ��������
  mov   eax, [esi]                          // ��������� ����� �� ������� �����
  add   esi, 4                       // ���������� ��������� �� ��������� �����
  mul   edx
  add   [ebx], eax                      // ��������� ������� ����� � ����������
  inc   ebx
  inc   ebx
  inc   ebx
  inc   ebx
  adc   [ebx], edx                            // ��������� ������� � ����������
  jnc   @NoCarry         // �������� ���, �� ������� � ��������� �������� �����
  push  ebx
@AddCarry:
  inc   ebx
  inc   ebx
  inc   ebx
  inc   ebx
  adc   dword ptr [ebx], 0                                 // ��������� �������
  jc    @AddCarry                  // ���������� �������, ���� �� �� ����� ����
  pop   ebx
@NoCarry:
  pop   edx                                            // ������������ ��������
  loop  @NextDigit1                // �������� �� ��������� ����� ������� �����
  pop   eax                                          // ������������ �������� A
  pop   esi                           // ������������ ��������� �� ������ �����
  pop   ebx           // ������������ ��������� �� ������� ������� � ����������
  pop   ecx                              // ������������ ������� �������� �����
  add   ebx, 4                         // �������� ������� ������� � ����������
  loop  @NextDigit2                 // ���������� ��������� ����� ������� �����
  pop   edx                              // ������������ ��������� �� ���������
  pop   ecx                                // ������������ �������� ��������� C
  mov   eax, 4
  mul   byte ptr (C+ofMSB)
  sub   eax, 4                                            // eax := 4*(C.MSB-1)
  add   edx, eax
  cmp   dword ptr [edx], 0
  jne   @Exit
  dec   byte ptr (C+ofMSB)             // C.MSB �� ������� ������ �������������
@Exit:
  pop   ebx
  pop   esi
  pop   edi
end;

end.
