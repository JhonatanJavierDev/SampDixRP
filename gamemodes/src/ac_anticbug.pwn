#include <YSI-Includes\YSI\y_hooks>

new
    bool:pCBugging[MAX_PLAYERS],
    pCBugLastFiredWeapon[MAX_PLAYERS];

hook OnPlayerDisconnect(playerid, reason) 
{
    pCBugging[playerid] = false;
    pCBugLastFiredWeapon[playerid] = 0;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
    if(
        ac_Info[CHEAT_CBUG][ac_Enabled] &&
        !pCBugging[playerid] &&
        GetPlayerState(playerid) == PLAYER_STATE_ONFOOT
    ) {
        new weaponid = GetPlayerWeapon(playerid);
        if(weaponid > 0 && WEAPON_INFO[weaponid][weapon_info_AC_CBUG]) 
        {
            if(newkeys & KEY_FIRE) 
            {
                pCBugLastFiredWeapon[playerid] = gettime();
            }
            else if(newkeys & KEY_CROUCH) 
            {
                new now = gettime();
                if(now > PLAYER_AC_INFO[playerid][CHEAT_CBUG][p_ac_info_IMMUNITY])
                {
                    if((now - pCBugLastFiredWeapon[playerid]) < 1) 
                    {
                        if(!ac_Info[CHEAT_CBUG][ac_Interval]) 
                        {
                            //OnPlayerCheatDetected(playerid, CHEAT_CBUG);
                            SetCBugPlayerInfo(playerid);
                        }
                        else
                        {
                            if(now - PLAYER_AC_INFO[playerid][CHEAT_CBUG][p_ac_info_LAST_DETECTION] > ac_Info[CHEAT_CBUG][ac_Interval]) PLAYER_AC_INFO[playerid][CHEAT_CBUG][p_ac_info_DETECTIONS] = 0;
                            else PLAYER_AC_INFO[playerid][CHEAT_CBUG][p_ac_info_DETECTIONS] ++;
                            
                            PLAYER_AC_INFO[playerid][CHEAT_CBUG][p_ac_info_LAST_DETECTION] = now;
                            if(PLAYER_AC_INFO[playerid][CHEAT_CBUG][p_ac_info_DETECTIONS] >= ac_Info[CHEAT_CBUG][ac_Detections]) 
                            {
                                //OnPlayerCheatDetected(playerid, CHEAT_CBUG);
                                SetCBugPlayerInfo(playerid);
                            }
                        }
                    }
                }
            }
        }
    }
}

SetCBugPlayerInfo(playerid) 
{
    new Float:sx, Float:sy, Float:sz;
    GetPlayerPos(playerid, sx, sy, sz);
    SetPlayerPos(playerid, sx, sy, sz);
    TogglePlayerControllableEx(playerid, false);
    KillTimer(PLAYER_TEMP[playerid][pt_TIMERS][16]);
    PLAYER_TEMP[playerid][pt_TIMERS][16] = SetTimerEx("FinishCBug", 2000, false, "i", playerid);
    SetTimerEx("ResyncPlayer", 0, false, "d", playerid);
    SendNotification(playerid, "Evita hacer CBug.");
}

forward FinishCBug(playerid);
public FinishCBug(playerid) 
{
    pCBugging[playerid] = false;
    pCBugLastFiredWeapon[playerid] = 0;
    TogglePlayerControllableEx(playerid, true);
}