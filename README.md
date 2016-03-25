#HardTruck map v3.0
 
Tak więc bez zbędnego gadania przejdźmy to systemów, zalet i wszystkiego co z w/w skryptem związane:
Pisany w 100% pod system MySQL Plugin zawarty w paczce.
System punktów premium i vip'a [PP](*1)
System dynamicznych pojazdów (*2)
System przebieralni w sklepach Binco
System administratora to chyba standard ale warto wypisać
System kar Ban stały/czasowy, warn, kick, blokada konta
System liderów frakcji pod komendą /lider
Dynamiczny system firm i frakcji
Gotowe komendy pod frakcje
System centrali
Limit ładunków (*3)
System rozwijania prywatnych pojazdów
Stacje benzynowe
System salonów do prywatnych pojazdów
System spawnu pojazdów dla graczy/firm/frakcji brak rozwalonych po mapie pojazdów
System prawa jazdy (teoria/praktyka)
System dokumentów (dowód osobisty, prawo jazdy itp)
System przeszkód dla pomocy drogowej
 
(*1) Gracz kupuje Punkty Premium (PP) które następnie może wydać na nowe pojazdy, vip'a itd.
(*2) Gracz zbiera na nowe pojazdy którymi będzie rozwoził towary bądź poruszał się po mapie. Nie ma tak zwanych publicznych pojazdów.
(*3) W centralach jest lista towarów do rozwiezienia ich ilość (globalnie). Resetują się gdy zostanie rozwieziony ostatni towar.
 
ScreenShoty:
http://imageshack.us/a/img189/5783/samp004oi.png
http://imageshack.us/a/img268/8421/samp051es.png
http://imageshack.us/a/img685/4650/samp050xev.png
Niestety więcej nie mam ale jeżeli ktoś takowe posiada zapraszam do dzielenia się nimi w odpowiedzi pod tym tematem bądź podesłaniu mi ich prywatną wiadomością.
 
Warunki korzystania z gamemoda:
Zabrania się zmiany autora.
Zabrania się udostępniania na innych forach bez mojej wiedzy.
Pozwalam na zmianę nazwy gamemod'a.
Pozwalam na edycję kodu.
 
Download
http://inferno24.pl/download/HardTruck+map+3.0.rar
 
Link zaktualizowany: 05-01-2014 14:10
Dodano include i pluginy niezbędne do odpalenia serwera na wersji 0.3x
Podziękowania dla dawka0202 za podrzucenie potrzebnych plików :)
 
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
