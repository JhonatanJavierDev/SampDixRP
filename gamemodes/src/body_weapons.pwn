#include <YSI-Includes\YSI\y_hooks>

new bool:pUpdateWeaponsInBody[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	pUpdateWeaponsInBody[playerid] = true;
	return true;
}

hook OnPlayerUpdate(playerid)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pUpdateWeaponsInBody[playerid])
	{
        UpdateWeaponsInBody(playerid);
    }
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(oldstate == PLAYER_STATE_ONFOOT)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(vehicleid && Vehicle_IsBike(vehicleid)) return Y_HOOKS_CONTINUE_RETURN_1;
		RemovePlayerArmedWeapons(playerid);
	}
	return Y_HOOKS_CONTINUE_RETURN_1;
}

RemovePlayerArmedWeapons(playerid)
{
	RemovePlayerAttachedObject(playerid, 7);
	RemovePlayerAttachedObject(playerid, 8);
	RemovePlayerAttachedObject(playerid, 9);
}

IsPlayerArmedWeaponsEnabled(playerid)
{
	return pUpdateWeaponsInBody[playerid];
}

DisablePlayerArmedWeapons(playerid)
{
	pUpdateWeaponsInBody[playerid] = false;
	RemovePlayerArmedWeapons(playerid);
}

EnablePlayerArmedWeapons(playerid)
{
	pUpdateWeaponsInBody[playerid] = true;
}

UpdateWeaponsInBody(playerid)
{
	RemovePlayerArmedWeapons(playerid);
	for(new i = 0; i != sizeof PLAYER_WEAPONS[]; i ++)
	{
		if(!PLAYER_WEAPONS[playerid][i][player_weapon_VALID]) continue;

		new weaponId;
		weaponId = PLAYER_WEAPONS[playerid][i][player_weapon_ID];
		if(GetPlayerWeapon(playerid) == weaponId) continue;
		switch(weaponId)
		{
			case 25: SetPlayerAttachedObject(playerid, 9, 349, 1, 0.2219, -0.1959, 0.1300, 0.4000, 162.6999, 5.4000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 26: SetPlayerAttachedObject(playerid, 9, 350, 1, 0.2249, -0.1550, -0.1110, 171.0000, 162.6000, -1.5999, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 27: SetPlayerAttachedObject(playerid, 9, 351, 1, 0.2249, -0.1820, 0.1909, 176.2999, 22.6000, -172.6999, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 29: SetPlayerAttachedObject(playerid, 9, 353, 1, 0.2249, -0.1680, 0.1089, 176.2999, 22.6000, -179.1000, 1.0000, 1.0000, 1.0000, 0xFFFAEBD7, 0xFFF5F5F5);
			case 30: SetPlayerAttachedObject(playerid, 9, 355, 1, 0.2249, -0.1680, 0.1089, 176.2999, 22.6000, -179.1000, 1.0000, 1.0000, 1.0000, 0xFFFAEBD7, 0xFFF5F5F5);
			case 31: SetPlayerAttachedObject(playerid, 9, 356, 1, 0.2249, -0.1680, 0.1089, 176.2999, 22.6000, -179.1000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 33: SetPlayerAttachedObject(playerid, 9, 357, 1, 0.2249, -0.1889, 0.1089, 176.2999, 9.6000, -173.9000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 34: SetPlayerAttachedObject(playerid, 9, 358, 1, 0.2249, -0.1889, 0.1089, 176.2999, 9.6000, -173.9000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 35: SetPlayerAttachedObject(playerid, 9, 359, 1, 0.0440, -0.1889, 0.0709, 176.2999, 36.3000, -173.9000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 36: SetPlayerAttachedObject(playerid, 9, 360, 1, -0.2179, -0.1889, -0.0250, 176.2999, 36.3000, -173.9000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 37: SetPlayerAttachedObject(playerid, 9, 361, 1, 0.4090, -0.1310, 0.1439, 175.2996, -11.2999, 170.3999, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 38: SetPlayerAttachedObject(playerid, 9, 362, 1, 0.4090, -0.1990, -0.0820, -178.2003, -11.2999, 177.8999, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 28: SetPlayerAttachedObject(playerid, 8, 352, 1, -0.1279, 0.1779, 0.0980, 175.3997, 74.1000, -166.0999, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 39: SetPlayerAttachedObject(playerid, 8, 372, 1, -0.0469, 0.1529, -0.2149, -30.9001, 11.4001, 174.1999, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 2: SetPlayerAttachedObject(playerid, 7, 333, 1, 0.4310, -0.1440, 0.1000, 0.8998, -115.1998, 0.0000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 3: SetPlayerAttachedObject(playerid, 7, 334, 1, -0.1539, 0.0190, 0.2180, 97.2999, -50.9997, -167.0001, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 4: SetPlayerAttachedObject(playerid, 7, 335, 1, -0.1539, 0.0190, 0.2180, 97.2999, -50.9997, -167.0001, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 5: SetPlayerAttachedObject(playerid, 7, 336, 1, 0.2620, -0.1440, 0.0410, 0.8998, -115.1998, 0.0000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 6: SetPlayerAttachedObject(playerid, 7, 337, 1, 0.2620, -0.1090, 0.0410, -5.4001, -105.1998, -87.9999, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 7: SetPlayerAttachedObject(playerid, 7, 338, 1, 0.4380, -0.0920, 0.1170, -5.4001, -105.1998, -87.9999, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 8: SetPlayerAttachedObject(playerid, 7, 339, 1, -0.0779, 0.0639, 0.1840, 92.2998, -59.5997, -178.5000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 9: SetPlayerAttachedObject(playerid, 7, 341, 1, 0.4030, -0.2949, 0.0810, -70.0001, -163.0997, 10.2997, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 10: SetPlayerAttachedObject(playerid, 7, 321, 1, -0.1179, 0.0540, 0.2290, -74.9001, -115.4997, 10.2997, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 11: SetPlayerAttachedObject(playerid, 7, 322, 1, -0.1179, 0.0540, 0.2290, -74.9001, -115.4997, 10.2997, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 12: SetPlayerAttachedObject(playerid, 7, 323, 1, -0.1179, 0.0540, 0.2290, -74.9001, -115.4997, 10.2997, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 13: SetPlayerAttachedObject(playerid, 7, 324, 1, -0.1179, 0.0540, 0.2290, -74.9001, -115.4997, 10.2997, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 14: SetPlayerAttachedObject(playerid, 7, 325, 1, -0.1179, 0.0540, 0.2290, -74.9001, -115.4997, 10.2997, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 15: SetPlayerAttachedObject(playerid, 7, 326, 1, 0.3190, -0.1019, -0.0429, 15.0999, -50.9997, -167.0001, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
			case 47:
			{
				if(!IsPlayerShieldInUse(playerid))
				{
					SetPlayerAttachedObject(playerid, 7, 18637, 6, -0.359999, 0.042999, -0.114999, 102.600006, -2.499998, 17.300006, 1.000000, 1.000000, 1.000000);
				}
			}
		}
	}
}
