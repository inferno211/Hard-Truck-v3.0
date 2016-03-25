/*

CREATE TABLE IF NOT EXISTS `sat_bans` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `BannedName` varchar(255) NOT NULL,
  `BannedIP` varchar(255) NOT NULL,
  `TimeEnd` int(255) NOT NULL,
  `TimeNalozony` varchar(255) NOT NULL,
  `AdminName` varchar(255) NOT NULL,
  `Reason` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
);

*/

#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <a_mysql>

#define Sloty 60

#define MYSQL_HOST "hardtruck.xaa.pl"
#define MYSQL_USER "hardtruc_baza"
#define MYSQL_PASS "Inferno211"
#define MYSQL_DB   "hardtruc_baza"

#define MAX_PLAYER_IP 16
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
new szQuery[255];
new Text: BanTD[Sloty][6];
new dstring[256];

public OnFilterScriptInit()
{
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
	
	for(new i=0; i<Sloty; i++)
	{
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
	return 1;
}


stock ShowInfo(playerid, String[])
{
	format(dstring, sizeof(dstring), "{ADFF2F}Hard Truck: {C0C0C0}%s", String);
	SendClientMessage(playerid, 0xFFFFFF, dstring);
	return 1;
}

public OnPlayerConnect(playerid)
{
	GetPlayerIp(playerid, PlayerIP[playerid], MAX_PLAYER_IP);
	CheckBan(playerid);
	return 1;
}

stock CheckBan(playerid)
{
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
	return 1;
}

stock BanPlayer(bannedid, adminid, dni, godziny, minuty, powod[])
{
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
    new func[128], Params[255];
	if(sscanf(params, "s[128]S()[255]", func, Params))
	{
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Informacje o komendzie unban", " /unban <ID/IP/Nick>\n\n /unban ID <id bana>\n/unban <IP> <zbanowane IP>\n/unban <Nick> <Nick zbanowanego gracza", "Rozumiem", "");
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
