#include <YSI-Includes\YSI\y_hooks>

new bool:pTazed[MAX_PLAYERS];

hook OnPlayerDisconnect(playerid, reason)
{
    pTazed[playerid] = false;
}

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    new weaponId = weaponid;
    if(weaponId)
	{
        new slot = WEAPON_INFO[weaponId][weapon_info_SLOT];
        if(WEAPON_INFO[ PLAYER_WEAPONS[playerid][slot][player_weapon_ID] ][weapon_info_TYPE] == WEAPON_TASER_GUN)
		{
            PlayerPlaySound(playerid, 6003, 0.0, 0.0, 0.0);
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
    new weaponId = GetPlayerWeapon(playerid);
    if(weaponId)
	{
        new slot = WEAPON_INFO[weaponId][weapon_info_SLOT];
        if(WEAPON_INFO[ PLAYER_WEAPONS[playerid][slot][player_weapon_ID] ][weapon_info_TYPE] == WEAPON_TASER_GUN)
		{
            if(PI[damagedid][pi_STATE] != ROLEPLAY_STATE_CRACK && !pTazed[damagedid])
			{
                pTazed[damagedid] = true;
                PlayerPlaySound(damagedid, 6003, 0.0, 0.0, 0.0);
                ApplyAnimation(damagedid, "CRACK", "crckidle4", 4.1, 1, 0, 0, 1, 0, 1);

                TogglePlayerControllableEx(damagedid, false);
                KillTimer(PLAYER_TEMP[damagedid][pt_TIMERS][16]);
                PLAYER_TEMP[damagedid][pt_TIMERS][16] = SetTimerEx("FinishTazer", 8000, false, "i", damagedid);
                SendNotification(damagedid, "Has recibido un disparo de una pistola taser.");

                new Float:health;
                GetPlayerHealth(damagedid, health);

                new Float:newHealth = health + amount;
                if(newHealth > 100.0) newHealth = 100.0;
                SetPlayerHealthEx(damagedid, newHealth);
            }
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

forward FinishTazer(playerid);
public FinishTazer(playerid)
{
    pTazed[playerid] = false;
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, true);
    ClearAnimations(playerid, 1);
    TogglePlayerControllableEx(playerid, true);
}
