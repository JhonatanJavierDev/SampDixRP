#include <YSI-Includes\YSI\y_hooks>

#define MAX_INVENTORY_ITEMS 16
#define MAX_INVENTORY_BUTTONS 6
#define INVENTORY_ROWS 4
#define INVENTORY_SECTIONS 4

enum E_InventoryItemsType
{
    INV_TYPE_MONEY,
    INV_TYPE_COINS,
    INV_TYPE_DRIVER_LICENSE,
    INV_TYPE_PHONE,
    INV_TYPE_MP3,
    INV_TYPE_JETPACK,
    INV_TYPE_PHONE_RESOLVER,
    INV_TYPE_SPEAKERS,
    INV_TYPE_MECANICO_PIECES,
    INV_TYPE_FUEL_DRUM,
    INV_TYPE_MEDICINE_SEEDS,
    INV_TYPE_CANNABIS_SEEDS,
    INV_TYPE_CRACK_SEEDS,
    INV_TYPE_MEDICINE,
    INV_TYPE_CANNABIS,
    INV_TYPE_CRACK,
    INV_TYPE_MECANICO_KITS,
    INV_TYPE_MEDICAL_KITS,

    INV_TYPE_POCKET,
    INV_TYPE_TOY,
    INV_TYPE_WEAPON
};

enum E_InventoryButtonsType
{
    INV_BUTTON_TYPE_NONE,
    INV_BUTTON_TYPE_USE,
    INV_BUTTON_TYPE_GIVE,
    INV_BUTTON_TYPE_SELL,
    INV_BUTTON_TYPE_SHOW,
    INV_BUTTON_TYPE_THROW,
    INV_BUTTON_TYPE_SAVE
};

enum E_pInventoryItems 
{
    bool:pinv_VALID,
    pinv_NAME[64],
    pinv_MODELID,
    Float:pinv_MDL_RX,
    Float:pinv_MDL_RY,
    Float:pinv_MDL_RZ,
    Float:pinv_MDL_ZOOM,
    E_InventoryItemsType:pinv_TYPE,
    E_InventoryButtonsType:pinv_BUTTONS[MAX_INVENTORY_BUTTONS],
    pinv_INDEX
};

new
    pInventoryOpened[MAX_PLAYERS],
    pInventoryCurrentSection[MAX_PLAYERS],
    pInventoryItems[MAX_PLAYERS][INVENTORY_SECTIONS][MAX_INVENTORY_ITEMS][E_pInventoryItems],
    pInventorySelectedItem[MAX_PLAYERS][E_pInventoryItems],
    E_InventoryButtonsType:pInventroySelectedButton[MAX_PLAYERS];

new
    Text:inventoryBaseTds[2],
    PlayerText:pInventoryCategoryButtonsTd[MAX_PLAYERS][INVENTORY_SECTIONS] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...},
    PlayerText:pInventoryItems_BgTd[MAX_PLAYERS][MAX_INVENTORY_ITEMS] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...},
    PlayerText:pInventoryItems_MdTd[MAX_PLAYERS][MAX_INVENTORY_ITEMS] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...},
    PlayerText:pInventoryItems_NameTd[MAX_PLAYERS][MAX_INVENTORY_ITEMS] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...};

#define INVENTORY_PRIMARY_COLOR 0x0A9C95FF
#define INVENTORY_BACKGROUND_COLOR 150
#define INVENTORY_TEXT_COLOR -1
#define INVENTORY_SELECTED_TEXT_COLOR 0xfce679FF
#define INVENTORY_ITEM_COLOR 0x4a4a4aFF
#define INVENTORY_SELECT_TEXTDRAW_COLOR 0xFFFFFFFF

#define INVENTORY_LETTER_PROPORTION 0.216
#define INVENTORY_DEFAULT_MARGIN 2.0
#define INVENTORY_DEFAULT_PADDING 1.0

#define INVENTORY_POS_X 553.0
#define INVENTORY_POS_Y 342.0
#define INVENTORY_TITLE_HEADER_SIZE_Y 12.0
#define INVENTORY_HEADERS_SIZE_Y 8.0
#define INVENTORY_PLACEHOLDERS_SIZE_Y 9.0

#define INVENTORY_ITEM_SIZE_X 25.0
#define INVENTORY_ITEM_SIZE_Y 30.0

new
    invItemsPerRow,
    Float:invSizeX,
    Float:invSizeY,
    Float:invPosX,
    Float:invPosY;

hook OnScriptInit()
{
    invItemsPerRow = MAX_INVENTORY_ITEMS / INVENTORY_ROWS;
    invSizeX =
        INVENTORY_DEFAULT_MARGIN +
        (invItemsPerRow * (INVENTORY_ITEM_SIZE_X + INVENTORY_DEFAULT_MARGIN));
    invSizeY =
        INVENTORY_TITLE_HEADER_SIZE_Y +
        INVENTORY_DEFAULT_MARGIN +
        INVENTORY_HEADERS_SIZE_Y +
        INVENTORY_DEFAULT_MARGIN +
        (INVENTORY_ROWS * (INVENTORY_ITEM_SIZE_Y + INVENTORY_DEFAULT_MARGIN));
    invPosX = INVENTORY_POS_X - (invSizeX / 2.0);
    invPosY = INVENTORY_POS_Y - (invSizeY / 2.0);

    inventoryBaseTds[0] = TextDrawCreate(invPosX, invPosY, "LD_SPAC:white");
    TextDrawTextSize(inventoryBaseTds[0], invSizeX, invSizeY);
    TextDrawAlignment(inventoryBaseTds[0], 1);
    TextDrawColor(inventoryBaseTds[0], INVENTORY_BACKGROUND_COLOR);
    TextDrawSetShadow(inventoryBaseTds[0], 0);
    TextDrawBackgroundColor(inventoryBaseTds[0], 255);
    TextDrawFont(inventoryBaseTds[0], 4);
    TextDrawSetProportional(inventoryBaseTds[0], 0);

    inventoryBaseTds[1] = TextDrawCreate(INVENTORY_POS_X, invPosY, "Inventario");
    TextDrawLetterSize(inventoryBaseTds[1], INVENTORY_LETTER_PROPORTION * (INVENTORY_TITLE_HEADER_SIZE_Y / 10.0), INVENTORY_TITLE_HEADER_SIZE_Y / 10.0);
    TextDrawTextSize(inventoryBaseTds[1], INVENTORY_TITLE_HEADER_SIZE_Y, invSizeX - 2.5);
    TextDrawAlignment(inventoryBaseTds[1], 2);
    TextDrawColor(inventoryBaseTds[1], INVENTORY_TEXT_COLOR);
    TextDrawUseBox(inventoryBaseTds[1], 1);
    TextDrawBoxColor(inventoryBaseTds[1], INVENTORY_PRIMARY_COLOR);
    TextDrawSetShadow(inventoryBaseTds[1], 0);
    TextDrawSetOutline(inventoryBaseTds[1], 0);
    TextDrawBackgroundColor(inventoryBaseTds[1], 255);
    TextDrawFont(inventoryBaseTds[1], 1);
    TextDrawSetProportional(inventoryBaseTds[1], 1);
}

