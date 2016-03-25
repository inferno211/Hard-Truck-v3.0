#HardTruck map v3.0
 
Tak wiêc bez zbêdnego gadania przejdŸmy to systemów, zalet i wszystkiego co z w/w skryptem zwi¹zane:
Pisany w 100% pod system MySQL Plugin zawarty w paczce.
System punktów premium i vip'a [PP](*1)
System dynamicznych pojazdów (*2)
System przebieralni w sklepach Binco
System administratora to chyba standard ale warto wypisaæ
System kar Ban sta³y/czasowy, warn, kick, blokada konta
System liderów frakcji pod komend¹ /lider
Dynamiczny system firm i frakcji
Gotowe komendy pod frakcje
System centrali
Limit ³adunków (*3)
System rozwijania prywatnych pojazdów
Stacje benzynowe
System salonów do prywatnych pojazdów
System spawnu pojazdów dla graczy/firm/frakcji brak rozwalonych po mapie pojazdów
System prawa jazdy (teoria/praktyka)
System dokumentów (dowód osobisty, prawo jazdy itp)
System przeszkód dla pomocy drogowej
 
(*1) Gracz kupuje Punkty Premium (PP) które nastêpnie mo¿e wydaæ na nowe pojazdy, vip'a itd.
(*2) Gracz zbiera na nowe pojazdy którymi bêdzie rozwozi³ towary b¹dŸ porusza³ siê po mapie. Nie ma tak zwanych publicznych pojazdów.
(*3) W centralach jest lista towarów do rozwiezienia ich iloœæ (globalnie). Resetuj¹ siê gdy zostanie rozwieziony ostatni towar.
 
ScreenShoty:
http://imageshack.us/a/img189/5783/samp004oi.png
http://imageshack.us/a/img268/8421/samp051es.png
http://imageshack.us/a/img685/4650/samp050xev.png
Niestety wiêcej nie mam ale je¿eli ktoœ takowe posiada zapraszam do dzielenia siê nimi w odpowiedzi pod tym tematem b¹dŸ podes³aniu mi ich prywatn¹ wiadomoœci¹.
 
Warunki korzystania z gamemoda:
Zabrania siê zmiany autora.
Zabrania siê udostêpniania na innych forach bez mojej wiedzy.
Pozwalam na zmianê nazwy gamemod'a.
Pozwalam na edycjê kodu.
 
Download
http://inferno24.pl/download/HardTruck+map+3.0.rar
 
Link zaktualizowany: 05-01-2014 14:10
Dodano include i pluginy niezbêdne do odpalenia serwera na wersji 0.3x
Podziêkowania dla dawka0202 za podrzucenie potrzebnych plików :)
 
Dodatkowe linki
http://www.PTSRP.pl
http://www.infus211.ct8.pl
http://www.facebook.com/ptsrp

Poprawka w ladowaniu centrali

Instrukcja:

Znajdz w OnGameModeInit:

LadujBramy();
LoadVehicles();
LoadCargos();
LoadFrakcje();
LoadLoadings();

Dodaj po:

LoadCentrale();
 

Dodatkowo, dla osob ktore maja problem z brakiem miejsc gdzie zawozic towary, w sat_loadings musicie dodac miejsca zaladunkow z ktorych bedzie losowac.
