#include <YSI-Includes\YSI\y_hooks>

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if(PI[playerid][pi_CREW])
	{
        new now = gettime(), crewid = PI[playerid][pi_CREW], crewIndex = PLAYER_TEMP[playerid][pt_CREW_INDEX];
        new crewcolor = CREW_INFO[ PLAYER_TEMP[playerid][pt_CREW_INDEX] ][crew_COLOR] >>> 8;
        new enterExitIndex = PLAYER_TEMP[playerid][pt_INTERIOR_INDEX];
        if(enterExitIndex != -1 && ENTER_EXIT[enterExitIndex][ee_ROBBABLE])
		{
            if(ENTER_EXIT[enterExitIndex][ee_TIMER] == -1)
			{
                if(now > CREW_INFO[crewIndex][crew_LAST_ROBBERY] + 300)
				{ // 5 min
                    if(now > ENTER_EXIT[enterExitIndex][ee_LAST_ROBBERY] + 1800)
					{ // 30 min
                        new attackers_in_shop = CountCrewPlayersInShop(crewIndex, enterExitIndex);
                        if(attackers_in_shop >= 1)
						{
                            //COMENZAR ATRACO
                            new string[128], city[45], zone[45];
                            GetPointZone(ENTER_EXIT[enterExitIndex][ee_EXT_X], ENTER_EXIT[enterExitIndex][ee_EXT_Y], city, zone);
                            format(string, sizeof string, "{%06x}[Banda] {FFFFFF}Integrantes de la banda iniciaron un atraco en %s, %s", crewcolor, city, zone);
                            SendMessageToCrewMembers(crewid, 0xCCCCCCCC, string);

                            StartShopAttack(crewIndex, enterExitIndex);
                            return Y_HOOKS_CONTINUE_RETURN_1;
                        }
                    }
                }
            }
            else
			{
                //esta siendo atracada
                if(crewIndex == ENTER_EXIT[enterExitIndex][ee_LAST_CREW_INDEX_ROBBERY])
				{
                    if(now > PLAYER_TEMP[playerid][pt_LAST_SHOT_ROBBERY] + 1)
					{
                        PLAYER_TEMP[playerid][pt_LAST_SHOT_ROBBERY] = now;
                        ENTER_EXIT[enterExitIndex][ee_ROBBERY_PROGRESS] += frandom(3.0, 1.5, 2);
                    }
                }
            }
        }
    }
    return 1;
}

hook OnPlayerEnterInterior(playerid, index) 
{
    if(ENTER_EXIT[index][ee_TIMER] != -1) 
    {
        if(ENTER_EXIT[index][ee_STEP] == 2) 
        {
            new Float:x, Float:y, Float:z;
            x = ENTER_EXIT[index][ee_INT_X];
            y = ENTER_EXIT[index][ee_INT_Y];
            z = ENTER_EXIT[index][ee_INT_Z];
            if(ENTER_EXIT[index][ee_MAIN_ACTOR] != INVALID_ACTOR_ID) 
            {
                GetDynamicActorPos(ENTER_EXIT[index][ee_MAIN_ACTOR], x, y, z);
            }
            PlayerPlaySoundEx(playerid, 3401, x, y, z);
        }
        
        if(PI[playerid][pi_CREW] && ENTER_EXIT[index][ee_LAST_CREW_INDEX_ROBBERY] == PLAYER_TEMP[playerid][pt_CREW_INDEX]) 
        {
            TextDrawShowForPlayer(playerid, Textdraws[textdraw_TERRITORY_BOX]);
            TextDrawShowForPlayer(playerid, ENTER_EXIT[index][ee_TEXTDRAW]);
        }
    }
}

hook OnPlayerExitInterior(playerid, index) 
{
    if(ENTER_EXIT[index][ee_TIMER] != -1) 
    {
        PlayerPlaySoundEx(playerid, 0, 0.0, 0.0, 0.0);
        if(PI[playerid][pi_CREW]) 
        {
            TextDrawHideForPlayer(playerid, Textdraws[textdraw_TERRITORY_BOX]);
            TextDrawHideForPlayer(playerid, ENTER_EXIT[index][ee_TEXTDRAW]);
        }
    }
}

