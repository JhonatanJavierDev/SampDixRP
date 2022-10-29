#include <YSI-Includes\YSI\y_hooks>

new
    pLastFuelSubtraction[MAX_PLAYERS],
	bool:pSpeedoShown[MAX_PLAYERS],
    pSpeedoTimer[MAX_PLAYERS] = {-1, ...};

hook OnPlayerDisconnect(playerid, reason)
{
	pSpeedoShown[playerid] = false;
    pLastFuelSubtraction[playerid] = 0;
    if(pSpeedoTimer[playerid] != -1)
	{
	    KillTimer(pSpeedoTimer[playerid]);
        pSpeedoTimer[playerid] = -1;
    }
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
	{
        new vehicleid = GetPlayerVehicleID(playerid);
        if(VEHICLE_INFO[GetVehicleModel(vehicleid) - 400][vehicle_info_NORMAL_SPEEDO] && !PLAYER_TEMP[playerid][pt_IN_TUNING_GARAGE]) ShowPlayerSpeedoMeter(playerid);
    }
    else if(oldstate == PLAYER_STATE_DRIVER)
	{
        HidePlayerSpeedoMeter(playerid);
    }
}

ShowPlayerSpeedoMeter(playerid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
	new vehicleid = GetPlayerVehicleID(playerid), modelid = GetVehicleModel(vehicleid);
	if(!VEHICLE_INFO[modelid - 400][vehicle_info_NORMAL_SPEEDO]) return 0;
    if(pSpeedoTimer[playerid] != -1)
	{
	    KillTimer(pSpeedoTimer[playerid]);
        pSpeedoTimer[playerid] = -1;
    }

	new td_str[64];
	if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_PARAMS_ENGINE]) { format(td_str, 64, "~g~~h~Motor"); PlayerTextDrawSetString(playerid, PlayerTextdraws[playerid][pSpeedoTd][5], td_str); }
	else { format(td_str, 64, "~r~Motor"); PlayerTextDrawSetString(playerid, PlayerTextdraws[playerid][pSpeedoTd][5], td_str); }

	if(!GLOBAL_VEHICLES[vehicleid][gb_vehicle_PARAMS_DOORS]) { format(td_str, 64, "~g~~h~Abierto"); PlayerTextDrawSetString(playerid, PlayerTextdraws[playerid][pSpeedoTd][6], td_str); }
	else { format(td_str, 64, "~r~Cerrado"); PlayerTextDrawSetString(playerid, PlayerTextdraws[playerid][pSpeedoTd][6], td_str); }

	if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_PARAMS_LIGHTS]) { format(td_str, 64, "~g~~h~Luces"); PlayerTextDrawSetString(playerid, PlayerTextdraws[playerid][pSpeedoTd][7], td_str); }
	else { format(td_str, 64, "~r~Luces"); PlayerTextDrawSetString(playerid, PlayerTextdraws[playerid][pSpeedoTd][7], td_str); }

	if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_COLOR_1] >= 0 || GLOBAL_VEHICLES[vehicleid][gb_vehicle_COLOR_1] <= 255)
	{
		new r, g, b, a;
		HexToRGBA(VEHICLE_COLORS[ GLOBAL_VEHICLES[vehicleid][gb_vehicle_COLOR_1] ], r, g, b, a);

		PlayerTextDrawBoxColor(playerid, PlayerTextdraws[playerid][pSpeedoTd][0], RGBAToHex(r, g, b, 50));
		PlayerTextDrawBoxColor(playerid, PlayerTextdraws[playerid][pSpeedoTd][4], RGBAToHex(r, g, b, 50));

		PlayerTextDrawSetPreviewModel(playerid, PlayerTextdraws[playerid][pSpeedoTd][1], modelid);
    	PlayerTextDrawSetPreviewVehCol(playerid, PlayerTextdraws[playerid][pSpeedoTd][1], GLOBAL_VEHICLES[vehicleid][gb_vehicle_COLOR_1], GLOBAL_VEHICLES[vehicleid][gb_vehicle_COLOR_2]);
	}

	format(td_str, sizeof td_str, "%.1f_Litros", GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS]);
	PlayerTextDrawSetString(playerid, PlayerTextdraws[playerid][pSpeedoTd][2], td_str);

	PlayerTextDrawSetString(playerid, PlayerTextdraws[playerid][pSpeedoTd][3], "_0_KM/H");
	if(PLAYER_TEMP[playerid][pt_Plataforma]) PlayerTextDrawSetString(playerid, PlayerTextdraws[playerid][pSpeedoTd][4], "_____IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
	else PlayerTextDrawSetString(playerid, PlayerTextdraws[playerid][pSpeedoTd][4], "_IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");

	if(!IsInventoryOpened(playerid))
	{
		for(new i = 0; i < 8; i ++) 
		{
			PlayerTextDrawShow(playerid, PlayerTextdraws[playerid][pSpeedoTd][i]);
			if(!PLAYER_VEHICLES[vehicleid][player_vehicle_VALID]) PlayerTextDrawHide(playerid, PlayerTextdraws[playerid][pSpeedoTd][6]);
		}
		pSpeedoShown[playerid] = true;
	}
	else pSpeedoShown[playerid] = false;

	pLastFuelSubtraction[playerid] = gettime();
	pSpeedoTimer[playerid] = SetTimerEx("UpdatePlayerSpeedo", 250, true, "iif", playerid, vehicleid, VEHICLE_INFO[modelid - 400][vehicle_info_MAX_VEL]);
	return 1;
}

