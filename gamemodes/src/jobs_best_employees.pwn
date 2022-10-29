#include <YSI-Includes\YSI\y_hooks>

#define RESET_JOBS_EMPLOYEES_RECORD 48 //horas
#define MAX_JOBS_TOP_EMPLOYEES 8 //aparecerán X empleados en el top (en la pizarra y a quienes se les entrega premio)
#define JOBS_RECORD_UPDATE_INTERVAL 300000 //comprobar cada 5 mins

enum E_JobsRecordsBoards 
{
    jobBoard_WORK,
    Float:jobBoard_X,
    Float:jobBoard_Y,
    Float:jobBoard_Z,
    Float:jobBoard_RX,
    Float:jobBoard_RY,
    Float:jobBoard_RZ,
    jobBoard_INTERIOR,
    jobBoard_WORLD,

    jobBoard_RESET_OBJECTID,
    jobBoard_TOP_OBJECTID
};

new JobsRecordsBoards[][E_JobsRecordsBoards] = 
{
    {WORK_TRUCK, -510.386169, -501.655273, 24.503437,           0.0, 0.0, 0.0, 0, 0, INVALID_STREAMER_ID, INVALID_STREAMER_ID},
    {WORK_MECANICO, 1832.541870, -1418.740234, 12.531561,       0.0, 0.0, 180.0, 0, 0, INVALID_STREAMER_ID, INVALID_STREAMER_ID},
    {WORK_TRASH, -1900.10193, -1750.98767, 20.73474,            0.0, 0.0, 64.48077, 0, 0, INVALID_STREAMER_ID, INVALID_STREAMER_ID},
    {WORK_LUMBERJACK, -526.22412, -98.41670, 62.14240,          0.0, 3.50, 37.38440, 0, 0, INVALID_STREAMER_ID, INVALID_STREAMER_ID},
    {WORK_HARVESTER, -371.16531, -1446.77783, 24.69432,         0.0, 0.0, 90.0, 0, 0, INVALID_STREAMER_ID, INVALID_STREAMER_ID},
    {WORK_FUMIGATOR, -1346.82959, -2191.87769, 22.03486,        0.0, 0.0, 0.0, 0, 0, INVALID_STREAMER_ID, INVALID_STREAMER_ID},
    {WORK_FARMER, 1562.85254, 33.95354, 23.15429,   0.00000,    0.0, 138.80991, 0, 0, INVALID_STREAMER_ID, INVALID_STREAMER_ID},
    {WORK_WAREHOUSE, 1929.148071, -1514.769897, 1393.058349,    0.0, 0.0, 0.0, 11, 0, INVALID_STREAMER_ID, INVALID_STREAMER_ID},
    {WORK_DELIVERYMAN, -1021.831420, -595.056518, 30.967796,    0.0, 0.0, 210.899995, 0, 0, INVALID_STREAMER_ID, INVALID_STREAMER_ID},
    {WORK_TRAILERO, 2796.7761, 970.1790, 9.7000,                0.0, 0.0, 222.0, INVALID_STREAMER_ID, INVALID_STREAMER_ID}
};

enum E_PlayerWorksPoints 
{
    pworksPoints_POINTS
};
new PlayerWorksPoints[MAX_PLAYERS][sizeof(work_info)][E_PlayerWorksPoints];

forward OnJobsRecordsRequestUpdate();

