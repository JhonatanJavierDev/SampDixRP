#include <YSI-Includes\YSI\y_hooks>

new Float:WaterVehsStations[][] = {
    {-2374.549804, 2297.461914, -0.236894},
    {-1664.029907, 187.403015, -0.157910},
    {1624.959716, 560.530212, -0.355069},
    {2297.031738, -2494.700439, 0.021154},
    {2736.525390, -2597.991699, -0.733959}
};

#define REPAIR_BOAT_PRICE 2000
#define PAINT_BOAT_PRICE 5000

hook OnScriptInit() {
    for(new i = 0; i < sizeof WaterVehsStations; i ++) {
        CreateDynamic3DTextLabel("Usa {"#PRIMARY_COLOR"}/barco {FFFFFF}para ver opciones.", 0xFFFFFFFF, WaterVehsStations[i][0], WaterVehsStations[i][1], WaterVehsStations[i][2], 100.0, .testlos = false, .interiorid = 0, .worldid = 0);
        new areaId = CreateDynamicCylinder(WaterVehsStations[i][0], WaterVehsStations[i][1], WaterVehsStations[i][2] - 10.0, WaterVehsStations[i][2] + 10.0, 30.0, 0, 0);
        Streamer_SetArrayData(STREAMER_TYPE_AREA, areaId, E_STREAMER_EXTRA_ID, { AREA_TYPE_WATERVEH_STATION });
    }
}

CMD:barco(playerid, params[]) {
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendNotification(playerid, "No estás en un barco.");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(Vehicle_IsBoat(vehicleid)) {
        new info[3];
        Streamer_GetArrayData(STREAMER_TYPE_AREA, PLAYER_TEMP[playerid][pt_LAST_AREA_ID], E_STREAMER_EXTRA_ID, info);
        if(info[0] != AREA_TYPE_WATERVEH_STATION || !IsPlayerInDynamicArea(playerid, PLAYER_TEMP[playerid][pt_LAST_AREA_ID])) return SendNotification(playerid, "No estás en el lugar adecuado.");

        GLOBAL_VEHICLES[vehicleid][gb_vehicle_PARAMS_ENGINE] = 0;
        UpdateVehicleParams(vehicleid);

        PLAYER_TEMP[playerid][pt_SELECTED_MECANICO_VEHICLE_ID] = vehicleid;

        new dialog_str[256];
        format(dialog_str, sizeof dialog_str, "1. Reparar (%s$)\n", number_format_thousand(REPAIR_BOAT_PRICE));

        if(PLAYER_VEHICLES[vehicleid][player_vehicle_VALID] && PLAYER_VEHICLES[vehicleid][player_vehicle_OWNER_ID] == PI[playerid][pi_ID]) {
            new string[128];
            format(string, sizeof string, "2. Cambiar color primario (%s$)\n3. Cambiar color secundario (%s$)", number_format_thousand(PAINT_BOAT_PRICE), number_format_thousand(PAINT_BOAT_PRICE));
            strcat(dialog_str, string);
        }

        PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
        PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_BOAT_OPTIONS;
        ShowPlayerDialog(playerid, DIALOG_BOAT_OPTIONS, DIALOG_STYLE_LIST, "Puerto", dialog_str, "Continuar", "Cerrar");
    }
    else SendNotification(playerid, "No estás en un barco.");
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        case DIALOG_BOAT_OPTIONS: {
            if(response) {
                switch(listitem) {
                    case 0: {
                        if(GivePlayerCash(playerid, -REPAIR_BOAT_PRICE, true, true)) {
                            RepairVehicleEx(PLAYER_TEMP[playerid][pt_SELECTED_MECANICO_VEHICLE_ID], playerid);
                            SendNotification(playerid, "Vehículo reparado.");
                        }
                        else SendNotification(playerid, "No tienes suficiente dinero.");
                    }
                    case 1, 2: {
                        new vehicleid = PLAYER_TEMP[playerid][pt_SELECTED_MECANICO_VEHICLE_ID];
                        if(PLAYER_VEHICLES[vehicleid][player_vehicle_VALID] && PLAYER_VEHICLES[vehicleid][player_vehicle_OWNER_ID] == PI[playerid][pi_ID]) {
                            PLAYER_TEMP[playerid][pt_MECANICO_COLOR_SLOT] = listitem - 1;
                            ShowDialog(playerid, DIALOG_BOAT_SELECT_COLOR);
                        }
                    }
                }
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case DIALOG_BOAT_SELECT_COLOR: {
            if(response) {
                if(GivePlayerCash(playerid, -PAINT_BOAT_PRICE, true, true)) {
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