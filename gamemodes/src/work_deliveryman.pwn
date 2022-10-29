#include <YSI-Includes\YSI\y_hooks>

forward OnDeliveryManRequestLoad(playerid, vehicleid);
forward OnDeliveryManLoadingUp(playerid, vehicleid);

new Float:DeliveryManLoadPoints[][4] =
{
    {-1035.790771, -658.482116, 32.141559, 1.210250}
};

new Float:DeliveryManReturnPosition[3] = {-1062.509277, -615.138854, 32.007812};

new
    PlayerText:pDeliveryManLoadingTd[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...},
    Float:pDeliveryManLoadingProgress[MAX_PLAYERS],
    pDeliveryManLoadingTimer[MAX_PLAYERS] = {-1, ...}
;

hook OnSanAndreasVehicleLoad(vehicleid)
{
    if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_TYPE] == VEHICLE_TYPE_WORK && WORK_VEHICLES[vehicleid][work_vehicle_WORK] == WORK_DELIVERYMAN && GLOBAL_VEHICLES[vehicleid][gb_vehicle_MODELID] == 482)
	{
        new slot = GetVehicleFreeObjectSlot(vehicleid);
        if(slot != -1)
		{
            VEHICLE_OBJECTS[vehicleid][slot][vobject_VALID] = true;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_TYPE] = VOBJECT_TYPE_TEXT;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ID] = 0;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_MODELID] = 19327;
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_NAME], 32, "amazon");
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ATTACHED] = true;

            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][0] = -0.924591;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][1] = -1.08005;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][2] = 0.599409;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][0] = -11.3;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][1] = 0.0;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][2] = -90.6;
            
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_text_TEXT], 32, "amazon");
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT], 24, "Arial");
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT_SIZE] = 90;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_BOLD] = true;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT_COLOR] = -16777216;

            UpdateVehicleAttachedObject(vehicleid, slot, true);
        }

        slot = GetVehicleFreeObjectSlot(vehicleid);
        if(slot != -1)
		{
            VEHICLE_OBJECTS[vehicleid][slot][vobject_VALID] = true;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_TYPE] = VOBJECT_TYPE_TEXT;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ID] = 0;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_MODELID] = 19327;
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_NAME], 32, ")");
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ATTACHED] = true;

            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][0] = -0.964661;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][1] = -0.848911;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][2] = 0.383799;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][0] = -10.1;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][1] = 94.5001;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][2] = -91.0;
            
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_text_TEXT], 32, ")");
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT], 24, "Calibri");
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT_SIZE] = 150;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_BOLD] = true;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT_COLOR] = -26368;

            UpdateVehicleAttachedObject(vehicleid, slot, true);
        }

        slot = GetVehicleFreeObjectSlot(vehicleid);
        if(slot != -1)
		{
            VEHICLE_OBJECTS[vehicleid][slot][vobject_VALID] = true;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_TYPE] = VOBJECT_TYPE_TEXT;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ID] = 0;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_MODELID] = 19327;
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_NAME], 32, ">");
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ATTACHED] = true;

            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][0] = -0.963531;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][1] = -1.07214;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][2] = 0.412823;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][0] = -13.7;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][1] = -30.3;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][2] = -88.9;
            
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_text_TEXT], 32, ">");
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT], 24, "Impact");
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT_SIZE] = 100;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_BOLD] = true;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT_COLOR] = -26368;

            UpdateVehicleAttachedObject(vehicleid, slot, true);
        }

        //ESPEJO
        slot = GetVehicleFreeObjectSlot(vehicleid);
        if(slot != -1)
		{
            VEHICLE_OBJECTS[vehicleid][slot][vobject_VALID] = true;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_TYPE] = VOBJECT_TYPE_TEXT;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ID] = 0;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_MODELID] = 19327;
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_NAME], 32, "amazon");
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ATTACHED] = true;

            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][0] = -(-0.924591);
            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][1] = -1.08005;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][2] = 0.599409;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][0] = -11.3;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][1] = 0.0;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][2] = -90.6 + 180.0;
            
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_text_TEXT], 32, "amazon");
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT], 24, "Arial");
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT_SIZE] = 90;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_BOLD] = true;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT_COLOR] = -16777216;

            UpdateVehicleAttachedObject(vehicleid, slot, true);
        }

        slot = GetVehicleFreeObjectSlot(vehicleid);
        if(slot != -1)
		{
            VEHICLE_OBJECTS[vehicleid][slot][vobject_VALID] = true;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_TYPE] = VOBJECT_TYPE_TEXT;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ID] = 0;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_MODELID] = 19327;
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_NAME], 32, ")");
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ATTACHED] = true;

            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][0] = -(-0.964661);
            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][1] = (-0.848911) * 1.5;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][2] = 0.383799;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][0] = -10.1;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][1] = 94.5001;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][2] = -91.0 + 180.0;
            
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_text_TEXT], 32, ")");
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT], 24, "Calibri");
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT_SIZE] = 150;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_BOLD] = true;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT_COLOR] = -26368;

            UpdateVehicleAttachedObject(vehicleid, slot, true);
        }

        slot = GetVehicleFreeObjectSlot(vehicleid);
        if(slot != -1)
		{
            VEHICLE_OBJECTS[vehicleid][slot][vobject_VALID] = true;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_TYPE] = VOBJECT_TYPE_TEXT;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ID] = 0;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_MODELID] = 19327;
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_NAME], 32, ">");
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ATTACHED] = true;

            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][0] = -(-0.963531);
            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][1] = -1.07214;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][2] = 0.412823;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][0] = -13.7;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][1] = -30.3;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][2] = -88.9 + 180.0;
            
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_text_TEXT], 32, ">");
            format(VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT], 24, "Impact");
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT_SIZE] = 100;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_BOLD] = true;
            VEHICLE_OBJECTS[vehicleid][slot][vobject_text_FONT_COLOR] = -26368;

            UpdateVehicleAttachedObject(vehicleid, slot, true);
        }
    }
}

