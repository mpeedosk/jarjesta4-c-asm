// neli.c :: J�rjesta neli m�ng. 10.11.2016 Martin Peedosk

#include <stdio.h>  // printf, printf, scanf
#include <stdlib.h> // system
#include <string.h> // memset
// defineerime funktsioonid, et saaks neid kasutada suvalises j�rjestuses
void prindiValjak(char *v2ljak);
int teeKaik(char *v2ljak, int mangija, const char*);
int kontrolli(char *v2ljak);
int nelik(char *v2ljak, int, int, int, int);
int voitRida(char *v2ljak);
int voitVeerg(char *v2ljak);
int voitDiagonaal(char *v2ljak);
// m�ngu v�ljak t�htede masiivina, mille suurus on 6*7=42. (0-5) oleks siis esimene rida, (6-11) teine rida jne.


int main(int argc, char *argv[]) {
	const char *nupud = "XO";
// vaatame, kumma m�ngija kord on. kui paaritu arv, siis m�ngija 1, kui paaris siis m�ngija 2. Muutja v6it on kontrolliks, kas m�ng on juba v�idetud
    int kord, v6it = 0;
    
    // v��rtustame v�ljaku alguses t�hikutega
	char v2ljak[42];
    memset(v2ljak, ' ', 42); 

	// m�ngime niikaua, kuni v�ljak on t�is, v�i kuni keegi on v�itnud
    for (kord = 0; kord < 42 && !v6it; kord++) {
		prindiValjak(v2ljak); // igal k�igul prindime v�ljaku uuesti.
        
        //ootame, kuni m�ngija teeb legaalse k�igu
		teeKaik( v2ljak, kord % 2, nupud);

        // k�igu l�pus kontrollime, kas m�ngija on v�itnud
        v6it = kontrolli(v2ljak);
    }
    // m�ngu l�pseisu kuvamine
    prindiValjak(v2ljak);
	
	 // kui kumbki pole v�itnud, siis j�relikult on v�ljak t�is, ning oleme viigiseisus.
    if (!v6it) {
        printf("M2ng l6ppes viigiga!");
    } else {
    	// kuna p�rast viimast k�iku suurendatakse (kord++), siis on meil �ige v�itja saamiseks �he v�rra lahutada
        printf("M2ngija %d (%c) v6itis!", kord % 2+1, nupud[--kord % 2]);
    }
   	
   	printf("\n\nVajuta suvalist nuppu, et j2tkata.\n");
    getchar();
}

// joonistame uue m�ngu seisu
void prindiValjak(char *v2ljak) {
	// puhastame k�surea akna
    system("cls"); 
    // v�ljastame m�ngu tiitli
    printf("\n	Jarjesta neli! \n"); 
     // v�ljak on 29 t�hikut lai
    printf("-----------------------------\n");

    // k�ime k�ik read ja veerud l�bi ning lisame, kas seal on O, X v�i t�hi
    for (int rida = 0; rida < 6; rida++) {
        for (int veerg = 0; veerg < 7; veerg++) {
        
        	// vaatame, mis sellel real ja veerul on. (O, X, )
            printf("| %c ", v2ljak[7 * rida + veerg]); 
        }
         // liigume j�rgmise rea juurde
        printf("| \n");
        printf("-----------------------------\n");
    }

    // oluline oleks, et numbrite vahel oleks 3 t�hikut, et k�ik oleks ilusti joondatud
    printf("  1   2   3   4   5   6   7 \n\n"); 
}

