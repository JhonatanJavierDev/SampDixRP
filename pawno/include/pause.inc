// Creador del Include: Gryphus One

// Modificaciones y traducción: HERMES

#if defined _OnPlayerPause_included
    #endinput
#endif
#define _OnPlayerPause_included

#include <a_samp>

// Defines

#define MinTimeWithoutUpdates 2 // Tiempo en el que el jugador será considerado "pausado" (segundos).
//#define ENVIARMENSAJE // Descomentar si quieres que envíe un mensaje a todos cuando un jugador pausea.
#define Amarillo 0xFFFF00AA // Color del mensaje que enviará si "ENVIARMENSAJE" está descomentado.

new stock TimeOfLastUpdate[MAX_PLAYERS];
new stock bool:Pausado[MAX_PLAYERS];
new stock bool:InClassSelection[MAX_PLAYERS];

stock IsPlayerPaused(playerid)
{
    if(Pausado[playerid] == true)
    {
        return 1;
    }
    return 0;
}

stock IsPlayerInClassSelection(playerid)
{
    if(InClassSelection[playerid] == true)
    {
        return 1;
    }
    return 0;
}

#define MinTimeWithoutUpdates2 (MinTimeWithoutUpdates * 1000)

forward BuscarPausados();
public BuscarPausados()
{
    new CurrentTime, PlayerState;
    CurrentTime = GetTickCount();
    for(new i = 0; i < MAX_PLAYERS; i ++)
    {
        if(Pausado[i] == false)
        // Si no está pausado...
        {
            if(InClassSelection[i] == false)
            // Evitamos un falso-positivo de OnPlayerClassSelection.
            {
                if(IsPlayerConnected(i))
                {
                    if( (CurrentTime - TimeOfLastUpdate[i]) >= MinTimeWithoutUpdates2 )
                    {
                        PlayerState = GetPlayerState(i);
                        if( (PlayerState == PLAYER_STATE_ONFOOT) || (PlayerState == PLAYER_STATE_DRIVER) || (PlayerState == PLAYER_STATE_PASSENGER) )
                        {
                            OnPlayerPause(i);
                        }
                    }
                }
            }
        }
    }
    return 1;
}

forward OnPlayerPause(playerid);
forward OnPlayerUnpause(playerid);

static gOnPlPa_HasCB[7];

public OnGameModeInit()
{
    SetTimer("BuscarPausados", 500, true);

    gOnPlPa_HasCB[0] = funcidx("OnPlPa_OnPlayerConnect") != -1;
    gOnPlPa_HasCB[1] = funcidx("OnPlPa_OnPlayerDisconnect") != -1;
    gOnPlPa_HasCB[2] = funcidx("OnPlPa_OnPlayerRequestClass") != -1;
    gOnPlPa_HasCB[3] = funcidx("OnPlPa_OnPlayerSpawn") != -1;
    gOnPlPa_HasCB[4] = funcidx("OnPlPa_OnPlayerUpdate") != -1;
    gOnPlPa_HasCB[5] = funcidx("OnPlPa_OnPlayerPause") != -1;
    gOnPlPa_HasCB[6] = funcidx("OnPlPa_OnPlayerUnpause") != -1;
    if (funcidx("OnPlPa_OnGameModeInit") != -1)
    {
        return CallLocalFunction("OnPlPa_OnGameModeInit", "");
    }

    return 1;
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit OnPlPa_OnGameModeInit
forward OnPlPa_OnGameModeInit();

public OnPlayerConnect(playerid)
{
    Pausado[playerid] = false;
    InClassSelection[playerid] = false;

    if (gOnPlPa_HasCB[0])
    {
        return CallLocalFunction("OnPlPa_OnPlayerConnect", "i",playerid);
    }
    return 1;
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect OnPlPa_OnPlayerConnect
forward OnPlPa_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid,  reason)
{
    Pausado[playerid] = false;
    InClassSelection[playerid] = false;

    if (gOnPlPa_HasCB[1])
    {
        return CallLocalFunction("OnPlPa_OnPlayerDisconnect", "ii",playerid,  reason);
    }
    return 1;
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect OnPlPa_OnPlayerDisconnect
forward OnPlPa_OnPlayerDisconnect(playerid,  reason);

public OnPlayerRequestClass(playerid,  classid)
{
    InClassSelection[playerid] = true;

    if (gOnPlPa_HasCB[2])
    {
        return CallLocalFunction("OnPlPa_OnPlayerRequestClass", "ii",playerid,  classid);
    }
    return 1;
}
#if defined _ALS_OnPlayerRequestClass
    #undef OnPlayerRequestClass
#else
    #define _ALS_OnPlayerRequestClass
#endif
#define OnPlayerRequestClass OnPlPa_OnPlayerRequestClass
forward OnPlPa_OnPlayerRequestClass(playerid,  classid);

public OnPlayerSpawn(playerid)
{
    InClassSelection[playerid] = false;

    if (gOnPlPa_HasCB[3])
    {
        return CallLocalFunction("OnPlPa_OnPlayerSpawn", "i",playerid);
    }
    return 1;
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn OnPlPa_OnPlayerSpawn
forward OnPlPa_OnPlayerSpawn(playerid);

public OnPlayerUpdate(playerid)
{
    TimeOfLastUpdate[playerid] = GetTickCount();
    if(Pausado[playerid] == true)
    // Chequeamos si ha vuelto de la pausa.
    {
        OnPlayerUnpause(playerid);
    }

    if (gOnPlPa_HasCB[4])
    {
        return CallLocalFunction("OnPlPa_OnPlayerUpdate", "i",playerid);
    }
    return 1;
}
#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate OnPlPa_OnPlayerUpdate
forward OnPlPa_OnPlayerUpdate(playerid);

public OnPlayerPause(playerid)
{
    Pausado[playerid] = true;
    #if defined ENVIARMENSAJE
        new NombreP[MAX_PLAYER_NAME], Mensaje[128];
        GetPlayerName(playerid, NombreP, sizeof(NombreP));
        format(Mensaje, sizeof(Mensaje), "[!] %s Ahora está en pausa.", NombreP);
        SendClientMessageToAll(Amarillo, Mensaje); // Cambiar "Amarillo" a gusto.
    #endif

    if (gOnPlPa_HasCB[5])
    {
        return CallLocalFunction("OnPlPa_OnPlayerPause", "i",playerid);
    }
    return 1;
}
#if defined _ALS_OnPlayerPause
    #undef OnPlayerPause
#else
    #define _ALS_OnPlayerPause
#endif
#define OnPlayerPause OnPlPa_OnPlayerPause
forward OnPlPa_OnPlayerPause(playerid);

public OnPlayerUnpause(playerid)
{
    Pausado[playerid] = false;
    #if defined ENVIARMENSAJE
        new NombreP[MAX_PLAYER_NAME], Mensaje[128];
        GetPlayerName(playerid, NombreP, sizeof(NombreP));
        format(Mensaje, sizeof(Mensaje), "[!] %s Ya no está en pausa.", NombreP);
        SendClientMessageToAll(Amarillo, Mensaje); // Cambiar "Amarillo" a gusto.
    #endif

    if (gOnPlPa_HasCB[6])
    {
        return CallLocalFunction("OnPlPa_OnPlayerUnpause", "i",playerid);
    }
    return 1;
}
#if defined _ALS_OnPlayerUnpause
    #undef OnPlayerUnpause
#else
    #define _ALS_OnPlayerUnpause
#endif
#define OnPlayerUnpause OnPlPa_OnPlayerUnpause
forward OnPlPa_OnPlayerUnpause(playerid);

