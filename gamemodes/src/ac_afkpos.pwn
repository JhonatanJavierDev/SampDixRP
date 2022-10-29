#include <YSI-Includes\YSI\y_hooks>

#define CHECK_AFK_POS_INTERVAL 600000 //10 min
#define AFK_POS_DISTANCE 2.0

new
    pAFKPosTimer[MAX_PLAYERS] = {-1, ...},
    Float:PAFKLastPositions[MAX_PLAYERS][3];

hook OnPlayerDisconnect(playerid, reason)
{
    if(pAFKPosTimer[playerid] != -1)
	{
        KillTimer(pAFKPosTimer[playerid]);
        pAFKPosTimer[playerid] = -1;
    }
    PAFKLastPositions[playerid] = Float:{0.0, 0.0, 0.0};
}

hook OnPlayerSpawn(playerid)
{
    SetAFKPosInfo(playerid);
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if(pAFKPosTimer[playerid] != -1)
	{
        KillTimer(pAFKPosTimer[playerid]);
        pAFKPosTimer[playerid] = -1;
    }
}

SetAFKPosInfo(playerid)
{
    if(pAFKPosTimer[playerid] != -1)
	{
        KillTimer(pAFKPosTimer[playerid]);
        pAFKPosTimer[playerid] = -1;
    }
    if(ac_Info[CHEAT_AFKPOS][ac_Enabled])
	{
        GetPlayerPos(playerid, PAFKLastPositions[playerid][0], PAFKLastPositions[playerid][1], PAFKLastPositions[playerid][2]);
        pAFKPosTimer[playerid] = SetTimerEx("CheckAFKPos", CHECK_AFK_POS_INTERVAL, false, "i", playerid);
    }
}

forward CheckAFKPos(playerid);
public CheckAFKPos(playerid)
{
    pAFKPosTimer[playerid] = -1;
    if(ac_Info[CHEAT_AFKPOS][ac_Enabled])
	{
        if(PI[playerid][pi_STATE] != ROLEPLAY_STATE_JAIL && GetPlayerDistanceFromPoint(playerid, PAFKLastPositions[playerid][0], PAFKLastPositions[playerid][1], PAFKLastPositions[playerid][2]) <= AFK_POS_DISTANCE) 
        {
            new now = gettime();
            if(now > PLAYER_AC_INFO[playerid][CHEAT_AFKPOS][p_ac_info_IMMUNITY])
            {
                if(!ac_Info[CHEAT_AFKPOS][ac_Interval]) OnPlayerCheatDetected(playerid, CHEAT_AFKPOS);
                else
                {
                    if(now - PLAYER_AC_INFO[playerid][CHEAT_AFKPOS][p_ac_info_LAST_DETECTION] > ac_Info[CHEAT_AFKPOS][ac_Interval]) PLAYER_AC_INFO[playerid][CHEAT_AFKPOS][p_ac_info_DETECTIONS] = 0;
                    else PLAYER_AC_INFO[playerid][CHEAT_AFKPOS][p_ac_info_DETECTIONS] ++;
                    
                    PLAYER_AC_INFO[playerid][CHEAT_AFKPOS][p_ac_info_LAST_DETECTION] = now;
                    if(PLAYER_AC_INFO[playerid][CHEAT_AFKPOS][p_ac_info_DETECTIONS] >= ac_Info[CHEAT_AFKPOS][ac_Detections]) OnPlayerCheatDetected(playerid, CHEAT_AFKPOS);
                }
            }
        }
        SetAFKPosInfo(playerid);
    }
}
