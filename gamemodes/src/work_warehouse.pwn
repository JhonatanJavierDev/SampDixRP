#include <YSI-Includes\YSI\y_hooks>

#define WAREHOUSE_INTERIOR 11
#define MAX_WAREHOUSE_ORDERS 50
#define MAX_WAREHOUSE_ORDERS_TD 12
#define SEED_WAREHOUSE_ORDERS_INTERVAL 300000 //5min

new
    Warehouse_AreaId = INVALID_STREAMER_ID,
    Float:Warehouse_OrdersCoords[3] = {1903.424804, -1481.402709, 1398.844238},
    Text:Warehouse_OrdersBaseTd[9],
    Text:Warehouse_OrdersTd[MAX_WAREHOUSE_ORDERS_TD][5] = {{Text:INVALID_TEXT_DRAW, ...}, ...}
;

enum _:E_WarehouseOrdersStatus {
    WORDER_STATUS_NONE,
    WORDER_STATUS_PROCESS,
    WORDER_STATUS_COMPLETED
};

enum _:E_WarehouseOrders {
    worder_ID,
    worder_DATE[24],
    worder_PRODUCTS,
    worder_STATE
};

new List:Warehouse_CurrentOrders;

new Float:Warehouse_PickUpPoints[][3] = {
    {1884.125854, -1497.201293, 1395.599365},
    {1889.180419, -1497.201293, 1395.599365},
    {1882.733520, -1494.107421, 1395.599365},
    {1888.108154, -1494.105834, 1395.599365},
    {1887.912353, -1492.210205, 1395.599365},
    {1882.803100, -1492.212158, 1395.599365},
    {1887.952270, -1489.113159, 1395.599365},
    {1882.819458, -1489.114990, 1395.599365},
    {1882.710327, -1486.930664, 1395.599365},
    {1887.946777, -1486.930664, 1395.599365},
    {1888.031005, -1483.834472, 1395.599365},
    {1882.433227, -1483.835449, 1395.599365},
    {1882.848999, -1481.319702, 1395.599365},
    {1888.141235, -1481.310424, 1395.599365},
    {1902.450805, -1490.450195, 1395.599365},
    {1902.546630, -1487.356323, 1395.599365},
    {1920.524536, -1492.172973, 1395.599365},
    {1917.041259, -1486.268188, 1395.599365},
    {1925.564208, -1483.411376, 1395.599365},
    {1920.208129, -1516.537109, 1394.119384},
    {1914.993164, -1516.703735, 1394.119384},
    {1914.946411, -1513.618286, 1394.119384},
    {1920.330932, -1513.611206, 1394.119384},
    {1905.136474, -1513.611572, 1394.119384},
    {1899.822387, -1513.621826, 1394.119384},
    {1889.405395, -1516.711425, 1394.119384},
    {1885.950927, -1514.620361, 1394.119384},
    {1889.532470, -1513.610473, 1394.119384},
    {1889.642578, -1510.514770, 1394.119384},
    {1884.290405, -1510.513549, 1394.119384},
    {1884.003051, -1508.946533, 1394.119384},
    {1899.740722, -1508.942626, 1394.119384},
    {1899.232421, -1510.513916, 1394.119384},
    {1904.810302, -1508.943969, 1394.119384},
    {1905.165893, -1510.514526, 1394.119384},
    {1908.931640, -1511.262451, 1394.119384},
    {1915.356445, -1508.943847, 1394.119384},
    {1915.272583, -1510.508789, 1394.119384},
    {1920.383544, -1508.943115, 1394.119384},
    {1920.358520, -1510.509643, 1394.119384},
    {1920.450439, -1505.848754, 1394.119384},
    {1915.325439, -1505.847900, 1394.119384},
    {1905.300292, -1505.848144, 1394.119384},
    {1899.216064, -1505.572753, 1394.119384}
};

new Float:Warehouse_PutCoords[3] = {1886.839965, -1503.435791, 1394.119384};

new
    bool:pWarehouseOrders[MAX_PLAYERS],
    PlayerText:pWarehouseOrdersTd[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...},
    pWarehouseCurrentOrder[MAX_PLAYERS],
    pWarehouseCurrentProduct[MAX_PLAYERS],
    pWarehouseCP[MAX_PLAYERS] = {INVALID_STREAMER_ID, ...}
;