hook OnScriptInit() 
{
    for(new i = 0; i < sizeof JobsRecordsBoards; i ++) 
    {
        new tmpobjid;
        CreateDynamicObject(3077, JobsRecordsBoards[i][jobBoard_X], JobsRecordsBoards[i][jobBoard_Y], JobsRecordsBoards[i][jobBoard_Z], JobsRecordsBoards[i][jobBoard_RX], JobsRecordsBoards[i][jobBoard_RY], JobsRecordsBoards[i][jobBoard_RZ], JobsRecordsBoards[i][jobBoard_WORLD], JobsRecordsBoards[i][jobBoard_INTERIOR]);

        new Float:pos[3], Float:rot[3];

        AttachObjectToObjectEx(
            JobsRecordsBoards[i][jobBoard_X], JobsRecordsBoards[i][jobBoard_Y], JobsRecordsBoards[i][jobBoard_Z],
            JobsRecordsBoards[i][jobBoard_RX], JobsRecordsBoards[i][jobBoard_RY], JobsRecordsBoards[i][jobBoard_RZ],
            -0.005279, 0.045013, 2.240036, 0.0, 0.0, 90.0,
            pos[0], pos[1], pos[2], rot[0], rot[1], rot[2]
        );
        tmpobjid = CreateDynamicObject(19483, pos[0], pos[1], pos[2], rot[0], rot[1], rot[2], JobsRecordsBoards[i][jobBoard_WORLD], JobsRecordsBoards[i][jobBoard_INTERIOR]);
        SetDynamicObjectMaterialText(tmpobjid, 0, "{FFFFFF}MEJORES EMPLEADOS", 130, "Arial", 43, 1, 0x00000000, 0x00000000, 0);

        AttachObjectToObjectEx(
            JobsRecordsBoards[i][jobBoard_X], JobsRecordsBoards[i][jobBoard_Y], JobsRecordsBoards[i][jobBoard_Z],
            JobsRecordsBoards[i][jobBoard_RX], JobsRecordsBoards[i][jobBoard_RY], JobsRecordsBoards[i][jobBoard_RZ],
            -0.005279, 0.045013, 2.050031, 0.0, 0.0, 90.0,
            pos[0], pos[1], pos[2], rot[0], rot[1], rot[2]
        );
        JobsRecordsBoards[i][jobBoard_RESET_OBJECTID] = CreateDynamicObject(19483, pos[0], pos[1], pos[2], rot[0], rot[1], rot[2], JobsRecordsBoards[i][jobBoard_WORLD], JobsRecordsBoards[i][jobBoard_INTERIOR]);
        SetDynamicObjectMaterialText(JobsRecordsBoards[i][jobBoard_RESET_OBJECTID], 0, "Se reestablece en", 130, "Arial", 20, 1, 0xFFFFFFFF, 0x00000000, 0);

        AttachObjectToObjectEx(
            JobsRecordsBoards[i][jobBoard_X], JobsRecordsBoards[i][jobBoard_Y], JobsRecordsBoards[i][jobBoard_Z],
            JobsRecordsBoards[i][jobBoard_RX], JobsRecordsBoards[i][jobBoard_RY], JobsRecordsBoards[i][jobBoard_RZ],
            -0.005279, 0.045013, 1.880027, 0.0, 0.0, 90.0,
            pos[0], pos[1], pos[2], rot[0], rot[1], rot[2]
        );
        JobsRecordsBoards[i][jobBoard_TOP_OBJECTID] = CreateDynamicObject(19483, pos[0], pos[1], pos[2], rot[0], rot[1], rot[2], JobsRecordsBoards[i][jobBoard_WORLD], JobsRecordsBoards[i][jobBoard_INTERIOR]);
        SetDynamicObjectMaterialText(JobsRecordsBoards[i][jobBoard_TOP_OBJECTID], 0, "- Sin datos", 130, "Segoe UI", 30, 1, 0xFFFFFFFF, 0x00000000, 0);
    }
}

hook OnInfoVarsLoaded() {
    if(JobsPointsLastReset == 0) {
        JobsPointsLastReset = gettime();
        SaveInfoVars();
    }

    SetTimer("OnJobsRecordsRequestUpdate", JOBS_RECORD_UPDATE_INTERVAL, true);
    OnJobsRecordsRequestUpdate();
}

hook OnPlayerDisconnect(playerid, reason) {
    new tmp[E_PlayerWorksPoints];
    for(new i = 0; i < sizeof PlayerWorksPoints[]; i ++) {
        PlayerWorksPoints[playerid][i] = tmp;
    }
}

hook OnPlayerLogin(playerid) {
    LoadPlayerWorksPoints(playerid);
}

LoadPlayerWorksPoints(playerid) {
    inline OnQueryLoaded()
	{
		new rows;
		if(cache_get_row_count(rows))
		{
			for(new i = 0; i != rows; i ++)
			{
				new work, points, last_prize;
				cache_get_value_name_int(i, "id_work", work);
				cache_get_value_name_int(i, "points", points);
				cache_get_value_name_int(i, "last_prize", last_prize);
                
                PlayerWorksPoints[playerid][work][pworksPoints_POINTS] = points;
                if(last_prize > 0) {
                    SendFormatNotification(playerid, "~g~¡Felicidades! ~w~Has ganado ~y~%s$ ~w~como premio por el esfuerzo realizado en tu trabajo de ~y~%s.",
                        number_format_thousand(last_prize),
                        work_info[work][work_info_NAME]
                    );

                    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE pworks_points SET last_prize = 0 WHERE id_player = %d AND id_work = %d;", PI[playerid][pi_ID], work);
                    mysql_tquery(mysql_db, QUERY_BUFFER);
                }
            }
        }
    }
    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "SELECT * FROM pworks_points WHERE id_player = %d;", PI[playerid][pi_ID]);
	mysql_tquery_inline(mysql_db, QUERY_BUFFER, using inline OnQueryLoaded);
}

