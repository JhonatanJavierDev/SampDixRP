#include <YSI-Includes\YSI\y_hooks>

#define MAX_NEARS_PLAYERS 20
new
    pNearsPlayers[MAX_PLAYERS][MAX_NEARS_PLAYERS] = {INVALID_PLAYER_ID, ...},
    pNearsPlayers_ID[MAX_PLAYERS] = {-1, ...},
    pNearsPlayers_LastSelectedId[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...},
    pNearsPlayers_LastPrice[MAX_PLAYERS],
    pNearsPlayers_LastAmount[MAX_PLAYERS];

hook OnPlayerDisconnect(playerid, reason) 
{
    for(new i = 0; i < MAX_NEARS_PLAYERS; i ++) 
    {
        pNearsPlayers[playerid][i] = INVALID_PLAYER_ID;
    }
    pNearsPlayers_ID[playerid] = -1;
    pNearsPlayers_LastSelectedId[playerid] = INVALID_PLAYER_ID;
    pNearsPlayers_LastPrice[playerid] = 0;
    pNearsPlayers_LastAmount[playerid] = 0;
}

ShowNearsPlayersToPlayer(playerid, id = -1) 
{
    new dialog_body[64 * MAX_NEARS_PLAYERS] = "", counter = 0;

    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++) 
    {
        if(i == playerid) continue;
        if(IsPlayerConnected(i)) 
        {
            new Float:pos[3];
            GetPlayerPos(i, pos[0], pos[1], pos[2]);
	        if(IsPlayerInRangeOfPoint(playerid, NEARS_PLAYERS_DISTANCE, pos[0], pos[1], pos[2]) && !PLAYER_TEMP[i][pt_SPECTANDO]) 
            {
                new str[64];
                format(str, sizeof str, "- [ID: %d] %s\n", i, PLAYER_TEMP[i][pt_RP_NAME]);
                strcat(dialog_body, str);

                pNearsPlayers[playerid][counter] = i;
                counter ++;
                
                if(counter > MAX_NEARS_PLAYERS) break;
            }
        }
    }

    if(counter > 0) 
    {
        PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
        PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_NEARS_PLAYERS;
        pNearsPlayers_ID[playerid] = id;
        ShowPlayerDialog(playerid, DIALOG_NEARS_PLAYERS, DIALOG_STYLE_LIST, "Jugadores cercanos", dialog_body, "Continuar", "Cerrar");
    }
    else SendNotification(playerid, "No hay jugadores cerca tuya.");
}

stock GetNP_PlayerLastSelectedId(playerid) 
{
    return pNearsPlayers_LastSelectedId[playerid];
}

stock GetNP_PlayerLastPrice(playerid) 
{
    return pNearsPlayers_LastPrice[playerid];
}

stock GetNP_PlayerLastAmount(playerid) 
{
    return pNearsPlayers_LastAmount[playerid];
}

ShowSelectPriceDialog(playerid, id = -1) 
{
    PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
    PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_NEARS_PLAYERS_PRICE;
    pNearsPlayers_ID[playerid] = id;
    ShowPlayerDialog(playerid, DIALOG_NEARS_PLAYERS_PRICE, DIALOG_STYLE_INPUT, "Introduce el precio", "Introduce el precio aquí:", "Continuar", "Cerrar");
}

ShowSelectAmountDialog(playerid, id = -1) 
{
    PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
    PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_NEARS_PLAYERS_AMOUNT;
    pNearsPlayers_ID[playerid] = id;
    ShowPlayerDialog(playerid, DIALOG_NEARS_PLAYERS_AMOUNT, DIALOG_STYLE_INPUT, "Introduce la cantidad", "Introduce la cantidad aquí:", "Continuar", "Cerrar");
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) 
{
    switch(dialogid) 
    {
        case DIALOG_NEARS_PLAYERS: 
        {
            pNearsPlayers_LastSelectedId[playerid] = response ? pNearsPlayers[playerid][listitem] : INVALID_PLAYER_ID;
            if(response) 
            {
                CallLocalFunction("OnNearPlayerSelected", "iii", playerid, pNearsPlayers_LastSelectedId[playerid], pNearsPlayers_ID[playerid]);
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case DIALOG_NEARS_PLAYERS_PRICE: 
        {
            if(response) 
            {
                new amount;
                if(!sscanf(inputtext, "d", amount)) 
                {
                    pNearsPlayers_LastPrice[playerid] = amount;
                    CallLocalFunction("OnPriceSelected", "iii", playerid, pNearsPlayers_LastPrice[playerid], pNearsPlayers_ID[playerid]);
                }
                else ShowSelectPriceDialog(playerid, pNearsPlayers_ID[playerid]);
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case DIALOG_NEARS_PLAYERS_AMOUNT: 
        {
            if(response) 
            {
                new amount;
                if(!sscanf(inputtext, "d", amount)) 
                {
                    pNearsPlayers_LastAmount[playerid] = amount;
                    CallLocalFunction("OnAmountSelected", "iii", playerid, pNearsPlayers_LastAmount[playerid], pNearsPlayers_ID[playerid]);
                }
                else ShowSelectAmountDialog(playerid, pNearsPlayers_ID[playerid]);
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}