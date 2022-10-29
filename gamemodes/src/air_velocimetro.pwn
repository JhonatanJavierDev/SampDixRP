#include <YSI-Includes\YSI\y_hooks>

enum PLANE_ALARMS_TYPES:(<<= 1) 
{
    PLANE_ALARM_TERRAIN = 1,
    PLANE_ALARM_BANK_ANGLE
};

enum E_Airports_Areas 
{
    airport_area_AREAID,
    Float:airport_area_MIN_X,
    Float:airport_area_MIN_Y,
    Float:airport_area_MAX_X,
    Float:airport_area_MAX_Y
};

new Airports_Areas[][E_Airports_Areas] = 
{
    {INVALID_STREAMER_ID, 881.229003, -2811.327148, 2625.628417, -2188.754638}, //LS
    {INVALID_STREAMER_ID, -2299.068603, -1045.947998, -670.923095, 1045.822631}, //SF
    {INVALID_STREAMER_ID, 1234.226196, 573.200256, 1758.641479, 2468.117675}, //LV
    {INVALID_STREAMER_ID, -475.365783, 2198.848144, 870.382324, 2850.787109} //AA
};

new
    Text:airSpeedoTd[16],
    PlayerText:pAirSpeedoTd[MAX_PLAYERS][5] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...},
    bool:pAirSpeedo[MAX_PLAYERS],
    bool:pInAirport[MAX_PLAYERS],
    PLANE_ALARMS_TYPES:pAirAlarms[MAX_PLAYERS],
    pAirSpeedoTimer[MAX_PLAYERS] = {-1, ...};

forward OnAirSpeedoRequestUpdate(playerid, vehicleid);

