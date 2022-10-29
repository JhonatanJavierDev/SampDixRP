#include <YSI-Includes\YSI\y_hooks>

#define MAX_GRAFFITI_PER_ZONE 2

enum _:E_Graffitis {
    graffiti_ID,

    graffiti_MODELID,
    graffiti_TEXT[128],
	graffiti_FONT[24],
	graffiti_FONT_SIZE,
	graffiti_FONT_BOLD,
	graffiti_FONT_COLOR,

    graffiti_ID_TERRITORY,
    graffiti_INDEX_TERRITORY,

    graffiti_ID_CREW,
    graffiti_INDEX_CREW,

    graffiti_BY_AID,

    graffiti_OBJECTID
};

new List:Graffitis[MAX_TERRITORIES];

hook OnScriptInit() {
    for(new i = 0; i < MAX_TERRITORIES; i ++) {
        Graffitis[i] = list_new();
    }
}

hook OnTerritoriesLoaded() {
    inline OnQueryLoaded()
	{
		new rows, total_graffitis[MAX_TERRITORIES];
		if(cache_get_row_count(rows))
		{
            for(new i = 0; i != rows; i ++)
			{
                new
                    id, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz,
                    interior, world, modelid, text[128], font[24], font_size,
                    font_bold, font_color, id_territory, id_crew, id_player;
                
                cache_get_value_name_int(i, "id", id);
                cache_get_value_name_float(i, "x", x);
                cache_get_value_name_float(i, "y", y);
                cache_get_value_name_float(i, "z", z);
                cache_get_value_name_float(i, "rx", rx);
                cache_get_value_name_float(i, "ry", ry);
                cache_get_value_name_float(i, "rz", rz);
                cache_get_value_name_int(i, "interior", interior);
                cache_get_value_name_int(i, "world", world);
                cache_get_value_name_int(i, "modelid", modelid);
                cache_get_value_name(i, "text", text);
                cache_get_value_name(i, "font", font);
                cache_get_value_name_int(i, "font_size", font_size);
                cache_get_value_name_int(i, "font_bold", font_bold);
                cache_get_value_name_int(i, "font_color", font_color);
                cache_get_value_name_int(i, "id_territory", id_territory);
                cache_get_value_name_int(i, "id_crew", id_crew);
                cache_get_value_name_int(i, "id_player", id_player);

                new territoryIndex = GetTerritoryIndexById(id_territory);
                new crewIndex = GetCrewIndexById(id_crew);
                if(territoryIndex != -1 && crewIndex != -1) {
                    total_graffitis[territoryIndex] ++;
                    if(total_graffitis[territoryIndex] > MAX_GRAFFITI_PER_ZONE) {
                        continue;
                    }

                    CreateGraffitiFromInfo(id, x, y, z, rx, ry, rz, interior, world, modelid, text, font, font_size, font_bold, font_color, id_territory, id_crew, id_player, territoryIndex, crewIndex);
                }
            }
        }
    }
    mysql_tquery_inline(mysql_db, "SELECT * FROM graffiti;", using inline OnQueryLoaded);
}

CountGraffitisInZone(index) {
    return list_size(Graffitis[index]);
}

CountCrewGraffitis(crewId) {
    new count = 0;
    for(new i = 0; i < MAX_TERRITORIES; i ++) {
        for(new j = 0; j < list_size(Graffitis[i]); j ++) {
            new info[E_Graffitis];
            list_get_arr(Graffitis[i], j, info);
            if(info[graffiti_ID_CREW] == crewId) {
                count ++;
            }
        }
    }
    return count;
}