hook OnScriptInit()
{
	for(new i = 0; i != sizeof DeliveryManLoadPoints; i ++)
	{
		CreateDynamic3DTextLabel("Usa {"#PRIMARY_COLOR"}/cargar {FFFFFF}para cargar la furgoneta", 0xFFFFFFFF, DeliveryManLoadPoints[i][0], DeliveryManLoadPoints[i][1], DeliveryManLoadPoints[i][2], 10.0, .testlos = true, .interiorid = 0);
		CreateDynamicPickup(19135, 1, DeliveryManLoadPoints[i][0], DeliveryManLoadPoints[i][1], DeliveryManLoadPoints[i][2], -1, 0);
	}
}

public OnDeliveryManRequestLoad(playerid, vehicleid)
{
    for(new i = 0; i != sizeof DeliveryManLoadPoints; i ++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, DeliveryManLoadPoints[i][0], DeliveryManLoadPoints[i][1], DeliveryManLoadPoints[i][2]))
        {
            new Float:angle;
            GetVehicleZAngle(vehicleid, angle);
            if(angle > 180.0) angle -= 360.0;

            if(angle > (DeliveryManLoadPoints[i][3] - 15.0) && angle < (DeliveryManLoadPoints[i][3] + 15.0))
            {	
                if(TRUCK_VEHICLE[vehicleid][truck_vehicle_LOADED]) return SendNotification(playerid, "La furgoneta ya está cargada.");
                if(TRUCK_VEHICLE[vehicleid][truck_vehicle_LOADING]) return SendNotification(playerid, "La furgoneta ya se está cargando.");
    
                TRUCK_VEHICLE[vehicleid][truck_vehicle_LOADING] = true;
                TRUCK_VEHICLE[vehicleid][truck_vehicle_DRIVER_USER_ID] = PI[playerid][pi_ID];
                
                SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
                
                GLOBAL_VEHICLES[vehicleid][gb_vehicle_PARAMS_ENGINE] = 0;
                UpdateVehicleParams(vehicleid);

                if(pDeliveryManLoadingTimer[playerid] != -1)
				{
                    KillTimer(pDeliveryManLoadingTimer[playerid]);
                    pDeliveryManLoadingTimer[playerid] = -1;
                }

                pDeliveryManLoadingProgress[playerid] = frandom(5.0, 3.0, 2);

                new string[128];
                format(string, sizeof string, "Cargando ~y~(%.1f%%)", pDeliveryManLoadingProgress[playerid]);
                PlayerTextDrawSetString(playerid, pDeliveryManLoadingTd[playerid], string);
                PlayerTextDrawShow(playerid, pDeliveryManLoadingTd[playerid]);

                pDeliveryManLoadingTimer[playerid] = SetTimerEx("OnDeliveryManLoadingUp", 1000, true, "ii", playerid, vehicleid);
            }
            else SendNotification(playerid, "La furgoneta no está correctamente colocada para cargarlo.");
            return 1;
        }
    }
    SendNotification(playerid, "Para cargar la furgoneta colocate en cualquier punto de carga.");
    return 1;
}