hook OnScriptInit() 
{
    for(new i = 0; i < sizeof Airports_Areas; i ++) 
    {
        Airports_Areas[i][airport_area_AREAID] = CreateDynamicRectangle(Airports_Areas[i][airport_area_MIN_X], Airports_Areas[i][airport_area_MIN_Y], Airports_Areas[i][airport_area_MAX_X], Airports_Areas[i][airport_area_MAX_Y], 0, 0);
        Streamer_SetArrayData(STREAMER_TYPE_AREA, Airports_Areas[i][airport_area_AREAID], E_STREAMER_EXTRA_ID, { AREA_TYPE_AIRPORT });
    }

    airSpeedoTd[0] = TextDrawCreate(170.000000, 333.000000, "LD_SPAC:white");
    TextDrawTextSize(airSpeedoTd[0], 300.000000, 80.000000);
    TextDrawAlignment(airSpeedoTd[0], 1);
    TextDrawColor(airSpeedoTd[0], 255);
    TextDrawSetShadow(airSpeedoTd[0], 0);
    TextDrawBackgroundColor(airSpeedoTd[0], 255);
    TextDrawFont(airSpeedoTd[0], 4);
    TextDrawSetProportional(airSpeedoTd[0], 0);

    airSpeedoTd[1] = TextDrawCreate(200.000000, 343.000000, "GEAR");
    TextDrawLetterSize(airSpeedoTd[1], 0.322666, 1.533629);
    TextDrawAlignment(airSpeedoTd[1], 2);
    TextDrawColor(airSpeedoTd[1], -1);
    TextDrawSetShadow(airSpeedoTd[1], 0);
    TextDrawSetOutline(airSpeedoTd[1], 1);
    TextDrawBackgroundColor(airSpeedoTd[1], 255);
    TextDrawFont(airSpeedoTd[1], 1);
    TextDrawSetProportional(airSpeedoTd[1], 1);

    airSpeedoTd[2] = TextDrawCreate(180.000000, 361.000000, "LD_SPAC:white");
    TextDrawTextSize(airSpeedoTd[2], 40.000000, 35.000000);
    TextDrawAlignment(airSpeedoTd[2], 1);
    TextDrawColor(airSpeedoTd[2], -2139062017);
    TextDrawSetShadow(airSpeedoTd[2], 0);
    TextDrawBackgroundColor(airSpeedoTd[2], 255);
    TextDrawFont(airSpeedoTd[2], 4);
    TextDrawSetProportional(airSpeedoTd[2], 0);

    airSpeedoTd[3] = TextDrawCreate(182.000000, 363.000000, "LD_SPAC:white");
    TextDrawTextSize(airSpeedoTd[3], 36.000000, 31.000000);
    TextDrawAlignment(airSpeedoTd[3], 1);
    TextDrawColor(airSpeedoTd[3], 215);
    TextDrawSetShadow(airSpeedoTd[3], 0);
    TextDrawBackgroundColor(airSpeedoTd[3], 255);
    TextDrawFont(airSpeedoTd[3], 4);
    TextDrawSetProportional(airSpeedoTd[3], 0);

    airSpeedoTd[4] = TextDrawCreate(260.000000, 343.000000, "AIRSPEED");
    TextDrawLetterSize(airSpeedoTd[4], 0.322666, 1.533629);
    TextDrawAlignment(airSpeedoTd[4], 2);
    TextDrawColor(airSpeedoTd[4], -1);
    TextDrawSetShadow(airSpeedoTd[4], 0);
    TextDrawSetOutline(airSpeedoTd[4], 1);
    TextDrawBackgroundColor(airSpeedoTd[4], 255);
    TextDrawFont(airSpeedoTd[4], 1);
    TextDrawSetProportional(airSpeedoTd[4], 1);

    airSpeedoTd[5] = TextDrawCreate(240.000000, 361.000000, "LD_SPAC:white");
    TextDrawTextSize(airSpeedoTd[5], 40.000000, 35.000000);
    TextDrawAlignment(airSpeedoTd[5], 1);
    TextDrawColor(airSpeedoTd[5], -2139062017);
    TextDrawSetShadow(airSpeedoTd[5], 0);
    TextDrawBackgroundColor(airSpeedoTd[5], 255);
    TextDrawFont(airSpeedoTd[5], 4);
    TextDrawSetProportional(airSpeedoTd[5], 0);

    airSpeedoTd[6] = TextDrawCreate(242.000000, 363.000000, "LD_SPAC:white");
    TextDrawTextSize(airSpeedoTd[6], 36.000000, 31.000000);
    TextDrawAlignment(airSpeedoTd[6], 1);
    TextDrawColor(airSpeedoTd[6], 215);
    TextDrawSetShadow(airSpeedoTd[6], 0);
    TextDrawBackgroundColor(airSpeedoTd[6], 255);
    TextDrawFont(airSpeedoTd[6], 4);
    TextDrawSetProportional(airSpeedoTd[6], 0);

    airSpeedoTd[7] = TextDrawCreate(320.000000, 343.000000, "ALTITUDE");
    TextDrawLetterSize(airSpeedoTd[7], 0.322666, 1.533629);
    TextDrawAlignment(airSpeedoTd[7], 2);
    TextDrawColor(airSpeedoTd[7], -1);
    TextDrawSetShadow(airSpeedoTd[7], 0);
    TextDrawSetOutline(airSpeedoTd[7], 1);
    TextDrawBackgroundColor(airSpeedoTd[7], 255);
    TextDrawFont(airSpeedoTd[7], 1);
    TextDrawSetProportional(airSpeedoTd[7], 1);

    airSpeedoTd[8] = TextDrawCreate(300.000000, 361.000000, "LD_SPAC:white");
    TextDrawTextSize(airSpeedoTd[8], 40.000000, 35.000000);
    TextDrawAlignment(airSpeedoTd[8], 1);
    TextDrawColor(airSpeedoTd[8], -2139062017);
    TextDrawSetShadow(airSpeedoTd[8], 0);
    TextDrawBackgroundColor(airSpeedoTd[8], 255);
    TextDrawFont(airSpeedoTd[8], 4);
    TextDrawSetProportional(airSpeedoTd[8], 0);

    airSpeedoTd[9] = TextDrawCreate(302.000000, 363.000000, "LD_SPAC:white");
    TextDrawTextSize(airSpeedoTd[9], 36.000000, 31.000000);
    TextDrawAlignment(airSpeedoTd[9], 1);
    TextDrawColor(airSpeedoTd[9], 215);
    TextDrawSetShadow(airSpeedoTd[9], 0);
    TextDrawBackgroundColor(airSpeedoTd[9], 255);
    TextDrawFont(airSpeedoTd[9], 4);
    TextDrawSetProportional(airSpeedoTd[9], 0);

    airSpeedoTd[10] = TextDrawCreate(380.000000, 343.000000, "HEADING");
    TextDrawLetterSize(airSpeedoTd[10], 0.322666, 1.533629);
    TextDrawAlignment(airSpeedoTd[10], 2);
    TextDrawColor(airSpeedoTd[10], -1);
    TextDrawSetShadow(airSpeedoTd[10], 0);
    TextDrawSetOutline(airSpeedoTd[10], 1);
    TextDrawBackgroundColor(airSpeedoTd[10], 255);
    TextDrawFont(airSpeedoTd[10], 1);
    TextDrawSetProportional(airSpeedoTd[10], 1);

    airSpeedoTd[11] = TextDrawCreate(360.000000, 361.000000, "LD_SPAC:white");
    TextDrawTextSize(airSpeedoTd[11], 40.000000, 35.000000);
    TextDrawAlignment(airSpeedoTd[11], 1);
    TextDrawColor(airSpeedoTd[11], -2139062017);
    TextDrawSetShadow(airSpeedoTd[11], 0);
    TextDrawBackgroundColor(airSpeedoTd[11], 255);
    TextDrawFont(airSpeedoTd[11], 4);
    TextDrawSetProportional(airSpeedoTd[11], 0);

    airSpeedoTd[12] = TextDrawCreate(362.000000, 363.000000, "LD_SPAC:white");
    TextDrawTextSize(airSpeedoTd[12], 36.000000, 31.000000);
    TextDrawAlignment(airSpeedoTd[12], 1);
    TextDrawColor(airSpeedoTd[12], 215);
    TextDrawSetShadow(airSpeedoTd[12], 0);
    TextDrawBackgroundColor(airSpeedoTd[12], 255);
    TextDrawFont(airSpeedoTd[12], 4);
    TextDrawSetProportional(airSpeedoTd[12], 0);

    airSpeedoTd[13] = TextDrawCreate(440.000000, 343.000000, "FUEL");
    TextDrawLetterSize(airSpeedoTd[13], 0.322666, 1.533629);
    TextDrawAlignment(airSpeedoTd[13], 2);
    TextDrawColor(airSpeedoTd[13], -1);
    TextDrawSetShadow(airSpeedoTd[13], 0);
    TextDrawSetOutline(airSpeedoTd[13], 1);
    TextDrawBackgroundColor(airSpeedoTd[13], 255);
    TextDrawFont(airSpeedoTd[13], 1);
    TextDrawSetProportional(airSpeedoTd[13], 1);

    airSpeedoTd[14] = TextDrawCreate(420.000000, 361.000000, "LD_SPAC:white");
    TextDrawTextSize(airSpeedoTd[14], 40.000000, 35.000000);
    TextDrawAlignment(airSpeedoTd[14], 1);
    TextDrawColor(airSpeedoTd[14], -2139062017);
    TextDrawSetShadow(airSpeedoTd[14], 0);
    TextDrawBackgroundColor(airSpeedoTd[14], 255);
    TextDrawFont(airSpeedoTd[14], 4);
    TextDrawSetProportional(airSpeedoTd[14], 0);

    airSpeedoTd[15] = TextDrawCreate(422.000000, 363.000000, "LD_SPAC:white");
    TextDrawTextSize(airSpeedoTd[15], 36.000000, 31.000000);
    TextDrawAlignment(airSpeedoTd[15], 1);
    TextDrawColor(airSpeedoTd[15], 215);
    TextDrawSetShadow(airSpeedoTd[15], 0);
    TextDrawBackgroundColor(airSpeedoTd[15], 255);
    TextDrawFont(airSpeedoTd[15], 4);
    TextDrawSetProportional(airSpeedoTd[15], 0);
}