hook OnScriptInit() {
    Warehouse_AreaId = CreateDynamicRectangle(1847.117065, -1564.247436, 1975.150146, -1428.235595, 0, WAREHOUSE_INTERIOR);
    Warehouse_CurrentOrders = list_new();

    CreateDynamic3DTextLabel("{FFFFFF}Presiona {11E6E9}[ H ] {FFFFFF}para ver los pedidos disponibles", 0xFFFFFFFF, Warehouse_OrdersCoords[0], Warehouse_OrdersCoords[1], Warehouse_OrdersCoords[2], 10.0, .testlos = true, .interiorid = WAREHOUSE_INTERIOR);

    Warehouse_OrdersBaseTd[0] = TextDrawCreate(180.000000, 110.000000, "LD_SPAC:white");
    TextDrawTextSize(Warehouse_OrdersBaseTd[0], 280.000000, 230.000000);
    TextDrawAlignment(Warehouse_OrdersBaseTd[0], 1);
    TextDrawColor(Warehouse_OrdersBaseTd[0], 255);
    TextDrawSetShadow(Warehouse_OrdersBaseTd[0], 0);
    TextDrawBackgroundColor(Warehouse_OrdersBaseTd[0], 255);
    TextDrawFont(Warehouse_OrdersBaseTd[0], 4);
    TextDrawSetProportional(Warehouse_OrdersBaseTd[0], 0);

    Warehouse_OrdersBaseTd[1] = TextDrawCreate(187.000000, 117.000000, "LD_SPAC:white");
    TextDrawTextSize(Warehouse_OrdersBaseTd[1], 266.000000, 216.000000);
    TextDrawAlignment(Warehouse_OrdersBaseTd[1], 1);
    TextDrawColor(Warehouse_OrdersBaseTd[1], 1010580735);
    TextDrawSetShadow(Warehouse_OrdersBaseTd[1], 0);
    TextDrawBackgroundColor(Warehouse_OrdersBaseTd[1], 255);
    TextDrawFont(Warehouse_OrdersBaseTd[1], 4);
    TextDrawSetProportional(Warehouse_OrdersBaseTd[1], 0);

    Warehouse_OrdersBaseTd[2] = TextDrawCreate(187.000000, 117.000000, "LD_SPAC:white");
    TextDrawTextSize(Warehouse_OrdersBaseTd[2], 266.000000, 30.000000);
    TextDrawAlignment(Warehouse_OrdersBaseTd[2], 1);
    TextDrawColor(Warehouse_OrdersBaseTd[2], 421075455);
    TextDrawSetShadow(Warehouse_OrdersBaseTd[2], 0);
    TextDrawBackgroundColor(Warehouse_OrdersBaseTd[2], 255);
    TextDrawFont(Warehouse_OrdersBaseTd[2], 4);
    TextDrawSetProportional(Warehouse_OrdersBaseTd[2], 0);

    Warehouse_OrdersBaseTd[3] = TextDrawCreate(195.000000, 135.000000, "v");
    TextDrawLetterSize(Warehouse_OrdersBaseTd[3], 2.024249, 0.809776);
    TextDrawTextSize(Warehouse_OrdersBaseTd[3], 201.000000, 0.000000);
    TextDrawAlignment(Warehouse_OrdersBaseTd[3], 1);
    TextDrawColor(Warehouse_OrdersBaseTd[3], -5963521);
    TextDrawSetShadow(Warehouse_OrdersBaseTd[3], 0);
    TextDrawBackgroundColor(Warehouse_OrdersBaseTd[3], 10551551);
    TextDrawFont(Warehouse_OrdersBaseTd[3], 1);
    TextDrawSetProportional(Warehouse_OrdersBaseTd[3], 1);

    Warehouse_OrdersBaseTd[4] = TextDrawCreate(196.000000, 119.000000, "amazon");
    TextDrawLetterSize(Warehouse_OrdersBaseTd[4], 0.420500, 2.256443);
    TextDrawTextSize(Warehouse_OrdersBaseTd[4], 254.000000, 0.000000);
    TextDrawAlignment(Warehouse_OrdersBaseTd[4], 1);
    TextDrawColor(Warehouse_OrdersBaseTd[4], -1);
    TextDrawSetShadow(Warehouse_OrdersBaseTd[4], 0);
    TextDrawBackgroundColor(Warehouse_OrdersBaseTd[4], 255);
    TextDrawFont(Warehouse_OrdersBaseTd[4], 1);
    TextDrawSetProportional(Warehouse_OrdersBaseTd[4], 1);

    Warehouse_OrdersBaseTd[5] = TextDrawCreate(220.250000, 155.000000, "N|_pedido");
    TextDrawLetterSize(Warehouse_OrdersBaseTd[5], 0.183499, 1.086666);
    TextDrawTextSize(Warehouse_OrdersBaseTd[5], 0.000000, 10.000000);
    TextDrawAlignment(Warehouse_OrdersBaseTd[5], 2);
    TextDrawColor(Warehouse_OrdersBaseTd[5], -1);
    TextDrawSetShadow(Warehouse_OrdersBaseTd[5], 0);
    TextDrawSetOutline(Warehouse_OrdersBaseTd[5], 1);
    TextDrawBackgroundColor(Warehouse_OrdersBaseTd[5], 255);
    TextDrawFont(Warehouse_OrdersBaseTd[5], 2);
    TextDrawSetProportional(Warehouse_OrdersBaseTd[5], 1);

    Warehouse_OrdersBaseTd[6] = TextDrawCreate(286.750000, 155.000000, "Fecha_pedido");
    TextDrawLetterSize(Warehouse_OrdersBaseTd[6], 0.183499, 1.086666);
    TextDrawAlignment(Warehouse_OrdersBaseTd[6], 2);
    TextDrawColor(Warehouse_OrdersBaseTd[6], -1);
    TextDrawSetShadow(Warehouse_OrdersBaseTd[6], 0);
    TextDrawSetOutline(Warehouse_OrdersBaseTd[6], 1);
    TextDrawBackgroundColor(Warehouse_OrdersBaseTd[6], 255);
    TextDrawFont(Warehouse_OrdersBaseTd[6], 2);
    TextDrawSetProportional(Warehouse_OrdersBaseTd[6], 1);

    Warehouse_OrdersBaseTd[7] = TextDrawCreate(353.250000, 155.000000, "Productos");
    TextDrawLetterSize(Warehouse_OrdersBaseTd[7], 0.183499, 1.086666);
    TextDrawAlignment(Warehouse_OrdersBaseTd[7], 2);
    TextDrawColor(Warehouse_OrdersBaseTd[7], -1);
    TextDrawSetShadow(Warehouse_OrdersBaseTd[7], 0);
    TextDrawSetOutline(Warehouse_OrdersBaseTd[7], 1);
    TextDrawBackgroundColor(Warehouse_OrdersBaseTd[7], 255);
    TextDrawFont(Warehouse_OrdersBaseTd[7], 2);
    TextDrawSetProportional(Warehouse_OrdersBaseTd[7], 1);

    Warehouse_OrdersBaseTd[8] = TextDrawCreate(419.750000, 155.000000, "Estado");
    TextDrawLetterSize(Warehouse_OrdersBaseTd[8], 0.183499, 1.086666);
    TextDrawAlignment(Warehouse_OrdersBaseTd[8], 2);
    TextDrawColor(Warehouse_OrdersBaseTd[8], -1);
    TextDrawSetShadow(Warehouse_OrdersBaseTd[8], 0);
    TextDrawSetOutline(Warehouse_OrdersBaseTd[8], 1);
    TextDrawBackgroundColor(Warehouse_OrdersBaseTd[8], 255);
    TextDrawFont(Warehouse_OrdersBaseTd[8], 2);
    TextDrawSetProportional(Warehouse_OrdersBaseTd[8], 1);
}