CountCrewPlayersInShop(crew_index, enter_exit_index)
{
	new count;
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PI[i][pi_CREW])
			{
				if(PLAYER_TEMP[i][pt_CREW_INDEX] == crew_index)
				{
					if(PI[i][pi_STATE] == ROLEPLAY_STATE_INTERIOR && PLAYER_TEMP[i][pt_GAME_STATE] == GAME_STATE_NORMAL)
					{
						if(PLAYER_TEMP[i][pt_INTERIOR_INDEX] == enter_exit_index)
						{
							count ++;
						}
					}
				}
			}
		}
	}
	return count;
}

StartShopAttack(crew_index, enter_exit_index)
{
    new now = gettime();
	CREW_INFO[crew_index][crew_LAST_ROBBERY] = now;
    ENTER_EXIT[enter_exit_index][ee_LAST_ROBBERY] = now;
    ENTER_EXIT[enter_exit_index][ee_LAST_CREW_INDEX_ROBBERY] = crew_index;
    ENTER_EXIT[enter_exit_index][ee_STEP] = 0;
    ENTER_EXIT[enter_exit_index][ee_ROBBERY_PROGRESS] = frandom(8.0, 4.0, 2);
    if(ENTER_EXIT[enter_exit_index][ee_TIMER] != -1) 
    {
        KillTimer(ENTER_EXIT[enter_exit_index][ee_TIMER]);
        ENTER_EXIT[enter_exit_index][ee_TIMER] = -1;
    }

    new message[145];
	format(message, sizeof message, "Intimidación:_%.2f%%", ENTER_EXIT[enter_exit_index][ee_ROBBERY_PROGRESS]);
    FixTextDrawString(message);
	TextDrawSetString(ENTER_EXIT[enter_exit_index][ee_TEXTDRAW], message);

    //mostrar tds
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PI[i][pi_CREW] && PLAYER_TEMP[i][pt_CREW_INDEX] == crew_index && PLAYER_TEMP[i][pt_INTERIOR_INDEX] == enter_exit_index)
			{
                TextDrawShowForPlayer(i, Textdraws[textdraw_TERRITORY_BOX]);
                TextDrawShowForPlayer(i, ENTER_EXIT[enter_exit_index][ee_TEXTDRAW]);
            }
        }
    }

    if(ENTER_EXIT[enter_exit_index][ee_MAIN_ACTOR] != INVALID_ACTOR_ID) 
    {
        ApplyDynamicActorAnimation(ENTER_EXIT[enter_exit_index][ee_MAIN_ACTOR], "SHOP", "SHP_Rob_React", 4.1, 0, 1, 1, 1, 0);
    }

    ENTER_EXIT[enter_exit_index][ee_TIMER] = SetTimerEx("UpdateShopAttack", 1000, true, "ii", crew_index, enter_exit_index);
}