hook OnPlayerConnect(playerid) 
{
    pAirAlarms[playerid] = PLANE_ALARMS_TYPES:0;
    pInAirport[playerid] = false;

    //eliminar obstaculos pistas
    RemoveBuildingForPlayer(playerid, 3664, 1388.0078, -2593.0000, 19.2813, 0.25);
    RemoveBuildingForPlayer(playerid, 3664, 1388.0078, -2494.2656, 19.2813, 0.25);
    RemoveBuildingForPlayer(playerid, 10764, -1041.3594, 451.2500, 16.4844, 0.25);
    RemoveBuildingForPlayer(playerid, 7979, 1477.3984, 1172.4453, 12.8906, 0.25);
    RemoveBuildingForPlayer(playerid, 3672, 1889.6563, -2666.0078, 18.8828, 0.25);
    RemoveBuildingForPlayer(playerid, 3672, 1822.7344, -2666.0078, 18.8828, 0.25);
    RemoveBuildingForPlayer(playerid, 3672, 1682.7266, -2666.0078, 18.8828, 0.25);
    RemoveBuildingForPlayer(playerid, 3672, 1617.2813, -2666.0078, 18.8828, 0.25);
    RemoveBuildingForPlayer(playerid, 3672, 1754.1719, -2666.0078, 18.8828, 0.25);
    RemoveBuildingForPlayer(playerid, 3629, 1617.2813, -2666.0078, 18.8828, 0.25);
    RemoveBuildingForPlayer(playerid, 1290, 1649.0625, -2641.4063, 18.4766, 0.25);
    RemoveBuildingForPlayer(playerid, 3629, 1682.7266, -2666.0078, 18.8828, 0.25);
    RemoveBuildingForPlayer(playerid, 3629, 1754.1719, -2666.0078, 18.8828, 0.25);
    RemoveBuildingForPlayer(playerid, 3629, 1822.7344, -2666.0078, 18.8828, 0.25);
    RemoveBuildingForPlayer(playerid, 1290, 1855.7969, -2641.4063, 18.4766, 0.25);
    RemoveBuildingForPlayer(playerid, 3629, 1889.6563, -2666.0078, 18.8828, 0.25);
    RemoveBuildingForPlayer(playerid, 1290, 1922.2031, -2641.4063, 18.4766, 0.25);
    RemoveBuildingForPlayer(playerid, 3663, 1882.2656, -2395.7813, 14.4688, 0.25);
    RemoveBuildingForPlayer(playerid, 1290, 2003.4531, -2422.1719, 18.4766, 0.25);
    RemoveBuildingForPlayer(playerid, 3664, 2042.7734, -2442.1875, 19.2813, 0.25);
    RemoveBuildingForPlayer(playerid, 1290, 2088.6094, -2422.1719, 18.4766, 0.25);
    RemoveBuildingForPlayer(playerid, 3664, 1960.6953, -2236.4297, 19.2813, 0.25);
    RemoveBuildingForPlayer(playerid, 8240, 1586.2578, 1189.5938, 23.4453, 0.25);
    RemoveBuildingForPlayer(playerid, 8241, 1586.2578, 1189.5938, 23.4453, 0.25);
    RemoveBuildingForPlayer(playerid, 3489, 1609.3359, 1671.6953, 16.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 3490, 1609.3359, 1671.6953, 16.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 3489, 1677.2969, 1671.6953, 16.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 3490, 1677.2969, 1671.6953, 16.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 8334, 1621.7813, 1316.9922, 13.8203, 0.25);
    RemoveBuildingForPlayer(playerid, 8338, 1641.1328, 1629.4063, 13.8203, 0.25);
    RemoveBuildingForPlayer(playerid, 8340, 1568.0000, 1676.1953, 13.8203, 0.25);
    RemoveBuildingForPlayer(playerid, 8378, 1586.2578, 1222.7031, 19.7500, 0.25);
    RemoveBuildingForPlayer(playerid, 8379, 1586.2578, 1222.7031, 19.7500, 0.25);
    RemoveBuildingForPlayer(playerid, 8335, 1621.7813, 1316.9922, 13.8203, 0.25);
    RemoveBuildingForPlayer(playerid, 8341, 1568.0000, 1676.1953, 13.8203, 0.25);
    RemoveBuildingForPlayer(playerid, 8339, 1641.1328, 1629.4063, 13.8203, 0.25);
}