AddPlayerJobPoints(playerid, work, points = 1, bool:message = true)
{
    PlayerWorksPoints[playerid][work][pworksPoints_POINTS] += points;

    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "INSERT INTO pworks_points (points, id_player, id_work) VALUES(%d, %d, %d) ON DUPLICATE KEY UPDATE points = %d;",
        PlayerWorksPoints[playerid][work][pworksPoints_POINTS],
        PI[playerid][pi_ID],
        work,
        PlayerWorksPoints[playerid][work][pworksPoints_POINTS]
    );
	mysql_tquery(mysql_db, QUERY_BUFFER);

    UpdateJobBoard(work, true);

    if(message)
	{
        SendFormatNotification(playerid, "~w~Llevas ~y~%d %s ~w~para el premio de mejores empleados.", PlayerWorksPoints[playerid][work][pworksPoints_POINTS], GetJobsBestEmployeesPointsName(work));
    }
}

GetJobsBestEmployeesPointsName(work)
{
    new pointsName[32] = "puntos";
    switch(work) {
        case WORK_TRUCK: pointsName = "recorridos";
    }
    return pointsName;
}

UpdateJobBoard(work, bool:check_time = false)
{
    inline OnQueryLoaded()
    {
        new resetSecondsLeft = GetJobsRecordsResestSecondsLeft();
        if(check_time && resetSecondsLeft <= 0)
		{
            OnJobsRecordsRequestUpdate();
        }
        else 
        {
            new resetString[128];
            format(resetString, sizeof resetString, "Se reestablece en %s.", TimeConvertExAsText(resetSecondsLeft, true));

            new rows;
            if(cache_get_row_count(rows))
            {
                if(rows)
                {
                    new currentPrize = work_info[work][work_info_TOP_MAX_PRIZE], pointsName[32];
                    format(pointsName, sizeof pointsName, "%s", GetJobsBestEmployeesPointsName(work));
                    new topString[128 * MAX_JOBS_TOP_EMPLOYEES];
                    for(new i = 0; i != rows; i ++)
                    {
                        new points, player_name[24];
                        cache_get_value_name_int(i, "points", points);
                        cache_get_value_name(i, "player_name", player_name);

                        new string[128];
                        if(i == 0 && work_info[work][work_info_TOP1_COINS_PRIZE] > 0) format(string, sizeof string, "%d. %s (%s %s) (%s$ y %d "SERVER_COIN")\n", i + 1, player_name, number_format_thousand(points), pointsName, number_format_thousand(currentPrize), work_info[work][work_info_TOP1_COINS_PRIZE]);
                        else format(string, sizeof string, "%d. %s (%s %s) (%s$)\n", i + 1, player_name, number_format_thousand(points), pointsName, number_format_thousand(currentPrize));
                        strcat(topString, string);
                        
                        currentPrize -= work_info[work][work_info_TOP_PRIZE_DECREASE];
                        if(currentPrize < work_info[work][work_info_TOP_MIN_PRIZE]) currentPrize = work_info[work][work_info_TOP_MIN_PRIZE];
                    }

                    SetWorkBoardsString(work, resetString, topString);
                    return 1;
                }
            }

            SetWorkBoardsString(work, resetString, "- Sin datos");
        }
    }
    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "SELECT pworks_points.points, player.name AS player_name FROM pworks_points INNER JOIN player ON pworks_points.id_player = player.id WHERE pworks_points.id_work = %d AND pworks_points.points > 0 ORDER BY pworks_points.points DESC LIMIT "#MAX_JOBS_TOP_EMPLOYEES";", work);
    mysql_tquery_inline(mysql_db, QUERY_BUFFER, using inline OnQueryLoaded);
    return 1;
}

SetWorkBoardsString(work, reset_string[], top_string[]) 
{
    for(new i = 0; i < sizeof JobsRecordsBoards; i ++) 
    {
        if(JobsRecordsBoards[i][jobBoard_WORK] == work) 
        {
            SetDynamicObjectMaterialText(JobsRecordsBoards[i][jobBoard_RESET_OBJECTID], 0, reset_string, 130, "Arial", 20, 1, 0xFFFFFFFF, 0x00000000, 0);
            SetDynamicObjectMaterialText(JobsRecordsBoards[i][jobBoard_TOP_OBJECTID], 0, top_string, 130, "Segoe UI", 30, 1, 0xFFFFFFFF, 0x00000000, 0);
        }
    }
}

