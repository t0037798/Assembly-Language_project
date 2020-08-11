INCLUDE Irvine32.inc
.data
startTime DWORD ?																	;計時
area	DWORD 150 DUP(0)															;數字地圖
areaS   DWORD 150 DUP('?')															;字串地圖
space   BYTE " ",0																	;輸出空格
guessR  DWORD ?																		;猜列
guessC  DWORD ?																		;猜行
msg000	BYTE "踩地雷測試版 ver. 1.4(增加成就系統)",0
msg001	BYTE "請按下Enter鍵繼續 . . . ",0
msg00	BYTE "規則說明:",0
msg01	BYTE "掃地雷模式:選定一個點可確認此點附近地雷數，但若直接掃中地雷則宣告失敗.",0
msg02	BYTE "拆地雷模式:選定一個點可拆除此點的地雷，若此點沒有地雷則比照掃地雷模式，但會減少",0
msg03	BYTE "	   一次拆地雷的機會，若機會歸0宣告失敗，若拆到地雷則機會不變.",0
msg04	BYTE "P.S. n < 6的地圖有一次失敗機會，n >= 6的地圖有兩次失敗機會.",0
msg05	BYTE "成功判定:掃完所有地圖中沒有地雷的點，或者拆完所有地雷.",0
msg06	BYTE "失敗判定:掃地雷的途中直接掃中地雷，或者拆地雷失敗多次.",0
msg07	BYTE "另外，系統會幫忙確認殘餘地雷數量，並顯示殘餘拆除失敗機會.",0
msg1    BYTE "準備開始?",0													
msg2    BYTE "1:掃地雷,2:拆地雷,3:離開 ：",0			
msg3    BYTE "row(輸入0可回到模式選擇):",0
msg4    BYTE "column(輸入0可回到模式選擇):",0
msg5    BYTE "輸入數字n來製作n*n的地圖，n<6為普通難度，n>=6為困難難度 [2 <= n <= 10] ：",0
msg6    BYTE "花費時間 ： ",0
msg7    BYTE "(s)",0
msg8	BYTE "YOU LOSE................................",0
msg9    BYTE "YOU WIN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",0
msg10	BYTE "是否要自訂地雷數量?? 1:Yes. 0:No.：",0					
msg11	BYTE "想要有多少地雷就有多少：",0
msg12	BYTE "太多啦!超越地圖承載量!!",0
msg13	BYTE "殘餘地雷:",0
msg14	BYTE "拆除失敗機會:",0
msg15	BYTE "重複輸入!!不能投機!!",0
msg16   BYTE "再玩一次? 1:是,0:否 ：",0
msg17	BYTE "錯誤輸入!!(不符合地圖範圍)",0
msg18	BYTE "地圖範圍不合規範!!",0
msg19	BYTE "請至少輸入1個上的地雷!!",0
msgA1	BYTE "獲得成就:一次都不能浪費!!(解鎖條件:不消耗拆地雷的失敗次數)",0
msgA2	BYTE "獲得成就:迴避專家.(解鎖條件:只使用掃地雷模式破完)",0
msgA3	BYTE "獲得成就:別騙我了，你根本開圖是吧?",0
msgA4	BYTE "獲得成就:出師未捷身先死.(解鎖條件:掃地雷掃第一次就爆炸)",0
msgA31	BYTE "(解鎖條件:只使用拆地雷模式破完，且地雷量需大於一定限制)",0
CountS  DWORD ?																		;掃地雷Max次數
CountS0	DWORD ?																		;成就比對用
CountB  DWORD ?																		;拆地雷Max次數
CountB0	DWORD ?																		;成就比對用
CountBl	DWORD ?																		;成就地雷限制數
MakeB   DWORD ?																		;製作地雷Max數
check   DWORD ?																		;成功或失敗確認
check0	DWORD ?																		;原始拆地雷機會
Map     DWORD ?																		;地圖邊長
NeedB	DWORD ?																		;自訂地雷數
back0	DWORD 0																		;回到模式選擇
.code
main PROC
	call GameRules		;規則說明
	again:				;重新遊玩起點
	call Randomize		;隨機地圖製作
	call MakeMap		;地圖製作
	call GetMseconds	;開始計時
	mov  startTime,eax		

	mov  eax,Map
	imul eax,Map
	mov  ecx,eax		;預計最多嘗試次數為n*n次
	sub  eax,CountB	
	mov  CountS,eax		;預計最多掃雷次數
	mov  CountS0,eax	;比對最初的安全區域狀態
	mov  eax,CountB
	mov  CountB0,eax	;比對最初的地雷狀態
	
	start:
	call choiceF		;選擇踩地雷方式
	mov  eax,back0	
	cmp  eax,1
	jne  cout
	mov  back0,0
	jmp  start
	cout:
	call MakeMapA		;踩完後地圖製作
	call Crlf
	cmp  check,0		;掃到地雷或沒拆到地雷太多次則失敗
	je   lose
	cmp  CountB,0		;成功掃完		
	je   success
	cmp  CountS,0		;成功拆完
	je   success
	loop start
	jmp	 quit

	lose:				;失敗訊息
	call GameAnswer		
	mov  edx,OFFSET msg8
	call WriteString
	call Crlf
	call AchievementL
	call Crlf
	jmp  quit
	
	success:			;成功訊息
	call GameAnswer	
	mov  edx,OFFSET msg9	
	call WriteString
	call Crlf
	call Achievement
	call Crlf	

	quit:	
	call GameOverMsg
	call ReadDec		;判斷是否重玩
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
	call ReadDec			;讀入邊長為n的地圖
	cmp  eax,1				;n若無輸入或為0判定需重新輸入
	ja	 Mp1
	mov  edx,OFFSET msg18
	call WriteString
	call Crlf
	call Crlf
	jmp  Mp0
	Mp1:
	cmp  eax,10				;n大於10超過範圍判定需重新輸入
	jbe  Mp2
	mov  edx,OFFSET msg18
	call WriteString
	call Crlf
	call Crlf
	jmp  Mp0
	Mp2:					;正式讀入地圖
	mov  Map,eax
	mov  ecx,Map
	add  ecx,2
	imul ecx,ecx
	mov  ebx,0	
	reset:					;將數字與字串陣列歸0
	mov  area[ebx],0
	mov  areaS[ebx],'?'	
	add  ebx,TYPE area	
	loop reset	
	mov  edx,OFFSET msg10	;是否自訂地雷數量
	call WriteString	
	call ReadDec
	cmp  eax,1
	je   design
	mov  eax,Map
	cmp  Map,6				;若地雷圖邊長>=6，預計地雷數加倍
	jb   Single
	add  eax,Map	
	mov  MakeB,eax
	inc  check	
	Single:					;若地雷圖邊長<6，地雷數=邊長
	mov  MakeB,eax
	mov  eax,MakeB
	mov  CountB,eax			;預計最多拆雷次數
	mov  CountB0,eax
	jmp  remake
	design:					;自訂地雷數
	call Crlf
	bbb0:					;自訂地雷數<1過少，判定重新輸入
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
	jbe  remake				;地雷數量大於地圖則重新輸入
	mov  edx,OFFSET msg12
	call Crlf
	call WriteString
	jmp  design

	remake:					;若地雷數不足預計數量，重複跑此迴圈直到補足	
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
			cmp  area[ebx],9	;確認此點是否已有地雷
			je   next0
			mov  eax,Map
			imul eax,eax			
			call RandomRange			
			cmp  eax,0			;每個點有(1/n*n)的機率產生地雷
			je   make
			jmp  next0
			make:
			mov  area[ebx],9	;地雷數字設定為9
			dec  MakeB		;計數尚需設置多少地雷
			cmp  MakeB,0		;若設置完畢則跳離製圖
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
		
	ready:					;解鎖成就3需至少在地雷量>=原先地圖預計的地雷量
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
	call ICanSeeTheMap		;開圖模式
	call Crlf
	call TheMap
	call Crlf
	ret
