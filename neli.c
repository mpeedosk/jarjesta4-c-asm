// neli.c :: Järjesta neli mäng. 10.11.2016 Martin Peedosk

#include <stdio.h>  // printf, printf, scanf
#include <stdlib.h> // system
#include <string.h> // memset
// defineerime funktsioonid, et saaks neid kasutada suvalises järjestuses
void prindiValjak(char *v2ljak);
int teeKaik(char *v2ljak, int mangija, const char*);
int kontrolli(char *v2ljak);
int nelik(char *v2ljak, int, int, int, int);
int voitRida(char *v2ljak);
int voitVeerg(char *v2ljak);
int voitDiagonaal(char *v2ljak);
// mängu väljak tähtede masiivina, mille suurus on 6*7=42. (0-5) oleks siis esimene rida, (6-11) teine rida jne.


int main(int argc, char *argv[]) {
	const char *nupud = "XO";
// vaatame, kumma mängija kord on. kui paaritu arv, siis mängija 1, kui paaris siis mängija 2. Muutja v6it on kontrolliks, kas mäng on juba võidetud
    int kord, v6it = 0;
    
    // väärtustame väljaku alguses tühikutega
	char v2ljak[42];
    memset(v2ljak, ' ', 42); 

	// mängime niikaua, kuni väljak on täis, või kuni keegi on võitnud
    for (kord = 0; kord < 42 && !v6it; kord++) {
		prindiValjak(v2ljak); // igal käigul prindime väljaku uuesti.
        
        //ootame, kuni mängija teeb legaalse käigu
		teeKaik( v2ljak, kord % 2, nupud);

        // käigu lõpus kontrollime, kas mängija on võitnud
        v6it = kontrolli(v2ljak);
    }
    // mängu lõpseisu kuvamine
    prindiValjak(v2ljak);
	
	 // kui kumbki pole võitnud, siis järelikult on väljak täis, ning oleme viigiseisus.
    if (!v6it) {
        printf("M2ng l6ppes viigiga!");
    } else {
    	// kuna pärast viimast käiku suurendatakse (kord++), siis on meil õige võitja saamiseks ühe võrra lahutada
        printf("M2ngija %d (%c) v6itis!", kord % 2+1, nupud[--kord % 2]);
    }
   	
   	printf("\n\nVajuta suvalist nuppu, et j2tkata.\n");
    getchar();
}

// joonistame uue mängu seisu
void prindiValjak(char *v2ljak) {
	// puhastame käsurea akna
    system("cls"); 
    // väljastame mängu tiitli
    printf("\n	Jarjesta neli! \n"); 
     // väljak on 29 tühikut lai
    printf("-----------------------------\n");

    // käime kõik read ja veerud läbi ning lisame, kas seal on O, X või tühi
    for (int rida = 0; rida < 6; rida++) {
        for (int veerg = 0; veerg < 7; veerg++) {
        
        	// vaatame, mis sellel real ja veerul on. (O, X, )
            printf("| %c ", v2ljak[7 * rida + veerg]); 
        }
         // liigume järgmise rea juurde
        printf("| \n");
        printf("-----------------------------\n");
    }

    // oluline oleks, et numbrite vahel oleks 3 tühikut, et kõik oleks ilusti joondatud
    printf("  1   2   3   4   5   6   7 \n\n"); 
}

// ootame kuni kasutaja teeb leegaalse käigu. Küsime niikaua kuni ta midagi lubatavat sisestab
int teeKaik(char *v2ljak, int mangija, const char *nupud) {
    // defineerime muutuja tsüklist väljaspoool, sest seda on hiljem ka vaja
    int veerg = 0;
    
    // väljastame kasutajale juhendi, mida ta tegema peaks
    printf("M2ngija %d (%c):\nVali veerg, kuhu k2ia: ", mangija + 1, nupud[mangija]);

	// lõpmatu tsükkel, ootame, kuni kasutaja sisestab veeru, mis on olemas
    for (;;) {  
    	// scanf abil küsime käsurealt sisendit ja salvestame muutujasse veerg
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
	
	// vaatame, kas kasutaja sisestatud veerule on võimalik nuppu panna
    for (int rida = 5; rida >= 0; rida--) {
    	// arvutame väljaku kordinaadi
    	int indeks = 7 * rida + veerg;
    	// vaatame, kas on tühi
        if (v2ljak[indeks] == ' ') {
            v2ljak[indeks] = nupud[mangija];
            return 1;
        }
    }
    // kui me siia jõuame, tähendab et kasutaja valis olemasoelva veeru, kuid see veerg on täis
    prindiValjak(v2ljak);
    printf("See veerg on t2is, palun vali uus veerg!\n");
    
    // alustame küsimist otsast peale
    return teeKaik(v2ljak, mangija, nupud);
}

// kontrollime, kas keegi on võitnud
int kontrolli(char *v2ljak) {
	// võiduks piisab, kui ainult üks on tõene
    return (voitRida(v2ljak) || voitVeerg(v2ljak) || voitDiagonaal(v2ljak));
}

// vaatame, kas on neli järjest
int nelik(char *v2ljak,int a, int b, int c, int d) {
    return (v2ljak[a] != ' ' && v2ljak[a] == v2ljak[b] && v2ljak[b] == v2ljak[c] && v2ljak[c] == v2ljak[d]);

}

// vaatamekas reas on neli järjest
int voitRida(char *v2ljak) {
	// vaatame kõik read läbi
    for (int rida = 0; rida < 6; rida++) {
        // kõiki veerge ei ole vaja vaadata, kuna võiduks on vaja 4 järjest, siis viimase 3 veeru korral läheks kontroll väljakust välja
		for (int col = 0; col < 4; col++) {
			// leiame masiivist õige koha
            int indeks = 7 * rida + col;
            // kui leidub neli järjest, on võit leitud
            if (nelik(v2ljak,indeks, indeks + 1, indeks + 2, indeks + 3)) {
                return 1;
            }
        }
    }
    // võitu ei ole
    return 0;
}

// vaatame, kas veerus on neli järjest
int voitVeerg(char *v2ljak) {
	// viimast 3 rida ei ole vaja vaadata eraldi, sest 4 peab olema järjest
    for (int rida = 0; rida < 3; rida++) {
    	// vaatame kõik veerud läbi
        for (int veerg = 0; veerg < 7; veerg++) {
        	// leiame masiivist õige koha
            int indeks = 7 * rida + veerg;
            // kui leidub neli järjest, on võit leitud
            if (nelik(v2ljak, indeks, indeks + 7, indeks + 14, indeks + 21)) {
                return 1;
            }
        }
    }
    // võitu ei ole
    return 0;

}

// vaatame, kas diagonaalis on neli järjest
int voitDiagonaal(char *v2ljak) {
	// vaatame mõlemat diagonaali üks mis algab paremalt ülevalt, teine mis algab vasakult ülevalt
    const int parem = 6, vasak = 8;

	// viimast 3 rida ei ole vaja vaadata eraldi, sest 4 peab olema järjest
    for (int rida = 0; rida < 3; rida++) {
    	// vaatame kõik veerud läbi
        for (int veerg = 0; veerg < 7; veerg++) {
        	// leiame masiivist õige koha
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
    // võitu ei ole
    return 0;

}