public OnJobsRecordsRequestUpdate() 
{
    new resetSecondsLeft = GetJobsRecordsResestSecondsLeft();
    if(resetSecondsLeft <= 0) 
    {
        //obtener los premiados
        for(new i = 1; i < sizeof(work_info); i ++) 
        {
            inline OnQueryLoaded()
            {
                new rows;
                if(cache_get_row_count(rows))
                {
                    if(rows)
                    {
                        new currentPrize = work_info[i][work_info_TOP_MAX_PRIZE];
                        for(new j = 0; j != rows; j ++)
				        {
                            new pid, connected, playerid;
                            cache_get_value_name_int(j, "id", pid);
                            cache_get_value_name_int(j, "connected", connected);
                            cache_get_value_name_int(j, "playerid", playerid);

                            if(connected && PI[playerid][pi_ID] == pid) 
                            {
                                GivePlayerCash(playerid, currentPrize, true, false);
                                if(j == 0 && work_info[i][work_info_TOP1_COINS_PRIZE] > 0) 
                                {
                                    PI[playerid][pi_COINS] += work_info[i][work_info_TOP1_COINS_PRIZE];
                                    
                                    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE player SET coins = %d WHERE id = %d;", PI[playerid][pi_COINS], PI[playerid][pi_ID]);
                                    mysql_tquery(mysql_db, QUERY_BUFFER);

                                    SendClientMessageEx(playerid, COLOR_PRINCIPAL, "·{FFFFFF}¡Felicidades! Has quedado en el puesto {FCE679}n°%d {FFFFFF}de mejores empleados en el trabajo de {FCE679}%s {FFFFFF}y has recibido {2BA30A}%s$ {FFFFFF}y {2BA30A}%d {FFFFFF}"SERVER_COIN" como premio.",
                                        j + 1,
                                        work_info[i][work_info_NAME],
                                        number_format_thousand(currentPrize),
                                        work_info[i][work_info_TOP1_COINS_PRIZE]
                                    );
                                }
                                else 
                                {
                                    SendClientMessageEx(playerid, COLOR_PRINCIPAL, "·{FFFFFF}¡Felicidades! Has quedado en el puesto {FCE679}n°%d {FFFFFF}de mejores empleados en el trabajo de {FCE679}%s {FFFFFF}y has recibido {2BA30A}%s$ {FFFFFF}como premio.",
                                        j + 1,
                                        work_info[i][work_info_NAME],
                                        number_format_thousand(currentPrize)
                                    );
                                }
                            }
                            else 
                            {
                                mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE pworks_points SET last_prize = last_prize + %d WHERE id_player = %d AND id_work = %d;", currentPrize, pid, i);
                                mysql_tquery(mysql_db, QUERY_BUFFER);

                                mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE player SET cash = cash + %d WHERE id = %d;", currentPrize, pid);
                                mysql_tquery(mysql_db, QUERY_BUFFER);

                                if(j == 0 && work_info[i][work_info_TOP1_COINS_PRIZE] > 0) 
                                {
                                    mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE player SET coins = coins + %d WHERE id = %d;", work_info[i][work_info_TOP1_COINS_PRIZE], pid);
                                    mysql_tquery(mysql_db, QUERY_BUFFER);
                                }
                            }

                            currentPrize -= work_info[i][work_info_TOP_PRIZE_DECREASE];
                            if(currentPrize < work_info[i][work_info_TOP_MIN_PRIZE]) currentPrize = work_info[i][work_info_TOP_MIN_PRIZE];
                        }
                    }
                }

                //resetear
                mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "UPDATE pworks_points SET points = 0 WHERE id_work = %d;", i);
                mysql_tquery(mysql_db, QUERY_BUFFER);
                for(new k, j = GetPlayerPoolSize(); k <= j; k++)
                {
                    if(IsPlayerConnected(k))
                    {
                        PlayerWorksPoints[k][i][pworksPoints_POINTS] = 0;
                    }
                }
                UpdateJobBoard(i);
            }
            mysql_format(mysql_db, QUERY_BUFFER, sizeof QUERY_BUFFER, "SELECT player.id, player.connected, player.playerid FROM pworks_points INNER JOIN player ON pworks_points.id_player = player.id WHERE pworks_points.id_work = %d AND pworks_points.points > 0 ORDER BY pworks_points.points DESC LIMIT "#MAX_JOBS_TOP_EMPLOYEES";", i);
            mysql_tquery_inline(mysql_db, QUERY_BUFFER, using inline OnQueryLoaded);
        }

        //resetear
        JobsPointsLastReset = gettime();
        SaveInfoVars();
    }
    else 
    {
        //actualizar pizarras
        for(new i = 1; i < sizeof(work_info); i ++) 
        {
            UpdateJobBoard(i);
        }
    }
    return 1;
}

GetJobsRecordsResestSecondsLeft() 
{
    return ((RESET_JOBS_EMPLOYEES_RECORD * 3600) - (gettime() - JobsPointsLastReset));
}