hook OnPlayerDisconnect(playerid, reason) 
{
    DestroyPlayerAirSpeedo(playerid);
}

hook OnPlayerStateChange(playerid, newstate, oldstate) 
{
    if(newstate == PLAYER_STATE_DRIVER) 
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(!VEHICLE_INFO[GetVehicleModel(vehicleid) - 400][vehicle_info_NORMAL_SPEEDO] && (Vehicle_IsPlane(vehicleid) || Vehicle_IsHelicopter(vehicleid))) {
            CreatePlayerAirSpeedo(playerid, vehicleid);
        }
    }
    else if(oldstate == PLAYER_STATE_DRIVER && pAirSpeedo[playerid]) 
    {
        DestroyPlayerAirSpeedo(playerid);
    }
}

hook OnPlayerEnterDynArea(playerid, areaid)
{
	new info[2];
	Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, info);
    if(info[0] == AREA_TYPE_AIRPORT) {
        pInAirport[playerid] = true;
        return Y_HOOKS_BREAK_RETURN_1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
	new info[2];
	Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, info);
    if(info[0] == AREA_TYPE_AIRPORT) 
    {
        pInAirport[playerid] = false;
        return Y_HOOKS_BREAK_RETURN_1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

public OnAirSpeedoRequestUpdate(playerid, vehicleid) 
{
    new string[128], model = GetVehicleModel(vehicleid), Float:pos[3], Float:angle;

    GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
    GetVehicleZAngle(vehicleid, angle);

    if(VEHICLE_INFO[model - 400][vehicle_info_LANDING_GEAR]) 
    {
        PlayerTextDrawSetString(playerid, pAirSpeedoTd[playerid][0], 
            GLOBAL_VEHICLES[vehicleid][gb_vehicle_LANDING_GEAR_STATUS] ? "up" : "down"
        );
    }

    new Float:vel = GetVehicleAirSpeed(vehicleid);
    format(string, sizeof string, "%.0f~n~KTS", vel);
    PlayerTextDrawSetString(playerid, pAirSpeedoTd[playerid][1], string);

    format(string, sizeof string, "%s~n~FT",  number_format_thousand(floatround(pos[2] * 13.28 /* 3.28 */)));
    PlayerTextDrawSetString(playerid, pAirSpeedoTd[playerid][2], string);
    
    format(string, sizeof string, "%.0f|", angle);
    PlayerTextDrawSetString(playerid, pAirSpeedoTd[playerid][3], string);

    if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_PARAMS_ENGINE]) 
    {
        GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS] -= floatmul(floatdiv(GLOBAL_VEHICLES[vehicleid][gb_vehicle_MAX_GAS], 200), vel * 0.0004);
        if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS] <= 0.1)
        {
            PLAYER_AC_INFO[playerid][CHEAT_VEHICLE_NOFUEL][p_ac_info_IMMUNITY] = gettime() + 15;
            GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS] = 0.0;
            GLOBAL_VEHICLES[vehicleid][gb_vehicle_PARAMS_ENGINE] = 0;
            UpdateVehicleParams(vehicleid);
            
            SendClientMessage(playerid, -1, "{999999}El vehículo se ha quedado sin gasolina...");
        }
    }

    format(string, sizeof string, "%s~n~liters", number_format_thousand(floatround(GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS])));
    PlayerTextDrawSetString(playerid, pAirSpeedoTd[playerid][4], string);

    if(VEHICLE_INFO[model - 400][vehicle_info_AIR_ALARMS]) 
    {
        new PLANE_ALARMS_TYPES:oldAlarms = pAirAlarms[playerid];

        //terrain
        new Float:highest_Z = 0.0;
        MapAndreas_FindZ_For2DCoord(pos[0], pos[1], highest_Z);

        if((pos[2] - highest_Z) < 100.0 && !pInAirport[playerid] && vel > 50.0) 
        {
            if(!(pAirAlarms[playerid] & PLANE_ALARM_TERRAIN)) 
            {
                pAirAlarms[playerid] |= PLANE_ALARM_TERRAIN;
            }
        }
        else 
        {
            if(pAirAlarms[playerid] & PLANE_ALARM_TERRAIN) 
            {
                pAirAlarms[playerid] &= ~PLANE_ALARM_TERRAIN;
            }
        }

        //bank angle
        new Float:rot[3];
        GetVehicleRotation(vehicleid, rot[0], rot[1], rot[2]);
        if(rot[0] >= 40.0 || rot[0] <= -40.0 || rot[1] >= 55.00 || rot[1] <= -55.0) 
        {
            if(!(pAirAlarms[playerid] & PLANE_ALARM_BANK_ANGLE)) 
            {
                pAirAlarms[playerid] |= PLANE_ALARM_BANK_ANGLE;
            }
        }
        else {
            if(pAirAlarms[playerid] & PLANE_ALARM_BANK_ANGLE) {
                pAirAlarms[playerid] &= ~PLANE_ALARM_BANK_ANGLE;
            }
        }

        if(pAirAlarms[playerid] != oldAlarms) {
            if((pAirAlarms[playerid] & PLANE_ALARM_TERRAIN) && (pAirAlarms[playerid] & PLANE_ALARM_BANK_ANGLE)) {
                PlayAudioStreamForPlayer(playerid, "https://files.super-rp.es/audio/game/alarm_terrain_bank_angle.mp3");
            }
            else if(pAirAlarms[playerid] & PLANE_ALARM_TERRAIN) {
                PlayAudioStreamForPlayer(playerid, "https://files.super-rp.es/audio/game/alarm_terrain.mp3");
            }
            else if(pAirAlarms[playerid] & PLANE_ALARM_BANK_ANGLE) {
                PlayAudioStreamForPlayer(playerid, "https://files.super-rp.es/audio/game/alarm_bank_angle.mp3");
            }
            else {
                StopAudioStreamForPlayer(playerid);
            }
        }
    }
}

