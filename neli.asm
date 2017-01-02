global _main

extern _scanf
extern _system
extern _getchar
extern _puts
extern _printf
extern _memset

; Defineerime mõned sõned
;---------------------------------------------

SECTION .data
		nupp db "XO", 10, 0
		viik db "M2ng l6ppes viigiga!",10,0
		voitja db "M2ngija %d (%c) v6itis!", 10, 0
		jatka db "Vajuta suvalist nuppu, et l6petada...", 10, 0
		cls db "cls", 0
		pealkiri db "J2rjesta neli!", 10, 0
		kriipsud db "-----------------------------",0
		lahter   db "| %c ", 0
		debug db "debug : %d ",10,0
		viimane_lahter db "| ", 0
		numbrid db "  1   2   3   4   5   6   7", 10, 0
		valik db "M2ngija %d (%c):",10,"Vali veerg, kuhu k2ia:", 0
		sisend db "%d",0
		veerg_puudub db "Sellist veergu ei ole! Proovige uuesti.",10, "Vali veerg, kuhu k2ia: ", 0
		tais db "See veerg on t2is, palun vali uus veerg!", 10

		
;---------------------------------------------
SECTION .text
; int main(int argc, char *argv[]) {
_main:

%define nupud 	dword [esp+68]
%define voit  	dword [esp+72]
%define kord 	dword [esp+76]


        push    ebp										; loome stack frame
        mov     ebp, esp
        sub     esp, 100
		
		;-----------------------
		
        mov     nupud, nupp                   			; loeme mängija nupud mällu, const char *nupud = "XO";
        mov     voit, 0									; int v6it = 0; kontrolliks, kas mäng on juba võidetud
        mov     dword [esp+8], 42                       ; väärtustame väljaku alguses tühikutega
        mov     dword [esp+4], 32                       ; väljaku algväärtus on ascii koodis 32 = " " ehk tühik 
        lea     eax,  [esp+26]
        mov     dword [esp], eax
        call    _memset                                 ; memset(v2ljak, ' ', 42); 	
        mov     kord, 0                    				; int kord = 0; kui paaritu arv, siis mängija 1, kui paaris siis mängija 2
        jmp     .main_tsuklipais                        ; hakkame tsüklit täitma

.main_tsuklikeha: ; mängime senikaua, kuni väljak on täis, või kuni keegi on võitnud
		lea     eax, [esp+26]
        mov     dword [esp], eax
        call    _prindiValjak                           ; igal käigul prindime väljaku uuesti.
        mov     eax, kord                     			; leiame kumma mängija kord on, selleks teeme kord%2
		mov 	ecx, 2
		div		ecx
        mov     eax, nupud
        mov     dword [esp+8], eax 						; kolmas argument - nupud
        mov     dword [esp+4], edx						; teine argument - mangija
        lea     eax, [esp+26]
        mov     dword [esp], eax                        ; esimene argument - väljak
        call    _teeKaik                                ; kutsume teeKaik(char *v2ljak, int mangija, const char *nupud)
        lea     eax, [esp+26]							
        mov     dword [esp], eax
        call    _kontrolli                              ; kontrolli(v2ljak)
        mov     voit, eax								; v6it = kontrolli(v2ljak);
        add     kord, 1									; suurendame tsükli indeksit (i++)

.main_tsuklipais:  ; kontrollime kas kord < 42 && !v6it
		cmp     kord, 41                     			; vaatame, ega me üle 41 käigu pole teinud
        jg      .main_tsukkellabi                       ; kui kord on suurem, siis on tsukkel labi ja väljume sellest
        cmp     voit, 0                     			; kui ei ole suurem, peame kontrollima, kas voit on 1 või 0
        jz      .main_tsuklikeha                        ; kui võit=false ehk võit=0, siis lähme keha täitma
		jmp 	.main_tsukkellabi

		
.main_tsukkellabi: ; kui for tsükkel on läbitud
		lea     eax, [esp+26]                           ; kui võitja on selgunud tuleb lõppseis väljastada
        mov     dword [esp], eax
        call    _prindiValjak
        cmp     voit, 0                     			; kontrollime, kas mäng lõppes viigiga (!v6it)
        jnz     _prindi_voitja                          ; mängija võitis
        mov     dword [esp], viik                       ; mäng lõppes viigiga
        call    _printf                                 ; kuvame teate
        jmp     _lopp                                   ; hakkame programmi lõpetama

_prindi_voitja: ; kui võitja on selgunud, kuvame vastava teate
%define nupud 	dword [esp+68]
%define voit  	dword [esp+72]
%define kord 	dword [esp+76]

		sub     kord, 1									; --kord, kuna pärast viimast käiku suurendatakse (kord++),
		mov     eax, kord								; siis on meil õige võitja saamiseks ühe võrra lahutada
		mov 	ecx, 2									; --kord % 2
		div		ecx
        mov     eax, nupud
        add     eax, edx
        movzx   eax, byte [eax]	
        movsx   ecx, al									; nupud[--kord % 2]
        mov     eax, kord								; kord % 2+1
        mov 	ebx, 2
		div		ebx
        mov     eax, edx
        add     eax, 1
        mov     dword [esp+8], ecx 						; printf("M2ngija %d (%c) v6itis!", kord % 2+1, nupud[--kord % 2]);
        mov     dword [esp+4], eax
        mov     dword [esp], voitja
        call    _printf									; kuvame teate kumb võitis
		
_lopp:  mov     dword [esp], jatka                      ; prindime sõnumi, et mäng on lõppenud
        call    _puts
        call    _getchar
        mov     eax, 0                                  ; lõpetame programmi tegevuse
        leave											; hävitame stack frame
        ret												; tagastame

; prindime mänguväljaku 

_prindiValjak: ; void prindiValjak(char *v2ljak)

%define rida  	dword [ebp-12]
%define veerg  	dword [ebp-16]

        push    ebp
        mov     ebp, esp
        sub     esp, 100
        mov     dword [esp], cls							
        call    _system                                 ; puhastame konsooli - system("cls"); 
        mov     dword [esp], pealkiri
        call    _puts                                   ; väljastame mängu pealkirja
        mov     dword [esp], kriipsud
        call    _puts                                   ; prindime eraldavad kriipsud "------------------"
		;  for (int rida = 0; rida < 6; rida++) {
        ;     for (int veerg = 0; veerg < 7; veerg++) {
		mov     rida, 0                       			; rida = 0
        jmp     .print_valimine							; prindime ridahaaval

	
.sisemine_lahter: ; prindime üksiku lahtri; printf("| %c ", v2ljak[7 * rida + veerg]); 
		mov     edx, rida                  				; rida
        mov     eax, 7
        mul		edx
        mov     edx, eax	
        add     eax, veerg								; veerg
        add     eax, dword[ebp+8]
        movzx   eax, byte [eax]
        mov     dword [esp+4], eax                      ; v2ljak[7 * rida + veerg]
        mov     dword [esp], lahter                     ; "| %c ", vaatame kas tuleb panna "0", "X" või " "
        call    _printf
        add     veerg, 1                       			; veerg ++

.print_sisemine:  
		cmp     veerg, 6                       			; veerg <= 6
        jle     .sisemine_lahter
        mov     dword [esp], viimane_lahter             ; viimane lahter tuleb väljaspool tsüklit teha
        call    _puts
        mov     dword [esp], kriipsud                   ; väljastame eraldavad kriipsud
        call    _puts
        add     rida, 1                      			; rida++

.print_valimine: ;kõikide ridade läbi käimine
		cmp     rida, 5                    				; rida <= 5
        jle     .print_sisemine_start                   ; kui on, siis lähme sisemisse tsüklisse
        mov     dword [esp], numbrid
        call    _puts									; prindime veerunumbrid
        leave
        ret 
		
.print_sisemine_start:  
		mov     veerg, 0                       			; veerg = 0
        jmp     .print_sisemine                         ; hakkame sisemist tsüklit täitma


_teeKaik: ; teeKaik(char *v2ljak, int mangija, const char *nupud)

%define veerg 	dword [ebp-20]
%define indeks 	dword [ebp-16]
%define rida 	dword [ebp-12]
%define v2ljak 	dword [ebp+8]
%define mangija dword [ebp+12]
%define nupud 	dword [ebp+16]
		;    // väljastame kasutajale juhendi, mida ta tegema peaks
        push    ebp
        mov     ebp, esp
        sub     esp, 100
        mov     veerg, 0                     			; veerg = 0;
        mov     edx, mangija							; mangija
        mov     eax, nupud
	    add     eax, edx
        movzx   eax, byte [eax]							; nupud[mangija]
        mov     edx, mangija                   			; mangija
        add     edx, 1
        mov     dword [esp+8], eax
        mov     dword [esp+4], edx 
        mov     dword [esp], valik
        call    _printf                                 ; prindime kumma mängija kord on 
		
		
.tsukkel: ;for (;;) lõpmatu tsükkel, ootame, kuni kasutaja sisestab veeru, mis on olemas
		lea     eax, [ebp-20]                           ; veerg
        mov     dword [esp+4], eax                      ; &veerg
        mov     dword [esp], sisend                     ; "%d" 
        call    _scanf                                  ; scanf("%d", &veerg)
        jz      .dialoog                                ; kui kasutaja ei sisestanud midagi, küsime uuesti
        mov     eax, veerg
        cmp     eax, 0									; veerg, 0
        jle     .dialoog
        mov     eax, veerg
        cmp     eax, 7
        jle     .sobiv_sisend                           ; veerg < 7 
	
.dialoog: ; ootame kuni kasutaja teeb leegaalse käigu. Küsime niikaua kuni ta midagi lubatavat sisestab
		call    _getchar                                ; getchar()
        cmp     eax, 10
        jnz     .dialoog                                ; reavahetuse korral ei tee midagi
        mov     dword [esp], veerg_puudub               ; veerg asub piiridest väljas, küsime uuesti
        call    _printf                                 ; väljastame veateate
        jmp     .tsukkel                                ; alustame otsast pihta


.sobiv_sisend:
        call    _getchar                                ; getchar()
        mov     eax, veerg						        ; kasutaja sisestab 1-7, kuid arvuti jaoks on vaja 0-6
        sub     eax, 1
        mov     veerg, eax           			        ; veerg--
        mov     rida, 5                			        ; rida = 5
        jmp     .tsukkel2

.tsukkel2: ;vaatame, kas kasutaja sisestatud veerule on võimalik nuppu juurde lisada
		mov     edx, rida			                    ; edx = rida    
		mov     eax, 7
        mul		edx										; rida *7
        mov     edx, eax
        mov     eax, veerg						        ; eax = veerg
        add     eax, edx
        mov     indeks, eax								; indeks = 7 * rida + veerg
        mov     edx, indeks					
        mov     eax, v2ljak
        add     eax, edx
        movzx   eax, byte [eax]							; v2ljak[indeks]
        cmp     eax, 32									; v2ljak[indeks] == ' '
        jnz     .hoivatud                               ; v2ljak[indeks] == ' ' = false
        mov     edx, indeks
        mov     eax, v2ljak
        add     edx, eax
        mov     ecx, mangija
        mov     eax, dword nupud
        add     eax, ecx
        movzx   eax, byte [eax]
        mov     byte [edx], al							;v2ljak[indeks] = nupud[mangija];
        mov     eax, 1
        jmp     .teeKaik_lopp							; return 1;

.hoivatud:; valitud veerg ei ole vaba
		sub     rida, 1              					; rida--         
		cmp     rida, 0                      			; rida >= 0
        jns     .tsukkel2                               ; rida >= 0 = true
        mov     eax, v2ljak
        mov     dword [esp], eax						; v2ljak
        call    _prindiValjak                           ; prindiValjak(v2ljak);
        mov     dword [esp], tais
        call    _printf                                 ; kuvame teate, et see veerg on täis
        mov     eax, nupud
        mov     dword [esp+8], eax                      ; nupud
        mov     eax, mangija
        mov     dword [esp+4], eax                      ; mangija
        mov     eax, v2ljak
        mov     dword [esp], eax                        ; v2ljak
        call    _teeKaik                                ; teeKaik(char *v2ljak, int mangija, const char *nupud)

.teeKaik_lopp: ; lõpetame funktsiooni töö 
		leave
        ret

_kontrolli: ; int kontrolli(char *v2ljak)
%define v2ljak 	dword [ebp+8]

        push    ebp
        mov     ebp, esp
        sub     esp, 100
        mov     eax, v2ljak
        mov     dword [esp], eax                        ; v2ljak
        call    _voitRida                               ; voitRida(char *v2ljak), kontrollime võitu ridamisi
        cmp     eax, 0                                  ; vaatame, kas tagastati true või false
        jnz     .voit                                   ; kui ei ole võitu, vaatame edasi
        mov     eax, v2ljak
        mov     dword [esp], eax                        ; v2ljak
        call    _voitVeerg                              ; voitVeerg(char *v2ljak), kontrollime võitu veergupidi
        cmp     eax, 0                                  ; vaatame, kas tagastati true või false
        jnz     .voit                                   ; kui ei ole võitu, vaatame edasi
        mov     eax, v2ljak
        mov     dword [esp], eax                        ; v2ljak
        call    _voitDiagonaal                          ; voitDiagonaal(char *v2ljak), kontrollime võitu diagonaalis
        cmp     eax, 0                                  ; kui ei ole võitu, peame tagastama false ehk 0
        jnz      .voit
		jmp 	 .ei_voitnud
		; 
.voit: ; üks mängijatest on võitnud
		mov     eax, 1
        leave                                           ; tagasame 1
        ret  

.ei_voitnud: ; keegi ei ole võitnud
		mov     eax, 0                                  ; tagastame 0
		leave
        ret

; kontrollime, kas neli on järjest
_nelik: ; nelik(char *v2ljak,int a, int b, int c, int d)

%define v2ljak 	dword [ebp+8]
%define a_ 		dword [ebp+12]
%define b_ 		dword [ebp+16]
%define c_ 		dword [ebp+20]
%define d_ 		dword [ebp+24]

        push    ebp
        mov     ebp, esp
        mov     edx, a_; a
        mov     eax, v2ljak
        add     eax, edx
        movzx   eax, byte [eax]							; v2ljak[a]
        cmp     al, 32                                  ; v2ljak[a] != ' '
        jz      .ei_voitnud
        mov     edx, a_									; a
        mov     eax, v2ljak
        add     eax, edx 
        movzx   edx, byte [eax]                         ; edx = v2ljak[a]
        mov     ecx, b_									; b
        mov     eax, v2ljak
        add     eax, ecx
        movzx   eax, byte [eax]                         ; eax = v2ljak[b]
        cmp     dl, al                                  ; v2ljak[a] == v2ljak[b]
        jnz     .ei_voitnud
        mov     edx, b_            				        ; b
        mov     eax, v2ljak
        add     eax, edx
        movzx   edx, byte [eax]                         ; v2ljak[b]
        mov     ecx, c_                				     ; c
        mov     eax, v2ljak
        add     eax, ecx
        movzx   eax, byte [eax]                         ; v2ljak[c]
        cmp     dl, al                                  ; v2ljak[b] == v2ljak[c]
        jnz     .ei_voitnud
        mov     edx, c_                  				; c
        mov     eax, v2ljak
        add     eax, edx
        movzx   edx, byte [eax]                         ; v2ljak[c]
        mov     ecx, d_                     			; d
        mov     eax, v2ljak
        add     eax, ecx
        movzx   eax, byte [eax]                         ; v2ljak[d]
        cmp     dl, al                                  ; v2ljak[c] == v2ljak[d]
        jnz     .ei_voitnud
        mov     eax, 1									; kui kõik sobib, saame tagastada true ehk 1
        jmp     .tagastame

.ei_voitnud:  
		mov     eax, 0

.tagastame:  
		pop     ebp
        ret

; vaatamekas reas on neli järjest
_voitRida:; voitRida(char *v2ljak) 

%define rida 	dword [ebp-4]
%define veerg 	dword [ebp-8]
%define indeks 	dword [ebp-12]
%define v2ljak 	dword [ebp+8]

        push    ebp
        mov     ebp, esp
        sub     esp, 100
        mov     rida, 0                       			; rida = 0
        jmp     .valimine_pais                          ; for (int rida = 0; rida < 6; rida++) {

.sisemine_algus:  
		mov     veerg, 0                        		; veerg = 0
        jmp     .sisemine_pais                          ; for (int veerg = 0; veerg < 4; veerg++) {

.sisemine_keha:
		mov     edx, rida 								; edx = rida
		mov     eax, 7
        mul		edx
        mov     edx, eax								; 7 * rida
        mov     eax, veerg                      
        add     eax, edx
        mov     indeks, eax								; indeks = 7 * rida + veerg
        mov     ecx, indeks
        add     ecx, 3									; indeks + 3
        mov     ebx, indeks
        add     ebx, 2									; indeks + 2
        mov     eax, indeks
        add     eax, 1                                  ; indeks + 1
        mov     dword [esp+16], ecx                     ; d - liigutame index+3 neljandaks argumendiks
        mov     dword [esp+12], ebx                     ; c - liigutame index+2 kolmandaks argumendiks
        mov     dword [esp+8], eax                      ; b - liigutame index+1 teiseks argumendiks
        mov     eax, indeks
        mov     dword [esp+4], eax						; a 
        mov     eax, v2ljak
        mov     dword [esp], eax                        ; v2ljak
        call    _nelik                                  ; nelik(char *v2ljak,int a, int b, int c, int d)
        cmp     eax, 0                                  ; vaatame, mida tagastatakse
        jz      .jargmine                               ; selles reas võitu ei olnud
        mov     eax, 1                                  ; selles reas oli võit
        jmp     .tagastame                              ; return 1;

.jargmine:  
		add     veerg, 1                        		; veerg++

.sisemine_pais:
		cmp     veerg, 3                        		; veerg <= 3
        jle     .sisemine_keha
        add     rida, 1									; rida++
		
.valimine_pais:
		cmp     rida, 5               					; rida <= 5
        jle     .sisemine_algus
        mov     eax, 0									; return 0

.tagastame:  
		leave
        ret                                             ; return 

_voitVeerg:; int voitVeerg(char *v2ljak)
%define rida 	dword [ebp-4]
%define veerg 	dword [ebp-8]
%define indeks 	dword [ebp-12]
%define v2ljak 	dword [ebp+8]

        push    ebp
        mov     ebp, esp
        sub     esp, 100
        mov     rida, 0                        			; rida = 0
        jmp     .valimine_pais                          ; for (int rida = 0; rida < 3; rida++) {

.sisemine_algus:  
		mov     veerg, 0                        		; veerg = 0
        jmp     .sisemine_pais                          ; for (int veerg = 0; veerg < 7; veerg++) {

.sisemine_keha:; int indeks = 7 * rida + veerg; if (nelik(v2ljak, indeks, indeks + 7, indeks + 14, indeks + 21)) { return 1; }
		mov     edx, rida	                			; edx = rida
		mov     eax, 7									
        mul		edx	
        mov     edx, eax								; 7 * rida
        mov     eax, veerg 
        add     eax, edx
        mov     indeks, eax      		                ; indeks = 7 * rida + veerg
        mov     ecx, indeks		
        add     ecx, 21		                            ; index + 21
        mov     ebx, indeks
        add     ebx, 14		                            ; index + 14
        mov     eax, indeks
        add     eax, 7                                  ; index + 7
        mov     dword [esp+16], ecx                     ; d = index + 21
        mov     dword [esp+12], ebx                     ; c = index + 14
        mov     dword [esp+8], eax                      ; b = index + 7
        mov     eax, indeks							
        mov     dword [esp+4], eax                      ; a = index 
        mov     eax, v2ljak
        mov     dword [esp], eax
        call    _nelik                                  ; nelik(char *v2ljak,int a, int b, int c, int d)
        cmp     eax, 0                                  ; vaatame, mida tagastati
        jz      .jargmine                               ; selles veerus võitu ei olnud
        mov     eax, 1                                  ; selles reas oli võit
        jmp     .tagastame                              ; return 1;

.jargmine:  
		add     veerg, 1             		            ; veerg++
.sisemine_pais:  
		cmp     veerg, 6                        		; veerg <= 7
        jle     .sisemine_keha
        add     rida, 1                        			; rida++
		
.valimine_pais:  
		cmp     rida, 2                        			; rida <= 2
        jle     .sisemine_algus
        mov     eax, 0                                  ; return 0
.tagastame:
		leave
        ret

_voitDiagonaal: ; voitDiagonaal(char *v2ljak)

%define indeks 	dword [ebp-24]
%define vasak 	dword [ebp-20]
%define parem 	dword [ebp-16]
%define veerg 	dword [ebp-12]
%define rida 	dword [ebp-8]
%define v2ljak 	dword [ebp+8]

        push    ebp
        mov     ebp, esp
        push    ebx
        sub     esp, 100
		mov     vasak, 8                       			; vasak = 8
        mov     parem, 6                     			; parem = 6
        mov     rida, 0                      			; rida = 0
        jmp     .valimine_pais                          ; for (int rida = 0; rida < 3; rida++) {

.sisemine_algus:
		mov     veerg, 0                       			; veerg = 0
        jmp     .sisemine_pais                          ; for (int veerg = 0; veerg < 7; veerg++) {

.haru_1: ;if (veerg <= 3 && nelik(v2ljak, indeks, indeks + vasak, indeks + vasak * 2, indeks + vasak * 3)) {
		mov     edx, rida                     			; edx = rida
		mov     eax, 7
        mul		edx
        mov     edx, eax								; 7 * rida
        mov     eax, veerg								; veerg
        add     eax, edx                                ; 7*rida + veerg
        mov     indeks, eax                     		; index = 7*rida + veerg
        cmp   	veerg, 3                      			; veerg <= 3
        jg      .haru_2                                 ; veerg > 3
        mov     edx, vasak                     			; edx = vasak 
        mov     eax, 3	                                ; eax = vasak
        mul     edx		                                ; edx = 3* vasak
		mov 	edx, eax
        mov     eax, indeks                     		; eax = indeks 
        lea     ecx, [edx+eax]                          ; ecx = 3 * vasak + indeks 
        mov     eax, vasak                     			; eax = vasak
        lea     edx, [eax+eax]                          ; edx = 2* vasak
        mov     eax, indeks                     		; eax = indeks
        add     edx, eax                                ; edx = 2* vasak + indeks
        mov     ebx, indeks								; ebx = indeks
        mov     eax, vasak                     			; eax = vasak
        add     eax, ebx								; eax = indeks + vasak
        mov     dword [esp+16], ecx                     ; indeks + vasak * 3
        mov     dword [esp+12], edx                     ; indeks + vasak * 2
        mov     dword [esp+8], eax                      ; indeks + vasak
        mov     eax, indeks
        mov     dword [esp+4], eax						; index
        mov     eax, v2ljak
        mov     dword [esp], eax                        ; väljak
        call    _nelik                                  ; nelik(v2ljak, indeks, indeks + vasak, indeks + vasak * 2, indeks + vasak * 3)
        cmp 	eax, 0                                  ; vaatame, mida tagastati
        jz      .haru_2                                 ; kui false, siis vaatame teist else if haru
        mov     eax, 1                                  ; kui true, tagastame 1
        jmp     .tagastame                              ; return 1;

.haru_2: ;else if(veerg >= 3 && nelik(v2ljak, indeks, indeks + parem, indeks + parem * 2, indeks + parem * 3)){ return 1;}
		cmp     veerg, 2                       			; veerg >= 3
        jle     .jargmine                               ; kui false, siis hakkame täitma järgmist tsüklit
        mov     edx, parem                     			; edx = parem
        mov     eax, 3
        mul     edx		                                ; eax = 3 * parem
		mov 	edx, eax
        mov     eax, indeks                    			; eax = indeks
        lea     ecx, [edx+eax]                          ; ecx = 3 * parem + indeks
        mov     eax, parem                     			; eax = parem
        lea     edx, [eax+eax]                          ; edx = 2 * parem
        mov     eax, indeks                     		; eax = indeks 
        add     edx, eax                                ; edx = 2 *parem + indeks
        mov     ebx, indeks                     		; ebx = indeks
        mov     eax, parem                     			; eax = parem
        add     eax, ebx                                ; eax = parem + indeks
        mov     dword [esp+16], ecx                     ; 3 * parem + indeks
        mov     dword [esp+12], edx                     ; 2 *parem + indeks
        mov     dword [esp+8], eax                      ; parem + indeks
        mov     eax, indeks
        mov     dword [esp+4], eax                      ; indeks
        mov     eax, v2ljak
        mov     dword [esp], eax                        ; v2ljak
        call    _nelik                                  ; nelik(v2ljak, indeks, indeks + parem, indeks + parem * 2, indeks + parem * 3)
        cmp     eax, 0                                  ; vaatame, mida tagastati 
        jz      .jargmine                               ; kui false, siis hakkame täitma järgmist tsüklit
        mov     eax, 1                                  ; kui true, tagastame 1
        jmp     .tagastame                              ; return 1;

.jargmine:  
		add     veerg, 1                       			; veerg ++

.sisemine_pais:
		cmp     veerg, 6                       			; veerg <= 6 
        jle     .haru_1
        add     rida, 1                        			; rida++
				
.valimine_pais:  
		cmp     rida, 2              					; rida <= 2
        jle     .sisemine_algus								
        mov     eax, 0                                  ; kui tsükkel läbi, siis return 0;
		
.tagastame:
		leave
        ret                                             ; tagastame