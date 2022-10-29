#include <YSI-Includes\YSI\y_hooks>

new
    pShieldCurrentObject[MAX_PLAYERS][2] = {{INVALID_STREAMER_ID, ...}, ...},
    bool:pInShield[MAX_PLAYERS];

HasPlayerShield(playerid) {
    for(new i = 0; i != sizeof PLAYER_WEAPONS[]; i ++) {
        new weaponid = PLAYER_WEAPONS[playerid][i][player_weapon_ID];
        if(weaponid != 0) {
            if(WEAPON_INFO[weaponid][weapon_info_SPECIAL] && WEAPON_INFO[weaponid][weapon_info_TYPE] == WEAPON_SHIELD) {
                return true;
            }
        }
    }
    return false;
}

IsPlayerShieldInUse(playerid) {
    return pInShield[playerid];
}

ResetPlayerShield(playerid) {
    for(new i = 0; i < sizeof pShieldCurrentObject[]; i ++) {
        if(pShieldCurrentObject[playerid][i] != INVALID_STREAMER_ID) {
            DestroyDynamicObject(pShieldCurrentObject[playerid][i]);
            pShieldCurrentObject[playerid][i] = INVALID_STREAMER_ID;
        }
    }
    if(pInShield[playerid]) {
        pInShield[playerid] = false;
        ClearAnimations(playerid, 1);
    }
}

SetPlayerShield(playerid) {
    ResetPlayerShield(playerid);

    pInShield[playerid] = true;
    
    new Float:pos[3], Float:angle;
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    GetPlayerFacingAngle(playerid, angle);

    ApplyAnimation(playerid, "COP_AMBIENT", "Copbrowse_shake", 4.1, 0, 0, 0, 1, 0, 1);

    pos[0] += (0.6 * floatsin(-angle, degrees));
	pos[1] += (0.6 * floatcos(-angle, degrees));

    pos[0] += (0.13 * floatsin(-(angle - 90.0), degrees));
	pos[1] += (0.13 * floatcos(-(angle - 90.0), degrees));
    pShieldCurrentObject[playerid][0] = CreateDynamicObject(18637, pos[0], pos[1], pos[2] - 0.13, 90.0, 0.0, angle + 180.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

    pos[0] += (0.2 * floatsin(-(angle - 90.0), degrees));
	pos[1] += (0.2 * floatcos(-(angle - 90.0), degrees));
    pos[0] += (0.2 * floatsin(-angle, degrees));
	pos[1] += (0.2 * floatcos(-angle, degrees));
    pShieldCurrentObject[playerid][1] = CreateDynamicObject(2679, pos[0], pos[1], pos[2] - 0.8, 0.0, 0.0, angle, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    SetDynamicObjectMaterial(pShieldCurrentObject[playerid][1], 0, 0, "blank", "blank", 0x00000000);
    SetDynamicObjectMaterial(pShieldCurrentObject[playerid][1], 1, 0, "blank", "blank", 0x00000000);
    SetDynamicObjectMaterial(pShieldCurrentObject[playerid][1], 2, 0, "blank", "blank", 0x00000000);
    SetDynamicObjectMaterial(pShieldCurrentObject[playerid][1], 3, 0, "blank", "blank", 0x00000000);

    Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
}

hook OnPlayerDisconnect(playerid, reason) {
    ResetPlayerShield(playerid);
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_SPECTATING || newstate == PLAYER_STATE_WASTED) {
        ResetPlayerShield(playerid);
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if ((newkeys & KEY_WALK) && !(oldkeys & KEY_WALK)) {
        if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !pInShield[playerid] && HasPlayerShield(playerid)) {
            if(PI[playerid][pi_STATE] != ROLEPLAY_STATE_JAIL && PI[playerid][pi_STATE] != ROLEPLAY_STATE_CRACK) {
                SetPlayerShield(playerid);
            }
        }
    }
    else if ((oldkeys & KEY_WALK) && !(newkeys & KEY_WALK)) {
        if(pInShield[playerid]) {
            ResetPlayerShield(playerid);
        }
    }
}