MakeMap ENDP

choiceF  PROC	;模式選擇或離開
	push ecx
	choice0:
	mov  edx,OFFSET msg2	
	call WriteString
	call ReadDec	
	cmp  eax,2	;拆地雷
	je   guess
	cmp  eax,1	;掃地雷
	je   sweep
	cmp  eax,3	;離開
	je   Q	
	jmp  choice0;無輸入或者輸入其他字串判定需重新輸入		

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
	mov  eax,back0			;確認是否退回模式選擇
	cmp  eax,1
	je   QC0
	call ReEnter
	cmp  areaS[ebx],'?'		;判斷是否有重複輸入相同座標，若重複則需重新輸入新的座標
	je   C0
	mov  edx,OFFSET msg15
	call WriteString
	call Crlf
	call Crlf
	jmp	 C1
	C0:
	call Clrscr
	cmp  area[ebx],9		;判斷是否掃中地雷
	jne  continue			;沒有可繼續，掃中地雷則判定失敗
	mov  areaS[ebx],'*'
	mov  ebx,0
	mov  check,0

	continue:
		call sweepF2		;掃附近地雷分布情況		
		call BombsSum		;該座標附近地雷數量
	QC0:
	
	ret
sweepF   ENDP

guessF    PROC
	C11:					;判斷同掃地雷模式
	call EnterRowCol
	mov  eax,back0			;確認是否退回模式選擇
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
	cmp  area[ebx],9	;和掃地雷模式相反，若拆中地雷則可繼續，否則減少拆地雷失敗機會
	je   continue2
	dec  check			;拆錯地雷位置則機會遞減

	call sweepF2		;掃附近地雷分布情況
	call BombsSum		;該座標附近地雷數量	
	mov  ebx,0	
	jmp  countinue20
	QC1:
	continue2:
		dec  CountB		;遞減殘餘地雷數量	
		mov  areaS[ebx],'*'
		mov  ebx,0		
	countinue20:
	ret