hook OnInfoVarsLoaded() {
    if(WarehouseOrderNum == 0) {
        WarehouseOrderNum = 1;
        SaveInfoVars();
    }
    SeedWarehouseOrders();
}

task OnWarehouseSeedRequest[SEED_WAREHOUSE_ORDERS_INTERVAL]()
{
    SeedWarehouseOrders();
}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
    if(PLAYER_TEMP[playerid][pt_WORKING_IN] == WORK_WAREHOUSE && areaid == Warehouse_AreaId) {
        CallLocalFunction("EndPlayerJob", "iib", playerid, WORK_WAREHOUSE, true);
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

SeedWarehouseOrders(amount = -1) {
    if(amount == -1) {
        amount = MAX_WAREHOUSE_ORDERS - list_size(Warehouse_CurrentOrders);
    }

    if(amount > 0) {
        new date[24];
        getDateTime(date);

        for(new i = 0; i < amount; i ++) {
            if(list_size(Warehouse_CurrentOrders) >= MAX_WAREHOUSE_ORDERS) {
                break;
            }

            new order[E_WarehouseOrders];
            order[worder_ID] = WarehouseOrderNum;
            format(order[worder_DATE], 24, "%s", date);
            order[worder_PRODUCTS] = minrand(1, 5);
            order[worder_STATE] = WORDER_STATUS_NONE;
            list_add_arr(Warehouse_CurrentOrders, order);
            WarehouseOrderNum ++;
        }
        SaveInfoVars();
        UpdateWarehouseOrdersTds();
    }
}

GetWOrderStateTdName(status) {
    new string[128];
    switch(status) {
        case WORDER_STATUS_PROCESS: format(string, sizeof string, "~y~Preparando...");
        case WORDER_STATUS_COMPLETED: format(string, sizeof string, "~g~Completado");
        default: format(string, sizeof string, "Esperando...");
    }
    return string;
}

UpdateWarehouseOrdersTds() {
    for(new i = 0; i < sizeof Warehouse_OrdersTd; i ++) {
        for(new j = 0; j < sizeof Warehouse_OrdersTd[]; j ++) {
            if(Warehouse_OrdersTd[i][j] != Text:INVALID_TEXT_DRAW) {
                TextDrawDestroy(Warehouse_OrdersTd[i][j]);
                Warehouse_OrdersTd[i][j] = Text:INVALID_TEXT_DRAW;
            }
        }
    }

    new Float:currentY = 173.0;
    for(new i = 0; i < list_size(Warehouse_CurrentOrders); i ++) {
        if(i >= MAX_WAREHOUSE_ORDERS_TD) {
            break;
        }

        new order[E_WarehouseOrders], string[128];
        list_get_arr(Warehouse_CurrentOrders, i, order);
        
        Warehouse_OrdersTd[i][0] = TextDrawCreate(320.000000, currentY, "box");
        TextDrawLetterSize(Warehouse_OrdersTd[i][0], 0.000000, 1.000000);
        TextDrawTextSize(Warehouse_OrdersTd[i][0], 10.000000, 262.000000);
        TextDrawAlignment(Warehouse_OrdersTd[i][0], 2);
        TextDrawColor(Warehouse_OrdersTd[i][0], -1);
        TextDrawUseBox(Warehouse_OrdersTd[i][0], 1);
        TextDrawBoxColor(Warehouse_OrdersTd[i][0], -2139062017);
        TextDrawSetShadow(Warehouse_OrdersTd[i][0], 0);
        TextDrawBackgroundColor(Warehouse_OrdersTd[i][0], 255);
        TextDrawFont(Warehouse_OrdersTd[i][0], 1);
        TextDrawSetProportional(Warehouse_OrdersTd[i][0], 1);
        TextDrawSetSelectable(Warehouse_OrdersTd[i][0], true);

        format(string, sizeof string, "%s", number_format_thousand(order[worder_ID]));
        Warehouse_OrdersTd[i][1] = TextDrawCreate(220.25, currentY, string);
        TextDrawLetterSize(Warehouse_OrdersTd[i][1], 0.185500, 0.859555);
        TextDrawTextSize(Warehouse_OrdersTd[i][1], 0.000000, 100.000000);
        TextDrawAlignment(Warehouse_OrdersTd[i][1], 2);
        TextDrawColor(Warehouse_OrdersTd[i][1], -1);
        TextDrawSetShadow(Warehouse_OrdersTd[i][1], 1);
        TextDrawBackgroundColor(Warehouse_OrdersTd[i][1], 255);
        TextDrawFont(Warehouse_OrdersTd[i][1], 1);
        TextDrawSetProportional(Warehouse_OrdersTd[i][1], 1);

        format(string, sizeof string, "%s", order[worder_DATE]);
        Warehouse_OrdersTd[i][2] = TextDrawCreate(286.75, currentY, string);
        TextDrawLetterSize(Warehouse_OrdersTd[i][2], 0.185500, 0.859555);
        TextDrawTextSize(Warehouse_OrdersTd[i][2], 0.000000, 100.000000);
        TextDrawAlignment(Warehouse_OrdersTd[i][2], 2);
        TextDrawColor(Warehouse_OrdersTd[i][2], -1);
        TextDrawSetShadow(Warehouse_OrdersTd[i][2], 1);
        TextDrawBackgroundColor(Warehouse_OrdersTd[i][2], 255);
        TextDrawFont(Warehouse_OrdersTd[i][2], 1);
        TextDrawSetProportional(Warehouse_OrdersTd[i][2], 1);

        format(string, sizeof string, "%d", order[worder_PRODUCTS]);
        Warehouse_OrdersTd[i][3] = TextDrawCreate(353.25, currentY, string);
        TextDrawLetterSize(Warehouse_OrdersTd[i][3], 0.185500, 0.859555);
        TextDrawTextSize(Warehouse_OrdersTd[i][3], 0.000000, 100.000000);
        TextDrawAlignment(Warehouse_OrdersTd[i][3], 2);
        TextDrawColor(Warehouse_OrdersTd[i][3], -1);
        TextDrawSetShadow(Warehouse_OrdersTd[i][3], 1);
        TextDrawBackgroundColor(Warehouse_OrdersTd[i][3], 255);
        TextDrawFont(Warehouse_OrdersTd[i][3], 1);
        TextDrawSetProportional(Warehouse_OrdersTd[i][3], 1);

        format(string, sizeof string, "%s", GetWOrderStateTdName(order[worder_STATE]));
        Warehouse_OrdersTd[i][4] = TextDrawCreate(419.75, currentY, string);
        TextDrawLetterSize(Warehouse_OrdersTd[i][4], 0.185500, 0.859555);
        TextDrawTextSize(Warehouse_OrdersTd[i][4], 0.000000, 100.000000);
        TextDrawAlignment(Warehouse_OrdersTd[i][4], 2);
        TextDrawColor(Warehouse_OrdersTd[i][4], -1);
        TextDrawSetShadow(Warehouse_OrdersTd[i][4], 1);
        TextDrawBackgroundColor(Warehouse_OrdersTd[i][4], 255);
        TextDrawFont(Warehouse_OrdersTd[i][4], 1);
        TextDrawSetProportional(Warehouse_OrdersTd[i][4], 1);

        currentY += 13.0;
    }

    for(new playerid = 0, x = GetPlayerPoolSize(); playerid <= x; playerid ++)
	{
		if(IsPlayerConnected(playerid) && pWarehouseOrders[playerid])
		{
            for(new i = 0; i < sizeof Warehouse_OrdersTd; i ++) {
                for(new j = 0; j < sizeof Warehouse_OrdersTd[]; j ++) {
                    if(Warehouse_OrdersTd[i][j] != Text:INVALID_TEXT_DRAW) {
                        TextDrawShowForPlayer(playerid, Warehouse_OrdersTd[i][j]);
                    }
                }
            }
        }
    }
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_CTRL_BACK) {
        if(IsPlayerInRangeOfPoint(playerid, 1.0, Warehouse_OrdersCoords[0], Warehouse_OrdersCoords[1], Warehouse_OrdersCoords[2])) {
            PC_EmulateCommand(playerid, "/pedidos");
            return Y_HOOKS_BREAK_RETURN_1;
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDisconnect(playerid, reason) {
    DestroyPlayerWarehouseOrders(playerid);
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_SPECTATING || newstate == PLAYER_STATE_WASTED) {
        if(pWarehouseOrders[playerid]) {
		    CancelSelectTextDrawEx(playerid);
        }
	}
	return 1;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid) {
    if(pWarehouseOrders[playerid]) {
        if(clickedid == Text:INVALID_TEXT_DRAW) {
            DestroyPlayerWarehouseOrders(playerid);
        }

        for(new i = 0; i < MAX_WAREHOUSE_ORDERS_TD; i ++) {
            if(clickedid == Warehouse_OrdersTd[i][0]) {
                if(pWarehouseCurrentOrder[playerid] > 0) SendNotification(playerid, "Ahora mismo estás atendiendo un pedido.");
                else {
                    new order[E_WarehouseOrders];
                    list_get_arr(Warehouse_CurrentOrders, i, order);
                    if(order[worder_STATE] == WORDER_STATUS_NONE) {
                        pWarehouseCurrentOrder[playerid] = order[worder_ID];
                        order[worder_STATE] = WORDER_STATUS_PROCESS;
                        list_set_arr(Warehouse_CurrentOrders, i, order);
                        
                        new string[128];
                        format(string, sizeof string, "%s", GetWOrderStateTdName(order[worder_STATE]));
                        TextDrawSetString(Warehouse_OrdersTd[i][4], string);

                        CancelSelectTextDrawEx(playerid);
                        CallLocalFunction("StartPlayerJob", "iii", playerid, WORK_WAREHOUSE, INVALID_VEHICLE_ID);
                    }
                    else {
                        SendNotification(playerid, "Este pedido ya está siendo atendido.");
                    }
                }
                return Y_HOOKS_BREAK_RETURN_1;
            }
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

GetOrderIndexByOrderId(id) {
    for(new i = 0; i < list_size(Warehouse_CurrentOrders); i ++) {
        new tmpOrder[E_WarehouseOrders];
        list_get_arr(Warehouse_CurrentOrders, i, tmpOrder);
        if(tmpOrder[worder_ID] == id) {
            return i;
        }
    }
    return -1;
}

hook StartPlayerJob(playerid, work, vehicleid) {
    if(work == WORK_WAREHOUSE) {
        DisablePlayerArmedWeapons(playerid);

        pWarehouseCurrentProduct[playerid] = 0;
        SetPlayerWarehousePickUpPoint(playerid);
    }
}

SetPlayerWarehousePickUpPoint(playerid, bool:put = false) {
    if(pWarehouseCP[playerid] != INVALID_STREAMER_ID) {
        DestroyDynamicCP(pWarehouseCP[playerid]);
        pWarehouseCP[playerid] = INVALID_STREAMER_ID;
    }

    if(put) {
        pWarehouseCP[playerid] = CreateDynamicCP(Warehouse_PutCoords[0], Warehouse_PutCoords[1], Warehouse_PutCoords[2], 2.0, 0, WAREHOUSE_INTERIOR, playerid, 500.0);
        Streamer_SetArrayData(STREAMER_TYPE_CP, pWarehouseCP[playerid], E_STREAMER_EXTRA_ID, {CHECKPOINT_TYPE_WH_PUT});
        SendNotification(playerid, "Ve a colocar el producto en la cinta transportadora.");
    }
    else {
        new point = random(sizeof Warehouse_PickUpPoints);
        pWarehouseCP[playerid] = CreateDynamicCP(Warehouse_PickUpPoints[point][0], Warehouse_PickUpPoints[point][1], Warehouse_PickUpPoints[point][2], 2.0, 0, WAREHOUSE_INTERIOR, playerid, 500.0);
        Streamer_SetArrayData(STREAMER_TYPE_CP, pWarehouseCP[playerid], E_STREAMER_EXTRA_ID, {CHECKPOINT_TYPE_WH_PICKUP});
        if(pWarehouseCurrentProduct[playerid] == 0) SendNotification(playerid, "Ve a coger el primer producto.");
        else SendNotification(playerid, "Ve a coger el siguiente producto.");
    }
    Streamer_Update(playerid, STREAMER_TYPE_CP);
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	new info[1];
	Streamer_GetArrayData(STREAMER_TYPE_CP, checkpointid, E_STREAMER_EXTRA_ID, info);

	switch(info[0])
	{
		case CHECKPOINT_TYPE_WH_PICKUP: {
            SetPlayerArmedWeapon(playerid, 0);
            RemovePlayerAttachedObject(playerid, 8);
	        SetPlayerAttachedObject(playerid, 8, 1220, 5, 0.020000, 0.150999, 0.184000, 8.100003, 20.200000, 5.300002, 0.494000, 0.450000, 0.531000);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
            SetPlayerWarehousePickUpPoint(playerid, true);
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case CHECKPOINT_TYPE_WH_PUT: {
            RemovePlayerAttachedObject(playerid, 8);
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

            new tmpObjectid = CreateDynamicObject(1220, 1886.447753, -1501.565673, 1394.439697, 0.000000, 0.000000, float(random(360)), .interiorid = WAREHOUSE_INTERIOR);
            new objInfo[3];
            objInfo[0] = OBJECT_TYPE_WH_BOX;
            objInfo[1] = pWarehouseCurrentOrder[playerid];
            Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tmpObjectid, E_STREAMER_EXTRA_ID, objInfo);
            MoveDynamicObject(tmpObjectid, 1927.371459, -1501.565673, 1394.439697, 1.2);
            Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

            new orderIndex = GetOrderIndexByOrderId(pWarehouseCurrentOrder[playerid]);
            if(orderIndex != -1) {
                new order[E_WarehouseOrders];
                list_get_arr(Warehouse_CurrentOrders, orderIndex, order);

                pWarehouseCurrentProduct[playerid] ++;
                if(pWarehouseCurrentProduct[playerid] >= order[worder_PRODUCTS]) {
                    order[worder_STATE] = WORDER_STATUS_COMPLETED;
                    list_set_arr(Warehouse_CurrentOrders, orderIndex, order);

                    new string[128];
                    format(string, sizeof string, "%s", GetWOrderStateTdName(order[worder_STATE]));
                    TextDrawSetString(Warehouse_OrdersTd[orderIndex][4], string);

                    pWarehouseCurrentOrder[playerid] = 0;
                    PLAYER_WORKS[playerid][WORK_WAREHOUSE][pwork_LEVEL] ++;
                    AddPlayerJobPoints(playerid, WORK_WAREHOUSE);
                    
                    new work_extra_payment;
                    if(work_info[WORK_WAREHOUSE][work_info_EXTRA_PAY] > 0 && work_info[WORK_WAREHOUSE][work_info_EXTRA_PAY_EXP] > 0)
                    {
                        work_extra_payment = (work_info[WORK_WAREHOUSE][work_info_EXTRA_PAY] * floatround(floatdiv(PLAYER_WORKS[playerid][WORK_WAREHOUSE][pwork_LEVEL], work_info[WORK_WAREHOUSE][work_info_EXTRA_PAY_EXP])));
                        if(work_info[WORK_WAREHOUSE][work_info_EXTRA_PAY_LIMIT] != 0) if(work_extra_payment > work_info[WORK_WAREHOUSE][work_info_EXTRA_PAY_LIMIT]) work_extra_payment = work_info[WORK_WAREHOUSE][work_info_EXTRA_PAY_LIMIT];
                        
                        if(PI[playerid][pi_VIP]) work_extra_payment += SU_WORK_EXTRA_PAY;
                    }
                    new amount = (minrand(40, 50) * order[worder_PRODUCTS]) + work_extra_payment;
                    GivePlayerCash(playerid, amount, true, false);
                    
                    format(string, sizeof string, "~g~+%d$", amount);
                    GameTextForPlayer(playerid, string, 5000, 1);
                    CallLocalFunction("EndPlayerJob", "iib", playerid, WORK_WAREHOUSE, true);
                }
                else {
                    SetPlayerWarehousePickUpPoint(playerid);
                }
            }
            else CallLocalFunction("EndPlayerJob", "iib", playerid, WORK_WAREHOUSE, true);
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook EndPlayerJob(playerid, work, bool:changeskin) {
    if(work == WORK_WAREHOUSE) {
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerToys(playerid);

        if(pWarehouseCurrentOrder[playerid] != 0) {
            new orderIndex = GetOrderIndexByOrderId(pWarehouseCurrentOrder[playerid]);
            if(orderIndex != -1) {
                new order[E_WarehouseOrders];
                list_get_arr(Warehouse_CurrentOrders, orderIndex, order);
                if(order[worder_STATE] != WORDER_STATUS_COMPLETED) {
                    order[worder_STATE] = WORDER_STATUS_NONE;
                    list_set_arr(Warehouse_CurrentOrders, orderIndex, order);

                    new string[128];
                    format(string, sizeof string, "%s", GetWOrderStateTdName(order[worder_STATE]));
                    TextDrawSetString(Warehouse_OrdersTd[orderIndex][4], string);
                }
            }
        }

        pWarehouseCurrentOrder[playerid] = 0;
        pWarehouseCurrentProduct[playerid] = 0;
        if(pWarehouseCP[playerid] != INVALID_STREAMER_ID) {
            DestroyDynamicCP(pWarehouseCP[playerid]);
            pWarehouseCP[playerid] = INVALID_STREAMER_ID;
        }
    }
}

hook OnDynamicObjectMoved(objectid) {
    new info[3];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, info);
    if(info[0] == OBJECT_TYPE_WH_BOX) {
        DestroyDynamicObject(objectid);
        new orderIndex = GetOrderIndexByOrderId(info[1]);
        if(orderIndex != -1) {
            new order[E_WarehouseOrders];
            list_get_arr(Warehouse_CurrentOrders, orderIndex, order);
            if(order[worder_STATE] == WORDER_STATUS_COMPLETED) {
                list_remove(Warehouse_CurrentOrders, orderIndex);
                UpdateWarehouseOrdersTds();
            }
        }
        return Y_HOOKS_BREAK_RETURN_1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

CMD:pedidos(playerid, params[]) {
    if(!PLAYER_WORKS[playerid][WORK_WAREHOUSE][pwork_SET]) return SendNotification(playerid, "No trabajas en el almacén.");
	if(PLAYER_TEMP[playerid][pt_WORKING_IN] != WORK_NONE && PLAYER_TEMP[playerid][pt_WORKING_IN] != WORK_WAREHOUSE)
	{
		SendFormatNotification(playerid, "Tienes que dejar de estar de servicio como %s primero.", work_info[ PLAYER_TEMP[playerid][pt_WORKING_IN] ][work_info_NAME]);
		return 1;
	}

    if(GetPlayerVirtualWorld(playerid) != 0) return SendNotification(playerid, "No estás en el lugar adecuado.");
	if(GetPlayerInterior(playerid) != WAREHOUSE_INTERIOR) return SendNotification(playerid, "No estás en el lugar adecuado.");
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendNotification(playerid, "No estás depie.");
	if(!IsPlayerInRangeOfPoint(playerid, 1.0, Warehouse_OrdersCoords[0], Warehouse_OrdersCoords[1], Warehouse_OrdersCoords[2])) return SendNotification(playerid, "No estás en el lugar adecuado.");

    ShowPlayerWarehouseOrders(playerid);
    return 1;
}

DestroyPlayerWarehouseOrders(playerid) {
    for(new i = 0; i < sizeof Warehouse_OrdersBaseTd; i ++) {
        TextDrawHideForPlayer(playerid, Warehouse_OrdersBaseTd[i]);
    }
    for(new i = 0; i < sizeof Warehouse_OrdersTd; i ++) {
        for(new j = 0; j < sizeof Warehouse_OrdersTd[]; j ++) {
            if(Warehouse_OrdersTd[i][j] != Text:INVALID_TEXT_DRAW) {
                TextDrawHideForPlayer(playerid, Warehouse_OrdersTd[i][j]);
            }
        }
    }
    if(pWarehouseOrdersTd[playerid] != PlayerText:INVALID_TEXT_DRAW) {
        PlayerTextDrawDestroy(playerid, pWarehouseOrdersTd[playerid]);
        pWarehouseOrdersTd[playerid] = PlayerText:INVALID_TEXT_DRAW;
    }
    pWarehouseOrders[playerid] = false;
}

ShowPlayerWarehouseOrders(playerid) {
    DestroyPlayerWarehouseOrders(playerid);

    for(new i = 0; i < sizeof Warehouse_OrdersBaseTd; i ++) {
        TextDrawShowForPlayer(playerid, Warehouse_OrdersBaseTd[i]);
    }

    for(new i = 0; i < sizeof Warehouse_OrdersTd; i ++) {
        for(new j = 0; j < sizeof Warehouse_OrdersTd[]; j ++) {
            if(Warehouse_OrdersTd[i][j] != Text:INVALID_TEXT_DRAW) {
                TextDrawShowForPlayer(playerid, Warehouse_OrdersTd[i][j]);
            }
        }
    }

    new string[128];
    format(string, sizeof string, "%s~n~Almacén_(%04d)~n~", PI[playerid][pi_NAME], PI[playerid][pi_ID]);
    FixTextDrawString(string);
    pWarehouseOrdersTd[playerid] = CreatePlayerTextDraw(playerid, 446.000000, 122.000000, string);
    PlayerTextDrawLetterSize(playerid, pWarehouseOrdersTd[playerid], 0.188499, 0.993333);
    PlayerTextDrawAlignment(playerid, pWarehouseOrdersTd[playerid], 3);
    PlayerTextDrawColor(playerid, pWarehouseOrdersTd[playerid], -1);
    PlayerTextDrawSetShadow(playerid, pWarehouseOrdersTd[playerid], 0);
    PlayerTextDrawSetOutline(playerid, pWarehouseOrdersTd[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, pWarehouseOrdersTd[playerid], 255);
    PlayerTextDrawFont(playerid, pWarehouseOrdersTd[playerid], 1);
    PlayerTextDrawSetProportional(playerid, pWarehouseOrdersTd[playerid], 1);
    PlayerTextDrawShow(playerid, pWarehouseOrdersTd[playerid]);

    pWarehouseOrders[playerid] = true;
    SelectTextDrawEx(playerid, -1);
}