hook OnPlayerDisconnect(playerid, reason) 
{
    pInventoryCurrentSection[playerid] = 0;
    DestroyPlayerInventory_TD(playerid);
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_SPECTATING || newstate == PLAYER_STATE_WASTED) 
    {
        if(pInventoryOpened[playerid]) 
        {
		    CancelSelectTextDrawEx(playerid);
        }
	}
	return 1;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid) 
{
    if(clickedid == Text:INVALID_TEXT_DRAW && pInventoryOpened[playerid]) 
    {
        DestroyPlayerInventory_TD(playerid);
    }
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) 
{
    if(pInventoryOpened[playerid])
    {
        for(new i = 0; i < sizeof pInventoryCategoryButtonsTd[]; i ++) 
        {
            if(playertextid == pInventoryCategoryButtonsTd[playerid][i] && pInventoryCurrentSection[playerid] != i) 
            {
                SetPlayerInventorySection(playerid, i);
                return Y_HOOKS_BREAK_RETURN_1;
            }
        }

        for(new i = 0; i < sizeof pInventoryItems_BgTd[]; i ++) 
        {
            if(playertextid == pInventoryItems_BgTd[playerid][i] || playertextid == pInventoryItems_NameTd[playerid][i]) 
            {
                OnPlayerClickInventoryItem(playerid, pInventoryCurrentSection[playerid], i);
                return Y_HOOKS_BREAK_RETURN_1;
            }
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
    if(newkeys & KEY_NO && PLAYER_TEMP[playerid][pt_GAME_STATE] == GAME_STATE_NORMAL) 
    {
        PC_EmulateCommand(playerid, "/inventario");
    }
}

ClearPlayerInventory(playerid) 
{
    new tmp_pInventoryItems[E_pInventoryItems];
    for(new i = 0; i < INVENTORY_SECTIONS; i ++) 
    {
        for(new j = 0; j < MAX_INVENTORY_ITEMS; j ++) 
        {
            pInventoryItems[playerid][i][j] = tmp_pInventoryItems;
        }
    }
}

DestroyPlayerInventoryTextDraws(playerid) 
{
    for(new i = 0; i < sizeof pInventoryCategoryButtonsTd[]; i ++) 
    {
        if(pInventoryCategoryButtonsTd[playerid][i] != PlayerText:INVALID_TEXT_DRAW) 
        {
            PlayerTextDrawDestroy(playerid, pInventoryCategoryButtonsTd[playerid][i]);
            pInventoryCategoryButtonsTd[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
        }
    }
    
    for(new i = 0; i < sizeof pInventoryItems_BgTd[]; i ++) 
    {
        if(pInventoryItems_BgTd[playerid][i] != PlayerText:INVALID_TEXT_DRAW) 
        {
            PlayerTextDrawDestroy(playerid, pInventoryItems_BgTd[playerid][i]);
            pInventoryItems_BgTd[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
        }

        if(pInventoryItems_MdTd[playerid][i] != PlayerText:INVALID_TEXT_DRAW) 
        {
            PlayerTextDrawDestroy(playerid, pInventoryItems_MdTd[playerid][i]);
            pInventoryItems_MdTd[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
        }

        if(pInventoryItems_NameTd[playerid][i] != PlayerText:INVALID_TEXT_DRAW) 
        {
            PlayerTextDrawDestroy(playerid, pInventoryItems_NameTd[playerid][i]);
            pInventoryItems_NameTd[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
        }
    }
}

GetInventorySectionName(section) 
{
    new name[32] = "general";
    switch(section) 
    {
        case 1: name = "comida";
        case 2: name = "prendas";
        case 3: name = "armas";
    }
    return name;
}

CreatePlayerInventoryTextDraws(playerid) 
{
    DestroyPlayerInventoryTextDraws(playerid);

    new Float:currentX = invPosX, Float:currentY = invPosY;

    //headers
    currentY += INVENTORY_TITLE_HEADER_SIZE_Y + INVENTORY_DEFAULT_MARGIN;

    new Float:headerSizeX = (invSizeX / INVENTORY_SECTIONS);
    for(new i = 0; i < INVENTORY_SECTIONS; i ++) 
    {
        new name[32];
        format(name, sizeof name, "%s", GetInventorySectionName(i));
        format(name, sizeof name, "%c%s", toupper(name[0]), name[1]);

        pInventoryCategoryButtonsTd[playerid][i] = CreatePlayerTextDraw(playerid, currentX + (headerSizeX / 2.0), currentY, name);
        PlayerTextDrawLetterSize(playerid, pInventoryCategoryButtonsTd[playerid][i], INVENTORY_LETTER_PROPORTION * (INVENTORY_HEADERS_SIZE_Y / 10.0), INVENTORY_HEADERS_SIZE_Y / 10.0);
        PlayerTextDrawTextSize(playerid, pInventoryCategoryButtonsTd[playerid][i], INVENTORY_HEADERS_SIZE_Y, headerSizeX);
        PlayerTextDrawAlignment(playerid, pInventoryCategoryButtonsTd[playerid][i], 2);
        PlayerTextDrawColor(playerid, pInventoryCategoryButtonsTd[playerid][i], pInventoryCurrentSection[playerid] == i ? INVENTORY_SELECTED_TEXT_COLOR : INVENTORY_TEXT_COLOR);
        PlayerTextDrawSetShadow(playerid, pInventoryCategoryButtonsTd[playerid][i], 0);
        PlayerTextDrawBackgroundColor(playerid, pInventoryCategoryButtonsTd[playerid][i], 255);
        PlayerTextDrawFont(playerid, pInventoryCategoryButtonsTd[playerid][i], 1);
        PlayerTextDrawSetProportional(playerid, pInventoryCategoryButtonsTd[playerid][i], 1);
        PlayerTextDrawSetSelectable(playerid, pInventoryCategoryButtonsTd[playerid][i], true);

        currentX += headerSizeX;
    }


    //item
    currentX = invPosX + INVENTORY_DEFAULT_MARGIN;
    currentY += INVENTORY_HEADERS_SIZE_Y + INVENTORY_DEFAULT_MARGIN;
    new Float:oldCurrentY = currentY;

    new counter = 0;
    for(new i = 0; i < MAX_INVENTORY_ITEMS; i ++) 
    {
        pInventoryItems_BgTd[playerid][i] = CreatePlayerTextDraw(playerid, currentX, currentY, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, pInventoryItems_BgTd[playerid][i], INVENTORY_ITEM_SIZE_X, INVENTORY_ITEM_SIZE_Y);
        PlayerTextDrawAlignment(playerid, pInventoryItems_BgTd[playerid][i], 1);
        PlayerTextDrawColor(playerid, pInventoryItems_BgTd[playerid][i], INVENTORY_ITEM_COLOR);
        PlayerTextDrawSetShadow(playerid, pInventoryItems_BgTd[playerid][i], 0);
        PlayerTextDrawBackgroundColor(playerid, pInventoryItems_BgTd[playerid][i], 255);
        PlayerTextDrawFont(playerid, pInventoryItems_BgTd[playerid][i], 4);
        PlayerTextDrawSetProportional(playerid, pInventoryItems_BgTd[playerid][i], 0);
        PlayerTextDrawSetSelectable(playerid, pInventoryItems_BgTd[playerid][i], true);

        pInventoryItems_MdTd[playerid][i] = CreatePlayerTextDraw(playerid, currentX + INVENTORY_DEFAULT_PADDING, currentY + INVENTORY_DEFAULT_PADDING, "");
        PlayerTextDrawTextSize(playerid, pInventoryItems_MdTd[playerid][i], INVENTORY_ITEM_SIZE_X - (INVENTORY_DEFAULT_PADDING * 2.0), INVENTORY_ITEM_SIZE_Y - (INVENTORY_DEFAULT_PADDING * 2.0));
        PlayerTextDrawAlignment(playerid, pInventoryItems_MdTd[playerid][i], 1);
        PlayerTextDrawColor(playerid, pInventoryItems_MdTd[playerid][i], -1);
        PlayerTextDrawSetShadow(playerid, pInventoryItems_MdTd[playerid][i], 0);
        PlayerTextDrawBackgroundColor(playerid, pInventoryItems_MdTd[playerid][i], INVENTORY_ITEM_COLOR);
        PlayerTextDrawFont(playerid, pInventoryItems_MdTd[playerid][i], 5);
        PlayerTextDrawSetPreviewModel(playerid, pInventoryItems_MdTd[playerid][i], 19300);
        PlayerTextDrawSetPreviewRot(playerid, pInventoryItems_MdTd[playerid][i], 0.0, 0.0, 0.0, 0.0);

        counter ++;
        if(counter >= invItemsPerRow) 
        {
            counter = 0;
            currentX = invPosX + INVENTORY_DEFAULT_MARGIN;
            currentY += INVENTORY_ITEM_SIZE_Y + INVENTORY_DEFAULT_MARGIN;
        }
        else 
        {
            currentX += INVENTORY_ITEM_SIZE_X + INVENTORY_DEFAULT_MARGIN;
        }
    }

    currentX = invPosX + INVENTORY_DEFAULT_MARGIN;
    currentY = oldCurrentY;

    counter = 0;
    for(new i = 0; i < MAX_INVENTORY_ITEMS; i ++) 
    {
        pInventoryItems_NameTd[playerid][i] = CreatePlayerTextDraw(playerid, currentX + (INVENTORY_ITEM_SIZE_X / 2.0), currentY, "_");
        PlayerTextDrawLetterSize(playerid, pInventoryItems_NameTd[playerid][i], INVENTORY_LETTER_PROPORTION * (INVENTORY_PLACEHOLDERS_SIZE_Y / 10.0), INVENTORY_PLACEHOLDERS_SIZE_Y / 10.0);
        PlayerTextDrawTextSize(playerid, pInventoryItems_NameTd[playerid][i], INVENTORY_ITEM_SIZE_Y - 4.0, INVENTORY_ITEM_SIZE_X);
        PlayerTextDrawAlignment(playerid, pInventoryItems_NameTd[playerid][i], 2);
        PlayerTextDrawColor(playerid, pInventoryItems_NameTd[playerid][i], 0xFFFFFF00);
        PlayerTextDrawSetShadow(playerid, pInventoryItems_NameTd[playerid][i], 0);
        PlayerTextDrawBackgroundColor(playerid, pInventoryItems_NameTd[playerid][i], 255);
        PlayerTextDrawFont(playerid, pInventoryItems_NameTd[playerid][i], 1);
        PlayerTextDrawSetProportional(playerid, pInventoryItems_NameTd[playerid][i], 1);
        PlayerTextDrawSetSelectable(playerid, pInventoryItems_NameTd[playerid][i], true);

        counter ++;

        if(counter >= invItemsPerRow) 
        {
            counter = 0;
            currentX = invPosX + INVENTORY_DEFAULT_MARGIN;
            currentY += INVENTORY_ITEM_SIZE_Y + INVENTORY_DEFAULT_MARGIN;
        }
        else 
        {
            currentX += INVENTORY_ITEM_SIZE_X + INVENTORY_DEFAULT_MARGIN;
        }
    }

}

SetPlayerInventoryModelsTd(playerid) 
{
    for(new i = 0; i < MAX_INVENTORY_ITEMS; i ++) 
    {
        if(pInventoryItems_MdTd[playerid][i] != PlayerText:INVALID_TEXT_DRAW) 
        {
            if(pInventoryItems[playerid][ pInventoryCurrentSection[playerid] ][i][pinv_VALID]) 
            {
                PlayerTextDrawSetPreviewModel(playerid, pInventoryItems_MdTd[playerid][i], pInventoryItems[playerid][ pInventoryCurrentSection[playerid] ][i][pinv_MODELID]);
                PlayerTextDrawSetPreviewRot(playerid, pInventoryItems_MdTd[playerid][i],
                    pInventoryItems[playerid][ pInventoryCurrentSection[playerid] ][i][pinv_MDL_RX],
                    pInventoryItems[playerid][ pInventoryCurrentSection[playerid] ][i][pinv_MDL_RY],
                    pInventoryItems[playerid][ pInventoryCurrentSection[playerid] ][i][pinv_MDL_RZ],
                    pInventoryItems[playerid][ pInventoryCurrentSection[playerid] ][i][pinv_MDL_ZOOM]
                );
                PlayerTextDrawShow(playerid, pInventoryItems_MdTd[playerid][i]);

                new td_str[128], name[64];
                format(name, sizeof name, "%s", pInventoryItems[playerid][ pInventoryCurrentSection[playerid] ][i][pinv_NAME]);
                FixTextDrawString(name, true);
                format(td_str, sizeof td_str, "_~n~_~n~_~n~_~n~%s", name);
                PlayerTextDrawSetString(playerid, pInventoryItems_NameTd[playerid][i], td_str);
            }
            else 
            {
                PlayerTextDrawSetPreviewModel(playerid, pInventoryItems_MdTd[playerid][i], 19300);
                PlayerTextDrawSetPreviewRot(playerid, pInventoryItems_MdTd[playerid][i], 0.0, 0.0, 0.0, 0.0);
                PlayerTextDrawShow(playerid, pInventoryItems_MdTd[playerid][i]);
                PlayerTextDrawSetString(playerid, pInventoryItems_NameTd[playerid][i], "_");
            }
        }
    }
}

SetPlayerInventorySection(playerid, section) 
{
    pInventoryCurrentSection[playerid] = section;
    for(new i = 0; i < sizeof pInventoryCategoryButtonsTd[]; i ++) 
    {
        PlayerTextDrawColor(playerid, pInventoryCategoryButtonsTd[playerid][i], pInventoryCurrentSection[playerid] == i ? INVENTORY_SELECTED_TEXT_COLOR : INVENTORY_TEXT_COLOR);
        PlayerTextDrawShow(playerid, pInventoryCategoryButtonsTd[playerid][i]);
    }
    SetPlayerInventoryModelsTd(playerid);
}

SeedPlayerInventory(playerid) 
{
    ClearPlayerInventory(playerid);

    new counter = 0;

    //GENERAL
    //dinero
    if(counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "%s$", number_format_thousand(PI[playerid][pi_CASH]));
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 1212;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_MONEY;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][0] = INV_BUTTON_TYPE_GIVE;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][1] = INV_BUTTON_TYPE_THROW;
        counter ++;
    }

    if(PI[playerid][pi_COINS] != 0 && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "%s "SERVER_COIN"", number_format_thousand(PI[playerid][pi_COINS]));
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 19941;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 90.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_COINS;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][0] = INV_BUTTON_TYPE_SELL;
        counter ++;
    }

    if(PI[playerid][pi_DRIVE_LICENSE_POINTS] != 0 && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "Licencia de conducir (%d puntos)", PI[playerid][pi_DRIVE_LICENSE_POINTS]);
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 19792;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 90.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_DRIVER_LICENSE;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][0] = INV_BUTTON_TYPE_SHOW;
        counter ++;
    }

    if(PI[playerid][pi_PHONE_NUMBER] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "Teléfono (%s)", number_format_thousand(PI[playerid][pi_PHONE_NUMBER]));
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 18868;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 90.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 0.6;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_PHONE;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][0] = INV_BUTTON_TYPE_USE;
        counter ++;
    }

    if(PI[playerid][pi_MP3] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "MP3");
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 18867;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 90.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 0.6;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_MP3;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][0] = INV_BUTTON_TYPE_USE;
        counter ++;
    }

    if(PI[playerid][pi_PHONE_RESOLVER] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "Guía telefónica");
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 1239;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_PHONE_RESOLVER;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][0] = INV_BUTTON_TYPE_USE;
        counter ++;
    }

    if(PI[playerid][pi_SPEAKERS] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "Altavoces");
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 2226;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 180.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_SPEAKERS;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][0] = INV_BUTTON_TYPE_USE;
        counter ++;
    }

    if(PI[playerid][pi_MECANICO_PIECES] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "Piezas de mecánico (%s)", number_format_thousand(PI[playerid][pi_MECANICO_PIECES]));
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 1020;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_MECANICO_PIECES;
        counter ++;
    }

    if(PI[playerid][pi_FUEL_DRUM] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "Bidón de gasolina (%s Litros)", number_format_thousand(PI[playerid][pi_FUEL_DRUM]));
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 1650;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_FUEL_DRUM;
        counter ++;
    }

    if(PI[playerid][pi_SEED_MEDICINE] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "Semillas de medicina (%sg)", number_format_thousand(PI[playerid][pi_SEED_MEDICINE]));
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 2060;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 90.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_MEDICINE_SEEDS;
        counter ++;
    }

    if(PI[playerid][pi_SEED_CANNABIS] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "Semillas de marihuana (%sg)", number_format_thousand(PI[playerid][pi_SEED_CANNABIS]));
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 2060;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 90.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_CANNABIS_SEEDS;
        counter ++;
    }

    if(PI[playerid][pi_SEED_CRACK] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "Semillas de coca (%sg)", number_format_thousand(PI[playerid][pi_SEED_CRACK]));
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 2060;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 90.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_CRACK_SEEDS;
        counter ++;
    }

    if(PI[playerid][pi_MEDICINE] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "Medicamentos (%sg)", number_format_thousand(PI[playerid][pi_MEDICINE]));
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 11736;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 90.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_MEDICINE;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][0] = INV_BUTTON_TYPE_USE;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][1] = INV_BUTTON_TYPE_GIVE;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][2] = INV_BUTTON_TYPE_SELL;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][3] = INV_BUTTON_TYPE_THROW;
        if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_NORMAL || PI[playerid][pi_STATE] == ROLEPLAY_STATE_CRACK) 
        {
            new vehicleid = GetPlayerCameraTargetVehicle(playerid);
            if(vehicleid != INVALID_VEHICLE_ID && PLAYER_VEHICLES[vehicleid][player_vehicle_VALID] && PLAYER_VEHICLES[vehicleid][player_vehicle_OWNER_ID] == PI[playerid][pi_ID]) 
            {
                pInventoryItems[playerid][0][counter][pinv_BUTTONS][4] = INV_BUTTON_TYPE_SAVE;
            }
        }
        else if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_OWN_PROPERTY) 
        {
            new index = GetPropertyIndexByID(PI[playerid][pi_LOCAL_INTERIOR]);
            if(index != -1 && PROPERTY_INFO[index][property_OWNER_ID] == PI[playerid][pi_ID] && IsPlayerInRangeOfPoint(playerid, NEARS_PLAYERS_DISTANCE, PROPERTY_CLOSET_POS[ PROPERTY_INFO[index][property_ID_INTERIOR] ][property_closet_X], PROPERTY_CLOSET_POS[ PROPERTY_INFO[index][property_ID_INTERIOR] ][property_closet_Y], PROPERTY_CLOSET_POS[ PROPERTY_INFO[index][property_ID_INTERIOR] ][property_closet_Z])) 
            {
                pInventoryItems[playerid][0][counter][pinv_BUTTONS][4] = INV_BUTTON_TYPE_SAVE;
            }
        }
        counter ++;
    }

    if(PI[playerid][pi_CANNABIS] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "Marihuana (%sg)", number_format_thousand(PI[playerid][pi_CANNABIS]));
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 19896;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_CANNABIS;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][0] = INV_BUTTON_TYPE_USE;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][1] = INV_BUTTON_TYPE_GIVE;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][2] = INV_BUTTON_TYPE_SELL;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][3] = INV_BUTTON_TYPE_THROW;
        if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_NORMAL || PI[playerid][pi_STATE] == ROLEPLAY_STATE_CRACK) 
        {
            new vehicleid = GetPlayerCameraTargetVehicle(playerid);
            if(vehicleid != INVALID_VEHICLE_ID && PLAYER_VEHICLES[vehicleid][player_vehicle_VALID] && PLAYER_VEHICLES[vehicleid][player_vehicle_OWNER_ID] == PI[playerid][pi_ID]) 
            {
                pInventoryItems[playerid][0][counter][pinv_BUTTONS][4] = INV_BUTTON_TYPE_SAVE;
            }
        }
        else if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_OWN_PROPERTY) 
        {
            new index = GetPropertyIndexByID(PI[playerid][pi_LOCAL_INTERIOR]);
            if(index != -1 && PROPERTY_INFO[index][property_OWNER_ID] == PI[playerid][pi_ID] && IsPlayerInRangeOfPoint(playerid, NEARS_PLAYERS_DISTANCE, PROPERTY_CLOSET_POS[ PROPERTY_INFO[index][property_ID_INTERIOR] ][property_closet_X], PROPERTY_CLOSET_POS[ PROPERTY_INFO[index][property_ID_INTERIOR] ][property_closet_Y], PROPERTY_CLOSET_POS[ PROPERTY_INFO[index][property_ID_INTERIOR] ][property_closet_Z])) 
            {
                pInventoryItems[playerid][0][counter][pinv_BUTTONS][4] = INV_BUTTON_TYPE_SAVE;
            }
        }
        counter ++;
    }

    if(PI[playerid][pi_CRACK] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "Crack (%sg)", number_format_thousand(PI[playerid][pi_CRACK]));
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 1575;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_CRACK;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][0] = INV_BUTTON_TYPE_USE;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][1] = INV_BUTTON_TYPE_GIVE;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][2] = INV_BUTTON_TYPE_SELL;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][3] = INV_BUTTON_TYPE_THROW;
        if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_NORMAL || PI[playerid][pi_STATE] == ROLEPLAY_STATE_CRACK) 
        {
            new vehicleid = GetPlayerCameraTargetVehicle(playerid);
            if(vehicleid != INVALID_VEHICLE_ID && PLAYER_VEHICLES[vehicleid][player_vehicle_VALID] && PLAYER_VEHICLES[vehicleid][player_vehicle_OWNER_ID] == PI[playerid][pi_ID]) 
            {
                pInventoryItems[playerid][0][counter][pinv_BUTTONS][4] = INV_BUTTON_TYPE_SAVE;
            }
        }
        else if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_OWN_PROPERTY) 
        {
            new index = GetPropertyIndexByID(PI[playerid][pi_LOCAL_INTERIOR]);
            if(index != -1 && PROPERTY_INFO[index][property_OWNER_ID] == PI[playerid][pi_ID] && IsPlayerInRangeOfPoint(playerid, NEARS_PLAYERS_DISTANCE, PROPERTY_CLOSET_POS[ PROPERTY_INFO[index][property_ID_INTERIOR] ][property_closet_X], PROPERTY_CLOSET_POS[ PROPERTY_INFO[index][property_ID_INTERIOR] ][property_closet_Y], PROPERTY_CLOSET_POS[ PROPERTY_INFO[index][property_ID_INTERIOR] ][property_closet_Z])) 
            {
                pInventoryItems[playerid][0][counter][pinv_BUTTONS][4] = INV_BUTTON_TYPE_SAVE;
            }
        }
        counter ++;
    }

    if(PI[playerid][pi_MECANICO_KITS] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "Kits de reparación (%s)", number_format_thousand(PI[playerid][pi_MECANICO_KITS]));
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 19921;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_MECANICO_KITS;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][0] = INV_BUTTON_TYPE_GIVE;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][1] = INV_BUTTON_TYPE_THROW;
        if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_NORMAL || PI[playerid][pi_STATE] == ROLEPLAY_STATE_CRACK) 
        {
            new vehicleid = GetPlayerCameraTargetVehicle(playerid);
            if(vehicleid != INVALID_VEHICLE_ID) 
            {
                pInventoryItems[playerid][0][counter][pinv_BUTTONS][2] = INV_BUTTON_TYPE_USE;
            }
        }
        counter ++;
    }

    if(PI[playerid][pi_MEDICAL_KITS] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "Botiquines (%s)", number_format_thousand(PI[playerid][pi_MEDICAL_KITS]));
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 11738;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 1.0;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_MEDICAL_KITS;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][0] = INV_BUTTON_TYPE_USE;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][1] = INV_BUTTON_TYPE_GIVE;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][2] = INV_BUTTON_TYPE_THROW;
        counter ++;
    }

    if(PI[playerid][pi_JETPACK] && counter < MAX_INVENTORY_ITEMS) 
    {
        pInventoryItems[playerid][0][counter][pinv_VALID] = true;
        format(pInventoryItems[playerid][0][counter][pinv_NAME], 64, "JetPack");
        pInventoryItems[playerid][0][counter][pinv_MODELID] = 370;
        pInventoryItems[playerid][0][counter][pinv_MDL_RX] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RY] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_RZ] = 0.0;
        pInventoryItems[playerid][0][counter][pinv_MDL_ZOOM] = 0.9;
        pInventoryItems[playerid][0][counter][pinv_TYPE] = INV_TYPE_JETPACK;
        pInventoryItems[playerid][0][counter][pinv_BUTTONS][0] = INV_BUTTON_TYPE_USE;
        counter ++;
    }

    //COMIDA
    counter = 0;
    for(new i = 0; i != MAX_PLAYER_POCKET_OBJECTS; i ++)
	{
		if(PLAYER_POCKET[playerid][i][player_pocket_VALID])
		{
            new modelid = 2703;
            if(!strcmp(PLAYER_POCKET[playerid][i][player_pocket_object_NAME], "Botella de agua mineral", true)) modelid = 2958;
            else if(!strcmp(PLAYER_POCKET[playerid][i][player_pocket_object_NAME], "Lata de refresco Sprunk", true)) modelid = 2601;
            else if(!strcmp(PLAYER_POCKET[playerid][i][player_pocket_object_NAME], "Lata de refresco cola", true)) modelid = 1543;
            else if(!strcmp(PLAYER_POCKET[playerid][i][player_pocket_object_NAME], "Barrita energetica", true)) modelid = 19565;
            else if(!strcmp(PLAYER_POCKET[playerid][i][player_pocket_object_NAME], "Porcion de pizza", true)) modelid = 2702;
            else if(!strcmp(PLAYER_POCKET[playerid][i][player_pocket_object_NAME], "Ensalada", true)) modelid = 19564;
            else if(!strcmp(PLAYER_POCKET[playerid][i][player_pocket_object_NAME], "Sandwich", true)) modelid = 19883;
            else if(!strcmp(PLAYER_POCKET[playerid][i][player_pocket_object_NAME], "Lata de cerveza", true)) modelid = 1486;
            else if(!strcmp(PLAYER_POCKET[playerid][i][player_pocket_object_NAME], "Vodka", true)) modelid = 1484;
            else if(!strcmp(PLAYER_POCKET[playerid][i][player_pocket_object_NAME], "Whisky", true)) modelid = 19823;

			pInventoryItems[playerid][1][counter][pinv_VALID] = true;
            format(pInventoryItems[playerid][1][counter][pinv_NAME], 64, "%s", PLAYER_POCKET[playerid][i][player_pocket_object_NAME]);
            pInventoryItems[playerid][1][counter][pinv_MODELID] = modelid;
            pInventoryItems[playerid][1][counter][pinv_MDL_RX] = 0.0;
            pInventoryItems[playerid][1][counter][pinv_MDL_RY] = 0.0;
            pInventoryItems[playerid][1][counter][pinv_MDL_RZ] = 0.0;
            pInventoryItems[playerid][1][counter][pinv_MDL_ZOOM] = 1.0;
            pInventoryItems[playerid][1][counter][pinv_TYPE] = INV_TYPE_POCKET;
            pInventoryItems[playerid][1][counter][pinv_INDEX] = i;
            counter ++;
		}
	}

    //ACCESORIOS
    counter = 0;
    for(new i = 0; i != MAX_SU_TOYS; i ++)
	{
		if(PLAYER_TOYS[playerid][i][player_toy_VALID])
		{
			pInventoryItems[playerid][2][counter][pinv_VALID] = true;
            format(pInventoryItems[playerid][2][counter][pinv_NAME], 64, "%s", PLAYER_TOYS[playerid][i][player_toy_NAME]);
            pInventoryItems[playerid][2][counter][pinv_MODELID] = PLAYER_TOYS[playerid][i][player_toy_MODELID];
            pInventoryItems[playerid][2][counter][pinv_MDL_RX] = 0.0;
            pInventoryItems[playerid][2][counter][pinv_MDL_RY] = 0.0;
            pInventoryItems[playerid][2][counter][pinv_MDL_RZ] = 0.0;
            pInventoryItems[playerid][2][counter][pinv_MDL_ZOOM] = 1.0;
            pInventoryItems[playerid][2][counter][pinv_TYPE] = INV_TYPE_TOY;
            pInventoryItems[playerid][2][counter][pinv_INDEX] = i;
            counter ++;
		}
	}

    //ARMAS
    counter = 0;
    for(new i = 0; i < sizeof PLAYER_WEAPONS[]; i ++)
	{
		if(PLAYER_WEAPONS[playerid][i][player_weapon_VALID])
		{
			pInventoryItems[playerid][3][counter][pinv_VALID] = true;
            format(pInventoryItems[playerid][3][counter][pinv_NAME], 64, "%s", WEAPON_INFO[ PLAYER_WEAPONS[playerid][i][player_weapon_ID] ][weapon_info_NAME]);
            pInventoryItems[playerid][3][counter][pinv_MODELID] = WEAPON_INFO[ PLAYER_WEAPONS[playerid][i][player_weapon_ID] ][weapon_info_MODEL];
            pInventoryItems[playerid][3][counter][pinv_MDL_RX] = 0.0;
            pInventoryItems[playerid][3][counter][pinv_MDL_RY] = 0.0;
            pInventoryItems[playerid][3][counter][pinv_MDL_RZ] = 0.0;
            pInventoryItems[playerid][3][counter][pinv_MDL_ZOOM] = 1.0;
            pInventoryItems[playerid][3][counter][pinv_TYPE] = INV_TYPE_WEAPON;
            PLAYER_TEMP[playerid][pt_PLAYER_LISTITEM][counter] = i;
            pInventoryItems[playerid][3][counter][pinv_INDEX] = i;
            counter ++;
		}
	}
}

