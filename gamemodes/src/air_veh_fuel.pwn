#include <YSI-Includes\YSI\y_hooks>

new Float:AirVehsFuelStations[][] = {
    {2029.713745, -2442.656982, 13.464413}, //aero ls
    {-1146.474853, -206.401168, 14.063703}, //aero sf
    {1569.021728, 1202.654541, 10.728508} //aero lv
};

#define REPAIR_PLANE_PRICE 2000
#define PAINT_PLANE_PRICE 5000

new
    pAirVehFuelingTimer[MAX_PLAYERS] = {-1, ...},
    PlayerText:pAirVehRefuellingTd[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};

hook OnScriptInit() {
    for(new i = 0; i < sizeof AirVehsFuelStations; i ++) {
        CreateDynamic3DTextLabel("Usa {"#PRIMARY_COLOR"}/avion {FFFFFF}para ver opciones.", 0xFFFFFFFF, AirVehsFuelStations[i][0], AirVehsFuelStations[i][1], AirVehsFuelStations[i][2], 100.0, .testlos = false, .interiorid = 0, .worldid = 0);
        new areaId = CreateDynamicCylinder(AirVehsFuelStations[i][0], AirVehsFuelStations[i][1], AirVehsFuelStations[i][2] - 10.0, AirVehsFuelStations[i][2] + 10.0, 30.0, 0, 0);
        Streamer_SetArrayData(STREAMER_TYPE_AREA, areaId, E_STREAMER_EXTRA_ID, { AREA_TYPE_AIRVEH_FUEL });
    }
}

hook OnPlayerDisconnect(playerid, reason) {
    DestroyPlayerAirVehRefuelling(playerid);
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_SPECTATING || newstate == PLAYER_STATE_WASTED) {
        DestroyPlayerAirVehRefuelling(playerid);
	}
	return 1;
}

DestroyPlayerAirVehRefuelling(playerid) {
    if(pAirVehFuelingTimer[playerid] != -1) {
        KillTimer(pAirVehFuelingTimer[playerid]);
        pAirVehFuelingTimer[playerid] = -1;
    }

    if(pAirVehRefuellingTd[playerid] != PlayerText:INVALID_TEXT_DRAW) {
        PlayerTextDrawDestroy(playerid, pAirVehRefuellingTd[playerid]);
        pAirVehRefuellingTd[playerid] = PlayerText:INVALID_TEXT_DRAW;
    }
    return 1;
}

