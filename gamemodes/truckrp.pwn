/*
 * Nazwa Projektu: Hard Truck v3.0
 * Autor: Inferno
 *

	Gdy zjedziesz w dó³ kodu znajdziesz linijki gdzie konfigurujesz gamemoda!
	
	Pozdrawiam
	Piotr Grencel (Inferno)
	
	25PP - tydzieñ
	45PP - 2 tygodnie
	90PP - miesi¹c
	150PP - 2 miesi¹ce + 1 tydzieñ gratis

*/
//------------------------------------------------------------------------------
#include <a_samp>
#include <sscanf2>
#include <streamer>
#include <a_mysql>
#include <foreach>
#include <zcmd>
//#include <MD5>
#include <progress>


#define MYSQL_HOST "localhost"                   		// Host bazy danych
#define MYSQL_USER ""                      				// U¿ytkownik bazy danych
#define MYSQL_PASS ""                         			// Haslo bazy danych
#define MYSQL_DB   ""                      				// Nazwa bazy danych
#define WEB_URL "www.Hard-Truck.pl"                          // Adres forum serwera
#define GM_TEXT "HardTruck v3.0"               	// Treœæ w zak³adce 'Mode'
#define SC_NAME "{36acff}Hard Truck"           // Nag³ówki
#define INFO_MAPNAME "» HT • v3.0.0 Beta «"         	// Treœæ w zak³adce 'Map'
#define Sloty 10 										// Liczba slotów na serwerze
#define MAX_PRZESZKODY 50 								// Iloœæ przeszkód jakie PD mo¿e ustawiæ
#define MAX_PRIVATE_VEHICLES 1000                       // Maksymalna iloœæ prywatnych pojazdów w mapie
#define MAX_REKLAM 4                                    // Iloœæ reklam w mapie
#define TIMER_INTERVAL 2000 							// Odœwie¿anie gpos


new Reklama[MAX_REKLAM][256] =
{
	{"Na serwerze jest mo¿liwosc kupna KP i PP. Wiêcej pod /pp."},
	{"Zapraszamy na nasze forum www.Hard-Truck.pl."},
	{"Status rekrutacji do frakcji znajdziesz pod /rekrutacja."},
	{"Zapraszamy na naszego TS'a 91.204.161.155."}
};


#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define MAX_PLAYER_IP 16
//------------------------------------------------------------------------------
#define NONE 0
#define GAZ 1
#define PALIWO 2
//------------------------------------------------------------------------------
#define KEYDEBUG 0
#define DEBUG 1
//------------------------------------------------------------------------------)
#define Distance3D(%1,%2,%3,%4,%5,%6) (floatsqroot((%1 - %4) * (%1 - %4) + (%2 - %5) * (%2 - %5) + (%3 - %6) * (%3 - %6))*1000.0)
//------------------------------------------------------------------------------
#define COLOR_YELLOW_W 	0xFFB400FF
#define COLOR_YELLOW_W_2 0xffc53aFF
#define COLOR_DO 		0x88A2ECFF
#define COLOR_DO2 		0x88A2ECFF
#define COLOR_DO3 		0x6283E6FF
#define COLOR_DO4 		0x486FE1FF
#define COLOR_DO5 		0x3C65DFFF
#define COLOR_FADE1     0xE6E6E6E6
#define COLOR_FADE2     0xC8C8C8C8
#define COLOR_FADE3     0xAAAAAAAA
#define COLOR_FADE4     0x8C8C8C8C
#define COLOR_FADE5     0x6E6E6E6E
#define COLOR_PURPLE 	0xC2A2DAAA
#define COLOR_PURPLE2 	0xBB98D6FF
#define COLOR_PURPLE3 	0xAD83CDFF
#define COLOR_PURPLE4 	0xA778C9FF
#define COLOR_PURPLE5 	0x9963C0FF
#define COLOR_YELLOW 	0xFFFF00FF
#define C_YELLOW 		"{ffff00}"
#define COLOR_WHITE 	0xFFFFFFFF
#define C_WHITE 		"{ffffff}"
#define COLOR_RED 		0xFF0000FF
#define C_RED 			"{ff0000}"
#define COLOR_RED2 		0xc00000FF
#define C_RED2 			"{c00000}"
#define COLOR_DRED 		0x990000FF
#define C_DRED 			"{990000}"
#define COLOR_BLUE_1 	0x007EFFFF
#define C_BLUE_1 		"{007eff}"
#define COLOR_BLUE_2 	0x0069D4FF
#define C_BLUE_2 		"{0069d4}"
#define COLOR_GREY 		0xC0C0C0FF
#define C_GREY 			"{C0C0C0}"
#define COLOR_GREY_2 	0x959595FF
#define C_GREY_2 		"{959595}"
//kolory do zmieniania w czacie,textcie 3d
#define C_BIALY 			"{FFFFFF}"
#define C_CZARNY 			"{000000}"
#define C_ZOLTY 			"{FFFF00}"
#define C_POMARANCZOWY 		"{FF7F50}"
#define C_CZERWONY 			"{FF0000}"
#define C_ROZOWY 			"{FF1493}"
#define C_NIEBIESKI 		"{4169E1}"
#define C_BRAZOWY 			"{A0522D}"
#define C_ZIELONY 			"{ADFF2F}"
#define C_TURKUSOWY 		"{00FFFF}"
#define C_SZARY 			"{C0C0C0}"
#define C_FILOETOWY 		"{BA55D3}"
#define C_BEZOWY 			"{FFDEAD}"
#define C_BORDOWY 			"{B22222}"
#define C_BLEKITNY 			"{00E0FF}"
#define KOLOR_NIEWIDZIALNY 	0xFFFFFF00
#define KOLOR_BIALY 		0xFFFFFFFF
#define KOLOR_CZARNY 		0x000000FF
#define KOLOR_ZOLTY 		0xFFFF00FF
#define KOLOR_POMARANCZOWY 0xFF8040FF
#define KOLOR_CZERWONY 0xFF2F2FFF
#define KOLOR_ROZOWY 0xFF80FFFF
#define KOLOR_NIEBIESKI 0x2B95FFFF
#define KOLOR_BRAZOWY 0x9D4F4FFF
#define KOLOR_ZIELONY 0x00FF40FF
#define KOLOR_TURKUSOWY 0x00FFFFFF
#define KOLOR_SZARY 0xC0C0C0FF
#define KOLOR_FILOETOWY 0x800040FF
#define KOLOR_BEZOWY 0xFFFFA6FF
#define KOLOR_BORDOWY 0x800000FF
#define KOLOR_NICKU 0x00FFFFFF

#define CarLoop(%1) for(new %1; %1 < MAX_PRIVATE_VEHICLES+1; %1++)
#define PlayerLoop(%1) for(new %1=0; %1<Sloty; %1++)
//B12

#define DIALOG_LOGIN 2000
#define DIALOG_REGISTER 2001
#define DIALOG_HELP 2002
#define DIALOG_BUY_TRUCK 2004
#define DIALOG_GPS 2005
#define DIALOG_MESSAGE_BOX 2006
#define DIALOG_TOWARY 2008
#define DIALOG_ANULUJ 2009
#define DIALOG_GPS_KATEGORIE 2010
#define DIALOG_GPS_ZALADUNKI 2011
#define DIALOG_GPS_CENTRALE 2012
#define DIALOG_GPS_STACJE 2013
#define DIALOG_OBIEKTY_1 2014
#define DIALOG_OBIEKTY_2 2015
#define DIALOG_OBIEKTY_3 2016
#define DIALOG_OBIEKTY_4 2017
#define DIALOG_OBIEKTY_PYTANIE 2018
#define DIALOG_STACJA 2019
#define DIALOG_NAPRAW 2020
#define DIALOG_MANDAT 2021
#define DIALOG_EMAIL 2022
#define DIALOG_KONTO 3200
#define DIALOG_VEHICLES 3100
#define DIALOG_LIDER 3000
#define DIALOG_PRAWKO 3300

#define MAX_CARGOS 100
#define MAX_LOADINGS 100
#define MAX_PETROL_STATIONS 100
//------------------------------------------------------------------------------
enum pEnum
{
	Uid,
	Name[MAX_PLAYER_NAME],
	VipTime,
	Float:pPos[4],
	bool:Logged,
	bool:InCarShop,
	bool:InBinco,
	Text3D:Player3DText,
	Text3D:Description,
	UsedDialog,
	Password[255],
	SpawnedVehicle,
	Score,
	Skin,
	Money,
	Admin,
	ActualVehicle,
	bool:WaitForLadunek,
	GPSON,
	Frakcja,
	Lider,
	Pracuje,
	Jail,
	Gold,
	VIP,
	Login,
	Warn,
	interior,
	vw,
	email[100],
	Namierzanie,
	NamierzIcon,
	karne,
	
//statystyki
	Mandat,
	Areszt,
	Dostarczen
};

enum vEnum {
	uid,
	frakcja,
	ownerid,
	model,
	c1,
	c2,
	Float:petrol,
	Float:maxpetrol,
	Float:mileage,
	Float:health,
	Float:vx,
	Float:vy,
	Float:vz,
	Float:va,
	Float:vPos[3],
	gtauid,
	locked,
	lights,
	engine,
	cargo,
	cargostat,
	Text3D:vDesc,
//dodatki
	nitro,
	hydraulika,
	paliwo,
	ladunek,
	zamekc,
	cb
};

enum cEnum {
	uid,
	cname[255],
	Float:weight,
	price,
	illegal,
	fromid,
	toid,
	dostepnosc
}

enum lenum {
	uid,
	lname[255],
	Float:lx,
	Float:ly,
	Float:lz
}

enum psInfo {
	uid,
	pname[255],
	Float:sx,
	Float:sy,
	Float:sz
}
#define MAX_FRAKCJI 10
enum FrakcjaEnum
{
	UID,
	Nazwa[64],
	Szef,
	Float: SpawnX,
	Float: SpawnY,
	Float: SpawnZ,
	Skin,
    Text3D: dinfo,
    Konto,
    bool: Rekrutacja
}
new FrakcjaInfo[MAX_FRAKCJI][FrakcjaEnum];

new Przeszkoda[Sloty][MAX_PRZESZKODY];
new PrzeszkodaID[Sloty][MAX_PRZESZKODY];
new Przeszkod[Sloty];
new Ostatni[Sloty];
new Edytuje[Sloty];
new odlicz=0;
new sczas=12;
new TotalVeh=0;
enum SpisObiektowEnum
{
	ID,
	nazwa[128]
}
#define MAX_OBIEKTOW 12
new SpisObiektow[MAX_OBIEKTOW][SpisObiektowEnum] =
{
	{979,   "(979) Barierka"},
	{1459,  "(1459) P³otek 1"},
	{1237,  "(1237) Beczka z wod¹"},
	{1427,  "(1427) Tabliczka drewniana"},
	{1424,  "(1424) Metalowa barierka"},
	{983,   "(983) P³otek metalowy, z siatk¹"},
	{1238,  "(1238) Czerwony pacho³ek"},
	{1282,  "(1282) Œwiec¹cy znak"},
	{1422,  "(1422) Betonowe klocki"},
	{1425,  "(1425) Znak \"objazd\""},
	{1428,  "(1428) Drabina"},
	{19425, "(19425) Spowalniacz prêdkoœci"}
};
enum CentralaEnum
{
	uid,
	nazwa[64],
	Float: cx,
	Float: cy,
	Float: cz,
	cp,
	zajety
}
#define MAX_CENTRALI 30
new CentralaInfo[MAX_CENTRALI][CentralaEnum];
enum StacjeEnum
{
	Float: SRadi,
	Float: SX,
	Float: SY,
	Float: SZ,
	Float: Cena
}
#define MAX_STACJI 22
new Stacje[MAX_STACJI][StacjeEnum] =
{
	{999999.999999, 99999.99999, 999999.99999, 999999.999999, 999999.999999}, //Nie ruszaæ
	{16.0, -1328.6442,2677.4944,49.7787,6.12},
	{8.0, -737.3889,2742.2444,46.8992,6.23},
	{12.0, -1475.6040,1863.6361,32.3494,6.65},
	{10.0, 70.2113,1218.4081,18.5282,7.11},
	{25.0, 611.5366,1694.5262,6.7086,6.29},
	{16.0, 1596.3970,2197.1189,10.5371,6.98},
	{16.0, 2199.8953,2477.1919,10.5369,6.10},
	{16.0, 2640.4731,1104.9952,10.5366,6.89},
	{16.0, 2115.5632,923.1831,10.5362,6.32},
	{10.0, 1380.8798,456.7491,19.6220,5.82},
	{12.0, 652.3244,-569.8619,16.0465,5.12},
	{12.0, 1003.0161,-939.9588,41.8959,5.64},
	{12.0, 1944.4365,-1773.8070,13.1072,5.32},
	{12.0, -89.2281,-1164.0281,2.0001,6.34},
	{14.0, -1606.3033,-2713.9014,48.2523,6.32},
	{8.0, -2244.0728,-2560.5244,31.6372,6.32},
	{10.0, -2029.6616,157.3720,28.5526,7.43},
	{16.0, -2414.1677,976.4759,45.0135,7.32},
	{16.0, -1674.9819,413.9892,7.1797,5.99},
	{16.0, 2150.0823,2748.0471,10.8203,6.33},
	{16.0, -1021.2431,1072.0266,37.9893,6.99}
};
//new Seconds;
new Bar: LadowanieBar[Sloty];
new PetrolValue;
new LoadingsValue;
new CargosValue;
new Text:CarStatus[Sloty];
new Text:CarStatus2[Sloty];
new Text:CarStatus3;
new Text:CarStatus4;
new iTick;
new zaladunekcp;
new Text:bulidInfo;
new Text:PenaltyAnnouce;
new PenaltyCount;
new Float:fStartTime;
new Text:Box[2];
new VehicleInfo[MAX_PRIVATE_VEHICLES+1][vEnum];
new CargoInfo[MAX_CARGOS+1][cEnum];
new LoadingsInfo[MAX_LOADINGS+1][lenum];
new PlayerInfo[Sloty][pEnum];
new PetrolStationInfo[MAX_PETROL_STATIONS][psInfo];
new dstring[256];
new Umarl[Sloty];
new FrakcjeValue;
new CentralaValue;
new WyswietlaPojazd[Sloty][1000];
new Wybral[Sloty];
new Text:godzinaserver;
new Text:data;
new Text:godzinaswiat;
new Text:BincoTD[2];

new Text:Salon[3];
new salon;
new saloncar;

#define MAX_INSALON 16
new SalonInfo[MAX_INSALON][4] = {
	//MODEL | CENA | PAKOWNOSC | WAGA
    {478, 900, 400, 1500},
    {414, 10000, 500, 14000},
    {498, 14000, 600, 16000},
    {499, 16000, 700, 18000},
    {413, 18500, 550, 35000},
    {418, 26000, 300, 35000},
    {456, 27000, 350, 10000},
    {440, 35000, 600, 35000},
    {428, 40100, 620, 35000},
    {459, 44000, 800, 20300},
    {543, 50000, 900, 20600},
    {482, 100000, 650, 35000},
    {455, 130000, 1400, 35000},
    {573, 200000, 1700, 35000},
//    {433, 300000, 3000, 35000},
//osobowe
	{419, 400000, 0, 2300},
	{436, 500000, 0, 3400}
    
};
#define MAX_POJAZDOWVIP 11
new PojazdyDlaVip[MAX_POJAZDOWVIP][2] = {
	//MODEL | CENA PP
	{401, 900},
	{402, 900},
	{405, 900},
	{410, 900},
	{411, 1900},
	{412, 1000},
	{451, 1500},
	{482, 1000},
	{522, 1800},
	{559, 1000},
	{560, 1400}
};
new OgladaSkin[Sloty];
#define MAX_BINCO_SKIN 20
new skiny[MAX_BINCO_SKIN]=
{
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	9,
	10,
	11,
	12,
	13,
	14,
	15,
	21,
	22,
	23,
	24,
	25
};

new miesiace[12][64]=
{
	{"Stycznia"},
	{"Lutego"},
	{"Marca"},
	{"Kwietnia"},
	{"Maja"},
	{"Czerwca"},
	{"Lipca"},
	{"Sierpnia"},
	{"Wrzesnia"},
	{"Pazdziernika"},
	{"Listopada"},
	{"Grudnia"}
};
#define MAX_F_POJAZDY 23
new PojazdyFirm[MAX_F_POJAZDY][2] =
{
	{0, 0},
//Firmy
	{403, 100000},
	{514, 100000},
	{515, 110000},
	{584, 40000},
	{591, 40000},
	{435, 40000},
	{450, 40000},
	{413, 8000},
	{414, 7000},
	{440, 5000},
	{456, 8000},
	{459, 4000},
	{478, 600},
	{482, 90000},
//Policyjne
	{427, 10000},
	{490, 11000},
	{523, 1000},
	{598, 800},
	{599, 1500},
//Pogotowie
	{416, 1000},
//Pomoc Drogowa
	{525, 1000},
	{578, 1200}
};
new mandatod[Sloty];
new mandatkwota[Sloty];
new punktyilosc[Sloty];
new Text:Binco[2];
new Text:OgloszenieTD[Sloty];
new pokazywaneogloszenie[Sloty];
new ogloszenietimer[Sloty];
new ReklamaNum;
new wyswietlreklame=0;

enum EnumPrawkoPytania
{
	takietam,
	Pytanie[512],
	Prawidlowa,
}
#define MAX_PYTAN 9
new PrawkoPytania[MAX_PYTAN][EnumPrawkoPytania] =
{
	{0,"{FFFFFF}Jaki ruch obowi¹zuje na ulicach:\n{C0C0C0}Prawo stronny\n{C0C0C0}Lewo stronny\n{C0C0C0}Obojêtnie, byle nie potr¹ciæ nikogo", 1},
	{0,"{FFFFFF}Jakie œwiat³o sygnalizuje zmianê koloru œwiat³a:\n{C0C0C0}Zielone\n{C0C0C0}Czerwone\n{C0C0C0}¯ó³te", 3},
	{0,"{FFFFFF}W razie wypadku z rannymi zawiadomisz:\n{C0C0C0}Policjê\n{C0C0C0}Policjê i Pogotowie\n{C0C0C0}Pogotowie", 2},
	{0,"{FFFFFF}Policjant mo¿e zatrzymaæ prawo jazdy za pokwitowaniem, gdy:\n{C0C0C0}Przekroczyliœmy liczbe 24 punktów karnych\n{C0C0C0}Przejechaliœmy na czerwonym œwietle\n{C0C0C0}Jechaliœmy za szybko", 1},
	{0,"{FFFFFF}Na autostradzie dopuszczalna prêdkoœæ wynosi:\n{C0C0C0}100km/h\n{C0C0C0}120km/h\n{C0C0C0}140km/h", 3},
	{0,"{FFFFFF}Samochód osobowy to pojazd przeznaczony do:\n{C0C0C0}Przewozu wiecej ni¿ 9 osób\n{C0C0C0}Przewozu tylu osób ile jest siedzeñ\n{C0C0C0}Przewozu tylu osób ile jest ukazane w dowodzie rejestracyjnym",3},
	{0,"{FFFFFF}Gdy zauwa¿ysz pojazd uprzywilejowany, to:\n{C0C0C0}Zajade mu drogê\n{C0C0C0}U³atwiê mu przejazd\n{C0C0C0}Zignorujê go kompletnie",2},
	{0,"{FFFFFF}Odstêp od poprzedzaj¹cego samochodu powinien wynosiæ\n{C0C0C0}Co najmniej 10 metrów\n{C0C0C0}Bezpieczn¹ odleg³oœæ (nie ustalona)\n{C0C0C0}60 metrów za pojazdem",2},
	{0,"{FFFFFF}Podczas opadów deszczu, droga hamowania jest\n{C0C0C0}D³u¿sza od hamowania na œniegu\n{C0C0C0}Krótsza od hamowania na suchej jezdni\n{C0C0C0}Krótsza od hamowania na œniegu",3}
};

new ZdajeTeoria[MAX_PLAYERS];
new AktualnePytanie[MAX_PLAYERS];
new Bledow[MAX_PLAYERS];
new naglowek[128];
new ObiektyPraktyka[100];
new KoniecTrasy;
new iloscobiektow=-1;
new PojazdPraktyka=-1;
new ZdajePraktyke=-1;
new AtualnaTrasa=0;
#define VW_PRAWKA 50

new OdliczanieKtore=5;
new OdliczankoPrawko[6][10] =
{
    {"~w~START"},
    {"~r~1"},
    {"~y~2"},
    {"~g~3"},
    {"~g~4"},
	{"~g~5"}
};

new VehicleNames[212][] = {
	{"Landstalker"},{"Bravura"},{"Buffalo"},{"Linerunner"},{"Perrenial"},
	{"Sentinel"},{"Dumper"},{"Firetruck"},{"Trashmaster"},{"Stretch"},
	{"Manana"},{"Infernus"},{"Voodoo"},{"Pony"},{"Mule"},{"Cheetah"},
	{"Ambulance"},{"Leviathan"},{"Moonbeam"},{"Esperanto"}, {"Taxi"},
	{"Washington"},{"Bobcat"},{"Mr_Whoopee"},{"BF_Injection"},{"Hunter"},
	{"Premier"},{"Enforcer"},{"Securicar"},{"Banshee"},{"Predator"},
	{"Bus"},{"Rhino"},{"Barracks"},{"Hotknife"},{"Trailer 1"},{"Previon"},
	{"Coach"},{"Cabbie"},{"Stallion"},{"Rumpo"},{"RC_Bandit"},{"Romero"},
	{"Packer"},{"Monster"},{"Admiral"},{"Squalo"}, {"Seasparrow"},{"Pizzaboy"},
	{"Tram"},{"Trailer 2"},{"Turismo"},{"Speeder"},{"Reefer"},{"Tropic"},
	{"Flatbed"},{"Yankee"}, {"Caddy"},{"Solair"},{"Berkley's RC Van"},
	{"Skimmer"},{"PCJ-600"},{"Faggio"},{"Freeway"},{"RC Baron"},{"RC Raider"},
	{"Glendale"},{"Oceanic"}, {"Sanchez"},{"Sparrow"},{"Patriot"},{"Quad"},
	{"Coastguard"},{"Dinghy"},{"Hermes"},{"Sabre"},{"Rustler"},{"ZR-350"},
	{"Walton"},{"Regina"},{"Comet"},{"BMX"},{"Burrito"},{"Camper"},{"Marquis"},
	{"Baggage"},{"Dozer"},{"Maverick"},{"News Chopper"}, {"Rancher"},
	{"FBI_Rancher"},{"Virgo"},{"Greenwood"},{"Jetmax"},{"Hotring"},{"Sandking"},
	{"Blista_Compact"},{"Police Maverick"},{"Boxville"}, {"Benson"},{"Mesa"},
	{"RC Goblin"},{"Hotring Racer A"},{"Hotring Racer B"},{"Bloodring Banger"},
	{"Rancher"},{"Super GT"}, {"Elegant"},{"Journey"},{"Bike"},
	{"Mountain_Bike"},{"Beagle"},{"Cropdust"},{"Stunt"},{"Tanker"},
	{"Roadtrain"}, {"Nebula"},{"Majestic"},{"Buccaneer"},{"Shamal"},{"Hydra"},
	{"FCR-900"},{"NRG-500"},{"HPV1000"},{"Cement_Truck"},{"Tow Truck"},
	{"Fortune"},{"Cadrona"},{"FBI Truck"},{"Willard"},{"Forklift"},{"Tractor"},
	{"Combine"},{"Feltzer"},{"Remington"},{"Slamvan"}, {"Blade"},{"Freight"},
	{"Streak"},{"Vortex"},{"Vincent"},{"Bullet"},{"Clover"},{"Sadler"},
	{"Firetruck LA"},{"Hustler"},{"Intruder"}, {"Primo"},{"Cargobob"},
	{"Tampa"},{"Sunrise"},{"Merit"},{"Utility"},{"Nevada"},{"Yosemite"},
	{"Windsor"}, {"Monster A"},{"Monster B"},{"Uranus"},{"Jester"},{"Sultan"},
	{"Stratum"},{"Elegy"},{"Raindance"},{"RC Tiger"},{"Flash"},{"Tahoma"},
	{"Savanna"},{"Bandito"},{"Freight Flat"},{"Streak Carriage"},{"Kart"},
	{"Mower"},{"Duneride"},{"Sweeper"},{"Broadway"}, {"Tornado"},{"AT-400"},
	{"DFT-30"},{"Huntley"},{"Stafford"},{"BF-400"},{"Newsvan"},{"Tug"},
	{"Trailer 3"},{"Emperor"}, {"Wayfarer"},{"Euros"},{"Hotdog"},{"Club"},
	{"Freight Carriage"},{"Trailer 3"},{"Andromada"},{"Dodo"},{"RC Cam"},
	{"Launch"}, {"Police Car (LSPD)"},{"Police Car (SFPD)"},
	{"Police Car (LVPD)"},{"Police Ranger"},{"Picador"},{"S.W.A.T. Van"},
	{"Alpha"}, {"Phoenix"},{"Glendale"},{"Sadler"},{"Luggage Trailer A"},
	{"Luggage Trailer B"},{"Stair Trailer"},{"Boxville"}, {"Farm Plow"},
	{"Utility Trailer"}
};
//------------------------------------------------------------------------------
main() {
	printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	printf(" PTS v3.0 Beta (Inferno)");
	printf(" Load Statistic:");
	printf(" Load time %.4fs", fStartTime);
	printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
}
new bincoenter;
new bincoexit;
new naukajazdyenter;
new naukajazdyexit;
new naukajazdyplac;
new intpolwe;
new intpolwy;
new snwe;
new snwy;
new szpitalwe;
new szpitalwy;

//System bana
new PlayerIP[Sloty][MAX_PLAYER_IP];
enum EnumBanInfo
{
	id,
	BannedName[32],
	BannedIP[16],
	TimeEnd,
	TimeNalozony[128],
	AdminName[32],
	Reason[128]
}
new BanInfo[Sloty][EnumBanInfo];
new Text: BanTD[Sloty][6];

new bramawojsko1,
    bramawojsko2,
	bramawojsko3,

 	bramasg1,
    bramasg2,
    bramasg3,
    bramasg4,
    bramasg5,
    bramasg6,

    bramalvlot,
    bramasflot,
    bramalslot;

forward RefreshCars();
forward Global();
forward OnPlayerUpdateEx(playerid);
forward ToLog(string[], ...);

public OnGameModeInit()
{
    new str[60];
    format(str,sizeof(str),"mapname %s",INFO_MAPNAME);
    SendRconCommand(str);//zmienia nazwe mapname
	new szString[128];

	ManualVehicleEngineAndLights();
	
	CreateDynamic3DTextLabel("Salon Samochodowy\n"C_ZIELONY"/salon", 0x00C6FFFF, 1291.0306,-1866.4099,13.5469, 20.0);
	CreateDynamic3DTextLabel("Nauka Jazdy\n"C_ZIELONY"/prawko", 0x00C6FFFF, 1172.6592, 1354.5636, 10.9219, 20.0);
	
	salon = CreateDynamicPickup(19197, 23, 1291.0306,-1866.4099,13.5469);
	saloncar = CreateVehicle(403,1296.1188,-1874.8885,13.3112,291.1050, -1, -1, -1);
	SetVehicleVirtualWorld(saloncar, 99999);
	
	CreateDynamicMapIcon(1656.4442, 1733.3796, 10.8281, 45, KOLOR_CZERWONY, 0, -1, -1, 100000000.0);
	
	bincoenter = CreateDynamicPickup(19197, 23, 1656.4442, 1733.3796, 10.8281, 0, 0);
	bincoexit = CreateDynamicPickup(19197, 23, 207.6924, -110.4737, 1005.1328, 0, 15);
	
	naukajazdyenter = CreateDynamicPickup(19197, 23, 1168.69995117,1361.50000000,10.60000038, 0, 0);
	naukajazdyexit = CreateDynamicPickup(19197, 23, 1168.69921875,1364.79980469,10.50000000, 0, 0);
	naukajazdyplac = CreateDynamicPickup(19197, 23, 1165.57, 1344.31, 10.80, 0, 0);
	CreateDynamicObject(1569, 1167.81, 1363.02, 9.82,   0.00, 0.00, 0.00); //drzwi blokuj¹ce wejœcie :D
	
	intpolwe = CreateDynamicPickup(19197, 23, 1475.19995117,-1360.69995117,11.30000019, 0, 0);
	intpolwy = CreateDynamicPickup(19197, 23, 1470.69995117,-1356.00000000,151.80000305, 0, 0);
	snwe = CreateDynamicPickup(19197, 23, 1283.59997559,-1160.50000000,23.29999924, 0, 0);
	snwy = CreateDynamicPickup(19197, 23, 1283.69995117,-1189.30004883,47.29999924, 0, 0);
	szpitalwe = CreateDynamicPickup(19197, 23, -2647.39990234,695.40002441,27.29999924, 0, 0);
	szpitalwy = CreateDynamicPickup(19197, 23, -2636.19995117,691.70001221,50.20000076, 0, 0);



	CreateDynamic3DTextLabel("Centrala ³adunków Doki (SF)\n"C_SZARY"Aby za³adowaæ musisz byæ w pojeŸdzie!\n"C_ZIELONY"/zlecenie", 0x15de00FF, -1733.7379,40.8773,3.6547, 20.0);
	CreateDynamicPickup(1274, 23, -1733.7379,40.8773,3.5547); // SF
	CreateDynamic3DTextLabel("Centrala ³adunków Kopalnia\n"C_SZARY"Aby za³adowaæ musisz byæ w pojeŸdzie!\n"C_ZIELONY"/zlecenie", 0x15de00FF, 373.5872,984.9277,30.0430, 20.0);
	CreateDynamicPickup(1274, 23, 373.5872,984.9277,30.0430); // Kopalnia
	
	CreateDynamic3DTextLabel("Sklep Binco\n"C_SZARY"Aby siê przebraæ wpisz /sklep!", 0x15de00FF, 217.7649, -98.6183, 1005.2578, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 15);
	

	zaladunekcp = CreateDynamicCP(-1691.9437,29.6827,3.5446, 5.0);
	
	CreateDynamicObject(1044, -1996.30, 135.33, 29.09,   90.00, 0.00, 357.62);
	CreateDynamicObject(1044, -1996.31, 138.11, 27.65,   90.00, 0.00, 0.00);
	CreateDynamicObject(1044, -1996.31, 138.07, 29.09,   90.00, 0.00, 357.62);
	CreateDynamicObject(1044, -1996.32, 135.37, 27.65,   90.00, 0.00, 0.00);
	
	SetObjectMaterialText(CreateObject(19353, -1996.31, 136.58, 31.25,   0.00, 0.00, 0.00), "Salon Samochodowy ==>", 0, 140, "Arial", 40, 0, -32256, -16777216, 1);

	mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_DB, MYSQL_PASS);
	
	if(mysql_ping() == -1)
	{
	    printf("[DataBase]Error 001: b³¹d przy ³¹czeniu z baz¹ danych.");
	    SendRconCommand("exit");
	}
	else
	{
	    printf("[DataBase]: Pomyœlnie po³¹czono z baz¹ danych.");
	}

	SetGameModeText(GM_TEXT);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	UsePlayerPedAnims();
	ShowNameTags(0);
	ShowPlayerMarkers(0);

	iTick = tickcount();
	
	CarLoop(i) {
		VehicleInfo[i][uid] = 0;
	}

	PenaltyAnnouce = TextDrawCreate(10.000000, 290.000000, " ");
	TextDrawBackgroundColor(PenaltyAnnouce, 255);
	TextDrawFont(PenaltyAnnouce, 1);
	TextDrawLetterSize(PenaltyAnnouce, 0.319999, 1.100000);
	TextDrawColor(PenaltyAnnouce, -1);
	TextDrawSetOutline(PenaltyAnnouce, 1);
	TextDrawSetProportional(PenaltyAnnouce, 1);
	
	Salon[0] = TextDrawCreate(320.000000, 433.000000, "~r~Cena ~w~30 000$    ~r~Pakownosc ~w~0    ~r~Waga ~w~4.5t~n~~n~~n~");
	TextDrawAlignment(Salon[0], 2);
	TextDrawBackgroundColor(Salon[0], 255);
	TextDrawFont(Salon[0], 1);
	TextDrawLetterSize(Salon[0], 0.200000, 1.000000);
	TextDrawColor(Salon[0], -1);
	TextDrawSetOutline(Salon[0], 1);
	TextDrawSetProportional(Salon[0], 1);
	TextDrawUseBox(Salon[0], 1);
	TextDrawBoxColor(Salon[0], 60);
	TextDrawTextSize(Salon[0], 0.000000, 640.000000);

	Salon[1] = TextDrawCreate(318.000000, 417.000000, "~<~ SPACJA ~>~");
	TextDrawBackgroundColor(Salon[1], 60);
	TextDrawAlignment(Salon[1], 2);
	TextDrawFont(Salon[1], 1);
	TextDrawLetterSize(Salon[1], 0.300000, 1.000000);
	TextDrawColor(Salon[1], -1);
	TextDrawSetOutline(Salon[1], 1);
	TextDrawSetProportional(Salon[1], 1);
	
	Binco[0] = TextDrawCreate(320.000000, 433.000000, "~r~Cena ~w~30 000$");
	TextDrawAlignment(Salon[0], 2);
	TextDrawBackgroundColor(Salon[0], 255);
	TextDrawFont(Salon[0], 1);
	TextDrawLetterSize(Salon[0], 0.200000, 1.000000);
	TextDrawColor(Salon[0], -1);
	TextDrawSetOutline(Salon[0], 1);
	TextDrawSetProportional(Salon[0], 1);
	TextDrawUseBox(Salon[0], 1);
	TextDrawBoxColor(Salon[0], 60);
	TextDrawTextSize(Salon[0], 0.000000, 640.000000);

	Binco[1] = TextDrawCreate(318.000000, 417.000000, "Uzyj Q i E by zmieniac skin oraz Y by zatwierdzic.");
	TextDrawBackgroundColor(Salon[1], 60);
	TextDrawAlignment(Salon[1], 2);
	TextDrawFont(Salon[1], 1);
	TextDrawLetterSize(Salon[1], 0.300000, 1.000000);
	TextDrawColor(Salon[1], -1);
	TextDrawSetOutline(Salon[1], 1);
	TextDrawSetProportional(Salon[1], 1);

	Salon[2] = TextDrawCreate(317.000000, 402.000000, "Tanker");
	TextDrawAlignment(Salon[2], 2);
	TextDrawBackgroundColor(Salon[2], 255);
	TextDrawFont(Salon[2], 1);
	TextDrawLetterSize(Salon[2], 0.500000, 1.800000);
	TextDrawColor(Salon[2], -1);
	TextDrawSetOutline(Salon[2], 1);
	TextDrawSetProportional(Salon[2], 1);

	format(szString, sizeof(szString), "%s", WEB_URL);
	bulidInfo = TextDrawCreate(2.000000, 438.000000, szString);
	TextDrawBackgroundColor(bulidInfo, 255);
	TextDrawFont(bulidInfo, 2);
	TextDrawLetterSize(bulidInfo, 0.300000, 1.000000);
	TextDrawColor(bulidInfo, -196);
	TextDrawSetOutline(bulidInfo, 0);
	TextDrawSetProportional(bulidInfo, 1);
	TextDrawSetShadow(bulidInfo, 0);

	Box[0] = TextDrawCreate(320.000000, 337.000000, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
	TextDrawAlignment(Box[0], 2);
	TextDrawBackgroundColor(Box[0], 255);
	TextDrawFont(Box[0], 0);
	TextDrawLetterSize(Box[0], 1.000000, 3.300000);
	TextDrawColor(Box[0], -1);
	TextDrawSetOutline(Box[0], 0);
	TextDrawSetProportional(Box[0], 1);
	TextDrawSetShadow(Box[0], 1);
	TextDrawUseBox(Box[0], 1);
	TextDrawBoxColor(Box[0], 255);
	TextDrawTextSize(Box[0], 0.000000, 640.000000);

	Box[1] 						=TextDrawCreate(650.000000, 0.000000, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
	TextDrawBackgroundColor		(Box[1], 255);
	TextDrawFont				(Box[1], 1);
	TextDrawLetterSize			(Box[1], 0.500000, 1.000000);
	TextDrawColor				(Box[1], -1);
	TextDrawSetOutline			(Box[1], 0);
	TextDrawSetProportional		(Box[1], 1);
	TextDrawSetShadow			(Box[1], 1);
	TextDrawUseBox				(Box[1], 1);
	TextDrawBoxColor			(Box[1], 255);
	TextDrawTextSize			(Box[1], -10.000000, 10.000000);
	
	godzinaserver 				=TextDrawCreate(547.000000, 21.000000, "15:00");
	TextDrawBackgroundColor		(godzinaserver, 255);
	TextDrawFont				(godzinaserver, 3);
	TextDrawLetterSize			(godzinaserver, 0.629999, 2.400000);
	TextDrawColor				(godzinaserver, -1);
	TextDrawSetOutline			(godzinaserver, 1);
	TextDrawSetProportional		(godzinaserver, 1);

	data 						=TextDrawCreate(577.000000, 43.000000, "19 czerwca");
	TextDrawAlignment			(data, 2);
	TextDrawBackgroundColor		(data, 255);
	TextDrawFont				(data, 3);
	TextDrawLetterSize			(data, 0.280000, 1.000000);
	TextDrawColor				(data, -1);
	TextDrawSetOutline			(data, 1);
	TextDrawSetProportional		(data, 1);

	godzinaswiat 				=TextDrawCreate(577.000000, 53.000000, "23:21");
	TextDrawAlignment			(godzinaswiat, 2);
	TextDrawBackgroundColor		(godzinaswiat, 255);
	TextDrawFont				(godzinaswiat, 3);
	TextDrawLetterSize			(godzinaswiat, 0.300000, 1.000000);
	TextDrawColor				(godzinaswiat, -1);
	TextDrawSetOutline			(godzinaswiat, 1);
	TextDrawSetProportional		(godzinaswiat, 1);
	
	BincoTD[0]					=TextDrawCreate(-10.000000, 430.000000, "~n~~n~");
	TextDrawBackgroundColor		(BincoTD[0], 255);
	TextDrawFont				(BincoTD[0], 1);
	TextDrawLetterSize			(BincoTD[0], 0.500000, 1.000000);
	TextDrawColor				(BincoTD[0], -1);
	TextDrawSetOutline			(BincoTD[0], 0);
	TextDrawSetProportional		(BincoTD[0], 1);
	TextDrawSetShadow			(BincoTD[0], 1);
	TextDrawUseBox				(BincoTD[0], 1);
	TextDrawBoxColor			(BincoTD[0], 96);
	TextDrawTextSize			(BincoTD[0], 650.000000, 0.000000);

	BincoTD[1]					=TextDrawCreate(315.000000, 433.000000, "Uzyj LPM lub PPM by zmienic skin oraz C by zaakceptowac i kupic skina.");
	TextDrawAlignment			(BincoTD[1], 2);
	TextDrawBackgroundColor		(BincoTD[1], 255);
	TextDrawFont				(BincoTD[1], 1);
	TextDrawLetterSize			(BincoTD[1], 0.230000, 1.200000);
	TextDrawColor				(BincoTD[1], -1);
	TextDrawSetOutline			(BincoTD[1], 1);
	TextDrawSetProportional		(BincoTD[1], 1);
	
	CarStatus3 					=TextDrawCreate(481.000000, 200.000000, ".");
	TextDrawBackgroundColor		(CarStatus3, 50);
	TextDrawFont				(CarStatus3, 1);
	TextDrawLetterSize			(CarStatus3, 14.910019, 28.300001);
	TextDrawColor				(CarStatus3, 50);
	TextDrawSetOutline			(CarStatus3, 0);
	TextDrawSetProportional		(CarStatus3, 1);
	TextDrawSetShadow			(CarStatus3, 1);
	
	CarStatus4 					=TextDrawCreate(196.000000, 200.000000, ".");
	TextDrawBackgroundColor		(CarStatus4, 50);
	TextDrawFont				(CarStatus4, 1);
	TextDrawLetterSize			(CarStatus4, 30.180080, 28.300001);
	TextDrawColor				(CarStatus4, 50);
	TextDrawSetOutline			(CarStatus4, 0);
	TextDrawSetProportional		(CarStatus4, 1);
	TextDrawSetShadow			(CarStatus4, 1);
	
	for(new i=0; i<Sloty; i++)
	{
		LadowanieBar[i] 			=CreateProgressBar(219.00, 140.00, 205.50, 2.50, 731250687, 100.0);

		CarStatus[i] 				=TextDrawCreate(523.000000, 382.000000, "~r~Paliwo ~w~0l~n~~g~Predkosc ~w~0km/h");
		TextDrawBackgroundColor		(CarStatus[i], 255);
		TextDrawFont				(CarStatus[i], 2);
		TextDrawLetterSize			(CarStatus[i], 0.179999, 0.899999);
		TextDrawColor				(CarStatus[i], -1);
		TextDrawSetOutline			(CarStatus[i], 1);
		TextDrawSetProportional		(CarStatus[i], 1);

		CarStatus2[i] 				=TextDrawCreate(279.000000, 366.000000, "~n~ Wczytywanie.. ~n~");
		TextDrawBackgroundColor		(CarStatus2[i], 255);
		TextDrawFont				(CarStatus2[i], 2);
		TextDrawLetterSize			(CarStatus2[i], 0.179999, 0.899999);
		TextDrawColor				(CarStatus2[i], -1);
		TextDrawSetOutline			(CarStatus2[i], 1);
		TextDrawSetProportional		(CarStatus2[i], 1);
		
		OgloszenieTD[i] 			=TextDrawCreate(499.000000, 243.000000, "Witaj na PTS. Prosze sie zalogowac a w razie problemow zapraszamy na nasze forum www.Hard-Truck.pl");
		TextDrawBackgroundColor		(OgloszenieTD[i], 255);
		TextDrawFont				(OgloszenieTD[i], 1);
		TextDrawLetterSize			(OgloszenieTD[i], 0.159999, 1.100000);
		TextDrawColor				(OgloszenieTD[i], -1);
		TextDrawSetOutline			(OgloszenieTD[i], 1);
		TextDrawSetProportional		(OgloszenieTD[i], 1);
		TextDrawUseBox				(OgloszenieTD[i], 1);
		TextDrawBoxColor			(OgloszenieTD[i], 64);
		TextDrawTextSize			(OgloszenieTD[i], 625.000000, 0.000000);
		
		BanTD[i][0]					=TextDrawCreate(0.000000, 1.000000, "  ~n~   ~n~");
		TextDrawBackgroundColor		(BanTD[i][0], 255);
		TextDrawFont				(BanTD[i][0], 1);
		TextDrawLetterSize			(BanTD[i][0], 0.500000, 24.900003);
		TextDrawColor				(BanTD[i][0], -1);
		TextDrawSetOutline			(BanTD[i][0], 0);
		TextDrawSetProportional		(BanTD[i][0], 1);
		TextDrawSetShadow			(BanTD[i][0], 1);
		TextDrawUseBox				(BanTD[i][0], 1);
		TextDrawBoxColor			(BanTD[i][0], 255);
		TextDrawTextSize			(BanTD[i][0], 641.000000, 0.000000);

		BanTD[i][1]					=TextDrawCreate(180.000000, 127.000000, " ~n~  ~n~");
		TextDrawBackgroundColor		(BanTD[i][1], 255);
		TextDrawFont				(BanTD[i][1], 1);
		TextDrawLetterSize			(BanTD[i][1], 0.500000, 12.000000);
		TextDrawColor				(BanTD[i][1], -1);
		TextDrawSetOutline			(BanTD[i][1], 0);
		TextDrawSetProportional		(BanTD[i][1], 1);
		TextDrawSetShadow			(BanTD[i][1], 1);
		TextDrawUseBox				(BanTD[i][1], 1);
		TextDrawBoxColor			(BanTD[i][1], 1886417151);
		TextDrawTextSize			(BanTD[i][1], 465.000000, 0.000000);

		BanTD[i][2]					=TextDrawCreate(319.000000, 132.000000, "~r~Zostales zbanowany/a!");
		TextDrawAlignment			(BanTD[i][2], 2);
		TextDrawBackgroundColor		(BanTD[i][2], 255);
		TextDrawFont				(BanTD[i][2], 1);
		TextDrawLetterSize			(BanTD[i][2], 0.500000, 2.300000);
		TextDrawColor				(BanTD[i][2], -1);
		TextDrawSetOutline			(BanTD[i][2], 1);
		TextDrawSetProportional		(BanTD[i][2], 1);

		BanTD[i][3]					=TextDrawCreate(201.000000, 170.000000, "~y~Twoj nick: ~w~Inferno~n~~y~Twoje IP: ~w~1.3.4.5~n~~y~Admin: ~w~Lusan~n~~y~Data nalozenia: ~w~data~n~~y~Do kiedy: ~w~data");
		TextDrawBackgroundColor		(BanTD[i][3], 255);
		TextDrawFont				(BanTD[i][3], 1);
		TextDrawLetterSize			(BanTD[i][3], 0.400000, 1.400000);
		TextDrawColor				(BanTD[i][3], -1);
		TextDrawSetOutline			(BanTD[i][3], 1);
		TextDrawSetProportional		(BanTD[i][3], 1);

		BanTD[i][4]					=TextDrawCreate(235.000000, 262.000000, "~r~Powod podany przez Administratora:");
		TextDrawBackgroundColor		(BanTD[i][4], 255);
		TextDrawFont				(BanTD[i][4], 1);
		TextDrawLetterSize			(BanTD[i][4], 0.270000, 1.299999);
		TextDrawColor				(BanTD[i][4], -1);
		TextDrawSetOutline			(BanTD[i][4], 1);
		TextDrawSetProportional		(BanTD[i][4], 1);

		BanTD[i][5]					=TextDrawCreate(218.000000, 281.000000, "Oto jest testowy ban jaki mogl podac administrator podczas banowania gracza.");
		TextDrawBackgroundColor		(BanTD[i][5], 255);
		TextDrawFont				(BanTD[i][5], 1);
		TextDrawLetterSize			(BanTD[i][5], 0.240000, 1.000000);
		TextDrawColor				(BanTD[i][5], -1);
		TextDrawSetOutline			(BanTD[i][5], 0);
		TextDrawSetProportional		(BanTD[i][5], 1);
		TextDrawSetShadow			(BanTD[i][5], 1);
		TextDrawUseBox				(BanTD[i][5], 1);
		TextDrawBoxColor			(BanTD[i][5], 0);
		TextDrawTextSize			(BanTD[i][5], 425.000000, 0.000000);
	}
	
	SetTimer("Global", 1000, 1);
	//SetTimer("RefreshCars", 10000, 1);
	
	for(new n=0; n != MAX_PRIVATE_VEHICLES; n++)
	{
	    VehicleInfo[n][gtauid]=-1;
	}
	for(new n=0; n != MAX_STACJI; n++)
	{
		format(dstring, sizeof(dstring), ""C_NIEBIESKI"Stacja Benzynowa\n"C_BEZOWY"Cena: "C_ZIELONY"%.2f"C_BEZOWY"$/L\n"C_ZOLTY"/stacja",Stacje[n][Cena]);
	    CreateDynamic3DTextLabel(dstring, KOLOR_ZIELONY, Stacje[n][SX], Stacje[n][SY], Stacje[n][SZ], 100.000);
	}
	
	for(new i = 0;i<Sloty;i++)
	{
	    if(IsPlayerConnected(i))
	    {
		    new query[128],username[32];
		    mysql_real_escape_string(username,username);
		    format(query,sizeof query,"UPDATE `sat_gpos` SET `active` = 1 WHERE `username` = '%username'",username);
		    mysql_query(query);
	    }
	}
	SetTimer("UpdatePlayerPositions",TIMER_INTERVAL,true);
	
	LadujBramy();
	LoadVehicles();
	LoadCargos();
	LoadFrakcje();
	LoadLoadings();
	fStartTime = (tickcount()-iTick)/1000.0;
	return 1;
}

#define NONE 0
#define GAZ 1
#define PALIWO 2
stock GetVehicleFuelType(vehmodel) {
	if(vehmodel == 400) return PALIWO;
	else if(vehmodel == 401) return PALIWO;
	else if(vehmodel == 402) return PALIWO;
	else if(vehmodel == 403) return PALIWO;
	else if(vehmodel == 404) return PALIWO;
	else if(vehmodel == 405) return PALIWO;
	else if(vehmodel == 406) return PALIWO;
	else if(vehmodel == 407) return PALIWO;
	else if(vehmodel == 408) return PALIWO;
	else if(vehmodel == 409) return PALIWO;
	else if(vehmodel == 410) return PALIWO;
	else if(vehmodel == 411) return PALIWO;
	else if(vehmodel == 412) return PALIWO;
	else if(vehmodel == 413) return PALIWO;
	else if(vehmodel == 414) return PALIWO;
	else if(vehmodel == 415) return PALIWO;
	else if(vehmodel == 416) return PALIWO;
	else if(vehmodel == 417) return PALIWO;
	else if(vehmodel == 418) return PALIWO;
	else if(vehmodel == 419) return PALIWO;
	else if(vehmodel == 420) return PALIWO;
	else if(vehmodel == 421) return PALIWO;
	else if(vehmodel == 422) return PALIWO;
	else if(vehmodel == 423) return PALIWO;
	else if(vehmodel == 424) return PALIWO;
	else if(vehmodel == 425) return PALIWO;
	else if(vehmodel == 426) return PALIWO;
	else if(vehmodel == 427) return PALIWO;
	else if(vehmodel == 428) return PALIWO;
	else if(vehmodel == 429) return PALIWO;
	else if(vehmodel == 430) return PALIWO;
	else if(vehmodel == 431) return PALIWO;
	else if(vehmodel == 432) return PALIWO;
	else if(vehmodel == 433) return PALIWO;
	else if(vehmodel == 434) return PALIWO;
	else if(vehmodel == 435) return PALIWO;
	else if(vehmodel == 436) return PALIWO;
	else if(vehmodel == 437) return PALIWO;
	else if(vehmodel == 438) return PALIWO;
	else if(vehmodel == 439) return PALIWO;
	else if(vehmodel == 440) return PALIWO;
	else if(vehmodel == 441) return NONE;
	else if(vehmodel == 442) return PALIWO;
	else if(vehmodel == 443) return PALIWO;
	else if(vehmodel == 444) return PALIWO;
	else if(vehmodel == 445) return PALIWO;
	else if(vehmodel == 446) return PALIWO;
	else if(vehmodel == 447) return PALIWO;
	else if(vehmodel == 448) return PALIWO;
	else if(vehmodel == 449) return NONE;
	else if(vehmodel == 450) return NONE;
	else if(vehmodel == 451) return PALIWO;
	else if(vehmodel == 452) return PALIWO;
	else if(vehmodel == 453) return PALIWO;
	else if(vehmodel == 454) return PALIWO;
	else if(vehmodel == 455) return PALIWO;
	else if(vehmodel == 456) return PALIWO;
	else if(vehmodel == 457) return PALIWO;
	else if(vehmodel == 458) return PALIWO;
	else if(vehmodel == 459) return PALIWO;
	else if(vehmodel == 460) return PALIWO;
	else if(vehmodel == 461) return PALIWO;
	else if(vehmodel == 462) return PALIWO;
	else if(vehmodel == 463) return PALIWO;
	else if(vehmodel == 464) return NONE;
	else if(vehmodel == 465) return NONE;
	else if(vehmodel == 466) return PALIWO;
	else if(vehmodel == 467) return PALIWO;
	else if(vehmodel == 468) return PALIWO;
	else if(vehmodel == 469) return PALIWO;
	else if(vehmodel == 470) return PALIWO;
	else if(vehmodel == 471) return PALIWO;
	else if(vehmodel == 472) return PALIWO;
	else if(vehmodel == 473) return PALIWO;
	else if(vehmodel == 474) return PALIWO;
	else if(vehmodel == 475) return PALIWO;
	else if(vehmodel == 476) return PALIWO;
	else if(vehmodel == 477) return PALIWO;
	else if(vehmodel == 478) return PALIWO;
	else if(vehmodel == 479) return PALIWO;
	else if(vehmodel == 480) return PALIWO;
	else if(vehmodel == 481) return NONE;
	else if(vehmodel == 482) return PALIWO;
	else if(vehmodel == 483) return PALIWO;
	else if(vehmodel == 484) return PALIWO;
	else if(vehmodel == 485) return PALIWO;
	else if(vehmodel == 486) return PALIWO;
	else if(vehmodel == 487) return PALIWO;
	else if(vehmodel == 488) return PALIWO;
	else if(vehmodel == 489) return PALIWO;
	else if(vehmodel == 490) return PALIWO;
	else if(vehmodel == 491) return PALIWO;
	else if(vehmodel == 492) return PALIWO;
	else if(vehmodel == 493) return PALIWO;
	else if(vehmodel == 494) return PALIWO;
	else if(vehmodel == 495) return PALIWO;
	else if(vehmodel == 496) return PALIWO;
	else if(vehmodel == 497) return PALIWO;
	else if(vehmodel == 498) return PALIWO;
	else if(vehmodel == 499) return PALIWO;
	else if(vehmodel == 500) return PALIWO;
	else if(vehmodel == 501) return NONE;
	else if(vehmodel == 502) return PALIWO;
	else if(vehmodel == 503) return PALIWO;
	else if(vehmodel == 504) return PALIWO;
	else if(vehmodel == 505) return PALIWO;
	else if(vehmodel == 506) return PALIWO;
	else if(vehmodel == 507) return PALIWO;
	else if(vehmodel == 508) return PALIWO;
	else if(vehmodel == 509) return NONE;
	else if(vehmodel == 510) return NONE;
	else if(vehmodel == 511) return 210;
	else if(vehmodel == 512) return 130;
	else if(vehmodel == 513) return 54;
	else if(vehmodel == 514) return 300;
	else if(vehmodel == 515) return 300;
	else if(vehmodel == 516) return 63;
	else if(vehmodel == 517) return 64;
	else if(vehmodel == 518) return 67;
	else if(vehmodel == 519) return 300;
	else if(vehmodel == 520) return 290;
	else if(vehmodel == 521) return 35;
	else if(vehmodel == 522) return 35;
	else if(vehmodel == 523) return 121;
	else if(vehmodel == 524) return 91;
	else if(vehmodel == 525) return 65;
	else if(vehmodel == 526) return 63;
	else if(vehmodel == 527) return 71;
	else if(vehmodel == 528) return 71;
	else if(vehmodel == 529) return 67;
	else if(vehmodel == 530) return 12;
	else if(vehmodel == 531) return 21;
	else if(vehmodel == 532) return 36;
	else if(vehmodel == 533) return 61;
	else if(vehmodel == 534) return 71;
	else if(vehmodel == 535) return 85;
	else if(vehmodel == 536) return 69;
	else if(vehmodel == 537) return NONE;
	else if(vehmodel == 538) return NONE;
	else if(vehmodel == 539) return 33;
	else if(vehmodel == 540) return 60;
	else if(vehmodel == 541) return 71;
	else if(vehmodel == 542) return 69;
	else if(vehmodel == 543) return 60;
	else if(vehmodel == 544) return 120;
	else if(vehmodel == 545) return 74;
	else if(vehmodel == 546) return 64;
	else if(vehmodel == 547) return 67;
	else if(vehmodel == 548) return 210;
	else if(vehmodel == 549) return 71;
	else if(vehmodel == 550) return 64;
	else if(vehmodel == 551) return 64;
	else if(vehmodel == 552) return 68;
	else if(vehmodel == 553) return 330;
	else if(vehmodel == 554) return 81;
	else if(vehmodel == 555) return 61;
	else if(vehmodel == 556) return 123;
	else if(vehmodel == 557) return 124;
	else if(vehmodel == 558) return 61;
	else if(vehmodel == 559) return 63;
	else if(vehmodel == 560) return 71;
	else if(vehmodel == 561) return 74;
	else if(vehmodel == 562) return 66;
	else if(vehmodel == 563) return 210;
	else if(vehmodel == 564) return NONE;
	else if(vehmodel == 565) return 57;
	else if(vehmodel == 566) return 65;
	else if(vehmodel == 567) return 66;
	else if(vehmodel == 568) return 45;
	else if(vehmodel == 569) return NONE;
	else if(vehmodel == 570) return NONE;
	else if(vehmodel == 571) return 10;
	else if(vehmodel == 572) return 10;
	else if(vehmodel == 573) return 121;
	else if(vehmodel == 574) return 21;
	else if(vehmodel == 575) return 71;
	else if(vehmodel == 576) return 75;
	else if(vehmodel == 577) return 900;
	else if(vehmodel == 578) return 210;
	else if(vehmodel == 579) return 85;
	else if(vehmodel == 580) return 80;
	else if(vehmodel == 581) return 31;
	else if(vehmodel == 582) return 81;
	else if(vehmodel == 583) return 20;
	else if(vehmodel == 584) return NONE;
	else if(vehmodel == 585) return 64;
	else if(vehmodel == 586) return 30;
	else if(vehmodel == 587) return 66;
	else if(vehmodel == 588) return 79;
	else if(vehmodel == 589) return 59;
	else if(vehmodel == 590) return NONE;
	else if(vehmodel == 591) return NONE;
	else if(vehmodel == 592) return NONE;
	else if(vehmodel == 593) return 110;
	else if(vehmodel == 594) return NONE;
	else if(vehmodel == 595) return 151;
	else if(vehmodel == 596) return 89;
	else if(vehmodel == 597) return 89;
	else if(vehmodel == 598) return 89;
	else if(vehmodel == 599) return 94;
	else if(vehmodel == 600) return 61;
	else if(vehmodel == 601) return 120;
	else if(vehmodel == 602) return 61;
	else if(vehmodel == 603) return 59;
	else if(vehmodel == 604) return 91;
	else if(vehmodel == 605) return 64;
	else if(vehmodel == 606) return NONE;
	else if(vehmodel == 607) return NONE;
	else if(vehmodel == 608) return NONE;
	else if(vehmodel == 609) return PALIWO;
	else if(vehmodel == 610) return NONE;
	else if(vehmodel == 611) return NONE;
	else return NONE;
}

stock GetVehicleMaxFuel(vehmodel) {
	if(vehmodel == 400) return 70;
	else if(vehmodel == 401) return 52;
	else if(vehmodel == 402) return 60;
	else if(vehmodel == 403) return 400;
	else if(vehmodel == 404) return 50;
	else if(vehmodel == 405) return 52;
	else if(vehmodel == 406) return 150;
	else if(vehmodel == 407) return 250;
	else if(vehmodel == 408) return 150;
	else if(vehmodel == 409) return 110;
	else if(vehmodel == 410) return 66;
	else if(vehmodel == 411) return 66;
	else if(vehmodel == 412) return 52;
	else if(vehmodel == 413) return 80;
	else if(vehmodel == 414) return 120;
	else if(vehmodel == 415) return 76;
	else if(vehmodel == 416) return 120;
	else if(vehmodel == 417) return 408;
	else if(vehmodel == 418) return 80;
	else if(vehmodel == 419) return 72;
	else if(vehmodel == 420) return 80;
	else if(vehmodel == 421) return 82;
	else if(vehmodel == 422) return 80;
	else if(vehmodel == 423) return 90;
	else if(vehmodel == 424) return 30;
	else if(vehmodel == 425) return 500;
	else if(vehmodel == 426) return 70;
	else if(vehmodel == 427) return 120;
	else if(vehmodel == 428) return 120;
	else if(vehmodel == 429) return 68;
	else if(vehmodel == 430) return 220;
	else if(vehmodel == 431) return 315;
	else if(vehmodel == 432) return 1020;
	else if(vehmodel == 433) return 430;
	else if(vehmodel == 434) return 30;
	else if(vehmodel == 435) return 0;
	else if(vehmodel == 436) return 60;
	else if(vehmodel == 437) return 310;
	else if(vehmodel == 438) return 80;
	else if(vehmodel == 439) return 72;
	else if(vehmodel == 440) return 80;
	else if(vehmodel == 441) return 0;
	else if(vehmodel == 442) return 61;
	else if(vehmodel == 443) return 180;
	else if(vehmodel == 444) return 162;
	else if(vehmodel == 445) return 56;
	else if(vehmodel == 446) return 101;
	else if(vehmodel == 447) return 140;
	else if(vehmodel == 448) return 7;
	else if(vehmodel == 449) return 0;
	else if(vehmodel == 450) return 0 ;
	else if(vehmodel == 451) return 78;
	else if(vehmodel == 452) return 111;
	else if(vehmodel == 453) return 201;
	else if(vehmodel == 454) return 221;
	else if(vehmodel == 455) return 198;
	else if(vehmodel == 456) return 101;
	else if(vehmodel == 457) return 15;
	else if(vehmodel == 458) return 70;
	else if(vehmodel == 459) return 84;
	else if(vehmodel == 460) return 30;
	else if(vehmodel == 461) return 25;
	else if(vehmodel == 462) return 7;
	else if(vehmodel == 463) return 30;
	else if(vehmodel == 464) return 0;
	else if(vehmodel == 465) return 0;
	else if(vehmodel == 466) return 71;
	else if(vehmodel == 467) return 61;
	else if(vehmodel == 468) return 27;
	else if(vehmodel == 469) return 50;
	else if(vehmodel == 470) return 110;
	else if(vehmodel == 471) return 35;
	else if(vehmodel == 472) return 110;
	else if(vehmodel == 473) return 69;
	else if(vehmodel == 474) return 70;
	else if(vehmodel == 475) return 71 ;
	else if(vehmodel == 476) return 68;
	else if(vehmodel == 477) return 69;
	else if(vehmodel == 478) return 45;
	else if(vehmodel == 479) return 61;
	else if(vehmodel == 480) return 67;
	else if(vehmodel == 481) return 0;
	else if(vehmodel == 482) return 96;
	else if(vehmodel == 483) return 75;
	else if(vehmodel == 484) return 87;
	else if(vehmodel == 485) return 40;
	else if(vehmodel == 486) return 141;
	else if(vehmodel == 487) return 123;
	else if(vehmodel == 488) return 121;
	else if(vehmodel == 489) return 91;
	else if(vehmodel == 490) return 101;
	else if(vehmodel == 491) return 81;
	else if(vehmodel == 492) return 62;
	else if(vehmodel == 493) return 130;
	else if(vehmodel == 494) return 99;
	else if(vehmodel == 495) return 81;
	else if(vehmodel == 496) return 61;
	else if(vehmodel == 497) return 140;
	else if(vehmodel == 498) return 121;
	else if(vehmodel == 499) return 104;
	else if(vehmodel == 500) return 71;
	else if(vehmodel == 501) return 0;
	else if(vehmodel == 502) return 96;
	else if(vehmodel == 503) return 97;
	else if(vehmodel == 504) return 91;
	else if(vehmodel == 505) return 84;
	else if(vehmodel == 506) return 67;
	else if(vehmodel == 507) return 81;
	else if(vehmodel == 508) return 133;
	else if(vehmodel == 509) return 0;
	else if(vehmodel == 510) return 0;
	else if(vehmodel == 511) return 210;
	else if(vehmodel == 512) return 130;
	else if(vehmodel == 513) return 54;
	else if(vehmodel == 514) return 300;
	else if(vehmodel == 515) return 300;
	else if(vehmodel == 516) return 63;
	else if(vehmodel == 517) return 64;
	else if(vehmodel == 518) return 67;
	else if(vehmodel == 519) return 300;
	else if(vehmodel == 520) return 290;
	else if(vehmodel == 521) return 35;
	else if(vehmodel == 522) return 35;
	else if(vehmodel == 523) return 121;
	else if(vehmodel == 524) return 91;
	else if(vehmodel == 525) return 65;
	else if(vehmodel == 526) return 63;
	else if(vehmodel == 527) return 71;
	else if(vehmodel == 528) return 71;
	else if(vehmodel == 529) return 67;
	else if(vehmodel == 530) return 12;
	else if(vehmodel == 531) return 21;
	else if(vehmodel == 532) return 36;
	else if(vehmodel == 533) return 61;
	else if(vehmodel == 534) return 71;
	else if(vehmodel == 535) return 85;
	else if(vehmodel == 536) return 69;
	else if(vehmodel == 537) return 0;
	else if(vehmodel == 538) return 0;
	else if(vehmodel == 539) return 33;
	else if(vehmodel == 540) return 60;
	else if(vehmodel == 541) return 71;
	else if(vehmodel == 542) return 69;
	else if(vehmodel == 543) return 60;
	else if(vehmodel == 544) return 120;
	else if(vehmodel == 545) return 74;
	else if(vehmodel == 546) return 64;
	else if(vehmodel == 547) return 67;
	else if(vehmodel == 548) return 210;
	else if(vehmodel == 549) return 71;
	else if(vehmodel == 550) return 64;
	else if(vehmodel == 551) return 64;
	else if(vehmodel == 552) return 68;
	else if(vehmodel == 553) return 330;
	else if(vehmodel == 554) return 81;
	else if(vehmodel == 555) return 61;
	else if(vehmodel == 556) return 123;
	else if(vehmodel == 557) return 124;
	else if(vehmodel == 558) return 61;
	else if(vehmodel == 559) return 63;
	else if(vehmodel == 560) return 71;
	else if(vehmodel == 561) return 74;
	else if(vehmodel == 562) return 66;
	else if(vehmodel == 563) return 210;
	else if(vehmodel == 564) return 0;
	else if(vehmodel == 565) return 57;
	else if(vehmodel == 566) return 65;
	else if(vehmodel == 567) return 66;
	else if(vehmodel == 568) return 45;
	else if(vehmodel == 569) return 0;
	else if(vehmodel == 570) return 0;
	else if(vehmodel == 571) return 10;
	else if(vehmodel == 572) return 10;
	else if(vehmodel == 573) return 121;
	else if(vehmodel == 574) return 21;
	else if(vehmodel == 575) return 71;
	else if(vehmodel == 576) return 75;
	else if(vehmodel == 577) return 900;
	else if(vehmodel == 578) return 210;
	else if(vehmodel == 579) return 85;
	else if(vehmodel == 580) return 80;
	else if(vehmodel == 581) return 31;
	else if(vehmodel == 582) return 81;
	else if(vehmodel == 583) return 20;
	else if(vehmodel == 584) return 0;
	else if(vehmodel == 585) return 64;
	else if(vehmodel == 586) return 30;
	else if(vehmodel == 587) return 66;
	else if(vehmodel == 588) return 79;
	else if(vehmodel == 589) return 59;
	else if(vehmodel == 590) return 0;
	else if(vehmodel == 591) return 0;
	else if(vehmodel == 592) return 0;
	else if(vehmodel == 593) return 110;
	else if(vehmodel == 594) return 0;
	else if(vehmodel == 595) return 151;
	else if(vehmodel == 596) return 89;
	else if(vehmodel == 597) return 89;
	else if(vehmodel == 598) return 89;
	else if(vehmodel == 599) return 94;
	else if(vehmodel == 600) return 61;
	else if(vehmodel == 601) return 120;
	else if(vehmodel == 602) return 61;
	else if(vehmodel == 603) return 59;
	else if(vehmodel == 604) return 91;
	else if(vehmodel == 605) return 64;
	else if(vehmodel == 606) return 0;
	else if(vehmodel == 607) return 0;
	else if(vehmodel == 608) return 0;
	else if(vehmodel == 609) return 99;
	else if(vehmodel == 610) return 0;
	else if(vehmodel == 611) return 0;
	else return 0;
}

stock wordwrap(givenString[]) {
	new temporalString[512];
	memcpy(temporalString, givenString, 0, 124 * 4);

	new comaPosition = strfind(temporalString, ",", true, 0),
		dotPosition  = strfind(temporalString, ".", true, 0);
	while(comaPosition != -1)
	{
		if(temporalString[comaPosition+1] != ' ') strins(temporalString, " ", comaPosition + 1);
		comaPosition = strfind(temporalString, ",", true, comaPosition + 1);
	}
	while(dotPosition != -1)
	{
		if(temporalString[dotPosition+1] != ' ') strins(temporalString, " ", dotPosition + 1);
		dotPosition = strfind(temporalString, ",", true, dotPosition + 1);
	}

	new spaceCounter = 0,
		spacePosition = strfind(temporalString, " ", true, 0);

	while(spacePosition != -1)
	{
		spaceCounter++;
		if(spaceCounter % 4 == 0 && spaceCounter != 0)
			strins(temporalString, "\n", spacePosition + 1);
		spacePosition = strfind(temporalString, " ", true, spacePosition + 1);
	}
	return temporalString;
}

stock GetClosestCar(playerid, Float:Prevdist=5.0) {
	if (!IsPlayerConnected(playerid))return -1;
	new Prevcar;
	for(new carid = 0; carid < MAX_PRIVATE_VEHICLES; carid++) {
		new Float:Dist = GetDistanceToCar(playerid,carid);
		if((Dist < Prevdist))
		{
			Prevdist = Dist;
			Prevcar = carid;
		}
	}
	return Prevcar;
}

stock GetDistanceToCar(playerid,carid)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2,Float:Dis;
	if (!IsPlayerConnected(playerid))return -1;
	GetPlayerPos(playerid,x1,y1,z1);GetVehiclePos(carid,x2,y2,z2);
	Dis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
	return floatround(Dis);
}

stock savePlayerStats(playerid)
{
	new szQuery[455];
	GetPlayerPos(playerid, PlayerInfo[playerid][pPos][0], PlayerInfo[playerid][pPos][1], PlayerInfo[playerid][pPos][2]);
	format(szQuery, sizeof(szQuery), "UPDATE `sat_users` SET `x`='%f', `y`='%f', `z`='%f', `a`='%f', `money`='%d', `score`='%d', `frakcja`='%d', `lider`='%d', `Skin`='%d', `Gold`='%d', `Login`='%d', `Mandat`='%d', `Areszt`='%d', `Dostarczen`='%d', `Warn`='%d', `interior`='%d', `vw`='%d' WHERE `username`='%s'",
		PlayerInfo[playerid][pPos][0],
		PlayerInfo[playerid][pPos][1],
		PlayerInfo[playerid][pPos][2],
		PlayerInfo[playerid][pPos][3],
		PlayerInfo[playerid][Money],
		PlayerInfo[playerid][Score],
		PlayerInfo[playerid][Frakcja],
		PlayerInfo[playerid][Lider],
		PlayerInfo[playerid][Skin],
		PlayerInfo[playerid][Gold],
		PlayerInfo[playerid][Login],
		PlayerInfo[playerid][Mandat],
		PlayerInfo[playerid][Areszt],
		PlayerInfo[playerid][Dostarczen],
		PlayerInfo[playerid][Warn],
		PlayerInfo[playerid][interior],
		PlayerInfo[playerid][vw],
		
		PlayerInfo[playerid][Name]);
	mysql_query(szQuery);
	if(!IsPlayerConnected(playerid))
	{
	    return 1;
	}
	SendClientMessage(playerid, KOLOR_CZERWONY, "Twoje konto zosta³o zapisane!");
	return 1;
}

stock IsAnyPlayerInCarShop() {
	foreach(Player, i) {
	    if(PlayerInfo[i][InCarShop] == true) {
	        return true;
	    }
	}
	return false;
}

stock GoPlayerToCarShop(playerid)
{
	TextDrawShowForPlayer(playerid, Salon[0]);
	TextDrawShowForPlayer(playerid, Salon[1]);
	TextDrawShowForPlayer(playerid, Salon[2]);
	TogglePlayerControllable(playerid, false);
	SetPlayerVirtualWorld(playerid, 666);

	PlayerInfo[playerid][InCarShop] = true;
	PlayerInfo[playerid][ActualVehicle] = 0;

	SetSalonVehicleModel(SalonInfo[PlayerInfo[playerid][ActualVehicle]][0]);

	SetPlayerCameraPos(playerid, 1297.6797,-1868.2694,13.5469);
	SetPlayerCameraLookAt(playerid, 1296.1188,-1874.8885,13.3112);
	
	TextDrawSetString(Salon[0], "~r~Cena ~w~900$    ~r~Pakownosc ~w~0    ~r~Waga ~w~0t~n~~n~~n~");
	TextDrawSetString(Salon[1], "Wcisnij Q lub E by zmienic pojazd lub Y by zakupic.");
	TextDrawSetString(Salon[2], " ");
	return 1;
}

stock LeavePlayerFromCarShop(playerid) {
    RemovePlayerFromVehicle(playerid);

	SetPlayerVirtualWorld(playerid, 0);
	TogglePlayerControllable(playerid, true);
	SetCameraBehindPlayer(playerid);
	PlayerInfo[playerid][InCarShop] = false;

    SetPlayerPos(playerid, 1291.0306,-1866.4099,13.5469);
    SetPlayerFacingAngle(playerid, 84.2208);
    	        
	SetSalonVehicleModel(SalonInfo[PlayerInfo[playerid][ActualVehicle]][0]);
		
	TextDrawSetString(Salon[0], "~r~Cena ~w~0$    ~r~Pakownosc ~w~0    ~r~Waga ~w~0t~n~~n~~n~");
	TextDrawSetString(Salon[1], "~<~ SPACJA ~>~");
	TextDrawSetString(Salon[2], " ");
	
	TextDrawHideForPlayer(playerid, Salon[0]);
	TextDrawHideForPlayer(playerid, Salon[1]);
	TextDrawHideForPlayer(playerid, Salon[2]);
	return 1;
}

stock GetVehSpeed(vehid) {
   new Float:X, Float:Y, Float:Z;
   GetVehicleVelocity(vehid, X, Y, Z);
   return floatround(floatsqroot(floatpower(X, 2) + floatpower(Y, 2) + floatpower(Z, 2)) * 200);
}

stock SetSalonVehicleModel(imodel) {
	DestroyVehicle(saloncar);
	saloncar = CreateVehicle(imodel, 1296.1188,-1874.8885,13.3112, 291.1050, -1, -1, -1);
	SetVehicleVirtualWorld(saloncar, 666);
	foreach(Player, i) {
	    if(PlayerInfo[i][InCarShop] == true) {
	        PutPlayerInVehicle(i, saloncar, 0);
	    }
	}
	return 1;
}
//2
stock ToggleVehicleEngineState(vid)
{
	new alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vid,VehicleInfo[GetVehicleUID(vid)][engine],VehicleInfo[GetVehicleUID(vid)][lights],alarm,VehicleInfo[GetVehicleUID(vid)][locked],bonnet,boot,objective);
	if(VehicleInfo[GetVehicleUID(vid)][petrol] == 0.0 &&!NieDotyczy(vid)&&vid!=PojazdPraktyka) return 1;
	if(VehicleInfo[GetVehicleUID(vid)][engine] == 1) {
		SetVehicleParamsEx(vid,false,VehicleInfo[GetVehicleUID(vid)][lights],alarm,doors,bonnet,boot,objective);
		GetVehicleParamsEx(vid,VehicleInfo[GetVehicleUID(vid)][engine],VehicleInfo[GetVehicleUID(vid)][lights],alarm,VehicleInfo[GetVehicleUID(vid)][locked],bonnet,boot,objective);
	} else {
		SetVehicleParamsEx(vid,true,VehicleInfo[GetVehicleUID(vid)][lights],alarm,doors,bonnet,boot,objective);
		GetVehicleParamsEx(vid,VehicleInfo[GetVehicleUID(vid)][engine],VehicleInfo[GetVehicleUID(vid)][lights],alarm,VehicleInfo[GetVehicleUID(vid)][locked],bonnet,boot,objective);
	}
	return 1;
}

stock ToggleVehicleLightsState(vid) {
	new alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(vid,VehicleInfo[GetVehicleUID(vid)][engine],VehicleInfo[GetVehicleUID(vid)][lights],alarm,doors,bonnet,boot,objective);
	if(VehicleInfo[GetVehicleUID(vid)][lights] == 1) {
		SetVehicleParamsEx(vid,VehicleInfo[GetVehicleUID(vid)][engine],false,alarm,doors,bonnet,boot,objective);
		GetVehicleParamsEx(vid,VehicleInfo[GetVehicleUID(vid)][engine],VehicleInfo[GetVehicleUID(vid)][lights],alarm,VehicleInfo[GetVehicleUID(vid)][locked],bonnet,boot,objective);
	} else {
		SetVehicleParamsEx(vid,VehicleInfo[GetVehicleUID(vid)][engine],true,alarm,doors,bonnet,boot,objective);
		GetVehicleParamsEx(vid,VehicleInfo[GetVehicleUID(vid)][engine],VehicleInfo[GetVehicleUID(vid)][lights],alarm,VehicleInfo[GetVehicleUID(vid)][locked],bonnet,boot,objective);
	}
}

stock ReloadLoadings() {
	ToLog("truckrp.amx->ReloadLoadings->Call");
	new Query[255], lid;
    LoadingsValue = 0;
    mysql_query("SELECT `uid`, `name`, `lx`, `ly`, `lz` FROM `sat_loading`");
    mysql_store_result();
	while(mysql_fetch_row_format(Query, "|")) {
	    sscanf(Query, "p<|>i", lid);
	    sscanf(Query, "p<|>is[255]fff", LoadingsInfo[lid][uid], LoadingsInfo[lid][lname], LoadingsInfo[lid][lx], LoadingsInfo[lid][ly], LoadingsInfo[lid][lz]);
		LoadingsValue++;
	}
	mysql_free_result();
}

stock LoadPetrolStations() {
	ToLog("truckrp.amx->LoadPetrolStations->Call");
	new Query[255], psid;
    PetrolValue = 0;
    mysql_query("SELECT `uid`, `name`, `sx`, `sy`, `sz` FROM `sat_petrol_station`");
    mysql_store_result();
	while(mysql_fetch_row_format(Query, "|")) {
	    sscanf(Query, "p<|>i", psid);
	    sscanf(Query, "p<|>is[255]fff", PetrolStationInfo[psid][uid], PetrolStationInfo[psid][pname], PetrolStationInfo[psid][sx], PetrolStationInfo[psid][sy], PetrolStationInfo[psid][sz]);
		PetrolValue++;
	}
	mysql_free_result();
	return 1;
}

stock LoadLoadings() {
	ToLog("truckrp.amx->LoadLoadings->Call");
	new Query[255], lid;
    LoadingsValue = 0;
    mysql_query("SELECT `uid`, `name`, `lx`, `ly`, `lz` FROM `sat_loading`");
    mysql_store_result();
	while(mysql_fetch_row_format(Query, "|")) {
	    sscanf(Query, "p<|>i", lid);
	    sscanf(Query, "p<|>is[255]fff", LoadingsInfo[lid][uid], LoadingsInfo[lid][lname], LoadingsInfo[lid][lx], LoadingsInfo[lid][ly], LoadingsInfo[lid][lz]);
		LoadingsValue++;
	}
	mysql_free_result();
}

stock ReloadCargos() {
	ToLog("truckrp.amx->ReloadCargos->Call");
	new Query[255], cid;
    CargosValue = 0;
    mysql_query("SELECT `uid`, `name`, `weight`, `price`, `illegal`, `fromid`, `toid`, `dostepnosc` FROM `sat_cargo`");
    mysql_store_result();
	while(mysql_fetch_row_format(Query, "|"))
	{
	    sscanf(Query, "p<|>i", cid);
	    sscanf(Query, "p<|>is[255]fiiiii", CargoInfo[cid][uid], CargoInfo[cid][cname], CargoInfo[cid][weight], CargoInfo[cid][price], CargoInfo[cid][illegal], CargoInfo[cid][fromid], CargoInfo[cid][toid], CargoInfo[cid][dostepnosc]);
		CargosValue++;
	}
	mysql_free_result();
}

CMD:deleteall(playerid, params[])
{
	if(!IsAdmin(playerid, 2))
	    return 1;
	new Float: Pos[3];
	new cuid;
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
    CarLoop(i)
    {
        if(IsVehicleInRangeOfPoint(i, 10.0, Pos[0], Pos[1], Pos[2]))
        {
			cuid = GetVehicleUID(i);
			DestroyVehicle(VehicleInfo[cuid][gtauid]);
			VehicleInfo[cuid][health]=0.0;
			SaveVehicleData(cuid);
			VehicleInfo[cuid][gtauid]=-1;
			ShowInfo(playerid, "Pojazdy usuniête!");
		}
	}
	return 1;
}
			
stock IsVehicleInRangeOfPoint(vehicleid, Float:radi, Float:x, Float:y, Float:z)
{
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new Float:tempposx, Float:tempposy, Float:tempposz;
	GetVehiclePos(vehicleid, oldposx, oldposy, oldposz);
	tempposx = (oldposx -x);
	tempposy = (oldposy -y);
	tempposz = (oldposz -z);
	if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
	{
		return 1;
	}
	return 0;
}


stock LoadVehicles()
{
	TotalVeh=0;
	ToLog("truckrp.amx->LoadVehicles->Call");
	new Query[255], vid;
	mysql_query("SELECT `uid`, `frakcja`, `ownerid`, `model`, `c1`, `c2`, `petrol`, `maxpetrol`, `mileage`, `health`, `x`, `y`, `z`, `a`, `locked`, `cargo`, `cargostate`, `nitro`, `hydraulika`, `paliwo`, `ladunek`, `zamekc`, `cb` FROM `sat_vehicles`");
	mysql_store_result();
	while(mysql_fetch_row_format(Query, "|"))
	{
	    sscanf(Query, "p<|>i", vid);
	    sscanf(Query, "p<|>iiiiiiffffffffiiiiiiiii", VehicleInfo[vid][uid], VehicleInfo[vid][frakcja], VehicleInfo[vid][ownerid], VehicleInfo[vid][model], VehicleInfo[vid][c1], VehicleInfo[vid][c2], VehicleInfo[vid][petrol],
	    VehicleInfo[vid][maxpetrol], VehicleInfo[vid][mileage], VehicleInfo[vid][health], VehicleInfo[vid][vx], VehicleInfo[vid][vy], VehicleInfo[vid][vz], VehicleInfo[vid][va],
		VehicleInfo[vid][locked], VehicleInfo[vid][cargo], VehicleInfo[vid][cargostat],
		//dodatki
		VehicleInfo[vid][nitro], VehicleInfo[vid][hydraulika], VehicleInfo[vid][paliwo], VehicleInfo[vid][ladunek], VehicleInfo[vid][zamekc], VehicleInfo[vid][cb]);
		VehicleInfo[vid][gtauid]=-1;
		TotalVeh++;
	}
	mysql_free_result();
}
stock ReloadVehicles()
{
	TotalVeh=0;
	ToLog("truckrp.amx->LoadVehicles->Call");
	new Query[255], vid;
	mysql_query("SELECT `uid`, `frakcja`, `ownerid`, `model`, `c1`, `c2`, `maxpetrol`, `mileage`, `health`, `x`, `y`, `z`, `a`, `locked`, `nitro`, `hydraulika`, `paliwo`, `ladunek`, `zamekc`, `cb` FROM `sat_vehicles`");
	mysql_store_result();
	while(mysql_fetch_row_format(Query, "|"))
	{
	    sscanf(Query, "p<|>i", vid);
	    sscanf(Query, "p<|>iiiiiifffffffiiiiiii", VehicleInfo[vid][uid], VehicleInfo[vid][frakcja], VehicleInfo[vid][ownerid], VehicleInfo[vid][model], VehicleInfo[vid][c1], VehicleInfo[vid][c2],
	    VehicleInfo[vid][maxpetrol], VehicleInfo[vid][mileage], VehicleInfo[vid][health], VehicleInfo[vid][vx], VehicleInfo[vid][vy], VehicleInfo[vid][vz], VehicleInfo[vid][va],
		VehicleInfo[vid][locked],
		//dodatki
		VehicleInfo[vid][nitro], VehicleInfo[vid][hydraulika], VehicleInfo[vid][paliwo], VehicleInfo[vid][ladunek], VehicleInfo[vid][zamekc], VehicleInfo[vid][cb]);
		VehicleInfo[vid][gtauid]=-1;
		TotalVeh++;
	}
	mysql_free_result();
}
/*
stock ReloadVehicles() {
	ToLog("truckrp.amx->ReloadVehicles->Call");
	new Query[255], vid, szPlate[255];
    TotalVeh=0;
	mysql_query("SELECT `uid`, `ownerid`, `model`, `c1`, `c2`, `petrol`, `mileage`, `health`, `x`, `y`, `z`, `a`, `locked`, `cargo`, `cargostate` FROM `sat_vehicles`");
	mysql_store_result();
	while(mysql_fetch_row_format(Query, "|")) {
	    sscanf(Query, "p<|>i", vid);
	    if(VehicleInfo[vid][uid] == 0) {
		    sscanf(Query, "p<|>iiiiifffffffiii", VehicleInfo[vid][uid], VehicleInfo[vid][ownerid], VehicleInfo[vid][model], VehicleInfo[vid][c1], VehicleInfo[vid][c2], VehicleInfo[vid][petrol],
		    VehicleInfo[vid][mileage], VehicleInfo[vid][health], VehicleInfo[vid][vx], VehicleInfo[vid][vy], VehicleInfo[vid][vz], VehicleInfo[vid][va],
			VehicleInfo[vid][locked], VehicleInfo[vid][cargo], VehicleInfo[vid][cargostat]);
			if(VehicleInfo[vid][health] == 0.0) {
			    VehicleInfo[vid][gtauid] = -1;
			} else {
			    VehicleInfo[vid][gtauid] = 	CreateVehicle(VehicleInfo[vid][model], VehicleInfo[vid][vx], VehicleInfo[vid][vy], VehicleInfo[vid][vz], VehicleInfo[vid][va], VehicleInfo[vid][c1], VehicleInfo[vid][c2], -1);
			}
    	    format(szPlate, sizeof(szPlate), "SAT %d", vid);
		    SetVehicleNumberPlate(VehicleInfo[vid][gtauid], szPlate);
			SetVehicleToRespawn(VehicleInfo[vid][gtauid]);
		}
	}
	mysql_free_result();
}
*/
/*CMD:konweruj(playerid, params[])
{
	CarLoop(i)
	{
	    new szQuery[255];
		format(szQuery, sizeof(szQuery), "UPDATE `sat_vehicles` SET `health`='100' WHERE `uid`='%d'", i);
		mysql_query(szQuery);
		format(szQuery, sizeof(szQuery), "Aktualizujê pojazd o ID %d", i);
		ShowInfo(playerid, szQuery);
	}
	return 1;
}*/
stock GetVehicleIDbyUID(vuid)
{
    for(new vvid=0; vvid<TotalVeh; vvid++)
    {
        if(VehicleInfo[vuid][gtauid]==vvid)
        {
            return vvid;
		}
	}
	return -1;
}

stock SaveVehicleData(vid)
{
	if(VehicleInfo[vid][gtauid]!=-1)
	{
		new vvvid = GetVehicleIDbyUID(vid);
		GetVehicleHealth(vvvid, VehicleInfo[vid][health]);
	}
		
	new szQuery[255];
	format(szQuery, sizeof(szQuery), "UPDATE `sat_vehicles` SET `c1`='%d', `c2`='%d', `petrol`='%f', `mileage`='%f', `health`='%f', \
	`x`='%f', `y`='%f', `z`='%f', `a`='%f', `locked`='%d', `cargo`='%d', `cargostate`='%d' WHERE `uid`='%d'",
	VehicleInfo[vid][c1],
	VehicleInfo[vid][c2],
	VehicleInfo[vid][petrol],
	VehicleInfo[vid][mileage],
	VehicleInfo[vid][health],
	VehicleInfo[vid][vx],
	VehicleInfo[vid][vy],
	VehicleInfo[vid][vz],
	VehicleInfo[vid][va],
	VehicleInfo[vid][locked],
	VehicleInfo[vid][cargo],
 	VehicleInfo[vid][cargostat],
	vid);
	mysql_query(szQuery);
}

stock GetVehicleMilleage(vid) {
	new Float:pp[3];

	GetVehiclePos(vid, pp[0], pp[1], pp[2]);

	new v;
	v = GetVehicleUID(vid);
	//VehicleInfo[v][mileage] += Distance3D(VehicleInfo[v][vPos][0], VehicleInfo[v][vPos][1], VehicleInfo[v][vPos][2], pp[0], pp[1], pp[2]);
	pp[0] = VehicleInfo[v][vPos][0];
	pp[1] = VehicleInfo[v][vPos][1];
	pp[2] = VehicleInfo[v][vPos][2];
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    if(vehicleid==PojazdPraktyka)
	{
	    if(ZdajePraktyke<0)
			return 1;
	    SetPlayerPos(ZdajePraktyke, 0.0, 0.0, 0.0);
	    SetPlayerVirtualWorld(ZdajePraktyke, 0);
	    ZdajePraktyke=-1;
	    AtualnaTrasa=0;
		return 1;
	}
	else
	{
		new Float:vh, vid;
		vid = GetVehicleUID(vehicleid);
		GetVehicleHealth(vehicleid, vh);
		if(VehicleInfo[vid][cargo]!=0)
		{
		    VehicleInfo[vid][cargo]=0;
		}
	    SaveVehicleData(vid);
	    VehicleInfo[vid][health]=0.0;
	    if(VehicleInfo[vid][gtauid] > -1 && VehicleInfo[vid][health]==0.0)
	    {
	    	DestroyVehicle(VehicleInfo[vid][gtauid]);
	    	//SendClientMessageToOwner(vid, KOLOR_SZARY, "Twój pojazd zosta³ doszczêtnie zniszczony i usuniêty!");
		}
		if(VehicleInfo[vid][vDesc])
		{
			Delete3DTextLabel(VehicleInfo[vid][vDesc]);
		}
	}
	return 1;
}
/*
stock SendClientMessageToOwner(caruid, color, tresc[])
{
    for(new i=0; i<Sloty; i++)
    {
        if(VehicleInfo[caruid][ownerid] == PlayerInfo[i][uid])
		{
		    SendClientMessage(i, color, tresc);
		    return 1;
		}
	}
	return 1;
}
*/
public OnPlayerEnterVehicle(playerid, vehicleid)
{
	new vid;
	vid = GetVehicleUID(vehicleid);
	if(VehicleInfo[vid][locked] == 1)
	{
     	GameTextForPlayer(playerid, "~w~Ten pojazd jest zamkniety!", 3000, 3);
	    SetPlayerPos(playerid, PlayerInfo[playerid][pPos][0], PlayerInfo[playerid][pPos][1], PlayerInfo[playerid][pPos][2]);
	}
	if(VehicleInfo[vid][frakcja] != 0)
	{
		if(VehicleInfo[vid][frakcja] != PlayerInfo[playerid][Frakcja])
		{
		    new pstate = GetPlayerState(playerid);
		    if(pstate == PLAYER_STATE_DRIVER)
		    {
	     		GameTextForPlayer(playerid, "~w~Ten pojazd nale¿y do frakcji!", 3000, 3);
		    	SetPlayerPos(playerid, PlayerInfo[playerid][pPos][0], PlayerInfo[playerid][pPos][1], PlayerInfo[playerid][pPos][2]);
			}
		}
	}
	return 1;
}

public OnPlayerEnterDynamicRaceCP(playerid, checkpointid)
{
	if(ZdajePraktyke==playerid)
	{
	    if(checkpointid == KoniecTrasy)
	    {
	        if(!IsPlayerInAnyVehicle(playerid))
	            return 1;
	        if(AtualnaTrasa<=2)
	        {
	        	TogglePlayerDynamicRaceCP(playerid, KoniecTrasy, 0);
            	PrzygotujDoPrawka(playerid, AtualnaTrasa);
            	AtualnaTrasa++;
			}
			else
			{
			    ZdajePraktyke=-1;
			    TogglePlayerDynamicRaceCP(playerid, KoniecTrasy, 0);
			    AtualnaTrasa=0;
				ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Prawo jazdy - praktyka (KONIEC)", "Gratulujê, zda³eœ egzamin praktyczny!\nOd teraz mo¿esz swobodnie poruszaæ siê drogami SanAndreas.", "Rozumiem","");
                PrawkoDestroyObject();
                SetPlayerPos(playerid, 1116.4723,1266.4159,10.5622);
                SetPlayerVirtualWorld(playerid, 0);
                TogglePlayerControllable(playerid, true);
                format(dstring, sizeof(dstring), "UPDATE `sat_prawko` SET `praktyka`='1' WHERE `username`='%s'", PlayerInfo[playerid][Name]);
				mysql_query(dstring);
				if(ZdanaTeoria(playerid))
				{
				    ShowInfo(playerid, "Otrzymujesz nowy przedmiot: Prawo Jazdy (by je komuœ pokazaæ u¿yj /pokaz)");
				}
			}
		}
	}
	return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    if(vehicleid==PojazdPraktyka)
    {
		new Float: CarHP;
		GetVehicleHealth(PojazdPraktyka, CarHP);
		if(CarHP<1000.0)
		{
			new pplayerid = ZdajePraktyke;
			TogglePlayerDynamicRaceCP(pplayerid, KoniecTrasy, 0);
			PrawkoDestroyObject();
			SetPlayerPos(pplayerid, 1116.4723,1266.4159,10.5622);
   			SetPlayerVirtualWorld(pplayerid, 0);
      		TogglePlayerControllable(pplayerid, true);
      		ShowDialog(pplayerid, 0, DIALOG_STYLE_MSGBOX, "Prawo jazdy - praktyka (KONIEC)", "Niestety, uszkodzi³eœ pojazd wiêc twój egzamin praktyczny nie zostaje zaliczony!", "Rozumiem", "");
    		AtualnaTrasa=0;
            ZdajePraktyke=-1;
        }
	}
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(ZdajePraktyke==playerid)
	{
	    if(newstate==PLAYER_STATE_ONFOOT)
	    {
	        PutPlayerInVehicle(playerid, PojazdPraktyka, 0);
			SendClientMessage(playerid, 0xFFFFFF, "Nie mo¿esz wyjœæ z pojazdu podczas egzaminu!");
		}
	}
	else
	{
		if(newstate == PLAYER_STATE_DRIVER)
		{
			TextDrawShowForPlayer(playerid, CarStatus[playerid]);
			TextDrawShowForPlayer(playerid, CarStatus2[playerid]);
			TextDrawShowForPlayer(playerid, CarStatus3);
			TextDrawShowForPlayer(playerid, CarStatus4);
			ShowOgloszenie(playerid, "~y~Pojazd~n~~w~2 - wlacza swiatla~n~~w~LALT - wlacza silnik", 7);
			if(!ZdanaTeoria(playerid)||!ZdanaPraktyka(playerid))
			{
			    SendClientMessage(playerid, KOLOR_BIALY, "Uwa¿aj by Ciê nie zatrzyma³a policja poniewa¿ nie posiadasz prawa jazdy!");
			}
		}

		if(oldstate == PLAYER_STATE_DRIVER)
		{
			TextDrawHideForPlayer(playerid, CarStatus[playerid]);
			TextDrawHideForPlayer(playerid, CarStatus2[playerid]);
			TextDrawHideForPlayer(playerid, CarStatus3);
			TextDrawHideForPlayer(playerid, CarStatus4);
			new v = GetPlayerVehicleID(playerid);
			new vuid = GetVehicleUID(v);
			SaveVehicleData(vuid);
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
#if KEYDEBUG == 1
	new str[64];
	format(str, sizeof(str), "Newkeys = %i | Oldkeys = %i", newkeys, oldkeys);
	ShowInfo(playerid, str);
#endif

	if(newkeys & 4) {
	    //if(GetPlayerVehicleSeat(playerid) == 1) {
		//Silnik
		cmd_silnik(playerid, "");
		//}
	}
	
	if(newkeys & 512) {
	    //if(GetPlayerVehicleSeat(playerid) == 1) {
		//Œwiat³a
		cmd_swiatla(playerid, "");
		//}
	}
	
	
	
	if(PlayerInfo[playerid][InCarShop])
	{
	    if(newkeys==64)
		{
	   		PlayerInfo[playerid][ActualVehicle]++;
	        if(PlayerInfo[playerid][ActualVehicle] >= sizeof(SalonInfo))
			{
		        PlayerInfo[playerid][ActualVehicle] = 0;
	        }

			format(dstring, sizeof(dstring), "~r~Cena ~w~%d$    ~r~Pakownosc ~w~%dkg    ~r~Waga ~w~%d.0t~n~~n~~n~", SalonInfo[PlayerInfo[playerid][ActualVehicle]][1], SalonInfo[PlayerInfo[playerid][ActualVehicle]][2],SalonInfo[PlayerInfo[playerid][ActualVehicle]][3]);
			TextDrawSetString(Salon[0], dstring);
			format(dstring, sizeof(dstring), "%s", VehicleNames[SalonInfo[PlayerInfo[playerid][ActualVehicle]][0]-400]);
			TextDrawSetString(Salon[2], dstring);

			SetSalonVehicleModel(SalonInfo[PlayerInfo[playerid][ActualVehicle]][0]);
			//Przód

			SetPlayerCameraPos(playerid, 1297.6797,-1868.2694,13.5469);
			SetPlayerCameraLookAt(playerid, 1296.1188,-1874.8885,13.3112);
		}
	    if(newkeys==256)
		{
			PlayerInfo[playerid][ActualVehicle]--;
			if(PlayerInfo[playerid][ActualVehicle] < 0)
			{
		        PlayerInfo[playerid][ActualVehicle] = sizeof(SalonInfo);
	        }


			format(dstring, sizeof(dstring), "~r~Cena ~w~%d$    ~r~Pakownosc ~w~%dkg    ~r~Waga ~w~%d.0t~n~~n~~n~", SalonInfo[PlayerInfo[playerid][ActualVehicle]][1], SalonInfo[PlayerInfo[playerid][ActualVehicle]][2],SalonInfo[PlayerInfo[playerid][ActualVehicle]][3]);
			TextDrawSetString(Salon[0], dstring);
			format(dstring, sizeof(dstring), "%s", VehicleNames[SalonInfo[PlayerInfo[playerid][ActualVehicle]][0]-400]);
			TextDrawSetString(Salon[2], dstring);

			SetSalonVehicleModel(SalonInfo[PlayerInfo[playerid][ActualVehicle]][0]);
	        //Ty³

			SetPlayerCameraPos(playerid, 1297.6797,-1868.2694,13.5469);
			SetPlayerCameraLookAt(playerid, 1296.1188,-1874.8885,13.3112);
    	}
    	if(newkeys==65536)
    	{
			if(SalonInfo[PlayerInfo[playerid][ActualVehicle]][1] > PlayerInfo[playerid][Money])
			{
		     	GameTextForPlayer(playerid, "~n~~n~~n~~r~~h~Blad!~n~~w~Nie posiadasz wystarczajacej ilosci gotowki!", 5000, 5);
			    return 1;
			}

			new szString[255];
			format(szString, sizeof(szString), "{FFFFFF}Czy napewno chcesz kupiæ pojazd %s za cenê %d$?", VehicleNames[SalonInfo[PlayerInfo[playerid][ActualVehicle]][0]-400], SalonInfo[PlayerInfo[playerid][ActualVehicle]][1]);
		    ShowDialog(playerid, DIALOG_BUY_TRUCK, DIALOG_STYLE_MSGBOX, "Potwierzenie", szString, "Tak", "Nie");
		}
	}
	if(PlayerInfo[playerid][InBinco]==true)
	{
	    if(newkeys==4) // LPM
	    {
	        OgladaSkin[playerid]--;
	        if(OgladaSkin[playerid]<0)
	        {
	            OgladaSkin[playerid]=MAX_BINCO_SKIN-1;
			}
			SetPlayerSkin(playerid, skiny[OgladaSkin[playerid]]);
			GameTextForPlayer(playerid, "~n~~n~~n~~r~~h~~g~Koszt: 300$", 5000, 5);
		}
		if(newkeys==128) // PPM
	    {
	        OgladaSkin[playerid]++;
	        if(OgladaSkin[playerid]==MAX_BINCO_SKIN)
	        {
	            OgladaSkin[playerid]=0;
			}
			SetPlayerSkin(playerid, skiny[OgladaSkin[playerid]]);
			GameTextForPlayer(playerid, "~n~~n~~n~~r~~h~~g~Koszt: 300$", 5000, 5);
		}
	    if(newkeys==2) // C
	    {
	        if(PlayerInfo[playerid][Money]<300)
	        {
	            GameTextForPlayer(playerid, "~n~~n~~n~~r~~h~Blad!~n~~w~Nie posiadasz wystarczajacej ilosci gotowki.~n~Potrzeba 300$!", 5000, 5);
			    return 1;
	        }
    	    SetCameraBehindPlayer(playerid);
		    SetPlayerVirtualWorld(playerid, 0);
		    PlayerInfo[playerid][InBinco]=false;
		    TogglePlayerControllable(playerid,1);
		    PlayerInfo[playerid][Skin]=skiny[OgladaSkin[playerid]];
		    SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
		    TextDrawHideForPlayer(playerid, BincoTD[0]);
        	TextDrawHideForPlayer(playerid, BincoTD[1]);
	    }
	
	}

	if(newkeys==4)
	{
	    // Szpital
	    if(DoInRange(4.0, playerid, -2647.39990234,695.40002441,27.29999924))
	    {
	        SetPlayerPos(playerid, -2636.19995117,691.70001221,50.20000076);
	    }
	    if(DoInRange(4.0, playerid, -2636.19995117,691.70001221,50.20000076))
	    {
    		SetPlayerPos(playerid, -2647.39990234,695.40002441,27.29999924);
	    }
	    // SanNews
	    if(DoInRange(4.0, playerid, 1283.59997559,-1160.50000000,23.29999924))
	    {
	        SetPlayerPos(playerid, 1283.69995117,-1189.30004883,47.29999924);
	    }
	    if(DoInRange(4.0, playerid, 1283.69995117,-1189.30004883,47.29999924))
	    {
    		SetPlayerPos(playerid, 1283.59997559,-1160.50000000,23.29999924);
	    }
	    // Policja
	    if(DoInRange(4.0, playerid, 1475.19995117,-1360.69995117,11.30000019))
	    {
	        SetPlayerPos(playerid, 1470.69995117,-1356.00000000,151.80000305);
	    }
	    if(DoInRange(4.0, playerid, 1470.69995117,-1356.00000000,151.80000305))
	    {
    		SetPlayerPos(playerid, 1475.19995117,-1360.69995117,11.30000019);
	    }
		// Binco
	    if(DoInRange(4.0, playerid, 207.6924,-110.4737,1005.1328))
	    {
	        SetPlayerPos(playerid, 1656.4442,1733.3796,10.8281);
	        SetPlayerInterior(playerid, 0);
	    }
	    if(DoInRange(4.0, playerid, 1656.4442,1733.3796,10.8281))
	    {
	        SetPlayerInterior(playerid, 15);
    		SetPlayerPos(playerid, 207.6924,-110.4737,1005.1328);
	    }
	    
	    // Nauka Jazdy
	    if(DoInRange(2.5, playerid, 1168.69995117,1361.50000000,10.60000038))
	    {
    		SetPlayerPos(playerid, 1168.69921875,1364.79980469,10.50000000);
	    }
	    if(DoInRange(2.5, playerid, 1168.69921875,1364.79980469,10.50000000))
	    {
    		SetPlayerPos(playerid, 1168.69995117,1361.50000000,10.60000038);
	    }
	    if(DoInRange(2.5, playerid, 1165.57, 1344.31, 10.80))
	    {
	        SetPlayerPos(playerid, 1165.4570, 1346.1755, 10.8953);
	    }
	    
	    //
	}
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(pickupid == intpolwe)
	{
	    ShowOgloszenie(playerid, "~y~Nauka jazdy.~n~~w~Wcisnij LPM by wejœæ do komisariatu.", 7);
	}
	if(pickupid == intpolwy)
	{
	    ShowOgloszenie(playerid, "~y~Nauka jazdy.~n~~w~Wcisnij LPM by wyjœæ z komisariatu.", 7);
	}
	if(pickupid == snwe)
	{
	    ShowOgloszenie(playerid, "~y~Nauka jazdy.~n~~w~Wcisnij LPM by wyjsc do bazy SanNews.", 7);
	}
	if(pickupid == snwy)
	{
	    ShowOgloszenie(playerid, "~y~Nauka jazdy.~n~~w~Wcisnij LPM by wyjsc z bazy SanNews.", 7);
	}
	if(pickupid == szpitalwe)
	{
	    ShowOgloszenie(playerid, "~y~Nauka jazdy.~n~~w~Wcisnij LPM by wejœæ do szpitala.", 7);
	}
	if(pickupid == szpitalwy)
	{
	    ShowOgloszenie(playerid, "~y~Nauka jazdy.~n~~w~Wcisnij LPM by wyjsc z szpitala.", 7);
	}
	
	
	if(pickupid == salon)
	{
	    //ShowOgloszenie(playerid, "~y~Salon samochodowy.~n~~w~Wpisz /salon by Wejsc/Wyjsc z salonu.", 7);
	}
	if(pickupid == bincoexit)
	{
		ShowOgloszenie(playerid, "~g~Sklep ~y~Binco~g~.~n~~w~Wcisnij LPM by wyjsc z lokalu.", 7);
	}
	if(pickupid == bincoenter)
	{
	    ShowOgloszenie(playerid, "~g~Sklep ~y~Binco~g~.~n~~w~Wcisnij LPM by wejsc do lokalu.", 7);
	}
	if(pickupid == naukajazdyenter)
	{
	    ShowOgloszenie(playerid, "~y~Nauka jazdy.~n~~w~Wcisnij LPM by wejsc do lokalu.", 7);
	}
	if(pickupid == naukajazdyexit)
	{
	    ShowOgloszenie(playerid, "~y~Nauka jazdy.~n~~w~Wcisnij LPM by wyjsc z lokalu.", 7);
	}
	if(pickupid == naukajazdyplac)
	{
	    ShowOgloszenie(playerid, "~y~Nauka jazdy.~n~~w~Wcisnij LPM by wyjsc z placu.", 7);
	}
	return 1;
}

public OnGameModeExit()
{
    mysql_query("UPDATE `sat_gpos` SET `active` = 0");
	foreach(Player, i)
	{
		savePlayerStats(i);
	}
	mysql_close();
	return 1;
}

public RefreshCars()
{
	SendClientMessageToAll(-1, "RefreshCars");
	for(new icar = 0; icar < TotalVeh; icar++)
	{
	    if(NieDotyczy(icar))
	    {
		    return 1;
		}
		new alarm, doors, bonnet, boot, objective;
     	new vid;
	 	vid = GetVehicleUID(icar);
		GetVehicleParamsEx(icar,VehicleInfo[vid][engine],VehicleInfo[vid][lights],alarm,VehicleInfo[vid][locked],bonnet,boot,objective);
		
		if(VehicleInfo[vid][engine] == 1)
		{
		    if(VehicleInfo[vid][petrol] == 0.0)
			{
				SetVehicleParamsEx(icar,false,VehicleInfo[vid][lights],alarm,doors,bonnet,boot,objective);
				SaveVehicleData(vid);
				VehicleInfo[vid][petrol] = 0;
		    } else {
	    		VehicleInfo[vid][petrol] -= 0.5;
	    		SendClientMessageToAll(-1, "RefreshCars - paliwo");
			}
		}
	    GetVehicleHealth(icar, VehicleInfo[vid][health]);
    }
   	//SendClientMessageToAll(-1, "[Call]RefreshCars()->Called");
   	return 1;
}

public Global()
{
	new godzina, minuta, second,
	    rok, miesiac, dzien;
	
    gettime(godzina, minuta, second);
    getdate(rok, miesiac, dzien);
    new string[45];
    if(second == 00)
    {
        
        sczas++;
		foreach(Player, i)
		{
			SetPlayerTime(i,sczas,0);
		}

		if(minuta == 00)
		{
			format(string, sizeof(string), "** Dzwony w ratuszu bij¹ %d razy. **", godzina);
			SendClientMessageToAll(COLOR_PURPLE, string);
		}
		if(sczas==24)
        {
            sczas=0;
		}
	}
	format(string, sizeof(string), "%s%d:%s%d",
	    ((sczas < 10) ? ("0") : ("")), sczas, ((second < 10) ? ("0") : ("")), second);
	TextDrawSetString(godzinaserver, string);
	format(string, sizeof(string), "%d %s", dzien, miesiace[miesiac-1]);
	TextDrawSetString(data, string);
	format(string, sizeof(string), "%s%d:%s%d",
	    ((godzina < 10) ? ("0") : ("")),
		godzina,
		((minuta < 10) ? ("0") : ("")),
		minuta);
  	TextDrawSetString(godzinaswiat, string);
  	SetWorldTime(sczas);

	foreach(Player, i)
	{
		OnPlayerUpdateEx(i);
	}
	
	ReklamaNum++;
	if(ReklamaNum==120)
	{
	    format(dstring, sizeof(dstring), ""C_ZIELONY"REKLAMA: {C0C0C0}%s", Reklama[wyswietlreklame]);
	    SendClientMessageToAll(KOLOR_ZIELONY, dstring);
	    ReklamaNum=0;
	    wyswietlreklame++;
	    if(wyswietlreklame==MAX_REKLAM)
	        wyswietlreklame=0;
	}
	
	if(PenaltyCount > 0)
	{
	    PenaltyCount--;
	    if(PenaltyCount < 1)
	    {
	        TextDrawHideForAll(PenaltyAnnouce);
	        TextDrawSetString(PenaltyAnnouce, " ");
	    }
	}
}

public OnPlayerText(playerid, text[])
{
	if(PlayerInfo[playerid][Logged]==false)
	{
	    ShowInfo(playerid, "Nie jesteœ zalogowany!");
	    return 0;
	}
	if(PlayerInfo[playerid][Jail]>0)
	{
	    ShowInfo(playerid, "Jesteœ w wiêzieniu wiêc nie mo¿esz pisaæ!");
	    return 0;
	}
    new str[400];
	if(text[0] == '.')
	{
		format(str,sizeof(str),"%s mówi: %s", PlayerInfo[playerid][Name], text);
		SendClientMessageEx(14.0, playerid, str, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		return 0;
	}
	if(text[0] == '!')
	{
	    SendMessageCB(playerid, text);
	    return 0;
	}
	new times[6];
	gettime(times[0], times[1], times[2]);
	getdate(times[3], times[4], times[5]);
    new szQuery[255];
	format(szQuery, 255, "INSERT INTO `sat_wiadomosci` SET `autor`='%s', `tresc`='%s', `data`='%d-%d-%d %d:%d:%d'", PlayerInfo[playerid][Name], text,
	times[3], times[4], times[5], times[0], times[1], times[2]);
	mysql_query(szQuery);

	if(IsAdmin(playerid, 3))
	{
		format(str, sizeof(str), "%d:"C_SZARY"%s"C_BIALY"[{00008B}HA"C_BIALY"]: %s", playerid, PlayerInfo[playerid][Name], text);
	 	SendClientMessageToAll(KOLOR_BIALY, str);
	 	return 0;
	}
	if(IsAdmin(playerid, 2))
	{
		format(str, sizeof(str), "%d:"C_SZARY"%s"C_BIALY"[{CC9966}VHA"C_BIALY"]: %s", playerid, PlayerInfo[playerid][Name], text);
	 	SendClientMessageToAll(KOLOR_BIALY, str);
	 	return 0;
	}
	if(IsAdmin(playerid, 1))
	{
		format(str, sizeof(str), "%d:"C_SZARY"%s"C_BIALY"[{FF2F2F}A"C_BIALY"]: %s", playerid, PlayerInfo[playerid][Name], text);
	 	SendClientMessageToAll(KOLOR_BIALY, str);
	 	return 0;
	}
	if(IsVip(playerid))
	{
	    format(str, sizeof(str), "%d:"C_SZARY"%s"C_BIALY"[{FFFF00}VIP"C_BIALY"]: %s", playerid, PlayerInfo[playerid][Name], text);
	 	SendClientMessageToAll(KOLOR_BIALY, str);
	 	return 0;
	}
	if(!IsVip(playerid))
	{
	    format(str, sizeof(str), "%d:"C_SZARY"%s"C_BIALY"["C_SZARY"Gracz"C_BIALY"]: %s", playerid, PlayerInfo[playerid][Name], text);
	 	SendClientMessageToAll(KOLOR_BIALY, str);
	 	return 0;
	}
	
	
	
	return 0;
}

stock LoadCargos() {
	ToLog("truckrp.amx->LoadCargos->Call");
	new Query[255], cid;
    CargosValue = 0;
    mysql_query("SELECT `uid`, `name`, `weight`, `price`, `illegal`, `fromid`, `toid`, `dostepnosc` FROM `sat_cargo`");
    mysql_store_result();
	while(mysql_fetch_row_format(Query, "|")) {
	    sscanf(Query, "p<|>i", cid);
	    sscanf(Query, "p<|>is[255]fiiiii", CargoInfo[cid][uid], CargoInfo[cid][cname], CargoInfo[cid][weight], CargoInfo[cid][price], CargoInfo[cid][illegal], CargoInfo[cid][fromid], CargoInfo[cid][toid], CargoInfo[cid][dostepnosc]);
		CargosValue++;
	}
	mysql_free_result();
}

public OnPlayerConnect(playerid)
{
	new query[160],username[32];
	GetPlayerName(playerid,username,sizeof(username));
	mysql_real_escape_string(username,username);

	format(query,sizeof query,"SELECT * FROM `sat_gpos` WHERE `username` = '%s'",username);
	mysql_query(query);
	mysql_store_result();
	if(!mysql_num_rows())
	{
		format(query,sizeof query,"INSERT INTO `sat_gpos` (`username`,`playerid`,`score`,`coordinates`,`health`,`vehicle`,`active`) VALUES ('%s',%i,%i,'%s',100,0,1)",username,playerid,GetPlayerScore(playerid),"0:0:0");
		mysql_query(query);
	} else {
	    format(query,sizeof query,"UPDATE `sat_gpos` SET `playerid` = %i, `score` = %i, `coordinates` = '%s', `active` = 1 WHERE `username` = '%s'",playerid,GetPlayerScore(playerid),"0:0:0",username);
		mysql_query(query);
	}
	mysql_free_result();
	
	
	
	GetPlayerIp(playerid, PlayerIP[playerid], MAX_PLAYER_IP);
	CheckBan(playerid);
	Umarl[playerid]=0;
	Przeszkod[playerid]=0;
	Edytuje[playerid]=0;
	Ostatni[playerid]=-1;
    PlayerInfo[playerid][Jail]=0;
    PlayerInfo[playerid][Pracuje]=0;
	ClearChat(playerid);
	mandatod[playerid]=-1;
 	mandatkwota[playerid]=-1;
 	OgladaSkin[playerid]=-1;
 	pokazywaneogloszenie[playerid]=0;
	ZdajeTeoria[playerid]=0;
 	Bledow[playerid]=0;
 	AktualnePytanie[playerid]=0;

	GetPlayerName(playerid, PlayerInfo[playerid][Name], MAX_PLAYER_NAME);

	SetPlayerColor(playerid, 0xFFFFFFFF);

	SetPlayerCameraPos(playerid,-2057.3618,493.7502,139.7422);
	SetPlayerCameraLookAt(playerid, -2020.1642,691.2957,75.0519);

	PlayerInfo[playerid][Uid] = -1;
	PlayerInfo[playerid][pPos][0] = 0.0;
	PlayerInfo[playerid][pPos][1] = 0.0;
	PlayerInfo[playerid][pPos][2] = 0.0;
	PlayerInfo[playerid][pPos][3] = 0.0;
	PlayerInfo[playerid][Logged] = false;
	PlayerInfo[playerid][InCarShop] = false;
	PlayerInfo[playerid][WaitForLadunek] = false;
	PlayerInfo[playerid][UsedDialog] = -1;
	TogglePlayerDynamicCP(playerid, zaladunekcp, false);
		
	ClearChat(playerid);

	if(IsPlayerRegister(playerid))
	{
	    ShowOgloszenie(playerid, "Witaj ponownie na naszym serwerze! Wpisz haslo jakie podales przy rejestracji nowego konta.", 20);
	    ShowDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, SC_NAME, "{FFFFFF}Witaj ponownie!\nWpisz swoje has³o poni¿ej aby siê zalogowaæ!", "Zaloguj", "");
	}
	else
	{
	    ShowOgloszenie(playerid, "Witaj na ~b~Polish Trans Serwer~w~. Nie posiadamy w bazie danych jeszcze takiego konta wiec prosimy o wpisanie hasla jakiego bedziesz uzywal do przyszlego logowania.", 20);
	    ShowDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, SC_NAME, "{FFFFFF}Witaj na serwerze "SC_NAME"{FFFFFF}!\nTwój nick nie jest zarejestrowany!\nAby siê zarejestrowaæ wpisz swoje has³o poni¿ej!", "Zarejestruj", "");
	}
    SendDeathMessage(playerid, INVALID_PLAYER_ID, 200);
	ToLog("[Call]OnPlayerConnect ( %d )->Called", playerid);
	return 1;
}



public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if(checkpointid == zaladunekcp)
	{
	    if(PlayerInfo[playerid][WaitForLadunek] == true && IsPlayerInAnyVehicle(playerid) && VehicleInfo[GetVehicleUID(GetPlayerVehicleID(playerid))][ownerid] == PlayerInfo[playerid][Uid])
		{
		    new vid = GetVehicleUID(GetPlayerVehicleID(playerid));
		    if(VehicleInfo[vid][cargostat]==0)
		    {
			    new s[2000];
	  			strcat(s, ""C_CZERWONY"Lista dostêpnych towarów do rozwiezienia:\n");
			    for(new i=1; i<CargosValue; i++)
			    {
			        format(dstring, sizeof(dstring), "\t"C_ZIELONY"%s "C_BEZOWY"[%s"C_BEZOWY"]\n",
						CargoInfo[i][cname],
						((CargoInfo[i][illegal] < 1) ? (""C_ZIELONY"Legalny") : (""C_CZERWONY"Nielegalny")));
			        strcat(s, dstring);
				}
	            ShowDialog(playerid, DIALOG_TOWARY, DIALOG_STYLE_LIST, "Lista towarów", s, "Zaladuj", "Anuluj");
		        PlayerInfo[playerid][WaitForLadunek] = false;
        		TogglePlayerDynamicCP(playerid, zaladunekcp, false);
	        }
			else
			{
				ShowInfo(playerid, "Ten pojazd ma ju¿ przypisane zlecenie!");
			}
	    }
	    else
	    {
	        ShowInfo(playerid, "Ten pojazd nie nale¿y do Ciebie!");
		}
	}
	return 1;
}

CMD:gps(playerid, params[])
{
    ShowDialog(playerid, DIALOG_GPS_KATEGORIE, DIALOG_STYLE_LIST, "GPS - Typ", "{FFFFFF}Wybierz typ miejsca:\n   {C0C0C0}Za³adunki...\n   {C0C0C0}Centrale za³adunków...\n   "C_CZERWONY"Wy³¹cz GPS", "Wybierz", "Anuluj");
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    if(ZdajePraktyke==playerid)
	{
	    ZdajePraktyke=-1;
	    AtualnaTrasa=0;
	}
    Umarl[playerid]=1;
    if(Edytuje[playerid]>0)
    {
	    DestroyObject(Ostatni[playerid]);
		Przeszkod[playerid]--;
		Ostatni[playerid]=-1;
		MenuGlowne(playerid);
		Edytuje[playerid]=0;
	}
	SetPlayerHealth(playerid, 100.0);
	SetSpawnInfo(playerid, 0, 0, -1983.63, 137.957, 27.6875, 87.8143, 0, 0, 0, 0, 0, 0);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SpawnPlayer(playerid);
	PlayerInfo[playerid][interior]=0;
	PlayerInfo[playerid][vw]=0;
    return 1;
}

public OnPlayerSpawn(playerid)
{
	TextDrawHideForPlayer(playerid, Box[0]);
	TextDrawHideForPlayer(playerid, Box[1]);
	
	if(PlayerInfo[playerid][Uid]==-1)
	{
	    Kick(playerid);
	}
	if(Umarl[playerid]==1)
	{
	    SetPlayerPos(playerid, -1983.6261, 137.9566, 27.6875);
	    SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
	    Umarl[playerid]=0;
	}
	if(GetPlayerVirtualWorld(playerid)==666)
	{
	    SetPlayerVirtualWorld(playerid, 0);
	}
	SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
	
	SetPlayerInterior(playerid, PlayerInfo[playerid][interior]);
	SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][vw]);

	SetCameraBehindPlayer(playerid);

	TextDrawShowForAll(godzinaserver);
	TextDrawShowForAll(data);
	TextDrawShowForAll(godzinaswiat);
	
	TextDrawShowForPlayer(playerid, bulidInfo);

	TogglePlayerControllable(playerid, true);

	Attach3DTextLabelToPlayer(PlayerInfo[playerid][Player3DText], playerid, 0.0, 0.0, 0.1);
	
	if(strval(PlayerInfo[playerid][email])==-1)
	{
	    ShowOgloszenie(playerid, "Dla bezpieczenstwa i mozliwosci odzyskania konta w przyszlosci prosimy o podanie kontaktowego adresu email.", 20);
	    ShowDialog(playerid, DIALOG_EMAIL, DIALOG_STYLE_INPUT, "Adres Email", "WprowadŸ adres email!\n\nW przysz³oœci gdybyœ zapomnia³ has³a odzyskasz je pod adresem\nwww.Hard-Truck.pl przy u¿yciu adresu który podasz.", "Zapisz", "");
	}
	if(PlayerInfo[playerid][Jail]>=1)
	{
	    ShowInfo(playerid,"Nie odsiedzia³eœ do koñca na³o¿onej na Ciebie kary!");
		SetPlayerPos(playerid,264.9535,77.5068,1001.0391);
  		SetPlayerInterior(playerid,6);
    	SetPlayerVirtualWorld(playerid,playerid);
	    SetPlayerWorldBounds(playerid,268.5071,261.3936,81.6285,71.8745);
	}
	if(IsVip(playerid))
	{
	    PokazCzas(playerid);
	}
	return 1;
}

public OnPlayerUpdateEx(playerid)
{
	if(IsPlayerInAnyVehicle(playerid))
	{
	    odlicz++;
		new szString[255];
	    format(szString, sizeof(szString), "~r~Paliwo ~w~%.2fl~n~~g~Predkosc ~w~%dkm/h", VehicleInfo[GetVehicleUID(GetPlayerVehicleID(playerid))][petrol], GetVehSpeed(GetPlayerVehicleID(playerid)));
		TextDrawSetString(CarStatus[playerid], szString);
		new v = GetPlayerVehicleID(playerid);
		new cuid = VehicleInfo[GetVehicleUID(v)][cargo];
		if(cuid == 0) {
			format(szString, sizeof(szString), "~n~ Brak zlecenia!~n~~n~");
		} else {
		    if(VehicleInfo[GetVehicleUID(GetPlayerVehicleID(playerid))][cargostat]) {
   				format(szString, sizeof(szString), "~n~ ~r~%s ~g~(Zaladowane)~n~ ~b~Z: ~w~%s ~n~~g~ Do: ~w~%s~n~ ~w~Kwota za dostarczenie: ~g~%d$/1kg~n~", CargoInfo[cuid][cname], LoadingsInfo[CargoInfo[cuid][fromid]][lname], LoadingsInfo[CargoInfo[cuid][toid]][lname], CargoInfo[cuid][price]);
		    } else {
				format(szString, sizeof(szString), "~n~ ~r~%s~n~ ~b~Z: ~w~%s ~n~~g~ Do: ~w~%s~n~ ~w~Kwota za dostarczenie: ~g~%d$~n/1kg~", CargoInfo[cuid][cname], LoadingsInfo[CargoInfo[cuid][fromid]][lname], LoadingsInfo[CargoInfo[cuid][toid]][lname], CargoInfo[cuid][price]);
			}
		}
		//~n~ ~r~Skrzynie biegow~n~ ~b~Z: ~w~Port LS ~g~Do: ~w~Eddies WorkShop~n~ ~w~Kwota za przejazd: ~g~5000$~n~
		TextDrawSetString(CarStatus2[playerid], szString);

		GetVehicleMilleage(GetPlayerVehicleID(playerid));
		
		if(odlicz==10)
		{
		    odlicz=0;
			new alarm, bonnet, boot, objective, doors;
	     	new vid;
		 	vid = GetVehicleUID(v);
			if(v!=PojazdPraktyka)
			{
			    GetVehicleParamsEx(v,VehicleInfo[vid][engine],VehicleInfo[vid][lights],alarm,VehicleInfo[vid][locked],bonnet,boot,objective);
				if(VehicleInfo[vid][engine] == 1)
				{
				    if(VehicleInfo[vid][petrol] == 0.0)
					{
						SetVehicleParamsEx(v,false,VehicleInfo[vid][lights],alarm,doors,bonnet,boot,objective);
						SaveVehicleData(vid);
						VehicleInfo[vid][petrol] = 0;
				    } else {
			    		VehicleInfo[vid][petrol] -= 0.1;
					}
				}
			}
		}
	}
	if(PlayerInfo[playerid][Jail]>0)
	{
	    PlayerInfo[playerid][Jail]--;
	    if(PlayerInfo[playerid][Jail]==0)
	    {
	        SetPlayerWorldBounds(playerid, 20000.0000, -20000.0000, 20000.0000, -20000.0000);
	        SetPlayerPos(playerid, -1983.63, 137.957, 27.6875);
	        SetPlayerFacingAngle(playerid, 87.8143);
	        SetPlayerInterior(playerid,0);
			SetPlayerVirtualWorld(playerid,0);
			ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Wiêzienie", "Wyszed³eœ z wiêzienia.", "Rozumiem", "");
	    }
	}
	
    SetPlayerScore(playerid, PlayerInfo[playerid][Score]);
    SetPlayerMoney(playerid, PlayerInfo[playerid][Money]);
	GetPlayerPos(playerid, PlayerInfo[playerid][pPos][0], PlayerInfo[playerid][pPos][1], PlayerInfo[playerid][pPos][2]);
	GetPlayerFacingAngle(playerid,  PlayerInfo[playerid][pPos][3]);
}

public OnPlayerUpdate(playerid) {
    /*SetPlayerScore(playerid, PlayerInfo[playerid][Score]);
    SetPlayerMoney(playerid, PlayerInfo[playerid][Money]);
	GetPlayerPos(playerid, PlayerInfo[playerid][pPos][0], PlayerInfo[playerid][pPos][1], PlayerInfo[playerid][pPos][2]);
	GetPlayerFacingAngle(playerid,  PlayerInfo[playerid][pPos][3]);
	UpdatePlayerNameTags(playerid);*/
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new query[128],username[32];
	GetPlayerName(playerid,username,sizeof username);
	mysql_real_escape_string(username,username);
	format(query,sizeof query,"UPDATE `sat_gpos` SET `active` = 0 WHERE `username` = '%s'",username);
	mysql_query(query);

	PlayerInfo[playerid][interior]=GetPlayerInterior(playerid);
	PlayerInfo[playerid][vw]=GetPlayerVirtualWorld(playerid);
	if(PlayerInfo[playerid][InBinco]==false||PlayerInfo[playerid][InCarShop]==false)
	{
		PlayerInfo[playerid][vw]=0;
	}
	if(ZdajePraktyke==playerid)
	{
	    ZdajePraktyke=-1;
	    AtualnaTrasa=0;
	    PlayerInfo[playerid][vw]=0;
	}
	if(PlayerInfo[playerid][GPSON])
		DestroyDynamicMapIcon(PlayerInfo[playerid][GPSON]);
	
	Delete3DTextLabel(PlayerInfo[playerid][Player3DText]);
	if(PlayerInfo[playerid][Description])
	    Delete3DTextLabel(PlayerInfo[playerid][Description]);
	    
	TextDrawHideForPlayer(playerid, bulidInfo);

	if(PlayerInfo[playerid][SpawnedVehicle] != -1) {
	    DestroyVehicle(PlayerInfo[playerid][SpawnedVehicle]);
	}
	
	CarLoop(v)
	{
		if(VehicleInfo[v][ownerid] == PlayerInfo[playerid][Uid])
		{
		    if(VehicleInfo[v][gtauid]!=-1)
		    {
		        DestroyVehicle(VehicleInfo[v][gtauid]);
		        VehicleInfo[v][gtauid]=-1;
		        SaveVehicleData(v);
			}
		}
	}
	if(PlayerInfo[playerid][Uid]!=-1)
	{
		savePlayerStats(playerid);
	}
	if(PlayerInfo[playerid][Logged]==true)
  	{
	  	switch(reason)
	  	{
	  		case 0: format(dstring, sizeof(dstring), "%s [%d] "C_SZARY"dosta³ crasha!",PlayerInfo[playerid][Name],playerid);
			case 1: format(dstring, sizeof(dstring), "%s [%d] "C_SZARY"wyszed³ z gry!",PlayerInfo[playerid][Name],playerid);
			case 2: format(dstring, sizeof(dstring), "%s [%d] "C_SZARY"zosta³ wyrzucony/zbanowany!",PlayerInfo[playerid][Name],playerid);
		}
		SendClientMessageToAll(KOLOR_BEZOWY,dstring);
	}
	PlayerInfo[playerid][Logged]=false;
	
	PlayerInfo[playerid][InCarShop] = false;
	PlayerInfo[playerid][InBinco] = false;
	
	return 1;
}
stock GetVehicleUID(gtaid) {
	//new v;
	CarLoop(vid) {
	    if(VehicleInfo[vid][gtauid] == gtaid) {
		    return vid; //v = vid;
	    }
	}
	return 0;
}
//------------------------------------------------------------------------------
//Admin CMD

CMD:givecar(playerid, params[])
{
	if(!IsAdmin(playerid, 3))
	    return 1;
	new player, pojazd, kwota;
	if(sscanf(params, "iii", player, pojazd, kwota))
	    return ShowInfo(playerid, "U¿yj: /givecar <gracz> <model> <koszt>");
	if(!IsPlayerConnected(player))
	    return ShowInfo(playerid, "Nie ma takiego gracza");
	if(pojazd < 400)
	    return ShowInfo(playerid, "Z³y id pojazdu!");

	new szQuery[255];
	format(szQuery, sizeof(szQuery), "INSERT INTO `sat_vehicles` SET `ownerid`='%d', `model`='%d', `c1`='%d', `c2`='%d', `petrol`='100'",
	PlayerInfo[player][Uid], pojazd, random(99999), random(99999));
	mysql_query(szQuery);

	ReloadVehicles();

	PlayerInfo[playerid][Money] -= kwota;
	format(dstring, sizeof dstring, "Admin da³ Ci pojazd %d za %d$!", pojazd, kwota);
	ShowInfo(player, dstring);
	return 1;
}

CMD:acmd(playerid, params[])
{
    new s[1000];
    if(PlayerInfo[playerid][Admin]==1)
    {
  		strcat(s, "Lista komend moderatora:\n");
		strcat(s, "\t/kick <powód> - wyrzucasz gracza.\n");
		strcat(s, "\t/tpto <id> - teleportujesz siê do gracza.\n");
		strcat(s, "\t/warn <id> <powód> - warnujesz gracza.\n");
		strcat(s, "\n\nWiem ¿e ma³o komend ale dodam jak bêdê mia³ czas ;)\n");
		ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Komendy moderatora", s, "Rozumiem", "");
	}
	if(PlayerInfo[playerid][Admin]==2)
	{
  		strcat(s, "Lista komend administratora:\n");
		strcat(s, "\t/kick <id> <powód> - wyrzucasz gracza.\n");
		strcat(s, "\t/ban <id> <powód> - banujesz gracza.\n");
		strcat(s, "\t/tpto <id> - teleportujesz siê do gracza.\n");
		strcat(s, "\t/respawnall - odspawnowuje wszystkim pojazdy.\n");
        strcat(s, "\n\nWiem ¿e ma³o komend ale dodam jak bêdê mia³ czas ;)\n");
        ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Komendy administratora", s, "Rozumiem", "");
	}
	if(PlayerInfo[playerid][Admin]==3)
	{
  		strcat(s, "Lista komend HeadAdministratora:\n");
		strcat(s, "\t/kick <id> <powód> - wyrzucasz gracza.\n");
		strcat(s, "\t/ban <id> <powód> - banujesz gracza.\n");
		strcat(s, "\t/tpto <id> - teleportujesz siê do gracza.\n");
		strcat(s, "\t/tphere <id> - teleportujesz gracza do siebie.\n");
		strcat(s, "\t/tp <id 1> <id 2> - teleportujesz gracza o id1 do gracza id2.\n");
        strcat(s, "\t/veh <nazwa lub id wozu>\n");
        strcat(s, "\t/createpetrolstation <nazwa> - Tworzysz stacjê benzynow¹.\n");
        strcat(s, "\t/dajlider <id> <frakcja> - Dajesz komuœ lidera danej frakcji.\n");
        strcat(s, "\t/dajadmin <id> <poziom> - Dajesz komuœ admina.\n");
        strcat(s, "\t/saveall - Zapisujesz dane serwera.\n");
        strcat(s, "\t/respawnall - odspawnowuje wszystkim pojazdy.\n");
        strcat(s, "\n\nWiem ¿e ma³o komend ale dodam jak bêdê mia³ czas ;)\n");
        ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Komendy head-admina", s, "Rozumiem", "");
	}
	
	return 1;
}

CMD:saveall(playerid, params[])
{
	if(!IsAdmin(playerid, 2))
	    return 1;
	if(isnull(params))
	{
		SendClientMessageToAll(KOLOR_CZERWONY, "Bezpieczny zapis gry, mo¿liwy lag. (Powód: brak)");
	}
	else
	{
	    format(dstring, sizeof(dstring), "Bezpieczny zapis gry, mo¿liwy lag. (Powód: %s)", params);
	    SendClientMessageToAll(KOLOR_CZERWONY, dstring);
	}

	return 1;
}

CMD:dajlider(playerid, params[])
{
	if(!IsAdmin(playerid, 3))
	    return 1;
	new player, idfrakcji;
	if(sscanf(params, "ii", player, idfrakcji))
	    return ShowInfo(playerid, "U¿yj: /dajlider <id gracza> <id frakcji>");
	if(idfrakcji<0 || idfrakcji>MAX_FRAKCJI)
		return ShowInfo(playerid, "Z³e id frakcji!");

	PlayerInfo[player][Frakcja]=idfrakcji;
	PlayerInfo[player][Lider]=idfrakcji;
	savePlayerStats(player);
	format(dstring, sizeof(dstring), "Da³eœ lidera %s graczowi %s.", FrakcjaInfo[idfrakcji][Nazwa], PlayerInfo[player][Name]);
	ShowInfo(playerid, dstring);
	format(dstring, sizeof(dstring), "Dosta³eœ lidera frakcji %s od %s. Menu lidera masz pod /panel.", FrakcjaInfo[idfrakcji][Nazwa], PlayerInfo[playerid][Name]);
	ShowInfo(player, dstring);
	return 1;
}

CMD:dajadmin(playerid, params[])
{
	if(!IsAdmin(playerid, 3))
	    return 1;
	new player, poziom;
	if(sscanf(params, "ii", player, poziom))
	    return ShowInfo(playerid, "U¿yj: /dajadmin <id gracza> <poziom>");

	PlayerInfo[player][Admin]=poziom;
	savePlayerStats(player);
	format(dstring, sizeof(dstring), "Da³eœ Admina poziom %d graczowi %s.", poziom, PlayerInfo[player][Name]);
	ShowInfo(playerid, dstring);
	format(dstring, sizeof(dstring), "Dosta³eœ admina poziomu %d od %s. Lista komend admina jest pod /acmd.", poziom, PlayerInfo[playerid][Name]);
	ShowInfo(player, dstring);
	return 1;
}

CMD:destroyvehicle(playerid, params[])
{
	new vid;
    if(!IsAdmin(playerid, 2)) return 1;
    if(sscanf(params, "i", vid))
        return ShowInfo(playerid, "U¿yj: /destroyvehicle <car uid>");
	if(VehicleInfo[vid][gtauid]==-1)
	    return ShowInfo(playerid, "Nie ma takiego pojazdu lub zosta³ ju¿ usuniêty.");
	DestroyVehicle(VehicleInfo[vid][gtauid]);
	VehicleInfo[vid][health]=0.0;
	SaveVehicleData(vid);
	VehicleInfo[vid][gtauid]=-1;
	ShowInfo(playerid, "Pojazd usuniêty!");
    return 1;
}

CMD:kick(playerid, params[])
{
	new User, Reasona[128];

	if(!IsAdmin(playerid)) return 1;

	if(sscanf(params, "us[128]", User, Reasona))
	{
		ShowInfo(playerid, "Tip: /kick <id> <powod>");
	    return 1;
	}

	if(User == INVALID_PLAYER_ID)
	{
	    ShowInfo(playerid, "Gracz o podanym id nie jest On-Line");
	    return 1;
	}

	KaraTD("Kick", PlayerInfo[playerid][Name], PlayerInfo[User][Name], Reasona, 10);
	Kick(User);
	return 1;
}

CMD:kickall(playerid, params[])
{
	if(!IsAdmin(playerid, 3)) return 1;
	
	PlayerLoop(i)
	{
	    if(i == playerid)
	        continue;
	    Kick(i);
	}
	return 1;
}

CMD:tpto(playerid, params[]) {
	new User, Float:x, Float:y, Float:z, Float:a;
	if(!IsAdmin(playerid)) return 1;

	if(sscanf(params, "u", User)) {
		ShowInfo(playerid, "Tip: /tpto [nick/id]");
		return 1;
	}

	if(User == INVALID_PLAYER_ID) {
	    ShowInfo(playerid, "Gracz o podanym id/nick'u nie jest online.");
	    return 1;
	}

	if(IsPlayerInAnyVehicle(User)) {
	    GetVehiclePos(GetPlayerVehicleID(User), x, y, z);
	    GetVehicleZAngle(GetPlayerVehicleID(User), a);
	} else {
		GetPlayerPos(User, x, y, z);
		GetPlayerFacingAngle(User, a);
	}

	if(IsPlayerInAnyVehicle(playerid)) {
	    SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
	    SetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	} else {
		SetPlayerPos(playerid, x, y, z);
		SetPlayerFacingAngle(playerid, a);
	}
	return 1;
}
CMD:tphere(playerid, params[]) {
	new User, Float:x, Float:y, Float:z, Float:a;
	if(!IsAdmin(playerid, 2)) return 1;

	if(sscanf(params, "u", User)) {
		ShowInfo(playerid, "Tip: /tphere [nick/id]");
		return 1;
	}

	if(User == INVALID_PLAYER_ID) {
	    ShowInfo(playerid, "Gracz o podanym id/nick'u nie jest online.");
	    return 1;
	}

	if(IsPlayerInAnyVehicle(playerid)) {
	    GetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
	    GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	} else {
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
	}

	if(IsPlayerInAnyVehicle(User)) {
	    SetVehiclePos(GetPlayerVehicleID(User), x, y, z);
	    SetVehicleZAngle(GetPlayerVehicleID(User), a);
	} else {
		SetPlayerPos(User, x, y, z);
		SetPlayerFacingAngle(User, a);
	}
	return 1;
}
CMD:tp(playerid, params[]) {
	new User1, User2, Float:x, Float:y, Float:z, Float:a;
	if(!IsAdmin(playerid, 2)) return 1;

	if(sscanf(params, "uu", User1, User2)) {
		ShowInfo(playerid, "Tip: /tp [nick/id] [nick 2/id 2]");
		return 1;
	}

	if(User1 == INVALID_PLAYER_ID) {
	    ShowInfo(playerid, "Gracz o podanym id/nick'u nie jest online.");
	    return 1;
	}
	if(User2 == INVALID_PLAYER_ID) {
	    ShowInfo(playerid, "Gracz o podanym id/nick'u nie jest online.");
	    return 1;
	}

	if(IsPlayerInAnyVehicle(User2)) {
	    GetVehiclePos(GetPlayerVehicleID(User2), x, y, z);
	    GetVehicleZAngle(GetPlayerVehicleID(User2), a);
	} else {
		GetPlayerPos(User2, x, y, z);
		GetPlayerFacingAngle(User2, a);
	}

	if(IsPlayerInAnyVehicle(User1)) {
	    SetVehiclePos(GetPlayerVehicleID(User1), x, y, z);
	    SetVehicleZAngle(GetPlayerVehicleID(User1), a);
	} else {
		SetPlayerPos(User1, x, y, z);
		SetPlayerFacingAngle(User1, a);
	}
	return 1;
}

//------------------------------------------------------------------------------
//17
COMMAND:komendy(playerid,cmdtext[])
{
	return cmd_cmd(playerid,cmdtext);
}
COMMAND:help(playerid,cmdtext[])
{
	return cmd_cmd(playerid,cmdtext);
}
CMD:cmd(playerid, params[])
{
    new s[1000];
	strcat(s, "Lista komend gracza:\n");
	strcat(s, "\t/zlecenie - przyjmujesz zlecenie w centrali zg³oszeñ.\n");
	strcat(s, "\t/zaladuj - ladujesz towar na zaladunku.\n");
	strcat(s, "\t/wyladuj - wyladowujesz towar na roz³adunku.\n");
	strcat(s, "\t/anuluj - anulujesz aktualne zlecenie.\n");
	strcat(s, "\t/salon - kupujesz pojazd w salonie samochodowym.\n");
	strcat(s, "\t/gps - otwierasz menu GPS'a.\n");
	strcat(s, "\t/opis [usun/tresc] - ustawiasz opis swojej postaci (np. AFK do 17.30).\n");
	strcat(s, "\t/swiatla - (2) odpalasz œwiat³a w pojeŸdzie.\n");
	strcat(s, "\t/silnik - (LALT) odpalasz silnik w pojeŸdzie.\n");
	strcat(s, "\t/plac [id] [kwota] - przelewasz graczowi pieni¹dze.\n");
	strcat(s, "\t/v - menu zarz¹dzania pojazdem.\n");
	strcat(s, "\t/sluzba - wchodzisz na s³u¿bê w swojej frakcji.\n");
	strcat(s, "\t/autor - informacje o autorze mapy.\n");
	ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Komendy gracza", s, "Rozumiem", "");
	return 1;
}
stock NaStacji(playerid)
{
	for(new n=0; n != MAX_STACJI; n++)
	{
	    if(DoInRange(Stacje[n][SRadi], playerid, Stacje[n][SX], Stacje[n][SY], Stacje[n][SZ]))
		{
		    return n;
		}
	}
	return 0;
}
CMD:stacja(playerid, params[])
{
	new stacja = NaStacji(playerid);
    if(stacja==0)
	    return ShowInfo(playerid, "Nie jesteœ na stacji benzynowej!");
	if(!IsPlayerInAnyVehicle(playerid))
	    return ShowInfo(playerid, "Nie jesteœ w pojeŸdzie!");
	new vid = GetPlayerVehicleID(playerid);
	new vuid = GetVehicleUID(vid);
	if(VehicleInfo[vuid][petrol]==VehicleInfo[vuid][maxpetrol])
	    return ShowInfo(playerid, "Masz w pe³ni zatankowany pojazd!");

	format(dstring, sizeof(dstring), "Witaj na stacji benzynowej.\nTwój stan paliwa wynosi %.02fL/%.02fL (mo¿esz nalaæ %.02fL).\n\nPodaj ile litrów paliwa nalaæ za %.02f$:",
	    VehicleInfo[vuid][petrol],
	    VehicleInfo[vuid][maxpetrol],
	    VehicleInfo[vuid][maxpetrol]-VehicleInfo[vuid][petrol],
	    Stacje[stacja][Cena]);
    ShowDialog(playerid, DIALOG_STACJA, DIALOG_STYLE_INPUT, "Stacja Benzynowa", dstring, "Zatankuj", "WyjdŸ");
    return 1;
}
CMD:sluzba(playerid, params[])
{
	new wBazie=GetFrakcja(playerid);
	if(PlayerInfo[playerid][Pracuje]==1)
	{
		PlayerInfo[playerid][Pracuje]=0;
		SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
		format(dstring, sizeof(dstring), "Wyszed³eœ z s³u¿by w frakcji %s.", FrakcjaInfo[wBazie][Nazwa]);
		ShowInfo(playerid, dstring);
		ResetPlayerWeapons(playerid);
		return 1;
	}
	
	if(wBazie==0)
	    return ShowInfo(playerid, "Nie jesteœ w bazie ¿adnej Frakcji/Firmy.");
	if(PlayerInfo[playerid][Frakcja]!=wBazie)
	    return ShowInfo(playerid, "Nie pracujesz w tej Frakcji/Firmie.");
	if(PlayerInfo[playerid][Pracuje]==0)
	{
	    PlayerInfo[playerid][Skin]=GetPlayerSkin(playerid);
		PlayerInfo[playerid][Pracuje]=1;
		SetPlayerSkin(playerid, FrakcjaInfo[wBazie][Skin]);
		format(dstring, sizeof(dstring), "Wszed³eœ na s³u¿bê w frakcji %s. Komendy frakcji znajdziesz pod /cmds.", FrakcjaInfo[wBazie][Nazwa]);
		ShowInfo(playerid, dstring);
		//ShowInfo(playerid, "Wpisz /pojazd by zespawnowaæ pojazd frakcyjny!");
		if(ToPolicjant(playerid))
		{
		    GivePlayerWeapon(playerid, 3, 1);
		    GivePlayerWeapon(playerid, 24, 90);
		    GivePlayerWeapon(playerid, 25, 25);
		    GivePlayerWeapon(playerid, 29, 120);
		    GivePlayerWeapon(playerid, 31, 120);
		}
		return 1;
	}
	return 1;
}
COMMAND:lider(playerid,cmdtext[])
{
	return cmd_panel(playerid,cmdtext);
}
CMD:panel(playerid, params[])
{
    MenuFirmy(playerid);
    return 1;
}
CMD:anuluj(playerid, params[])
{
    new vid = GetVehicleUID(GetPlayerVehicleID(playerid));
    if(VehicleInfo[vid][cargo] == 0 &&  IsPlayerInAnyVehicle(playerid) && VehicleInfo[GetVehicleUID(GetPlayerVehicleID(playerid))][ownerid] == PlayerInfo[playerid][Uid])
        return ShowInfo(playerid, "Nie posiadasz zlecenia!");

	ShowDialog(playerid, DIALOG_ANULUJ, DIALOG_STYLE_MSGBOX, "Anulowanie zlecenia.", "Czy jesteœ pewien ¿e chcesz anulowaæ zlecenie?\nJe¿eli siê zgodzisz z twojego konta zostanie pobrane 500$.\n\nAnulowaæ zlecenie?", "Tak", "Nie");
	return 1;
}

CMD:opis(playerid, params[])
{
	new Var[255], String[512];
	if(sscanf(params, "s[255]", Var))
	{
	    ShowInfo(playerid, "Tip: /opis [usun/treœæ opisu]");
	    return 1;
	}

	if(!strcmp(Var, "usun", true))
	{
		format(String, sizeof(String), "Opis twojej postaci zostal usuniety.");
		SendClientMessage(playerid, COLOR_PURPLE, String);
		if(PlayerInfo[playerid][Description])
		    Delete3DTextLabel(PlayerInfo[playerid][Description]);
	} else {
	    if(strval(Var) > 256)
	    {
		    ShowInfo(playerid, "Opis postaci jest za d³ugi, przez co nie mo¿e zostaæ stworzony. (Max 256 znaków)");
	        return 1;
	    }
		SendClientMessage(playerid, COLOR_WHITE, "Opis twojej postaci zosta³ ustawiony (aby go usun¹æ wpisz /opis usun):");
		format(String, sizeof(String), "%s", wordwrap(Var));
		SendClientMessage(playerid, COLOR_PURPLE, String);
		if(PlayerInfo[playerid][Description]) Delete3DTextLabel(PlayerInfo[playerid][Description]);
		PlayerInfo[playerid][Description] = Create3DTextLabel(String, 0xC2A2DAFF, 1234.0, 1234.0, 1234.0, 2.0, 0, 1);
		Attach3DTextLabelToPlayer(PlayerInfo[playerid][Description], playerid, 0.0, 0.0, -0.6);
	}
	return 1;
}

CMD:swiatla(playerid, params[]) {
	if(IsPlayerInAnyVehicle(playerid)) {
		ToggleVehicleLightsState(GetPlayerVehicleID(playerid));
	}
	return 1;
}

CMD:silnik(playerid, params[]) {
	if(IsPlayerInAnyVehicle(playerid)) {
		ToggleVehicleEngineState(GetPlayerVehicleID(playerid));
	}
	return 1;
}

CMD:plac(playerid, params[]) {
	new user, cash, str[255];
	if(sscanf(params, "ui", user, cash)) {
	    ShowInfo(playerid, "Tip: /plac [nick/id] [kwota]");
	    return 1;
	}
	
	if(user == INVALID_PLAYER_ID) {
	    ShowInfo(playerid, "Gracz o podanym id nie jest on-line!");
	    return 1;
	}
	
	if(cash < 1)
	{
	    ShowInfo(playerid, "Nie poprawna kwota!");
	    return 1;
	}
	
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, PlayerInfo[user][pPos][0], PlayerInfo[user][pPos][1], PlayerInfo[user][pPos][2])) {
	    ShowInfo(playerid, "Jesteœ zbyt daleko gracza!");
		return 1;
	}

	format(str,sizeof(str),"* %s siega do kieszeni po gotówkê, nastêpnie podaje j¹ %s.", PlayerName(playerid), PlayerName(user));
	serwerme(playerid, str);
	PlayerInfo[playerid][Money] -= cash;
	PlayerInfo[user][Money] += cash;
	return 1;
}
stock GetVehicleMaxWeight(vmodel)
{
    for(new i=0; i<MAX_INSALON; i++)
    {
        if(vmodel==SalonInfo[i][0])
        {
            return SalonInfo[i][2];
		}
	}
	return 0;
}


CMD:wyladuj(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid)) return 1;
	new v = GetPlayerVehicleID(playerid);
	new vmodel = GetVehicleModel(v);
	new vid = GetVehicleUID(v);

	if(VehicleInfo[vid][cargo] == 0)
	{
	   	ShowInfo(playerid, "Nie posiadasz zlecenia!");
	    return 1;
	}

	if(VehicleInfo[vid][cargostat] == 0)
	{
	   	ShowInfo(playerid, "Nie posiadasz zaladowanego towaru!");
	    return 1;
	}

	if(IsPlayerInRangeOfPoint(playerid, 10.0, LoadingsInfo[CargoInfo[VehicleInfo[vid][cargo]][toid]][lx], LoadingsInfo[CargoInfo[VehicleInfo[vid][cargo]][toid]][ly], LoadingsInfo[CargoInfo[VehicleInfo[vid][cargo]][toid]][lz]))
	{
	    new ladownosc = GetVehicleMaxWeight(vmodel);
	    new nagroda = ladownosc*CargoInfo[VehicleInfo[vid][cargo]][price];
	    new dodnagroda;
		new vipkasa=0;
		new vipscore=1;
	    if(VehicleInfo[vid][ladunek]==1)
	    {
	        dodnagroda=200*CargoInfo[VehicleInfo[vid][cargo]][price];
		}
		if(VehicleInfo[vid][ladunek]==0)
	    {
	        dodnagroda=0;
		}
		new s[1000];
		strcat(s, "Informacje o zleceniu:\n");
		format(dstring, sizeof dstring, "Towar: %s\n", CargoInfo[VehicleInfo[vid][cargo]][cname]);
		strcat(s, dstring);
		format(dstring, sizeof dstring, "Za³adunek: %s\n", LoadingsInfo[CargoInfo[VehicleInfo[vid][cargo]][fromid]][lname]);
		strcat(s, dstring);
		format(dstring, sizeof dstring, "Wy³adunek: %s\n", LoadingsInfo[CargoInfo[VehicleInfo[vid][cargo]][toid]][lname]);
		strcat(s, dstring);
		format(dstring, sizeof dstring, "Cena (1kg): %d\n", CargoInfo[VehicleInfo[vid][cargo]][price]);
		strcat(s, dstring);
		format(dstring, sizeof dstring, "Wynagrodzenie: %d$\n", nagroda);
		strcat(s, dstring);
		format(dstring, sizeof dstring, "Wynagrodzenie za dodatkowy ³adunek %d$\n", dodnagroda);
		strcat(s, dstring);
		ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Informacje o zaladunku", s, "Rozladuj", "");
		
		GameTextForPlayer(playerid,"Wyladowanie towaru...",ladownosc*10,3);
      	SetTimerEx("Unfreeze",ladownosc*10,false,"iS",playerid,"~g~Wyladowano");
		TogglePlayerControllable(playerid,0);
		
		if(IsVip(playerid))
		{
		    vipkasa = (nagroda/100)*50;
		    vipscore=2;
			ShowInfo(playerid, "Otrzyma³eœ 50 procent wynagrodzenia i +2 score.");
		}
		VehicleInfo[vid][cargostat] = 0;
   	    VehicleInfo[vid][cargo] = 0;
   	    PlayerInfo[playerid][Dostarczen]++;
   	    if(PlayerInfo[playerid][Pracuje]==0)
   	    {
   	    	PlayerInfo[playerid][Money] += nagroda+dodnagroda+vipkasa;
		}
        if(PlayerInfo[playerid][Pracuje]==1)
   	    {
   	        new pfrakcja = PlayerInfo[playerid][Frakcja];
   	    	FrakcjaInfo[pfrakcja][Konto] = nagroda+dodnagroda+vipkasa;
   	    	format(dstring, sizeof(dstring), "UPDATE `sat_frakcje` SET `Konto`='%d' WHERE `uid`='%d'", FrakcjaInfo[pfrakcja][Konto], pfrakcja);
   	    	mysql_query(dstring);
		}
   	    
		PlayerInfo[playerid][Score] += vipscore;
		SaveVehicleData(vid);

	   	ShowInfo(playerid, "{FFFFFF}Ciê¿arówka roz³adowana! Towar dostarczony!");
	}
	else
	{
	   	ShowInfo(playerid, "Nie jesteœ przy miejscu za³adunku!");
	}
	return 1;
}

forward Unfreeze(playerid,text[]);//odmraza
public Unfreeze(playerid,text[])
{
    TogglePlayerControllable(playerid,1);
    GameTextForPlayer(playerid,text,3000,3);
	return 1;
}

CMD:zaladuj(playerid, params[]) {
	if(!IsPlayerInAnyVehicle(playerid)) return 1;
    new v = GetPlayerVehicleID(playerid);
	new vid = GetVehicleUID(v);
	new vmodel = GetVehicleModel(v);
	
	if(VehicleInfo[vid][cargo] == 0) {
	   	ShowInfo(playerid, "Nie posiadasz zlecenia!");
	    return 1;
	}
	
	if(IsPlayerInRangeOfPoint(playerid, 10.0, LoadingsInfo[CargoInfo[VehicleInfo[vid][cargo]][fromid]][lx], LoadingsInfo[CargoInfo[VehicleInfo[vid][cargo]][fromid]][ly], LoadingsInfo[CargoInfo[VehicleInfo[vid][cargo]][fromid]][lz]))
	{
	    //TODO: zaladowanie + stat = 1
	    //ShowLoadingInfo(playerid);
	    //TogglePlayerControllable(playerid, false);
	    VehicleInfo[vid][cargostat] = 1;
		SaveVehicleData(vid);
		new ladownosc = GetVehicleMaxWeight(vmodel);
		GameTextForPlayer(playerid,"Ladowanie towaru...",ladownosc*10,3);
      	SetTimerEx("Unfreeze",ladownosc*10,false,"iS",playerid,"~g~Zaladowano");
      	TogglePlayerControllable(playerid,0);
	} else {
	   	ShowInfo(playerid, "Nie jesteœ przy miejscu za³adunku!");
	}
	return 1;
}

CMD:salon(playerid, params[]) {
	if(PlayerInfo[playerid][InCarShop]) {
	    LeavePlayerFromCarShop(playerid);
	    return 1;
	}
	
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 1291.0306,-1866.4099,13.5469)) {
	    if(!IsAnyPlayerInCarShop()) {
		    GoPlayerToCarShop(playerid);
		} else {
	    	ShowInfo(playerid, "Aktualnie inny gracz korzysta z salonu! Spróbuj ponownie póŸniej ;).");
		}
	}
	return 1;
}
/*

*/
CMD:v(playerid, params[])
{
	new func[128], Params[255];
	if(sscanf(params, "s[128]S()[255]", func, Params))
	{
		ListaPrywatnychPojazdow(playerid);
	    return 1;
	}
	else if(!strcmp(func, "o", true) || !strcmp(func, "opis", true))
	{
	    new vid = GetVehicleUID(GetPlayerVehicleID(playerid));
	    new String[255];
	    if(!IsPlayerInAnyVehicle(playerid)) return 1;

	    if(isnull(Params))
		{
	        ShowInfo(playerid, "U¿yj: /v (o)pis <tresc opisu>");
	        return 1;
	    }

		if(VehicleInfo[vid][ownerid] != PlayerInfo[playerid][Uid])
		{
		    ShowInfo(playerid, "Nie jestes wlascicielem tego pojazdu wiec nie mozesz dodac opisu do niego.");
		    return 1;
		}

	    if(!strcmp(Params, "usun", true))
		{
	   		if(VehicleInfo[vid][vDesc])
			    Delete3DTextLabel(VehicleInfo[vid][vDesc]);
			//ShowInfo(playerid, "Opis usuniêty!");
	    }
		else
		{
		    if(strval(Params) > 256)
		    {
			    ShowInfo(playerid, "Opis pojazdu jest za d³ugi, przez co nie mo¿e zostaæ stworzony. (Max 256 znaków)");
		        return 1;
    		}
			SendClientMessage(playerid, COLOR_WHITE, "Opis twojego pojazdu zosta³ ustawiony (aby go usun¹æ wpisz /opis usun):");
			format(String, sizeof(String), "%s", wordwrap(Params));
			SendClientMessage(playerid, COLOR_PURPLE, String);

			if(VehicleInfo[vid][vDesc]) {
				Delete3DTextLabel(VehicleInfo[vid][vDesc]);
			}

			VehicleInfo[vid][vDesc] = Create3DTextLabel(String, 0xC2A2DAFF, 1234.0, 1234.0, 1234.0, 10.0, 0, 1);
			Attach3DTextLabelToVehicle(VehicleInfo[vid][vDesc], VehicleInfo[vid][gtauid], 0.0, 0.0, 0.5);
		}
	}
	else if(!strcmp(func, "p", true) || !strcmp(func, "parkuj", true))
	{
	    if(IsPlayerInAnyVehicle(playerid))
		{
			new szQuery[255];
		    new vid = GetVehicleUID(GetPlayerVehicleID(playerid));

			if(VehicleInfo[vid][ownerid] != PlayerInfo[playerid][Uid])
			{
			    ShowInfo(playerid, "Nie jestes wlascicielem tego pojazdu wiec nie mozesz go przeparkowac.");
			    return 1;
			}

			GetVehiclePos(GetPlayerVehicleID(playerid), VehicleInfo[vid][vx], VehicleInfo[vid][vy], VehicleInfo[vid][vz]);
			GetVehicleZAngle(GetPlayerVehicleID(playerid), VehicleInfo[vid][va]);

			format(szQuery, sizeof(szQuery), "UPDATE `sat_vehicles` SET `x`='%f', `y`='%f', `z`='%f', `a`='%f' WHERE `uid`='%d'", VehicleInfo[vid][vx], VehicleInfo[vid][vy], VehicleInfo[vid][vz], VehicleInfo[vid][va], vid);
			mysql_query(szQuery);

		    GameTextForPlayer(playerid, "~n~~n~~w~Pojazd zaparkowany pomyslnie!", 3000, 5);
		    SendClientMessage(playerid, COLOR_GREY, "/v [p(arkuj)/z(amek)/o(pis)]");
		}
	}
	if(!strcmp(func, "z", true) || !strcmp(func, "zamknij", true))
	{
	    new string[255], query[128];
 		new vehicle = GetClosestCar(playerid),
    		vehid = GetVehicleUID(vehicle);

		if(vehicle == 0) return GameTextForPlayer(playerid, "~r~Nie znajdujesz sie w poblizu zadnego pojazdu", 3000, 3);

		if(VehicleInfo[vehid][frakcja] != 0)
		{
		    if(VehicleInfo[vehid][frakcja] != PlayerInfo[playerid][Frakcja])
		    {
                ShowInfo(playerid, "Nie posiadasz kluczy do tego pojazdu.");
                return 1;
			}
		}
		if(VehicleInfo[vehid][ownerid] != PlayerInfo[playerid][Uid])
		{
			ShowInfo(playerid, "Nie posiadasz kluczy do tego pojazdu.");
   			return 1;
		}
		
		if(VehicleInfo[vehid][zamekc] == 0 && VehicleInfo[vehid][locked] == 0)
		{
		    ShowInfo(playerid, "Nie masz wykupionego zamka centralnego!");
		    return 1;
		}

		if(VehicleInfo[vehid][locked] == 0)
 		{
			SetVehicleParamsEx(VehicleInfo[vehid][gtauid], VehicleInfo[vehid][engine], VehicleInfo[vehid][lights], 0, 1, 0, 0, 0);
   			format(string, sizeof(string), "* %s zamyka pojazd %s.", PlayerName(playerid), VehicleNames[VehicleInfo[vehid][model] - 400]);
   			format(query, sizeof(query), "UPDATE `sat_vehicles` SET `locked`='1' WHERE `uid`='%d'", vehid);
   			VehicleInfo[vehid][locked] = 1;
        }
        else
        {
			SetVehicleParamsEx(VehicleInfo[vehid][gtauid], VehicleInfo[vehid][engine], VehicleInfo[vehid][lights], 0, 0, 0, 0, 0);
       		format(string, sizeof(string), "* %s otwiera pojazd %s.", PlayerName(playerid), VehicleNames[VehicleInfo[vehid][model] - 400]);
   			format(query, sizeof(query), "UPDATE `sat_vehicles` SET `locked`='0' WHERE `uid`='%d'", vehid);
   			VehicleInfo[vehid][locked] = 0;
       	}
       	mysql_query(query);
		serwerme(playerid, string);
		SendClientMessage(playerid, COLOR_GREY, "/v [p(arkuj)/z(amek)/o(pis)");
	}
	return 1;
}

stock ListaPrywatnychPojazdow(playerid)
{
	new szString[1700], buff[255], value = 1;
	szString = "{FFFFFF}UID\tStan\tPaliwo\tPrzebieg\tSpawned\tModel\n";
	CarLoop(v)
	{
		if(VehicleInfo[v][ownerid] == PlayerInfo[playerid][Uid])
		{
			GetVehicleHealth(VehicleInfo[v][gtauid], VehicleInfo[v][health]);
			format(buff, sizeof(buff), "{C0C0C0}%d\t%.1f\t%.1f\t%.1f\t\t%s\t\t%s\n",
			v,
			VehicleInfo[v][health],
			VehicleInfo[v][petrol],
			VehicleInfo[v][mileage],
			((VehicleInfo[v][gtauid] < 0) ? ("Nie") : ("Tak")),
			VehicleNames[VehicleInfo[v][model]-400]);
			strcat(szString, buff);
			WyswietlaPojazd[playerid][value]=v;
			value++;
		}
	}
	if(value == 1)
	{
		szString = "{FF0000}Nie posiadasz ¿adnych pojazdów!";
	}
	ShowDialog(playerid, DIALOG_VEHICLES, DIALOG_STYLE_LIST, "Twoje pojazdy", szString, "Wybierz", "Anuluj");
	return 1;
}
CMD:me(playerid, params[]) {
	new tresc[255];
   	if(sscanf(params, "s[255]", tresc)) {
		ShowInfo(playerid, "Tip: /me [Treœæ]");
		return 1;
	}
	format(params, 256,"** %s %s", PlayerName(playerid), tresc);
	serwerme(playerid, params);
	return 1;
}

CMD:pw(playerid, params[]) {
	cmd_pm(playerid, params);
	return 1;
}

CMD:w(playerid, params[]) {
	cmd_pm(playerid, params);
	return 1;
}

CMD:pm(playerid, params[])
{
	new User, Message[255], String[255];
	if(sscanf(params, "us[255]", User, Message)) {
	    ShowInfo(playerid, "Tip: /pm [nick/id] [treœæ]");
	    return 1;
	}

	if(User == INVALID_PLAYER_ID) {
	    ShowInfo(playerid, "Gracz o podanym id/nick'u nie jest online.");
	    return 1;
	}

	format(String, sizeof(String), "(( %s(%d): %s ))", PlayerName(playerid), playerid, Message);
	SendClientMessage(User, COLOR_YELLOW_W, String);

	format(String, sizeof(String), "(( %s(%d): %s ))", PlayerName(User), User, Message);
	SendClientMessage(playerid, COLOR_YELLOW_W_2, String);
	return 1;
}

CMD:c(playerid, params[]) {
	new str[255];
	new tresc[255];
   	if(sscanf(params, "s[255]", tresc)) {
		ShowInfo(playerid, "Tip: /c [Treœæ]");
		return 1;
	}

	format(str,sizeof(str),"%s szepcze: %s", PlayerName(playerid), tresc);
	SendClientMessageEx(8.0, playerid, str, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, COLOR_FADE1, COLOR_FADE2);
	return 1;
}

CMD:k(playerid, params[]) {
	new str[255];
	new tresc[255];
   	if(sscanf(params, "s[255]", tresc)) {
		ShowInfo(playerid, "Tip: /k [Treœæ]");
		return 1;
	}

	format(str,sizeof(str),"%s krzyczy: %s!!!", PlayerName(playerid), tresc);
	SendClientMessageEx(30.0, playerid, str, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, COLOR_FADE1, COLOR_FADE2);
	ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:do(playerid, params[]) {
	new tresc[255];
   	if(sscanf(params, "s[255]", tresc)) {
		ShowInfo(playerid, "Tip: /do [Treœæ]");
		return 1;
	}

	format(params, 256,"%s (( %s ))", tresc, PlayerName(playerid));
	serwerdo(playerid, params);
	return 1;
}

CMD:ooc(playerid, params[]) return cmd_b(playerid, params);
CMD:b(playerid, params[]) {
	new tresc[255];
   	if(sscanf(params, "s[255]", tresc)) {
		ShowInfo(playerid, "Tip: /b [wiadomosc]");
		return 1;
	}

	SendOOCMessage(playerid, tresc);
	return 1;
}


//------------------------------------------------------------------------------

stock IsPlayerHaveAnyVehicle(playerid) {
	CarLoop(i) {
		if(VehicleInfo[i][ownerid] == PlayerInfo[playerid][Uid]) {
		    return true;
		}
	}
	return false;
}
//------------------------------------------------------------------------------
stock IsVehicleInUse(vehicleid) {
	new temp;
	foreach(Player, i) {
		if(GetPlayerState(i)==PLAYER_STATE_DRIVER && GetPlayerVehicleID(i)==vehicleid) {
			temp++;
		}
	}
	if(temp > 0) { return true; } else return false;
}

stock IsAdmin(playerid, level = 1) {
	if(PlayerInfo[playerid][Admin] >= level) return 1;
	return 0;
}

stock SendOOCMessage(playerid, String[]) {
	new str[255];
	format(str,sizeof(str),"(( %s ))", String);
	SetPlayerChatBubble(playerid, str, 0xFFFFFFFF, 15.0, 10000);
	format(str,sizeof(str),"[OOC] %s: %s", PlayerName(playerid), String);
	SendClientMessage(playerid, COLOR_WHITE, str);
}

stock ShowInfo(playerid, String[])
{
	format(dstring, sizeof(dstring), ""C_ZIELONY"SERWER: {C0C0C0}%s", String);
	SendClientMessage(playerid, COLOR_GREY, dstring);
	return 1;
}

stock serwerdo(playerid, String[]) {
	return SendClientMessageEx(14.0, playerid, String, COLOR_DO, COLOR_DO2, COLOR_DO3, COLOR_DO4, COLOR_DO5);
}

stock serwerme(playerid, String[]) {
	return SendClientMessageEx(14.0, playerid, String, COLOR_PURPLE, COLOR_PURPLE2, COLOR_PURPLE3, COLOR_PURPLE4, COLOR_PURPLE5);
}

stock IsNumeric(const string[]) {
	for(new i=0, j=strlen(string); i<j; i++) {
		if(string[i] > '9' || string[i] < '0') {
			return 0;
		}
	}
	return 1;
}

stock SendClientMessageEx(Float:radi, playerid, string[], col1, col2, col3, col4, col5, echo=0)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		foreach(Player, i)
		{
			if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
			{
	        		if(echo == 0)
	        		{
					GetPlayerPos(i, posx, posy, posz);
					tempposx = (oldposx -posx);
					tempposy = (oldposy -posy);
					tempposz = (oldposz -posz);
					if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
						SendClientMessage(i, col1, string);
					else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
						SendClientMessage(i, col2, string);
					else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
						SendClientMessage(i, col3, string);
					else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
						SendClientMessage(i, col4, string);
					else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
						SendClientMessage(i, col5, string);

				}
					else if(echo == 1)
				{
					if(i != playerid)
					{
						GetPlayerPos(i, posx, posy, posz);
						tempposx = (oldposx -posx);
						tempposy = (oldposy -posy);
						tempposz = (oldposz -posz);
						if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
							SendClientMessage(i, col1, string);
						else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
							SendClientMessage(i, col2, string);
						else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
							SendClientMessage(i, col3, string);
						else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
							SendClientMessage(i, col4, string);
						else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
							SendClientMessage(i, col5, string);
					}
				}
			}
		}
	}
	return 1;
}

stock strtoupper(string[])
{
	for(new l = 0; l < strlen(string); l++)
		string[l] = toupper(string[l]);
}

stock ShowDialog(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
	PlayerInfo[playerid][UsedDialog] = -1;
	ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);
   	PlayerInfo[playerid][UsedDialog] = dialogid;
   	return 1;
}

stock ShowMessage(playerid, info[], caption[]) {
	PlayerInfo[playerid][UsedDialog] = -1;
	ShowPlayerDialog(playerid, DIALOG_MESSAGE_BOX, DIALOG_STYLE_MSGBOX, caption, info, "Zamknij", "");
   	PlayerInfo[playerid][UsedDialog] = DIALOG_MESSAGE_BOX;
}

stock SetPlayerMoney(playerid, val) {
	GivePlayerMoney(playerid, val-GetPlayerMoney(playerid));
}

stock IsPlayerRegister(playerid) {
	new szQuery[255];
	format(szQuery, sizeof(szQuery), "SELECT * FROM `sat_users` WHERE `username`='%s'", PlayerInfo[playerid][Name]);
	mysql_query(szQuery);
    mysql_store_result();
	mysql_fetch_row_format(szQuery);

	if(mysql_num_rows()!=0) {
	    mysql_free_result();
	    return 1;
	}
	return 0;
}
stock IsNickRegister(Nick[])
{
	new szQuery[255];
	format(szQuery, sizeof(szQuery), "SELECT * FROM `sat_users` WHERE `username`='%s'", Nick);
	mysql_query(szQuery);
    mysql_store_result();
	mysql_fetch_row_format(szQuery);

	if(mysql_num_rows()!=0) {
	    mysql_free_result();
	    return 1;
	}
	return 0;
}

stock ConvertColor(color) {
	new str[8];
	format(str, sizeof(str), "%06x", color >>> 8);
	return str;
}

stock SetPlayerNameEx(playerid, name[]) {
	SetPlayerName(playerid, name);
	GetPlayerName(playerid, PlayerInfo[playerid][Name], MAX_PLAYER_NAME);
}

stock DeleteSpaceFromString(name[])
{
	new pos = strfind(name, "_", true);
	if( pos != -1 )
	name[pos] = ' ';
}

stock KaraTD(Rodzaj[], Nadajacy[], Gracz[], Powod[], Count, Dni = 0, Godzin = 0, Minut = 0) {
	new String[512];
	format(String, sizeof(String), "~r~%s~n~~w~Gracz:     %s~n~Nadajacy: %s~n~Czas: %dDni, %dGodz, %dMin~n~~y~~h~%s", Rodzaj, Gracz, Nadajacy, Dni, Godzin, Minut, Powod);
	TextDrawSetString(PenaltyAnnouce, String);
	TextDrawShowForAll(PenaltyAnnouce);
	PenaltyCount = Count;
}

stock SAMPNick(playerid) {
	new szName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, szName, MAX_PLAYER_NAME);
	return szName;
}

stock PlayerName(playerid)
{
	new szName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, szName, MAX_PLAYER_NAME);
	return szName;
}

stock ClearChat(playerid = INVALID_PLAYER_ID) {
	if(playerid == INVALID_PLAYER_ID) {
	   	for(new i = 0 ; i <= 100; i++)
	   		SendClientMessageToAll(0x00CC00AA, " ");
	} else {
	   	for(new i = 0 ; i <= 100 ; i++)
	   		SendClientMessage(playerid, 0x00CC00AA, " ");
	}
}

stock GetVehicleIDFromName(vname[]) {
	CarLoop(v) {
	    if(strfind(VehicleNames[v], vname, true) != -1) {
	        return v+400;
		}
	}
	return -1;
}

public ToLog(string[]) {
//#if DEBUG == 1
	new returntofile[255];
	printf(string);
	format(returntofile, sizeof(returntofile), "%s\n", string);
	new File:handle = fopen("truck.txt", io_append);
	fwrite(handle, returntofile);
	fclose(handle);
//#endif
	return 1;
}

stock ReloadVehicles2(playerid)
{
    CarLoop(v)
	{
		if(VehicleInfo[v][ownerid] == PlayerInfo[playerid][Uid])
		{
		    if(VehicleInfo[v][gtauid]!=-1)
		    {
		        DestroyVehicle(VehicleInfo[v][gtauid]);
		        VehicleInfo[v][gtauid]=-1;
		        SaveVehicleData(v);
			}
		}
	}
	
    new Query[255], vid;
	TotalVeh=0;
	ToLog("truckrp.amx->LoadVehicles->Call");

	format(Query, 255, "SELECT `uid`, `frakcja`, `ownerid`, `model`, `c1`, `c2`, `maxpetrol`, `mileage`, `health`, `x`, `y`, `z`, `a`, `locked`, `nitro`, `hydraulika`, `paliwo`, `ladunek`, `zamekc`, `cb` FROM `sat_vehicles` WHERE `ownerid`='%d'",
	                        PlayerInfo[playerid][Uid]);
	mysql_query(Query);
	mysql_store_result();
	while(mysql_fetch_row_format(Query, "|"))
	{
	    sscanf(Query, "p<|>i", vid);
	    sscanf(Query, "p<|>iiiiiifffffffiiiiiii", VehicleInfo[vid][uid], VehicleInfo[vid][frakcja], VehicleInfo[vid][ownerid], VehicleInfo[vid][model], VehicleInfo[vid][c1], VehicleInfo[vid][c2],
	    VehicleInfo[vid][maxpetrol], VehicleInfo[vid][mileage], VehicleInfo[vid][health], VehicleInfo[vid][vx], VehicleInfo[vid][vy], VehicleInfo[vid][vz], VehicleInfo[vid][va],
		VehicleInfo[vid][locked],
		//dodatki
		VehicleInfo[vid][nitro], VehicleInfo[vid][hydraulika], VehicleInfo[vid][paliwo], VehicleInfo[vid][ladunek], VehicleInfo[vid][zamekc], VehicleInfo[vid][cb]);
		VehicleInfo[vid][gtauid]=-1;
		TotalVeh++;
	}
	mysql_free_result();
}

stock SpawnVeh(playerid, vid)
{
	if(VehicleInfo[vid][gtauid]==-1)
	{
		if(GetPlayerInterior(playerid)!=0)
	    	return ShowInfo(playerid, "Nie mo¿esz tutaz zespawnowaæ pojazdu!");
	    if(VehicleInfo[vid][health]>0.0)
	    {
	        new pierwszyraz;
	        new szQuery[250], szPlate[50];
	        format(szQuery, sizeof(szQuery), "SELECT `x`, `y`, `z`, `a`, `health`, `pierwszyraz` FROM `sat_vehicles` WHERE `uid`='%d'", vid);
			mysql_query(szQuery);
			mysql_store_result();
			mysql_fetch_row_format(szQuery);
			if(!mysql_num_rows())
			{
			    return 1;
			}
			sscanf(szQuery, "p<|>fffffi", VehicleInfo[vid][vx], VehicleInfo[vid][vy], VehicleInfo[vid][vz], VehicleInfo[vid][va], VehicleInfo[vid][health], pierwszyraz);
			
			if(pierwszyraz==0)
			{
				VehicleInfo[vid][gtauid] = 	CreateVehicle(VehicleInfo[vid][model], VehicleInfo[vid][vx], VehicleInfo[vid][vy], VehicleInfo[vid][vz], VehicleInfo[vid][va], VehicleInfo[vid][c1], VehicleInfo[vid][c2], -1);
	  			SetVehicleHealth(VehicleInfo[vid][gtauid], VehicleInfo[vid][health]);
			}
			else
			{
			    GetPlayerPos(playerid, VehicleInfo[vid][vx], VehicleInfo[vid][vy], VehicleInfo[vid][vz]);
			    GetPlayerFacingAngle(playerid, VehicleInfo[vid][va]);
			    VehicleInfo[vid][gtauid] = 	CreateVehicle(VehicleInfo[vid][model], VehicleInfo[vid][vx], VehicleInfo[vid][vy], VehicleInfo[vid][vz], VehicleInfo[vid][va], VehicleInfo[vid][c1], VehicleInfo[vid][c2], -1);
	  			SetVehicleHealth(VehicleInfo[vid][gtauid], 1000.0);
	  			PutPlayerInVehicle(playerid, VehicleInfo[vid][gtauid], 0);
	  			VehicleInfo[vid][petrol] = VehicleInfo[vid][maxpetrol];
	  			
	  			format(szQuery, sizeof(szQuery), "UPDATE `sat_vehicles` SET `x`='%f', `y`='%f', `z`='%f', `a`='%f', `petrol`='%f' WHERE `uid`='%d'", VehicleInfo[vid][vx], VehicleInfo[vid][vy], VehicleInfo[vid][vz], VehicleInfo[vid][va], VehicleInfo[vid][maxpetrol], vid);
				mysql_query(szQuery);
				GameTextForPlayer(playerid, "~n~~n~~w~Pojazd pomyœlnie zaparkowany w tym miejscu!", 3000, 5);
	  			new s[1000];
	  			strcat(s, "Jest to twój pierwszy spawn pojazdu tak wiêc zosta³\n");
                strcat(s, "on postawiony w twojej lokalizacji i tutaj zaparko-\n");
                strcat(s, "wany.\n");
                strcat(s, "Proszê siê teraz udaæ na jakiœ parking i zaparkowaæ\n");
                strcat(s, "tan swój pojazd komend¹ /v [p(arkuj)].\n");
                strcat(s, "strcat gdy tylko zaparkujesz pojazd ten od tego mo-\n");
                strcat(s, "mêtu bêdzie siê tam zawsze respawnowa³.\n");
                strcat(s, "\nOto lista komend dotycz¹ca pojazdów:\n");
                strcat(s, "/v [p(arkuj)]\n");
                strcat(s, "/v [z(amek)]\n");
                strcat(s, "/v [o(pis)]\n");
                strcat(s, "/swiatla (klawisz: 2\n");
                strcat(s, "/silnik (klawisz: LALT\n");
				ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Spawn Pojazdu", s, "Rozumiem", "");
				pierwszyraz=0;
				
				format(dstring, sizeof(dstring), "UPDATE `sat_vehicles` SET `pierwszyraz`='0' WHERE `uid`='%d'", vid);
				mysql_query(dstring);
			}
		    format(szPlate, sizeof(szPlate), "SAT %d", VehicleInfo[vid][gtauid]);
		    SetVehicleNumberPlate(VehicleInfo[vid][gtauid], szPlate);
		    SetVehicleParamsEx(VehicleInfo[vid][gtauid], 0, 0, 0, VehicleInfo[vid][locked], 0, 0, 0);
		    VehicleInfo[vid][frakcja]=0;
		    if(VehicleInfo[vid][nitro]==1)
		    {
		        AddVehicleComponent(VehicleInfo[vid][gtauid], 1010);
		    }
		    if(VehicleInfo[vid][hydraulika]==1)
		    {
		        AddVehicleComponent(VehicleInfo[vid][gtauid], 1087);
		    }
		    return 1;
		}
		else
		{
		    ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Spawn pojazdów", "Ten pojazd jest zniszczony!", "Rozumiem", "");
		    return 1;
		}
	}
	else
	{
	    GetVehicleHealth(VehicleInfo[vid][gtauid], VehicleInfo[vid][health]);
	    DestroyVehicle(VehicleInfo[vid][gtauid]);
	    VehicleInfo[vid][gtauid]=-1;
		format(dstring, sizeof(dstring), "UPDATE `sat_vehicles` SET `health`='%f' WHERE `uid`='%d'", VehicleInfo[vid][health], vid);
	}
	return 1;
}

CMD:konto(playerid, params[])
{
    ZarzadzajKontemMenu(playerid);
	return 1;
}


stock ZarzadzajKontemMenu(playerid)
{
	new s[1000];
	strcat(s, "{FFFFFF}1. Statystyki:\n");
	strcat(s, "   {C0C0C0}Statystyki konta...\n");
	strcat(s, "   {C0C0C0}Reset statystyk...\n");
	strcat(s, "{FFFFFF}2. Konto:\n");
	strcat(s, "   {C0C0C0}Zmieñ has³o...\n");
	strcat(s, "   {C0C0C0}Zmieñ login...\n");
	strcat(s, "{FFFFFF}3. Punkty premium:\n");
	strcat(s, "   {C0C0C0}Kup PP...\n");
	strcat(s, "   {C0C0C0}Wymieñ PP na KP...\n");
	strcat(s, "   {C0C0C0}Kup pojazd za PP...\n");
	ShowDialog(playerid, DIALOG_KONTO, DIALOG_STYLE_LIST, "Zarz¹dzanie kontem", s, "Wybierz", "WyjdŸ");
	return 1;
}

stock GetSalonCarIDByModelToRepair(vmodel)
{
    for(new i=0; i<MAX_INSALON; i++)
	{
		if(SalonInfo[i][0]==vmodel)
		{
		    return i;
		}
	}
	return -1;
}

stock GetSalonCarIDByModel(vmodel)
{
    for(new i=0; i<MAX_INSALON; i++)
	{
		if(SalonInfo[i][0]==vmodel)
		{
		    return i;
		}
	}
	return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid != PlayerInfo[playerid][UsedDialog])
	{
	    dialogid = PlayerInfo[playerid][UsedDialog];
	}

	switch(dialogid)
	{
	    case DIALOG_EMAIL:
	    {
			if(isnull(inputtext))
			{
			    ShowDialog(playerid, DIALOG_EMAIL, DIALOG_STYLE_INPUT, "Adres Email", "WprowadŸ adres email!\nW przysz³oœci gdybyœ zapomnia³ has³a odzyskasz je pod adresem\nwww.Hard-Truck.pl przy u¿yciu adresu który podasz.\n\nNic nie wpisa³eœ!", "Zapisz", "");
				return 1;
			}
			if(strlen(inputtext)<7)
			{
			    ShowDialog(playerid, DIALOG_EMAIL, DIALOG_STYLE_INPUT, "Adres Email", "WprowadŸ adres email!\nW przysz³oœci gdybyœ zapomnia³ has³a odzyskasz je pod adresem\nwww.Hard-Truck.pl przy u¿yciu adresu który podasz.\n\nNie poprawny format emaila!", "Zapisz", "");
				return 1;
			}
			new szEmail[255];
			mysql_real_escape_string(inputtext, szEmail);
			format(dstring, sizeof(dstring), "UPDATE `sat_users` SET `email`='%s' WHERE `username`='%s'", szEmail, PlayerInfo[playerid][Name]);
			mysql_query(dstring);
		}
	    case DIALOG_MANDAT:
	    {
	        if(response)
	        {
	            new player = mandatod[playerid];
				new kwota = mandatkwota[playerid];
				new Float: Pos[3];
				if(!IsPlayerConnected(playerid))
				    return ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Mandat", "Nie ma na serwerze policjanta który wystawi³ Ci mandat!\n\nWygl¹da na to ¿e Ci siê upiek³o.", "Rozumiem", "");
				GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
				if(!DoInRange(7.0, player, Pos[0], Pos[1], Pos[2]))
				    return ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Mandat", "Jesteœ za daleko od policjanta który wystawi³ Ci mandat", "Rozumiem", "");
    			format(dstring, sizeof(dstring), "Przyj¹³eœ mandat w wyokoœci %d$", kwota);
				ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Mandat", dstring, "Rozumiem", "");
				format(dstring, sizeof(dstring), "Gracz %s[%d] przyj¹³ mandat w wysokoœci %d$", PlayerInfo[playerid][Name], playerid, kwota);
				ShowDialog(player, 0, DIALOG_STYLE_MSGBOX, "Mandat", dstring, "Rozumiem", "");
                mandatod[playerid]=-1;
                mandatkwota[playerid]=-1;

				if(IsVip(playerid))
				{
					new dlavipa = (kwota/100)*30;
					PlayerInfo[playerid][Money]+=dlavipa;
					ShowInfo(playerid, "Otrzyma³eœ 30 procent mniej mandatu w ramach konta VIP!");
				}
				PlayerInfo[playerid][Money]-=kwota;
				FrakcjaInfo[1][Konto]+=kwota;
				format(dstring, sizeof dstring, "UPDATE `sat_frakcje` SET `Konto`='%d' WHERE `uid`='1'", FrakcjaInfo[1][Konto]);
				mysql_query(dstring);
				PlayerInfo[playerid][Mandat]++;
				PlayerInfo[playerid][karne]+=punktyilosc[playerid];
				if(PlayerInfo[playerid][karne] >= 24)
				{
					ShowInfo(playerid, "Przekroczy³eœ 24 punkty karne. Twoje prawo jazdy zosta³o skonfiskowane!");
					format(dstring, sizeof(dstring), "UPDATE `sat_prawko` SET `teoria`='0', `praktyka`='0' WHERE `username`='%s'", PlayerInfo[playerid][Name]);
					mysql_query(dstring);
					ShowInfo(player, "Gracz przekroczy³ maksymaln¹ iloœæ punktów karnych. Prawo jazdy zosta³o mu zabrane.");
				}
	        }
	        else
	        {
	            new player = mandatod[playerid];
				new kwota = mandatkwota[playerid];
	            format(dstring, sizeof(dstring), "Odrzuci³eœ mandat w wysokoœci %d$", kwota);
				ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Mandat", dstring, "Rozumiem", "");
				format(dstring, sizeof(dstring), "Gracz %s[%d] odrzuci³ mandat w wysokoœci %d$", PlayerInfo[playerid][Name], playerid, kwota);
				ShowDialog(player, 0, DIALOG_STYLE_MSGBOX, "Mandat", dstring, "Rozumiem", "");
				mandatod[playerid]=-1;
                mandatkwota[playerid]=-1;
	        }
		}
	    case DIALOG_NAPRAW:
	    {
	        if(!response) return 1;
			new pstate = GetPlayerState(playerid);
			if(pstate != PLAYER_STATE_DRIVER)
			    return ShowInfo(playerid, "Musisz byæ kierowc¹ tego pojazdu!");
			new v = GetPlayerVehicleID(playerid);
			new vid = GetVehicleUID(v);
			new Float:HP;
		    GetVehicleHealth(v,HP);
			new pkoszt=floatround((1000.0-HP)*3.1);
			if(PlayerInfo[playerid][Money]<pkoszt) return ShowInfo(playerid, "Nie staæ Ciê na t¹ naprawê!");
	        RepairVehicle(v);
			SetVehicleHealth(v,1000.0);
			ShowInfo(playerid, "Pojazd naprawiony!");
			VehicleInfo[vid][health]=1000.0;
			PlayerInfo[playerid][Money]-=pkoszt;
			FrakcjaInfo[3][Konto]+=pkoszt;
			format(dstring, sizeof dstring, "UPDATE `sat_frakcje` SET `Konto`='%d' WHERE `uid`='1'", FrakcjaInfo[3][Konto]);
			mysql_query(dstring);
		}
	    case DIALOG_KONTO:
	    {
	        if(!response) return 1;
	        if(listitem==0) return ZarzadzajKontemMenu(playerid);
	        if(listitem==1)
	        {
	            if(IsVip(playerid))
	            {
		            new CzasPrem, Days, Hours, Minutes;
					CzasPrem = PlayerInfo[playerid][VIP] - gettime();
					if (CzasPrem >= 86400)
					{
						Days = CzasPrem / 86400;
						CzasPrem = CzasPrem - (Days * 86400);
					}
					if (CzasPrem >= 3600)
					{
						Hours = CzasPrem / 3600;
						CzasPrem = CzasPrem - (Hours * 3600);
					}
					if (CzasPrem >= 60)
					{
						Minutes = CzasPrem / 60;
						CzasPrem = CzasPrem - (Minutes * 60);
					}
		            new s[1000];
		            format(s, sizeof(s), "{FFFFFF}Nick: {C0C0C0}%s\n{FFFFFF}ID: {C0C0C0}%d\n{FFFFFF}UID: {C0C0C0}%d\n{FFFFFF}Pieniêdzy: {C0C0C0}%d\n{FFFFFF}Score: {C0C0C0}%d\n{FFFFFF}PP: {C0C0C0}%d\n{FFFFFF}KP: {C0C0C0}%d {FFFFFF}dni, {C0C0C0}%d {FFFFFF}godzin i {C0C0C0}%d {FFFFFF}minut\n{FFFFFF}Aresztowañ: {C0C0C0}%d\n{FFFFFF}Mandatów: {C0C0C0}%d\n{FFFFFF}Dostarczonych towarów: {C0C0C0}%d\n{FFFFFF}Punktów karnych: {C0C0C0}%d/24",
		                PlayerInfo[playerid][Name],
		                playerid,
		                PlayerInfo[playerid][Uid],
		                PlayerInfo[playerid][Money],
		                PlayerInfo[playerid][Score],
		                PlayerInfo[playerid][Gold],
						Days, Hours, Minutes,
						PlayerInfo[playerid][Areszt],
						PlayerInfo[playerid][Mandat],
						PlayerInfo[playerid][Dostarczen],
						PlayerInfo[playerid][karne]);
		            ShowDialog(playerid, DIALOG_KONTO+2, DIALOG_STYLE_MSGBOX, "Zarz¹dzanie kontem - Statystyki konta", s, "Wróæ", "");
				}
				else
				{
		            new s[1000];
		            format(s, sizeof(s), "{FFFFFF}Nick: {C0C0C0}%s\n{FFFFFF}ID: {C0C0C0}%d\n{FFFFFF}UID: {C0C0C0}%d\n{FFFFFF}Pieniêdzy: {C0C0C0}%d\n{FFFFFF}Score: {C0C0C0}%d\n{FFFFFF}PP: {C0C0C0}%d\n{FFFFFF}KP: {C0C0C0}nie aktywne\n{FFFFFF}Aresztowañ: {C0C0C0}%d\n{FFFFFF}Mandatów: {C0C0C0}%d\n{FFFFFF}Dostarczonych towarów: {C0C0C0}%d",
		                PlayerInfo[playerid][Name],
		                playerid,
		                PlayerInfo[playerid][Uid],
		                PlayerInfo[playerid][Money],
		                PlayerInfo[playerid][Score],
		                PlayerInfo[playerid][Gold],
						PlayerInfo[playerid][Areszt],
						PlayerInfo[playerid][Mandat],
						PlayerInfo[playerid][Dostarczen]);
		            ShowDialog(playerid, DIALOG_KONTO+2, DIALOG_STYLE_MSGBOX, "Zarz¹dzanie kontem - Statystyki konta", s, "Wróæ", "");
				}
	            return 1;
	        }
	        if(listitem==2)
	        {
	            ShowDialog(playerid, DIALOG_KONTO+3, DIALOG_STYLE_MSGBOX, "Zarz¹dzanie kontem - Reset statystyk", "Je¿eli klikniesz resetuj to twoje konto zostanie przywrócone\ndo stanu jak byœ dopiero zacz¹³ grê.", "Resetuj", "Wruæ");
	            return 1;
	        }
	        if(listitem==3) return ZarzadzajKontemMenu(playerid);
	        if(listitem==4) return ShowDialog(playerid, DIALOG_KONTO+1, DIALOG_STYLE_PASSWORD, "Zarz¹dzanie kontem - Zmieñ has³o", "Wpisz nowe has³o:", "Zmieñ", "Cofnij");
	        if(listitem==5) return ShowDialog(playerid, DIALOG_KONTO+8, DIALOG_STYLE_INPUT, "Zarz¹dzanie kontem - Zmieñ login", "Podaj nowy login:", "Zmieñ", "Cofnij");
	        if(listitem==6) return ZarzadzajKontemMenu(playerid);
	        if(listitem==7) return cmd_pp(playerid, "");
	        if(listitem==8)
	        {
	            if(IsVip(playerid))
	            {
	                ZarzadzajKontemMenu(playerid);
	                ShowInfo(playerid, "Konto Premium mo¿esz przed³u¿yæ dopiero po wygaœniêciu aktualnego!");
					return 1;
				}
				new s[1000];
	            strcat(s, "{FFFFFF}Cena (PP)\tOkres wa¿noœci KP\n");
	            strcat(s, "{C0C0C0}100PP\t\t1 tydzieñ\n");
	            strcat(s, "{C0C0C0}180PP\t\t2 tygodnie\n");
	            strcat(s, "{C0C0C0}350PP\t\t1 miesi¹c");
	            ShowDialog(playerid, DIALOG_KONTO+4, DIALOG_STYLE_LIST, "Zarz¹dzenia kontem - Wymieñ PP na KP", s, "Wybierz", "Wróæ");
				return 1;
			}
			if(listitem==9)
			{
			    new s[2000];
			    strcat(s, "{FFFFFF}Cena\t\tModel\n");
			    for(new i=0; i<MAX_POJAZDOWVIP; i++)
			    {
			    	format(dstring, sizeof(dstring), "{C0C0C0}%dPP\t\t[%d]%s\n", PojazdyDlaVip[i][1], PojazdyDlaVip[i][0], VehicleNames[PojazdyDlaVip[i][0] - 400]);
					strcat(s, dstring);
				}
				ShowDialog(playerid, DIALOG_KONTO+5, DIALOG_STYLE_LIST, "Zarz¹dzenia kontem - Kup pojazd za PP", s, "Kup", "Wróæ");
			}
	    }
	    case DIALOG_KONTO+8:
	    {
	        if(!response)
	            return ZarzadzajKontemMenu(playerid);
	            
			if(strlen(inputtext) < 3 || strlen(inputtext) > MAX_PLAYER_NAME)
			    return ShowDialog(playerid, DIALOG_KONTO+8, DIALOG_STYLE_INPUT, "Zarz¹dzanie kontem - Zmieñ login", "Podaj nowy login:\n\n{FF0000}Nick powinien siê sk³adaæ z minimum 3 i maximum 20 znaków!", "Zmieñ", "Cofnij");
			new szQuery[255];
			format(szQuery, 255, "SELECT * FROM `sat_users` WHERE `username`='%s'", inputtext);
	        mysql_query(szQuery);
	        mysql_store_result();
			mysql_fetch_row_format(szQuery);

			if(mysql_num_rows()!=0) {
			    mysql_free_result();
			    return ShowDialog(playerid, DIALOG_KONTO+8, DIALOG_STYLE_INPUT, "Zarz¹dzanie kontem - Zmieñ login", "Podaj nowy login:\n\n{FF0000}Ten nick jest ju¿ zajêty. Podaj inny!", "Zmieñ", "Cofnij");
			}
			mysql_free_result();
	        
			KaraTD("Kick", "Serwer", PlayerInfo[playerid][Name], "Zmiana nicku", 10);
			Kick(playerid);
			format(szQuery, 255, "UPDATE `sat_users` SET `username`='%s' WHERE `username`='%s'", inputtext, PlayerInfo[playerid][Name]);
			mysql_query(szQuery);
			mysql_free_result();
	        return 1;
	    }
	    case DIALOG_KONTO+5:
	    {
	        if(response)
	        {
	            if(listitem==0)
	            {
		            new s[2000];
				    strcat(s, "{FFFFFF}Cena\t\tModel\n");
				    for(new i=0; i<MAX_POJAZDOWVIP; i++)
				    {
				    	format(dstring, sizeof(dstring), "{C0C0C0}%dPP\t\t[%d]%s\n", PojazdyDlaVip[i][1], PojazdyDlaVip[i][0], VehicleNames[PojazdyDlaVip[i][0] - 400]);
						strcat(s, dstring);
					}
					ShowDialog(playerid, DIALOG_KONTO+5, DIALOG_STYLE_LIST, "Zarz¹dzenia kontem - Kup pojazd za PP", s, "Kup", "Wróæ");
				}
	            if(PlayerInfo[playerid][Gold]>=PojazdyDlaVip[listitem-1][1])
	            {
	                new szQuery[255];
					format(szQuery, sizeof(szQuery), "INSERT INTO `sat_vehicles` SET `ownerid`='%d', `model`='%d', `c1`='%d', `c2`='%d', `petrol`='100'",
					PlayerInfo[playerid][Uid], PojazdyDlaVip[listitem-1][0], random(99999), random(99999));
					mysql_query(szQuery);
					ReloadVehicles();
					PlayerInfo[playerid][Gold]-=PojazdyDlaVip[listitem-1][1];
					format(dstring, sizeof(dstring), "UPDATE `sat_users` SET `Gold`='%d' WHERE `uid`='%d'", PlayerInfo[playerid][Gold], PlayerInfo[playerid][Uid]);
					mysql_query(dstring);
	            }
	            else
	            {
	                ShowInfo(playerid, "Nie staæ Ciê na ten pojazd!");
	                new s[2000];
				    strcat(s, "{FFFFFF}Cena\t\tModel\n");
				    for(new i=0; i<MAX_POJAZDOWVIP; i++)
				    {
				    	format(dstring, sizeof(dstring), "{C0C0C0}%dPP\t\t[%d]%s\n", PojazdyDlaVip[i][1], PojazdyDlaVip[i][0], VehicleNames[PojazdyDlaVip[i][0] - 400]);
						strcat(s, dstring);
					}
					ShowDialog(playerid, DIALOG_KONTO+5, DIALOG_STYLE_LIST, "Zarz¹dzenia kontem - Kup pojazd za PP", s, "Kup", "Wróæ");
				}
	        }
	        else
	        {
	            ZarzadzajKontemMenu(playerid);
	        }
		}
	    case DIALOG_KONTO+4:
	    {
	        if(response)
	        {
				if(listitem==0)
				{
    				if(IsVip(playerid))
		            {
		                ZarzadzajKontemMenu(playerid);
		                ShowInfo(playerid, "Konto Premium mo¿esz przed³u¿yæ dopiero po wygaœniêciu aktualnego!");
						return 1;
					}
					new s[1000];
		            strcat(s, "{FFFFFF}Cena (PP)\tOkres wa¿noœci KP\n");
		            strcat(s, "{C0C0C0}100PP\t1 tydzieñ\n");
		            strcat(s, "{C0C0C0}180PP\t2 tygodnie\n");
		            strcat(s, "{C0C0C0}350PP\t1 miesi¹c");
		            ShowDialog(playerid, DIALOG_KONTO+4, DIALOG_STYLE_LIST, "Zarz¹dzenia kontem - Wymieñ PP na KP", s, "Wybierz", "Wróæ");
					return 1;
				}
	            if(listitem==1)
	            {
	                if(PlayerInfo[playerid][Gold]>=100)
	                {
	                    GiveVip(playerid, 7, 0, 100);
	                    format(dstring, sizeof(dstring), "Dosta³eœ VIP'a na %i Dni i %i Godzin ! Komendy: /vcmd.", 7, 0);
						ShowInfo(playerid, dstring);
						ShowInfo(playerid, "Proszê zrobiæ reloga!");
						KaraTD("Kick", "System", PlayerInfo[playerid][Name], "Nadanie konta VIP", 10);
						Kick(playerid);
					}
					else
					{
					    ShowInfo(playerid, "Nie staæ ciê na t¹ opcjê!");
					    ZarzadzajKontemMenu(playerid);
					}
				}
				if(listitem==2)
	            {
	                if(PlayerInfo[playerid][Gold]>=180)
	                {
	                    GiveVip(playerid, 14, 0, 180);
	                    format(dstring, sizeof(dstring), "Dosta³eœ VIP'a na %i Dni i %i Godzin ! Komendy: /vcmd.", 14, 0);
						ShowInfo(playerid, dstring);
						ShowInfo(playerid, "Proszê zrobiæ reloga!");
						KaraTD("Kick", "System", PlayerInfo[playerid][Name], "Nadanie konta VIP", 10);
						Kick(playerid);
					}
					else
					{
					    ShowInfo(playerid, "Nie staæ ciê na t¹ opcjê!");
					    ZarzadzajKontemMenu(playerid);
					}
				}
				if(listitem==3)
	            {
	                if(PlayerInfo[playerid][Gold]>=350)
	                {
	                    GiveVip(playerid, 30, 0, 350);
	                    format(dstring, sizeof(dstring), "Dosta³eœ VIP'a na %i Dni i %i Godzin ! Komendy: /vcmd.", 30, 0);
						ShowInfo(playerid, dstring);
						ShowInfo(playerid, "Proszê zrobiæ reloga!");
						KaraTD("Kick", "System", PlayerInfo[playerid][Name], "Nadanie konta VIP", 10);
						Kick(playerid);
					}
					else
					{
					    ShowInfo(playerid, "Nie staæ ciê na t¹ opcjê!");
					    ZarzadzajKontemMenu(playerid);
					}
				}
			}
			else
			{
			    ZarzadzajKontemMenu(playerid);
			}
			return 1;
		}
	    case DIALOG_KONTO+3:
	    {
	        if(response)
	        {
				PlayerInfo[playerid][Money]=1000;
				PlayerInfo[playerid][Score]=0;
				PlayerInfo[playerid][Areszt]=0;
				PlayerInfo[playerid][Mandat]=0;
				PlayerInfo[playerid][Dostarczen]=0;
				PlayerInfo[playerid][Frakcja]=0;
				PlayerInfo[playerid][Lider]=0;
				PlayerInfo[playerid][Pracuje]=0;
				PlayerInfo[playerid][Jail]=0;
				PlayerInfo[playerid][Skin]=0;
				CarLoop(vid)
				{
	    			if(VehicleInfo[vid][ownerid] == PlayerInfo[playerid][Uid])
	    			{
	    			    if(VehicleInfo[vid][gtauid]!=-1)
	    			    {
			    	    	DestroyVehicle(VehicleInfo[vid][gtauid]);
	    					VehicleInfo[vid][gtauid]=-1;
						}
						VehicleInfo[vid][ownerid]=0;
						SaveVehicleData(vid);
	    			}
				}
				SpawnPlayer(playerid);
	        }
	    }
	    case DIALOG_KONTO+1:
	    {
	        new szPass[255];
	        if(!response) return ZarzadzajKontemMenu(playerid);
	        if(isnull(inputtext))
	            return ShowDialog(playerid, DIALOG_KONTO+1, DIALOG_STYLE_PASSWORD, "Zarz¹dzanie kontem - Zmieñ has³o", "Nic nie wpisa³eœ!\n\nWpisz nowe has³o:", "Zmieñ", "Cofnij");
			if(strlen(inputtext) < 3 || strlen(inputtext) > 20)
			    return ShowDialog(playerid, DIALOG_KONTO+1, DIALOG_STYLE_PASSWORD, "Zarz¹dzanie kontem - Zmieñ has³o", "Z³a d³ugoœæ has³a!\n\nWpisz nowe has³o:", "Zmieñ", "Cofnij");

			mysql_real_escape_string(inputtext, szPass);
			format(dstring, sizeof(dstring), "UPDATE `sat_users` SET `password`=md5('%s') WHERE `username`='%s'", szPass, PlayerInfo[playerid][Name]);
			mysql_query(dstring);
			format(dstring, sizeof dstring, "Has³o zmienione prawid³owo na %s.", inputtext);
			ShowDialog(playerid, DIALOG_KONTO+2, DIALOG_STYLE_MSGBOX, "Zarz¹dzanie kontem - Zmieñ has³o", dstring, "Rozumiem", "");
		}
		case DIALOG_KONTO+2:
		{
		    ZarzadzajKontemMenu(playerid);
		}
	    case DIALOG_STACJA:
	    {
	        if(response)
	        {
		    	new stacja = NaStacji(playerid);
		    	new Float: wwybral = floatstr(inputtext);
			    if(stacja==0)
				    return ShowInfo(playerid, "Nie jesteœ na stacji benzynowej!");
				if(!IsPlayerInAnyVehicle(playerid))
				    return ShowInfo(playerid, "Nie jesteœ w pojeŸdzie!");
				new v = GetPlayerVehicleID(playerid);
				new vid = GetVehicleUID(v);
				if(VehicleInfo[vid][petrol]==VehicleInfo[vid][maxpetrol])
				    return ShowInfo(playerid, "Masz w pe³ni zatankowany pojazd!");
				if(wwybral+VehicleInfo[vid][petrol] > VehicleInfo[vid][maxpetrol] || wwybral < 0)
				{
				    format(dstring, sizeof(dstring), "Witaj na stacji benzynowej.\nTwój stan paliwa wynosi %.02fL/%f.02fL (mo¿esz nalaæ %.02f).\n\nPoda³eœ za du¿o litrów paliwa!\n\nPodaj ile litrów paliwa nalaæ za %.02f$:",
					    VehicleInfo[vid][petrol],
					    VehicleInfo[vid][maxpetrol],
					    VehicleInfo[vid][maxpetrol]-VehicleInfo[vid][petrol],
					    Stacje[stacja][Cena]);
					return ShowDialog(playerid, DIALOG_STACJA, DIALOG_STYLE_INPUT, "Stacja Benzynowa", dstring, "Zatankuj", "WyjdŸ");
				}
				if(wwybral<=0.0)
				{
				    format(dstring, sizeof(dstring), "Witaj na stacji benzynowej.\nTwój stan paliwa wynosi %.02f/%.02fL (mo¿esz nalaæ %.02f).\n\nPoda³eœ za nisk¹ wartoœæ litrów paliwa!\n\nPodaj ile litrów paliwa nalaæ za %.02f$:",
					    VehicleInfo[vid][petrol],
					    VehicleInfo[vid][maxpetrol],
					    VehicleInfo[vid][maxpetrol]-VehicleInfo[vid][petrol],
					    Stacje[stacja][Cena]);
					return ShowDialog(playerid, DIALOG_STACJA, DIALOG_STYLE_INPUT, "Stacja Benzynowa", dstring, "Zatankuj", "WyjdŸ");
				}
				new zaplac = floatround(wwybral)*floatround(Stacje[stacja][Cena]);
				if(zaplac > PlayerInfo[playerid][Money])
				{
				    format(dstring, sizeof(dstring), "Witaj na stacji benzynowej.\nTwój stan paliwa wynosi %.02f/%.02fL (mo¿esz nalaæ %.02f).\n\nNie staæ Ciê na tyle paliwa!\n\nPodaj ile litrów paliwa nalaæ za %.02f$:",
					    VehicleInfo[vid][petrol],
					    VehicleInfo[vid][maxpetrol],
					    VehicleInfo[vid][maxpetrol]-VehicleInfo[vid][petrol],
					    Stacje[stacja][Cena]);
					return ShowDialog(playerid, DIALOG_STACJA, DIALOG_STYLE_INPUT, "Stacja Benzynowa", dstring, "Zatankuj", "WyjdŸ");
				}
				VehicleInfo[vid][petrol]+=wwybral;
				PlayerInfo[playerid][Money]-=zaplac;
				format(dstring, sizeof(dstring), "Zatankowa³eœ %.02f litrów paliwa za %d$.\nTwój aktualny stan paliwa w pojeŸdzie wynosi %.02f/%.02fL.",
				    wwybral,
				    zaplac,
					VehicleInfo[vid][petrol],
					VehicleInfo[vid][maxpetrol]);
				ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Stacja Benzynowa", dstring, "Rozumiem", "");
	        }
		}
		case DIALOG_VEHICLES:
		{
		    if(!response) return 1;
		    new s[1000];
			Wybral[playerid] = WyswietlaPojazd[playerid][listitem];
			format(dstring, sizeof(dstring), "{FFFFFF}Zarz¹dzanie pojazdem %s [UID: %d]:\n",
				VehicleNames[VehicleInfo[Wybral[playerid]][model]-400],
				Wybral[playerid]);
			strcat(s, dstring);
			format(dstring, sizeof(dstring), "  {C0C0C0}%s\n", ((VehicleInfo[Wybral[playerid]][gtauid] < 0) ? ("Zespawnuj...") : ("Odspawnuj...")));
			strcat(s, dstring);
			strcat(s, "  {C0C0C0}Dodatki...\n");
			strcat(s, "  {C0C0C0}Z³omuj...\n");
			strcat(s, "  {C0C0C0}Napraw...\n");
			strcat(s, "  {C0C0C0}Przypisz...\n");
			strcat(s, "  {C0C0C0}Namierz...\n");
		    ShowDialog(playerid, DIALOG_VEHICLES+1, DIALOG_STYLE_LIST, "Lista pojazdów - zarz¹dzanie pojazdem", s, "Wybierz", "Cofnij");
		}
		case DIALOG_VEHICLES+1:
		{
		    if(response)
		    {
		        if(listitem==0)
		        {
		            new s[1000];
					format(dstring, sizeof(dstring), "{FFFFFF}Zarz¹dzanie pojazdem %s [UID: %d]:\n", VehicleNames[VehicleInfo[Wybral[playerid]][model]-400], Wybral[playerid]);
					strcat(s, dstring);
					format(dstring, sizeof(dstring), "  {C0C0C0}%s\n", ((VehicleInfo[Wybral[playerid]][gtauid] < 0) ? ("Zespawnuj...") : ("Odspawnuj...")));
					strcat(s, dstring);
					strcat(s, "  {C0C0C0}Dodatki...\n");
					strcat(s, "  {C0C0C0}Z³omuj...\n");
					strcat(s, "  {C0C0C0}Napraw...\n");
					strcat(s, "  {C0C0C0}Przypisz...\n");
					strcat(s, "  {C0C0C0}Namierz...\n");
				    ShowDialog(playerid, DIALOG_VEHICLES+1, DIALOG_STYLE_LIST, "Lista pojazdów - zarz¹dzanie pojazdem", s, "Wybierz", "Cofnij");
		        }
		        if(listitem==1)
					return SpawnVeh(playerid, Wybral[playerid]);
		        if(listitem==2)
		        {
		            new veh = Wybral[playerid];
		            new s[1500];
					format(dstring, sizeof(dstring), "{FFFFFF}Cena\tDodatek\tStatus\n", VehicleNames[VehicleInfo[veh][model]-400], veh);
					strcat(s, dstring);
					format(dstring, sizeof(dstring), "{C0C0C0}400$\tNitro\t\t[%s{C0C0C0}]\n", ((VehicleInfo[veh][nitro] == 1) ? (""C_ZIELONY"Wykupione") : (""C_CZERWONY"Nie wykupione")));
					strcat(s, dstring);
					format(dstring, sizeof(dstring), "{C0C0C0}300$\tHydraulika\t[%s{C0C0C0}]\n", ((VehicleInfo[veh][hydraulika] == 1) ? (""C_ZIELONY"Wykupione") : (""C_CZERWONY"Nie wykupione")));
                    strcat(s, dstring);
                    format(dstring, sizeof(dstring), "{C0C0C0}700$\t+30 paliwa\t[%s{C0C0C0}]\n", ((VehicleInfo[veh][paliwo] == 1) ? (""C_ZIELONY"Wykupione") : (""C_CZERWONY"Nie wykupione")));
		  			strcat(s, dstring);
		  			format(dstring, sizeof(dstring), "{C0C0C0}1000$\tDod. £adunek\t[%s{C0C0C0}]\n", ((VehicleInfo[veh][ladunek] == 1) ? (""C_ZIELONY"Wykupione") : (""C_CZERWONY"Nie wykupione")));
		  			strcat(s, dstring);
		  			format(dstring, sizeof(dstring), "{C0C0C0}100$\tZamek Centr.\t[%s{C0C0C0}]\n", ((VehicleInfo[veh][zamekc] == 1) ? (""C_ZIELONY"Wykupione") : (""C_CZERWONY"Nie wykupione")));
		  			strcat(s, dstring);
		  			format(dstring, sizeof(dstring), "{C0C0C0}500$\tCB-Radio\t[%s{C0C0C0}]\n", ((VehicleInfo[veh][cb] > -1) ? (""C_ZIELONY"Wykupione") : (""C_CZERWONY"Nie wykupione")));
		  			strcat(s, dstring);
                    ShowDialog(playerid, DIALOG_VEHICLES+2, DIALOG_STYLE_LIST, "Lista pojazdów - zarz¹dzanie dodatkami", s, "Kup", "Cofnij");
				}
				if(listitem==3)
				{
				    new vid = Wybral[playerid];
				    if(VehicleInfo[vid][gtauid]!=-1)
					{
					    ListaPrywatnychPojazdow(playerid);
						ShowInfo(playerid, "By zez³omowaæ pojazd nie mo¿esz mieæ go zespawnowanego!");
						return 1;
					}
				    new vshopid = GetSalonCarIDByModel(VehicleInfo[vid][model]);
				    new zakwote = SalonInfo[vshopid][1]/3;
				    format(dstring, sizeof(dstring), "Czy na pewno chcesz zez³omowaææ pojazd %s [UID: %d] za %d$?", VehicleNames[VehicleInfo[vid][model]-400], VehicleInfo[vid][uid], zakwote);
				    ShowDialog(playerid, DIALOG_VEHICLES+3, DIALOG_STYLE_MSGBOX, "Lista pojazdów - z³omowanie", dstring, "Tak", "Nie");
				}
				if(listitem==4)
				{
				    ShowInfo(playerid, "By naprawiæ pojazd wezwij PomocDrogow¹.");
				    /*
				    new vid = Wybral[playerid];
				    if(VehicleInfo[vid][gtauid]!=-1)
					{
					    ListaPrywatnychPojazdow(playerid);
						ShowInfo(playerid, "By naprawiæ pojazd nie mo¿esz mieæ go zespawnowanego!");
						return 1;
					}
					if(VehicleInfo[vid][health]!=0.0000)
					{
					    ListaPrywatnychPojazdow(playerid);
						ShowInfo(playerid, "By naprawiæ pojazd musi mieæ on 0.0000 HP!");
						return 1;
					}
				    new vshopid = GetSalonCarIDByModelToRepair(VehicleInfo[vid][model]);
				    new zakwote;
				    if(vshopid==-1)
				    {
			     		zakwote = 100000;
					}
					else
					{
					    zakwote = SalonInfo[vshopid][1]/2;
					}
				    format(dstring, sizeof(dstring), "Czy na pewno chcesz naprawiæ pojazd %s [UID: %d] za %d$?", VehicleNames[VehicleInfo[vid][model]-400], VehicleInfo[vid][uid], zakwote);
				    ShowDialog(playerid, DIALOG_VEHICLES+5, DIALOG_STYLE_MSGBOX, "Lista pojazdów - naprawa", dstring, "Tak", "Nie");
					*/
				}
				if(listitem==5)
				{
				    new vid = Wybral[playerid];
				    new pfrakcja = PlayerInfo[playerid][Frakcja];
				    if(VehicleInfo[vid][gtauid]!=-1)
					{
					    ListaPrywatnychPojazdow(playerid);
						ShowInfo(playerid, "By przypisaæ pojazd nie mo¿esz mieæ go zespawnowanego!");
						return 1;
					}
					format(dstring, sizeof(dstring), "Czy na pewno chcesz przypisaæ pojazd %s[UID: %d] pod frakcjê %s[UID: %d]?", VehicleNames[VehicleInfo[vid][model]-400], VehicleInfo[vid][uid], FrakcjaInfo[pfrakcja][Nazwa], pfrakcja);
					ShowDialog(playerid, DIALOG_VEHICLES+6, DIALOG_STYLE_MSGBOX, "Lista pojazdów - Przypisz", dstring, "Tak", "Nie");
				}
				if(listitem==6)
				{
					new vid = Wybral[playerid];
					new v = VehicleInfo[vid][gtauid];
					if(v == -1)
					{
						ListaPrywatnychPojazdow(playerid);
						ShowInfo(playerid, "By namierzyæ pojazd musi on byæ zespawnowany!");
						return 1;
					}
					new Float: Pos[3];
					GetVehiclePos(v, Pos[0], Pos[1], Pos[2]);
					TogglePlayerDynamicCP(playerid, PlayerInfo[playerid][Namierzanie], 0);
					DestroyDynamicCP(PlayerInfo[playerid][Namierzanie]);
					PlayerInfo[playerid][Namierzanie] = CreateDynamicCP(Pos[0], Pos[1], Pos[2], 5.0, -1, -1, playerid, 100.0);
					TogglePlayerDynamicCP(playerid, PlayerInfo[playerid][Namierzanie], 1);
					
					DestroyDynamicMapIcon(PlayerInfo[playerid][NamierzIcon]);
					PlayerInfo[playerid][NamierzIcon] = CreateDynamicMapIcon(Pos[0], Pos[1], Pos[2], 55, 0, 0, 0, playerid, 999999.0);
					Streamer_SetIntData(STREAMER_TYPE_MAP_ICON, PlayerInfo[playerid][NamierzIcon], E_STREAMER_STYLE, MAPICON_GLOBAL);
					Streamer_Update(playerid);
				}
		    }
		    if(!response)
		    {
		        ListaPrywatnychPojazdow(playerid);
			}
		}
		case DIALOG_VEHICLES+6:
		{
		    if(response)
		    {
		        new vid = Wybral[playerid];
		    	new pfrakcja = PlayerInfo[playerid][Frakcja];
		    	if(pfrakcja == 1 || pfrakcja == 2)
		    	{
		    	    ShowInfo(playerid, "Nie mo¿esz przypisaæ pojazdu pod t¹ frakcjê!");
		    	    ListaPrywatnychPojazdow(playerid);
		    	    return 1;
				}
		    	if(VehicleInfo[vid][gtauid]!=-1)
				{
  					ListaPrywatnychPojazdow(playerid);
					ShowInfo(playerid, "By przypisaæ pojazd nie mo¿esz mieæ go zespawnowanego!");
					return 1;
				}
				VehicleInfo[vid][ownerid]=-1;
				VehicleInfo[vid][frakcja]=pfrakcja;
				format(dstring, sizeof(dstring), "UPDATE `sat_vehicles` SET `ownerid`='-1', `frakcja`='%d' WHERE `uid`='%d'", pfrakcja, vid);
				mysql_query(dstring);
				ReloadVehicles();
				ShowDialog(playerid, DIALOG_VEHICLES+4, DIALOG_STYLE_MSGBOX, "Lista pojazdów - Przypisz", "Pomyœlnie przypisa³eœ pojazd!\nOd teraz jest on dostêpny pod komend¹ /pojazd w twojej frakcji.", "Wróæ", "");
				return 1;
			}
		}
		case DIALOG_VEHICLES+3:
		{
		    if(response)
		    {
		        new vid = Wybral[playerid];
		        if(VehicleInfo[vid][gtauid]!=-1)
				{
	    			ListaPrywatnychPojazdow(playerid);
					ShowInfo(playerid, "By zez³omowaæ pojazd nie mo¿esz mieæ go zespawnowanego!");
					return 1;
				}
    			new vshopid = GetSalonCarIDByModel(VehicleInfo[vid][model]);
			    new zakwote;
			    if(vshopid==-1)
			    {
     				zakwote = 100000;
				}
				else
				{
    				zakwote = SalonInfo[vshopid][1]/2;
				}
				VehicleInfo[vid][ownerid]=0;
				format(dstring, sizeof(dstring), "UPDATE `sat_vehicles` SET `ownerid`='-1' WHERE `uid`='%d'", vid);
				mysql_query(dstring);
				PlayerInfo[playerid][Money]+=zakwote;
				format(dstring, sizeof(dstring), "Pomyœlnie zez³omowa³eœ pojazd!\nNa twoje konto wp³ynê³o %d$.", zakwote);
				ShowDialog(playerid, DIALOG_VEHICLES+4, DIALOG_STYLE_MSGBOX, "Lista pojazdów - z³omowanie", dstring, "Rozumiem", "");
		    }
		    else
		    {
		        ListaPrywatnychPojazdow(playerid);
		    }
		    return 1;
		}
		case DIALOG_VEHICLES+5:
		{
		    if(response)
		    {
		        new vid = Wybral[playerid];
		        if(VehicleInfo[vid][gtauid]!=-1)
				{
	    			ListaPrywatnychPojazdow(playerid);
					ShowInfo(playerid, "By zez³omowaæ pojazd nie mo¿esz mieæ go zespawnowanego!");
					return 1;
				}
				if(VehicleInfo[vid][gtauid]!=-1)
				{
	    			ListaPrywatnychPojazdow(playerid);
					ShowInfo(playerid, "By naprawiæ pojazd musi mieæ on 0.0000 HP!");
					return 1;
				}
    			new vshopid = GetSalonCarIDByModelToRepair(VehicleInfo[vid][model]);
			    new zakwote = SalonInfo[vshopid][1]/2;
			    if(PlayerInfo[playerid][Money]<zakwote)
			    {
	    			ListaPrywatnychPojazdow(playerid);
					ShowInfo(playerid, "Nie staæ Ciê na naprawê!!");
					return 1;
				}
				VehicleInfo[vid][health]=1000.0;
				format(dstring, sizeof(dstring), "UPDATE `sat_vehicles` SET `health`='1000.0' WHERE `uid`='%d'", vid);
				mysql_query(dstring);
				PlayerInfo[playerid][Money]-=zakwote;
				format(dstring, sizeof(dstring), "Pomyœlnie naprawi³eœ pojazd!\nZ twojego konta pobrano %d$.", zakwote);
				ShowDialog(playerid, DIALOG_VEHICLES+4, DIALOG_STYLE_MSGBOX, "Lista pojazdów - naprawa", dstring, "Rozumiem", "");
		    }
		    else
		    {
		        ListaPrywatnychPojazdow(playerid);
		    }
		    return 1;
		}
		case DIALOG_VEHICLES+4:
		{
            return ListaPrywatnychPojazdow(playerid);
		}
		case DIALOG_VEHICLES+2:
		{
		    if(!response)
		    {
			    new s[1000];
				Wybral[playerid] = WyswietlaPojazd[playerid][listitem];
				format(dstring, sizeof(dstring), "{FFFFFF}Zarz¹dzanie pojazdem %s [UID: %d]:\n",
					VehicleNames[VehicleInfo[Wybral[playerid]][model]-400],
					Wybral[playerid]);
				strcat(s, dstring);
				format(dstring, sizeof(dstring), "  {C0C0C0}%s\n", ((VehicleInfo[Wybral[playerid]][gtauid] < 0) ? ("Zespawnuj...") : ("Odspawnuj...")));
				strcat(s, dstring);
				strcat(s, "  {C0C0C0}Dodatki...\n");
				strcat(s, "  {C0C0C0}Z³omuj...\n");
				strcat(s, "  {C0C0C0}Napraw...\n");
				strcat(s, "  {C0C0C0}Przypisz...\n");
				strcat(s, "  {C0C0C0}Namierz...\n");
			    ShowDialog(playerid, DIALOG_VEHICLES+1, DIALOG_STYLE_LIST, "Lista pojazdów - zarz¹dzanie pojazdem", s, "Wybierz", "Cofnij");
			    return 1;
			}
		    new veh = Wybral[playerid];
		    if(listitem==0)
		    {
       			new s[1500];
				format(dstring, sizeof(dstring), "{FFFFFF}Cena\tDodatek\tStatus\n", VehicleNames[VehicleInfo[veh][model]-400], veh);
				strcat(s, dstring);
				format(dstring, sizeof(dstring), "{C0C0C0}400$\tNitro\t\t[%s{C0C0C0}]\n", ((VehicleInfo[veh][nitro] == 1) ? (""C_ZIELONY"Wykupione") : (""C_CZERWONY"Nie wykupione")));
				strcat(s, dstring);
				format(dstring, sizeof(dstring), "{C0C0C0}300$\tHydraulika\t[%s{C0C0C0}]\n", ((VehicleInfo[veh][hydraulika] == 1) ? (""C_ZIELONY"Wykupione") : (""C_CZERWONY"Nie wykupione")));
		  		strcat(s, dstring);
		  		format(dstring, sizeof(dstring), "{C0C0C0}700$\t+30 paliwa\t[%s{C0C0C0}]\n", ((VehicleInfo[veh][paliwo] == 1) ? (""C_ZIELONY"Wykupione") : (""C_CZERWONY"Nie wykupione")));
	  			strcat(s, dstring);
	  			format(dstring, sizeof(dstring), "{C0C0C0}1000$\tDod. £adunek\t[%s{C0C0C0}]\n", ((VehicleInfo[veh][ladunek] == 1) ? (""C_ZIELONY"Wykupione") : (""C_CZERWONY"Nie wykupione")));
	  			strcat(s, dstring);
	  			format(dstring, sizeof(dstring), "{C0C0C0}100$\tZamek Centr.\t[%s{C0C0C0}]\n", ((VehicleInfo[veh][zamekc] == 1) ? (""C_ZIELONY"Wykupione") : (""C_CZERWONY"Nie wykupione")));
	  			strcat(s, dstring);
	  			format(dstring, sizeof(dstring), "{C0C0C0}500$\tCB-Radio\t[%s{C0C0C0}]\n", ((VehicleInfo[veh][cb] > -1) ? (""C_ZIELONY"Wykupione") : (""C_CZERWONY"Nie wykupione")));
	  			strcat(s, dstring);
		 		ShowDialog(playerid, DIALOG_VEHICLES+2, DIALOG_STYLE_LIST, "Lista pojazdów - zarz¹dzanie dodatkami", s, "Kup", "Cofnij");
			}
			if(listitem==1)
			{
			    if(VehicleInfo[veh][gtauid]!=-1)
			        return ShowInfo(playerid, "Twój pojazd jest zespawnowany wiêc nie mo¿esz dokupiæ dodatków!");
				if(PlayerInfo[playerid][Money]<400)
				    return ShowInfo(playerid, "Nie staæ Ciê na ten dodatek!");
				if(VehicleInfo[veh][nitro]==1)
				    return ShowInfo(playerid, "Masz ju¿ wykupiony ten dodatek!");
				VehicleInfo[veh][nitro]=1;
				format(dstring, sizeof(dstring), "UPDATE `sat_vehicles` SET `nitro`='1' WHERE `uid`='%d'", veh);
				mysql_query(dstring);
				PlayerInfo[playerid][Money]-=400;
				ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Lista pojazdów - kupno dodatku", "Zakupi³eœ nitro do swojego pojazdu za 400$.", "Rozumiem", "");
			}
			if(listitem==2)
			{
			    if(VehicleInfo[veh][gtauid]!=-1)
			        return ShowInfo(playerid, "Twój pojazd jest zespawnowany wiêc nie mo¿esz dokupiæ dodatków!");
                if(PlayerInfo[playerid][Money]<300)
				    return ShowInfo(playerid, "Nie staæ Ciê na ten dodatek!");
				if(VehicleInfo[veh][hydraulika]==1)
				    return ShowInfo(playerid, "Masz ju¿ wykupiony ten dodatek!");
				VehicleInfo[veh][hydraulika]=1;
				format(dstring, sizeof(dstring), "UPDATE `sat_vehicles` SET `hydraulika`='1' WHERE `uid`='%d'", veh);
				mysql_query(dstring);
				PlayerInfo[playerid][Money]-=300;
				ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Lista pojazdów - kupno dodatku", "Zakupi³eœ hydraulike do swojego pojazdu za 300$.", "Rozumiem", "");
			}
			if(listitem==3)
			{
			    if(VehicleInfo[veh][gtauid]!=-1)
			        return ShowInfo(playerid, "Twój pojazd jest zespawnowany wiêc nie mo¿esz dokupiæ dodatków!");
                if(PlayerInfo[playerid][Money]<700)
				    return ShowInfo(playerid, "Nie staæ Ciê na ten dodatek!");
				if(VehicleInfo[veh][paliwo]==1)
				    return ShowInfo(playerid, "Masz ju¿ wykupiony ten dodatek!");
				VehicleInfo[veh][paliwo]=1;
				VehicleInfo[veh][maxpetrol]+=30;
				format(dstring, sizeof(dstring), "UPDATE `sat_vehicles` SET `paliwo`='1', `maxpetrol`='%f' WHERE `uid`='%d'",VehicleInfo[veh][maxpetrol], veh);
				mysql_query(dstring);
				PlayerInfo[playerid][Money]-=700;
				ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Lista pojazdów - kupno dodatku", "Zakupi³eœ nowy bak (+30L paliwa) do swojego pojazdu za 700$.", "Rozumiem", "");
			}
			if(listitem==3)
			{
			    if(VehicleInfo[veh][gtauid]!=-1)
			        return ShowInfo(playerid, "Twój pojazd jest zespawnowany wiêc nie mo¿esz dokupiæ dodatków!");
                if(PlayerInfo[playerid][Money]<700)
				    return ShowInfo(playerid, "Nie staæ Ciê na ten dodatek!");
				if(VehicleInfo[veh][paliwo]==1)
				    return ShowInfo(playerid, "Masz ju¿ wykupiony ten dodatek!");
				VehicleInfo[veh][paliwo]=1;
				VehicleInfo[veh][maxpetrol]+=30;
				format(dstring, sizeof(dstring), "UPDATE `sat_vehicles` SET `paliwo`='1', `maxpetrol`='%f' WHERE `uid`='%d'",VehicleInfo[veh][maxpetrol], veh);
				mysql_query(dstring);
				PlayerInfo[playerid][Money]-=700;
				ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Lista pojazdów - kupno dodatku", "Zakupi³eœ nowy bak (+30L paliwa) do swojego pojazdu za 700$.", "Rozumiem", "");
			}
			if(listitem==4)
			{
			    if(VehicleInfo[veh][gtauid]!=-1)
			        return ShowInfo(playerid, "Twój pojazd jest zespawnowany wiêc nie mo¿esz dokupiæ dodatków!");
                if(PlayerInfo[playerid][Money]<1000)
				    return ShowInfo(playerid, "Nie staæ Ciê na ten dodatek!");
				if(VehicleInfo[veh][ladunek]==1)
				    return ShowInfo(playerid, "Masz ju¿ wykupiony ten dodatek!");
				VehicleInfo[veh][ladunek]=1;
				format(dstring, sizeof(dstring), "UPDATE `sat_vehicles` SET `ladunek`='1' WHERE `uid`='%d'", veh);
				mysql_query(dstring);
				PlayerInfo[playerid][Money]-=1000;
				ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Lista pojazdów - kupno dodatku", "Zakupi³eœ dodatkowe miejsce na ³adunek do swojego pojazdu za 1000$.", "Rozumiem", "");
			}
			if(listitem==5)
			{
			    if(VehicleInfo[veh][gtauid]!=-1)
			        return ShowInfo(playerid, "Twój pojazd jest zespawnowany wiêc nie mo¿esz dokupiæ dodatków!");
                if(PlayerInfo[playerid][Money]<100)
				    return ShowInfo(playerid, "Nie staæ Ciê na ten dodatek!");
				if(VehicleInfo[veh][zamekc]==1)
				    return ShowInfo(playerid, "Masz ju¿ wykupiony ten dodatek!");
				VehicleInfo[veh][zamekc]=1;
				format(dstring, sizeof(dstring), "UPDATE `sat_vehicles` SET `zamekc`='1' WHERE `uid`='%d'", veh);
				mysql_query(dstring);
				PlayerInfo[playerid][Money]-=100;
				ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Lista pojazdów - kupno dodatku", "Zakupi³eœ zamek centralny do swojego pojazdu za 100$.", "Rozumiem", "");
			}
			if(listitem==6)
			{
			    if(VehicleInfo[veh][gtauid]!=-1)
			        return ShowInfo(playerid, "Twój pojazd jest zespawnowany wiêc nie mo¿esz dokupiæ dodatków!");
                if(PlayerInfo[playerid][Money]<500)
				    return ShowInfo(playerid, "Nie staæ Ciê na ten dodatek!");
				if(VehicleInfo[veh][cb]==1)
				    return ShowInfo(playerid, "Masz ju¿ wykupiony ten dodatek!");
				VehicleInfo[veh][cb]=0;
				format(dstring, sizeof(dstring), "UPDATE `sat_vehicles` SET `cb`='0' WHERE `uid`='%d'", veh);
				mysql_query(dstring);
				PlayerInfo[playerid][Money]-=500;
				ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Lista pojazdów - kupno dodatku", "Zakupi³eœ CB-Radio do swojego pojazdu za 500$.\n\nBy zmieniæ stacjê wpisz /setcb <id stacji [0-50]> natomiast by pisaæ\nna CB-Radiu swoj¹ wypowiedŸ na chacie poprzedŸ wykrzyknikiem.", "Rozumiem", "");
			}
			ListaPrywatnychPojazdow(playerid);
		}
	    case DIALOG_GPS_KATEGORIE:
	    {
	        if(response)
	        {
	            if(listitem==0) return ShowDialog(playerid, DIALOG_GPS_KATEGORIE, DIALOG_STYLE_LIST, "GPS - Typ", "Wybierz typ miejsca:\n\tZa³adunki...\n\tStacje benzynowe...\n\tCentrale za³adunków...\n"C_CZERWONY"Wy³¹cz GPS", "Wybierz", "Anuluj");
	            if(listitem==1)
	            {
            		new buffer[255], string[1700];
					format(buffer, sizeof(buffer), "{FFFFFF}Wybierz za³adunek:\n");
					string = buffer;
					for(new i = 1; i < LoadingsValue+1; i++)
					{
						format(buffer, sizeof(buffer), "   {C0C0C0}%s (UID: %d)\n", LoadingsInfo[i][lname], i);
						strcat(string, buffer);
					}
					ShowDialog(playerid, DIALOG_GPS_ZALADUNKI, DIALOG_STYLE_LIST, "GPS - Wybierz lokalizacjê", string, "Wybierz", "Zamknij");
	            }
	            if(listitem==2)
	            {
					ShowDialog(playerid, DIALOG_GPS_CENTRALE, DIALOG_STYLE_LIST, "GPS - Wybierz lokalizacjê", "{FFFFFF}Wybierz centralê:\n   {C0C0C0}Doki (SF)\n   {C0C0C0}Kopalnia", "Wybierz", "Zamknij");
	            }
	            if(listitem==3)
	            {
	                if(PlayerInfo[playerid][GPSON])
					{
			        	DestroyDynamicMapIcon(PlayerInfo[playerid][GPSON]);
		            }
	            }
			}
		}
		case DIALOG_GPS_CENTRALE:
		{
		    if(response)
		    {
		        if(listitem==0)
		        {
		            ShowDialog(playerid, DIALOG_GPS_CENTRALE, DIALOG_STYLE_LIST, "GPS - Wybierz lokalizacjê", "{FFFFFF}Wybierz centralê:\n   {C0C0C0}Doki (SF)\n   {C0C0C0}Kopalnia", "Wybierz", "Zamknij");
				}
				if(listitem==1)
				{
				    if(PlayerInfo[playerid][GPSON])
					{
			        	DestroyDynamicMapIcon(PlayerInfo[playerid][GPSON]);
		            }

		            PlayerInfo[playerid][GPSON] = CreateDynamicMapIcon(-1733.5723,40.8155,3.5547, 56, 0, 0, 0, playerid, 999999.0);
					Streamer_SetIntData(STREAMER_TYPE_MAP_ICON, PlayerInfo[playerid][GPSON], E_STREAMER_STYLE, MAPICON_GLOBAL);
					Streamer_Update(playerid);
				}
				if(listitem==2)
				{
				    if(PlayerInfo[playerid][GPSON])
					{
			        	DestroyDynamicMapIcon(PlayerInfo[playerid][GPSON]);
		            }

		            PlayerInfo[playerid][GPSON] = CreateDynamicMapIcon(373.5872,984.9277,30.0430, 56, 0, 0, 0, playerid, 999999.0);
					Streamer_SetIntData(STREAMER_TYPE_MAP_ICON, PlayerInfo[playerid][GPSON], E_STREAMER_STYLE, MAPICON_GLOBAL);
					Streamer_Update(playerid);
				}
			}
		}
		case DIALOG_GPS_ZALADUNKI:
		{
		    if(response)
			{
				if(listitem == 0)
				{
			        new buffer[255], string[1700];
					format(buffer, sizeof(buffer), "{FFFFFF}Wybierz za³adunek:\n");
					string = buffer;
					for(new i = 1; i < LoadingsValue+1; i++)
					{
						format(buffer, sizeof(buffer), "   {C0C0C0}%s (UID: %d)\n", LoadingsInfo[i][lname], i);
						strcat(string, buffer);
					}
					ShowDialog(playerid, DIALOG_GPS_ZALADUNKI, DIALOG_STYLE_LIST, "GPS - Wybierz lokalizacjê", string, "Wybierz", "Zamknij");
		        }
				else
				{
		            if(PlayerInfo[playerid][GPSON])
					{
			        	DestroyDynamicMapIcon(PlayerInfo[playerid][GPSON]);
		            }



					PlayerInfo[playerid][GPSON] = CreateDynamicMapIcon(LoadingsInfo[listitem][lx], LoadingsInfo[listitem][ly], LoadingsInfo[listitem][lz], 56, 0, 0, 0, playerid, 999999.0);
					Streamer_SetIntData(STREAMER_TYPE_MAP_ICON, PlayerInfo[playerid][GPSON], E_STREAMER_STYLE, MAPICON_GLOBAL);
					Streamer_Update(playerid);
		        }
		    }
		}
		case DIALOG_ANULUJ:
		{
		    if(response)
		    {
		        new vid = GetVehicleUID(GetPlayerVehicleID(playerid));
		        new szQuery[255];
		        if(VehicleInfo[vid][cargo] == 0 &&  IsPlayerInAnyVehicle(playerid) && VehicleInfo[GetVehicleUID(GetPlayerVehicleID(playerid))][ownerid] == PlayerInfo[playerid][Uid])
        			return ShowInfo(playerid, "Nie posiadasz zlecenia!");
                VehicleInfo[vid][cargo]=0;
                VehicleInfo[vid][cargostat]=0;
		        format(szQuery, sizeof(szQuery), "UPDATE `sat_vehicles` SET `cargo`='0' WHERE `uid`='%d'", vid);
		        mysql_query(szQuery);
		        ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Anulowanie zlecenia.", "Zlecenie anulowane!\n\nZ twojego konta pobrano 500$.", "Rozumiem", "");
                PlayerInfo[playerid][Money]-=500;
			}
		}
	    case DIALOG_TOWARY:
	    {
	        new centrala = NaCentrali(playerid);
	        CentralaInfo[centrala][zajety]=0;
	        if(response)
	        {
	            new vid = GetVehicleUID(GetPlayerVehicleID(playerid));
	            if(listitem==0)
				{
					return 1;
				}
				else
				{
					if(VehicleInfo[vid][cargostat]==0)
					{
					    if(CargoInfo[listitem][dostepnosc]<=0)
					    {
					        ShowInfo(playerid, "Ten towar jest niedostêpny!");
							new s[2000];
		  					strcat(s, "{FFFFFF}Dostep\tLegalnoœæ\tNazwa:\n");
					    	for(new i=1; i<CargosValue+1; i++)
					    	{
		       					format(dstring, sizeof(dstring), "{C0C0C0}%d\t{C0C0C0}[%s{C0C0C0}]\t%s{C0C0C0}\n",
		       					CargoInfo[i][dostepnosc],
		       					((CargoInfo[i][illegal] < 1) ? (""C_ZIELONY"Legalny") : (""C_CZERWONY"Nielegalny")),
									CargoInfo[i][cname]);
		       					strcat(s, dstring);
							}
		   					ShowDialog(playerid, DIALOG_TOWARY, DIALOG_STYLE_LIST, "Lista towarów", s, "Zaladuj", "Anuluj");
		   					return 1;
					    }
					    new szQuery[255];
			        	VehicleInfo[vid][cargo] = listitem;
			        	CargoInfo[listitem][dostepnosc]--;
			        	SendClientMessage(playerid, -1, "Zlecenie przypisane! Jego informacje wyœwietlone s¹ na textdrawie pod licznikiem.");

			        	format(szQuery, sizeof(szQuery), "UPDATE `sat_vehicles` SET `cargo`='%d' WHERE `uid`='%d'", listitem, vid);
			        	mysql_query(szQuery);
						if(!SprawdzTowary())
						{
						    LoadCargos();
						}
					}
					else
					{
					    ShowInfo(playerid, "Ten pojazd posiada ju¿ zlecenie!");
					}
				}
			}
			else
			{
			    ShowInfo(playerid, "Zlecenie odrzucone!");
			}
		}
	    case DIALOG_BUY_TRUCK:
		{
	        if(response)
			{
				new szQuery[255];
				ShowInfo(playerid, "{FFFFFF}Transakcja potwierdzona!");
				format(szQuery, sizeof(szQuery), "INSERT INTO `sat_vehicles` SET `ownerid`='%d', `model`='%d', `c1`='%d', `c2`='%d', `petrol`='100'",
				PlayerInfo[playerid][Uid], SalonInfo[PlayerInfo[playerid][ActualVehicle]][0], random(99999), random(99999));
				mysql_query(szQuery);

    			ReloadVehicles2(playerid);

				SetPlayerPos(playerid, 1291.0306,-1866.4099,13.5469);
				SetPlayerFacingAngle(playerid, 3.8130);

			    RemovePlayerFromVehicle(playerid);

				SetPlayerVirtualWorld(playerid, 0);
				TogglePlayerControllable(playerid, true);
				SetCameraBehindPlayer(playerid);
				PlayerInfo[playerid][InCarShop] = false;

				SetSalonVehicleModel(SalonInfo[PlayerInfo[playerid][ActualVehicle]][0]);

				TextDrawSetString(Salon[0], "~r~Cena ~w~0$    ~r~Pakownosc ~w~0    ~r~Waga ~w~0t~n~~n~~n~");
				TextDrawSetString(Salon[1], "~<~ SPACJA ~>~");
				TextDrawSetString(Salon[2], " ");

				TextDrawHideForPlayer(playerid, Salon[0]);
				TextDrawHideForPlayer(playerid, Salon[1]);
				TextDrawHideForPlayer(playerid, Salon[2]);

				PlayerInfo[playerid][Money] -= SalonInfo[PlayerInfo[playerid][ActualVehicle]][1];
	        }
			else
			{
	            ShowInfo(playerid, "{FFFFFF}Transakcja anulowana!");
	        }
	    }
	    case DIALOG_LOGIN:
		{
	        new szQuery[455], szString[255];
	        if(!response) {
				Kick(playerid);
	        }

	        format(szQuery, sizeof(szQuery), "SELECT `uid`, `x`, `y`, `z`, `a`, `score`, `money`, `admin`, `skin`, `frakcja`, `lider`, `Mandat`, `Areszt`, `Dostarczen`, `Warn`, `interior`, `vw`, `email`, `Gold`, `VIP`, `karne` FROM `sat_users` WHERE `username`='%s' AND `password`=md5('%s')", PlayerInfo[playerid][Name], inputtext);
	        mysql_query(szQuery);
	        mysql_store_result();
			mysql_fetch_row_format(szQuery);

	        if(!mysql_num_rows())
			{
           	    ShowDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, SC_NAME, "{FFFFFF}Witaj ponownie!\nWpisz swoje has³o poni¿ej aby siê zalogowaæ!", "Zaloguj", "");
        	    mysql_free_result();
		     	GameTextForPlayer(playerid, "~n~~n~~n~~n~~r~Haslo nie jest prawidlowe!", 5000, 5);
	            return 1;
	        }

			sscanf(szQuery, "p<|>iffffiiiiiiiiiiiis[100]iii",
				PlayerInfo[playerid][Uid],
				PlayerInfo[playerid][pPos][0],
				PlayerInfo[playerid][pPos][1],
				PlayerInfo[playerid][pPos][2],
				PlayerInfo[playerid][pPos][3],
				PlayerInfo[playerid][Score],
				PlayerInfo[playerid][Money],
				PlayerInfo[playerid][Admin],
				PlayerInfo[playerid][Skin],
				PlayerInfo[playerid][Frakcja],
				PlayerInfo[playerid][Lider],
				PlayerInfo[playerid][Mandat],
				PlayerInfo[playerid][Areszt],
				PlayerInfo[playerid][Dostarczen],
				PlayerInfo[playerid][Warn],
				PlayerInfo[playerid][interior],
				PlayerInfo[playerid][vw],
				PlayerInfo[playerid][email],
				PlayerInfo[playerid][Gold],
				PlayerInfo[playerid][VIP],
				PlayerInfo[playerid][karne]);
            if(PlayerInfo[playerid][Warn]==4)
			{
				ShowInfo(playerid, "To konto jest zablokowane!");
				Kick(playerid);
				return 1;
			}
			format(szString, sizeof(szString), "{0096ff}Zalogowa³eœ siê na konto {36acff}%s{0096ff}(UID {36acff}%i{0096ff})!", PlayerInfo[playerid][Name], PlayerInfo[playerid][Uid]);
			SendClientMessage(playerid, -1, szString);
			PlayerInfo[playerid][Logged] = true;
			SetSpawnInfo(playerid, 0, 0, PlayerInfo[playerid][pPos][0], PlayerInfo[playerid][pPos][1], PlayerInfo[playerid][pPos][2], PlayerInfo[playerid][pPos][3], 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
			SetPlayerPos(playerid, PlayerInfo[playerid][pPos][0], PlayerInfo[playerid][pPos][1], PlayerInfo[playerid][pPos][2]);
			SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPos][3]);
			
			SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
           	mysql_free_result();
           	format(dstring, sizeof(dstring), "%s [%d] "C_BIALY"do³¹czy³ do gry!",PlayerInfo[playerid][Name],playerid);
			SendClientMessageToAll(KOLOR_BEZOWY,dstring);
			if(IsVip(playerid))
			{
			    SetPlayerColor(playerid, 0xFFFFFFFF);
			}
			if(PlayerInfo[playerid][Admin]==0)
			{
				format(szString, sizeof(szString), "%s (%d)", PlayerInfo[playerid][Name], playerid);
			}
			if(PlayerInfo[playerid][Admin]==1)
			{
				format(szString, sizeof(szString), "Moderator\n%s (%d)", PlayerInfo[playerid][Name], playerid);
			}
			if(PlayerInfo[playerid][Admin]==2)
			{
				format(szString, sizeof(szString), "Administrator\n%s (%d)", PlayerInfo[playerid][Name], playerid);
			}
			if(PlayerInfo[playerid][Admin]==3)
			{
				format(szString, sizeof(szString), "HeadAdmin\n%s (%d)", PlayerInfo[playerid][Name], playerid);
			}
			PlayerInfo[playerid][Player3DText] = Create3DTextLabel(szString, GetPlayerColor(playerid), 30.0, 40.0, 50.0, 14.0, 1);
	    }

	    case DIALOG_REGISTER:
		{
		    new szQuery[255], szString[255], szPass[255];
	        if(!response)
			{
				Kick(playerid);
	        }

			if(strlen(inputtext) < 3 || strlen(inputtext) > 20)
			{
			    ShowDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, SC_NAME, "{FFFFFF}Witaj na serwerze "SC_NAME"{FFFFFF}!\nTwój nick nie jest zarejestrowany!\nAby siê zarejestrowaæ wpisz swoje has³o poni¿ej!", "Zarejestruj", "");
   		     	GameTextForPlayer(playerid, "~n~~n~~n~~n~~r~Zly format hasla!~n~Minimalna ilosc znakow 3 maksymalna 20!", 5000, 5);
			    return 1;
			}

            mysql_real_escape_string(inputtext, szPass);
			format(szQuery, sizeof(szQuery), "INSERT INTO `sat_users` SET `username`='%s', `password`=md5('%s'), `skin`='%d'", PlayerInfo[playerid][Name], szPass, skiny[random(sizeof(skiny))]);
			mysql_query(szQuery);

			format(szString, sizeof(szString), "{0096ff}Konto stworzone poprawnie! Prosimy o zalogowanie siê! Twoje has³o {36acff}%s", inputtext);
			SendClientMessage(playerid, -1, szString);

		    ShowDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, SC_NAME, "{FFFFFF}Witaj ponownie!\nWpisz swoje has³o poni¿ej aby siê zalogowaæ!", "Zaloguj", "");
	    }
	    case DIALOG_LIDER:
	    {
	        if(!response) return 1;
	        if(listitem==0||listitem==4||listitem==6||listitem==10||listitem==12||listitem==15) return MenuFirmy(playerid);
		    if(listitem==1) return ShowDialog(playerid, DIALOG_LIDER+1, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Zatrudnij pracownika", "Wpisz nick gracza którego chcesz zatrudniæ do swojej frakcji:", "Dodaj", "Cofnij");
	        if(listitem==2) return ShowDialog(playerid, DIALOG_LIDER+2, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Zwolnij pracownika", "Wpisz nick gracza którego chcesz zwolniæ z swojej frakcji:", "Usuñ", "Cofnij");
			if(listitem==3) return PracownicyFirmy(playerid);
			if(listitem==5) return ShowDialog(playerid, DIALOG_LIDER+4, DIALOG_STYLE_MSGBOX, "Panel zarz¹dzania Frakcj¹ - Ustaw spawn", "Czy na pewno chcesz usatwiæ spawn frakcji w tym miejscu?", "Ustaw", "Cofnij");
            if(listitem==7) return StanKonta(playerid);
			if(listitem==8) return ShowDialog(playerid, DIALOG_LIDER+8, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Wp³ata pieniêdzy", "Wpisz kwotê jak¹ chcesz wp³¹ciæ na konto firmy!", "Wp³aæ", "Anuluj");
			if(listitem==9) return ShowDialog(playerid, DIALOG_LIDER+3, DIALOG_STYLE_MSGBOX, "Panel zarz¹dzania Frakcj¹ - Wyp³ata", "By daæ wyp³atê wpisz /wyplata <id> <kwota>", "Wróæ", "");
            if(listitem==11) return ShowDialog(playerid, DIALOG_LIDER+5, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Zmiana skina", "Wpisz ID skina który bêdzie s³u¿y³ za s³u¿bowy w twojej frakcji:", "Zmieñ", "Cofnij");
			if(listitem==13) return KupPojazd(playerid);
			if(listitem==14) return ListaPojazdow(playerid);
			if(listitem==16) return ShowRekrutacja(playerid);
		}
	    case DIALOG_LIDER+1:
		{
		    if(PlayerInfo[playerid][Lider]==0)
	    		return 1;
		    if(response) DodajGracza(playerid, inputtext);
			else MenuFirmy(playerid);
		}
		case DIALOG_LIDER+2:
		{
		    if(PlayerInfo[playerid][Lider]==0)
	    		return 1;
		    if(response) UsunGracza(playerid, inputtext);
			else MenuFirmy(playerid);
		}
		case DIALOG_LIDER+3:
		{
		    if(PlayerInfo[playerid][Lider]==0)
	    		return 1;
		    if(response)
		    	MenuFirmy(playerid);
		}
		case DIALOG_LIDER+4:
		{
		    if(PlayerInfo[playerid][Lider]==0)
	    		return 1;
		    new query[1000];
		    new pFrakcja = PlayerInfo[playerid][Lider];
      		
		    GetPlayerPos(playerid, FrakcjaInfo[pFrakcja][SpawnX], FrakcjaInfo[pFrakcja][SpawnY], FrakcjaInfo[pFrakcja][SpawnZ]);

			DestroyDynamic3DTextLabel(FrakcjaInfo[pFrakcja][dinfo]);
			format(dstring, sizeof(dstring), ""C_BLEKITNY"%s\n"C_BEZOWY"Wpisz "C_ZIELONY"/sluzba "C_BEZOWY"by wejœæ/wyjœæ z s³u¿by.", FrakcjaInfo[pFrakcja][Nazwa]);
			FrakcjaInfo[pFrakcja][dinfo]=CreateDynamic3DTextLabel(dstring, KOLOR_ZIELONY, FrakcjaInfo[pFrakcja][SpawnX], FrakcjaInfo[pFrakcja][SpawnY], FrakcjaInfo[pFrakcja][SpawnZ], 30.0);

			format(query, sizeof(query), "UPDATE `sat_frakcje` SET `SpawnX`='%f', `SpawnY`='%f', `SpawnZ`='%f' WHERE `UID`='%d'", FrakcjaInfo[pFrakcja][SpawnX], FrakcjaInfo[pFrakcja][SpawnY], FrakcjaInfo[pFrakcja][SpawnZ], pFrakcja);
        	mysql_query(query);
        	ShowDialog(playerid, DIALOG_LIDER+3, DIALOG_STYLE_MSGBOX, "Panel zarz¹dzania Frakcj¹ - Ustaw spawn", "Pozycja spawnu ustawiona.", "Wróæ", "");
		}
		case DIALOG_LIDER+5:
		{
		    if(PlayerInfo[playerid][Lider]==0)
	    		return 1;
			new query[256];
			new pFrakcja = PlayerInfo[playerid][Lider];
      		new skin = strval(inputtext);
      		if(skin<1 || skin>299)
      		    return ShowDialog(playerid, DIALOG_LIDER+5, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Zmiana skina", "Nie prawid³owy ID skina!\n\nWpisz ID skina który bêdzie s³u¿y³ za s³u¿bowy w twojej frakcji:", "Zmieñ", "Cofnij");
      		FrakcjaInfo[pFrakcja][Skin]=skin;
      		format(query, sizeof(query), "UPDATE `sat_frakcje` SET `Skin`='%d' WHERE `UID`='%d'", FrakcjaInfo[pFrakcja][Skin], pFrakcja);
        	mysql_query(query);
        	format(dstring, sizeof dstring, "Skin s³u¿bowy zosta³ zmieniony na %d.", FrakcjaInfo[pFrakcja][Skin]);
        	ShowDialog(playerid, DIALOG_LIDER+3, DIALOG_STYLE_MSGBOX, "Panel zarz¹dzania Frakcj¹ - Zmiana skina",dstring, "Wróæ", "");
		}
		case DIALOG_LIDER+8:
		{
		    new pFrakcja = PlayerInfo[playerid][Lider];
		    if(pFrakcja==0) return 1;
		    if(!response) return MenuFirmy(playerid);
			new kwota = strval(inputtext);
			if(kwota < 1) return ShowDialog(playerid, DIALOG_LIDER+8, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Wp³ata pieniêdzy", "Nie poprawna kwota!\n\nWpisz kwotê jak¹ chcesz wp³¹ciæ na konto firmy!", "Wp³aæ", "Wróæ");
			if(kwota > PlayerInfo[playerid][Money]) return ShowDialog(playerid, DIALOG_LIDER+8, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Wp³ata pieniêdzy", "Nie masz tyle pieniêdzy!\n\nWpisz kwotê jak¹ chcesz wp³¹ciæ na konto firmy!", "Wp³aæ", "Wróæ");
			PlayerInfo[playerid][Money]-=kwota;
			FrakcjaInfo[pFrakcja][Konto]+=kwota;
            format(dstring, sizeof(dstring), "UPDATE `sat_frakcje` SET `Konto`='%d' WHERE `uid`='%d'", FrakcjaInfo[pFrakcja][Konto], pFrakcja);
            mysql_query(dstring);
            
            format(dstring, sizeof(dstring), "{FFFFFF}Wp³aci³eœ {C0C0C0}%d$ {FFFFFF}na konto twojej frakcji!", kwota);
            ShowDialog(playerid, DIALOG_LIDER+3, DIALOG_STYLE_MSGBOX, "Panel zarz¹dzania Frakcj¹ - Wp³ata pieniêdzy", dstring, "Wróæ", "");

			return 1;
		}
		case DIALOG_OBIEKTY_1:
		{
		    if(!response) return 1;
		    if(listitem==0) MenuObiektow(playerid);
		    if(listitem==1) CofnijObiekt(playerid);
		    if(listitem==2) ListaObiektow(playerid);
		    if(listitem==3) UsunObiekty(playerid);
		    if(listitem==4) MenuGlowne(playerid);//linia
		    return 1;
		}
		case DIALOG_OBIEKTY_2:
		{
	        if(!response)
		        return MenuGlowne(playerid);

		    if(Przeszkod[playerid]==MAX_PRZESZKODY)
		        return SendClientMessage(playerid, -1, "Masz ju¿ ustawione 50 obiekty!");

			new Float:Pos[4];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);
	 		new Float:x = Pos[0] + (5.0 * floatsin(-Pos[3], degrees));
	 		new Float:y = Pos[1] + (5.0 * floatcos(-Pos[3], degrees));


			Przeszkoda[playerid][Przeszkod[playerid]] = CreateObject(SpisObiektow[listitem][ID], x, y, Pos[2]+0.5, 0.0000, 0.0000, Pos[3] - 90.0);
	        PrzeszkodaID[playerid][Przeszkod[playerid]] = listitem;

	        Ostatni[playerid] = Przeszkoda[playerid][Przeszkod[playerid]];

			EditObject(playerid, Przeszkoda[playerid][Przeszkod[playerid]]);
	        Edytuje[playerid]=1;
			return 1;
		}
		case DIALOG_OBIEKTY_3:
		{
		    if(!response)
		        return MenuGlowne(playerid);
		    Edytuje[playerid]=2;
		    EditObject(playerid, Przeszkoda[playerid][listitem]);
		    return 1;
		}
		case DIALOG_OBIEKTY_4:
		    MenuGlowne(playerid);

		case DIALOG_OBIEKTY_PYTANIE:
		{
		    if(response)
		    {
		        DestroyObject(Ostatni[playerid]);
				Przeszkod[playerid]--;
				Ostatni[playerid]=-1;
				MenuGlowne(playerid);
				Edytuje[playerid]=0;
		    }
		}
		
		case DIALOG_LIDER+6:
		{
		    if(!response) return MenuFirmy(playerid);
		    new pfrakcja = PlayerInfo[playerid][Lider];
		    if(pfrakcja==0)
				return 1;
		    if(FrakcjaInfo[pfrakcja][Konto]<PojazdyFirm[listitem][1])
		    {
		        ShowInfo(playerid, "Nie staæ Ciê na ten pojazd.");
		        KupPojazd(playerid);
		        return 1;
			}
			new typpojazdu = SprawdzPojazd(PojazdyFirm[listitem][0]);
			if(typpojazdu == 1 && pfrakcja != 1)
			{
			    ShowInfo(playerid, "Ten pojazd jest przeznaczony dla policji.");
		        KupPojazd(playerid);
		        return 1;
			}
			if(typpojazdu == 2 && pfrakcja != 2)
			{
			    ShowInfo(playerid, "Ten pojazd jest przeznaczony dla medyków.");
		        KupPojazd(playerid);
		        return 1;
			}
			if(typpojazdu == 3 && pfrakcja != 3)
			{
			    ShowInfo(playerid, "Ten pojazd jest przeznaczony dla pomocy drogowej.");
		        KupPojazd(playerid);
		        return 1;
			}
			new szQuery[255];
            ShowInfo(playerid, "{FFFFFF}Transakcja potwierdzona!");
			format(szQuery, sizeof(szQuery), "INSERT INTO `sat_vehicles` SET `ownerid`='%d', `frakcja`='%d', `model`='%d', `c1`='%d', `c2`='%d', `petrol`='100'",
			0,
			pfrakcja,
			PojazdyFirm[listitem][0],
			random(99),
			random(99));
			mysql_query(szQuery);
			
			FrakcjaInfo[pfrakcja][Konto]-=PojazdyFirm[listitem][1];
			
			format(dstring, sizeof(dstring), "UPDATE `sat_frakcje` SET `Konto`='%d' WHERE `uid`='%d'", FrakcjaInfo[pfrakcja][Konto], pfrakcja);
			mysql_query(dstring);

			ReloadVehicles();
		}
		case DIALOG_LIDER+7:
		{
		    if(!response) return 1;
		    Wybral[playerid] = WyswietlaPojazd[playerid][listitem];
		    SpawnFVeh(playerid, Wybral[playerid]);
		}
		case DIALOG_LIDER+9:
		{
		    new pfrakcja = PlayerInfo[playerid][Lider];
    		if(pfrakcja == 0) return 1;
    		if(response) FrakcjaInfo[pfrakcja][Rekrutacja]=true;
    		if(!response) FrakcjaInfo[pfrakcja][Rekrutacja]=false;
    		format(dstring, sizeof(dstring), "UPDATE `sat_frakcje` SET `Rekr`='%d' WHERE `uid`='%d'", FrakcjaInfo[pfrakcja][Rekrutacja], pfrakcja);
    		mysql_query(dstring);
    		format(dstring, sizeof(dstring), "{C0C0C0}%s rekrutacjê do frakcji/firmy.", ((FrakcjaInfo[pfrakcja][Rekrutacja] == true) ? ("Otwar³eœ") : ("Zamkn¹³eœ")));
    		ShowDialog(playerid, DIALOG_LIDER+3, DIALOG_STYLE_MSGBOX, "Panel zarz¹dzania Frakcj¹ - Wybierz stan rekrutacji", dstring, "Wróæ", "");
		}
		case DIALOG_PRAWKO-1:
		{
		    if(response)
		    {
		    	if(!ZdanaTeoria(playerid))
				{
					ShowDialog(playerid, DIALOG_PRAWKO, DIALOG_STYLE_MSGBOX, "Prawo jazdy - Teoria", "Test teoretyczny na prawo jazdy kosztuje 200$ za ka¿de podejœcie.\n\nCzy na pewno chcesz zdawaæ na egzamin?", "Tak", "Nie");
				}
				else
				{
				    ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Prawo jazdy - Teoria", "Ju¿ masz zdany egzamin teoretyczny.", "Rozumiem", "");
				}
			}
			if(!response)
			{
				if(!ZdanaPraktyka(playerid))
				{
					ShowDialog(playerid, DIALOG_PRAWKO+3, DIALOG_STYLE_MSGBOX, "Prawo jazdy - Praktyka", "Test praktyczny na prawo jazdy kosztuje 300$ za ka¿de podejœcie.\n\nCzy na pewno chcesz zdawaæ na egzamin?", "Tak", "Nie");
				}
				else
				{
				    ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Prawo jazdy - Praktyka", "Ju¿ masz zdany egzamin praktyka.", "Rozumiem", "");
				}
			}
		}
		case DIALOG_PRAWKO:
		{
		    if(response)
		    {
		        PlayerInfo[playerid][Money]-=200;
		        ZdajeTeoria[playerid]=1;
		        format(dstring, sizeof(dstring), "Zaakceptowa³eœ zdawanie egzaminu teoretycznego!\nCzytaj uwa¿nie pytania i nie strzelaj w odpowiedziach!\nPamiêtaj ¿e na %d pytañ mo¿esz pope³niæ maksyalnie 1 b³¹d, inaczej\nnie zaliczysz egzaminu praktycznego.\n\nTak wiêc do dzie³a!\nGdy bêdziesz gotowy kliknij START.", MAX_PYTAN);
		        ShowDialog(playerid, DIALOG_PRAWKO+1, DIALOG_STYLE_MSGBOX, "Prawo jazdy - Teoria", dstring, "START", "");
			}
		}
		case DIALOG_PRAWKO+1:
		{
		    AktualnePytanie[playerid]=0;
		    Bledow[playerid]=0;
		    format(naglowek, 128, "Prawo jazdy - Teoria (Pytanie %d/%d)", AktualnePytanie[playerid]+1, MAX_PYTAN);
			ShowDialog(playerid, DIALOG_PRAWKO+2, DIALOG_STYLE_LIST, naglowek, PrawkoPytania[AktualnePytanie[playerid]][Pytanie], "Wybierz", "");
		}
		case DIALOG_PRAWKO+2:
		{
			if(listitem==0)
			{
			    format(naglowek, 128, "Prawo jazdy - Teoria (Pytanie %d/%d)", AktualnePytanie[playerid]+1, MAX_PYTAN);
			    ShowDialog(playerid, DIALOG_PRAWKO+2, DIALOG_STYLE_LIST, "Prawo jazdy - Teoria", PrawkoPytania[AktualnePytanie[playerid]][Pytanie], "Wybierz", "");
			    return 1;
			}
		    if(listitem==PrawkoPytania[AktualnePytanie[playerid]][Prawidlowa]) // poprawna odpowiedŸ
		    {
		        if(AktualnePytanie[playerid]<MAX_PYTAN-1)
		        {
		            AktualnePytanie[playerid]++;
		        	format(naglowek, 128, "Prawo jazdy - Teoria (Pytanie %d/%d)", AktualnePytanie[playerid]+1, MAX_PYTAN);
		        	ShowDialog(playerid, DIALOG_PRAWKO+2, DIALOG_STYLE_LIST, naglowek, PrawkoPytania[AktualnePytanie[playerid]][Pytanie], "Wybierz", "");
				}
				else
				{
				    if(Bledow[playerid]>1)
				    {
						format(dstring, sizeof(dstring), "Niestety nie zda³eœ, pope³ni³eœ za du¿o b³êdów!\nPope³ni³eœ %d b³êdów na %d pytañ przy dopuszczalnej iloœci 1 b³êdu.\nSpróbuj ponownie zdaæ na prawo jazdy!", Bledow, MAX_PYTAN);
						ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Prawo jazdy - Teoria (KONIEC)", dstring, "Rozumiem", "");
					}
					else if(Bledow[playerid]<=1)
					{
						format(dstring, sizeof(dstring), "Gratulujê, zda³eœ egzamin teoretyczny!\nZaliczy³eœ egzamin z %d b³êdami na %d pytañ przy maksymalnej iloœci b³êdów wynosz¹cej 1.\n\nCzeka Ciê teraz egzamin praktyczny na który zapiszesz siê u tego samego egazminatora.\n\nDo us³ysenia w krótce.", Bledow, MAX_PYTAN);
						ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Prawo jazdy - Teoria (KONIEC)", dstring, "Rozumiem", "");
						
						format(dstring, sizeof(dstring), "UPDATE `sat_prawko` SET `teoria`='1' WHERE `username`='%s'", PlayerInfo[playerid][Name]);
						mysql_query(dstring);
						
						if(ZdanaPraktyka(playerid))
						{
						    ShowInfo(playerid, "Otrzymujesz nowy przedmiot: Prawo Jazdy (by je komuœ pokazaæ u¿yj /pokaz)");
						}
					}
					ZdajeTeoria[playerid]=0;
					Bledow[playerid]=0;
					AktualnePytanie[playerid]=0;
				}
				return 1;
			}
			else //b³¹d
			{
			    Bledow[playerid]++;
			    if(AktualnePytanie[playerid]<MAX_PYTAN-1)
		        {
		            format(naglowek, 128, "Prawo jazdy - Teoria (Pytanie %d/%d)", AktualnePytanie[playerid]+1, MAX_PYTAN);
		        	AktualnePytanie[playerid]++;
		        	ShowDialog(playerid, DIALOG_PRAWKO+2, DIALOG_STYLE_LIST, naglowek, PrawkoPytania[AktualnePytanie[playerid]][Pytanie], "Wybierz", "");
				}
				else
				{
				    if(Bledow[playerid]>1)
				    {
						format(dstring, sizeof(dstring), "Niestety nie zda³eœ, pope³ni³eœ za du¿o b³êdów!\nPope³ni³eœ %d b³êdów na %d pytañ przy dopuszczalnej iloœci 1 b³êdu.\nSpróbuj ponownie zdaæ na prawo jazdy!", Bledow, MAX_PYTAN);
						ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Prawo jazdy - Teoria (KONIEC)", dstring, "Rozumiem", "");
					}
					else if(Bledow[playerid]<=1)
					{
						format(dstring, sizeof(dstring), "Gratulujê, zda³eœ egzamin teoretyczny!\nZaliczy³eœ egzamin z %d b³êdami na %d pytañ przy maksymalnej iloœci b³êdów wynosz¹cej 1.\n\nCzeka Ciê teraz egzamin praktyczny na który zapiszesz siê u tego samego egazminatora.\n\nDo us³ysenia w krótce.", Bledow, MAX_PYTAN);
						ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Prawo jazdy - Teoria (KONIEC)", dstring, "Rozumiem", "");

						format(dstring, sizeof(dstring), "UPDATE `sat_prawko` SET `teoria`='1' WHERE `username`='%s'", PlayerInfo[playerid][Name]);
						mysql_query(dstring);
						
						if(ZdanaPraktyka(playerid))
						{
						    ShowInfo(playerid, "Otrzymujesz nowy przedmiot: Prawo Jazdy (by je komuœ pokazaæ u¿yj /pokaz)");
						}
					}
					ZdajeTeoria[playerid]=0;
					Bledow[playerid]=0;
				}
				return 1;
			}
		}
		case DIALOG_PRAWKO+3:
		{
		    if(!response)
		        return 1;
			if(ZdajePraktyke!=-1)
			    return ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Prawo jazdy - praktyka", "Ju¿ ktoœ zdaje na prawo jazdy.", "Rozumiem", "");
            PlayerInfo[playerid][Money]-=300;
			new s[1000];
			strcat(s, "Zaakceptowa³eœ zdawanie egzaminu praktycznego.\n");
	        strcat(s, "Za chwilê zostaniesz przeniesiony na plac manewrowy gdzie bêdziesz\n");
	        strcat(s, "musia³ pokonaæ 3 tory przeszkód. Na ka¿dy tor masz jedn¹ minutê i\n");
	        strcat(s, "trzydzieœci sekund by dojechaæ do mety.\n");
	        strcat(s, "By zdaæ egzamin musisz przejechaæ wszystkie trzy trasy w wyznaczo-\n");
	        strcat(s, "nym czasie oraz z nie uszkodzonym pojazdem.\n");
	        strcat(s, "Po up³ywie czasu automatycznie oblewasz egzamin.\n");
	        strcat(s, "Je¿eli jesteœ ju¿ gotowy i wiesz wszystko co i jak wciœnij przyci-\n");
	        strcat(s, "sk dalej by przenieœæ na plac manewrowy.");
			ShowDialog(playerid, DIALOG_PRAWKO+4, DIALOG_STYLE_MSGBOX, "Prawo jazdy - Praktyka", s, "Dalej", "");
			ZdajePraktyke=playerid;

		}
		case DIALOG_PRAWKO+4:
		{
		    AtualnaTrasa=0;
		    PrzygotujDoPrawka(playerid, AtualnaTrasa);
		    AtualnaTrasa++;
		}
		case DIALOG_PRAWKO+5:
		{
		    OdliczanieKtore=5;
			SetTimerEx("PrawkoOdliczanie", 1000, false, "i", playerid);
		}
	}
	return 1;
}
CMD:rekrutacja(playerid, params[])
{
	new s[2000];
	strcat(s, "{FFFFFF}UID\tStatus\t\tNazwa frakcji/firmy\n");
	for(new n=1; n<FrakcjeValue; n++)
	{
	    format(dstring, sizeof(dstring), "{C0C0C0}%d\t%s\t{C0C0C0}%s\n",
			n,
			((FrakcjaInfo[n][Rekrutacja] == true) ? (""C_ZIELONY"Otwarta\t") : (""C_CZERWONY"Zamkniêta")),
			FrakcjaInfo[n][Nazwa]);
		strcat(s, dstring);
	}
	ShowDialog(playerid, 0, DIALOG_STYLE_LIST, "Status rekrutacji w frakcjach", s, "Wyjdz", "");
	return 1;
}
stock ShowRekrutacja(playerid)
{
    new pfrakcja = PlayerInfo[playerid][Lider];
    if(pfrakcja == 0) return 1;
    format(dstring, sizeof(dstring), "{C0C0C0}Aktualny stan rekrutacji to %s{C0C0C0}.\n\n{C0C0C0}Wybierz stan rekrutacji do twojej frakcji:", ((FrakcjaInfo[pfrakcja][Rekrutacja] == true) ? (""C_ZIELONY"Otwarta") : (""C_CZERWONY"Zamkniêta")));
    ShowDialog(playerid, DIALOG_LIDER+9, DIALOG_STYLE_MSGBOX, "Panel zarz¹dzania Frakcj¹ - Wybierz stan rekrutacji", dstring, "Otwarta", "Zamkniêta");
	return 1;
}
stock SprawdzPojazd(vmodel)
{
	switch(vmodel)
	{
		case 427, 490, 523, 598, 599: return 1;
		case 416: return 3;
		case 525, 578: return 2;
	}
	return 0;
}
stock ListaPojazdow(playerid)
{
    new pfrakcja = PlayerInfo[playerid][Frakcja];
    if(PlayerInfo[playerid][Frakcja]==0)
		return 1;
    new szString[1000], buff[255], value = 1;
	szString = "{FFFFFF}UID\tStan\tPaliwo\tSpawned\tModel\n";
	CarLoop(v)
	{
		if(VehicleInfo[v][frakcja] == pfrakcja)
		{
			format(buff, sizeof(buff), "{C0C0C0}%d\t%.1f\t%.1f\t%s\t\t%s\n",
			v,
			VehicleInfo[v][health],
			VehicleInfo[v][petrol],
			((VehicleInfo[v][gtauid] < 0) ? ("Nie") : ("Tak")),
			VehicleNames[VehicleInfo[v][model]-400]);
			strcat(szString, buff);
            WyswietlaPojazd[playerid][value]=v;
			value++;
		}
	}
	if(value == 0)
	{
		szString = "{FF0000}Nie posiadasz ¿adnych pojazdów!";
	}
	ShowDialog(playerid, DIALOG_LIDER+7, DIALOG_STYLE_LIST, "Twoje pojazdy", szString, "(un)spawn", "Anuluj");
	return 1;
}
stock SpawnFVeh(playerid, vid)
{
	if(VehicleInfo[vid][gtauid]==-1)
	{
	    if(VehicleInfo[vid][health]>0.0)
	    {
		    new szPlate[60];
			new Float: Pos[4];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);
			VehicleInfo[vid][gtauid] = 	CreateVehicle(VehicleInfo[vid][model], Pos[0], Pos[1], Pos[2], Pos[3], VehicleInfo[vid][c1], VehicleInfo[vid][c2], -1);
	  		SetVehicleHealth(VehicleInfo[vid][gtauid], VehicleInfo[vid][health]);
	    	PutPlayerInVehicle(playerid, VehicleInfo[vid][gtauid], 0);
		    format(szPlate, sizeof(szPlate), "SAT %d", vid);
		    SetVehicleNumberPlate(VehicleInfo[vid][gtauid], szPlate);
		    SetVehicleParamsEx(VehicleInfo[vid][gtauid], 0, 0, 0, VehicleInfo[vid][locked], 0, 0, 0);
		    return 1;
		}
		else
		{
		    ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Spawn pojazdów", "Ten pojazd jest zniszczony!", "Rozumiem", "");
		    return 1;
		}
	}
	else
	{
	    GetVehicleHealth(VehicleInfo[vid][gtauid], VehicleInfo[vid][health]);
	    DestroyVehicle(VehicleInfo[vid][gtauid]);
	    VehicleInfo[vid][gtauid]=-1;
		SaveVehicleData(vid);
	}
	return 1;
}
//------------------------------------------------------------------------------
//EOF
stock KupPojazd(playerid)
{
	if(PlayerInfo[playerid][Lider]==0)
		return 1;
	new s[2000];
	strcat(s, "{FFFFFF}Cena\tModel\tNazwa\n");
	for(new n=1; n != MAX_F_POJAZDY; n++)
    {
        format(dstring, sizeof dstring, "{C0C0C0}%d\t%d\t%s\n", PojazdyFirm[n][1], PojazdyFirm[n][0], VehicleNames[PojazdyFirm[n][0]-400]);
		strcat(s, dstring);
	}
	ShowDialog(playerid, DIALOG_LIDER+6, DIALOG_STYLE_LIST, "Lista pojazdów", s, "Kup", "Cofnij");
	return 1;
}
stock StanKonta(playerid)
{
	if(PlayerInfo[playerid][Lider]==0)
	    return 1;
    new pFrakcja = PlayerInfo[playerid][Lider];
	format(dstring, sizeof(dstring), "Stan konta firmy %s wynosi %d$", FrakcjaInfo[pFrakcja][Nazwa], FrakcjaInfo[pFrakcja][Konto]);
    ShowDialog(playerid, DIALOG_LIDER+3, DIALOG_STYLE_MSGBOX, "Panel zarz¹dzania Frakcj¹ - Stan konta", dstring, "Rozumiem", "");
    return 1;
}
stock MenuFirmy(playerid)
{
	if(PlayerInfo[playerid][Lider]==0)
	    return 1;
 	new pFrakcja = PlayerInfo[playerid][Lider];
	new s[1000];
	strcat(s, "{FFFFFF}1. Pracownicy:\n");
	strcat(s, "  {C0C0C0}Zatrudnij pracownika...\n");
	strcat(s, "  {C0C0C0}Zwolnij pracownika...\n");
	strcat(s, "  {C0C0C0}Lista zatrudnionych pracowników...\n");
	strcat(s, "{FFFFFF}2. Spawn:\n");
	strcat(s, "  {C0C0C0}Ustaw miejsce spawnu...\n");
	strcat(s, "{FFFFFF}3. Konto firmy:\n");
	strcat(s, "  {C0C0C0}Stan konta...\n");
	strcat(s, "  {C0C0C0}Wplac pieniadze...\n");
	strcat(s, "  {C0C0C0}Wyplata...\n");
	strcat(s, "{FFFFFF}4. Skin:\n");
	strcat(s, "  {C0C0C0}Zmiana skinu...\n");
	strcat(s, "{FFFFFF}5. Pojazdy:\n");
	strcat(s, "  {C0C0C0}Kup pojazd...\n");
	strcat(s, "  {C0C0C0}Lista pojazdów...\n");
	strcat(s, "{FFFFFF}6. Rekrutacja:\n");
	strcat(s, "  {C0C0C0}Wybierz stan rekrutacji...\n");
	format(dstring, sizeof(dstring), "Panel zarz¹dzania frakcj¹ (%s)", FrakcjaInfo[pFrakcja][Nazwa]);
	ShowDialog(playerid, DIALOG_LIDER, DIALOG_STYLE_LIST, dstring, s, "Wybierz", "Anuluj");
	return 1;
}

stock PracownicyFirmy(playerid)
{
	new query[300];
	if(PlayerInfo[playerid][Lider]==0)
	    return 1;
    new pFrakcja = PlayerInfo[playerid][Lider];
	format(query, sizeof(query), "SELECT * FROM `sat_users` WHERE `frakcja`='%d'", pFrakcja);
	mysql_query(query);
	mysql_store_result();
	if(!mysql_num_rows())
		return ShowDialog(playerid, DIALOG_LIDER+3, DIALOG_STYLE_MSGBOX, "Panel zarz¹dzania Frakcj¹ - Lista pracowników", ""C_ZIELONY"Aktualna lista pracowników:\n\n\t"C_BEZOWY"Brak pracowników!", "Cofnij", "");
	else
	{
	    new savingstring[MAX_PLAYER_NAME];
		new s[1000];
		strcat(s, ""C_ZIELONY"Aktualna lista pracowników:\n\n");
	    while(mysql_fetch_row_format(query,"|"))
	    {
	        mysql_fetch_field_row(savingstring, "username");
			format(dstring, sizeof(dstring), ""C_BEZOWY"\t%s\n", savingstring);
	        strcat(s, dstring);
	    }
	    ShowDialog(playerid, DIALOG_LIDER+3, DIALOG_STYLE_MSGBOX, "Panel zarz¹dzania Frakcj¹ - Lista pracowników", s, "Cofnij", "");
	}
	return 1;
}
stock LoadFrakcje()
{
	ToLog("truckrp.amx->LoadFrakcje->Call");
	new Query[255], cid;
    FrakcjeValue = 0;
    mysql_query("SELECT `uid`, `Nazwa`, `SpawnX`, `SpawnY`, `SpawnZ`, `Skin`, `Konto`, `Rekr` FROM `sat_frakcje`");
    mysql_store_result();
	while(mysql_fetch_row_format(Query, "|"))
	{
	    sscanf(Query, "p<|>i", cid);
	    sscanf(Query, "p<|>is[64]fffiii",
			FrakcjaInfo[cid][UID],
			FrakcjaInfo[cid][Nazwa],
			FrakcjaInfo[cid][SpawnX],
			FrakcjaInfo[cid][SpawnY],
			FrakcjaInfo[cid][SpawnZ],
			FrakcjaInfo[cid][Skin],
			FrakcjaInfo[cid][Konto],
			FrakcjaInfo[cid][Rekrutacja]);
		FrakcjeValue++;
		if(FrakcjaInfo[cid][UID]!=0)
		{
			format(dstring, sizeof(dstring), ""C_BLEKITNY"%s\n"C_BEZOWY"Wpisz "C_ZIELONY"/sluzba "C_BEZOWY"by wejœæ/wyjœæ z s³u¿by.", FrakcjaInfo[cid][Nazwa]);
			FrakcjaInfo[cid][dinfo]=CreateDynamic3DTextLabel(dstring, KOLOR_ZIELONY, FrakcjaInfo[cid][SpawnX], FrakcjaInfo[cid][SpawnY], FrakcjaInfo[cid][SpawnZ], 30.0);
		}
		printf("za³adowano %s", FrakcjaInfo[cid][Nazwa]);
	}
	mysql_free_result();
}

stock NaCentrali(playerid)
{
    for(new i=1; i<CentralaValue+1; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, CentralaInfo[i][cx], CentralaInfo[i][cy], CentralaInfo[i][cz]))
        {
			return i;
        }
    }
	return 0;
}

CMD:zlecenie(playerid, params[])
{
	new pstate = GetPlayerState(playerid);
	if(DoInRange(10, playerid, 373.5872,984.9277,30.0430)||DoInRange(10, playerid, -1733.5723,40.8155,3.5547))
	{
	    if(PlayerInfo[playerid][Pracuje]==1 && PlayerInfo[playerid][Frakcja]==1 || PlayerInfo[playerid][Frakcja]==2)
	    {
	        ShowInfo(playerid, "Nie mo¿esz rozwoziæ towarów bêd¹c w tych frakcjach!");
		}
		else
	    {
		    if(pstate != PLAYER_STATE_DRIVER)
			{
		    	ShowInfo(playerid, "Nie jesteœ w pojeŸdzie!");
		        return 1;
		    }
		    if(VehicleInfo[GetVehicleUID(GetPlayerVehicleID(playerid))][ownerid] == PlayerInfo[playerid][Uid])
			{
			    new vid = GetVehicleUID(GetPlayerVehicleID(playerid));
			    if(VehicleInfo[vid][cargostat]==0 && VehicleInfo[vid][cargo]==0)
			    {
				    new s[3000];
		  			strcat(s, "{FFFFFF}Dostep\tLegalnoœæ\tNazwa:\n");
				    for(new i=1; i<CargosValue+1; i++)
				    {
				        format(dstring, sizeof(dstring), "{C0C0C0}%d\t{C0C0C0}[%s{C0C0C0}]\t%s\n",
				            CargoInfo[i][dostepnosc],
				            ((CargoInfo[i][illegal] < 1) ? (""C_ZIELONY"Legalny") : (""C_CZERWONY"Nielegalny")),
							CargoInfo[i][cname]);
				        strcat(s, dstring);
					}
		            ShowDialog(playerid, DIALOG_TOWARY, DIALOG_STYLE_LIST, "Lista towarów", s, "Zaladuj", "Anuluj");
		        }
				else
				{
					ShowInfo(playerid, "Ten pojazd ma ju¿ przypisane zlecenie!");
				}
		    }
		    else
		    {
		        ShowInfo(playerid, "Ten pojazd nie nale¿y do Ciebie!");
			}
		}
	}
	else
	{
	    ShowInfo(playerid, "Musisz znajdowaæ siê przy Centrali £adunków!");
	}
	return 1;
}
stock LoadCentrale()
{
    ToLog("truckrp.amx->LoadCentrale->Call");
    new Query[255], cid;
    CentralaValue = 0;
    mysql_query("SELECT `uid`, `name`, `lx`, `ly`, `lz` FROM `sat_centrala`");
    mysql_store_result();
    while(mysql_fetch_row_format(Query, "|"))
	{
	    sscanf(Query, "p<|>i", cid);
	    sscanf(Query, "p<|>is[64]fff", CentralaInfo[cid][uid], CentralaInfo[cid][nazwa], CentralaInfo[cid][cx], CentralaInfo[cid][cy], CentralaInfo[cid][cz]);
        CentralaValue++;
	}
	mysql_free_result();
}
stock UsunGracza(playerid, Nick[])
{
	new query[300];
	if(PlayerInfo[playerid][Lider]==0)
	    return 1;
    new pFrakcja = PlayerInfo[playerid][Lider];
	if(strlen(Nick)<=0 || strlen(Nick)>=MAX_PLAYER_NAME)
		return ShowDialog(playerid, DIALOG_LIDER+2, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Zwolnij pracownika", "Niepoprawna d³ugoœæ nicku!\n\nWpisz nick gracza którego chcesz zwolniæ z swojej frakcji:", "Usuñ", "Cofnij");

	new player=GetPlayerID(Nick);
	if(player != -1)
	{
	    if(PlayerInfo[player][Lider]==0)
	    {
		    PlayerInfo[player][Frakcja]=0;
			format(dstring, sizeof(dstring), ""C_SZARY"Zosta³eœ zwolniony z frakcji %s przez %s.", FrakcjaInfo[pFrakcja][Nazwa], PlayerInfo[playerid][Name]);
			ShowInfo(player, dstring);
			format(dstring, sizeof(dstring), ""C_SZARY"Zwolni³eœ %s z %s.", Nick, FrakcjaInfo[pFrakcja][Nazwa]);
			ShowInfo(playerid, dstring);
			savePlayerStats(player);
			MenuFirmy(playerid);
			if(PlayerInfo[playerid][Pracuje]==1)
			{
			    SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
			    PlayerInfo[playerid][Pracuje]=0;
			}
		}
		else
		{
			ShowDialog(playerid, DIALOG_LIDER+2, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Zwolnij pracownika", "Ten gracz nie jest zatrudniony u Ciebie w frakcji!\n\nWpisz nick gracza którego chcesz zwolniæ z swojej frakcji:", "Usuñ", "Cofnij");
		}
		return 1;
	}
	else
	{
		format(query, sizeof(query), "SELECT * FROM `sat_users` WHERE `username`='%s'", Nick);
		mysql_query(query);
		mysql_store_result();
		if(!mysql_num_rows())
			return ShowDialog(playerid, DIALOG_LIDER+2, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Zwolnij pracownika", "Nie ma takiego gracza!\n\nWpisz nick gracza którego chcesz zwolniæ z swojej frakcji:", "Usuñ", "Cofnij");
		else
		{
		    new GetF=0;
		    new savingstring[20];
		    mysql_free_result();
		    format(query, sizeof(query), "SELECT `frakcja` FROM `sat_users` WHERE `username`='%s'", Nick);
		    mysql_query(query);
		    mysql_store_result();
		    while(mysql_fetch_row_format(query,"|"))
		    {
		        mysql_fetch_field_row(savingstring, "frakcja"); GetF=strval(savingstring);
		    }
		    printf("%s\n%d", query, GetF);
		    mysql_free_result();
		    if(GetF==PlayerInfo[playerid][Lider])
		    {
		        format(query, sizeof(query), "UPDATE `sat_users` SET `frakcja`='%d' WHERE `username`='%s'", 0, Nick);
        		mysql_query(query);
        		format(dstring, sizeof(dstring), ""C_SZARY"Zwolni³eœ %s z %s.", Nick, FrakcjaInfo[pFrakcja][Nazwa]);
				ShowInfo(playerid, dstring);
				MenuFirmy(playerid);
        		return 1;
		    }
		    else
			{
				ShowDialog(playerid, DIALOG_LIDER+2, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Zwolnij pracownika", "Ten gracz nie jest zatrudniony u Ciebie w frakcji!\n\nWpisz nick gracza którego chcesz zwolniæ z swojej frakcji:", "Usuñ", "Cofnij");
			}
		}
	}
	return 1;
}
stock DodajGracza(playerid, Nick[])
{
	new query[300];
	if(PlayerInfo[playerid][Lider]==0)
	    return 1;
    new pFrakcja = PlayerInfo[playerid][Lider];
	if(strlen(Nick)<=0 || strlen(Nick)>=MAX_PLAYER_NAME)
		return ShowDialog(playerid, DIALOG_LIDER+1, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Zatrudnij pracownika", "Niepoprawna d³ugoœæ nicku!\n\nWpisz nick gracza którego chcesz zatrudniæ do swojej frakcji:", "Dodaj", "Cofnij");

	new player=GetPlayerID(Nick);
	if(player != -1)
	{
	    if(PlayerInfo[player][Frakcja]==0)
	    {
		    PlayerInfo[player][Frakcja]=pFrakcja;
			format(dstring, sizeof(dstring), ""C_SZARY"Zosta³eœ zatrudniony do %s przez %s. By siê zwolniæ wpisz /zwolnij.", FrakcjaInfo[pFrakcja][Nazwa], PlayerInfo[playerid][Name]);
			ShowInfo(player, dstring);
			format(dstring, sizeof(dstring), ""C_SZARY"Zatrudni³eœ %s do %s.", Nick, FrakcjaInfo[pFrakcja][Nazwa]);
			ShowInfo(playerid, dstring);
			savePlayerStats(player);
			MenuFirmy(playerid);
		}
		else
		{
			ShowDialog(playerid, DIALOG_LIDER+1, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Zatrudnij pracownika", "Ten gracz jest ju¿ zatrudniony w jakieœ frakcji!\n\nWpisz nick gracza którego chcesz zatrudniæ do swojej frakcji:", "Dodaj", "Cofnij");
		}
		return 1;
	}
	else
	{
		format(query, sizeof(query), "SELECT * FROM `sat_users` WHERE `username`='%s'", Nick);
		mysql_query(query);
		mysql_store_result();
		if(!mysql_num_rows())
		{
			return ShowDialog(playerid, DIALOG_LIDER+1, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Zatrudnij pracownika", "Nie ma takiego gracza!\n\nWpisz nick gracza którego chcesz zatrudniæ do swojej frakcji:", "Dodaj", "Cofnij");
		}
		else
		{
		    new GetF=0;
		    new savingstring[20];
		    mysql_free_result();
		    format(query, sizeof(query), "SELECT `frakcja` FROM `sat_users` WHERE `username`='%s'", Nick);
		    mysql_query(query);
		    mysql_store_result();
		    while(mysql_fetch_row_format(query,"|"))
		    {
		        mysql_fetch_field_row(savingstring, "Frakcja"); GetF=strval(savingstring);
		    }
		    mysql_free_result();
		    if(GetF==0)
		    {
		        format(query, sizeof(query), "UPDATE `sat_users` SET `frakcja`='%d' WHERE `username`='%s'", pFrakcja, Nick);
        		mysql_query(query);
        		format(dstring, sizeof(dstring), ""C_SZARY"Zatrudni³eœ %s do %s.", Nick, FrakcjaInfo[pFrakcja][Nazwa]);
				ShowInfo(playerid, dstring);
				MenuFirmy(playerid);
        		return 1;
		    }
		    else
			{
			    if(GetF==pFrakcja)
			    {
					return ShowDialog(playerid, DIALOG_LIDER+1, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Zatrudnij pracownika", "Ten gracz jest ju¿ zatrudniony u Ciebie w frakcji!\n\nWpisz nick gracza którego chcesz zatrudniæ do swojej frakcji:", "Dodaj", "Cofnij");
				}
				ShowDialog(playerid, DIALOG_LIDER+1, DIALOG_STYLE_INPUT, "Panel zarz¹dzania Frakcj¹ - Zatrudnij pracownika", "Ten gracz jest ju¿ zatrudniony w jakieœ frakcji!\n\nWpisz nick gracza którego chcesz zatrudniæ do swojej frakcji:", "Dodaj", "Cofnij");
			}
		}
	}
	return 1;
}

stock GetFrakcja(playerid)
{
    for(new i=0; i<FrakcjeValue; i++)
    {
		if(IsPlayerInRangeOfPoint(playerid, 5.0, FrakcjaInfo[i][SpawnX], FrakcjaInfo[i][SpawnY], FrakcjaInfo[i][SpawnZ]))
		{
		    return i;
		}
	}
	return 0;
}
stock ToPolicjant(playerid)
{
	if(PlayerInfo[playerid][Pracuje]==1&&PlayerInfo[playerid][Frakcja]==1)
	{
	    return 1;
	}
	return 0;
}
stock ToMedyk(playerid)
{
	if(PlayerInfo[playerid][Pracuje]==1&&PlayerInfo[playerid][Frakcja]==3)
	{
	    return 1;
	}
	return 0;
}
stock ToPomoc(playerid)
{
	if(PlayerInfo[playerid][Pracuje]==1&&PlayerInfo[playerid][Frakcja]==2)
	{
	    return 1;
	}
	return 0;
}
stock ToNews(playerid)
{
	if(PlayerInfo[playerid][Pracuje]==1&&PlayerInfo[playerid][Frakcja]==6)
	{
	    return 1;
	}
	return 0;
}
stock ToSG(playerid)
{
	if(PlayerInfo[playerid][Pracuje]==1&&PlayerInfo[playerid][Frakcja]==4)
	{
	    return 1;
	}
	return 0;
}
stock ToTaxi(playerid)
{
	if(PlayerInfo[playerid][Pracuje]==1&&PlayerInfo[playerid][Frakcja]==5)
	{
	    return 1;
	}
	return 0;
}
stock ToWojsko(playerid)
{
	if(PlayerInfo[playerid][Pracuje]==1&&PlayerInfo[playerid][Frakcja]==7)
	{
	    return 1;
	}
	return 0;
}

stock GetPlayerID(Nick[])
{
	for(new playerid=0; playerid != Sloty; playerid++)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(!strcmp(PlayerInfo[playerid][Name], Nick, false))
	        {
	            return playerid;
	        }
	    }
	}
	return -1;
}

stock MenuGlowne(playerid)
{
    ShowDialog(playerid, DIALOG_OBIEKTY_1, DIALOG_STYLE_LIST, "Menu obiektów",
		"Ustaw nowy obiekt\n\
		Cofnij ostatni obiekt\n\
		Wyœwietl listê postawionych przez Ciebie obiektów oraz je edytuj.\n\
		Usuñ wszystkie obiekty.\n\
		", "Wybierz", "Anuluj");
    return 1;
}

stock CofnijObiekt(playerid)
{
	if(Ostatni[playerid]==-1)
	    return ShowDialog(playerid, DIALOG_OBIEKTY_4, DIALOG_STYLE_MSGBOX, "Menu obiektów - Cofanie obiektu", "Najpierw ustaw obiekt!", "Rozumiem", "");

	DestroyObject(Ostatni[playerid]);
	Przeszkod[playerid]--;
	Ostatni[playerid]=-1;
	MenuGlowne(playerid);
	return 1;
}

stock MenuObiektow(playerid)
{
	new s[1000];
    for(new n; n < MAX_OBIEKTOW; n++)
	{
	    format(dstring, sizeof(dstring), "%s\n", SpisObiektow[n][nazwa]);
	    strcat(s, dstring);
	}
 	ShowDialog(playerid, DIALOG_OBIEKTY_2, DIALOG_STYLE_LIST, "Menu obiektów - Ustaw nowy obiekt.", s, "Ustaw", "Wstecz");
	return 1;
}
stock ListaObiektow(playerid)
{
    new s[1000];
	for(new n; n < Przeszkod[playerid]; n++)
	{
	    format(dstring, sizeof(dstring), "%d. %s\n", n+1, SpisObiektow[PrzeszkodaID[playerid][n]][ID]);
	    strcat(s, dstring);
	}
	ShowDialog(playerid, DIALOG_OBIEKTY_3, DIALOG_STYLE_LIST, "Menu obiektów - Lista/Edycja obiektów.", s, "Edytuj", "Wstecz");
	return 1;
}
stock UsunObiekty(playerid)
{
    for(new n; n < Przeszkod[playerid]; n++)
	{
	    DestroyObject(Przeszkoda[playerid][n]);
	}
	Przeszkod[playerid]=0;
	return 1;
}
//------------------------------------------------------------------------------
//CMDS
CMD:cmds(playerid, params[])
{
	new s[1200];
	if(ToPomoc(playerid))
	{
	    strcat(s, "Lista komend Pomocy Drogowej:\n");
	    strcat(s, "\t/obiekt - ustawiasz obiekt/przeszkode.\n");
	    strcat(s, "\t/napraw - naprawiasz pojazd.\n");
	    strcat(s, "\nWiêcej komend dorobiê w póŸniejszym terminie.\nInferno");
	}
	if(ToPolicjant(playerid))
	{
	    strcat(s, "Lista komend Policji:\n");
	    strcat(s, "\t/aresztuj <id> <dlugosc (min)> - aresztujesz gracza na dany czas.\n");
	    strcat(s, "\t/mandat <id> <kwota> - wystawiasz mandat graczowi.\n");
	    strcat(s, "\t/kontrola <id> - kontrolujesz co wiezie gracz.\n");
	    strcat(s, "\t/(m)egafon <id> - wo³asz przez megafon.\n");
	    strcat(s, "\t/(s)uszarka - mierzysz predkosc osób w okolicy.\n");
	    strcat(s, "\nWiêcej komend dorobiê w póŸniejszym terminie.\nInferno");
	}
	if(ToMedyk(playerid))
	{
	    strcat(s, "Lista komend Medyka:\n");
	    strcat(s, "\t/ulecz <id> - leczysz gracza.\n");
	    strcat(s, "\nWiêcej komend dorobiê w póŸniejszym terminie.\nInferno");
	}
	ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Lista komend frakcji", s,"Rozumiem", "");
	return 1;
}
//------------------------------------------------------------------------------
// CMD PD
CMD:obiekt(playerid, params[])
{
	if(!ToPomoc(playerid))
	    return 1;
	if(Edytuje[playerid]>0)
	    return ShowDialog(playerid, DIALOG_OBIEKTY_PYTANIE, DIALOG_STYLE_MSGBOX, "UWAGA", "Je¿eli klikniesz tak obiekt aktualny nie bêdzie zapisany!\nJe¿eli chcesz by pozosta³ na mapie kliknij nie a nastêpnie ikonkê dyskietki\nw menu za¿¹dzania obiektem.\n\n Chcesz anulowaæ edycjê?", "Tak", "Nie");
    MenuGlowne(playerid);
	return 1;
}
CMD:napraw(playerid, params[])
{
	new player = strval(params);
    if(!ToPomoc(playerid))
	    return 1;
	if(!IsPlayerConnected(player))
	{
	    ShowInfo(playerid,"Nie ma takiego gracza!");
	    return 1;
	}
	if(GetPlayerState(player)!=PLAYER_STATE_DRIVER)
	{
		ShowInfo(playerid,"Ten gracz nie jest kierowc¹ ¿adnego pojazdu!");
		return 1;
	}
	if(GetVehSpeed(GetPlayerVehicleID(player))>1)
	{
		ShowInfo(playerid,"Gracz musi staæ w miejscu by u¿yæ tej komendy!");
		return 1;
	}
	new Float:Pos[3];
	GetVehiclePos(GetPlayerVehicleID(player),Pos[0],Pos[1],Pos[2]);
	if(!DoInRange(7.0, playerid,Pos[0],Pos[1],Pos[2]))
	{
	    ShowInfo(playerid,"Jesteœ za daleko od tego gracza!");
	    return 1;
	}
 	new vid = GetVehicleUID(GetPlayerVehicleID(player));
	new Float:HP, koszt;
	GetVehicleHealth(GetPlayerVehicleID(player),VehicleInfo[vid][health]);
	HP=VehicleInfo[vid][health];
	if(HP>=999.0)
	{
		ShowInfo(playerid,"Jego pojazd jest w perfekcyjnym stanie!");
		return 1;
	}
	koszt=floatround((1000.0-HP)*3.1);
	if(PlayerInfo[player][Money]<koszt)
	{
	    ShowInfo(playerid,"Nie staæ go na naprawê mechanika!");
		format(dstring, sizeof dstring, "Nie staæ Ciê na naprawê mechanika! Potrzeba %d$.", koszt);
	    ShowInfo(player,dstring);
		return 1;
	}
	format(dstring, sizeof(dstring), "Czy zgadzasz siê na naprawê pojazdu za %d$?", koszt);
	ShowDialog(player, DIALOG_NAPRAW, DIALOG_STYLE_MSGBOX, "Naprawa pojazdu", dstring, "Tak", "Nie");
	ShowInfo(playerid, "Informacja o naprawie pojazdu zosta³a wys³ana.");
	ShowInfo(playerid, "Gdy tylko siê zgodzi na naprawê pieni¹dze wp³yn¹ na konto frakcji!");
	return 1;
}
//------------------------------------------------------------------------------
// CMD Policji
stock GetPlayerSpeed(playerid)// km/h by destroyer
{
	new Float:x,Float:y,Float:z,Float:predkosc;
	if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),x,y,z); else GetPlayerVelocity(playerid,x,y,z);
	predkosc=floatsqroot((x*x)+(y*y)+(z*z))*198;
	return floatround(predkosc);
}
stock DoInRange(Float: radi, playerid, Float:x, Float:y, Float:z)//sprawdza odleglosc od miejsca
{
	if(IsPlayerInRangeOfPoint(playerid, radi, x, y, z)) return 1;
	return 0;
}
COMMAND:s(playerid,cmdtext[])
{
	return cmd_suszarka(playerid,cmdtext);
}
CMD:suszarka(playerid, cmdtext[])
{
	if(!ToPolicjant(playerid))
	{
		ShowInfo(playerid,""C_CZERWONY"Nie jesteœ w mundurze lub nie pracujesz w policji!");
		return 1;
	}
	if(GetPlayerInterior(playerid)!=0)
	{
		ShowInfo(playerid,""C_CZERWONY"Nie mo¿esz u¿ywaæ tej komendy w interiorze!");
		return 1;
	}
	new Float:Pos[3];
	GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);
	SendClientMessage(playerid,KOLOR_BIALY,"Pojazdy namierzone suszark¹:");
	foreach(Player,i)
	{
		if(GetPlayerState(i)==PLAYER_STATE_DRIVER&&GetPlayerSpeed(i)>5&&DoInRange(90.0, i,Pos[0],Pos[1],Pos[2])&&i!=playerid)
		{
			new w=GetPlayerSpeed(i);
			format(dstring,sizeof(dstring),"Policjant [%d]%s namierzy³ twój pojazd 'suszark¹',wskaza³o: "C_ZOLTY"%d km/h",playerid,PlayerInfo[playerid][Name],w);
			SendClientMessage(i,KOLOR_NIEBIESKI,dstring);
			format(dstring,sizeof(dstring),"Pojazd %s,kierowca: [%d]%s, prêdkoœæ: "C_ZOLTY"%d km/h",GetVehicleName(GetPlayerVehicleID(i)),i,PlayerInfo[i][Name],w);
			SendClientMessage(playerid,KOLOR_NIEBIESKI,dstring);
		}
	}
	return 1;
}

stock GetVehicleName(vehicleid)
{
	new tmp = GetVehicleModel(vehicleid) - 400;
	return VehicleNames[tmp];
}

stock GetVehicleNameByID(vmodel)
{
	new tmp = vmodel - 400;
	return VehicleNames[tmp];
}
	
CMD:aresztuj(playerid, params[])
{
	if(!ToPolicjant(playerid))
	    return 1;
	new Float: Pos[3],
	    player,
	    czas;
	if(sscanf(params, "ii", player, czas))
	    return ShowInfo(playerid, "U¿yj: /aresztuj <id> <minuty>");
	if(!IsPlayerConnected(player))
	    return ShowInfo(playerid, "Nie ma takiego gracza!");
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	if(!IsPlayerInRangeOfPoint(player, 10.0, Pos[0], Pos[1], Pos[2]))
	    return ShowInfo(playerid, "Ten gracz jest za daleko!");
	if(czas<0||czas>15)
	    return ShowInfo(playerid, "Z³y czas. Minimalna d³ugoœæ wiêzienia to 1 minuta a maksymalna 15 minut.");
	new czasdaj = czas*60;
	PlayerInfo[player][Jail]=czasdaj;
	PlayerInfo[player][Areszt]++;
	savePlayerStats(player);
	SetPlayerPos(player,264.9535,77.5068,1001.0391);
	SetPlayerInterior(player,6);
	SetPlayerVirtualWorld(player,player);
	SetPlayerWorldBounds(player,268.5071,261.3936,81.6285,71.8745);
	format(dstring,sizeof(dstring),"Policjant [%d]%s aresztowa³ ciebie na %d minut/y.",playerid,PlayerInfo[playerid][Name],czas);
	SendClientMessage(player,KOLOR_NIEBIESKI,dstring);
	format(dstring,sizeof(dstring),"Aresztowa³eœ [%d]%s na %d minut/y.",player,PlayerInfo[player][Name],czas);
	SendClientMessage(playerid,KOLOR_NIEBIESKI,dstring);
	return 1;
}

CMD:mandat(playerid, params[])
{
	if(!ToPolicjant(playerid))
	    return 1;
	new Float: Pos[3], player, kwota, punkty;
	if(sscanf(params, "iii", player, kwota, punkty))
	    return ShowInfo(playerid, "U¿yj: /mandat <id> <kwota> <punkty karne>");
	    
	if(!IsPlayerConnected(player))
	    return ShowInfo(playerid, "Nie ma takiego gracza.");
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	if(!IsPlayerInRangeOfPoint(player, 10.0, Pos[0], Pos[1], Pos[2]))
	    return ShowInfo(playerid, "Ten gracz jest za daleko!");
	if(kwota<10||kwota>15000)
	    return ShowInfo(playerid, "Z³a kwota!");
	if(punkty<0)
	    return ShowInfo(playerid, "Z³a iloœæ punktów karnych!");
	    
	mandatod[player]=playerid;
	mandatkwota[player]=kwota;
	punktyilosc[player]=punkty;
	
	format(dstring, sizeof(dstring), "Wystawi³eœ mandat graczowi %s[%d] w wysokoœci %d$ \noraz %d punktów karnych. \n\nPoczekaj na zap³atê. Gdy sp³aci zostanie Ci pokazana informacja!", PlayerInfo[player][Name], player, kwota, punkty);
	ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Mandat", dstring, "Rozumiem", "");
	
	format(dstring, sizeof(dstring), "Policjant %s[%d] wystawi³ Ci mandat na kwotê %d$ \noraz %d punktów karnych.\n\nCzy przyjmujesz mandat?", PlayerInfo[playerid][Name], playerid, kwota, punkty);
	ShowDialog(player, DIALOG_MANDAT, DIALOG_STYLE_MSGBOX, "Mandat", dstring, "Tak", "Nie");
	return 1;
}

COMMAND:m(playerid,cmdtext[])
{
	return cmd_megafon(playerid,cmdtext);
}

CMD:megafon(playerid, params[])
{
	if(!ToPolicjant(playerid))
	    return 1;
	if(isnull(params))
	    return ShowInfo(playerid, "U¿yj: /(m)egafon <tresc>");
	new Float: Pos[3];
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
    for(new i=0; i<Sloty; i++)
    {
        if(DoInRange(50, i, Pos[0], Pos[1], Pos[2]))
        {
            format(dstring, sizeof(dstring), ""C_NIEBIESKI"***"C_ZOLTY"%s"C_NIEBIESKI"***", params);
            SendClientMessage(i, KOLOR_ZOLTY, dstring);
		}
	}
	return 1;
}

CMD:kontrola(playerid, params[])
{
	if(!ToPolicjant(playerid))
	    return 1;
	if(isnull(params))
	    return ShowInfo(playerid, "U¿yj: /kontrola <id>");
	new player = strval(params),
	    Float: Pos[3];
    if(!IsPlayerConnected(player))
	    return ShowInfo(playerid, "Nie ma takiego gracza.");
    GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	if(!IsPlayerInRangeOfPoint(player, 10.0, Pos[0], Pos[1], Pos[2]))
	    return ShowInfo(playerid, "Ten gracz jest za daleko!");
	new pstate = GetPlayerState(player);
	if(pstate != PLAYER_STATE_DRIVER)
	    return ShowInfo(playerid, "Ten gracz nie jest kierowc¹!");
	new v = GetPlayerVehicleID(player);
	new vuid = GetVehicleUID(v);
	new vmodel = GetVehicleModel(v);
	new vcargo = VehicleInfo[vuid][cargo];
	if(vcargo < 1)
	{
		format(dstring, sizeof(dstring), ""C_CZERWONY"Kontrola przewo¿onego towaru.\n  {C0C0C0}Gracz: %s[%d]\n  {C0C0C0}Pojazd: %s(UID: %d)\n  {C0C0C0}Przewo¿ony towar: %s\n  {C0C0C0}Towar legalny: %s\n  {C0C0C0}Waga towaru: %s",
		    PlayerInfo[player][Name],
			player,
			VehicleNames[vmodel-400],
			vuid,
			"brak",
			((CargoInfo[vcargo][illegal] == 0) ? (""C_ZIELONY"brak") : (""C_CZERWONY"brak")),
			"Funkcja w budowie...");
		ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Kontrola", dstring, "Rozumiem", "");
		ShowDialog(player, 0, DIALOG_STYLE_MSGBOX, "Kontrola", dstring, "Rozumiem", "");
	}
	else
	{
		format(dstring, sizeof(dstring), ""C_CZERWONY"Kontrola przewo¿onego towaru.\n  {C0C0C0}Gracz: %s[%d]\n  {C0C0C0}Pojazd: %s(UID: %d)\n  {C0C0C0}Przewo¿ony towar: %s\n  {C0C0C0}Towar legalny: %s\n  {C0C0C0}Waga towaru: %s",
		    PlayerInfo[player][Name],
			player,
			VehicleNames[vmodel-400],
			vuid,
			CargoInfo[vcargo][cname],
			((CargoInfo[vcargo][illegal] == 0) ? (""C_ZIELONY"Tak") : (""C_CZERWONY"Nie")),
			"Funkcja w budowie...");
		ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Kontrola", dstring, "Rozumiem", "");
		ShowDialog(player, 0, DIALOG_STYLE_MSGBOX, "Kontrola", dstring, "Rozumiem", "");
	}
	return 1;
}
//------------------------------------------------------------------------------
// CMD Medyk
CMD:ulecz(playerid, params[])
{
	if(!ToMedyk(playerid))
	    return 1;
	new player = strval(params),
 		Float: Pos[3];
	if(!IsPlayerConnected(player))
	    return ShowInfo(playerid, "Nie ma takiego gracza.");
    GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	if(!IsPlayerInRangeOfPoint(player, 10.0, Pos[0], Pos[1], Pos[2]))
	    return ShowInfo(playerid, "Ten gracz jest za daleko!");
	if(playerid==player)
	    return ShowInfo(playerid, "Nie mo¿esz leczyæ sam siebie!");
	SetPlayerHealth(player, 100.0);
	return 1;
}
public OnPlayerCommandReceived(playerid, cmdtext[])
{
	if(PlayerInfo[playerid][Logged]==false)
	{
		ShowInfo(playerid,"Nie zalogowa³eœ siê!");
		return 0;
	}
	if(PlayerInfo[playerid][Jail]>=1)
	{
	    ShowInfo(playerid,"Jesteœ w wiêzieniu, nie mo¿esz u¿ywaæ komend!");
		return 0;
	}
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	printf("[CMD]%s - %s", PlayerInfo[playerid][Name], cmdtext);
	if(!success)
	{
		ShowInfo(playerid,""C_CZERWONY"Nie poprawna komenda! Spis komend: /cmd");
	}
	return 1;
}

stock NieDotyczy(carid)
{
	new vmodel = GetVehicleModel(carid);
	if(vmodel==552) return 1;
	if(vmodel==443) return 1;
	if(vmodel==530) return 1;
	if(vmodel==487) return 1;
	if(vmodel==416) return 1;
	if(vmodel==598) return 1;
	if(vmodel==596) return 1;
	if(vmodel==599) return 1;
	if(vmodel==523) return 1;
	return 0;
}

CMD:fmoney(playerid, params[])
{
	if(!IsAdmin(playerid, 3))
	    return 1;
	new fffrakcja, ilosc;
	if(sscanf(params, "ii", fffrakcja, ilosc))
	    return 1;
	FrakcjaInfo[fffrakcja][Konto]+=ilosc;
	return 1;
}

stock SprawdzTowary()
{
    for(new i=1; i<CargosValue+1; i++)
    {
        if(CargoInfo[i][dostepnosc]>0)
        {
            return 1;
		}
	}
	return 0;
}

CMD:restart(playerid, params[])
{
	if(!IsAdmin(playerid, 2))
	    return 1;
	    
    for(new i=1; i<Sloty+1; i++)
    {
	    KaraTD("Kick", PlayerInfo[playerid][Name], PlayerInfo[i][Name], "Restart serwera", 10);
		Kick(i);
    }
    SendRconCommand("password restart");
    return 1;
}

stock CanTuning(vmodel)
{
	switch(vmodel)
	{
		case 417,425,430,435,446..450,452..454,460..465,468,469,471..473,
		476,481,484,485,487,488,493,497,501,509..513,519..523,537..539,548,
		553,563,569,570,577,581,586,590..595,606..611:return 0;
	}
	return 1;
}

CMD:warn(playerid, params[])
{
	if(!IsAdmin(playerid))
	    return 1;
	new player, Reasona[128];
	if(sscanf(params, "is[128]", player, Reasona))
	    return ShowInfo(playerid, "U¿yj: /warn <id> <powód>");
	    
    PlayerInfo[player][Warn]++;
    if(PlayerInfo[player][Warn]==4)
    {
        Kick(playerid);
        KaraTD("Blokada konta (4 warn)", PlayerInfo[playerid][Name], PlayerInfo[player][Name], Reasona, 10);
	}
	else
	{
	    KaraTD("Warn", PlayerInfo[playerid][Name], PlayerInfo[player][Name], Reasona, 10);
	}
	return 1;
}

stock UzywanyBinco()
{
    PlayerLoop(i)
    {
        if(PlayerInfo[i][InBinco]==true)
        {
			return 1;
		}
	}
	return 0;
}

CMD:sklep(playerid, params[])
{
	if(PlayerInfo[playerid][InBinco]==false)
	{
		if(UzywanyBinco())
		{
		    return ShowInfo(playerid, "Ktoœ ju¿ jest w przebieralni!");
		}
	}
	if(!DoInRange(4.0, playerid, 217.7649,-98.6183,1005.2578))
	{
	    ShowInfo(playerid, "Musisz byæ w sklepie binco!");
	    return 1;
	}
    
    if(PlayerInfo[playerid][InBinco]==false)
    {
        SetPlayerVirtualWorld(playerid, 666);
        SetPlayerPos(playerid, 217.7649,-98.6183,1005.2578);
        SetPlayerFacingAngle(playerid, 270.0000);
    	SetPlayerCameraPos(playerid, 215.9861,-99.9208,1005.2578);
    	SetPlayerCameraLookAt(playerid, 217.5232,-98.5866,1005.2578);
    	TogglePlayerControllable(playerid,0);
    	PlayerInfo[playerid][InBinco]=true;
        SetPlayerSkin(playerid, skiny[0]);
        OgladaSkin[playerid]=0;
        TextDrawShowForPlayer(playerid, BincoTD[0]);
        TextDrawShowForPlayer(playerid, BincoTD[1]);
	}
	else
	{
	    SetCameraBehindPlayer(playerid);
	    SetPlayerVirtualWorld(playerid, 0);
	    PlayerInfo[playerid][InBinco]=false;
	    TogglePlayerControllable(playerid,1);
	    SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
	    OgladaSkin[playerid]=-1;
	    TextDrawHideForPlayer(playerid, BincoTD[0]);
        TextDrawHideForPlayer(playerid, BincoTD[1]);
	}
    return 1;
}
CMD:pojazd(playerid, params[])
{
	if(GetPlayerInterior(playerid)!=0)
	    return ShowInfo(playerid, "Nie mo¿esz tutaz zespawnowaæ pojazdu!");
    ListaPojazdow(playerid);
    return 1;
}

CMD:kill(playerid, params[])
{
	if(!IsAdmin(playerid, 3))
	    return 1;
	SetPlayerHealth(playerid, 0);
	return 1;
}

CMD:setskin(playerid, params[])
{
	new player, skinid;
	if(!IsAdmin(playerid, 2))
	    return 1;
	    
	if(sscanf(params, "ii", player, skinid))
	    return ShowInfo(playerid, "U¿yj: /setskin <player id> <skin id>");
	SetPlayerSkin(player, skinid);
	PlayerInfo[player][Skin]=skinid;
	return 1;
}

CMD:wyplata(playerid, params[])
{
    new pFrakcja = PlayerInfo[playerid][Lider],
		player,
		kwota;
	if(pFrakcja==0)
	    return 1;
	if(sscanf(params, "ii", player, kwota))
	    return ShowInfo(playerid, "U¿yj: /wyplata <id> <kwota>");
	if(!IsPlayerConnected(player))
	    return ShowInfo(playerid, "Nie ma takiego gracza!");
	if(kwota < 0 || kwota > FrakcjaInfo[pFrakcja][Konto])
	    return ShowInfo(playerid, "Nie poprawna kwota wyp³aty!");
	if(PlayerInfo[playerid][Frakcja]!=pFrakcja)
	    return ShowInfo(playerid, "Ten gracz nie nale¿y do twojej frakcji!");
	PlayerInfo[player][Money]+=kwota;
	FrakcjaInfo[pFrakcja][Konto]-=kwota;
	format(dstring, sizeof(dstring), "UPDATE `sat_frakcje` SET `Konto`='%d' WHERE `uid`='%d'", FrakcjaInfo[pFrakcja][Konto], pFrakcja);
 	mysql_query(dstring);
 	format(dstring, sizeof(dstring), "Da³eœ wyp³atê graczowi %s[%d] w wysokoœci %d$.", PlayerInfo[player][Name], player, kwota);
 	ShowInfo(playerid, dstring);
 	return 1;
}

CMD:givepp(playerid, params[])
{
	new player, ilosc;
	if(!IsAdmin(playerid, 3))
	    return 1;
	if(sscanf(params, "ii", player, ilosc))
	    return ShowInfo(playerid, "U¿yj: /givepp <id> <ilosc>");
	if(!IsPlayerConnected(player))
	    return ShowInfo(playerid, "Nie ma takeigo gracza!");
	PlayerInfo[player][Gold]+=ilosc;
	format(dstring, sizeof(dstring), "UPDATE `sat_users` SET `Gold`='%d' WHERE `uid`='%d'", PlayerInfo[player][Gold], PlayerInfo[player][Uid]);
	mysql_query(dstring);
	format(dstring, sizeof(dstring), "Administrator %s[%d] da³ Ci %d Punktów Premium (PP). Wszystko o PP znajdziesz pod /pp.", PlayerInfo[playerid][Name], playerid, ilosc);
	ShowInfo(player, dstring);
	format(dstring, sizeof(dstring), "Da³eœ %d PP graczowi %s[%d].", PlayerInfo[player][Name], player, ilosc);
	ShowInfo(playerid, dstring);
	return 1;
}

CMD:pp(playerid, params[])
{
	new s[2000];
	strcat(s, "{FFFFFF}1. Co to jest PP?\n");
	strcat(s, "   {C0C0C0}PP to skrót od PunktyPremium.\n");
	strcat(s, "{FFFFFF}2. Co daj¹ PunktyPremium?\n");
	strcat(s, "   {C0C0C0}Za PP mo¿esz zakupiæ unikalny pojazd/skin lub wymieniæ je na KP?\n");
	strcat(s, "{FFFFFF}3. Co to jest KP?\n");
	strcat(s, "   {C0C0C0}KP to inaczej KontoPremium czyli taki jak by VIP na serwerze. Gracz z tym dodatkiem\n");
	strcat(s, "   {C0C0C0}posiada liczne udogodnienia takie jak:\n");
	strcat(s, "      {C0C0C0}- +50% nale¿noœci podstawowej (nie wliczaj¹c dodatków pojazdu) za przewieziony towar.\n");
	strcat(s, "      {C0C0C0}- -30% tañszy ka¿dy mandat.\n");
	strcat(s, "      {C0C0C0}- Inny kolor nicku na chacie i nad g³ow¹.\n");
	strcat(s, "      {C0C0C0}- +1 score za ka¿dy przewieziony towar.\n");
	strcat(s, "      {C0C0C0}- -20% rabatu za przejazd taksówk¹.\n");
	strcat(s, "{FFFFFF}4. Jak zdobyæ PP i ile one kosztuj¹?\n");
	strcat(s, "   {C0C0C0}Wszelkie informacje na temat punktów premium znajdziesz pod www.Hard-Truck.pl/pp.php.\n");
	strcat(s, "{FFFFFF}5. Ile kosztuje KP?\n");
	strcat(s, "   {C0C0C0}1 tydzieñ - 100PP\n");
	strcat(s, "   {C0C0C0}2 tygodnie - 180PP\n");
	strcat(s, "   {C0C0C0}1 miesi¹c - 350PP\n");
	strcat(s, "{FFFFFF}6. Gdzie kupiê KP?\n");
	strcat(s, "   {C0C0C0}Zdobêdziesz je pod komend¹ /konto.\n");
	strcat(s, "{FFFFFF}7. Wys³a³em sms'a na PP i co dalej?\n");
	strcat(s, "   {C0C0C0}Napisz PW do Inferno na www.Hard-Truck.pl wed³ug wzoru podanego na stronie z pkt 4.\n");
	ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Informacje o Punktach Premium (PP)", s, "Rozumiem", "");
	return 1;
}

CMD:dajvip(playerid,params[])
{
	new player, Days, Hours, vCena;

	if(!IsAdmin(playerid, 3)) return 0;
	if(sscanf(params, "iiii", player, Days, Hours, vCena))
		return ShowInfo(playerid, "Uzyj: /dajvip [ID gracza] [Dni] [Godziny] [Cena]");
	if(IsPlayerConnected(player))
	{
		GiveVip(player, Days, Hours, vCena);
		format(dstring, sizeof(dstring), "Dosta³eœ VIP'a na %i Dni i %i Godzin ! Komendy: /vcmd.", Days, Hours);
		ShowInfo(player, dstring);
		ShowInfo(player, "Proszê zrobiæ reloga!");
		KaraTD("Kick", "System", PlayerInfo[player][Name], "Nadanie konta VIP", 10);
		Kick(player);
		format(dstring, sizeof(dstring), "Da³eœ VIP'a graczowi %s[%d] na %i Dni i %i Godzin.", PlayerInfo[player][Name], player, Days, Hours);
		ShowInfo(playerid, dstring);
	}
	return 1;
}

stock GiveVip(playerid, Days, Hours, vCena)
{
	PlayerInfo[playerid][Gold]-=vCena;
	new timeVip;
	timeVip = (Days * 86400) + (Hours * 3600) + gettime();
	PlayerInfo[playerid][VIP]=timeVip;
	format(dstring, sizeof(dstring), "UPDATE `sat_users` SET `VIP`='%d', `Gold`='%d' WHERE `uid`='%d'", PlayerInfo[playerid][VIP], PlayerInfo[playerid][Gold], PlayerInfo[playerid][Uid]);
	mysql_query(dstring);
	return 1;
}

stock PokazCzas(playerid)
{
	new CzasPrem, Days, Hours, Minutes;
	CzasPrem = PlayerInfo[playerid][VIP] - gettime();


	if (CzasPrem >= 86400)
	{
		Days = CzasPrem / 86400;
		CzasPrem = CzasPrem - (Days * 86400);
	}
	if (CzasPrem >= 3600)
	{
		Hours = CzasPrem / 3600;
		CzasPrem = CzasPrem - (Hours * 3600);
	}
	if (CzasPrem >= 60)
	{
		Minutes = CzasPrem / 60;
		CzasPrem = CzasPrem - (Minutes * 60);
	}

	new ff[128];
	format(ff,sizeof ff,"Konto VIP aktywne przez: %i Dni, %i Godzin, %i Minut",Days,Hours,Minutes);
	ShowInfo(playerid,ff);
}

CMD:tovip(playerid, params[])
{
	if(IsVip(playerid))
	{
	    ShowInfo(playerid, "Jesteœ VIP'em");
	}
	else
	{
	    ShowInfo(playerid, "Nie jesteœ VIP'em");
	}
	return 1;
}

stock IsVip(playerid)
{
	if(PlayerInfo[playerid][VIP] > gettime())
	{
	    return 1;
	}
	return 0;
}

stock ShowOgloszenie(playerid, Text[], czas)
{
    if(pokazywaneogloszenie[playerid]==1)
    {
        KillTimer(ogloszenietimer[playerid]);
        TextDrawHideForPlayer(playerid, OgloszenieTD[playerid]);
        TextDrawSetString(OgloszenieTD[playerid], " ");
        pokazywaneogloszenie[playerid]=0;
	}
	new Float: Pos[3];
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	PlayerPlaySound(playerid, 1083, Pos[0], Pos[1], Pos[2]);
    pokazywaneogloszenie[playerid]=1;
    TextDrawSetString(OgloszenieTD[playerid], Text);
    TextDrawShowForPlayer(playerid, OgloszenieTD[playerid]);
    SetTimerEx("ShowajOgloszenie", czas*1000, false, "i", playerid);
    return 1;
}

forward ShowajOgloszenie(playerid);
public ShowajOgloszenie(playerid)
{
	KillTimer(ogloszenietimer[playerid]);
 	TextDrawHideForPlayer(playerid, OgloszenieTD[playerid]);
  	TextDrawSetString(OgloszenieTD[playerid], " ");
   	pokazywaneogloszenie[playerid]=0;
   	return 1;
}

CMD:setcb(playerid, params[])
{
	new playerstate = GetPlayerState(playerid);
	new vid = GetPlayerVehicleID(playerid);
	new vuid = GetVehicleUID(vid);
	if(playerstate != PLAYER_STATE_DRIVER)
	    return ShowInfo(playerid, "Musisz byæ kierowc¹ pojazdu by zmieniæ stacjê w CB-Radiu!");
	if(VehicleInfo[vuid][ownerid]!=PlayerInfo[playerid][Uid])
	    return ShowInfo(playerid, "Ten pojazd nie nale¿y do Ciebie!");
	if(VehicleInfo[vuid][cb]==-1)
	    return ShowInfo(playerid, "Ten pojazd nie ma zakupionego CB-Radia! Kupisz go pod /v l -> pojazd -> Dodatki...");
	new stacjacb;
	if(sscanf(params, "i", stacjacb))
	    return ShowInfo(playerid, "U¿yj: /setcb <id stacji [0-50]>");
	if(stacjacb < 0 || stacjacb > 50)
		return ShowInfo(playerid, "Nie poprawny numer CB-Stacji! Musi siê on mieœciæ miêdzy 0 a 50!");
		
	VehicleInfo[vuid][cb]=stacjacb;
	format(dstring, sizeof(dstring), "UPDATE `sat_vehicles` SET `cb`='%d' WHERE `uid`='%d'", stacjacb, vuid);
	mysql_query(dstring);
	ShowInfo(playerid, "Zmieni³eœ stacjê w CB-Radiu. By rozmawiaæ przez CB poprzedŸ swoj¹ wypowiedŸ ! na chacie.");
	return 1;
}
stock SendMessageCB(playerid, text[])
{
	new cbmessage[350];
	new playerstate = GetPlayerState(playerid);
	new vid = GetPlayerVehicleID(playerid);
	new vuid = GetVehicleUID(vid);
	if(playerstate != PLAYER_STATE_DRIVER)
	    return ShowInfo(playerid, "Musisz byæ kierowc¹ pojazdu by pisaæ na CB-Radiu!");
	if(VehicleInfo[vuid][cb]==-1)
	    return ShowInfo(playerid, "Ten pojazd nie ma zakupionego CB-Radia! Kupisz go pod /v l -> pojazd -> Dodatki...");
	    
	format(cbmessage, 350, ""C_NIEBIESKI"[CB-Radio: %d] %s[%d]: %s", VehicleInfo[vuid][cb], PlayerInfo[playerid][Name], playerid, text);
    PlayerLoop(player)
    {
        if(IsPlayerConnected(player))
        {
	        new pplayerstate = GetPlayerState(player);
	        new pvid = GetPlayerVehicleID(player);
			new pvuid = GetVehicleUID(pvid);
			if(pplayerstate == PLAYER_STATE_DRIVER)
			{
				if(VehicleInfo[pvuid][cb]==VehicleInfo[vuid][cb])
				{
					SendClientMessage(player, KOLOR_BIALY, cbmessage);
				}
			}
		}
	}
	return 1;
}

CMD:prawko(playerid, params[])
{
    DodajWpis(playerid);
	if(DoInRange(5.0, playerid, 1172.6592, 1354.5636, 10.9219))
	{
		ShowDialog(playerid, DIALOG_PRAWKO-1, DIALOG_STYLE_MSGBOX, "Prawo jazdy", "Jaky typ egzaminu chcesz teraz zdaæ?", "Teoria", "Praktyka");
	}
	else
	{
	    ShowInfo(playerid, "Nie jesteœ w budynku nauki jazdy!");
	}
	return 1;
}

stock ZdanaTeoria(playerid)
{
	new szQuery[255];
	format(szQuery, sizeof(szQuery), "SELECT * FROM `sat_prawko` WHERE `username`='%s' AND `teoria`='1'", PlayerInfo[playerid][Name]);
	mysql_query(szQuery);
    mysql_store_result();
	mysql_fetch_row_format(szQuery);
	if(mysql_num_rows()!=0)
	{
	    mysql_free_result();
	    return 1;
	}

	return 0;
}
stock ZdanaPraktyka(playerid)
{
	new szQuery[255];
	format(szQuery, sizeof(szQuery), "SELECT * FROM `sat_prawko` WHERE `username`='%s' AND `praktyka`='1'", PlayerInfo[playerid][Name]);
	mysql_query(szQuery);
    mysql_store_result();
	mysql_fetch_row_format(szQuery);
	if(mysql_num_rows()!=0)
	{
	    mysql_free_result();
	    return 1;
	}

	return 0;
}
stock DodajWpis(playerid)
{
	new szQuery[255];
	format(szQuery, sizeof(szQuery), "SELECT * FROM `sat_prawko` WHERE `username`='%s'", PlayerInfo[playerid][Name]);
	mysql_query(szQuery);
    mysql_store_result();
	mysql_fetch_row_format(szQuery);
	if(mysql_num_rows()==0)
	{
	    format(szQuery, sizeof(szQuery), "INSERT INTO `sat_prawko` SET `username`='%s'", PlayerInfo[playerid][Name]);
	    mysql_query(szQuery);
	    print("dodano wpis");
	    return 1;
	}
	print("nie dodano wpisu");
	mysql_free_result();
	return 0;
}

forward PrawkoOdliczanie(playerid);
public PrawkoOdliczanie(playerid)
{
    GameTextForPlayer(playerid, OdliczankoPrawko[OdliczanieKtore], 1000, 5);
    if(OdliczanieKtore>0)
    {
    	PlayerSoundForPlayer(playerid, 1056);
    	SetTimerEx("PrawkoOdliczanie", 1000, false, "i", playerid);
	}
    if(OdliczanieKtore==0)
    {
        PlayerSoundForPlayer(playerid, 1057);
        TogglePlayerControllable(playerid, true);
    }
    OdliczanieKtore--;
    return 1;
}

stock PrzygotujDoPrawka(playerid, typ)
{
	SetPlayerVirtualWorld(playerid, VW_PRAWKA);
	SetPlayerInterior(playerid, 0);
    PrawkoDestroyObject();
    PrawkoCreateObject(playerid, typ);
	PutPlayerInVehicle(playerid, PojazdPraktyka, 0);
	TogglePlayerControllable(playerid, false);
	TogglePlayerDynamicRaceCP(playerid, KoniecTrasy, 1);
	return 1;
}

stock PrawkoCreateObject(playerid, typ)
{
	if(typ==0)
	{
	    PrawkoDestroyObject();
		ObiektyPraktyka[0] = CreateDynamicObject(3578, 1165.76, 1227.52, 10.49,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[1] = CreateDynamicObject(3578, 1162.17, 1231.00, 10.49,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[2] = CreateDynamicObject(3578, 1169.25, 1231.03, 10.49,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[3] = CreateDynamicObject(19425, 1164.38, 1235.61, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[4] = CreateDynamicObject(19425, 1167.47, 1235.60, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[5] = CreateDynamicObject(1237, 1169.23, 1236.79, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[6] = CreateDynamicObject(1237, 1162.14, 1236.79, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[7] = CreateDynamicObject(1237, 1169.26, 1239.61, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[8] = CreateDynamicObject(1237, 1169.26, 1242.50, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[9] = CreateDynamicObject(1237, 1169.25, 1245.34, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[10] = CreateDynamicObject(1237, 1169.33, 1248.16, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[11] = CreateDynamicObject(1237, 1168.73, 1251.16, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[12] = CreateDynamicObject(1237, 1167.27, 1253.82, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[13] = CreateDynamicObject(1237, 1165.23, 1255.87, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[14] = CreateDynamicObject(1237, 1162.81, 1257.69, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[15] = CreateDynamicObject(1237, 1159.99, 1258.51, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[16] = CreateDynamicObject(1237, 1157.22, 1258.78, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[17] = CreateDynamicObject(1237, 1154.55, 1258.75, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[18] = CreateDynamicObject(1237, 1162.32, 1239.20, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[19] = CreateDynamicObject(1237, 1162.39, 1242.03, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[20] = CreateDynamicObject(1237, 1162.47, 1245.15, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[21] = CreateDynamicObject(1237, 1161.95, 1247.96, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[22] = CreateDynamicObject(1237, 1160.26, 1249.96, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[23] = CreateDynamicObject(1237, 1157.64, 1251.44, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[24] = CreateDynamicObject(1237, 1154.25, 1251.89, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[25] = CreateDynamicObject(1237, 1151.20, 1252.15, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[26] = CreateDynamicObject(1237, 1148.15, 1252.37, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[27] = CreateDynamicObject(1237, 1145.18, 1252.72, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[28] = CreateDynamicObject(1237, 1151.99, 1259.28, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[29] = CreateDynamicObject(1237, 1149.86, 1260.48, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[30] = CreateDynamicObject(1237, 1148.92, 1263.10, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[31] = CreateDynamicObject(1237, 1148.88, 1265.56, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[32] = CreateDynamicObject(1237, 1143.10, 1253.92, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[33] = CreateDynamicObject(1237, 1141.43, 1258.10, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[34] = CreateDynamicObject(1237, 1141.33, 1260.50, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[35] = CreateDynamicObject(1237, 1141.31, 1262.99, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[36] = CreateDynamicObject(1237, 1141.33, 1265.59, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[37] = CreateDynamicObject(1237, 1141.72, 1255.81, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[38] = CreateDynamicObject(1237, 1148.95, 1268.10, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[39] = CreateDynamicObject(1237, 1148.91, 1270.49, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[40] = CreateDynamicObject(1237, 1141.39, 1267.88, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[41] = CreateDynamicObject(1237, 1141.48, 1270.46, 9.78,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[42] = CreateDynamicObject(3578, 1145.21, 1280.05, 10.49,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[43] = CreateDynamicObject(3578, 1141.49, 1276.69, 10.49,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[44] = CreateDynamicObject(3578, 1148.91, 1276.58, 10.49,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[45] = CreateDynamicObject(19425, 1143.45, 1272.12, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[46] = CreateDynamicObject(19425, 1146.75, 1272.12, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);

        PojazdPraktyka = CreateVehicle(604, 1165.8857, 1231.8535, 10.5024, 0.0000, -1, -1, 100);
		SetVehicleVirtualWorld(PojazdPraktyka, VW_PRAWKA);
		SetVehicleHealth(PojazdPraktyka, 1000.0);
		KoniecTrasy = CreateDynamicRaceCP(1, 1145.4443, 1275.5548, 10.5612, 0.0, 0.0, 0.0, 5, VW_PRAWKA, -1, -1, 200.0);
		iloscobiektow=47;

		ShowDialog(playerid, DIALOG_PRAWKO+5, DIALOG_STYLE_MSGBOX, "Prawo jazdy - praktyka (Trasa: 1/3)", "Je¿eli jesteœ gotowy wciœnij start by rozpocz¹æ.", "START", "");
		return 1;
	}
	if(typ==1)
	{
	    PrawkoDestroyObject();
		ObiektyPraktyka[0] = CreateDynamicObject(3578, 1140.59, 1220.70, 10.51,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[1] = CreateDynamicObject(3578, 1136.70, 1217.96, 10.51,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[2] = CreateDynamicObject(3578, 1133.24, 1220.71, 10.51,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[3] = CreateDynamicObject(19425, 1135.48, 1225.55, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[4] = CreateDynamicObject(19425, 1138.71, 1225.56, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[5] = CreateDynamicObject(1237, 1133.28, 1226.36, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[6] = CreateDynamicObject(1237, 1140.74, 1226.36, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[7] = CreateDynamicObject(3578, 1126.59, 1269.82, 10.51,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[8] = CreateDynamicObject(3578, 1136.79, 1269.90, 10.51,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[9] = CreateDynamicObject(3578, 1131.44, 1274.48, 10.51,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[10] = CreateDynamicObject(1237, 1137.61, 1233.59, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[11] = CreateDynamicObject(1237, 1137.79, 1244.19, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[12] = CreateDynamicObject(1237, 1137.98, 1254.11, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[13] = CreateDynamicObject(1237, 1136.70, 1263.79, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[14] = CreateDynamicObject(1237, 1133.25, 1228.75, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[15] = CreateDynamicObject(983, 1147.52, 1229.46, 10.48,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[16] = CreateDynamicObject(983, 1144.29, 1226.24, 10.48,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[17] = CreateDynamicObject(983, 1147.51, 1235.86, 10.48,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[18] = CreateDynamicObject(983, 1147.56, 1242.24, 10.48,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[19] = CreateDynamicObject(983, 1147.58, 1248.62, 10.48,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[20] = CreateDynamicObject(983, 1147.59, 1255.00, 10.48,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[21] = CreateDynamicObject(983, 1147.63, 1261.46, 10.48,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[22] = CreateDynamicObject(983, 1144.44, 1264.65, 10.48,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[23] = CreateDynamicObject(983, 1139.64, 1264.69, 10.48,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[24] = CreateDynamicObject(983, 1126.41, 1261.10, 10.48,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[25] = CreateDynamicObject(983, 1126.39, 1254.70, 10.48,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[26] = CreateDynamicObject(983, 1126.37, 1248.30, 10.48,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[27] = CreateDynamicObject(983, 1126.37, 1241.90, 10.48,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[28] = CreateDynamicObject(983, 1126.37, 1235.54, 10.48,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[29] = CreateDynamicObject(983, 1126.34, 1229.18, 10.48,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[30] = CreateDynamicObject(983, 1129.56, 1225.94, 10.48,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[31] = CreateDynamicObject(1237, 1135.39, 1233.55, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[32] = CreateDynamicObject(1237, 1133.24, 1231.36, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[33] = CreateDynamicObject(1237, 1133.17, 1233.51, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[34] = CreateDynamicObject(1237, 1140.45, 1244.19, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[35] = CreateDynamicObject(1237, 1143.22, 1244.15, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[36] = CreateDynamicObject(1237, 1145.98, 1244.10, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[37] = CreateDynamicObject(1237, 1134.82, 1254.16, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[38] = CreateDynamicObject(1237, 1131.63, 1254.17, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[39] = CreateDynamicObject(1237, 1128.48, 1254.18, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[40] = CreateDynamicObject(1237, 1126.86, 1263.75, 9.74,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);

		PojazdPraktyka = CreateVehicle(604, 1137.0677, 1222.0414, 10.4574, 0.0000, -1, -1, 100);
		SetVehicleVirtualWorld(PojazdPraktyka, VW_PRAWKA);
		SetVehicleHealth(PojazdPraktyka, 1000.0);
		KoniecTrasy = CreateDynamicRaceCP(1, 1132.1947,1268.5957,10.5627, 0.0, 0.0, 0.0, 5, VW_PRAWKA, -1, -1, 200.0);
		iloscobiektow=41;

		ShowDialog(playerid, DIALOG_PRAWKO+5, DIALOG_STYLE_MSGBOX, "Prawo jazdy - praktyka (Trasa: 2/3)", "Je¿eli jesteœ gotowy wciœnij start by rozpocz¹æ.", "START", "");
		return 1;
	}
	if(typ==2)
	{
	    PrawkoDestroyObject();
		ObiektyPraktyka[0] = CreateDynamicObject(3578, 1109.15, 1280.26, 10.55,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[1] = CreateDynamicObject(3578, 1109.08, 1273.24, 10.55,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[2] = CreateDynamicObject(19425, 1113.88, 1278.46, 9.82,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[3] = CreateDynamicObject(19425, 1113.88, 1275.25, 9.82,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[4] = CreateDynamicObject(3578, 1106.62, 1276.93, 10.55,   0.00, 0.00, 90.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[5] = CreateDynamicObject(3578, 1113.28, 1265.73, 10.55,   0.00, 0.00, 60.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[6] = CreateDynamicObject(3578, 1117.69, 1263.18, 10.55,   0.00, 0.00, 60.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[7] = CreateDynamicObject(3578, 1114.57, 1263.30, 10.55,   0.00, 0.00, 150.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[8] = CreateDynamicObject(1237, 1114.72, 1273.19, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[9] = CreateDynamicObject(1237, 1116.19, 1270.62, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[10] = CreateDynamicObject(1237, 1114.80, 1280.03, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[11] = CreateDynamicObject(1237, 1120.51, 1268.07, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[11] = CreateDynamicObject(1237, 1117.09, 1272.01, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[12] = CreateDynamicObject(1237, 1118.03, 1274.28, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[13] = CreateDynamicObject(1237, 1119.34, 1275.81, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[14] = CreateDynamicObject(1237, 1120.42, 1277.67, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[15] = CreateDynamicObject(1237, 1121.40, 1279.38, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[16] = CreateDynamicObject(1237, 1122.35, 1281.08, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[17] = CreateDynamicObject(1237, 1123.30, 1282.80, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[18] = CreateDynamicObject(1237, 1116.07, 1280.48, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[19] = CreateDynamicObject(1237, 1117.06, 1282.11, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[20] = CreateDynamicObject(1237, 1118.11, 1283.96, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[21] = CreateDynamicObject(1237, 1119.26, 1285.79, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[22] = CreateDynamicObject(1237, 1121.38, 1269.68, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[23] = CreateDynamicObject(1237, 1122.38, 1271.31, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[24] = CreateDynamicObject(1237, 1123.51, 1273.34, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[25] = CreateDynamicObject(1237, 1124.63, 1275.25, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[26] = CreateDynamicObject(1237, 1125.59, 1277.09, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[27] = CreateDynamicObject(1237, 1126.60, 1278.99, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[28] = CreateDynamicObject(1237, 1127.65, 1281.01, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[29] = CreateDynamicObject(1237, 1120.33, 1287.01, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[30] = CreateDynamicObject(1237, 1121.77, 1287.49, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[31] = CreateDynamicObject(1237, 1128.36, 1283.06, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[32] = CreateDynamicObject(3578, 1124.75, 1292.42, 10.55,   0.00, 0.00, 60.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[33] = CreateDynamicObject(3578, 1131.47, 1288.28, 10.55,   0.00, 0.00, 60.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[34] = CreateDynamicObject(3578, 1128.81, 1292.41, 10.55,   0.00, 0.00, 150.00, VW_PRAWKA, -1, -1, 100.0);
		ObiektyPraktyka[35] = CreateDynamicObject(1237, 1116.51, 1273.34, 9.82,   0.00, 0.00, 0.00, VW_PRAWKA, -1, -1, 100.0);

		PojazdPraktyka = CreateVehicle(604, 1110.6206, 1276.8944, 10.5206, -90.0000, -1, -1, 100);
		SetVehicleVirtualWorld(PojazdPraktyka, VW_PRAWKA);
		SetVehicleHealth(PojazdPraktyka, 1000.0);
		KoniecTrasy = CreateDynamicRaceCP(1, 1116.4723,1266.4159,10.5622, 0.0, 0.0, 0.0, 5, VW_PRAWKA, -1, -1, 200.0);
		iloscobiektow=36;

		ShowDialog(playerid, DIALOG_PRAWKO+5, DIALOG_STYLE_MSGBOX, "Prawo jazdy - praktyka (Trasa: 3/3)", "Je¿eli jesteœ gotowy wciœnij start by rozpocz¹æ.", "START", "");
		return 1;
	}
	return 1;
}

stock PrawkoDestroyObject()
{
	if(iloscobiektow==-1)
	    return 1;
    for(new i=0; i<iloscobiektow+1; i++)
    {
        DestroyDynamicObject(ObiektyPraktyka[i]);
	}
	DestroyVehicle(PojazdPraktyka);
	DestroyDynamicRaceCP(KoniecTrasy);
	iloscobiektow=-1;
	PojazdPraktyka=-1;
	return 1;
}

stock PlayerSoundForPlayer(playerid, typ)
{
	new Float: Pos[3];
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	PlayerPlaySound(playerid, typ, Pos[0], Pos[1], Pos[2]);
	return 1;
}

CMD:pokaz(playerid, params[])
{
	new typ[64], player, Float: Pos[3];
	if(sscanf(params, "is[64]", player, typ))
	{
		ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "/pokaz", "U¿yj:\n/pokaz <id> (d)owod - pokazujesz dowód osobisty\n/pokaz <id> (p)rawko - pokazujesz prawo jazdy\n/pokaz <id> (r)ejestracja - pokazujesz dowód rejestracyjny pojazdu (w pojezdzie)", "Rozmumiem", "");
		return 1;
	}
    if(!strcmp(typ, "d", true) || !strcmp(typ, "dowod", true))
    {
        {
            if(!IsPlayerConnected(playerid))
                return 1;
            GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			if(!IsPlayerInRangeOfPoint(player, 10.0, Pos[0], Pos[1], Pos[2]))
			    return ShowInfo(playerid, "Ten gracz jest za daleko!");
            format(dstring, sizeof(dstring), "Gracz %s[%d] posiada dowód osobisty.", PlayerInfo[playerid][Name], playerid);
            ShowDialog(player, 0, DIALOG_STYLE_MSGBOX, "Dowód Osobisty", dstring, "Rozumiem", "");
            ShowInfo(playerid, "Pokaza³eœ dowód osobisty.");
		}
	}
	if(!strcmp(typ, "p", true) || !strcmp(typ, "prawko", true))
    {
        if(ZdanaTeoria(playerid)&&ZdanaPraktyka(playerid))
        {
            if(!IsPlayerConnected(playerid))
                return 1;
            GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			if(!IsPlayerInRangeOfPoint(player, 10.0, Pos[0], Pos[1], Pos[2]))
			    return ShowInfo(playerid, "Ten gracz jest za daleko!");
            format(dstring, sizeof(dstring), "Gracz %s[%d] posiada prawo jazdy.", PlayerInfo[playerid][Name], playerid);
            ShowDialog(player, 0, DIALOG_STYLE_MSGBOX, "Prawo Jazdy", dstring, "Rozumiem", "");
            ShowInfo(playerid, "Pokaza³eœ prawo jazdy.");
		}
		else
		{
		    ShowInfo(playerid, "Nie posiadasz prawa jazdy!");
		}
	}
	if(!strcmp(typ, "r", true) || !strcmp(typ, "rejestracja", true))
    {
        new pstate = GetPlayerState(playerid);
        if(pstate == PLAYER_STATE_DRIVER)
        {
            {
	            if(!IsPlayerConnected(playerid))
	                return 1;
	            GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
				if(!IsPlayerInRangeOfPoint(player, 10.0, Pos[0], Pos[1], Pos[2]))
				    return ShowInfo(playerid, "Ten gracz jest za daleko!");
	            format(dstring, sizeof(dstring), "Gracz %s[%d] posiada dowód rejestracyjny pojazdu\nw którym przebywa.", PlayerInfo[playerid][Name], playerid);
	            ShowDialog(player, 0, DIALOG_STYLE_MSGBOX, "Prawo Jazdy", dstring, "Rozumiem", "");
	            ShowInfo(playerid, "Pokaza³eœ dowód rejestracyjny.");
            }
		}
		else
		{
		    ShowInfo(playerid, "Musisz siedzieæ na miejscu kierowcy pojazdu!");
		}
	}
    return 1;
}

CMD:autor(playerid, params[])
{
	ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Autor mapy", "{FFFFFF}Mapê stworzy³: {C0C0C0}Inferno\n{FFFFFF}Kontakt:\n   {C0C0C0}Skype - inferno17031995\n   {C0C0C0}GG - 34773974", "Wyjdz", "");
	return 1;
}

stock CheckBan(playerid)
{
	new szQuery[255];
    format(szQuery, sizeof(szQuery), "SELECT `id`, `BannedName`, `BannedIP`, `TimeEnd`, `TimeNalozony`, `AdminName`, `Reason` FROM `sat_bans` WHERE `BannedIP`='%s'", PlayerIP[playerid]);
    mysql_query(szQuery);
    mysql_store_result();
	mysql_fetch_row_format(szQuery);

	if(!mysql_num_rows())
	{
		mysql_free_result();
		return 1;
	}

	sscanf(szQuery, "p<|>is[32]s[16]is[128]s[32]s[128]",
		BanInfo[playerid][id],
		BanInfo[playerid][BannedName],
		BanInfo[playerid][BannedIP],
		BanInfo[playerid][TimeEnd],
		BanInfo[playerid][TimeNalozony],
		BanInfo[playerid][AdminName],
		BanInfo[playerid][Reason]);

	if(BanInfo[playerid][TimeEnd] > gettime())
	{
	    ShowBanInfo(playerid, BanInfo[playerid][BannedName], BanInfo[playerid][BannedIP], BanInfo[playerid][AdminName], BanInfo[playerid][TimeNalozony], BanInfo[playerid][TimeEnd], BanInfo[playerid][Reason]);
	    Kick(playerid);
	    return 1;
	}
	if(BanInfo[playerid][TimeEnd] < gettime())
	{
	    format(szQuery, sizeof(szQuery), "DELETE FROM `sat_bans` WHERE `id`='%d'", BanInfo[playerid][id]);
		mysql_query(szQuery);
	}
	return 1;
}

stock GetTimeConver(Days, Hours, Minutes)
{
	new wynik;
	if(Days == 0 && Hours == 0 && Minutes == 0)
	{
	    wynik = 999999999999;
	    return wynik;
	}
	wynik = (Days * 86400) + (Hours * 3600) + (Minutes * 60) + gettime();
	return wynik;
}

CMD:ban(playerid, params[])
{
	if(!IsAdmin(playerid)) return 1;
	new gracz, czas[3], powod[128];
 	if(sscanf(params, "iiiis[128]", gracz, czas[0], czas[1], czas[2], powod))
  	{
   		ShowInfo(playerid, "Uzyj: /ban add <id gracza> <dni> <godziny> <minuty> <powód>");
	    return 1;
	}
	if(!IsPlayerConnected(gracz))
	{
		return ShowInfo(playerid, "Nie ma takiego gracza!");
	}
	if(czas[0] < 0 || czas[1] < 0 || czas[2] < 0)
	{
	    return ShowInfo(playerid, "Z³a wartoœæ d³ugoœci bana!");
	}
	BanPlayer(gracz, playerid, czas[0], czas[1], czas[2], powod);
	KaraTD("Ban", PlayerInfo[playerid][Name], PlayerInfo[gracz][Name], powod, 10, czas[0], czas[1], czas[2]);
	return 1;
}

stock BanPlayer(bannedid, adminid, dni, godziny, minuty, powod[])
{
	new szQuery[255];
	new BanName[MAX_PLAYER_NAME];
	GetPlayerName(bannedid, BanName, MAX_PLAYER_NAME);
	new AdmName[MAX_PLAYER_NAME];
	GetPlayerName(adminid, AdmName, MAX_PLAYER_NAME);
	new czasUNIX = GetTimeConver(dni, godziny, minuty);
	new datanalozenia[50];
	new Time[6];
	gettime(Time[3], Time[4], Time[5]);
	getdate(Time[0], Time[1], Time[2]);

	new CzasBan, Days, Hours, Minutes;
	CzasBan = czasUNIX - gettime();
	if (CzasBan >= 86400)
	{
		Days = CzasBan / 86400;
		CzasBan = CzasBan - (Days * 86400);
	}
	if (CzasBan >= 3600)
	{
		Hours = CzasBan / 3600;
		CzasBan = CzasBan - (Hours * 3600);
	}
	if (CzasBan >= 60)
	{
		Minutes = CzasBan / 60;
		CzasBan = CzasBan - (Minutes * 60);
	}
	format(datanalozenia, 50, "%d.%d.%d %d:%d", Time[2], Time[1], Time[0], Time[3], Time[4]);
	format(szQuery, sizeof(szQuery), "INSERT INTO `sat_bans` SET `BannedName`='%s', `BannedIP`='%s', `TimeEnd`='%d', `TimeNalozony`='%s', `AdminName`='%s', `Reason`='%s'",
	BanName, PlayerIP[bannedid], czasUNIX, datanalozenia, AdmName, powod);
	mysql_query(szQuery);
    ShowBanInfo(bannedid, BanName, PlayerIP[bannedid], AdmName, datanalozenia, czasUNIX, powod);
 	Kick(bannedid);

 	format(dstring, sizeof(dstring), "Zbanowa³eœ gracza %s[%d] na %d dni %d godzin i %d minut za %s.", BanName, bannedid, Days, Hours, Minutes, powod);
 	ShowInfo(adminid, dstring);
}


stock ShowBanInfo(playerid, BanNick[], BanIP[], AdminNick[], DataNalozenia[], DataZakonczenia, powod[])
{
	new CzasBan, Days, Hours, Minutes;
	CzasBan = DataZakonczenia - gettime();
	if (CzasBan >= 86400)
	{
		Days = CzasBan / 86400;
		CzasBan = CzasBan - (Days * 86400);
	}
	if (CzasBan >= 3600)
	{
		Hours = CzasBan / 3600;
		CzasBan = CzasBan - (Hours * 3600);
	}
	if (CzasBan >= 60)
	{
		Minutes = CzasBan / 60;
		CzasBan = CzasBan - (Minutes * 60);
	}



	format(dstring, sizeof(dstring), "~y~Twoj nick: ~w~%s~n~~y~Twoje IP: ~w~%s~n~~y~Admin: ~w~%s~n~~y~Data nalozenia: ~w~%s~n~~y~Koniec za: ~w~%d dni, %d godzin, %d minut",
	BanNick, BanIP, AdminNick, DataNalozenia, Days, Hours, Minutes);
	TextDrawSetString(BanTD[playerid][3], dstring);
	TextDrawSetString(BanTD[playerid][5], powod);

    TextDrawShowForPlayer(playerid, BanTD[playerid][0]);
    TextDrawShowForPlayer(playerid, BanTD[playerid][1]);
    TextDrawShowForPlayer(playerid, BanTD[playerid][2]);
    TextDrawShowForPlayer(playerid, BanTD[playerid][3]);
    TextDrawShowForPlayer(playerid, BanTD[playerid][4]);
    TextDrawShowForPlayer(playerid, BanTD[playerid][5]);
}

CMD:unban(playerid, params[])
{
	new szQuery[255];
    if(!IsAdmin(playerid, 2)) return 1;
    new func[128], Params[255];
	if(sscanf(params, "s[128]S()[255]", func, Params))
	{
		ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Informacje o komendzie unban", " /unban <ID/IP/Nick>\n\n /unban ID <id bana>\n/unban <IP> <zbanowane IP>\n/unban <Nick> <Nick zbanowanego gracza", "Rozumiem", "");
	    return 1;
	}
	else if(!strcmp(func, "id", true))
	{
        format(szQuery, sizeof(szQuery), "SELECT * FROM `sat_bans` WHERE `id`='%d'", strval(Params));
	    mysql_query(szQuery);
	    mysql_store_result();
		mysql_fetch_row_format(szQuery);

		if(!mysql_num_rows())
		{
		    ShowInfo(playerid, "Nie ma takiego bana!");
			mysql_free_result();
			return 1;
		}
		else
		{
		    format(szQuery, sizeof(szQuery), "DELETE FROM `sat_bans` WHERE `id`='%d'", strval(Params));
			mysql_query(szQuery);
		}
	}
	else if(!strcmp(func, "ip", true))
	{
        format(szQuery, sizeof(szQuery), "SELECT * FROM `sat_bans` WHERE `BannedIP`='%s'", Params);
	    mysql_query(szQuery);
	    mysql_store_result();
		mysql_fetch_row_format(szQuery);

		if(!mysql_num_rows())
		{
		    ShowInfo(playerid, "Nie ma takiego bana!");
			mysql_free_result();
			return 1;
		}
		else
		{
		    format(szQuery, sizeof(szQuery), "DELETE FROM `sat_bans` WHERE `BannedIP`='%s'", Params);
			mysql_query(szQuery);
		}
	}
	else if(!strcmp(func, "nick", true))
	{
        format(szQuery, sizeof(szQuery), "SELECT * FROM `sat_bans` WHERE `BannedName`='%s'", Params);
	    mysql_query(szQuery);
	    mysql_store_result();
		mysql_fetch_row_format(szQuery);

		if(!mysql_num_rows())
		{
		    ShowInfo(playerid, "Nie ma takiego bana!");
			mysql_free_result();
			return 1;
		}
		else
		{
		    format(szQuery, sizeof(szQuery), "DELETE FROM `sat_bans` WHERE `BannedName`='%s'", Params);
			mysql_query(szQuery);
		}
	}
	return 1;
}

CMD:scigany(playerid, params[])
{
    new szQuery[255];
	new func[128], Params[255];
	if(sscanf(params, "s[128]S()[255]", func, Params))
	{
		ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Informacje o /scigany", "U¿yj:\n   /scigany (a)dd <nick> <powod> - dodaje gracza do listy œciganych\n   /scigany (r)emove <nick> - usówa gracza z œciganych\n\n"C_RED"Listê œgiganych znajdziesz na www.Hard-Truck.pl/scigani.php", "Rozumiem", "");
	    return 1;
	}
	else if(!strcmp(func, "a", true) || !strcmp(func, "add", true))
	{
	    new sName[64], sPowod[255];
	    if(sscanf(Params, "s[64]s[255]", sName, sPowod))
	        return ShowInfo(playerid, "U¿yj: /scigany (a)dd <nick> <powod>");
		format(szQuery, 255, "SELECT * FROM `sat_scigani` WHERE `Nick`='%s' AND `Aktywne`='1'", sName);
		mysql_query(szQuery);
        mysql_query(szQuery);
	    mysql_store_result();
		mysql_fetch_row_format(szQuery);
		if(mysql_num_rows()!=0) return ShowInfo(playerid, "Ten gracz jest ju¿ na liœcie œciganych!");
		mysql_free_result();
		format(szQuery, 255, "INSERT INTO `sat_scigani` SET `Nick`='%s', `Powod`='%s', `Policjant`='%s'", sName, sPowod, PlayerInfo[playerid][Name]);
		mysql_query(szQuery);
		format(dstring, sizeof(dstring), "Doda³eœ gracza %s do listy œciganych.", sName);
		ShowInfo(playerid, dstring);
		format(dstring, sizeof(dstring), "Powód: %s", sPowod);
		ShowInfo(playerid, dstring);
		new player=GetPlayerID(sName);
		if(player != -1)
		{
			format(dstring, sizeof(dstring), "Policjant %s[%d] doda³ Ciê do listy œciganych graczy.", PlayerInfo[playerid][Name], playerid);
			ShowInfo(player, dstring);
			format(dstring, sizeof(dstring), "Powód: %s", sPowod);
			ShowInfo(player, dstring);
		}
	}
	else if(!strcmp(func, "r", true) || !strcmp(func, "remove", true))
	{
		format(szQuery, 255, "SELECT * FROM `sat_scigani` WHERE `Nick`='%s' AND `Aktywne`='1'", Params);
        mysql_query(szQuery);
        mysql_query(szQuery);
	    mysql_store_result();
		mysql_fetch_row_format(szQuery);
		if(mysql_num_rows()==0) return ShowInfo(playerid, "Ten gracz nie jest na liœcie œciganych!");
		mysql_free_result();
		format(szQuery, 255, "UPDATE `sat_scigani` SET `Aktywne`='0' WHERE `Nick`='%s'", Params);
		mysql_query(szQuery);
		
		format(dstring, sizeof(dstring), "Usun¹³eœ gracza %s z listy œciganych.", Params);
		ShowInfo(playerid, dstring);
		new player=GetPlayerID(Params);
		if(player != -1)
		{
			format(dstring, sizeof(dstring), "Policjant %s[%d] usun¹³ Ciê z listy œciganych graczy.", PlayerInfo[playerid][Name], playerid);
			ShowInfo(player, dstring);
		}
	}
	return 1;
}

stock LadujBramy()
{
	bramawojsko1 = CreateObject(972, 283.168579, 1954.083740, 9.262619, 0.0000, 0.0000, 0.0000);
	bramawojsko2 = CreateObject(972, 283.210114, 1986.850464, 16.637506, 0.0000, 0.0000, 0.0000);
	bramawojsko3 = CreateObject(972, 283.165558, 2021.283936, 16.637506, 0.0000, 0.0000, 0.0000);

	bramasg1 = CreateObject(988, 1744.851074, 525.779114, 27.700771, 0.0000, 0.0000, 342.6566);
	bramasg2 = CreateObject(988, 1739.233765, 538.232605, 27.108688, 0.0000, 0.0000, 162.6567);
	bramasg3 = CreateObject(988, -1613.499390, 608.492065, 41.339581, 0.0000, 0.0000, 135.8595);
	bramasg4 = CreateObject(988, -1599.446533, 608.462097, 41.675186, 0.0000, 0.0000, 316.7190);
	bramasg5 = CreateObject(988, -9.3000001907349, -1355.3000488281, 10.699999809265, 0, 0, 127.99624633789);
	bramasg6 = CreateObject(988, -2.4000000953674, -1371.5, 10.89999961853, 0, 0, 307.99072265625);

	bramalvlot = CreateObject(980,1705.69995117,1607.69995117,11.80000019,0.00000000,0.00000000,72.75000000);
	bramasflot = CreateObject(980,-1545.59997559,-430.70001221,2.09999990,0.00000000,0.00000000,134.74182129);
	bramalslot = CreateObject(980,1961.69995117,-2189.80004883,9.60000038,0.00000000,0.00000000,179.98901367);
}

	CMD:lslvc(playerid, cmdtext[])
 	{

 		MoveObject(bramasg1,1744.851074, 525.779114, 27.700771, 2); // otwarta brama
		return 1;
	}

	CMD:lslvo(playerid, cmdtext[])
 	{

		MoveObject(bramasg1,1750.087524, 524.137024, 27.699448, 2); // zamknieta brama
		return 1;
	}

	CMD:lvlsc(playerid, cmdtext[])
 	{

 		MoveObject(bramasg2,1739.233765, 538.232605, 27.108688, 2); // otwarta brama
		return 1;
	}

	CMD:lvlso(playerid, cmdtext[])
 	{

		MoveObject(bramasg2,1733.984131, 539.898804, 27.109276, 2); // zamknieta brama
		return 1;
	}

	CMD:lvsfc(playerid, cmdtext[])
 	{

 		MoveObject(bramasg3,-1613.499390, 608.492065, 41.339581, 2); // otwarta brama
		return 1;
	}

	CMD:lvsfo(playerid, cmdtext[])
 	{

		MoveObject(bramasg3,-1617.449707, 612.320068, 41.348686, 2); // zamknieta brama
		return 1;
	}

	CMD:sflvc(playerid, cmdtext[])
 	{

 		MoveObject(bramasg4,-1599.446533, 608.462097, 41.675186, 2); // otwarta brama
		return 1;
	}

	CMD:sflvo(playerid, cmdtext[]) 
 	{

		MoveObject(bramasg4,-1595.425049, 604.690002, 41.675514, 2); // zamknieta brama
		return 1;
	}

	CMD:lssfc(playerid, cmdtext[])
 	{

 		MoveObject(bramasg5,-5.9000000953674, -1359.5999755859, 10.699999809265, 2); // otwarta brama
		return 1;
	}

	CMD:lssfo(playerid, cmdtext[])
 	{

		MoveObject(bramasg5,-9.3000001907349, -1355.3000488281, 10.699999809265, 2); // zamknieta brama
		return 1;
	}

	CMD:sflsc(playerid, cmdtext[])
 	{

 		MoveObject(bramasg6,-5.6999998092651, -1367.1999511719, 10.800000190735, 2); // otwarta brama
		return 1;
	}

	CMD:sflso(playerid, cmdtext[])
 	{

		MoveObject(bramasg6,-2.4000000953674, -1371.5, 10.89999961853, 2); // zamknieta brama
		return 1;
	}

	CMD:lotlsc(playerid, cmdtext[])
 	{

 		GameTextForPlayer(playerid, "~n~lotnisko ls zamkniete", 2500, 5);
 		MoveObject(bramalslot,1961.69995117,-2189.80004883,15.30000019, 1);
		return 1;
	}

	CMD:lotlso(playerid, cmdtext[])
 	{

 		GameTextForPlayer(playerid, "~n~lotnisko ls otwarte", 2500, 5);
		MoveObject(bramalslot,1961.69995117,-2189.80004883,9.60000038, 1);
		return 1;
	}

	CMD:lotsfc(playerid, cmdtext[])
 	{

		GameTextForPlayer(playerid, "~n~lotnisko sf zamkniete", 2500, 5);
 		MoveObject(bramasflot,-1545.59997559,-430.70001221,7.80000019, 1);
		return 1;
	}

	CMD:lotsfo(playerid, cmdtext[])
 	{

		GameTextForPlayer(playerid, "~n~lotnisko sf otwarte", 2500, 5);
		MoveObject(bramasflot,-1545.59997559,-430.70001221,2.09999990, 1);
		return 1;
	}

	CMD:lotlvc(playerid, cmdtext[])
 	{

		GameTextForPlayer(playerid, "~n~lotnisko lv zamkniete", 2500, 5);
 		MoveObject(bramalvlot,1705.69995117,1607.69995117,11.80000019, 1);
		return 1;
	}

	CMD:lotlvo(playerid, cmdtext[])
 	{

		GameTextForPlayer(playerid, "~n~lotnisko lv otwarte", 2500, 5);
		MoveObject(bramalvlot,1705.69995117,1607.69995117,6.30000019, 1);
		return 1;
	}


	//Hangary wojskowe
	CMD:ho(playerid, cmdtext[])
 	{

 		GameTextForPlayer(playerid, "~n~Hangar 1 Otwarty", 2500, 5);
 		MoveObject(bramawojsko1,283.168579, 1954.083740, 9.262619, 3); // otwarta brama
		return 1;
	}

	CMD:hc(playerid, cmdtext[])
 	{

		GameTextForPlayer(playerid, "~n~Hangar 1 Zamkniety", 2500, 5);
		MoveObject(bramawojsko1,283.217224, 1954.071411, 16.637506, 3); // zamknieta brama
	    return 1;
	}

	CMD:h2o(playerid, cmdtext[])
 	{

 		GameTextForPlayer(playerid, "~n~Hangar 2 Otwarty", 2500, 5);
 		MoveObject(bramawojsko2,283.222626, 1986.878906, 9.262619, 3); // otwarta brama
		return 1;
	}

	CMD:h2c(playerid, cmdtext[])
 	{

 		GameTextForPlayer(playerid, "~n~Hangar 2 Zamkniety", 2500, 5);
 		MoveObject(bramawojsko2,283.210114, 1986.850464, 16.637506, 3); // zamknieta brama
		return 1;
	}

	CMD:h3o(playerid, cmdtext[])
 	{

 		GameTextForPlayer(playerid, "~n~Hangar 3 Otwarty", 2500, 5);
 		MoveObject(bramawojsko3,283.198822, 2021.273560, 9.212547, 3); // otwarta brama
		return 1;
	}

	CMD:h3c(playerid, cmdtext[])
 	{

 		GameTextForPlayer(playerid, "~n~Hangar 3 Zamkniety", 2500, 5);
 		MoveObject(bramawojsko3,283.165558, 2021.283936, 16.637506, 3); // zamknieta brama
		return 1;
	}


//KaraTD("Ban", PlayerInfo[playerid][Name], PlayerInfo[User][Name], Reason, 10);

forward UpdatePlayerPositions();
public UpdatePlayerPositions()
{
	new query[256],username[32],Float:x,Float:y,Float:z,score,vehicle,ghealth;
	for(new i = 0;i<MAX_PLAYERS;i++)
	{
		if(IsPlayerConnected(i))
		{
			//getting data [username]
			GetPlayerName(i,username,sizeof username);
		    mysql_real_escape_string(username,username);
		    //getting data [location]
		    GetPlayerPos(i,x,y,z);
		    //getting data [score]
		    score = GetPlayerScore(i);
		    //getting data [vehicle]
		    if(IsPlayerInAnyVehicle(i))
		    {
		        vehicle = GetVehicleModel(GetPlayerVehicleID(i));
		    } else vehicle = 0;
		    //getting data [health]
		    new Float:hp;
			GetPlayerHealth(i,hp);
		    ghealth = floatround(hp);

		    format(query,sizeof query,"UPDATE `sat_gpos` SET `playerid` = %i, `score` = %i, `coordinates` = '%f:%f:%f',`vehicle` = %i,`health` = %i WHERE `username` = '%s'",i,score,x,y,z,vehicle,ghealth,username);
		    mysql_query(query);
		}
	}
	return 1;
}

CMD:taryfikator(playerid, params[])
{
	new tar[1200];
	strcat(tar, "{FF0000}Uszkodzony pojazd\t\t\t\t\t\t{00FFFF}100 - 300 $\n");
	strcat(tar, "{FF0000}Jazda ze zgaszonymi œwiat³ami noc¹\t\t\t{00FFFF}200 - 400 $\n");
	strcat(tar, "{FF0000}Parkowanie w niedozwolonym miejscu\t\t\t{00FFFF}100 $\n");
	strcat(tar, "{FF0000}Jazda na czerwonym œwietle\t\t\t\t\t{00FFFF}300 - 800 $\n");
	strcat(tar, "{FF0000}Jazda pod pr¹d\t\t\t\t\t\t{00FFFF}300 - 1000 $\n");
	strcat(tar, "{FF0000}Jazda po torach\t\t\t\t\t\t{00FFFF}200 - 500 $\n");
	strcat(tar, "{FF0000}Jazda po bezdro¿ach\t\t\t\t\t\t{00FFFF}300 - 1000 $\n");
	strcat(tar, "{FF0000}Zawracanie w niedozwolonym miejscu\t\t\t{00FFFF}100 - 700 $\n");
	strcat(tar, "{FF0000}Prze³adowana naczepa\t\t\t\t\t{00FFFF}2500 $\n");
	strcat(tar, "{FF0000}Ucieczka przed policj¹\t\t\t\t\t{00FFFF}3000 - 5000 $\n");
	strcat(tar, "{FF0000}Spowodowanie wypadku\t\t\t\t\t{00FFFF}500 - 1500 $\n");
	strcat(tar, "{FF0000}Jazda pod wp³ywem alkoholu\t\t\t\t{00FFFF}400 $\n");
	strcat(tar, "{FF0000}Przekroczenie prêdkoœci o 10-20 km/h\t\t\t{00FFFF}300 $\n");
	strcat(tar, "{FF0000}Przekroczenie prêdkoœci o 21-30 km/h\t\t\t{00FFFF}400 - 600 $\n");
	strcat(tar, "{FF0000}Przekroczenie prêdkoœci o 31-40 km/h\t\t\t{00FFFF}700 - 900 $\n");
	strcat(tar, "{FF0000}Przekroczenie prêdkoœci o 41-49 km/h\t\t\t{00FFFF}1000 - 1200 $\n");
	strcat(tar, "{FF0000}Przekroczenie prêdkoœci o 50 km/h i wiêcej\t\t{00FFFF}1500 $\n");
	ShowDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Taryfikator", tar, "WyjdŸ", "");
	return 1;
}
