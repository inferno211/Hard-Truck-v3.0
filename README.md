#HardTruck map v3.0
 
Tak wi�c bez zb�dnego gadania przejd�my to system�w, zalet i wszystkiego co z w/w skryptem zwi�zane:
Pisany w 100% pod system MySQL Plugin zawarty w paczce.
System punkt�w premium i vip'a [PP](*1)
System dynamicznych pojazd�w (*2)
System przebieralni w sklepach Binco
System administratora to chyba standard ale warto wypisa�
System kar Ban sta�y/czasowy, warn, kick, blokada konta
System lider�w frakcji pod komend� /lider
Dynamiczny system firm i frakcji
Gotowe komendy pod frakcje
System centrali
Limit �adunk�w (*3)
System rozwijania prywatnych pojazd�w
Stacje benzynowe
System salon�w do prywatnych pojazd�w
System spawnu pojazd�w dla graczy/firm/frakcji brak rozwalonych po mapie pojazd�w
System prawa jazdy (teoria/praktyka)
System dokument�w (dow�d osobisty, prawo jazdy itp)
System przeszk�d dla pomocy drogowej
 
(*1) Gracz kupuje Punkty Premium (PP) kt�re nast�pnie mo�e wyda� na nowe pojazdy, vip'a itd.
(*2) Gracz zbiera na nowe pojazdy kt�rymi b�dzie rozwozi� towary b�d� porusza� si� po mapie. Nie ma tak zwanych publicznych pojazd�w.
(*3) W centralach jest lista towar�w do rozwiezienia ich ilo�� (globalnie). Resetuj� si� gdy zostanie rozwieziony ostatni towar.
 
ScreenShoty:
http://imageshack.us/a/img189/5783/samp004oi.png
http://imageshack.us/a/img268/8421/samp051es.png
http://imageshack.us/a/img685/4650/samp050xev.png
Niestety wi�cej nie mam ale je�eli kto� takowe posiada zapraszam do dzielenia si� nimi w odpowiedzi pod tym tematem b�d� podes�aniu mi ich prywatn� wiadomo�ci�.
 
Warunki korzystania z gamemoda:
Zabrania si� zmiany autora.
Zabrania si� udost�pniania na innych forach bez mojej wiedzy.
Pozwalam na zmian� nazwy gamemod'a.
Pozwalam na edycj� kodu.
 
Download
http://inferno24.pl/download/HardTruck+map+3.0.rar
 
Link zaktualizowany: 05-01-2014 14:10
Dodano include i pluginy niezb�dne do odpalenia serwera na wersji 0.3x
Podzi�kowania dla dawka0202 za podrzucenie potrzebnych plik�w :)
 
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