CreateGraffitiFromInfo(id, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, interior, world, modelid, text[], font[], font_size, font_bold, font_color, id_territory, id_crew, id_player, territoryIndex, crewIndex) {
    if(CountGraffitisInZone(territoryIndex) >= MAX_GRAFFITI_PER_ZONE) return INVALID_STREAMER_ID;

    new objectid;
    objectid = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, world, interior, .streamdistance = 650.0, .drawdistance = 650.0);
    if(objectid != INVALID_STREAMER_ID) {
        SetDynamicObjectMaterialText(objectid, 0, text, 130, font, font_size, font_bold, font_color, 0x00000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
    
        new objInfo[4];
        objInfo[0] = OBJECT_TYPE_GRAFFITI;
        objInfo[1] = territoryIndex;
        objInfo[2] = crewIndex;
        objInfo[3] = id;
        Streamer_SetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, objInfo);

        new info[E_Graffitis];
        info[graffiti_ID] = id;

        info[graffiti_MODELID] = modelid;
        format(info[graffiti_TEXT], 128, "%s", text);
        format(info[graffiti_FONT], 24, "%s", font);
        info[graffiti_FONT_SIZE] = font_size;
        info[graffiti_FONT_BOLD] = font_bold;
        info[graffiti_FONT_COLOR] = font_color;

        info[graffiti_ID_TERRITORY] = id_territory;
        info[graffiti_INDEX_TERRITORY] = territoryIndex;

        info[graffiti_ID_CREW] = id_crew;
        info[graffiti_INDEX_CREW] = crewIndex;

        info[graffiti_BY_AID] = id_player;

        info[graffiti_OBJECTID] = objectid;

        list_add_arr(Graffitis[territoryIndex], info);
        return objectid;
    }
    return INVALID_STREAMER_ID;
}

hook OnCrewDeleted(crewId) {
    for(new i = 0; i < MAX_TERRITORIES; i ++) {
        new bool:delete = false;
        for(new j = 0; j < list_size(Graffitis[i]); j ++) {
            new info[E_Graffitis];
            list_get_arr(Graffitis[i], j, info);
            if(info[graffiti_ID_CREW] == crewId) {
                DestroyDynamicObject(info[graffiti_OBJECTID]);
                delete = true;
            }
        }

        if(delete) {
            list_clear(Graffitis[i]);
        }
    }

    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "DELETE FROM graffiti WHERE id_crew = %d;", crewId);
    mysql_tquery(mysql_db, QUERY_BUFFER);
    return 1;
}

hook OnCrewCaptureTerritory(crewId, crewIndex, territoryId, territoryIndex) {
    ClearTerritoryGraffitis(territoryId, territoryIndex);
}

hook OnCrewLeftTerritory(crewId, crewIndex, territoryId, territoryIndex) {
    ClearTerritoryGraffitis(territoryId, territoryIndex);
}

ClearTerritoryGraffitis(territoryId, territoryIndex) {
    for(new i = 0; i < list_size(Graffitis[territoryIndex]); i ++) {
        new info[E_Graffitis];
        list_get_arr(Graffitis[territoryIndex], i, info);
        DestroyDynamicObject(info[graffiti_OBJECTID]);
    }
    list_clear(Graffitis[territoryIndex]);

    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "DELETE FROM graffiti WHERE id_territory = %d;", territoryId);
    mysql_tquery(mysql_db, QUERY_BUFFER);
}

