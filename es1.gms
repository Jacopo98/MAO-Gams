$Title Pianificazione Urbana

* commento inline
$onText
Soluzione dell'esercizio 1 (esercitazione 1)
$offText

* NB --> linguaggio non case sensitive

$onText
Appunti:
non cambia nulla tra set e sets, stesso vale per parameters
/1*4/ equivale a fare /1,2,3,4/
$offText

Set J insieme delle tipologie di abitazioni /1*4/;

Parameters
 Tax (j) Tassa [K$] dell'abitazione j
/
1 1
2 1.9
3 2.7
4 3.4
/

 S(j) Spazio in acri dell'abitazione j
/
1 0.18
2 0.28
3 0.4
4 0.5
/

 cc(j) costo di costruzione [K$]  dell'abitazione
/
1 50
2 70
3 130
4 160
/
;

Scalars
 Nmax Numero massimo di edifici demolibili /300/
 s0 Spazio occupato dai vecchi edifici  /0.25/
 cd Costo di demolizione [K$] /2/
 qs Quota di spazio per servizi /0.15/
 p34 Frazione minima di 3 e 4 /0.25/
 p1 frazione minima di 1 /0.2/
 p2 frazione minima di 2 /0.1/
 B Budget [K$] /15000/
 ;
 

*FASE DI MODELLAZIONE
* indicazione delle variabili decisionali
* Variables di base è di tipo Free Variables (implicito)
Variables
x(j) N umero di abitazione j costruite
y numero di vecchie abitazioni demolite
z Variabile obiettivo: Tasse totali [K$]
;

Integer variables x,y;
*devono essere interi --> pero devo modificare l'upper bound perche lavoro con valori maggiori di 100
y.up = Nmax;

*Positive variables x,y;

* Free Variable z; (non serve è già Free Variable)

$onText
Positive Variables ---> >= 0
Negative Variables ---> <= 0
Free Variables ---> in R
Binary Variables ---> [0\1]
Integer Variables ---> in [0,1,2,...,100]
$OffText

Equations
 obiettivo Funsione obiettivo
 demolizioni Upper Bound (vincolo) sulle demolizioni
 spazio Vincolo di spazio
 lb34 Lower  bound su 3 e 4
 lb1 Lower  bound su 1
 lb2 Lower  bound su 2
 budget Vincolo di budget
;

obiettivo.. z =e= sum(j,Tax(j)*x(j));
demolizioni.. y =l= Nmax;
spazio.. sum(j,S(j)*x(j)) =l= s0*y*(1-qs);
lb34.. x('3') + x('4') =g= p34*sum(j,x(j));
lb1.. x('1') =g= p1*sum(j,x(j));
lb2.. x('2') =g= p2*sum(j,x(j));
budget.. sum(j,cc(j)*x(j))+cd*y =l= B;

*COSTRUZIONE DEL MODELLO
* uso all per dire che tutte le equazioni partecipano al modello
* di seguito alcune possibilità:
Model Ex1 /all/;
Model Ex1_b /obiettivo,demolizioni,spazio,budget/;
Model Ex1_c /Ex1_b + lb34/;
Model Ex1_d /Ex1 - lb2/;

* dopo using specifico la classe di modellazione, nel nostro caso lineare
* direzione di ottimizzazione + variabile obiettivo
*Solve Ex1 using LP maximising z; (ORA USO QUELLA mista intera (MIP))
* di seguito ecco come gestire il GAP di ottimalità assoluto e relativo
Ex1.optca = 0;
Ex1.optcr = 0;
Solve Ex1 using MIP maximising z;



*ogni volta che sono a valle del comando di rislouzione devo accede alle
*variabili usando l'estensione .l

Scalar Xtot Numero totale di nuovi edifici;
Xtot = sum(j,x.l(j));

*Per la domanda 2
Scalar ratio percentuale di spazio saturato;
Ratio = sum(j,s(j)*x.l(j))/(s0*y.l);


Display S,x.l,x.m,Xtot, Ratio;

