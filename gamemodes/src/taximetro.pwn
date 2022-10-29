#include <YSI-Includes\YSI\y_hooks>

new
    bool:pTaximeterShown[MAX_PLAYERS],
    PlayerText:pTaximeterTd[MAX_PLAYERS][5];

hook OnPlayerConnect(playerid) 
{
    pTaximeterTd[playerid][0] = CreatePlayerTextDraw(playerid, 552.500000, 273.000000, "box");
	PlayerTextDrawLetterSize(playerid, pTaximeterTd[playerid][0], 0.000000, 6.730331);
	PlayerTextDrawTextSize(playerid, pTaximeterTd[playerid][0], 0.000000, 108.000000);
	PlayerTextDrawAlignment(playerid, pTaximeterTd[playerid][0], 2);
	PlayerTextDrawColor(playerid, pTaximeterTd[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, pTaximeterTd[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, pTaximeterTd[playerid][0], 150);
	PlayerTextDrawSetShadow(playerid, pTaximeterTd[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, pTaximeterTd[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, pTaximeterTd[playerid][0], 255);
	PlayerTextDrawFont(playerid, pTaximeterTd[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, pTaximeterTd[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, pTaximeterTd[playerid][0], 0);

	pTaximeterTd[playerid][1] = CreatePlayerTextDraw(playerid, 552.500000, 273.000000, "Tax¢metro");
	PlayerTextDrawLetterSize(playerid, pTaximeterTd[playerid][1], 0.198999, 1.015112);
	PlayerTextDrawTextSize(playerid, pTaximeterTd[playerid][1], 0.000000, 108.000000);
	PlayerTextDrawAlignment(playerid, pTaximeterTd[playerid][1], 2);
	PlayerTextDrawColor(playerid, pTaximeterTd[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, pTaximeterTd[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, pTaximeterTd[playerid][1], 0x0A9C95FF);
	PlayerTextDrawSetShadow(playerid, pTaximeterTd[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, pTaximeterTd[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, pTaximeterTd[playerid][1], 255);
	PlayerTextDrawFont(playerid, pTaximeterTd[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, pTaximeterTd[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, pTaximeterTd[playerid][1], 0);

	pTaximeterTd[playerid][2] = CreatePlayerTextDraw(playerid, 503.000000, 287.000000, "Tarifa:_0$/Km");
	PlayerTextDrawLetterSize(playerid, pTaximeterTd[playerid][2], 0.244665, 1.234961);
	PlayerTextDrawAlignment(playerid, pTaximeterTd[playerid][2], 1);
	PlayerTextDrawColor(playerid, pTaximeterTd[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, pTaximeterTd[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, pTaximeterTd[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, pTaximeterTd[playerid][2], 255);
	PlayerTextDrawFont(playerid, pTaximeterTd[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, pTaximeterTd[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, pTaximeterTd[playerid][2], 0);

	pTaximeterTd[playerid][3] = CreatePlayerTextDraw(playerid, 503.000000, 306.000000, "Recorrido:_0.0Km");
	PlayerTextDrawLetterSize(playerid, pTaximeterTd[playerid][3], 0.244665, 1.234961);
	PlayerTextDrawAlignment(playerid, pTaximeterTd[playerid][3], 1);
	PlayerTextDrawColor(playerid, pTaximeterTd[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, pTaximeterTd[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, pTaximeterTd[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, pTaximeterTd[playerid][3], 255);
	PlayerTextDrawFont(playerid, pTaximeterTd[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, pTaximeterTd[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, pTaximeterTd[playerid][3], 0);
	
	pTaximeterTd[playerid][4] = CreatePlayerTextDraw(playerid, 503.000000, 317.000000, "A_pagar:_0$");
	PlayerTextDrawLetterSize(playerid, pTaximeterTd[playerid][4], 0.244665, 1.234961);
	PlayerTextDrawAlignment(playerid, pTaximeterTd[playerid][4], 1);
	PlayerTextDrawColor(playerid, pTaximeterTd[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, pTaximeterTd[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, pTaximeterTd[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, pTaximeterTd[playerid][4], 255);
	PlayerTextDrawFont(playerid, pTaximeterTd[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, pTaximeterTd[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, pTaximeterTd[playerid][4], 0);
}

hook OnPlayerDisconnect(playerid, reason) {
    pTaximeterShown[playerid] = false;
    for(new i = 0; i < sizeof pTaximeterTd[]; i ++) {
        PlayerTextDrawDestroy(playerid, pTaximeterTd[playerid][i]);
    }
}

ResetVehicleTaxiMeter(vehicleid)
{
	KillTimer(TAXI_METER_VEHICLE[vehicleid][veh_taxi_meter_TIMER]);
	TAXI_METER_VEHICLE[vehicleid][veh_taxi_meter_ENABLED] = false;
	TAXI_METER_VEHICLE[vehicleid][veh_taxi_meter_PAYMENT] = 0;
	TAXI_METER_VEHICLE[vehicleid][veh_taxi_meter_OLD_X] = 0.0;
	TAXI_METER_VEHICLE[vehicleid][veh_taxi_meter_OLD_Y] = 0.0;
	TAXI_METER_VEHICLE[vehicleid][veh_taxi_meter_OLD_Z] = 0.0;
	TAXI_METER_VEHICLE[vehicleid][veh_taxi_meter_DISTANCE] = 0.0;
	return 1;
}

ShowPlayerTaxiMeter(playerid)
{
	UpdatePlayerTaxiMeterTextdraws(playerid);
    if(!IsInventoryOpened(playerid)) {
        for(new i = 0; i < sizeof pTaximeterTd[]; i ++) {
            PlayerTextDrawShow(playerid, pTaximeterTd[playerid][i]);
        }
        pTaximeterShown[playerid] = true;
    }
    else pTaximeterShown[playerid] = false;
	PLAYER_TEMP[playerid][pt_TAXI_METER_ENABLED] = true;
	return 1;
}

UpdatePlayerTaxiMeterTextdraws(playerid)
{
    PlayerTaximeter_UpdateShown(playerid);

	new td_str[128], vehicleid = GetPlayerVehicleID(playerid);
	if(vehicleid == INVALID_VEHICLE_ID) return 0;
	
	format(td_str, sizeof td_str, "Tarifa:_~y~%d$/Km", TAXI_METER_VEHICLE[vehicleid][veh_taxi_meter_PRICE]);
	PlayerTextDrawSetString(playerid, pTaximeterTd[playerid][2], td_str);
	
	format(td_str, sizeof td_str, "Recorrido:_~y~%.1fKm", TAXI_METER_VEHICLE[vehicleid][veh_taxi_meter_DISTANCE]);
	PlayerTextDrawSetString(playerid, pTaximeterTd[playerid][3], td_str);
	
	format(td_str, sizeof td_str, "A_pagar:_~y~%s$", number_format_thousand(TAXI_METER_VEHICLE[vehicleid][veh_taxi_meter_PAYMENT]));
	PlayerTextDrawSetString(playerid, pTaximeterTd[playerid][4], td_str);
	return 1;
}

forward UpdateVehicleTaximeter(taxi, driver, passenger);
public UpdateVehicleTaximeter(taxi, driver, passenger)
{
	new driver_vehicle = GetPlayerVehicleID(driver), passenger_vehicle = GetPlayerVehicleID(passenger);
	
	if(!IsPlayerConnected(driver))
	{
		SendClientMessageEx(passenger, -1, "{"#SILVER_COLOR"}El taxi te costó %s$.", number_format_thousand(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT]));		
		GivePlayerCash(passenger, -TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT], true, true);
		
		ResetVehicleTaxiMeter(taxi);
		HidePlayerTaxiMeter(passenger);
		return 1;
	}
	if(!IsPlayerConnected(passenger))
	{		
		new work_extra_payment;
		if(work_info[WORK_TAXI][work_info_EXTRA_PAY] > 0 && work_info[WORK_TAXI][work_info_EXTRA_PAY_EXP] > 0)
		{
			work_extra_payment = (work_info[WORK_TAXI][work_info_EXTRA_PAY] * floatround(floatdiv(PLAYER_WORKS[ driver ][WORK_TAXI][pwork_LEVEL], work_info[WORK_TAXI][work_info_EXTRA_PAY_EXP])));
			if(work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT] != 0) if(work_extra_payment > work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT]) work_extra_payment = work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT];
		
			if(PI[driver][pi_VIP]) work_extra_payment += SU_WORK_EXTRA_PAY;
		}
		PLAYER_WORKS[driver][WORK_TAXI][pwork_LEVEL] ++;
		
		SendClientMessageEx(driver, -1, "{"#SILVER_COLOR"}Has ganado %s$ con este viaje.", number_format_thousand(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT] + work_extra_payment));
		GivePlayerCash(driver, TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT] + work_extra_payment, true, false);
		
		ResetVehicleTaxiMeter(taxi);
		UpdatePlayerTaxiMeterTextdraws(driver);
		
		new new_passenger = GetVehicleFirstPassenger(taxi);
		if(new_passenger != INVALID_PLAYER_ID)
		{
			ShowPlayerTaxiMeter(new_passenger);
			if(PLAYER_TEMP[new_passenger][pt_WANT_TAXI])
			{
				PLAYER_TEMP[new_passenger][pt_WANT_TAXI] = false;
				DisablePlayerJobMark(new_passenger, WORK_TAXI);
			}
			
			TAXI_METER_VEHICLE[taxi][veh_taxi_meter_ENABLED] = true;
			GetVehiclePos(taxi, TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_X], TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_Y], TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_Z]);
			KillTimer(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_TIMER]);
			TAXI_METER_VEHICLE[taxi][veh_taxi_meter_TIMER] = SetTimerEx("UpdateVehicleTaximeter", 4000, true, "iii", taxi, GLOBAL_VEHICLES[taxi][gb_vehicle_DRIVER], new_passenger);
		}
		return 1;
	}
	
	if(driver_vehicle != taxi)
	{
		new work_extra_payment;
		if(work_info[WORK_TAXI][work_info_EXTRA_PAY] > 0 && work_info[WORK_TAXI][work_info_EXTRA_PAY_EXP] > 0)
		{
			work_extra_payment = (work_info[WORK_TAXI][work_info_EXTRA_PAY] * floatround(floatdiv(PLAYER_WORKS[ driver ][WORK_TAXI][pwork_LEVEL], work_info[WORK_TAXI][work_info_EXTRA_PAY_EXP])));
			if(work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT] != 0) if(work_extra_payment > work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT]) work_extra_payment = work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT];
		
			if(PI[driver][pi_VIP]) work_extra_payment += SU_WORK_EXTRA_PAY;
		}
		PLAYER_WORKS[driver][WORK_TAXI][pwork_LEVEL] ++;
		
		SendClientMessageEx(driver, -1, "{"#SILVER_COLOR"}Has ganado %s$ con este viaje.", number_format_thousand(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT] + work_extra_payment));
		SendClientMessageEx(passenger, -1, "{"#SILVER_COLOR"}El taxi te costó %s$.", number_format_thousand(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT]));
		
		GivePlayerCash(driver, TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT] + work_extra_payment, true, false);
		GivePlayerCash(passenger, -TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT], true, true);
		
		ResetVehicleTaxiMeter(taxi);
		HidePlayerTaxiMeter(driver);
		HidePlayerTaxiMeter(passenger);
		return 1;
	}
	if(passenger_vehicle != taxi)
	{
		new work_extra_payment;
		if(work_info[WORK_TAXI][work_info_EXTRA_PAY] > 0 && work_info[WORK_TAXI][work_info_EXTRA_PAY_EXP] > 0)
		{
			work_extra_payment = (work_info[WORK_TAXI][work_info_EXTRA_PAY] * floatround(floatdiv(PLAYER_WORKS[ driver ][WORK_TAXI][pwork_LEVEL], work_info[WORK_TAXI][work_info_EXTRA_PAY_EXP])));
			if(work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT] != 0) if(work_extra_payment > work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT]) work_extra_payment = work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT];
			
			if(PI[driver][pi_VIP]) work_extra_payment += SU_WORK_EXTRA_PAY;
		}
		PLAYER_WORKS[driver][WORK_TAXI][pwork_LEVEL] ++;
		
		SendClientMessageEx(driver, -1, "{"#SILVER_COLOR"}Has ganado %s$ con este viaje.", number_format_thousand(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT] + work_extra_payment));
		SendClientMessageEx(passenger, -1, "{"#SILVER_COLOR"}El taxi te costó %s$.", number_format_thousand(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT]));
		
		GivePlayerCash(driver, TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT] + work_extra_payment, true, false);
		GivePlayerCash(passenger, -TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT], true, true);
		
		ResetVehicleTaxiMeter(taxi);
		HidePlayerTaxiMeter(passenger);
		UpdatePlayerTaxiMeterTextdraws(driver);
		
		new new_passenger = GetVehicleFirstPassenger(taxi);
		if(new_passenger != INVALID_PLAYER_ID)
		{
			ShowPlayerTaxiMeter(new_passenger);
			if(PLAYER_TEMP[new_passenger][pt_WANT_TAXI])
			{
				PLAYER_TEMP[new_passenger][pt_WANT_TAXI] = false;
				DisablePlayerJobMark(new_passenger, WORK_TAXI);
			}
			
			TAXI_METER_VEHICLE[taxi][veh_taxi_meter_ENABLED] = true;
			GetVehiclePos(taxi, TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_X], TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_Y], TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_Z]);
			KillTimer(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_TIMER]);
			TAXI_METER_VEHICLE[taxi][veh_taxi_meter_TIMER] = SetTimerEx("UpdateVehicleTaximeter", 4000, true, "iii", taxi, GLOBAL_VEHICLES[taxi][gb_vehicle_DRIVER], new_passenger);
		}
		return 1;
	}
	
	if(GetPlayerState(driver) != PLAYER_STATE_DRIVER)
	{
		new work_extra_payment;
		if(work_info[WORK_TAXI][work_info_EXTRA_PAY] > 0 && work_info[WORK_TAXI][work_info_EXTRA_PAY_EXP] > 0)
		{
			work_extra_payment = (work_info[WORK_TAXI][work_info_EXTRA_PAY] * floatround(floatdiv(PLAYER_WORKS[ driver ][WORK_TAXI][pwork_LEVEL], work_info[WORK_TAXI][work_info_EXTRA_PAY_EXP])));
			if(work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT] != 0) if(work_extra_payment > work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT]) work_extra_payment = work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT];
			
			if(PI[driver][pi_VIP]) work_extra_payment += SU_WORK_EXTRA_PAY;
		}
		PLAYER_WORKS[driver][WORK_TAXI][pwork_LEVEL] ++;
		
		SendClientMessageEx(driver, -1, "{"#SILVER_COLOR"}Has ganado %s$ con este viaje.", number_format_thousand(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT] + work_extra_payment));
		SendClientMessageEx(passenger, -1, "{"#SILVER_COLOR"}El taxi te costó %s$.", number_format_thousand(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT]));
		
		GivePlayerCash(driver, TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT] + work_extra_payment, true, false);
		GivePlayerCash(passenger, -TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT], true, true);
		
		ResetVehicleTaxiMeter(taxi);
		HidePlayerTaxiMeter(driver);
		HidePlayerTaxiMeter(passenger);
		return 1;
	}
	if(GetPlayerState(passenger) != PLAYER_STATE_PASSENGER)
	{
		new work_extra_payment;
		if(work_info[WORK_TAXI][work_info_EXTRA_PAY] > 0 && work_info[WORK_TAXI][work_info_EXTRA_PAY_EXP] > 0)
		{
			work_extra_payment = (work_info[WORK_TAXI][work_info_EXTRA_PAY] * floatround(floatdiv(PLAYER_WORKS[ driver ][WORK_TAXI][pwork_LEVEL], work_info[WORK_TAXI][work_info_EXTRA_PAY_EXP])));
			if(work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT] != 0) if(work_extra_payment > work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT]) work_extra_payment = work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT];
		
			if(PI[driver][pi_VIP]) work_extra_payment += SU_WORK_EXTRA_PAY;
		}
		PLAYER_WORKS[driver][WORK_TAXI][pwork_LEVEL] ++;
		
		SendClientMessageEx(driver, -1, "{"#SILVER_COLOR"}Has ganado %s$ con este viaje.", number_format_thousand(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT] + work_extra_payment));
		SendClientMessageEx(passenger, -1, "{"#SILVER_COLOR"}El taxi te costó %s$.", number_format_thousand(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT]));
		
		GivePlayerCash(driver, TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT] + work_extra_payment, true, false);
		GivePlayerCash(passenger, -TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT], true, true);
		
		ResetVehicleTaxiMeter(taxi);
		HidePlayerTaxiMeter(passenger);
		UpdatePlayerTaxiMeterTextdraws(driver);
		
		new new_passenger = GetVehicleFirstPassenger(taxi);
		if(new_passenger != INVALID_PLAYER_ID)
		{
			ShowPlayerTaxiMeter(new_passenger);
			if(PLAYER_TEMP[new_passenger][pt_WANT_TAXI])
			{
				PLAYER_TEMP[new_passenger][pt_WANT_TAXI] = false;
				DisablePlayerJobMark(new_passenger, WORK_TAXI);
			}
			
			TAXI_METER_VEHICLE[taxi][veh_taxi_meter_ENABLED] = true;
			GetVehiclePos(taxi, TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_X], TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_Y], TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_Z]);
			KillTimer(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_TIMER]);
			TAXI_METER_VEHICLE[taxi][veh_taxi_meter_TIMER] = SetTimerEx("UpdateVehicleTaximeter", 4000, true, "iii", taxi, GLOBAL_VEHICLES[taxi][gb_vehicle_DRIVER], new_passenger);
		}
		return 1;
	}

	if(PI[passenger][pi_CASH] < TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT])
	{
		new work_extra_payment;
		if(work_info[WORK_TAXI][work_info_EXTRA_PAY] > 0 && work_info[WORK_TAXI][work_info_EXTRA_PAY_EXP] > 0)
		{
			work_extra_payment = (work_info[WORK_TAXI][work_info_EXTRA_PAY] * floatround(floatdiv(PLAYER_WORKS[ driver ][WORK_TAXI][pwork_LEVEL], work_info[WORK_TAXI][work_info_EXTRA_PAY_EXP])));
			if(work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT] != 0) if(work_extra_payment > work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT]) work_extra_payment = work_info[WORK_TAXI][work_info_EXTRA_PAY_LIMIT];
		
			if(PI[driver][pi_VIP]) work_extra_payment += SU_WORK_EXTRA_PAY;
		}
		PLAYER_WORKS[driver][WORK_TAXI][pwork_LEVEL] ++;
		
		SendClientMessageEx(driver, -1, "{"#SILVER_COLOR"}Has ganado %s$ con este viaje.", number_format_thousand(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT] + work_extra_payment));
		SendClientMessage(driver, -1, "{"#SILVER_COLOR"}El pasajero no tiene suficiente dinero para seguir pagando el viaje.");
		GivePlayerCash(driver, TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT] + work_extra_payment, true, false);
		
		SendClientMessageEx(passenger, -1, "{"#SILVER_COLOR"}El taxi te costó %s$.", number_format_thousand(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT]));
		SendClientMessage(passenger, -1, "{"#SILVER_COLOR"}No tienes suficiente dinero para seguir pagando el viaje.");
		GivePlayerCash(passenger, -TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT], true, true);
		if(PI[passenger][pi_CASH] < 0) SetPlayerCash(passenger, 0);
		
		ResetVehicleTaxiMeter(taxi);
		HidePlayerTaxiMeter(passenger);
		UpdatePlayerTaxiMeterTextdraws(driver);
		
		RemovePlayerFromVehicle(passenger);
		
		new new_passenger = GetVehicleFirstPassenger(taxi);
		if(new_passenger != INVALID_PLAYER_ID && new_passenger != passenger)
		{
			ShowPlayerTaxiMeter(new_passenger);
			if(PLAYER_TEMP[new_passenger][pt_WANT_TAXI])
			{
				PLAYER_TEMP[new_passenger][pt_WANT_TAXI] = false;
				DisablePlayerJobMark(new_passenger, WORK_TAXI);
			}
			
			TAXI_METER_VEHICLE[taxi][veh_taxi_meter_ENABLED] = true;
			GetVehiclePos(taxi, TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_X], TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_Y], TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_Z]);
			KillTimer(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_TIMER]);
			TAXI_METER_VEHICLE[taxi][veh_taxi_meter_TIMER] = SetTimerEx("UpdateVehicleTaximeter", 4000, true, "iii", taxi, GLOBAL_VEHICLES[taxi][gb_vehicle_DRIVER], new_passenger);
		}
		return 1;
	}
	
	new Float:distance = GetVehicleDistanceFromPoint(taxi, TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_X], TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_Y], TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_Z]) * 0.01;

	TAXI_METER_VEHICLE[taxi][veh_taxi_meter_DISTANCE] += distance;
	TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PAYMENT] = TAXI_METER_VEHICLE[taxi][veh_taxi_meter_PRICE] * floatround(TAXI_METER_VEHICLE[taxi][veh_taxi_meter_DISTANCE], floatround_round);
	
	GetVehiclePos(taxi, TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_X], TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_Y], TAXI_METER_VEHICLE[taxi][veh_taxi_meter_OLD_Z]);
	
	UpdatePlayerTaxiMeterTextdraws(driver);
	UpdatePlayerTaxiMeterTextdraws(passenger);
	return 1;
}

HidePlayerTaxiMeter(playerid)
{
    pTaximeterShown[playerid] = false;
    for(new i = 0; i < sizeof pTaximeterTd[]; i ++) {
        PlayerTextDrawHide(playerid, pTaximeterTd[playerid][i]);
    }
	PLAYER_TEMP[playerid][pt_TAXI_METER_ENABLED] = false;
	return 1;
}

PlayerTaximeter_UpdateShown(playerid) {
    if(PLAYER_TEMP[playerid][pt_TAXI_METER_ENABLED]) {
        if(!IsInventoryOpened(playerid) && !pTaximeterShown[playerid]) {
            for(new i = 0; i < sizeof pTaximeterTd[]; i ++) {
                PlayerTextDrawShow(playerid, pTaximeterTd[playerid][i]);
            }
            pTaximeterShown[playerid] = true;
        }
        else if(IsInventoryOpened(playerid) && pTaximeterShown[playerid]) {
            for(new i = 0; i < sizeof pTaximeterTd[]; i ++) {
                PlayerTextDrawHide(playerid, pTaximeterTd[playerid][i]);
            }
            pTaximeterShown[playerid] = false;
        }
    }
}