HidePlayerSpeedoMeter(playerid)
{
    pLastFuelSubtraction[playerid] = 0;
	pSpeedoShown[playerid] = false;
	if(pSpeedoTimer[playerid] != -1) 
	{
	    KillTimer(pSpeedoTimer[playerid]);
        pSpeedoTimer[playerid] = -1;
    }
	for(new i = 0; i < 8; i ++) 
	{
        PlayerTextDrawHide(playerid, PlayerTextdraws[playerid][pSpeedoTd][i]);
    }
	return 1;
}

forward UpdatePlayerSpeedo(playerid, vehicleid, Float:maxvel);
public UpdatePlayerSpeedo(playerid, vehicleid, Float:maxvel)
{
	if(!IsInventoryOpened(playerid) && !pSpeedoShown[playerid]) 
	{
		for(new i = 0; i < 8; i ++) 
		{
			PlayerTextDrawShow(playerid, PlayerTextdraws[playerid][pSpeedoTd][i]);
		}
		pSpeedoShown[playerid] = true;
	}
	else if(IsInventoryOpened(playerid) && pSpeedoShown[playerid]) 
	{
		for(new i = 0; i < 8; i ++) 
		{
			PlayerTextDrawHide(playerid, PlayerTextdraws[playerid][pSpeedoTd][i]);
		}
		pSpeedoShown[playerid] = false;
	}

	if(vehicleid != GetPlayerVehicleID(playerid))
	{
		HidePlayerSpeedoMeter(playerid);
		ShowPlayerSpeedoMeter(playerid);
		
		GLOBAL_VEHICLES[vehicleid][gb_vehicle_DRIVER] = INVALID_PLAYER_ID;
		GLOBAL_VEHICLES[vehicleid][gb_vehicle_LAST_DRIVER] = playerid;
		GLOBAL_VEHICLES[vehicleid][gb_vehicle_OCCUPIED] = false;
		PLAYER_TEMP[playerid][pt_LAST_VEHICLE_ID] = GetPlayerVehicleID(playerid);
		GLOBAL_VEHICLES[ PLAYER_TEMP[playerid][pt_LAST_VEHICLE_ID] ][gb_vehicle_OCCUPIED] = true;
		return 0;
	}
	
	new Float:vel = GetVehicleSpeed(vehicleid);
	
	if(ac_Info[CHEAT_VEHICLE_SPEED_HACK][ac_Enabled])
	{
		if(gettime() > PLAYER_AC_INFO[playerid][CHEAT_VEHICLE_SPEED_HACK][p_ac_info_IMMUNITY])
		{
			if(vel > maxvel + 100.0)
			{
				if(!ac_Info[CHEAT_VEHICLE_SPEED_HACK][ac_Interval]) OnPlayerCheatDetected(playerid, CHEAT_VEHICLE_SPEED_HACK);
				else
				{
					if(gettime() - PLAYER_AC_INFO[playerid][CHEAT_VEHICLE_SPEED_HACK][p_ac_info_LAST_DETECTION] > ac_Info[CHEAT_VEHICLE_SPEED_HACK][ac_Interval]) PLAYER_AC_INFO[playerid][CHEAT_VEHICLE_SPEED_HACK][p_ac_info_DETECTIONS] = 0;
					else PLAYER_AC_INFO[playerid][CHEAT_VEHICLE_SPEED_HACK][p_ac_info_DETECTIONS] ++;
					
					PLAYER_AC_INFO[playerid][CHEAT_VEHICLE_SPEED_HACK][p_ac_info_LAST_DETECTION] = gettime();
					if(PLAYER_AC_INFO[playerid][CHEAT_VEHICLE_SPEED_HACK][p_ac_info_DETECTIONS] >= ac_Info[CHEAT_VEHICLE_SPEED_HACK][ac_Detections]) OnPlayerCheatDetected(playerid, CHEAT_VEHICLE_SPEED_HACK);
				}
			}
		}
	}
	
	if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_STATE] == VEHICLE_STATE_NORMAL)
	{
		GetVehicleHealth(vehicleid, GLOBAL_VEHICLES[vehicleid][gb_vehicle_HEALTH]);
		if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_HEALTH] < MIN_VEHICLE_HEALTH)
		{	
			GLOBAL_VEHICLES[vehicleid][gb_vehicle_STATE] = VEHICLE_STATE_DAMAGED;
			GLOBAL_VEHICLES[vehicleid][gb_vehicle_HEALTH] = MIN_VEHICLE_HEALTH;
			SetVehicleHealthEx(vehicleid, GLOBAL_VEHICLES[vehicleid][gb_vehicle_HEALTH], playerid);
				
			GLOBAL_VEHICLES[vehicleid][gb_vehicle_PARAMS_ENGINE] = 0;
			UpdateVehicleParams(vehicleid);
			SendClientMessage(playerid, -1, "{CCCCCC}El motor del vehículo está demasiado dañado.");
		}
	}
	
	if(gettime() > pLastFuelSubtraction[playerid] + 5)
	{
		if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_PARAMS_ENGINE])
		{
			GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS] -= floatmul(floatdiv(vel, maxvel), 0.1);
			
			if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS] <= 0.1)
			{
				PLAYER_AC_INFO[playerid][CHEAT_VEHICLE_NOFUEL][p_ac_info_IMMUNITY] = gettime() + 15;
				GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS] = 0.0;
				GLOBAL_VEHICLES[vehicleid][gb_vehicle_PARAMS_ENGINE] = 0;
				UpdateVehicleParams(vehicleid);
				
				SendClientMessage(playerid, -1, "{999999}El vehículo se ha quedado sin gasolina...");
			}
		}
		pLastFuelSubtraction[playerid] = gettime();
	}

	new td_str[64];

	if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS] < 15.0) format(td_str, 64, "~r~%.1f~w~_Litros", GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS]);
	else format(td_str, 64, "%.1f_Litros", GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS]);
	PlayerTextDrawSetString(playerid, PlayerTextdraws[playerid][pSpeedoTd][2], td_str);
	
	if(floatround(vel) >= 0 && floatround(vel) < 40) format(td_str, 64, "~h~%d~w~_KM/H", floatround(vel));
	else if(floatround(vel) >= 40 && floatround(vel) < 80) format(td_str, 64, "~b~~h~%d~w~_KM/H", floatround(vel));
	else if(floatround(vel) >= 80 && floatround(vel) < 140) format(td_str, 64, "~g~~g~%d~w~_KM/H", floatround(vel));
	else if(floatround(vel) >= 140) format(td_str, 64, "~r~%d~w~_KM/H", floatround(vel));

	PlayerTextDrawSetString(playerid, PlayerTextdraws[playerid][pSpeedoTd][3], td_str);

    new start = floatround( floatdiv(vel, floatdiv(maxvel, 33.0)) );
    if(PLAYER_TEMP[playerid][pt_Plataforma]) format(td_str, 64, "~r~_____IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
	else format(td_str, 64, "~r~_IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
    if(start < 33) strins(td_str, "~w~", 3 + start);
	PlayerTextDrawSetString(playerid, PlayerTextdraws[playerid][pSpeedoTd][4], td_str);
	
	GetVehiclePos(vehicleid, GLOBAL_VEHICLES[vehicleid][gb_vehicle_POS][0], GLOBAL_VEHICLES[vehicleid][gb_vehicle_POS][1], GLOBAL_VEHICLES[vehicleid][gb_vehicle_POS][2]);
	return 1;
}

stock Float:GetVehicleSpeed(vehicleid)
{
    new Float:vx, Float:vy, Float:vz;
    GetVehicleVelocity(vehicleid, vx, vy, vz);
	new Float:vel = floatmul(floatsqroot(floatadd(floatadd(floatpower(vx, 2), floatpower(vy, 2)),  floatpower(vz, 2))), 181.5);
	return vel;
}
