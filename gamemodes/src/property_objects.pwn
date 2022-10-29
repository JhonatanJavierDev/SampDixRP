#include <YSI-Includes\YSI\y_hooks>

#define UNCREATED_POBJECTS_PER_PAGE 6
#define TEXTURES_WEBPAGE "textures.xyin.ws"

new List:PropertyObjects[MAX_PROPIEDADES];

new
    PlayerText:pUncreatedPObjectsTd[MAX_PLAYERS][11] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...},
    bool:pPUObjectsMenuOpened[MAX_PLAYERS],
    pPUObjectsMenuCurrentPage[MAX_PLAYERS],
    pPUObjectsMenuTotalPages[MAX_PLAYERS],
    pPUObjectsMenuIds[MAX_PLAYERS][UNCREATED_POBJECTS_PER_PAGE],
    pPUObjectsMenuLastPageChange[MAX_PLAYERS],
    pPObjectCurrentModelID[MAX_PLAYERS],
    pPObjectCurrentObjectID[MAX_PLAYERS],
    pPObjectCurrentID[MAX_PLAYERS],
    pPObjectTextureIndex[MAX_PLAYERS]
;

hook OnScriptInit() 
{
    for(new i = 0; i < MAX_PROPIEDADES; i ++) 
    {
        PropertyObjects[i] = list_new();
    }
}

hook OnPropertiesLoaded() 
{
    inline OnQueryLoaded()
	{
		new rows, total_objects[MAX_PROPIEDADES];
		if(cache_get_row_count(rows))
		{
			for(new i = 0; i != rows; i ++)
			{
                new
                    id, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz,
                    bool:isnull_texture0, texture0[256],
                    bool:isnull_texture1, texture1[256],
                    bool:isnull_texture2, texture2[256],
                    bool:isnull_texture3, texture3[256],
                    id_property
                ;

                cache_get_value_name_int(i, "id", id);
                cache_get_value_name_int(i, "modelid", modelid);
                cache_get_value_name_float(i, "x", x);
                cache_get_value_name_float(i, "y", y);
                cache_get_value_name_float(i, "z", z);
                cache_get_value_name_float(i, "rx", rx);
                cache_get_value_name_float(i, "ry", ry);
                cache_get_value_name_float(i, "rz", rz);

                cache_is_value_name_null(i, "texture0", isnull_texture0);
                cache_is_value_name_null(i, "texture1", isnull_texture1);
                cache_is_value_name_null(i, "texture2", isnull_texture2);
                cache_is_value_name_null(i, "texture3", isnull_texture3);

                if(!isnull_texture0) cache_get_value_name(i, "texture0", texture0);
                if(!isnull_texture1) cache_get_value_name(i, "texture1", texture1);
                if(!isnull_texture2) cache_get_value_name(i, "texture2", texture2);
                if(!isnull_texture3) cache_get_value_name(i, "texture3", texture3);

                cache_get_value_name_int(i, "id_property", id_property);

                new property_index = GetPropertyIndexByID(id_property);
                total_objects[property_index] ++;
                if(total_objects[property_index] > MAX_SU_PROPERTY_OBJECTS) 
                {
                    continue;
                }
                CreatePropertyFurnitureObject(false, property_index, id, id_property, modelid, x, y, z, rx, ry, rz, texture0, texture1, texture2, texture3);
            }
        }
    }
    mysql_tquery_inline(mysql_db, "SELECT * FROM property_objects WHERE `create` = 1;", using inline OnQueryLoaded);
}

CreatePropertyFurnitureObject(bool:update, property_index, id_object, id_property, modelid, Float:x, Float:y, Float:z, Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0, texture0[] = "", texture1[] = "", texture2[] = "", texture3[] = "") {
    new objectid = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, id_property);
    new info[3];
    info[0] = OBJECT_TYPE_FURNITURE;
    info[1] = id_object;
    info[2] = id_property;
    Streamer_SetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, info);

    new texture_modelid, texture_txdname[64], texture_texturename[64], texture_color;
    if(strlen(texture0) > 0 && !sscanf(texture0, "p<,>ds[64]s[64]d", texture_modelid, texture_txdname, texture_texturename, texture_color)) 
    {
        SetDynamicObjectMaterial(objectid, 0, texture_modelid, texture_txdname, texture_texturename, texture_color);
    }
    if(strlen(texture1) > 0 && !sscanf(texture1, "p<,>ds[64]s[64]d", texture_modelid, texture_txdname, texture_texturename, texture_color)) 
    {
        SetDynamicObjectMaterial(objectid, 1, texture_modelid, texture_txdname, texture_texturename, texture_color);
    }
    if(strlen(texture2) > 0 && !sscanf(texture2, "p<,>ds[64]s[64]d", texture_modelid, texture_txdname, texture_texturename, texture_color)) 
    {
        SetDynamicObjectMaterial(objectid, 2, texture_modelid, texture_txdname, texture_texturename, texture_color);
    }
    if(strlen(texture3) > 0 && !sscanf(texture3, "p<,>ds[64]s[64]d", texture_modelid, texture_txdname, texture_texturename, texture_color)) 
    {
        SetDynamicObjectMaterial(objectid, 3, texture_modelid, texture_txdname, texture_texturename, texture_color);
    }
    
    list_add(PropertyObjects[property_index], objectid);

    if(update) 
    {
        UpdatePObjectDB(id_object, 1, modelid, x, y, z, rx, ry, rz, texture0, texture1, texture2, texture3);
    }
    return objectid;
}

CountPropertyObjects(id_property) 
{
    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "SELECT COUNT(*) FROM property_objects WHERE id_property = %d;", id_property);
    new count, Cache:result = mysql_query(mysql_db, QUERY_BUFFER);
    cache_get_value_int(0, 0, count);
    cache_delete(result);
    return count;
}

CountPropertyUncreatedObjects(id_property) 
{
    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "SELECT COUNT(*) FROM property_objects WHERE id_property = %d AND `create` = 0;", id_property);
    new count, Cache:result = mysql_query(mysql_db, QUERY_BUFFER);
    cache_get_value_int(0, 0, count);
    cache_delete(result);
    return count;
}