ShowPlayerInventory_TD(playerid) 
{
    CreatePlayerInventoryTextDraws(playerid);
    SeedPlayerInventory(playerid);
    SetPlayerInventoryModelsTd(playerid);
    pInventoryOpened[playerid] = true;
    
    for(new i = 0; i < sizeof inventoryBaseTds; i ++) 
    {
        TextDrawShowForPlayer(playerid, inventoryBaseTds[i]);
    }

    for(new i = 0; i < sizeof pInventoryCategoryButtonsTd[]; i ++) 
    {
        if(pInventoryCategoryButtonsTd[playerid][i] != PlayerText:INVALID_TEXT_DRAW) 
        {
            PlayerTextDrawShow(playerid, pInventoryCategoryButtonsTd[playerid][i]);
        }
    }

    for(new i = 0; i < sizeof pInventoryItems_BgTd[]; i ++) 
    {
        if(pInventoryItems_BgTd[playerid][i] != PlayerText:INVALID_TEXT_DRAW) 
        {
            PlayerTextDrawShow(playerid, pInventoryItems_BgTd[playerid][i]);
        }

        if(pInventoryItems_MdTd[playerid][i] != PlayerText:INVALID_TEXT_DRAW) 
        {
            PlayerTextDrawShow(playerid, pInventoryItems_MdTd[playerid][i]);
        }

        if(pInventoryItems_NameTd[playerid][i] != PlayerText:INVALID_TEXT_DRAW) 
        {
            PlayerTextDrawShow(playerid, pInventoryItems_NameTd[playerid][i]);
        }
    }
    PlayerTaximeter_UpdateShown(playerid);
}

