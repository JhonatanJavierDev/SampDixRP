#include <YSI-Includes\YSI\y_hooks>

#define DEFAULT_KEY_PRESS_TOUCHS 20

new
    bool:pInKeyPress[MAX_PLAYERS],
    pKeyPressCurrentKey[MAX_PLAYERS],
    pKeyPressCurrentTouchs[MAX_PLAYERS],
    pKeyPressTouchs[MAX_PLAYERS],
    PlayerText:pKeyPressTd[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};

enum E_KeyPress_Keys 
{
    keypress_KEY,
    keypress_KEYNAME[64]
};

new KeyPress_Keys[][E_KeyPress_Keys] = 
{
    {KEY_CROUCH, "~k~~PED_DUCK~"},
    {KEY_SPRINT, "~k~~PED_SPRINT~"},
    {KEY_SECONDARY_ATTACK, "~k~~VEHICLE_ENTER_EXIT~"},
    //{KEY_YES, "~k~~CONVERSATION_YES~"},
    {KEY_CTRL_BACK, "~k~~GROUP_CONTROL_BWD~"}
};

forward OnPlayerKeyPressFinish(playerid);
forward OnPlayerKeyPress(playerid, Float:percentage);

hook OnPlayerDisconnect(playerid, reason) 
{
    DestroyPlayerKeyPress(playerid);
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_SPECTATING || newstate == PLAYER_STATE_WASTED) 
    {
        if(pInKeyPress[playerid]) 
        {
		    DestroyPlayerKeyPress(playerid);
        }
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
    if(pInKeyPress[playerid] && newkeys & KeyPress_Keys[ pKeyPressCurrentKey[playerid] ][keypress_KEY]) 
    {
        pKeyPressCurrentTouchs[playerid] ++;
        UpdatePlayerKeyPress(playerid, true);
        return Y_HOOKS_BREAK_RETURN_1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

SetPlayerKeyPress(playerid, touchs = DEFAULT_KEY_PRESS_TOUCHS) 
{
    DestroyPlayerKeyPress(playerid);

    pKeyPressTd[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 350.000000, "_");
    PlayerTextDrawLetterSize(playerid, pKeyPressTd[playerid], 0.233249, 1.198665);
    PlayerTextDrawTextSize(playerid, pKeyPressTd[playerid], 0.000000, 200.000000);
    PlayerTextDrawAlignment(playerid, pKeyPressTd[playerid], 2);
    PlayerTextDrawColor(playerid, pKeyPressTd[playerid], -1);
    PlayerTextDrawSetShadow(playerid, pKeyPressTd[playerid], 0);
    PlayerTextDrawSetOutline(playerid, pKeyPressTd[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, pKeyPressTd[playerid], 255);
    PlayerTextDrawFont(playerid, pKeyPressTd[playerid], 1);
    PlayerTextDrawSetProportional(playerid, pKeyPressTd[playerid], 1);
    PlayerTextDrawShow(playerid, pKeyPressTd[playerid]);

    pKeyPressCurrentKey[playerid] = random(sizeof KeyPress_Keys);
    pKeyPressTouchs[playerid] = touchs;
    pInKeyPress[playerid] = true;
    UpdatePlayerKeyPress(playerid);
}

UpdatePlayerKeyPress(playerid, bool:callback = false) 
{
    if(pKeyPressCurrentTouchs[playerid] > pKeyPressTouchs[playerid]) 
    {
        DestroyPlayerKeyPress(playerid);
        CallLocalFunction("OnPlayerKeyPressFinish", "i", playerid);
    }
    else 
    {
        new Float:percentage = (pKeyPressCurrentTouchs[playerid] * 100.0) / pKeyPressTouchs[playerid];
        if(percentage > 100.0) percentage = 100.0;

        new string[128];
        format(string, sizeof string, "~w~Pulsa ~y~%s ~w~repetidamente~n~~n~~w~Progreso ~y~%.1f%%", KeyPress_Keys[ pKeyPressCurrentKey[playerid] ][keypress_KEYNAME], percentage);
        PlayerTextDrawSetString(playerid, pKeyPressTd[playerid], string);

        if(callback) 
        {
            CallLocalFunction("OnPlayerKeyPress", "if", playerid, percentage);
        }
    }
}

DestroyPlayerKeyPress(playerid) 
{
    pInKeyPress[playerid] = false;
    pKeyPressCurrentKey[playerid] = 0;
    pKeyPressCurrentTouchs[playerid] = 0;
    pKeyPressTouchs[playerid] = 0;
    if(pKeyPressTd[playerid] != PlayerText:INVALID_TEXT_DRAW) 
    {
        PlayerTextDrawDestroy(playerid, pKeyPressTd[playerid]);
        pKeyPressTd[playerid] = PlayerText:INVALID_TEXT_DRAW;
    }
}