CMD:graffiti(playerid, params[]) {
    if(!PI[playerid][pi_CREW]) return SendNotification(playerid, "No perteneces a ninguna banda.");
	if(!CREW_RANK_INFO[ PLAYER_TEMP[playerid][pt_CREW_INDEX] ][ PI[playerid][pi_CREW_RANK] ][crew_rank_PERMISSION][CREW_RANK_GRAFFITI]) return SendNotification(playerid, "No tienes permiso para crear o borrar graffitis.");
	if(PLAYER_TEMP[playerid][pt_LAST_TERRITORY] == INVALID_STREAMER_ID) return SendNotification(playerid, "No estás en un territorio de tu banda.");
	if(!IsPlayerInDynamicArea(playerid, TERRITORIES[ PLAYER_TEMP[playerid][pt_LAST_TERRITORY] ][territory_AREA])) return SendNotification(playerid, "No estás en un territorio de tu banda.");
	if(TERRITORIES[ PLAYER_TEMP[playerid][pt_LAST_TERRITORY] ][territory_CREW_ID] != PI[playerid][pi_CREW]) return SendNotification(playerid, "No estás en un territorio de tu banda.");			
    if(PI[playerid][pi_LEVEL] < 6) return SendNotification(playerid, "Debes ser nivel 6 o superior para usar los graffitis.");
	
	PLAYER_TEMP[playerid][pt_PLAYER_TERRITORY_PRO] = PLAYER_TEMP[playerid][pt_LAST_TERRITORY];
	PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
    PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_GRAFFITI_OPTIONS;

    new string[128];
    format(string, sizeof string, "1. Crear graffiti (%d/%d)\n2. Editar graffiti", CountGraffitisInZone(PLAYER_TEMP[playerid][pt_LAST_TERRITORY]), MAX_GRAFFITI_PER_ZONE);
    ShowPlayerDialog(playerid, DIALOG_GRAFFITI_OPTIONS, DIALOG_STYLE_LIST, "Graffitis", string, "Continuar", "Cerrar");
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        case DIALOG_GRAFFITI_OPTIONS: {
            if(response) {
                switch(listitem) {
                    case 0: {
                        new territoryIndex = PLAYER_TEMP[playerid][pt_PLAYER_TERRITORY_PRO];
                        if(CountGraffitisInZone(territoryIndex) >= MAX_GRAFFITI_PER_ZONE) SendNotification(playerid, "No se pueden crear más graffitis en este territorio.");
                        else {
                            new Float:pos[3], Float:angle, interior = GetPlayerInterior(playerid), world = GetPlayerVirtualWorld(playerid);
                            GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
                            GetPlayerFacingAngle(playerid, angle);
                            pos[0] += (1.5 * floatsin(-angle, degrees));
                    		pos[1] += (1.5 * floatcos(-angle, degrees));
                            angle -= 90.0;

                            inline OnQueryLoaded()
	                        {
                                new id = cache_insert_id();
                                if(id > 0) {
                                    new objectid = CreateGraffitiFromInfo(id, pos[0], pos[1], pos[2], 0.0, 0.0, angle, interior, world, 19479, "Graffiti", "Arial", 30, 0, 0xFFFFFFFF, TERRITORIES[territoryIndex][territory_ID], PI[playerid][pi_CREW], PI[playerid][pi_ID], territoryIndex, PLAYER_TEMP[playerid][pt_CREW_INDEX]);
                                    Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
                                    PLAYER_TEMP[playerid][pt_SELECTED_GRAFFITI] = objectid;
                                    EditDynamicObject(playerid, objectid);
                                }
                            }
                            mysql_format(
                                mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER,
                                "\
                                    INSERT INTO graffiti(x, y, z, rz, interior, world, modelid, text, id_territory, id_crew, id_player, font_size, font_color)\
                                    VALUES(%f, %f, %f, %f, %d, %d, 19479, 'Graffiti', %d, %d, %d, 30, %d);\
                                ",
                                pos[0], pos[1], pos[2], angle, interior, world, TERRITORIES[territoryIndex][territory_ID], PI[playerid][pi_CREW], PI[playerid][pi_ID], 0xFFFFFFFF
                            );
                            mysql_tquery_inline(mysql_db, QUERY_BUFFER, using inline OnQueryLoaded);
                        }
                    }
                    case 1: {
                        SelectObject(playerid);
                    }
                }
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case DIALOG_GRAFFITI_EDIT: {
            if(response) {
                switch(listitem) {
                    case 0: EditDynamicObject(playerid, PLAYER_TEMP[playerid][pt_SELECTED_GRAFFITI]);
                    case 1: {
                        ShowEditGraffitiTextDialog(playerid);
                    }
                    case 2: {
                        new info[4];
	                    Streamer_GetArrayData(STREAMER_TYPE_OBJECT, PLAYER_TEMP[playerid][pt_SELECTED_GRAFFITI], E_STREAMER_EXTRA_ID, info);

                        new territoryIndex = PLAYER_TEMP[playerid][pt_PLAYER_TERRITORY_PRO];
                        new graffitiId = info[3];

                        new index = GetGraffitiIndexById(territoryIndex, graffitiId);
                        if(index != -1) {
                            mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "DELETE FROM graffiti WHERE id = %d;", info[3]);
                            mysql_tquery(mysql_db, QUERY_BUFFER);

                            new ginfo[E_Graffitis];
                            list_get_arr(Graffitis[territoryIndex], index, ginfo);
                            DestroyDynamicObject(ginfo[graffiti_OBJECTID]);

                            list_remove(Graffitis[territoryIndex], index);
                            SendNotification(playerid, "Se ha eliminado el graffiti.");
                        }
                    }
                }
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case DIALOG_GRAFFITI_TEXT_OPTIONS: {
            if(response) {
                switch(listitem) {
                    case 0: { //texto
                        PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
                        PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_GRAFFITI_ETEXT_TEXT;
                        ShowPlayerDialog(playerid, DIALOG_GRAFFITI_ETEXT_TEXT, DIALOG_STYLE_INPUT, "Graffiti", "Introduce el nuevo texto:", "Continuar", "Atrás");
                    }
                    case 1: { //fuente
                        PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
                        PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_GRAFFITI_ETEXT_FONT;
                        ShowPlayerDialog(playerid, DIALOG_GRAFFITI_ETEXT_FONT, DIALOG_STYLE_INPUT, "Graffiti", "Introduce la nueva fuente:", "Continuar", "Atrás");
                    }
                    case 2: { //tamaño
                        PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
                        PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_GRAFFITI_ETEXT_SIZE;
                        ShowPlayerDialog(playerid, DIALOG_GRAFFITI_ETEXT_SIZE, DIALOG_STYLE_INPUT, "Graffiti", "Introduce el nuevo tamaño de letra:", "Continuar", "Atrás");
                    }
                    case 3: { //negrita
                        new info[4];
                        Streamer_GetArrayData(STREAMER_TYPE_OBJECT, PLAYER_TEMP[playerid][pt_SELECTED_GRAFFITI], E_STREAMER_EXTRA_ID, info);

                        new territoryIndex = PLAYER_TEMP[playerid][pt_PLAYER_TERRITORY_PRO];
                        new graffitiId = info[3];

                        new index = GetGraffitiIndexById(territoryIndex, graffitiId);
                        if(index != -1) {
                            new ginfo[E_Graffitis];
                            list_get_arr(Graffitis[territoryIndex], index, ginfo);

                            ginfo[graffiti_FONT_BOLD] = !ginfo[graffiti_FONT_BOLD];
                            list_set_arr(Graffitis[territoryIndex], index, ginfo);
                            UpdateGraffitiText(ginfo);

                            mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE graffiti SET font_bold = %d WHERE id = %d;", ginfo[graffiti_FONT_BOLD], ginfo[graffiti_ID]);
                            mysql_tquery(mysql_db, QUERY_BUFFER);

                            ShowEditGraffitiTextDialog(playerid);
                        }
                    }
                    case 4: { //color
                        new string[4200];
                        for(new i = 0; i != sizeof(RandomColors); i++)
                        {
                            new str[128];
                            format(str, sizeof(str), "{%06x}color %d\n", RandomColors[i] >>> 8, i + 1);
                            strcat(string, str);
                        }

                        PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
                        PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_GRAFFITI_ETEXT_COLOR;
                        ShowPlayerDialog(playerid, DIALOG_GRAFFITI_ETEXT_COLOR, DIALOG_STYLE_LIST, "Graffiti", string, "Continuar", "Atrás");
                    }
                }
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case DIALOG_GRAFFITI_ETEXT_TEXT: {
            if(response) {
                new value[128];
                if(sscanf(inputtext, "s[128]", value)) return SendNotification(playerid, "Valor no válido.");

                new info[4];
                Streamer_GetArrayData(STREAMER_TYPE_OBJECT, PLAYER_TEMP[playerid][pt_SELECTED_GRAFFITI], E_STREAMER_EXTRA_ID, info);

                new territoryIndex = PLAYER_TEMP[playerid][pt_PLAYER_TERRITORY_PRO];
                new graffitiId = info[3];

                new index = GetGraffitiIndexById(territoryIndex, graffitiId);
                if(index != -1) {
                    new ginfo[E_Graffitis];
                    list_get_arr(Graffitis[territoryIndex], index, ginfo);

                    format(ginfo[graffiti_TEXT], sizeof value, "%s", value);
                    list_set_arr(Graffitis[territoryIndex], index, ginfo);
                    UpdateGraffitiText(ginfo);

                    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE graffiti SET text = '%e' WHERE id = %d;", ginfo[graffiti_TEXT], ginfo[graffiti_ID]);
                    mysql_tquery(mysql_db, QUERY_BUFFER);
                }
            }
            ShowEditGraffitiTextDialog(playerid);
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case DIALOG_GRAFFITI_ETEXT_FONT: {
            if(response) {
                new value[24];
                if(sscanf(inputtext, "s[24]", value)) return SendNotification(playerid, "Valor no válido.");

                new info[4];
                Streamer_GetArrayData(STREAMER_TYPE_OBJECT, PLAYER_TEMP[playerid][pt_SELECTED_GRAFFITI], E_STREAMER_EXTRA_ID, info);

                new territoryIndex = PLAYER_TEMP[playerid][pt_PLAYER_TERRITORY_PRO];
                new graffitiId = info[3];

                new index = GetGraffitiIndexById(territoryIndex, graffitiId);
                if(index != -1) {
                    new ginfo[E_Graffitis];
                    list_get_arr(Graffitis[territoryIndex], index, ginfo);

                    format(ginfo[graffiti_FONT], sizeof value, "%s", value);
                    list_set_arr(Graffitis[territoryIndex], index, ginfo);
                    UpdateGraffitiText(ginfo);

                    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE graffiti SET font = '%e' WHERE id = %d;", ginfo[graffiti_FONT], ginfo[graffiti_ID]);
                    mysql_tquery(mysql_db, QUERY_BUFFER);
                }
            }
            ShowEditGraffitiTextDialog(playerid);
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case DIALOG_GRAFFITI_ETEXT_SIZE: {
            if(response) {
                new value;
                if(sscanf(inputtext, "d", value)) return SendNotification(playerid, "Valor no válido.");
                if(value <= 0 || value > 200) return SendNotification(playerid, "Valor no válido.");

                new info[4];
                Streamer_GetArrayData(STREAMER_TYPE_OBJECT, PLAYER_TEMP[playerid][pt_SELECTED_GRAFFITI], E_STREAMER_EXTRA_ID, info);

                new territoryIndex = PLAYER_TEMP[playerid][pt_PLAYER_TERRITORY_PRO];
                new graffitiId = info[3];

                new index = GetGraffitiIndexById(territoryIndex, graffitiId);
                if(index != -1) {
                    new ginfo[E_Graffitis];
                    list_get_arr(Graffitis[territoryIndex], index, ginfo);

                    ginfo[graffiti_FONT_SIZE] = value;
                    list_set_arr(Graffitis[territoryIndex], index, ginfo);
                    UpdateGraffitiText(ginfo);

                    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE graffiti SET font_size = %d WHERE id = %d;", ginfo[graffiti_FONT_SIZE], ginfo[graffiti_ID]);
                    mysql_tquery(mysql_db, QUERY_BUFFER);
                }
            }
            ShowEditGraffitiTextDialog(playerid);
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case DIALOG_GRAFFITI_ETEXT_COLOR: {
            if(response) {
                new value = RGBAToARGB(RandomColors[listitem]);
                
                new info[4];
                Streamer_GetArrayData(STREAMER_TYPE_OBJECT, PLAYER_TEMP[playerid][pt_SELECTED_GRAFFITI], E_STREAMER_EXTRA_ID, info);

                new territoryIndex = PLAYER_TEMP[playerid][pt_PLAYER_TERRITORY_PRO];
                new graffitiId = info[3];

                new index = GetGraffitiIndexById(territoryIndex, graffitiId);
                if(index != -1) {
                    new ginfo[E_Graffitis];
                    list_get_arr(Graffitis[territoryIndex], index, ginfo);

                    ginfo[graffiti_FONT_COLOR] = value;
                    list_set_arr(Graffitis[territoryIndex], index, ginfo);
                    UpdateGraffitiText(ginfo);

                    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE graffiti SET font_color = %d WHERE id = %d;", ginfo[graffiti_FONT_COLOR], ginfo[graffiti_ID]);
                    mysql_tquery(mysql_db, QUERY_BUFFER);
                }
            }
            ShowEditGraffitiTextDialog(playerid);
            return Y_HOOKS_BREAK_RETURN_1;
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerSelectDynObject(playerid, STREAMER_TAG_OBJECT objectid, modelid, Float:x, Float:y, Float:z) {
    new info[4];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, info);

    if(info[0] == OBJECT_TYPE_GRAFFITI) {
        new territoryIndex = info[1];
        new crewIndex = info[2];
        if(PLAYER_TEMP[playerid][pt_PLAYER_TERRITORY_PRO] == territoryIndex && PLAYER_TEMP[playerid][pt_CREW_INDEX] == crewIndex && CREW_RANK_INFO[crewIndex][ PI[playerid][pi_CREW_RANK] ][crew_rank_PERMISSION][CREW_RANK_GRAFFITI]) {
            CancelEdit(playerid);
            PLAYER_TEMP[playerid][pt_SELECTED_GRAFFITI] = objectid;
            ShowDialog(playerid, DIALOG_GRAFFITI_EDIT);
        }
        return Y_HOOKS_BREAK_RETURN_1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerEditDynObject(playerid, STREAMER_TAG_OBJECT objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    new info[4];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, info);

    if(info[0] == OBJECT_TYPE_GRAFFITI && objectid == PLAYER_TEMP[playerid][pt_SELECTED_GRAFFITI]) {
        switch(response) {
            case EDIT_RESPONSE_CANCEL: {
                new Float:pos[3], Float:rot[3];
                Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_X, pos[0]);
                Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_Y, pos[1]);
                Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_Z, pos[2]);
                Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_R_X, rot[0]);
                Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_R_Y, rot[1]);
                Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_R_Z, rot[2]);
                SetDynamicObjectPos(objectid, pos[0], pos[1], pos[2]);
                SetDynamicObjectRot(objectid, rot[0], rot[1], rot[2]);

                SendNotification(playerid, "Has cancelado la edición y el objeto a vuelto a su posición anterior.");
                ShowDialog(playerid, DIALOG_GRAFFITI_EDIT);
            }
            case EDIT_RESPONSE_FINAL: {
                SetDynamicObjectPos(objectid, x, y, z);
                SetDynamicObjectRot(objectid, rx, ry, rz);
            
                mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE graffiti SET x = %f, y = %f, z = %f, rx = %f, ry = %f, rz = %f WHERE id = %d;", x, y, z, rx, ry, rz, info[3]);
                mysql_tquery(mysql_db, QUERY_BUFFER);

                SendNotification(playerid, "La posición del graffiti se ha actualizado correctamente.");
                ShowDialog(playerid, DIALOG_GRAFFITI_EDIT);
            }
        }
        return Y_HOOKS_BREAK_RETURN_1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

GetGraffitiIndexById(territoryIndex, graffitiId) {
    for(new i = 0; i < list_size(Graffitis[territoryIndex]); i ++) {
        new ginfo[E_Graffitis];
        list_get_arr(Graffitis[territoryIndex], i, ginfo);
        if(ginfo[graffiti_ID] == graffitiId) {
            return i;
        }
    }
    return -1;
}

ShowEditGraffitiTextDialog(playerid) {
    new info[4];
    Streamer_GetArrayData(STREAMER_TYPE_OBJECT, PLAYER_TEMP[playerid][pt_SELECTED_GRAFFITI], E_STREAMER_EXTRA_ID, info);

    new territoryIndex = PLAYER_TEMP[playerid][pt_PLAYER_TERRITORY_PRO];
    new graffitiId = info[3];

    new index = GetGraffitiIndexById(territoryIndex, graffitiId);
    if(index != -1) {
        new ginfo[E_Graffitis];
        list_get_arr(Graffitis[territoryIndex], index, ginfo);

        PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
        PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_GRAFFITI_TEXT_OPTIONS;

        new string[512];
        format(string, sizeof string, "\
            Parámetro\tValor\n\
            Texto\t'%s'\n\
            Fuente\t'%s'\n\
            Tamaño\t%d\n\
            Negrita\t%s\n\
            Color\t{%06x}%d\n\
        ", ginfo[graffiti_TEXT], ginfo[graffiti_FONT], ginfo[graffiti_FONT_SIZE], ginfo[graffiti_FONT_BOLD] == 0 ? "no" : "sí", ARGBToRGBA(ginfo[graffiti_FONT_COLOR]) >>> 8, ginfo[graffiti_FONT_COLOR]);
        ShowPlayerDialog(playerid, DIALOG_GRAFFITI_TEXT_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Graffiti", string, "Continuar", "Cerrar");
    }
}

UpdateGraffitiText(ginfo[E_Graffitis]) {
    SetDynamicObjectMaterialText(ginfo[graffiti_OBJECTID], 0, ginfo[graffiti_TEXT], 130, ginfo[graffiti_FONT], ginfo[graffiti_FONT_SIZE], ginfo[graffiti_FONT_BOLD], ginfo[graffiti_FONT_COLOR], 0x00000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
}