RegisterPropertyObject(property_index, id_property, modelid, create = 0, Float:x = 0.0, Float:y = 0.0, Float:z = 0.0, Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0, texture0[] = "", texture1[] = "", texture2[] = "", texture3[] = "", bool:editWhenCreate = false, forplayerid = INVALID_PLAYER_ID) 
{
    inline OnQueryLoaded(n_texture0[], n_texture1[], n_texture2[], n_texture3[])
	{
		new id = cache_insert_id();
        if(id > 0 && create) 
        {
            new objectid = CreatePropertyFurnitureObject(false, property_index, id, id_property, modelid, x, y, z, rx, ry, rz, n_texture0, n_texture1, n_texture2, n_texture3);
            if(editWhenCreate && forplayerid != INVALID_PLAYER_ID) 
            {
                Streamer_Update(forplayerid, STREAMER_TYPE_OBJECT);
                
                pPObjectCurrentModelID[forplayerid] = modelid;
                pPObjectCurrentObjectID[forplayerid] = objectid;
                pPObjectCurrentID[forplayerid] = id;
                EditDynamicObject(forplayerid, objectid);
            }
        }
	}

    mysql_format(
        mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER,
        "\
			INSERT INTO property_objects(`create`, modelid, x, y, z, rx, ry, rz, texture0, texture1, texture2, texture3, id_property)\
			VALUES(%d, %d, %f, %f, %f, %f, %f, %f, '%e', '%e', '%e', '%e', %d);\
		",
        create, modelid, x, y, z, rx, ry, rz, texture0, texture1, texture2, texture3, id_property
    );
    mysql_tquery_inline(mysql_db, QUERY_BUFFER, using inline OnQueryLoaded, "ssss", texture0, texture1, texture2, texture3);
}

DeletePropertyObjects(property_index, bool:db_delete = true) 
{
    for_list(i : PropertyObjects[property_index])
    {
        new objectid = iter_get(i);
        DestroyDynamicObject(objectid);
    }
    list_clear(PropertyObjects[property_index]);

    if(db_delete) 
    {
        mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "DELETE FROM property_objects WHERE id_property = %d;", PROPERTY_INFO[property_index][property_ID]);
        mysql_tquery(mysql_db, QUERY_BUFFER);
    }
}

