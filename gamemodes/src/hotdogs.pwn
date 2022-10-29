#include <YSI-Includes\YSI\y_hooks>

enum E_Hotdogs 
{
    Float:hotdog_X,
    Float:hotdog_Y,
    Float:hotdog_Z,
    Float:hotdog_RZ,
    hotdog_INTERIOR,
    hotdog_WORLD
};

new Hotdogs[][E_Hotdogs] = 
{
    {1521.081787, -1740.334472, 13.662808, 90.0, 0, 0},
    {2076.462158, -1759.976562, 13.663937, 90.000000, 0, 0},
    {-499.431182, -560.542968, 25.653444, 90.000000, 0, 0},
    {672.445739, -1387.844970, 13.718844, 270.000000, 0, 0},
    {1004.998291, -951.281860, 42.287918, 275.000000, 0, 0},
    {1697.033081, -1154.006103, 23.958143, 270.000000, 0, 0},
    {2721.436523, -1948.906738, 13.671932, 180.000000, 0, 0},
    {1953.953979, -2151.578125, 13.686879, 0.000000, 0, 0},
    {2392.177490, -1740.385864, 13.666885, 90.000000, 0, 0},
    {1839.420288, -1474.359985, 13.693675, 0.000000, 0, 0},
    {1364.806396, -1292.429077, 13.672823, 180.000000, 0, 0},
    {674.251159, -568.583679, 16.455949, 0.000000, 0, 0},
    {101.561309, -219.333221, 1.708124, 90.000000, 0, 0},
    {240.305068, -48.383594, 1.748123, 180.000000, 0, 0},
    {-1030.976074, -590.944030, 32.127834, 270.000000, 0, 0},
    {-1762.685913, -123.803474, 3.684686, 450.000000, 0, 0},
    {-1993.996704, 322.070098, 35.281845, 0.000000, 0, 0},
    {-1569.109497, 709.428955, 7.319067, 0.000000, 0, 0},
    {-2009.026977, 1165.813598, 45.566799, 90.000000, 0, 0},
    {-2440.959472, 715.646850, 35.298988, 270.000000, 0, 0},
    {-2700.117919, 233.730590, 4.449691, 180.000000, 0, 0},
    {-283.546203, 1080.777709, 19.854410, 0.000000, 0, 0},
    {62.097099, 1190.318969, 18.951538, 90.000000, 0, 0},
    {2497.755126, 1260.518798, 10.951885, 270.000000, 0, 0},
    {1719.540771, 1441.272949, 10.906860, 180.000000, 0, 0},
    {2080.139892, 1693.435546, 10.940316, 180.000000, 0, 0},
    {2547.513916, 2105.779785, 10.941873, 90.000000, 0, 0},
    {1968.899780, 765.874511, 10.950318, 90.000000, 0, 0},
    {1021.664428, -1047.171020, 31.728750, 90.000000, 0, 0},
    {1887.724365, -2059.629394, 13.676881, 90.000000, 0, 0},
    {2220.215820, 34.278121, 26.625968, 90.000000, 0, 0},
    {2511.083251, 48.616699, 26.614383, 270.000000, 0, 0},
    {1336.745727, 2597.810791, 10.940318, 270.000000, 0, 0}
};

enum E_HotdogsFood 
{
    hotdogFood_NAME[24],
    hotdogFood_PRICE,
	Float:hotdogFood_HUNGRY,
	Float:hotdogFood_THIRST,
	hotdogFood_DRUNK
};

new HotdogsFood[][E_HotdogsFood] = 
{
    {"Botella de agua mineral", 80, 0.0, 25.0, 0},
	{"Lata de refresco Sprunk", 40, 0.0, 12.0, 0},
	{"Lata de refresco cola", 30, 0.0, 10.0, 0},
    {"Perrito caliente", 50, 20.0, 0.0, 0},
	{"Porcion de pizza", 50, 20.0, 0.0, 0},
	{"Ensalada", 50, 15.0, 2.0, 0},
	{"Sandwich", 45, 10.0, 2.0, 0},
	{"Lata de cerveza", 40, 0.0, 3.0, 1000}
};

