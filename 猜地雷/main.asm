INCLUDE Irvine32.inc
.data
startTime DWORD ?																	;�p��
area	DWORD 150 DUP(0)															;�Ʀr�a��
areaS   DWORD 150 DUP('?')															;�r��a��
space   BYTE " ",0																	;��X�Ů�
guessR  DWORD ?																		;�q�C
guessC  DWORD ?																		;�q��
msg000	BYTE "��a�p���ժ� ver. 1.4(�W�[���N�t��)",0
msg001	BYTE "�Ы��UEnter���~�� . . . ",0
msg00	BYTE "�W�h����:",0
msg01	BYTE "���a�p�Ҧ�:��w�@���I�i�T�{���I����a�p�ơA���Y���������a�p�h�ŧi����.",0
msg02	BYTE "��a�p�Ҧ�:��w�@���I�i����I���a�p�A�Y���I�S���a�p�h��ӱ��a�p�Ҧ��A���|���",0
msg03	BYTE "	   �@����a�p�����|�A�Y���|�k0�ŧi���ѡA�Y���a�p�h���|����.",0
msg04	BYTE "P.S. n < 6���a�Ϧ��@�����Ѿ��|�An >= 6���a�Ϧ��⦸���Ѿ��|.",0
msg05	BYTE "���\�P�w:�����Ҧ��a�Ϥ��S���a�p���I�A�Ϊ̩�Ҧ��a�p.",0
msg06	BYTE "���ѧP�w:���a�p���~�����������a�p�A�Ϊ̩�a�p���Ѧh��.",0
msg07	BYTE "�t�~�A�t�η|�����T�{�ݾl�a�p�ƶq�A����ܴݾl����Ѿ��|.",0
msg1    BYTE "�ǳƶ}�l?",0													
msg2    BYTE "1:���a�p,2:��a�p,3:���} �G",0			
msg3    BYTE "row(��J0�i�^��Ҧ����):",0
msg4    BYTE "column(��J0�i�^��Ҧ����):",0
msg5    BYTE "��J�Ʀrn�ӻs�@n*n���a�ϡAn<6�����q���סAn>=6���x������ [2 <= n <= 10] �G",0
msg6    BYTE "��O�ɶ� �G ",0
msg7    BYTE "(s)",0
msg8	BYTE "YOU LOSE................................",0
msg9    BYTE "YOU WIN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",0
msg10	BYTE "�O�_�n�ۭq�a�p�ƶq?? 1:Yes. 0:No.�G",0					
msg11	BYTE "�Q�n���h�֦a�p�N���h�֡G",0
msg12	BYTE "�Ӧh��!�W�V�a�ϩӸ��q!!",0
msg13	BYTE "�ݾl�a�p:",0
msg14	BYTE "����Ѿ��|:",0
msg15	BYTE "���ƿ�J!!������!!",0
msg16   BYTE "�A���@��? 1:�O,0:�_ �G",0
msg17	BYTE "���~��J!!(���ŦX�a�Ͻd��)",0
msg18	BYTE "�a�Ͻd�򤣦X�W�d!!",0
msg19	BYTE "�Цܤֿ�J1�ӤW���a�p!!",0
msgA1	BYTE "��o���N:�@����������O!!(�������:�����ө�a�p�����Ѧ���)",0
msgA2	BYTE "��o���N:�j�ױM�a.(�������:�u�ϥα��a�p�Ҧ��}��)",0
msgA3	BYTE "��o���N:�O�F�ڤF�A�A�ڥ��}�ϬO�a?",0
msgA4	BYTE "��o���N:�X�v����������.(�������:���a�p���Ĥ@���N�z��)",0
msgA31	BYTE "(�������:�u�ϥΩ�a�p�Ҧ��}���A�B�a�p�q�ݤj��@�w����)",0
CountS  DWORD ?																		;���a�pMax����
CountS0	DWORD ?																		;���N����
CountB  DWORD ?																		;��a�pMax����
CountB0	DWORD ?																		;���N����
CountBl	DWORD ?																		;���N�a�p�����
MakeB   DWORD ?																		;�s�@�a�pMax��
check   DWORD ?																		;���\�Υ��ѽT�{
check0	DWORD ?																		;��l��a�p���|
Map     DWORD ?																		;�a�����
NeedB	DWORD ?																		;�ۭq�a�p��
back0	DWORD 0																		;�^��Ҧ����
.code
main PROC
	call GameRules		;�W�h����
	again:				;���s�C���_�I
	call Randomize		;�H���a�ϻs�@
	call MakeMap		;�a�ϻs�@
	call GetMseconds	;�}�l�p��
	mov  startTime,eax		

	mov  eax,Map
	imul eax,Map
	mov  ecx,eax		;�w�p�̦h���զ��Ƭ�n*n��
	sub  eax,CountB	
	mov  CountS,eax		;�w�p�̦h���p����
	mov  CountS0,eax	;���̪쪺�w���ϰ쪬�A
	mov  eax,CountB
	mov  CountB0,eax	;���̪쪺�a�p���A
	
	start:
	call choiceF		;��ܽ�a�p�覡
	mov  eax,back0	
	cmp  eax,1
	jne  cout
	mov  back0,0
	jmp  start
	cout:
	call MakeMapA		;�򧹫�a�ϻs�@
	call Crlf
	cmp  check,0		;����a�p�ΨS���a�p�Ӧh���h����
	je   lose
	cmp  CountB,0		;���\����		
	je   success
	cmp  CountS,0		;���\�
	je   success
	loop start
	jmp	 quit

	lose:				;���ѰT��
	call GameAnswer		
	mov  edx,OFFSET msg8
	call WriteString
	call Crlf
	call AchievementL
	call Crlf
	jmp  quit
	
	success:			;���\�T��
	call GameAnswer	
	mov  edx,OFFSET msg9	
	call WriteString
	call Crlf
	call Achievement
	call Crlf	

	quit:	
	call GameOverMsg
	call ReadDec		;�P�_�O�_����
	cmp  eax,0	
	je   end0
	call Clrscr
	jmp  again
	end0:
	exit