CreatePlayerAirVehRefuellingTDs(playerid) {
    pAirVehRefuellingTd[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 310.000000, "Repostando");
    PlayerTextDrawLetterSize(playerid, pAirVehRefuellingTd[playerid], 0.233249, 1.198665);
    PlayerTextDrawTextSize(playerid, pAirVehRefuellingTd[playerid], 0.000000, 200.000000);
    PlayerTextDrawAlignment(playerid, pAirVehRefuellingTd[playerid], 2);
    PlayerTextDrawColor(playerid, pAirVehRefuellingTd[playerid], -1);
    PlayerTextDrawSetShadow(playerid, pAirVehRefuellingTd[playerid], 0);
    PlayerTextDrawSetOutline(playerid, pAirVehRefuellingTd[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, pAirVehRefuellingTd[playerid], 255);
    PlayerTextDrawFont(playerid, pAirVehRefuellingTd[playerid], 1);
    PlayerTextDrawSetProportional(playerid, pAirVehRefuellingTd[playerid], 1);
}

CMD:avion(playerid, params[]) {
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendNotification(playerid, "No estás en un avión o helicoptero.");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(Vehicle_IsPlane(vehicleid) || Vehicle_IsHelicopter(vehicleid)) {
        new info[3];
        Streamer_GetArrayData(STREAMER_TYPE_AREA, PLAYER_TEMP[playerid][pt_LAST_AREA_ID], E_STREAMER_EXTRA_ID, info);
        if(info[0] != AREA_TYPE_AIRVEH_FUEL || !IsPlayerInDynamicArea(playerid, PLAYER_TEMP[playerid][pt_LAST_AREA_ID])) return SendNotification(playerid, "No estás en el lugar adecuado.");

        GLOBAL_VEHICLES[vehicleid][gb_vehicle_PARAMS_ENGINE] = 0;
        UpdateVehicleParams(vehicleid);

        PLAYER_TEMP[playerid][pt_SELECTED_MECANICO_VEHICLE_ID] = vehicleid;

        new dialog_str[256];
        format(dialog_str, sizeof dialog_str, "1. Rellenar combustible\n2. Reparar (%s$)\n", number_format_thousand(REPAIR_PLANE_PRICE));

        if(PLAYER_VEHICLES[vehicleid][player_vehicle_VALID] && PLAYER_VEHICLES[vehicleid][player_vehicle_OWNER_ID] == PI[playerid][pi_ID]) {
            new string[128];
            format(string, sizeof string, "3. Cambiar color primario (%s$)\n4. Cambiar color secundario (%s$)", number_format_thousand(PAINT_PLANE_PRICE), number_format_thousand(PAINT_PLANE_PRICE));
            strcat(dialog_str, string);
        }

        PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
        PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_PLANE_OPTIONS;
        ShowPlayerDialog(playerid, DIALOG_PLANE_OPTIONS, DIALOG_STYLE_LIST, "Aeropuerto", dialog_str, "Continuar", "Cerrar");
    }
    else SendNotification(playerid, "No estás en un avión o helicoptero.");
    return 1;
}

forward OnVehAirRefuellingUpdate(playerid, vehicleid);
public OnVehAirRefuellingUpdate(playerid, vehicleid) {
    if(!GLOBAL_VEHICLES[vehicleid][gb_vehicle_VALID] || GLOBAL_VEHICLES[vehicleid][gb_vehicle_PARAMS_ENGINE] || GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS] >= GLOBAL_VEHICLES[vehicleid][gb_vehicle_MAX_GAS]) return DestroyPlayerAirVehRefuelling(playerid);

    GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS] += 500.0;
    if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS] > GLOBAL_VEHICLES[vehicleid][gb_vehicle_MAX_GAS]) GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS] = GLOBAL_VEHICLES[vehicleid][gb_vehicle_MAX_GAS];

    if(pAirVehRefuellingTd[playerid] != PlayerText:INVALID_TEXT_DRAW) {
        new Float:percentage = (GLOBAL_VEHICLES[vehicleid][gb_vehicle_GAS] * 100.0) / GLOBAL_VEHICLES[vehicleid][gb_vehicle_MAX_GAS];
        if(percentage > 100.0) percentage = 100.0;

        new string[128];
        format(string, sizeof string, "Repostando_~y~(%.0f%%)", percentage);
        PlayerTextDrawSetString(playerid, pAirVehRefuellingTd[playerid], string);
    }
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        case DIALOG_PLANE_OPTIONS: {
            if(response) {
                switch(listitem) {
                    case 0: {
                        DestroyPlayerAirVehRefuelling(playerid);
                        CreatePlayerAirVehRefuellingTDs(playerid);

                        if(pAirVehRefuellingTd[playerid] != PlayerText:INVALID_TEXT_DRAW) {
                            PlayerTextDrawShow(playerid, pAirVehRefuellingTd[playerid]);
                        }

                        pAirVehFuelingTimer[playerid] = SetTimerEx("OnVehAirRefuellingUpdate", 1000, true, "ii", playerid, PLAYER_TEMP[playerid][pt_SELECTED_MECANICO_VEHICLE_ID]);
                    }
                    case 1: {
                        if(GivePlayerCash(playerid, -REPAIR_PLANE_PRICE, true, true)) {
                            RepairVehicleEx(PLAYER_TEMP[playerid][pt_SELECTED_MECANICO_VEHICLE_ID], playerid);
                            SendNotification(playerid, "Vehículo reparado.");
                        }
                        else SendNotification(playerid, "No tienes suficiente dinero.");
                    }
                    case 2, 3: {
                        new vehicleid = PLAYER_TEMP[playerid][pt_SELECTED_MECANICO_VEHICLE_ID];
                        if(PLAYER_VEHICLES[vehicleid][player_vehicle_VALID] && PLAYER_VEHICLES[vehicleid][player_vehicle_OWNER_ID] == PI[playerid][pi_ID]) {
                            PLAYER_TEMP[playerid][pt_MECANICO_COLOR_SLOT] = listitem - 2;
                            ShowDialog(playerid, DIALOG_PLANE_SELECT_COLOR);
                        }
                    }
                }
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case DIALOG_PLANE_SELECT_COLOR: {
            if(response) {
                if(GivePlayerCash(playerid, -PAINT_PLANE_PRICE, true, true)) {
                    switch(PLAYER_TEMP[playerid][pt_MECANICO_COLOR_SLOT])
                    {
                        case 0: GLOBAL_VEHICLES[ PLAYER_TEMP[playerid][pt_SELECTED_MECANICO_VEHICLE_ID] ][gb_vehicle_COLOR_1] = listitem;
                        case 1: GLOBAL_VEHICLES[ PLAYER_TEMP[playerid][pt_SELECTED_MECANICO_VEHICLE_ID] ][gb_vehicle_COLOR_2] = listitem;
                    }
                    ChangeVehicleColor(PLAYER_TEMP[playerid][pt_SELECTED_MECANICO_VEHICLE_ID], GLOBAL_VEHICLES[ PLAYER_TEMP[playerid][pt_SELECTED_MECANICO_VEHICLE_ID] ][gb_vehicle_COLOR_1], GLOBAL_VEHICLES[ PLAYER_TEMP[playerid][pt_SELECTED_MECANICO_VEHICLE_ID] ][gb_vehicle_COLOR_2]);
                    SendNotification(playerid, "Vehículo pintado.");
                }
                else SendNotification(playerid, "No tienes suficiente dinero.");
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}