hook OnScriptInit() 
{
    for(new i = 0; i < sizeof Hotdogs; i ++) 
    {
        new tmp = CreateDynamicObject(1340, Hotdogs[i][hotdog_X], Hotdogs[i][hotdog_Y], Hotdogs[i][hotdog_Z], 0.0, 0.0, Hotdogs[i][hotdog_RZ], .interiorid = Hotdogs[i][hotdog_INTERIOR], .worldid = Hotdogs[i][hotdog_WORLD], .streamdistance = 600.0, .drawdistance = 600.0);
        SetDynamicObjectMaterial(tmp, 0, -1, "none", "none", 0xFFFFFFFF);

        new Float:pos[3], Float:rz = Hotdogs[i][hotdog_RZ];
        rz += 90.0;
        pos[0] = Hotdogs[i][hotdog_X] + (1.0 * floatsin(-rz, degrees));
        pos[1] = Hotdogs[i][hotdog_Y] + (1.0 * floatcos(-rz, degrees));
        pos[2] = Hotdogs[i][hotdog_Z];
        CreateDynamicActor(168, pos[0], pos[1], pos[2], rz + 180.0, .interiorid = Hotdogs[i][hotdog_INTERIOR], .worldid = Hotdogs[i][hotdog_WORLD]);

        pos[0] = Hotdogs[i][hotdog_X] - (1.0 * floatsin(-rz, degrees));
        pos[1] = Hotdogs[i][hotdog_Y] - (1.0 * floatcos(-rz, degrees));
        CreateDynamic3DTextLabel("{"#PRIMARY_COLOR"}Puesto de comida rápida\n·{FFFFFF}Acercate para comprar comida", COLOR_PRINCIPAL, pos[0], pos[1], pos[2], 5.0, .testlos = true, .interiorid = Hotdogs[i][hotdog_INTERIOR], .worldid = Hotdogs[i][hotdog_WORLD]);

        new info[3], pickupId = CreateDynamicPickup(1582, 1, pos[0], pos[1], pos[2] - 0.5, .interiorid = Hotdogs[i][hotdog_INTERIOR], .worldid = Hotdogs[i][hotdog_WORLD]);
		info[0] = PICKUP_TYPE_HOTDOG;
		info[1] = i; // Index
		info[2] = 0; // Nada
		Streamer_SetArrayData(STREAMER_TYPE_PICKUP, pickupId, E_STREAMER_EXTRA_ID, info);
    }
}

CMD:comida(playerid, params[])
{
	if(PLAYER_TEMP[playerid][pt_LAST_PICKUP_ID] == 0) return SendNotification(playerid, "No estás en el lugar adecuado.");

	new info[3];
	Streamer_GetArrayData(STREAMER_TYPE_PICKUP, PLAYER_TEMP[playerid][pt_LAST_PICKUP_ID], E_STREAMER_EXTRA_ID, info);
    if(info[0] != PICKUP_TYPE_HOTDOG) return SendNotification(playerid, "No estás en el lugar adecuado.");

    new Float:pos[3];
    Streamer_GetFloatData(STREAMER_TYPE_PICKUP, PLAYER_TEMP[playerid][pt_LAST_PICKUP_ID], E_STREAMER_X, pos[0]);
    Streamer_GetFloatData(STREAMER_TYPE_PICKUP, PLAYER_TEMP[playerid][pt_LAST_PICKUP_ID], E_STREAMER_Y, pos[1]);
    Streamer_GetFloatData(STREAMER_TYPE_PICKUP, PLAYER_TEMP[playerid][pt_LAST_PICKUP_ID], E_STREAMER_Z, pos[2]);

    if(!IsPlayerInRangeOfPoint(playerid, 2.0, pos[0], pos[1], pos[2])) return SendNotification(playerid, "No estás en el lugar adecuado.");
	
    new dialog_body[64 * sizeof HotdogsFood];
    format(dialog_body, sizeof dialog_body, "{FFFFFF}Producto\t{FFFFFF}Precio\n");
	for(new i = 0; i != sizeof HotdogsFood; i ++)
	{
        new str[64];
		format(str, sizeof(str), "%d. %s\t%d$\n", i + 1, HotdogsFood[i][hotdogFood_NAME], HotdogsFood[i][hotdogFood_PRICE]);
		strcat(dialog_body, str);
	}

    PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
    PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_HOTDOG;
    ShowPlayerDialog(playerid, DIALOG_HOTDOG, DIALOG_STYLE_TABLIST_HEADERS, "{11E6E9}Puesto de comida rápida", dialog_body, "Comprar", "Cerrar");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) 
{
    if(dialogid == DIALOG_HOTDOG) 
    {
        if(response) 
        {
            if(GivePlayerCash(playerid, -HotdogsFood[listitem][hotdogFood_PRICE], true, true)) 
            {
                Add_Hungry_Thirst(playerid, HotdogsFood[listitem][hotdogFood_HUNGRY], HotdogsFood[listitem][hotdogFood_THIRST]);
                if(HotdogsFood[listitem][hotdogFood_DRUNK] > 0) 
                {
                    GivePlayerDrunkLevel(playerid, HotdogsFood[listitem][hotdogFood_DRUNK]);
                }
                PlayerPlaySoundEx(playerid, 1058, 0.0, 0.0, 0.0);
                
                new action[64];
                format(action, sizeof action, "compra %s y lo consume.", HotdogsFood[listitem][hotdogFood_NAME]);
                Auto_SendPlayerAction(playerid, action);
                
                ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 0, 0, 0, 0, 0, 0);
                ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.1, false, true, true, false, 1000);
            }
            else SendClientMessage(playerid, -1, "{"#SILVER_COLOR"}No tienes suficiente dinero.");
        }
        return Y_HOOKS_BREAK_RETURN_1;
    }
    return Y_HOOKS_CONTINUE_RETURN_0;
}