CreatePlayerAirSpeedo(playerid, vehicleid) {
    DestroyPlayerAirSpeedo(playerid);

    pAirSpeedoTd[playerid][0] = CreatePlayerTextDraw(playerid, 200.000000, 372.000000, "-");
    PlayerTextDrawLetterSize(playerid, pAirSpeedoTd[playerid][0], 0.200000, 1.200000);
    PlayerTextDrawAlignment(playerid, pAirSpeedoTd[playerid][0], 2);
    PlayerTextDrawColor(playerid, pAirSpeedoTd[playerid][0], -1);
    PlayerTextDrawSetShadow(playerid, pAirSpeedoTd[playerid][0], 0);
    PlayerTextDrawBackgroundColor(playerid, pAirSpeedoTd[playerid][0], 255);
    PlayerTextDrawFont(playerid, pAirSpeedoTd[playerid][0], 2);
    PlayerTextDrawSetProportional(playerid, pAirSpeedoTd[playerid][0], 1);

    pAirSpeedoTd[playerid][1] = CreatePlayerTextDraw(playerid, 260.000000, 367.000000, "0~n~KTS");
    PlayerTextDrawLetterSize(playerid, pAirSpeedoTd[playerid][1], 0.200000, 1.200000);
    PlayerTextDrawAlignment(playerid, pAirSpeedoTd[playerid][1], 2);
    PlayerTextDrawColor(playerid, pAirSpeedoTd[playerid][1], -1);
    PlayerTextDrawSetShadow(playerid, pAirSpeedoTd[playerid][1], 0);
    PlayerTextDrawBackgroundColor(playerid, pAirSpeedoTd[playerid][1], 255);
    PlayerTextDrawFont(playerid, pAirSpeedoTd[playerid][1], 2);
    PlayerTextDrawSetProportional(playerid, pAirSpeedoTd[playerid][1], 1);

    pAirSpeedoTd[playerid][2] = CreatePlayerTextDraw(playerid, 320.000000, 367.000000, "0~n~FT");
    PlayerTextDrawLetterSize(playerid, pAirSpeedoTd[playerid][2], 0.200000, 1.200000);
    PlayerTextDrawAlignment(playerid, pAirSpeedoTd[playerid][2], 2);
    PlayerTextDrawColor(playerid, pAirSpeedoTd[playerid][2], -1);
    PlayerTextDrawSetShadow(playerid, pAirSpeedoTd[playerid][2], 0);
    PlayerTextDrawBackgroundColor(playerid, pAirSpeedoTd[playerid][2], 255);
    PlayerTextDrawFont(playerid, pAirSpeedoTd[playerid][2], 2);
    PlayerTextDrawSetProportional(playerid, pAirSpeedoTd[playerid][2], 1);

    pAirSpeedoTd[playerid][3] = CreatePlayerTextDraw(playerid, 380.000000, 372.000000, "0|");
    PlayerTextDrawLetterSize(playerid, pAirSpeedoTd[playerid][3], 0.200000, 1.200000);
    PlayerTextDrawAlignment(playerid, pAirSpeedoTd[playerid][3], 2);
    PlayerTextDrawColor(playerid, pAirSpeedoTd[playerid][3], -1);
    PlayerTextDrawSetShadow(playerid, pAirSpeedoTd[playerid][3], 0);
    PlayerTextDrawBackgroundColor(playerid, pAirSpeedoTd[playerid][3], 255);
    PlayerTextDrawFont(playerid, pAirSpeedoTd[playerid][3], 2);
    PlayerTextDrawSetProportional(playerid, pAirSpeedoTd[playerid][3], 1);

    pAirSpeedoTd[playerid][4] = CreatePlayerTextDraw(playerid, 440.000000, 367.000000, "0~n~liters");
    PlayerTextDrawLetterSize(playerid, pAirSpeedoTd[playerid][4], 0.200000, 1.200000);
    PlayerTextDrawAlignment(playerid, pAirSpeedoTd[playerid][4], 2);
    PlayerTextDrawColor(playerid, pAirSpeedoTd[playerid][4], -1);
    PlayerTextDrawSetShadow(playerid, pAirSpeedoTd[playerid][4], 0);
    PlayerTextDrawBackgroundColor(playerid, pAirSpeedoTd[playerid][4], 255);
    PlayerTextDrawFont(playerid, pAirSpeedoTd[playerid][4], 2);
    PlayerTextDrawSetProportional(playerid, pAirSpeedoTd[playerid][4], 1);

    for(new i = 0; i < sizeof airSpeedoTd; i ++) {
        TextDrawShowForPlayer(playerid, airSpeedoTd[i]);
    }

    for(new i = 0; i < sizeof pAirSpeedoTd[]; i ++) {
        PlayerTextDrawShow(playerid, pAirSpeedoTd[playerid][i]);
    }

    pAirSpeedoTimer[playerid] = SetTimerEx("OnAirSpeedoRequestUpdate", 250, true, "ii", playerid, vehicleid);
    pAirSpeedo[playerid] = true;
}

