#if defined _inc_interpolate_weather
	#endinput
#endif
#define _inc_interpolate_weather

#include <YSI-Includes\YSI\y_hooks>

#define WEATHER_INTERPOLATION_SECONDS 60 //segundos que toma a GTA:SA interpolar de un clima a otro

new 
	worldtime_Timer_Interval = 1000, //si no se usa SetWorldMinutesForDay sera cada 1 segundo
	world_Hour = 12, world_Minute, world_Weather,
	pHour[MAX_PLAYERS], pMinute[MAX_PLAYERS], pWeather_ID[MAX_PLAYERS],
	pWeather_Changed_Counter[MAX_PLAYERS];

#define GetMyWorldHour() world_Hour
#define GetMyWorldMinute() world_Minute
#define GetMyWorldWeather() world_Weather
#define GetMyWorldPlayerWeather(%0) pWeather_ID[%0]

forward OnMyWorldTimeUpdate();

hook OnPlayerConnect(playerid)
{
	pWeather_Changed_Counter[playerid] = 0;
	pHour[playerid] = -1;
	pMinute[playerid] = -1;
	pWeather_ID[playerid] = world_Weather;
	
	TogglePlayerClock(playerid, true); //necesario para que el clima interpole
	SetPlayerTime(playerid, world_Hour, world_Minute);
	SetPlayerWeather(playerid, pWeather_ID[playerid]);
	return 1;
}

hook OnPlayerSpawn(playerid)
{
	pWeather_Changed_Counter[playerid] = 0;
	if(pHour[playerid] == -1 && pMinute[playerid] == -1) SetPlayerTime(playerid, world_Hour, world_Minute);
	else SetPlayerTime(playerid, pHour[playerid], pMinute[playerid]);
	SetPlayerWeather(playerid, pWeather_ID[playerid]);
	return 1;
}

ptask PlayerWorldTimeTimer[1000](playerid)
{
	if(!pWeather_Changed_Counter[playerid]) {
		if(pHour[playerid] == -1 && pMinute[playerid] == -1) SetPlayerTime(playerid, world_Hour, world_Minute);
		else SetPlayerTime(playerid, pHour[playerid], pMinute[playerid]);
	}
	else pWeather_Changed_Counter[playerid] --;
}

task WorldTimeTimer[worldtime_Timer_Interval]()
{
	world_Minute ++;
	if(world_Minute >= 60)
	{
		world_Hour ++;
		world_Minute = 0;

		if(world_Hour >= 24) world_Hour = 0;
	}
	CallRemoteFunction("OnMyWorldTimeUpdate", "");
}

stock InterpolateWeather(weatherid)
{
	world_Weather = weatherid;

	new near_Hour = world_Hour;
	if(world_Minute > 30)
	{
		near_Hour ++;
		if(near_Hour >= 24) near_Hour = 0;
	}

	foreach(new i : Player)
	{
		if(pHour[i] == -1 && pMinute[i] == -1) {
			pWeather_Changed_Counter[i] = WEATHER_INTERPOLATION_SECONDS - 15; // - 15 porque los timers de samp son una mierda
			pWeather_ID[i] = world_Weather;

			SetPlayerTime(i, near_Hour, 0); //necesario porque empieza a interpolar en el minuto 0
			SetPlayerWeather(i, pWeather_ID[i]);
		}
	}
	return 1;
}

stock InterpolatePlayerWeather(playerid, weatherid)
{
	new near_Hour;
	if(pHour[playerid] == -1 && pMinute[playerid] == -1) near_Hour = world_Hour;
	else near_Hour = pHour[playerid];

	if(world_Minute > 30)
	{
		near_Hour ++;
		if(near_Hour >= 24) near_Hour = 0;
	}

	pWeather_Changed_Counter[playerid] = WEATHER_INTERPOLATION_SECONDS - 15; // - 15 porque los timers de samp son una mierda
	pWeather_ID[playerid] = weatherid;

	SetPlayerTime(playerid, near_Hour, 0); //necesario porque empieza a interpolar en el minuto 0
	SetPlayerWeather(playerid, pWeather_ID[playerid]);
	return 1;
}

stock SetPlayerMyWeather(playerid, weatherid)
{
	pWeather_ID[playerid] = weatherid;
	SetPlayerWeather(playerid, weatherid);
	if(pHour[playerid] == -1 && pMinute[playerid] == -1) SetPlayerTime(playerid, world_Hour, world_Minute);
	else SetPlayerTime(playerid, pHour[playerid], pMinute[playerid]);
	return 1;
}

stock SetPlayerMyTime(playerid, hour, minute)
{
	pHour[playerid] = hour;
	pMinute[playerid] = minute;

	SetPlayerWeather(playerid, pWeather_ID[playerid]);
	if(pHour[playerid] == -1 && pMinute[playerid] == -1) SetPlayerTime(playerid, world_Hour, world_Minute);
	else SetPlayerTime(playerid, pHour[playerid], pMinute[playerid]);
	return 1;
}

stock SetMyWorldTime(hour, minute)
{
	world_Hour = hour;
	world_Minute = minute;

	if(world_Hour < 0) world_Hour = 23;
	else if(world_Hour > 23) world_Hour = 0;

	if(world_Minute < 0) world_Minute = 59;
	else if(world_Minute > 59) world_Minute = 0;
	return 1;
}

stock SetWorldMinutesForDay(minutes_for_day) // minutes_for_day = minutos REALES para que pasen 24 Horas del juego
{
	worldtime_Timer_Interval = floatround(floatmul(float(minutes_for_day), floatdiv(125, 3)));
	return worldtime_Timer_Interval;
}