main ENDP

GameRules PROC
	call Crlf
	mov  edx,OFFSET msg000
	call WriteString
	call Crlf		
	call Crlf	
	call Crlf
	mov  edx,OFFSET msg00
	call WriteString
	call Crlf		
	call Crlf
	mov  edx,OFFSET msg01
	call WriteString
	call Crlf
	mov  edx,OFFSET msg02
	call WriteString
	call Crlf
	mov  edx,OFFSET msg03
	call WriteString
	call Crlf
	call Crlf
	mov  edx,OFFSET msg04
	call WriteString
	call Crlf	
	call Crlf
	mov  edx,OFFSET msg05
	call WriteString
	call Crlf	
	mov  edx,OFFSET msg06
	call WriteString
	call Crlf	
	call Crlf
	mov  edx,OFFSET msg07
	call WriteString
	call Crlf	
	call Crlf
	mov  edx,OFFSET msg001
	call WriteString
	call ReadDec
	call Clrscr
	ret
GameRules ENDP

MakeMap PROC
	mov  check,2
	mov  edx,OFFSET msg1	
	call WriteString
	call Crlf
	call Crlf
	Mp0:
	mov  edx,OFFSET msg5
	call WriteString
	call ReadDec			;Ū�J�����n���a��
	cmp  eax,1				;n�Y�L��J�ά�0�P�w�ݭ��s��J
	ja	 Mp1
	mov  edx,OFFSET msg18
	call WriteString
	call Crlf
	call Crlf
	jmp  Mp0
	Mp1:
	cmp  eax,10				;n�j��10�W�L�d��P�w�ݭ��s��J
	jbe  Mp2
	mov  edx,OFFSET msg18
	call WriteString
	call Crlf
	call Crlf
	jmp  Mp0
	Mp2:					;����Ū�J�a��
	mov  Map,eax
	mov  ecx,Map
	add  ecx,2
	imul ecx,ecx
	mov  ebx,0	
	reset:					;�N�Ʀr�P�r��}�C�k0
	mov  area[ebx],0
	mov  areaS[ebx],'?'	
	add  ebx,TYPE area	
	loop reset	
	mov  edx,OFFSET msg10	;�O�_�ۭq�a�p�ƶq
	call WriteString	
	call ReadDec
	cmp  eax,1
	je   design
	mov  eax,Map
	cmp  Map,6				;�Y�a�p�����>=6�A�w�p�a�p�ƥ[��
	jb   Single
	add  eax,Map	
	mov  MakeB,eax
	inc  check	
	Single:					;�Y�a�p�����<6�A�a�p��=���
	mov  MakeB,eax
	mov  eax,MakeB
	mov  CountB,eax			;�w�p�̦h��p����
	mov  CountB0,eax
	jmp  remake
	design:					;�ۭq�a�p��
	call Crlf
	bbb0:					;�ۭq�a�p��<1�L�֡A�P�w���s��J
	mov  edx,OFFSET msg11
	call WriteString
	call ReadDec
	cmp  eax,0
	ja   bbb
	mov  edx,OFFSET msg19
	call WriteString
	call Crlf
	call Crlf
	jmp  bbb0
	bbb:
	mov  MakeB,eax
	mov  eax,MakeB
	mov  CountB,eax		
	mov  ebx,Map
	imul ebx,ebx
	cmp  MakeB,ebx
	jbe  remake				;�a�p�ƶq�j��a�ϫh���s��J
	mov  edx,OFFSET msg12
	call Crlf
	call WriteString
	jmp  design

	remake:					;�Y�a�p�Ƥ����w�p�ƶq�A���ƶ]���j�骽��ɨ�	
	mov  ebx,0
	mov  ecx,Map
	mov  eax,Map
	add  eax,3
	imul eax,TYPE area
	add  ebx,eax
	M1:
		push ecx
		mov  ecx,Map
		M2:
			cmp  area[ebx],9	;�T�{���I�O�_�w���a�p
			je   next0
			mov  eax,Map
			imul eax,eax			
			call RandomRange			
			cmp  eax,0			;�C���I��(1/n*n)�����v���ͦa�p
			je   make
			jmp  next0
			make:
			mov  area[ebx],9	;�a�p�Ʀr�]�w��9
			dec  MakeB		;�p�Ʃ|�ݳ]�m�h�֦a�p
			cmp  MakeB,0		;�Y�]�m�����h�����s��
			je   ready
			next0:
			add  ebx,TYPE area
			loop M2
		pop  ecx
		mov  eax,2
		imul eax,TYPE area
		add  ebx,eax
		loop M1

	cmp MakeB,0
	jne remake
		
	ready:					;���ꦨ�N3�ݦܤ֦b�a�p�q>=����a�Ϲw�p���a�p�q
	mov eax,Map	
	cmp  Map,6			
	jb   Single1
	add  eax,Map	
	mov  CountBl,eax
	jmp  ready1
	Single1:
	mov CountBl,eax

	ready1:
	mov eax,check
	mov check0,eax
	pop  ecx
	call ICanSeeTheMap		;�}�ϼҦ�
	call Crlf
	call TheMap
	call Crlf
	ret