hook OnDeliveryManLoadingUp(playerid, vehicleid)
{
    if(GetPlayerVehicleID(playerid) != vehicleid || pDeliveryManLoadingProgress[playerid] >= 100.0)
	{
        if(pDeliveryManLoadingTd[playerid] != PlayerText:INVALID_TEXT_DRAW)
		{
            PlayerTextDrawDestroy(playerid, pDeliveryManLoadingTd[playerid]);
            pDeliveryManLoadingTd[playerid] = PlayerText:INVALID_TEXT_DRAW;
        }
        if(pDeliveryManLoadingTimer[playerid] != -1)
		{
            KillTimer(pDeliveryManLoadingTimer[playerid]);
            pDeliveryManLoadingTimer[playerid] = -1;
        }
        pDeliveryManLoadingProgress[playerid] = 0.0;

        if(GetPlayerVehicleID(playerid) == vehicleid)
		{
            GLOBAL_VEHICLES[vehicleid][gb_vehicle_PARAMS_ENGINE] = 1;
            UpdateVehicleParams(vehicleid);
            
            TRUCK_VEHICLE[vehicleid][truck_vehicle_LOADED] = true;
            TRUCK_VEHICLE[vehicleid][truck_vehicle_LOADING] = false;
            TRUCK_VEHICLE[vehicleid][truck_vehicle_DELIVERED] = false;
            TRUCK_VEHICLE[vehicleid][truck_vehicle_CURRENT_POINT] = 0;
            TRUCK_VEHICLE[vehicleid][truck_vehicle_POINT] = GetRandomPropertyIndex();
            TRUCK_VEHICLE[vehicleid][truck_vehicle_TOTAL_POINTS] = minrand(2, 6);
            TRUCK_VEHICLE[vehicleid][truck_vehicle_TOTAL_DISTANCE] = GetPlayerDistanceFromPoint(playerid, PROPERTY_INFO[ TRUCK_VEHICLE[vehicleid][truck_vehicle_POINT] ][property_EXT_X], PROPERTY_INFO[ TRUCK_VEHICLE[vehicleid][truck_vehicle_POINT] ][property_EXT_Y], PROPERTY_INFO[ TRUCK_VEHICLE[vehicleid][truck_vehicle_POINT] ][property_EXT_Z]);
            
            SendFormatNotification(playerid, "La furgoneta ha sido cargada, tienes que entregar ~y~%d paquetes. ~w~Ve a entregar el primero.", TRUCK_VEHICLE[vehicleid][truck_vehicle_TOTAL_POINTS]);
            SetPlayerDeliveryManCheckpoint(playerid, vehicleid);
        }
    }
    else
	{
        pDeliveryManLoadingProgress[playerid] += frandom(10.0, 7.0, 2);
        if(pDeliveryManLoadingProgress[playerid] > 100.0) pDeliveryManLoadingProgress[playerid] = 100.0;

        new string[128];
        format(string, sizeof string, "Cargando ~y~(%.1f%%)", pDeliveryManLoadingProgress[playerid]);
        PlayerTextDrawSetString(playerid, pDeliveryManLoadingTd[playerid], string);
    }
}

