new
	sa_weathers[] = {0,1},
	sa_weather,
	last_weather_update;

#define UPDATE_WEATHER_SECONDS 10800 //cada 3 horas

public OnMyWorldTimeUpdate()
{
	if(gettime() > last_weather_update + UPDATE_WEATHER_SECONDS)
	{
		sa_weather = sa_weathers[random(sizeof(sa_weathers))];
		for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
		{
			if(IsPlayerConnected(i) && PLAYER_TEMP[i][pt_GAME_STATE] > GAME_STATE_CONNECTED)
			{
				InterpolatePlayerWeather(i, sa_weather);
			}
		}
		last_weather_update = gettime();
	}
	new td_str[16]; format(td_str, sizeof td_str, "%02d:%02d", GetMyWorldHour(), GetMyWorldMinute());

	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		PlayerTextDrawSetString(i, PlayerTextdraws[i][ptextdraw_SERVER_TIME], td_str);
		TextDrawSetString(Textdraws[textdraw_iPhone][2], td_str);
		TextDrawSetString(Textdraws[textdraw_iPhone][3], td_str);
	}
	return 1;
}

SetPlayerCityWeather(playerid)
{
	SetPlayerMyTime(playerid, -1, -1); //volver a la hora del servidor
	SetPlayerMyWeather(playerid, sa_weather);
	return 1;
}