MakeMap ENDP

choiceF  PROC	;�Ҧ���ܩ����}
	push ecx
	choice0:
	mov  edx,OFFSET msg2	
	call WriteString
	call ReadDec	
	cmp  eax,2	;��a�p
	je   guess
	cmp  eax,1	;���a�p
	je   sweep
	cmp  eax,3	;���}
	je   Q	
	jmp  choice0;�L��J�Ϊ̿�J��L�r��P�w�ݭ��s��J		

	guess:
		call guessF
		jmp  next

	sweep:
		call sweepF
		jmp  next	

	Q:
		mov check,0
		jmp next
	next:
		pop ecx
	ret
choiceF  ENDP

sweepF   PROC
	C1:
	call EnterRowCol		
	mov  eax,back0			;�T�{�O�_�h�^�Ҧ����
	cmp  eax,1
	je   QC0
	call ReEnter
	cmp  areaS[ebx],'?'		;�P�_�O�_�����ƿ�J�ۦP�y�СA�Y���ƫh�ݭ��s��J�s���y��
	je   C0
	mov  edx,OFFSET msg15
	call WriteString
	call Crlf
	call Crlf
	jmp	 C1
	C0:
	call Clrscr
	cmp  area[ebx],9		;�P�_�O�_�����a�p
	jne  continue			;�S���i�~��A�����a�p�h�P�w����
	mov  areaS[ebx],'*'
	mov  ebx,0
	mov  check,0

	continue:
		call sweepF2		;������a�p�������p		
		call BombsSum		;�Ӯy�Ъ���a�p�ƶq
	QC0:
	
	ret
sweepF   ENDP

guessF    PROC
	C11:					;�P�_�P���a�p�Ҧ�
	call EnterRowCol
	mov  eax,back0			;�T�{�O�_�h�^�Ҧ����
	cmp  eax,1
	je   QC1
	call ReEnter
	cmp  areaS[ebx],'?'
	je   C10
	mov  edx,OFFSET msg15
	call WriteString
	call Crlf
	call Crlf
	jmp	 C11
	C10:
	call Clrscr
	cmp  area[ebx],9	;�M���a�p�Ҧ��ۤϡA�Y��a�p�h�i�~��A�_�h��֩�a�p���Ѿ��|
	je   continue2
	dec  check			;����a�p��m�h���|����

	call sweepF2		;������a�p�������p
	call BombsSum		;�Ӯy�Ъ���a�p�ƶq	
	mov  ebx,0	
	jmp  countinue20
	QC1:
	continue2:
		dec  CountB		;����ݾl�a�p�ƶq	
		mov  areaS[ebx],'*'
		mov  ebx,0		
	countinue20:
	ret
guessF    ENDP

MakeMapA PROC			;�T�{��e�w���a�p�ϱ��p
	push ecx
	call ICanSeeTheMap	;�}�ϼҦ�
	call TheMap
	call Crlf
	mov edx,OFFSET msg13
	call WriteString
	mov eax,CountB
	call WriteDec
	call Crlf
	mov edx,OFFSET msg14
	call WriteString
	mov eax,check
	cmp eax,0
	je  lo
	dec eax
	lo:
	call WriteDec
	call Crlf
	pop ecx		
	ret
MakeMapA ENDP

GameAnswer PROC			;�a�p�����ѵ�
	mov  ebx,0
	mov  ecx,Map
	mov  eax,Map
	add  eax,3
	imul eax,TYPE area
	add  ebx,eax	
	B1:					;��X�a�ϤW�Ʀr��9���I(�Y�a�p�I)�A�N����m�ƻs��r��a�ϼаO��'*'
		push ecx
		mov  ecx,Map
		B2:		   			
			cmp  area[ebx],9
			jne	 bombs
			mov  areaS[ebx],'*'
			bombs:
			add  ebx,TYPE area
			loop B2
		call Crlf
		pop  ecx
		mov  eax,2
		imul eax,TYPE areaS
		add  ebx,eax
		loop B1
	call TheMap
	call Crlf
	ret
GameAnswer ENDP

GameOverMsg PROC			;�C�����������T��
	call GetMseconds
	sub  eax,startTime
	mov  edx,0
	mov  ebx,1000			;�@���⦨��
	div  ebx
	mov  edx,OFFSET msg6	;�L�X�C���ɶ�
	call WriteString		
	call WriteDec
	mov  edx,OFFSET msg7
	call WriteString
	call Crlf
	call Crlf
	mov  edx,OFFSET msg16
	call WriteString
	ret
GameOverMsg ENDP

ICanSeeTheMap PROC		;�}�ϼҦ�
	mov esi,OFFSET area		
	mov ecx,Map
	mov eax,Map
	add eax,3
	imul eax,TYPE area
	add esi,eax
	T1:
		push ecx
		mov  ecx,Map
		T2:
			mov eax,[esi]
			call WriteDec
			mov edx,OFFSET space
			call WriteString
			add esi,TYPE area
			loop T2
		call Crlf
		pop ecx
		mov  eax,2		
		imul eax,TYPE area
		add  esi,eax
		loop T1
	ret
ICanSeeTheMap ENDP

TheMap PROC		;�ثe�w���a�Ϥ������p
	call Crlf
	mov  esi,OFFSET areaS	
	mov  ecx,Map
	mov  eax,Map
	add  eax,3
	imul eax,TYPE areaS
	add  esi,eax
	L01:
		push ecx		
		mov  ecx,Map
		L02:		   			
			mov  edx,esi
			call WriteString
			mov  edx,OFFSET space
			call WriteString
			add  esi,TYPE areaS			
			loop L02
		call Crlf
		pop  ecx
		mov  eax,2		
		imul eax,TYPE areaS
		add  esi,eax
		loop L01
	ret
TheMap ENDP

EnterRowCol PROC	;��C��J
	C1:
	mov  edx,OFFSET msg3	;��J�C
	call WriteString
	call ReadDec
	cmp  eax,0				;�^��Ҧ����
	je   back
	cmp  eax,Map			;�Y��J���X�d��A�P�w�ݭ��s��J
	jbe  C1r	
	C1r0:
	mov  edx,OFFSET msg17
	call WriteString
	call Crlf
	jmp  C1
	C1r:					;�L��J�ο�J��0�A�P�w�ݭ��s��J
	cmp  eax,0
	jz   C1r0
	mov  guessR,eax			;Ū�J�C
	C1cc:
	mov  edx,OFFSET msg4	;��J��
	call WriteString
	call ReadDec
	cmp  eax,0				;�^��Ҧ����
	je	 back
	cmp  eax,Map
	jbe  C1c				;�Y��J���X�d��A�P�w�ݭ��s��J
	C1c0:	
	mov  edx,OFFSET msg17
	call WriteString
	call Crlf
	jmp  C1cc
	C1c:					;�L��J�ο�J��0�A�P�w�ݭ��s��J
	cmp  eax,0
	jz   C1c0
	mov  guessC,eax			;Ū�J��
	jmp  nextE

	back:
		mov back0,1		
	nextE:

	ret
EnterRowCol ENDP

ReEnter PROC	;���ƿ�J�P�w
	mov  ebx,0				;�}�C��m�p��
	mov  eax,Map			
	add  eax,2
	imul eax,guessR
	add  eax,guessC
	imul eax,TYPE area
	add  ebx,eax	
	ret