hook StartPlayerJob(playerid, work, vehicleid)
{
    if(work == WORK_DELIVERYMAN)
	{
        if(pDeliveryManLoadingTd[playerid] == PlayerText:INVALID_TEXT_DRAW)
		{
            pDeliveryManLoadingTd[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 350.000000, "_");
            PlayerTextDrawLetterSize(playerid, pDeliveryManLoadingTd[playerid], 0.233249, 1.198665);
            PlayerTextDrawTextSize(playerid, pDeliveryManLoadingTd[playerid], 0.000000, 200.000000);
            PlayerTextDrawAlignment(playerid, pDeliveryManLoadingTd[playerid], 2);
            PlayerTextDrawColor(playerid, pDeliveryManLoadingTd[playerid], -1);
            PlayerTextDrawSetShadow(playerid, pDeliveryManLoadingTd[playerid], 0);
            PlayerTextDrawSetOutline(playerid, pDeliveryManLoadingTd[playerid], 1);
            PlayerTextDrawBackgroundColor(playerid, pDeliveryManLoadingTd[playerid], 255);
            PlayerTextDrawFont(playerid, pDeliveryManLoadingTd[playerid], 1);
            PlayerTextDrawSetProportional(playerid, pDeliveryManLoadingTd[playerid], 1);
        }


        if(IsPlayerArmedWeaponsEnabled(playerid)) DisablePlayerArmedWeapons(playerid);
        RemovePlayerAttachedObject(playerid, 8);
        if(TRUCK_VEHICLE[vehicleid][truck_vehicle_LOADED])
        {
            if(TRUCK_VEHICLE[vehicleid][truck_vehicle_DELIVERED]) SendNotification(playerid, "La furgoneta ya ha entregado todos los paquetes, ve al punto de partida para cobrar.");
            else {
                if(TRUCK_VEHICLE[vehicleid][truck_vehicle_CURRENT_POINT] == 0) SendNotification(playerid, "Ve a entregar el primer paquete al punto marcado.");
                else {
                    SendFormatNotification(playerid, "Ve a entregar el siguiente paquete al punto marcado. Te quedan ~y~%d ~w~paquetes por entregar.", TRUCK_VEHICLE[vehicleid][truck_vehicle_TOTAL_POINTS] - TRUCK_VEHICLE[vehicleid][truck_vehicle_CURRENT_POINT]);
                }
            }
            
            SetPlayerDeliveryManCheckpoint(playerid, vehicleid);
        }
        else SendNotification(playerid, "Para comenzar a trabajar carga la furgoneta en la zona indicada con una flecha amarilla.");
    }
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(oldstate == PLAYER_STATE_DRIVER && PLAYER_TEMP[playerid][pt_WORKING_IN] == WORK_DELIVERYMAN)
	{
        if(PLAYER_TEMP[playerid][pt_LAST_VEHICLE_ID] != INVALID_VEHICLE_ID)
		{
            new vehicleid = PLAYER_TEMP[playerid][pt_LAST_VEHICLE_ID];
            if(TRUCK_VEHICLE[vehicleid][truck_vehicle_DRIVER_USER_ID] == PI[playerid][pi_ID] && !TRUCK_VEHICLE[vehicleid][truck_vehicle_DELIVERED])
			{
                new index = TRUCK_VEHICLE[vehicleid][truck_vehicle_POINT];
                if(index != -1)
				{
                    new Float:distance = GetPlayerDistanceFromPoint
                    (
                        playerid,
                        PROPERTY_INFO[index][property_EXT_X],
                        PROPERTY_INFO[index][property_EXT_Y],
                        PROPERTY_INFO[index][property_EXT_Z]
                    );

                    if(distance <= 30.0)
					{
                        SetPlayerArmedWeapon(playerid, 0);
                        RemovePlayerAttachedObject(playerid, 8);
                        SetPlayerAttachedObject(playerid, 8, 1220, 5, 0.020000, 0.150999, 0.184000, 8.100003, 20.200000, 5.300002, 0.494000, 0.450000, 0.531000);
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
                    }
                }
            }
        }
    }
}

hook EndPlayerJob(playerid, work, bool:changeskin)
{
    if(work == WORK_DELIVERYMAN)
	{
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        SetPlayerToys(playerid);
        if(PLAYER_TEMP[playerid][pt_LAST_VEHICLE_ID] != INVALID_VEHICLE_ID)
        {
            if(TRUCK_VEHICLE[ PLAYER_TEMP[playerid][pt_LAST_VEHICLE_ID] ][truck_vehicle_DRIVER_USER_ID] == PI[playerid][pi_ID] && TRUCK_VEHICLE[ PLAYER_TEMP[playerid][pt_LAST_VEHICLE_ID] ][truck_vehicle_LOADING]) {
                SetVehicleToRespawnEx(PLAYER_TEMP[playerid][pt_LAST_VEHICLE_ID]);
            }
        }
        if(IsValidDynamicCP(PLAYER_TEMP[playerid][pt_TRUCK_CHECKPOINT]))
        {
            DestroyDynamicCP(PLAYER_TEMP[playerid][pt_TRUCK_CHECKPOINT]);
            PLAYER_TEMP[playerid][pt_TRUCK_CHECKPOINT] = INVALID_STREAMER_ID;
        }
        if(pDeliveryManLoadingTd[playerid] != PlayerText:INVALID_TEXT_DRAW) {
            PlayerTextDrawDestroy(playerid, pDeliveryManLoadingTd[playerid]);
            pDeliveryManLoadingTd[playerid] = PlayerText:INVALID_TEXT_DRAW;
        }
        if(pDeliveryManLoadingTimer[playerid] != -1) {
            KillTimer(pDeliveryManLoadingTimer[playerid]);
            pDeliveryManLoadingTimer[playerid] = -1;
        }
        pDeliveryManLoadingProgress[playerid] = 0.0;
    }
}