DeletePropertyObject(property_index, id_object, objectid, bool:uncreate = false) 
{
    new index = -1;
    for(new i = 0; i < list_size(PropertyObjects[property_index]); i ++) 
    {
        if(list_get(PropertyObjects[property_index], i) == objectid) 
        {
            index = i;
            break;
        }
    }

    if(index != -1) list_remove(PropertyObjects[property_index], index);
    DestroyDynamicObject(objectid);
    
    if(uncreate) 
    {
        mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE property_objects SET `create` = 0 WHERE id = %d;", id_object);
        mysql_tquery(mysql_db, QUERY_BUFFER);
    }
    else 
    {
        mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "DELETE FROM property_objects WHERE id = %d;", id_object);
        mysql_tquery(mysql_db, QUERY_BUFFER);
    }
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) 
{
    switch(dialogid) 
    {
        case DIALOG_PROPERTY_OBJECTS_MENU: 
        {
            if(response) 
            {
                switch(listitem) 
                {
                    case 0: //editar
                    { 
                        SelectObject(playerid);
                    }
                    case 1: //ver muebles guardados
                    { 
                        CreatePlayerPUObjectsMenu(playerid, PLAYER_TEMP[playerid][pt_PLAYER_PROPERTY_SELECTED]);
                    }
                    case 2: //borrar todos los muebles
                    { 
                        new property_index = PLAYER_TEMP[playerid][pt_PLAYER_PROPERTY_SELECTED];
                        new total = CountPropertyObjects(PROPERTY_INFO[property_index][property_ID]);
                        
                        new string[256];
                        format(string, sizeof string, "Se eliminarán %d muebles.\n¿Estás seguro de que quieres eliminarlos?", total);
                        
                        PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
                        PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_POBJECTS_DELETE_ALL;
                        ShowPlayerDialog(playerid, DIALOG_POBJECTS_DELETE_ALL, DIALOG_STYLE_MSGBOX, "Eliminar todo", string, "Eliminar", "Cancelar");
                    }
                }
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case DIALOG_POBJECTS_DELETE_ALL: 
        {
            if(response) 
            {
                new property_index = PLAYER_TEMP[playerid][pt_PLAYER_PROPERTY_SELECTED];
                DeletePropertyObjects(property_index);
                SendNotification(playerid, "Se han eliminado todos los muebles.");
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case DIALOG_POBJECT_EDIT: 
        {
            if(response) 
            {
                switch(listitem) 
                {
                    case 0: EditDynamicObject(playerid, pPObjectCurrentObjectID[playerid]);//Mover
                    case 1: //texturizar
                    { 
                        new dialog_body[32 * 4];
                        for(new i = 0; i < 4; i ++) 
                        {
                            new string[32];
                            format(string, sizeof string, "Índice %d\n", i);
                            strcat(dialog_body, string);
                        }

                        PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
                        PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_POBJECT_TEXTURE_INDEX;
                        ShowPlayerDialog(playerid, DIALOG_POBJECT_TEXTURE_INDEX, DIALOG_STYLE_LIST, "Selecciona el índice", dialog_body, "Continuar", "Atrás");
                    }
                    case 2: //clonar
                    { 
                        new property_index = PLAYER_TEMP[playerid][pt_PLAYER_PROPERTY_SELECTED];
                        new limit = PI[playerid][pi_VIP] ? MAX_SU_PROPERTY_OBJECTS : MAX_NU_PROPERTY_OBJECTS;
                        if(CountPropertyObjects(PROPERTY_INFO[property_index][property_ID]) >= limit) SendNotification(playerid, "No puedes añadir más muebles a esta propiedad.");
                        else 
                        {
                            if(GivePlayerCash(playerid, -GetPObjectModelPrice(pPObjectCurrentModelID[playerid]), true, true)) 
                            {
                                inline OnQueryLoaded()
                                {
                                    new rows;
                                    if(cache_get_row_count(rows))
                                    {
                                        if(rows) 
                                        {
                                            new
                                                modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz,
                                                bool:isnull_texture0, texture0[256],
                                                bool:isnull_texture1, texture1[256],
                                                bool:isnull_texture2, texture2[256],
                                                bool:isnull_texture3, texture3[256],
                                                id_property
                                            ;
                                            
                                            cache_get_value_name_int(0, "modelid", modelid);
                                            cache_get_value_name_float(0, "x", x);
                                            cache_get_value_name_float(0, "y", y);
                                            cache_get_value_name_float(0, "z", z);
                                            cache_get_value_name_float(0, "rx", rx);
                                            cache_get_value_name_float(0, "ry", ry);
                                            cache_get_value_name_float(0, "rz", rz);

                                            cache_is_value_name_null(0, "texture0", isnull_texture0);
                                            cache_is_value_name_null(0, "texture1", isnull_texture1);
                                            cache_is_value_name_null(0, "texture2", isnull_texture2);
                                            cache_is_value_name_null(0, "texture3", isnull_texture3);

                                            if(!isnull_texture0) cache_get_value_name(0, "texture0", texture0);
                                            if(!isnull_texture1) cache_get_value_name(0, "texture1", texture1);
                                            if(!isnull_texture2) cache_get_value_name(0, "texture2", texture2);
                                            if(!isnull_texture3) cache_get_value_name(0, "texture3", texture3);

                                            cache_get_value_name_int(0, "id_property", id_property);

                                            RegisterPropertyObject(property_index, id_property, modelid, 1, x, y, z, rx, ry, rz, texture0, texture1, texture2, texture3, true, playerid);
                                            SendNotification(playerid, "El mueble ha sido clonado.");
                                        }
                                    }
                                }
                                mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "SELECT * FROM property_objects WHERE id = %d;", pPObjectCurrentID[playerid]);
                                mysql_tquery_inline(mysql_db, QUERY_BUFFER, using inline OnQueryLoaded);
                            }
                            else SendNotification(playerid, "No tienes suficiente dinero.");
                        }
                    }
                    case 3: //guardar
                    { 
                        new property_index = PLAYER_TEMP[playerid][pt_PLAYER_PROPERTY_SELECTED];
                        DeletePropertyObject(property_index, pPObjectCurrentID[playerid], pPObjectCurrentObjectID[playerid], true);
                        SendNotification(playerid, "El mueble se ha guardado correctamente.");
                    }
                    case 4: //eliminar
                    { 
                        new property_index = PLAYER_TEMP[playerid][pt_PLAYER_PROPERTY_SELECTED];
                        DeletePropertyObject(property_index, pPObjectCurrentID[playerid], pPObjectCurrentObjectID[playerid]);
                        SendNotification(playerid, "El mueble ha sido eliminado.");
                    }
                }
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case DIALOG_POBJECT_TEXTURE_INDEX: 
        {
            if(response) 
            {
                pPObjectTextureIndex[playerid] = listitem;

                PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
                PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_POBJECT_TEXTURE;
                ShowPlayerDialog(playerid, DIALOG_POBJECT_TEXTURE, DIALOG_STYLE_INPUT, "Introduce la textura",
                    "\
                        Introduce la textura que deseas aplicar, el formato es el siguiente:\n\n\
                        \t[Model ID] [TXD Name] [Texture Name] [Color AARRGGBB (opcional)]\n\
                        \tPor ejemplo: 18202 w_towncs_t concretebig4256128 0xFFFFFFFF\n\n\
                        No introduzcas nada para eliminar la textura actual.\n\
                        Puedes ver las texturas en {"#PRIMARY_COLOR"}"TEXTURES_WEBPAGE"\
                    ",
                "Continuar", "Cerrar");
            }
            else ShowEditPObjectDialog(playerid);
            return Y_HOOKS_BREAK_RETURN_1;
        }
        case DIALOG_POBJECT_TEXTURE: 
        {
            if(response) 
            {
                new property_index = PLAYER_TEMP[playerid][pt_PLAYER_PROPERTY_SELECTED];
                if(strlen(inputtext) > 0) {
                    new modelid, txdname[64], texturename[64], inputColor[32];
                    if(!sscanf(inputtext, "ds[64]s[64]s[32]", modelid, txdname, texturename, inputColor)) { }
                    else if(!sscanf(inputtext, "ds[64]s[64]", modelid, txdname, texturename)) { }
                    else return SendNotification(playerid, "El formato no es válido.");

                    new color = 0;
                    if(strlen(inputColor) > 0) 
                    {
                        if(inputColor[0] == '0' && inputColor[1] == 'x') color = HexToInt(inputColor[2]);
                        if(inputColor[0] == '#') color = HexToInt(inputColor[1]);
                        else color = HexToInt(inputColor);
                    }

                    UpdatePObjectTexture(pPObjectCurrentID[playerid], pPObjectCurrentObjectID[playerid], pPObjectTextureIndex[playerid], modelid, txdname, texturename, color);
                    SendNotification(playerid, "Textura del mueble actualizada.");
                    ShowEditPObjectDialog(playerid);
                }
                else 
                {
                    DeletePObjectTexture(property_index, pPObjectCurrentID[playerid], pPObjectCurrentObjectID[playerid], pPObjectTextureIndex[playerid], true, playerid);
                    SendNotification(playerid, "Textura del mueble eliminada.");
                }
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDisconnect(playerid, reason) 
{
    DestroyPlayerPUObjectsMenu(playerid);
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_SPECTATING || newstate == PLAYER_STATE_WASTED) 
    {
        if(pPUObjectsMenuOpened[playerid]) {
		    CancelSelectTextDrawEx(playerid);
        }
	}
	return 1;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid) 
{
    if(clickedid == Text:INVALID_TEXT_DRAW && pPUObjectsMenuOpened[playerid]) 
    {
        DestroyPlayerPUObjectsMenu(playerid);
    }
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) 
{
    if(pPUObjectsMenuOpened[playerid]) 
    {
        if(playertextid == pUncreatedPObjectsTd[playerid][9]) //<<
        { 
            if((gettime() - pPUObjectsMenuLastPageChange[playerid]) < 1) SendNotification(playerid, "Cálmate.");
            else 
            {
                pPUObjectsMenuCurrentPage[playerid] --;
                if(pPUObjectsMenuCurrentPage[playerid] < 0) pPUObjectsMenuCurrentPage[playerid] = pPUObjectsMenuTotalPages[playerid] - 1;
                UpdatePUObjectsTextDraws(playerid);
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
        else if(playertextid == pUncreatedPObjectsTd[playerid][10]) //>>
        { 
            if((gettime() - pPUObjectsMenuLastPageChange[playerid]) < 1) SendNotification(playerid, "Cálmate.");
            else 
            {
                pPUObjectsMenuCurrentPage[playerid] ++;
                if(pPUObjectsMenuCurrentPage[playerid] > pPUObjectsMenuTotalPages[playerid] - 1) pPUObjectsMenuCurrentPage[playerid] = 0;
                UpdatePUObjectsTextDraws(playerid);
            }
            return Y_HOOKS_BREAK_RETURN_1;
        }
        else 
        {
            new mdlTdStartIndex = 2;
            for(new i = 0; i < UNCREATED_POBJECTS_PER_PAGE; i ++) 
            {
                if(playertextid == pUncreatedPObjectsTd[playerid][mdlTdStartIndex]) 
                {
                    CancelSelectTextDrawEx(playerid);

                    inline OnQueryLoaded()
                    {
                        new rows;
                        if(cache_get_row_count(rows))
                        {
                            if(rows) 
                            {
                                new
                                    id, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz,
                                    bool:isnull_texture0, texture0[256],
                                    bool:isnull_texture1, texture1[256],
                                    bool:isnull_texture2, texture2[256],
                                    bool:isnull_texture3, texture3[256],
                                    id_property
                                ;

                                cache_get_value_name_int(0, "id", id);
                                cache_get_value_name_int(0, "modelid", modelid);
                                cache_get_value_name_float(0, "x", x);
                                cache_get_value_name_float(0, "y", y);
                                cache_get_value_name_float(0, "z", z);
                                cache_get_value_name_float(0, "rx", rx);
                                cache_get_value_name_float(0, "ry", ry);
                                cache_get_value_name_float(0, "rz", rz);

                                cache_is_value_name_null(0, "texture0", isnull_texture0);
                                cache_is_value_name_null(0, "texture1", isnull_texture1);
                                cache_is_value_name_null(0, "texture2", isnull_texture2);
                                cache_is_value_name_null(0, "texture3", isnull_texture3);

                                if(!isnull_texture0) cache_get_value_name(0, "texture0", texture0);
                                if(!isnull_texture1) cache_get_value_name(0, "texture1", texture1);
                                if(!isnull_texture2) cache_get_value_name(0, "texture2", texture2);
                                if(!isnull_texture3) cache_get_value_name(0, "texture3", texture3);

                                cache_get_value_name_int(0, "id_property", id_property);

                                if(x == 0.0 && y == 0.0 && z == 0.0) 
                                {
                                    new Float:pos[3], Float:angle;
                                    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
                                    GetPlayerFacingAngle(playerid, angle);

                                    x = pos[0] + (3.0 * floatsin(-angle, degrees));
				                    y = pos[1] + (3.0 * floatcos(-angle, degrees));
                                    z = pos[2];
                                }

                                new property_index = GetPropertyIndexByID(id_property);
                                new objectid = CreatePropertyFurnitureObject(true, property_index, id, id_property, modelid, x, y, z, rx, ry, rz, texture0, texture1, texture2, texture3);
                                Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
                                
                                pPObjectCurrentModelID[playerid] = modelid;
                                pPObjectCurrentObjectID[playerid] = objectid;
                                pPObjectCurrentID[playerid] = id;
                                EditDynamicObject(playerid, objectid);
                            }
                        }
                    }

                    new object_id = pPUObjectsMenuIds[playerid][i];
                    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "SELECT * FROM property_objects WHERE id = %d;", object_id);
                    mysql_tquery_inline(mysql_db, QUERY_BUFFER, using inline OnQueryLoaded);
                    return Y_HOOKS_BREAK_RETURN_1;
                }
                mdlTdStartIndex ++;
            }
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

CreatePlayerPUObjectsMenu(playerid, property_index) 
{
    DestroyPlayerPUObjectsMenu(playerid);
    CreateUncreatedPObjectsTds(playerid);

    for(new i = 0; i < sizeof pUncreatedPObjectsTd[]; i ++) 
    {
        if(pUncreatedPObjectsTd[playerid][i] != PlayerText:INVALID_TEXT_DRAW) 
        {
            PlayerTextDrawShow(playerid, pUncreatedPObjectsTd[playerid][i]);
        }
    }
    SelectTextDrawEx(playerid, -1);

    pPUObjectsMenuTotalPages[playerid] = floatround(floatdiv(float(CountPropertyUncreatedObjects(PROPERTY_INFO[property_index][property_ID])), float(UNCREATED_POBJECTS_PER_PAGE)), floatround_ceil);
    pPUObjectsMenuOpened[playerid] = true;
    UpdatePUObjectsTextDraws(playerid);
}

UpdatePUObjectsTextDraws(playerid) 
{
    pPUObjectsMenuLastPageChange[playerid] = gettime();

    new property_index = PLAYER_TEMP[playerid][pt_PLAYER_PROPERTY_SELECTED];
    new id_property = PROPERTY_INFO[property_index][property_ID];

    for(new i = 0; i < UNCREATED_POBJECTS_PER_PAGE; i ++) 
    {
        pPUObjectsMenuIds[playerid][i] = 0;
    }

    new string[128];
    if(pPUObjectsMenuTotalPages[playerid] > 1) 
    {
        format(string, sizeof string, "Página_%d/%d", pPUObjectsMenuCurrentPage[playerid] + 1, pPUObjectsMenuTotalPages[playerid]);
        FixTextDrawString(string);
        PlayerTextDrawShow(playerid, pUncreatedPObjectsTd[playerid][9]);
        PlayerTextDrawShow(playerid, pUncreatedPObjectsTd[playerid][10]);
    }
    else 
    {
        format(string, sizeof string, "Página_1/1");
        FixTextDrawString(string);
        PlayerTextDrawHide(playerid, pUncreatedPObjectsTd[playerid][9]);
        PlayerTextDrawHide(playerid, pUncreatedPObjectsTd[playerid][10]);
    }
    PlayerTextDrawSetString(playerid, pUncreatedPObjectsTd[playerid][8], string);

    inline OnQueryLoaded()
	{
		new rows, count, modelids[UNCREATED_POBJECTS_PER_PAGE];
		if(cache_get_row_count(rows))
		{
			for(new i = 0; i != rows; i ++)
			{
                new id, modelid;
                cache_get_value_name_int(i, "id", id);
                cache_get_value_name_int(i, "modelid", modelid);

                pPUObjectsMenuIds[playerid][count] = id;
                modelids[count] = modelid;
                count ++;
            }
        }

        new mdlTdStartIndex = 2;
        for(new i = 0; i < UNCREATED_POBJECTS_PER_PAGE; i ++) 
        {
            if(modelids[i] == 0) 
            {
                PlayerTextDrawBackgroundColor(playerid, pUncreatedPObjectsTd[playerid][mdlTdStartIndex], -2139062172);
                PlayerTextDrawSetSelectable(playerid, pUncreatedPObjectsTd[playerid][mdlTdStartIndex], false);
                PlayerTextDrawSetPreviewModel(playerid, pUncreatedPObjectsTd[playerid][mdlTdStartIndex], 19483);
            }
            else 
            {
                PlayerTextDrawBackgroundColor(playerid, pUncreatedPObjectsTd[playerid][mdlTdStartIndex], -2139062017);
                PlayerTextDrawSetSelectable(playerid, pUncreatedPObjectsTd[playerid][mdlTdStartIndex], true);
                PlayerTextDrawSetPreviewModel(playerid, pUncreatedPObjectsTd[playerid][mdlTdStartIndex], modelids[i]);
            }

            PlayerTextDrawShow(playerid, pUncreatedPObjectsTd[playerid][mdlTdStartIndex]);
            mdlTdStartIndex ++;
        }        
    }
    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "SELECT id, modelid FROM property_objects WHERE id_property = %d AND `create` = 0 LIMIT "#UNCREATED_POBJECTS_PER_PAGE" OFFSET %d;", id_property, pPUObjectsMenuCurrentPage[playerid] * UNCREATED_POBJECTS_PER_PAGE);
    mysql_tquery_inline(mysql_db, QUERY_BUFFER, using inline OnQueryLoaded);
}

DestroyPlayerPUObjectsMenu(playerid) {
    for(new i = 0; i < sizeof pUncreatedPObjectsTd[]; i ++) {
        if(pUncreatedPObjectsTd[playerid][i] != PlayerText:INVALID_TEXT_DRAW) {
            PlayerTextDrawDestroy(playerid, pUncreatedPObjectsTd[playerid][i]);
            pUncreatedPObjectsTd[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
        }
    }

    pPUObjectsMenuOpened[playerid] = false;
    pPUObjectsMenuCurrentPage[playerid] = 0;
    pPUObjectsMenuTotalPages[playerid] = 0;
    pPUObjectsMenuLastPageChange[playerid] = 0;
    for(new i = 0; i < UNCREATED_POBJECTS_PER_PAGE; i ++) {
        pPUObjectsMenuIds[playerid][i] = 0;
    }
}

CreateUncreatedPObjectsTds(playerid) {
    pUncreatedPObjectsTd[playerid][0] = CreatePlayerTextDraw(playerid, 200.000000, 131.000000, "LD_SPAC:white");
    PlayerTextDrawTextSize(playerid, pUncreatedPObjectsTd[playerid][0], 240.000000, 214.000000);
    PlayerTextDrawAlignment(playerid, pUncreatedPObjectsTd[playerid][0], 1);
    PlayerTextDrawColor(playerid, pUncreatedPObjectsTd[playerid][0], 255);
    PlayerTextDrawSetShadow(playerid, pUncreatedPObjectsTd[playerid][0], 0);
    PlayerTextDrawBackgroundColor(playerid, pUncreatedPObjectsTd[playerid][0], 255);
    PlayerTextDrawFont(playerid, pUncreatedPObjectsTd[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, pUncreatedPObjectsTd[playerid][0], 0);

    pUncreatedPObjectsTd[playerid][1] = CreatePlayerTextDraw(playerid, 320.000000, 141.000000, "Muebles_guardados");
    PlayerTextDrawLetterSize(playerid, pUncreatedPObjectsTd[playerid][1], 0.285000, 1.388444);
    PlayerTextDrawAlignment(playerid, pUncreatedPObjectsTd[playerid][1], 2);
    PlayerTextDrawColor(playerid, pUncreatedPObjectsTd[playerid][1], -1);
    PlayerTextDrawSetShadow(playerid, pUncreatedPObjectsTd[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, pUncreatedPObjectsTd[playerid][1], 1);
    PlayerTextDrawBackgroundColor(playerid, pUncreatedPObjectsTd[playerid][1], 255);
    PlayerTextDrawFont(playerid, pUncreatedPObjectsTd[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, pUncreatedPObjectsTd[playerid][1], 1);

    pUncreatedPObjectsTd[playerid][2] = CreatePlayerTextDraw(playerid, 216.000000, 165.000000, "");
    PlayerTextDrawTextSize(playerid, pUncreatedPObjectsTd[playerid][2], 65.000000, 70.000000);
    PlayerTextDrawAlignment(playerid, pUncreatedPObjectsTd[playerid][2], 1);
    PlayerTextDrawColor(playerid, pUncreatedPObjectsTd[playerid][2], -1);
    PlayerTextDrawSetShadow(playerid, pUncreatedPObjectsTd[playerid][2], 0);
    PlayerTextDrawBackgroundColor(playerid, pUncreatedPObjectsTd[playerid][2], -2139062172);
    PlayerTextDrawFont(playerid, pUncreatedPObjectsTd[playerid][2], 5);
    PlayerTextDrawSetProportional(playerid, pUncreatedPObjectsTd[playerid][2], 0);
    PlayerTextDrawSetSelectable(playerid, pUncreatedPObjectsTd[playerid][2], false);
    PlayerTextDrawSetPreviewModel(playerid, pUncreatedPObjectsTd[playerid][2], 19483);
    PlayerTextDrawSetPreviewRot(playerid, pUncreatedPObjectsTd[playerid][2], 0.000000, 0.000000, 0.000000, 1.407349);

    pUncreatedPObjectsTd[playerid][3] = CreatePlayerTextDraw(playerid, 287.500000, 165.000000, "");
    PlayerTextDrawTextSize(playerid, pUncreatedPObjectsTd[playerid][3], 65.000000, 70.000000);
    PlayerTextDrawAlignment(playerid, pUncreatedPObjectsTd[playerid][3], 1);
    PlayerTextDrawColor(playerid, pUncreatedPObjectsTd[playerid][3], -1);
    PlayerTextDrawSetShadow(playerid, pUncreatedPObjectsTd[playerid][3], 0);
    PlayerTextDrawBackgroundColor(playerid, pUncreatedPObjectsTd[playerid][3], -2139062172);
    PlayerTextDrawFont(playerid, pUncreatedPObjectsTd[playerid][3], 5);
    PlayerTextDrawSetProportional(playerid, pUncreatedPObjectsTd[playerid][3], 0);
    PlayerTextDrawSetSelectable(playerid, pUncreatedPObjectsTd[playerid][3], false);
    PlayerTextDrawSetPreviewModel(playerid, pUncreatedPObjectsTd[playerid][3], 19483);
    PlayerTextDrawSetPreviewRot(playerid, pUncreatedPObjectsTd[playerid][3], 0.000000, 0.000000, 0.000000, 1.407349);

    pUncreatedPObjectsTd[playerid][4] = CreatePlayerTextDraw(playerid, 359.000000, 165.000000, "");
    PlayerTextDrawTextSize(playerid, pUncreatedPObjectsTd[playerid][4], 65.000000, 70.000000);
    PlayerTextDrawAlignment(playerid, pUncreatedPObjectsTd[playerid][4], 1);
    PlayerTextDrawColor(playerid, pUncreatedPObjectsTd[playerid][4], -1);
    PlayerTextDrawSetShadow(playerid, pUncreatedPObjectsTd[playerid][4], 0);
    PlayerTextDrawBackgroundColor(playerid, pUncreatedPObjectsTd[playerid][4], -2139062172);
    PlayerTextDrawFont(playerid, pUncreatedPObjectsTd[playerid][4], 5);
    PlayerTextDrawSetProportional(playerid, pUncreatedPObjectsTd[playerid][4], 0);
    PlayerTextDrawSetSelectable(playerid, pUncreatedPObjectsTd[playerid][4], false);
    PlayerTextDrawSetPreviewModel(playerid, pUncreatedPObjectsTd[playerid][4], 19483);
    PlayerTextDrawSetPreviewRot(playerid, pUncreatedPObjectsTd[playerid][4], 0.000000, 0.000000, 0.000000, 1.407349);

    pUncreatedPObjectsTd[playerid][5] = CreatePlayerTextDraw(playerid, 216.000000, 242.000000, "");
    PlayerTextDrawTextSize(playerid, pUncreatedPObjectsTd[playerid][5], 65.000000, 70.000000);
    PlayerTextDrawAlignment(playerid, pUncreatedPObjectsTd[playerid][5], 1);
    PlayerTextDrawColor(playerid, pUncreatedPObjectsTd[playerid][5], -1);
    PlayerTextDrawSetShadow(playerid, pUncreatedPObjectsTd[playerid][5], 0);
    PlayerTextDrawBackgroundColor(playerid, pUncreatedPObjectsTd[playerid][5], -2139062172);
    PlayerTextDrawFont(playerid, pUncreatedPObjectsTd[playerid][5], 5);
    PlayerTextDrawSetProportional(playerid, pUncreatedPObjectsTd[playerid][5], 0);
    PlayerTextDrawSetSelectable(playerid, pUncreatedPObjectsTd[playerid][5], false);
    PlayerTextDrawSetPreviewModel(playerid, pUncreatedPObjectsTd[playerid][5], 19483);
    PlayerTextDrawSetPreviewRot(playerid, pUncreatedPObjectsTd[playerid][5], 0.000000, 0.000000, 0.000000, 1.407349);

    pUncreatedPObjectsTd[playerid][6] = CreatePlayerTextDraw(playerid, 288.000000, 242.000000, "");
    PlayerTextDrawTextSize(playerid, pUncreatedPObjectsTd[playerid][6], 65.000000, 70.000000);
    PlayerTextDrawAlignment(playerid, pUncreatedPObjectsTd[playerid][6], 1);
    PlayerTextDrawColor(playerid, pUncreatedPObjectsTd[playerid][6], -1);
    PlayerTextDrawSetShadow(playerid, pUncreatedPObjectsTd[playerid][6], 0);
    PlayerTextDrawBackgroundColor(playerid, pUncreatedPObjectsTd[playerid][6], -2139062172);
    PlayerTextDrawFont(playerid, pUncreatedPObjectsTd[playerid][6], 5);
    PlayerTextDrawSetProportional(playerid, pUncreatedPObjectsTd[playerid][6], 0);
    PlayerTextDrawSetSelectable(playerid, pUncreatedPObjectsTd[playerid][6], false);
    PlayerTextDrawSetPreviewModel(playerid, pUncreatedPObjectsTd[playerid][6], 19483);
    PlayerTextDrawSetPreviewRot(playerid, pUncreatedPObjectsTd[playerid][6], 0.000000, 0.000000, 0.000000, 1.407349);

    pUncreatedPObjectsTd[playerid][7] = CreatePlayerTextDraw(playerid, 359.000000, 242.000000, "");
    PlayerTextDrawTextSize(playerid, pUncreatedPObjectsTd[playerid][7], 65.000000, 70.000000);
    PlayerTextDrawAlignment(playerid, pUncreatedPObjectsTd[playerid][7], 1);
    PlayerTextDrawColor(playerid, pUncreatedPObjectsTd[playerid][7], -1);
    PlayerTextDrawSetShadow(playerid, pUncreatedPObjectsTd[playerid][7], 0);
    PlayerTextDrawBackgroundColor(playerid, pUncreatedPObjectsTd[playerid][7], -2139062172);
    PlayerTextDrawFont(playerid, pUncreatedPObjectsTd[playerid][7], 5);
    PlayerTextDrawSetProportional(playerid, pUncreatedPObjectsTd[playerid][7], 0);
    PlayerTextDrawSetPreviewModel(playerid, pUncreatedPObjectsTd[playerid][7], 19483);
    PlayerTextDrawSetPreviewRot(playerid, pUncreatedPObjectsTd[playerid][7], 0.000000, 0.000000, 0.000000, 1.407349);

    pUncreatedPObjectsTd[playerid][8] = CreatePlayerTextDraw(playerid, 320.000000, 322.000000, "Pagina_1/1");
    PlayerTextDrawLetterSize(playerid, pUncreatedPObjectsTd[playerid][8], 0.217499, 1.055554);
    PlayerTextDrawAlignment(playerid, pUncreatedPObjectsTd[playerid][8], 2);
    PlayerTextDrawColor(playerid, pUncreatedPObjectsTd[playerid][8], -1);
    PlayerTextDrawSetShadow(playerid, pUncreatedPObjectsTd[playerid][8], 0);
    PlayerTextDrawSetOutline(playerid, pUncreatedPObjectsTd[playerid][8], 1);
    PlayerTextDrawBackgroundColor(playerid, pUncreatedPObjectsTd[playerid][8], 255);
    PlayerTextDrawFont(playerid, pUncreatedPObjectsTd[playerid][8], 1);
    PlayerTextDrawSetProportional(playerid, pUncreatedPObjectsTd[playerid][8], 1);

    pUncreatedPObjectsTd[playerid][9] = CreatePlayerTextDraw(playerid, 288.000000, 322.000000, "~<~");
    PlayerTextDrawLetterSize(playerid, pUncreatedPObjectsTd[playerid][9], 0.217499, 1.055554);
    PlayerTextDrawTextSize(playerid, pUncreatedPObjectsTd[playerid][9], 10.5, 15.000000);
    PlayerTextDrawAlignment(playerid, pUncreatedPObjectsTd[playerid][9], 2);
    PlayerTextDrawColor(playerid, pUncreatedPObjectsTd[playerid][9], -1);
    PlayerTextDrawSetShadow(playerid, pUncreatedPObjectsTd[playerid][9], 0);
    PlayerTextDrawSetOutline(playerid, pUncreatedPObjectsTd[playerid][9], 1);
    PlayerTextDrawBackgroundColor(playerid, pUncreatedPObjectsTd[playerid][9], 255);
    PlayerTextDrawFont(playerid, pUncreatedPObjectsTd[playerid][9], 1);
    PlayerTextDrawSetProportional(playerid, pUncreatedPObjectsTd[playerid][9], 1);
    PlayerTextDrawSetSelectable(playerid, pUncreatedPObjectsTd[playerid][9], true);

    pUncreatedPObjectsTd[playerid][10] = CreatePlayerTextDraw(playerid, 345.000000, 322.000000, "~>~");
    PlayerTextDrawLetterSize(playerid, pUncreatedPObjectsTd[playerid][10], 0.217499, 1.055554);
    PlayerTextDrawTextSize(playerid, pUncreatedPObjectsTd[playerid][10], 10.5, 15.000000);
    PlayerTextDrawAlignment(playerid, pUncreatedPObjectsTd[playerid][10], 2);
    PlayerTextDrawColor(playerid, pUncreatedPObjectsTd[playerid][10], -1);
    PlayerTextDrawSetShadow(playerid, pUncreatedPObjectsTd[playerid][10], 0);
    PlayerTextDrawSetOutline(playerid, pUncreatedPObjectsTd[playerid][10], 1);
    PlayerTextDrawBackgroundColor(playerid, pUncreatedPObjectsTd[playerid][10], 255);
    PlayerTextDrawFont(playerid, pUncreatedPObjectsTd[playerid][10], 1);
    PlayerTextDrawSetProportional(playerid, pUncreatedPObjectsTd[playerid][10], 1);
    PlayerTextDrawSetSelectable(playerid, pUncreatedPObjectsTd[playerid][10], true);
}

hook OnPlayerSelectDynObject(playerid, STREAMER_TAG_OBJECT objectid, modelid, Float:x, Float:y, Float:z) 
{
    new info[3];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, info);

    if(info[0] == OBJECT_TYPE_FURNITURE) 
    {
        if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_OWN_PROPERTY && PI[playerid][pi_LOCAL_INTERIOR] == info[2]) 
        {
            CancelEdit(playerid);
            pPObjectCurrentModelID[playerid] = modelid;
            pPObjectCurrentObjectID[playerid] = objectid;
            pPObjectCurrentID[playerid] = info[1];
            ShowEditPObjectDialog(playerid);
        }
        return Y_HOOKS_BREAK_RETURN_1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerEditDynObject(playerid, STREAMER_TAG_OBJECT objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) 
{
    new info[3];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, info);

    if(info[0] == OBJECT_TYPE_FURNITURE) 
    {
        switch(response) 
        {
            case EDIT_RESPONSE_CANCEL: 
            {
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
                ShowEditPObjectDialog(playerid);
            }
            case EDIT_RESPONSE_FINAL: {
                SetDynamicObjectPos(objectid, x, y, z);
                SetDynamicObjectRot(objectid, rx, ry, rz);
                UpdatePObjectDB_Positions(pPObjectCurrentID[playerid], x, y, z, rx, ry, rz);
                SendNotification(playerid, "La posición del mueble se ha actualizado correctamente.");
                ShowEditPObjectDialog(playerid);
            }
        }
        return Y_HOOKS_BREAK_RETURN_1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

ShowEditPObjectDialog(playerid) {
    new dialog_body[512];
    format(dialog_body, sizeof dialog_body, "1. Mover\n2. Texturizar\n3. Clonar (%s$)\n4. Guardar\n5. Eliminar", number_format_thousand(GetPObjectModelPrice(pPObjectCurrentModelID[playerid])));

    PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
    PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_POBJECT_EDIT;
    ShowPlayerDialog(playerid, DIALOG_POBJECT_EDIT, DIALOG_STYLE_LIST, "Mueble", dialog_body, "Continuar", "Cerrar");
}

UpdatePObjectDB(id_object, create, modelid, Float:x, Float:y, Float:z, Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0, texture0[] = "", texture1[] = "", texture2[] = "", texture3[] = "") {
    mysql_format(
        mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER,
        "\
            UPDATE property_objects SET \
                `create` = %d,\
                modelid = %d,\
                x = %f,\
                y = %f,\
                z = %f,\
                rx = %f,\
                ry = %f,\
                rz = %f,\
                texture0 = '%e',\
                texture1 = '%e',\
                texture2 = '%e',\
                texture3 = '%e' \
            WHERE id = %d;\
        ",
        create,
        modelid,
        x, y, z,
        rx, ry, rz,
        texture0,
        texture1,
        texture2,
        texture3,
        id_object
    );
    mysql_tquery(mysql_db, QUERY_BUFFER);
}

UpdatePObjectDB_Positions(id_object, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    mysql_format(
        mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER,
        "\
            UPDATE property_objects SET \
                x = %f,\
                y = %f,\
                z = %f,\
                rx = %f,\
                ry = %f,\
                rz = %f \
            WHERE id = %d;\
        ",
        x, y, z,
        rx, ry, rz,
        id_object
    );
    mysql_tquery(mysql_db, QUERY_BUFFER);
}

UpdatePObjectDB_Texture(id_object, materialindex, texture[] = "") {
    mysql_format(
        mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER,
        "\
            UPDATE property_objects SET \
                texture%d = '%e' \
            WHERE id = %d;\
        ",
        materialindex,
        texture,
        id_object
    );
    mysql_tquery(mysql_db, QUERY_BUFFER);
}

UpdatePObjectTexture(id_object, objectid, materialindex, modelid, txdname[], texturename[], color) {
    SetDynamicObjectMaterial(objectid, materialindex, modelid, txdname, texturename, color);

    new string[256];
    format(string, sizeof string, "%d, %s, %s, %d", modelid, txdname, texturename, color);
    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE property_objects SET texture%d = '%e' WHERE id = %d;", materialindex, string, id_object);
    mysql_tquery(mysql_db, QUERY_BUFFER);
}

DeletePObjectTexture(property_index, id_object, objectid, materialindex, bool:menuDialogWhenCreate = false, forplayerid = INVALID_PLAYER_ID) {
    new index = -1;
    for(new i = 0; i < list_size(PropertyObjects[property_index]); i ++) {
        if(list_get(PropertyObjects[property_index], i) == objectid) {
            index = i;
            break;
        }
    }

    if(index != -1) list_remove(PropertyObjects[property_index], index);
    DestroyDynamicObject(objectid);
    UpdatePObjectDB_Texture(id_object, materialindex);

    inline OnQueryLoaded()
    {
        new rows;
        if(cache_get_row_count(rows))
        {
            if(rows) {
                new
                    id, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz,
                    bool:isnull_texture0, texture0[256],
                    bool:isnull_texture1, texture1[256],
                    bool:isnull_texture2, texture2[256],
                    bool:isnull_texture3, texture3[256],
                    id_property
                ;
                
                cache_get_value_name_int(0, "id", id);
                cache_get_value_name_int(0, "modelid", modelid);
                cache_get_value_name_float(0, "x", x);
                cache_get_value_name_float(0, "y", y);
                cache_get_value_name_float(0, "z", z);
                cache_get_value_name_float(0, "rx", rx);
                cache_get_value_name_float(0, "ry", ry);
                cache_get_value_name_float(0, "rz", rz);

                cache_is_value_name_null(0, "texture0", isnull_texture0);
                cache_is_value_name_null(0, "texture1", isnull_texture1);
                cache_is_value_name_null(0, "texture2", isnull_texture2);
                cache_is_value_name_null(0, "texture3", isnull_texture3);

                if(!isnull_texture0 && materialindex != 0) cache_get_value_name(0, "texture0", texture0);
                if(!isnull_texture1 && materialindex != 1) cache_get_value_name(0, "texture1", texture1);
                if(!isnull_texture2 && materialindex != 2) cache_get_value_name(0, "texture2", texture2);
                if(!isnull_texture3 && materialindex != 3) cache_get_value_name(0, "texture3", texture3);

                cache_get_value_name_int(0, "id_property", id_property);

                new newObjectid = CreatePropertyFurnitureObject(false, property_index, id_object, id_property, modelid, x, y, z, rx, ry, rz, texture0, texture1, texture2, texture3);
                if(menuDialogWhenCreate && forplayerid != INVALID_PLAYER_ID) {
                    Streamer_Update(forplayerid, STREAMER_TYPE_OBJECT);
                    pPObjectCurrentModelID[forplayerid] = modelid;
                    pPObjectCurrentObjectID[forplayerid] = newObjectid;
                    pPObjectCurrentID[forplayerid] = id;
                    ShowEditPObjectDialog(forplayerid);
                }
            }
        }
    }
    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "SELECT * FROM property_objects WHERE id = %d;", id_object);
    mysql_tquery_inline(mysql_db, QUERY_BUFFER, using inline OnQueryLoaded);
}

hook OnDefaultPFurChanged(index) {
    for_list(i : PropertyObjects[index])
    {
        new objectid = iter_get(i);

        new Float:z_pos;
        Streamer_GetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_Z, z_pos);
        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_Z, z_pos + (PROPERTY_INFO[index][property_DIS_DEFAULT_INTERIOR] ? PROPERTY_EMPTY_INTERIOR_Z_OFFSET : -PROPERTY_EMPTY_INTERIOR_Z_OFFSET));
    }

    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE property_objects SET z = z + (%f) WHERE x != 0.0 AND y != 0.0 and z != 0.0 AND id_property = %d;", (PROPERTY_INFO[index][property_DIS_DEFAULT_INTERIOR] ? PROPERTY_EMPTY_INTERIOR_Z_OFFSET : -PROPERTY_EMPTY_INTERIOR_Z_OFFSET), PROPERTY_INFO[index][property_ID]);
    mysql_tquery(mysql_db, QUERY_BUFFER);
}