ReEnter ENDP

sweepF2 PROC		;���p�T�{	
	dec  CountS			;����i�����w���ϰ�ƶq
	mov  eax,ebx
	mov  edx,0
	mov  ecx,Map
	add  ecx,3	
	imul ecx,TYPE area
	sub  eax,ecx
	mov  esi,OFFSET area
	add  esi,eax
	mov  ecx,3			;�P�_�ҿ�y�ЩP��8�Ӯy��
	N1:
		push ecx
		mov  ecx,3
		N2:
			mov  eax,[esi]
			cmp  eax,9	;�P��C�h�@���a�p�A���y����ܪ��Ʀr�q0�}�l���W
			jne  N2C
			inc  edx
			N2C:
			add  esi,TYPE area;��m�Y�����ܪ��y�Ыh���L�P�w
			cmp  esi,ebx
			jne  N2Q
			add  esi,TYPE area
			dec  ecx
			N2Q:
			loop N2
		pop ecx
		mov  eax,Map
		dec  eax
		imul eax,TYPE area
		add  esi,eax
		loop N1	
	ret
sweepF2 ENDP

BombsSum PROC	;����a�p�ƶq
	mov eax,edx	
	cmp eax,0
	je  a0
	cmp eax,1
	je  a1
	cmp eax,2
	je  a2
	cmp eax,3
	je  a3
	cmp eax,4
	je  a4
	cmp eax,5
	je  a5
	cmp eax,6
	je  a6
	cmp eax,7
	je  a7
	cmp eax,8
	je  a8
	
	a8:mov areaS[ebx],'8'	
	jmp Q1
	a7:mov areaS[ebx],'7'
	jmp Q1
	a6:mov areaS[ebx],'6'
	jmp Q1
	a5:mov areaS[ebx],'5'
	jmp Q1
	a4:mov areaS[ebx],'4'
	jmp Q1
	a3:mov areaS[ebx],'3'
	jmp Q1
	a2:mov areaS[ebx],'2'
	jmp Q1
	a1:mov areaS[ebx],'1'
	jmp Q1
	a0:mov areaS[ebx],'0'
	Q1:
	ret