// ootame kuni kasutaja teeb leegaalse k�igu. K�sime niikaua kuni ta midagi lubatavat sisestab
int teeKaik(char *v2ljak, int mangija, const char *nupud) {
    // defineerime muutuja ts�klist v�ljaspoool, sest seda on hiljem ka vaja
    int veerg = 0;
    
    // v�ljastame kasutajale juhendi, mida ta tegema peaks
    printf("M2ngija %d (%c):\nVali veerg, kuhu k2ia: ", mangija + 1, nupud[mangija]);

	// l�pmatu ts�kkel, ootame, kuni kasutaja sisestab veeru, mis on olemas
    for (;;) {  
    	// scanf abil k�sime k�surealt sisendit ja salvestame muutujasse veerg
        if (!scanf("%d", &veerg) || veerg < 1 || veerg > 7) {
        	while(getchar() != '\n');
            printf("Sellist veergu ei ole! Proovige uuesti.\n");
            printf("Vali veerg, kuhu k2ia: ");
        } else {
        	// kasutaja sisestas midagi sobivat
            break;
        }
    }
    getchar();
    
    // kasutaja sisestab 1-7, kuid arvuti jaoks on vaja 0-6
    veerg--;
	
	// vaatame, kas kasutaja sisestatud veerule on v�imalik nuppu panna
    for (int rida = 5; rida >= 0; rida--) {
    	// arvutame v�ljaku kordinaadi
    	int indeks = 7 * rida + veerg;
    	// vaatame, kas on t�hi
        if (v2ljak[indeks] == ' ') {
            v2ljak[indeks] = nupud[mangija];
            return 1;
        }
    }
    // kui me siia j�uame, t�hendab et kasutaja valis olemasoelva veeru, kuid see veerg on t�is
    prindiValjak(v2ljak);
    printf("See veerg on t2is, palun vali uus veerg!\n");
    
    // alustame k�simist otsast peale
    return teeKaik(v2ljak, mangija, nupud);
}

// kontrollime, kas keegi on v�itnud
int kontrolli(char *v2ljak) {
	// v�iduks piisab, kui ainult �ks on t�ene
    return (voitRida(v2ljak) || voitVeerg(v2ljak) || voitDiagonaal(v2ljak));
}

// vaatame, kas on neli j�rjest
int nelik(char *v2ljak,int a, int b, int c, int d) {
    return (v2ljak[a] != ' ' && v2ljak[a] == v2ljak[b] && v2ljak[b] == v2ljak[c] && v2ljak[c] == v2ljak[d]);

}

// vaatamekas reas on neli j�rjest
int voitRida(char *v2ljak) {
	// vaatame k�ik read l�bi
    for (int rida = 0; rida < 6; rida++) {
        // k�iki veerge ei ole vaja vaadata, kuna v�iduks on vaja 4 j�rjest, siis viimase 3 veeru korral l�heks kontroll v�ljakust v�lja
		for (int col = 0; col < 4; col++) {
			// leiame masiivist �ige koha
            int indeks = 7 * rida + col;
            // kui leidub neli j�rjest, on v�it leitud
            if (nelik(v2ljak,indeks, indeks + 1, indeks + 2, indeks + 3)) {
                return 1;
            }
        }
    }
    // v�itu ei ole
    return 0;
}

// vaatame, kas veerus on neli j�rjest
int voitVeerg(char *v2ljak) {
	// viimast 3 rida ei ole vaja vaadata eraldi, sest 4 peab olema j�rjest
    for (int rida = 0; rida < 3; rida++) {
    	// vaatame k�ik veerud l�bi
        for (int veerg = 0; veerg < 7; veerg++) {
        	// leiame masiivist �ige koha
            int indeks = 7 * rida + veerg;
            // kui leidub neli j�rjest, on v�it leitud
            if (nelik(v2ljak, indeks, indeks + 7, indeks + 14, indeks + 21)) {
                return 1;
            }
        }
    }
    // v�itu ei ole
    return 0;

}

// vaatame, kas diagonaalis on neli j�rjest
int voitDiagonaal(char *v2ljak) {
	// vaatame m�lemat diagonaali �ks mis algab paremalt �levalt, teine mis algab vasakult �levalt
    const int parem = 6, vasak = 8;

	// viimast 3 rida ei ole vaja vaadata eraldi, sest 4 peab olema j�rjest
    for (int rida = 0; rida < 3; rida++) {
    	// vaatame k�ik veerud l�bi
        for (int veerg = 0; veerg < 7; veerg++) {
        	// leiame masiivist �ige koha
			int indeks = 7 * rida + veerg;
			// kui oleme 0-3 veeru juures saame vaadata vasaku diagonaali nuppe
            if (veerg <= 3 && nelik(v2ljak, indeks, indeks + vasak, indeks + vasak * 2, indeks + vasak * 3)) {
                return 1;
            // kui oleme 3-6 veeru juures, saame vaadata parema diagonaali nuppe
			}else if(veerg >= 3 && nelik(v2ljak, indeks, indeks + parem, indeks + parem * 2, indeks + parem * 3)){
            	return 1;
			}
        }
    }
    // v�itu ei ole
    return 0;

}