guessF    ENDP

MakeMapA PROC			;確認當前已知地雷圖情況
	push ecx
	call ICanSeeTheMap	;開圖模式
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

GameAnswer PROC			;地雷分布解答
	mov  ebx,0
	mov  ecx,Map
	mov  eax,Map
	add  eax,3
	imul eax,TYPE area
	add  ebx,eax	
	B1:					;找出地圖上數字為9的點(即地雷點)，將此位置複製到字串地圖標記為'*'
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

GameOverMsg PROC			;遊戲結束相關訊息
	call GetMseconds
	sub  eax,startTime
	mov  edx,0
	mov  ebx,1000			;毫秒換算成秒
	div  ebx
	mov  edx,OFFSET msg6	;印出遊玩時間
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

ICanSeeTheMap PROC		;開圖模式
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

TheMap PROC		;目前已知地圖分布情況
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

EnterRowCol PROC	;行列輸入
	C1:
	mov  edx,OFFSET msg3	;輸入列
	call WriteString
	call ReadDec
	cmp  eax,0				;回到模式選擇
	je   back
	cmp  eax,Map			;若輸入不合範圍，判定需重新輸入
	jbe  C1r	
	C1r0:
	mov  edx,OFFSET msg17
	call WriteString
	call Crlf
	jmp  C1
	C1r:					;無輸入或輸入為0，判定需重新輸入
	cmp  eax,0
	jz   C1r0
	mov  guessR,eax			;讀入列
	C1cc:
	mov  edx,OFFSET msg4	;輸入行
	call WriteString
	call ReadDec
	cmp  eax,0				;回到模式選擇
	je	 back
	cmp  eax,Map
	jbe  C1c				;若輸入不合範圍，判定需重新輸入
	C1c0:	
	mov  edx,OFFSET msg17
	call WriteString
	call Crlf
	jmp  C1cc
	C1c:					;無輸入或輸入為0，判定需重新輸入
	cmp  eax,0
	jz   C1c0
	mov  guessC,eax			;讀入行
	jmp  nextE

	back:
		mov back0,1		
	nextE:

	ret
EnterRowCol ENDP

ReEnter PROC	;重複輸入判定
	mov  ebx,0				;陣列位置計數
	mov  eax,Map			
	add  eax,2
	imul eax,guessR
	add  eax,guessC
	imul eax,TYPE area
	add  ebx,eax	
	ret
ReEnter ENDP

sweepF2 PROC		;掃雷確認	
	dec  CountS			;遞減可掃的安全區域數量
	mov  eax,ebx
	mov  edx,0
	mov  ecx,Map
	add  ecx,3	
	imul ecx,TYPE area
	sub  eax,ecx
	mov  esi,OFFSET area
	add  esi,eax
	mov  ecx,3			;判斷所選座標周圍的8個座標
	N1:
		push ecx
		mov  ecx,3
		N2:
			mov  eax,[esi]
			cmp  eax,9	;周圍每多一顆地雷，此座標顯示的數字從0開始遞增
			jne  N2C
			inc  edx
			N2C:
			add  esi,TYPE area;位置若走到選擇的座標則跳過判定
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

BombsSum PROC	;附近地雷數量
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
	
Achievement PROC		;成就系統
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