BombsSum ENDP

AchievementL PROC	
	mov eax,CountS0
	dec eax
	cmp eax,CountS
	je  SoSad
	jmp SL
	SoSad:
		mov edx,OFFSET msgA4
		call WriteString		
	SL:
	ret
AchievementL ENDP
	
Achievement PROC		;���N�t��
	mov eax,CountB0
	cmp eax,CountB
	je  Ac2c
	mov eax,CountS0
	cmp eax,CountS
	je  Ac3c1	
	mov eax,check
	cmp eax,check0
	je  Ac1
	jmp nextA
	Ac1:
		mov  edx,OFFSET msgA1
		call WriteString
		jmp  nextA
	Ac2c:
		mov eax,check
		cmp eax,check0
		je  Ac2
		jmp nextA
	Ac2:
		mov  edx,OFFSET msgA2
		call WriteString
		jmp  nextA
	Ac3c1:
		mov eax,check
		cmp eax,check0
		je  Ac3c2
		jmp nextA
	Ac3c2:
		mov  eax,CountB0
		cmp  eax,CountBl
		jae  Ac3
		jmp  nextA
	Ac3:
		mov  edx,OFFSET msgA3
		call WriteString
		mov  edx,OFFSET msgA31
		call Crlf
		call WriteString
	nextA:	
	ret
Achievement ENDP


END main