DestroyPlayerAirSpeedo(playerid) 
{
    for(new i = 0; i < sizeof airSpeedoTd; i ++) 
    {
        TextDrawHideForPlayer(playerid, airSpeedoTd[i]);
    }

    for(new i = 0; i < sizeof pAirSpeedoTd[]; i ++) 
    {
        PlayerTextDrawDestroy(playerid, pAirSpeedoTd[playerid][i]);
    }

    if(pAirSpeedoTimer[playerid] != -1) 
    {
        KillTimer(pAirSpeedoTimer[playerid]);
        pAirSpeedoTimer[playerid] = -1;
    }

    pAirAlarms[playerid] = PLANE_ALARMS_TYPES:0;
    pAirSpeedo[playerid] = false;
}

stock Float:GetVehicleAirSpeed(vehicleid)
{
    new Float:vel = GetVehicleSpeed(vehicleid);
	return vel * 1.2; //vel * 0.54;
}

const VEHICLE_SYNC = 200;
IPacket:VEHICLE_SYNC(playerid, BitStream:bs)
{
    new inCarData[PR_InCarSync];

    BS_IgnoreBits(bs, 8);
    BS_ReadInCarSync(bs, inCarData);

    if(GLOBAL_VEHICLES[ inCarData[PR_vehicleId] ][gb_vehicle_VALID]) {
        GLOBAL_VEHICLES[ inCarData[PR_vehicleId] ][gb_vehicle_LANDING_GEAR_STATUS] = inCarData[PR_landingGearState];
    }
    return 1;
}