DestroyPlayerInventory_TD(playerid) 
{
    ClearPlayerInventory(playerid);
    for(new i = 0; i < sizeof inventoryBaseTds; i ++) 
    {
        TextDrawHideForPlayer(playerid, inventoryBaseTds[i]);
    }
    DestroyPlayerInventoryTextDraws(playerid);
    pInventoryOpened[playerid] = false;
    PlayerTaximeter_UpdateShown(playerid);
}

CMD:inventario(playerid, params[])
{
    if(!pInventoryOpened[playerid]) 
    {
	    if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_JAIL || PI[playerid][pi_STATE] == ROLEPLAY_STATE_ARRESTED) return SendClientMessage(playerid, -1, "{"#SILVER_COLOR"}Ahora no puedes abrir el inventario.");
        SelectTextDrawEx(playerid, INVENTORY_SELECT_TEXTDRAW_COLOR);
        ShowPlayerInventory_TD(playerid);
    }
    else 
    {
        CancelSelectTextDrawEx(playerid);
    }
	return 1;
}
alias:inventario("inv", "n");

IsInventoryOpened(playerid) 
{
    return pInventoryOpened[playerid];
}

OnPlayerClickInventoryItem(playerid, section, index) 
{
    if(pInventoryItems[playerid][section][index][pinv_VALID]) 
    {
        pInventorySelectedItem[playerid] = pInventoryItems[playerid][section][index];
        CancelSelectTextDrawEx(playerid);
        switch(pInventoryItems[playerid][section][index][pinv_TYPE]) 
        {
            case INV_TYPE_POCKET: 
            {
                PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
                PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_PLAYER_POCKET;
                CallLocalFunction("OnDialogResponse", "iiii", playerid, DIALOG_PLAYER_POCKET, 1, pInventoryItems[playerid][section][index][pinv_INDEX]);
            }
            case INV_TYPE_TOY: 
            {
                PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
                PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_PLAYER_TOYS;
                CallLocalFunction("OnDialogResponse", "iiii", playerid, DIALOG_PLAYER_TOYS, 1, pInventoryItems[playerid][section][index][pinv_INDEX]);
            }
            case INV_TYPE_WEAPON: 
            {
                PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
                PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_PLAYER_WEAPONS;
                CallLocalFunction("OnDialogResponse", "iiii", playerid, DIALOG_PLAYER_WEAPONS, 1, index);
            }
            default: 
            {
                ShowInvActionsButtonsDialog(playerid);
            }
        }
    }
    else 
    {
        SendClientMessageEx(playerid, -1, "{"#RED_COLOR"}Espacio vacío.");
    }
}

ShowInvActionsButtonsDialog(playerid) 
{
    new dialog_body[64 * MAX_INVENTORY_BUTTONS] = "", counter = 0;
    if(pInventorySelectedItem[playerid][pinv_VALID]) 
    {
        for(new i = 0; i < MAX_INVENTORY_BUTTONS; i ++) 
        {
            if(pInventorySelectedItem[playerid][pinv_BUTTONS][i] != INV_BUTTON_TYPE_NONE) 
            {
                switch(pInventorySelectedItem[playerid][pinv_BUTTONS][i]) 
                {
                    case INV_BUTTON_TYPE_USE: strcat(dialog_body, "- Usar\n");
                    case INV_BUTTON_TYPE_GIVE: strcat(dialog_body, "- Dar\n");
                    case INV_BUTTON_TYPE_SELL: strcat(dialog_body, "- Vender\n");
                    case INV_BUTTON_TYPE_SHOW: strcat(dialog_body, "- Mostrar\n");
                    case INV_BUTTON_TYPE_THROW: strcat(dialog_body, "- Tirar\n");
                    case INV_BUTTON_TYPE_SAVE: strcat(dialog_body, "- Guardar en el maletero/armario\n");
                }
                counter ++;
            }
        }
    }

    if(counter > 0) 
    {
        PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
        PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_INV_ACTIONS;
        ShowPlayerDialog(playerid, DIALOG_INV_ACTIONS, DIALOG_STYLE_LIST, pInventorySelectedItem[playerid][pinv_NAME], dialog_body, "Continuar", "Cerrar");
    }
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) 
{
    switch(dialogid) 
    {
        case DIALOG_INV_ACTIONS: 
        {
            if(response) 
            {
                pInventroySelectedButton[playerid] = pInventorySelectedItem[playerid][pinv_BUTTONS][listitem];
                switch(pInventroySelectedButton[playerid]) 
                {
                    case INV_BUTTON_TYPE_USE: 
                    {
                        switch(pInventorySelectedItem[playerid][pinv_TYPE]) 
                        {
                            case INV_TYPE_PHONE: PC_EmulateCommand(playerid, "/movil");
                            case INV_TYPE_MP3: PC_EmulateCommand(playerid, "/mp3");
                            case INV_TYPE_PHONE_RESOLVER: PC_EmulateCommand(playerid, "/guia");
                            case INV_TYPE_SPEAKERS: PC_EmulateCommand(playerid, "/amp3");
                            case INV_TYPE_JETPACK: PC_EmulateCommand(playerid, "/jetpack");
                            case INV_TYPE_MEDICINE: PC_EmulateCommand(playerid, "/consumir medicamento");
                            case INV_TYPE_CANNABIS: PC_EmulateCommand(playerid, "/consumir marihuana");
                            case INV_TYPE_CRACK: PC_EmulateCommand(playerid, "/consumir crack");
                            case INV_TYPE_MECANICO_KITS: PC_EmulateCommand(playerid, "/reparar");
                            case INV_TYPE_MEDICAL_KITS: ShowNearsPlayersToPlayer(playerid, NEAR_PLAYERS_INV_GENERAL);
                        }
                    }
                    case INV_BUTTON_TYPE_GIVE, INV_BUTTON_TYPE_SELL, INV_BUTTON_TYPE_SHOW: ShowNearsPlayersToPlayer(playerid, NEAR_PLAYERS_INV_GENERAL);
                    case INV_BUTTON_TYPE_THROW, INV_BUTTON_TYPE_SAVE: ShowSelectAmountDialog(playerid, NEAR_PLAYERS_INV_GENERAL);
                }
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnNearPlayerSelected(playerid, to_player, id) 
{
    if(id == NEAR_PLAYERS_INV_GENERAL) 
    {
        switch(pInventroySelectedButton[playerid]) 
        {
            case INV_BUTTON_TYPE_USE: 
            {
                switch(pInventorySelectedItem[playerid][pinv_TYPE]) 
                {
                    case INV_TYPE_MEDICAL_KITS: 
                    {
                        new command[128];
                        format(command, sizeof command, "/curar %d %d", to_player);
                        PC_EmulateCommand(playerid, command);
                    }
                }
            }
            case INV_BUTTON_TYPE_GIVE: ShowSelectAmountDialog(playerid, NEAR_PLAYERS_INV_GENERAL);
            case INV_BUTTON_TYPE_SELL: ShowSelectPriceDialog(playerid, NEAR_PLAYERS_INV_GENERAL);
            case INV_BUTTON_TYPE_SHOW: 
            {
                switch(pInventorySelectedItem[playerid][pinv_TYPE]) 
                {
                    case INV_TYPE_DRIVER_LICENSE: 
                    {
                        new action[128];
                        format(action, sizeof action, "le muestra su licencia de conducir a %s.", PLAYER_TEMP[to_player][pt_RP_NAME]);
                        Auto_SendPlayerAction(playerid, action);

                        SendClientMessageEx(to_player, -1, "{"#SILVER_COLOR"}Licencia de conducir de %s, puntos: %d.", PLAYER_TEMP[playerid][pt_RP_NAME], PI[playerid][pi_DRIVE_LICENSE_POINTS]);
                    }
                }
            }
        }
        return Y_HOOKS_BREAK_RETURN_1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPriceSelected(playerid, price, id) 
{
    if(id == NEAR_PLAYERS_INV_GENERAL) 
    {
        ShowSelectAmountDialog(playerid, NEAR_PLAYERS_INV_GENERAL);
        return Y_HOOKS_BREAK_RETURN_1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnAmountSelected(playerid, amount, id) 
{
    if(id == NEAR_PLAYERS_INV_GENERAL) 
    {
        
        new
            command[128],
            to_player = GetNP_PlayerLastSelectedId(playerid),
            price = GetNP_PlayerLastPrice(playerid);

        switch(pInventroySelectedButton[playerid]) 
        {
            case INV_BUTTON_TYPE_GIVE: 
            {
                switch(pInventorySelectedItem[playerid][pinv_TYPE]) 
                {
                    case INV_TYPE_MONEY: format(command, sizeof command, "/dar dinero %d %d", to_player, amount);
                    case INV_TYPE_MEDICINE: format(command, sizeof command, "/dar medicamentos %d %d", to_player, amount);
                    case INV_TYPE_CANNABIS: format(command, sizeof command, "/dar marihuana %d %d", to_player, amount);
                    case INV_TYPE_CRACK: format(command, sizeof command, "/dar crack %d %d", to_player, amount);
                    case INV_TYPE_MECANICO_KITS: format(command, sizeof command, "/dar kit %d %d", to_player, amount);
                    case INV_TYPE_MEDICAL_KITS: format(command, sizeof command, "/dar botiquin %d %d", to_player, amount);
                }
            }
            case INV_BUTTON_TYPE_SELL: 
            {
                switch(pInventorySelectedItem[playerid][pinv_TYPE]) 
                {
                    case INV_TYPE_COINS: format(command, sizeof command, "/vender coins %d %d %d", to_player, amount, price);
                    case INV_TYPE_MEDICINE: format(command, sizeof command, "/vender medicamentos %d %d %d", to_player, amount, price);
                    case INV_TYPE_CANNABIS: format(command, sizeof command, "/vender marihuana %d %d %d", to_player, amount, price);
                    case INV_TYPE_CRACK: format(command, sizeof command, "/vender crack %d %d %d", to_player, amount, price);
                }
            }
            case INV_BUTTON_TYPE_THROW: 
            {
                switch(pInventorySelectedItem[playerid][pinv_TYPE]) 
                {
                    case INV_TYPE_MONEY: format(command, sizeof command, "/tirar dinero %d", amount);
                    case INV_TYPE_MEDICINE: format(command, sizeof command, "/tirar medicamentos %d", amount);
                    case INV_TYPE_CANNABIS: format(command, sizeof command, "/tirar marihuana %d", amount);
                    case INV_TYPE_CRACK: format(command, sizeof command, "/tirar crack %d", amount);
                    case INV_TYPE_MECANICO_KITS: format(command, sizeof command, "/tirar kit %d", amount);
                    case INV_TYPE_MEDICAL_KITS: format(command, sizeof command, "/tirar botiquin %d", amount);
                }
            }
            case INV_BUTTON_TYPE_SAVE: 
            {
                switch(pInventorySelectedItem[playerid][pinv_TYPE]) 
                {
                    case INV_TYPE_MEDICINE: format(command, sizeof command, "/guardar medicamentos %d", amount);
                    case INV_TYPE_CANNABIS: format(command, sizeof command, "/guardar marihuana %d %d", amount);
                    case INV_TYPE_CRACK: format(command, sizeof command, "/guardar crack %d", amount);
                }
            }
        }

        PC_EmulateCommand(playerid, command);
        return Y_HOOKS_BREAK_RETURN_1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

GetInvSelectedItem_Index(playerid) 
{
    return pInventorySelectedItem[playerid][pinv_INDEX];
}
