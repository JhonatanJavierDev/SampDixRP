#include <YSI-Includes\YSI\y_hooks>

#define POLICE_PDOOR_KICK_RESET_TIME 600000 //10min

new
    pPoliceForcingPDoor[MAX_PLAYERS] = {-1, ...};

CMD:allanar(playerid, params[]) {
	if(!PLAYER_WORKS[playerid][WORK_POLICE][pwork_SET]) return SendNotification(playerid, "No eres policía.");
	if(PLAYER_TEMP[playerid][pt_WORKING_IN] != WORK_POLICE) return SendNotification(playerid, "No estás de servicio como policía.");
	if(PLAYER_WORKS[playerid][WORK_POLICE][pwork_LEVEL] < 3) return SendFormatNotification(playerid, "Tienes que ser %s para poder hacer esto.", POLICE_RANKS[3]);

	if(PLAYER_TEMP[playerid][pt_LAST_PICKUP_ID] == 0) return SendNotification(playerid, "No estás en el lugar adecuado.");
    if(pPoliceForcingPDoor[playerid] != -1) return SendNotification(playerid, "Estás forzado una puerta ahora.");
		
	new info[3];
	
	new Float:pos[3];
	Streamer_GetArrayData(STREAMER_TYPE_PICKUP, PLAYER_TEMP[playerid][pt_LAST_PICKUP_ID], E_STREAMER_EXTRA_ID, info);
	if(info[0] != PICKUP_TYPE_PROPERTY) return SendNotification(playerid, "No estás en el lugar adecuado.");

	Streamer_GetFloatData(STREAMER_TYPE_PICKUP, PLAYER_TEMP[playerid][pt_LAST_PICKUP_ID], E_STREAMER_X, pos[0]);
	Streamer_GetFloatData(STREAMER_TYPE_PICKUP, PLAYER_TEMP[playerid][pt_LAST_PICKUP_ID], E_STREAMER_Y, pos[1]);
	Streamer_GetFloatData(STREAMER_TYPE_PICKUP, PLAYER_TEMP[playerid][pt_LAST_PICKUP_ID], E_STREAMER_Z, pos[2]);

	if(!IsPlayerInRangeOfPoint(playerid, 1.0, pos[0], pos[1], pos[2])) return SendNotification(playerid, "No estás en el lugar adecuado.");

	new propertyIndex = info[1];
	if(PROPERTY_INFO[propertyIndex][property_POLICE_FORCING]) return SendNotification(playerid, "La puerta ya está siendo forzada.");
    if(PROPERTY_INFO[propertyIndex][property_POLICE_FORCED]) return SendNotification(playerid, "La puerta ya está abierta.");

	PROPERTY_INFO[propertyIndex][property_POLICE_FORCING] = true;
    ApplyAnimation(playerid, "POLICE", "Door_Kick", 4.1, 1, 0, 0, 1, 0, 1);
    pPoliceForcingPDoor[playerid] = propertyIndex;
    SetPlayerKeyPress(playerid, minrand(20, 30));
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if(pPoliceForcingPDoor[playerid] != -1) {
        PROPERTY_INFO[ pPoliceForcingPDoor[playerid] ][property_POLICE_FORCING] = false;
        pPoliceForcingPDoor[playerid] = -1;
    }
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_SPECTATING || newstate == PLAYER_STATE_WASTED) {
        if(pPoliceForcingPDoor[playerid] != -1) {
            PROPERTY_INFO[ pPoliceForcingPDoor[playerid] ][property_POLICE_FORCING] = false;
            pPoliceForcingPDoor[playerid] = -1;
        }
	}
	return 1;
}

hook OnPlayerKeyPressFinish(playerid) {
    if(pPoliceForcingPDoor[playerid] != -1) {
        new propertyIndex = pPoliceForcingPDoor[playerid];
        PROPERTY_INFO[propertyIndex][property_POLICE_FORCING] = false;
        PROPERTY_INFO[propertyIndex][property_POLICE_FORCED] = true;
        if(PROPERTY_INFO[propertyIndex][property_POLICE_FORCE_TIMER] != -1) {
            KillTimer(PROPERTY_INFO[propertyIndex][property_POLICE_FORCE_TIMER]);
            PROPERTY_INFO[propertyIndex][property_POLICE_FORCE_TIMER] = -1;
        }
        PROPERTY_INFO[propertyIndex][property_POLICE_FORCE_TIMER] = SetTimerEx("PropertyDoorPoliceForceFinish", POLICE_PDOOR_KICK_RESET_TIME, false, "i", propertyIndex);
        pPoliceForcingPDoor[playerid] = -1;
        ClearAnimations(playerid, 1);
        SendNotification(playerid, "La puerta ha sido forzada, ya se puede entrar.");
        return Y_HOOKS_BREAK_RETURN_1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

forward PropertyDoorPoliceForceFinish(propertyIndex);
public PropertyDoorPoliceForceFinish(propertyIndex) {
    PROPERTY_INFO[propertyIndex][property_POLICE_FORCE_TIMER] = -1;
    PROPERTY_INFO[propertyIndex][property_POLICE_FORCING] = false;
    PROPERTY_INFO[propertyIndex][property_POLICE_FORCED] = false;
}