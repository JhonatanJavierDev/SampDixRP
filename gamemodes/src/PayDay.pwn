#define	Segundos(%0) 	(1000 * %0)
#define Minutos(%0) 	(1000 * %0 * 60)
#define	Horas(%0) 		(1000 * %0 * 60 * 60)

/*forward PayDayAll();
public PayDayAll()
{
	if(PayDayActivo)
	{
		for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
		{
			if(IsPlayerConnected(i) && PLAYER_TEMP[i][pt_USER_LOGGED])
			{
				PlayerPayday(i);
				GameTextForPlayer(i, "~g~¡LLUVIA DE PAYDAY!", Segundos(1), 3);
			}
		}
	}
	return 1;
}*/

	PayDayActivo = false,
	ForcePayday,

CMD:paydayall(playerid, params[])
{
	if(PayDayActivo) 
	{
		PayDayActivo = false;
		KillTimer(ForcePayday);
	}
	else
	{
		ForcePayday = SetTimerEx("PayDayAll", Segundos(1), true);
		PayDayActivo = true;
		SendCmdLogToAdmins(playerid, "paydayall", params);
	}
	return 1;
}