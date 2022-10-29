#include <YSI-Includes\YSI\y_hooks>

CMD:mp3(playerid, params[])
{
	if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_JAIL || PI[playerid][pi_STATE] == ROLEPLAY_STATE_ARRESTED) return SendErrorNotification(playerid, "Ahora no puedes usar este comando.");
	if(!PI[playerid][pi_PHONE_NUMBER]) return SendErrorNotification(playerid, "No puedes escuchar música sin ningun télefono.");
	if(PI[playerid][pi_PHONE_STATE] == PHONE_STATE_OFF) return SendFormatNotification(playerid, "Tu teléfono está apagado, para encenderlo usa /movil.");
	if(!PI[playerid][pi_MP3]) return SendErrorNotification(playerid, "No tienes audifonos, puedes ir a cualquier 24/7 para comprar uno.");

	PLAYER_TEMP[playerid][pt_MUSIC_FOR_PROPERTY] = false;
	PLAYER_TEMP[playerid][pt_MUSIC_FOR_VEHICLE] = false;
	PLAYER_TEMP[playerid][pt_MUSIC_FOR_SPEAKERS] = false;
	Auto_SendPlayerAction(playerid, "busca música en su iPhone.");
	ShowDialog(playerid, DIALOG_PLAYER_MP3);
	return 1;
}

/*CMD:amp3(playerid, params[])
{
	if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_JAIL || PI[playerid][pi_STATE] == ROLEPLAY_STATE_ARRESTED) return SendErrorNotification(playerid, "Ahora no puedes usar este comando.");
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendErrorNotification(playerid, "No estás depie.");
	if(!PI[playerid][pi_SPEAKERS]) return SendErrorNotification(playerid, "No tienes altavoces, puedes ir a cualquier 24/7 para comprarlos.");

	if(gettime() < PLAYER_TEMP[playerid][pt_SPEAKERS_TIME] + 120) return SendFormatNotification(playerid, "Tienes que esperar %s minutos para volver a utilizar los altavoces.", TimeConvert((120-(gettime()-PLAYER_TEMP[playerid][pt_SPEAKERS_TIME]))));

	PLAYER_TEMP[playerid][pt_MUSIC_FOR_SPEAKERS] = true;
	ShowDialog(playerid, DIALOG_PLAYER_MP3);
	return 1;
}*/

CMD:emisora(playerid, params[])
{
	if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_JAIL || PI[playerid][pi_STATE] == ROLEPLAY_STATE_ARRESTED) return SendErrorNotification(playerid, "Ahora no puedes usar este comando.");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendErrorNotification(playerid, "No conduces ningún vehículo.");
	if(!PI[playerid][pi_MP3]) return SendErrorNotification(playerid, "No tienes ningún MP3, puedes ir a cualquier 24/7 para comprar uno.");

	PLAYER_TEMP[playerid][pt_MUSIC_FOR_VEHICLE] = true;
	ShowDialog(playerid, DIALOG_PLAYER_MP3);
	return 1;
}
alias:emisora("emisoras");