forward UpdateShopAttack(crew_index, enter_exit_index);
public UpdateShopAttack(crew_index, enter_exit_index) 
{
    ENTER_EXIT[enter_exit_index][ee_ROBBERY_PROGRESS] += frandom(0.8, 0.3, 2);

    if(ENTER_EXIT[enter_exit_index][ee_STEP] < 2) 
    {
        //CONTAR
        new attackers_in_shop = CountCrewPlayersInShop(crew_index, enter_exit_index);
        if(attackers_in_shop <= 0) 
        {
            FinishShopAttack(enter_exit_index);
            return 1;
        }
    }

    if(ENTER_EXIT[enter_exit_index][ee_ROBBERY_PROGRESS] >= 120.0 && ENTER_EXIT[enter_exit_index][ee_STEP] == 2) 
    {
        FinishShopAttack(enter_exit_index);
    }
    else if(ENTER_EXIT[enter_exit_index][ee_ROBBERY_PROGRESS] >= 99.0 && ENTER_EXIT[enter_exit_index][ee_STEP] == 1) 
    {
        new Float:x, Float:y, Float:z;
        x = ENTER_EXIT[enter_exit_index][ee_INT_X];
        y = ENTER_EXIT[enter_exit_index][ee_INT_Y];
        z = ENTER_EXIT[enter_exit_index][ee_INT_Z];

        if(ENTER_EXIT[enter_exit_index][ee_MAIN_ACTOR] != INVALID_ACTOR_ID) 
        {
            ApplyDynamicActorAnimation(ENTER_EXIT[enter_exit_index][ee_MAIN_ACTOR], "PED", "cower", 4.1, 0, 1, 1, 1, 0);
            GetDynamicActorPos(ENTER_EXIT[enter_exit_index][ee_MAIN_ACTOR], x, y, z);
        }

        new prize = minrand(2500, 3000);
        new prize_message[64];
		format(prize_message, sizeof prize_message, "{"#SILVER_COLOR"}Has ganado %d$ por robar esta tienda.", prize);

        new message_police[145], city[45], zone[45];
        GetPointZone(ENTER_EXIT[enter_exit_index][ee_EXT_X], ENTER_EXIT[enter_exit_index][ee_EXT_Y], city, zone);
        format(message_police, sizeof message_police, "{"#PRIMARY_COLOR"}[Central de policía] {FFFFFF}La banda '%s' ha atracado una tienda en {"#PRIMARY_COLOR"}%s, %s.", CREW_INFO[crew_index][crew_NAME], city, zone);
        
        for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
        {
            if(IsPlayerConnected(i))
            {
                if(PLAYER_TEMP[i][pt_INTERIOR_INDEX] == enter_exit_index)
                {
                    PlayerPlaySoundEx(i, 3401, x, y, z);
                    if(PI[i][pi_CREW] && PLAYER_TEMP[i][pt_CREW_INDEX] == crew_index) 
                    {
                        GivePlayerCash(i, prize, true, false);
						SendClientMessage(i, -1, prize_message);

                        if(PI[i][pi_WANTED_LEVEL] < 3)
						SetPlayerWantedLevelEx(i, 3);
                    }
                }

                if(PLAYER_WORKS[i][WORK_POLICE][pwork_SET])
                {
                    if(PLAYER_TEMP[i][pt_WORKING_IN] == WORK_POLICE)
                    {
                        SendClientMessage(i, -1, message_police);
                    }
                }
            }
        }

        ENTER_EXIT[enter_exit_index][ee_STEP] = 2;
    }
    else if(ENTER_EXIT[enter_exit_index][ee_ROBBERY_PROGRESS] >= 80.0 && ENTER_EXIT[enter_exit_index][ee_STEP] == 0) 
    {
        if(ENTER_EXIT[enter_exit_index][ee_MAIN_ACTOR] != INVALID_ACTOR_ID) 
        {
            ApplyDynamicActorAnimation(ENTER_EXIT[enter_exit_index][ee_MAIN_ACTOR], "SHOP", "SHP_Rob_GiveCash", 4.1, 0, 1, 1, 1, 0);
        }
        ENTER_EXIT[enter_exit_index][ee_STEP] = 1;
    }

    new message[145], Float:progress = ENTER_EXIT[enter_exit_index][ee_ROBBERY_PROGRESS];
    if(progress > 100.0) 
    progress = 100.0;
	format(message, sizeof message, "Intimidación:_%.2f%%", progress);
    FixTextDrawString(message);
	TextDrawSetString(ENTER_EXIT[enter_exit_index][ee_TEXTDRAW], message);
    return 1;
}

FinishShopAttack(enter_exit_index) 
{
    if(ENTER_EXIT[enter_exit_index][ee_TIMER] != -1) 
    {
        KillTimer(ENTER_EXIT[enter_exit_index][ee_TIMER]);
        ENTER_EXIT[enter_exit_index][ee_TIMER] = -1;
    }

    if(ENTER_EXIT[enter_exit_index][ee_MAIN_ACTOR] != INVALID_ACTOR_ID) 
    {
        ClearDynamicActorAnimations(ENTER_EXIT[enter_exit_index][ee_MAIN_ACTOR]);
    }

    //quitar tds
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PLAYER_TEMP[i][pt_INTERIOR_INDEX] == enter_exit_index)
			{
                TextDrawHideForPlayer(i, Textdraws[textdraw_TERRITORY_BOX]);
                TextDrawHideForPlayer(i, ENTER_EXIT[enter_exit_index][ee_TEXTDRAW]);
                PlayerPlaySoundEx(i, 0, 0.0, 0.0, 0.0);
            }
        }
    }
}