SetPlayerDeliveryManCheckpoint(playerid, vehicleid) 
{
    if(IsValidDynamicCP(PLAYER_TEMP[playerid][pt_TRUCK_CHECKPOINT]))
	{
		DestroyDynamicCP(PLAYER_TEMP[playerid][pt_TRUCK_CHECKPOINT]);
		PLAYER_TEMP[playerid][pt_TRUCK_CHECKPOINT] = INVALID_STREAMER_ID;
	}

	if(TRUCK_VEHICLE[vehicleid][truck_vehicle_DELIVERED])
	{
		PLAYER_TEMP[playerid][pt_TRUCK_CHECKPOINT] = CreateDynamicCP(DeliveryManReturnPosition[0], DeliveryManReturnPosition[1], DeliveryManReturnPosition[2], 5.0, 0, 0, playerid, 9999999999.0);
		
		new info[1];
		info[0] = CHECKPOINT_TYPE_FINISH_DMAN;
		Streamer_SetArrayData(STREAMER_TYPE_CP, PLAYER_TEMP[playerid][pt_TRUCK_CHECKPOINT], E_STREAMER_EXTRA_ID, info);
	}
	else
	{
        new index = TRUCK_VEHICLE[vehicleid][truck_vehicle_POINT];
        if(index != -1) {
            PLAYER_TEMP[playerid][pt_TRUCK_CHECKPOINT] = CreateDynamicCP(PROPERTY_INFO[index][property_EXT_X], PROPERTY_INFO[index][property_EXT_Y], PROPERTY_INFO[index][property_EXT_Z], 2.0, 0, 0, playerid, 9999999999.0);
            
            new info[1];
            info[0] = CHECKPOINT_TYPE_DMAN;
            Streamer_SetArrayData(STREAMER_TYPE_CP, PLAYER_TEMP[playerid][pt_TRUCK_CHECKPOINT], E_STREAMER_EXTRA_ID, info);
        }
	}
	Streamer_Update(playerid, STREAMER_TYPE_CP);
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	new info[1];
	Streamer_GetArrayData(STREAMER_TYPE_CP, checkpointid, E_STREAMER_EXTRA_ID, info);

	switch(info[0])
	{
        case CHECKPOINT_TYPE_DMAN: 
        {
            if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;

            new vehicleid = PLAYER_TEMP[playerid][pt_LAST_VEHICLE_ID];
            if(vehicleid != INVALID_VEHICLE_ID) 
            {
                if(TRUCK_VEHICLE[vehicleid][truck_vehicle_DRIVER_USER_ID] == PI[playerid][pi_ID]) 
                {
                    RemovePlayerAttachedObject(playerid, 8);
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
                    TRUCK_VEHICLE[vehicleid][truck_vehicle_CURRENT_POINT] ++;
                    if(TRUCK_VEHICLE[vehicleid][truck_vehicle_CURRENT_POINT] >= TRUCK_VEHICLE[vehicleid][truck_vehicle_TOTAL_POINTS]) 
                    {
                        TRUCK_VEHICLE[vehicleid][truck_vehicle_POINT] = 0;
                        TRUCK_VEHICLE[vehicleid][truck_vehicle_DELIVERED] = true;
                        SendNotification(playerid, "Has terminado de entregar todos los paquetes, regresa al punto de partida para cobrar.");
                    }
                    else 
                    {
                        TRUCK_VEHICLE[vehicleid][truck_vehicle_POINT] = GetRandomPropertyIndex();
                        TRUCK_VEHICLE[vehicleid][truck_vehicle_TOTAL_DISTANCE] += GetPlayerDistanceFromPoint(playerid, PROPERTY_INFO[ TRUCK_VEHICLE[vehicleid][truck_vehicle_POINT] ][property_EXT_X], PROPERTY_INFO[ TRUCK_VEHICLE[vehicleid][truck_vehicle_POINT] ][property_EXT_Y], PROPERTY_INFO[ TRUCK_VEHICLE[vehicleid][truck_vehicle_POINT] ][property_EXT_Z]);
                        SendFormatNotification(playerid, "Paquete entregado, ve a entregar el siguiente. Te quedan ~y~%d ~w~paquetes.", TRUCK_VEHICLE[vehicleid][truck_vehicle_TOTAL_POINTS] - TRUCK_VEHICLE[vehicleid][truck_vehicle_CURRENT_POINT]);
                    }
                    SetPlayerDeliveryManCheckpoint(playerid, vehicleid);
                }
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case CHECKPOINT_TYPE_FINISH_DMAN: 
        {
            if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
			if(!PLAYER_WORKS[playerid][WORK_DELIVERYMAN][pwork_SET]) return 1;
			if(PLAYER_TEMP[playerid][pt_WORKING_IN] != WORK_DELIVERYMAN) return 1;
	
			new vehicleid = GetPlayerVehicleID(playerid);
			if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_TYPE] != VEHICLE_TYPE_WORK) return 1;
			if(WORK_VEHICLES[vehicleid][work_vehicle_WORK] != WORK_DELIVERYMAN) return 1;
			if(!TRUCK_VEHICLE[vehicleid][truck_vehicle_DELIVERED]) return 1;
			if(TRUCK_VEHICLE[vehicleid][truck_vehicle_UNLOADING]) return 1;
			if(TRUCK_VEHICLE[vehicleid][truck_vehicle_DRIVER_USER_ID] != PI[playerid][pi_ID]) return SendNotification(playerid, "Solo le pagaremos al conductor que entregó los paquetes.");
			
			DestroyDynamicCP(PLAYER_TEMP[playerid][pt_TRUCK_CHECKPOINT]);
			PLAYER_TEMP[playerid][pt_TRUCK_CHECKPOINT] = INVALID_STREAMER_ID;
			
			SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
			
			new work_extra_payment;
			if(work_info[WORK_DELIVERYMAN][work_info_EXTRA_PAY] > 0 && work_info[WORK_DELIVERYMAN][work_info_EXTRA_PAY_EXP] > 0)
			{
				work_extra_payment = (work_info[WORK_DELIVERYMAN][work_info_EXTRA_PAY] * floatround(floatdiv(PLAYER_WORKS[playerid][WORK_DELIVERYMAN][pwork_LEVEL], work_info[WORK_DELIVERYMAN][work_info_EXTRA_PAY_EXP])));
				if(work_info[WORK_DELIVERYMAN][work_info_EXTRA_PAY_LIMIT] != 0) if(work_extra_payment > work_info[WORK_DELIVERYMAN][work_info_EXTRA_PAY_LIMIT]) work_extra_payment = work_info[WORK_DELIVERYMAN][work_info_EXTRA_PAY_LIMIT];
			
				if(PI[playerid][pi_VIP]) work_extra_payment += SU_WORK_EXTRA_PAY;
			}

            new prize;
            prize = floatround(floatmul(TRUCK_VEHICLE[vehicleid][truck_vehicle_TOTAL_DISTANCE], 0.6));
            prize += work_extra_payment;
			if(GivePlayerCash(playerid, prize, true, false)) 
            {
                SetVehicleToRespawnEx(vehicleid);
				PLAYER_WORKS[playerid][WORK_DELIVERYMAN][pwork_LEVEL] ++;
				AddPlayerJobPoints(playerid, WORK_DELIVERYMAN);
				
				new string[64];
				format(string, sizeof string, "~g~+%s$", number_format_thousand(prize));
				GameTextForPlayer(playerid, string, 5000, 1);
				CallLocalFunction("EndPlayerJob", "iib", playerid, PLAYER_TEMP[playerid][pt_WORKING_IN], true);
			}
            return Y_HOOKS_BREAK_RETURN_1;
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}