PlayMP3(playerid, id)
{
	new url[128], song_name[24];
	format(url, sizeof url, ListEmisoras[id][emisora_URL]);
	format(song_name, sizeof song_name, ListEmisoras[id][emisora_NAME]);

	if(PLAYER_TEMP[playerid][pt_MUSIC_FOR_PROPERTY])
	{
		for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
		{
			if(IsPlayerConnected(i))
			{
				if((PI[i][pi_STATE] == ROLEPLAY_STATE_OWN_PROPERTY || PI[i][pi_STATE] == ROLEPLAY_STATE_GUEST_PROPERTY) && PI[i][pi_LOCAL_INTERIOR] == PI[playerid][pi_LOCAL_INTERIOR])
				{
					PlayAudioStreamForPlayerEx(i, url);
					SendFormatNotification(i, "~b~Reproduciendo '%s'~n~~n~~w~Utiliza ~r~/stop ~w~para parar la música.", song_name);
				}
			}
		}
		PLAYER_TEMP[playerid][pt_MUSIC_FOR_PROPERTY] = false;
		Auto_SendPlayerAction(playerid, "pone música en su propiedad.");
	}
	else if(PLAYER_TEMP[playerid][pt_MUSIC_FOR_VEHICLE])
	{
		for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(IsPlayerInAnyVehicle(i))
				{
					if(GetPlayerVehicleID(playerid) == GetPlayerVehicleID(i))
					{
						PlayAudioStreamForPlayerEx(i, url);
						SendFormatNotification(i, "~b~Reproduciendo '%s'~n~~n~~w~Utiliza ~r~/stop ~w~para parar la música.", song_name);
					}
				}
			}
		}
		PLAYER_TEMP[playerid][pt_MUSIC_FOR_VEHICLE] = false;
		GLOBAL_VEHICLES[ GetPlayerVehicleID(playerid) ][gb_vehicle_EMISORA_ID] = id;
		if(PLAYER_VEHICLES[ GetPlayerVehicleID(playerid) ][player_vehicle_OWNER_ID] == PI[playerid][pi_ID]) Auto_SendPlayerAction(playerid, "pone música en su vehículo.");
		else Auto_SendPlayerAction(playerid, "pone música en el vehículo.");
	}
	else if(PLAYER_TEMP[playerid][pt_MUSIC_FOR_SPEAKERS])
	{
		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

		for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
		{
			if(IsPlayerConnected(i))
			{
				if((PLAYER_TEMP[i][pt_GAME_STATE] == GAME_STATE_NORMAL || PLAYER_TEMP[i][pt_GAME_STATE] == GAME_STATE_DEAD) && PI[i][pi_CONFIG_AUDIO])
				{
					if(GetPlayerDistanceFromPoint(i, pos[0], pos[1], pos[2]) <= 30.0)
					{
						PlayAudioStreamForPlayerEx(i, url, pos[0], pos[1], pos[2], 50.0, true);
						SendClientMessageEx(i, 0xf796bdFF, "* Se escuchan unos altavoces...");
					}
				}
			}
		}
		PLAYER_TEMP[playerid][pt_SPEAKERS_TIME] = gettime();
		PLAYER_TEMP[playerid][pt_MUSIC_FOR_SPEAKERS] = false;
		Auto_SendPlayerAction(playerid, "pone música de su iPhone en los altavoces.");
	}
	else
	{
		PLAYER_TEMP[playerid][pt_MUSIC_PLAYER] = id;
		PlayAudioStreamForPlayerEx(playerid, url);
		SendFormatNotification(playerid, "Reproduciendo ~g~'%s' ~w~usa ~g~/stop ~w~para parar la música.", song_name);
		Auto_SendPlayerAction(playerid, "escucha música de su iPhone en sus auriculares.");
	}
	return 1;
}
StopMP3(playerid)
{
	if(PLAYER_TEMP[playerid][pt_MUSIC_FOR_PROPERTY])
	{
		for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
		{
			if(IsPlayerConnected(i))
			{
				if((PI[i][pi_STATE] == ROLEPLAY_STATE_OWN_PROPERTY || PI[i][pi_STATE] == ROLEPLAY_STATE_GUEST_PROPERTY) && PI[i][pi_LOCAL_INTERIOR] == PI[playerid][pi_LOCAL_INTERIOR])
				{
					StopAudioStreamForPlayer(i);
				}
			}
		}
		PLAYER_TEMP[playerid][pt_MUSIC_FOR_PROPERTY] = false;
		Auto_SendPlayerAction(playerid, "apaga la música de la propiedad.");
	}
	else if(PLAYER_TEMP[playerid][pt_MUSIC_FOR_VEHICLE])
	{
		for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(IsPlayerInAnyVehicle(i))
				{
					if(GetPlayerVehicleID(playerid) == GetPlayerVehicleID(i))
					{
						StopAudioStreamForPlayer(i);
					}
				}
			}
		}
		PLAYER_TEMP[playerid][pt_MUSIC_FOR_VEHICLE] = false;
		if(PLAYER_VEHICLES[ GetPlayerVehicleID(playerid) ][player_vehicle_OWNER_ID] == PI[playerid][pi_ID]) Auto_SendPlayerAction(playerid, "apaga la emisora de su vehículo.");
		else Auto_SendPlayerAction(playerid, "apaga la emisora del vehículo.");
	}
	else if(PLAYER_TEMP[playerid][pt_MUSIC_FOR_SPEAKERS])
	{
		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

		for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
		{
			if(IsPlayerConnected(i))
			{
				if((PLAYER_TEMP[i][pt_GAME_STATE] == GAME_STATE_NORMAL || PLAYER_TEMP[i][pt_GAME_STATE] == GAME_STATE_DEAD) && PI[i][pi_CONFIG_AUDIO])
				{
					if(GetPlayerDistanceFromPoint(i, pos[0], pos[1], pos[2]) <= 30.0)
					{
						StopAudioStreamForPlayer(i);
					}
				}
			}
		}
		PLAYER_TEMP[playerid][pt_MUSIC_FOR_SPEAKERS] = false;
		Auto_SendPlayerAction(playerid, "apaga la música de los altavoces.");
	}
	else
	{
		if(!PLAYER_TEMP[playerid][pt_MUSIC_PLAYER]) return 1;
		StopAudioStreamForPlayer(playerid);
		Auto_SendPlayerAction(playerid, "apaga la música de su iPhone en sus auriculares.");
	}
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(!PLAYER_TEMP[playerid][pt_MUSIC_PLAYER])
	{
		if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_EMISORA_ID] != 0)
			{
				PlayAudioStreamForPlayerEx(playerid, ListEmisoras[ GLOBAL_VEHICLES[vehicleid][gb_vehicle_EMISORA_ID] ][emisora_URL]);
			}
		}
		else if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
		{
			if(GLOBAL_VEHICLES[ PLAYER_TEMP[playerid][pt_LAST_VEHICLE_ID] ][gb_vehicle_EMISORA_ID] != 0) StopAudioStreamForPlayer(playerid);
		}
	}
}