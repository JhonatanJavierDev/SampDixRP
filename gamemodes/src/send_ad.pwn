#include <YSI-Includes\YSI\y_hooks>

enum
{
    TWITTER,
    TWITTER_A
}

CMD:twitter(playerid, params[])
{
	if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_CRACK || PI[playerid][pi_STATE] == ROLEPLAY_STATE_JAIL || PI[playerid][pi_STATE] == ROLEPLAY_STATE_ARRESTED) return SendNotification(playerid, "Ahora no puedes usar este comando.");
	if(!PI[playerid][pi_PHONE_NUMBER]) return SendNotification(playerid, "No tienes ningún teléfono, puedes ir a cualquier ~g~24/7 ~w~para comprar uno.");
	if(PI[playerid][pi_PHONE_STATE] == PHONE_STATE_OFF) return SendNotification(playerid, "Tu teléfono está ~r~apagado~w~, para encenderlo usa /movil.");
	if(!PI[playerid][pi_DOUBT_CHANNEL_TW]) return SendNotification(playerid, "Para enviar un twit primero debes activar el canal de twitter desde ~g~/telefono");
	if(isnull(params)) return SendNotification(playerid, "Modo de uso: ~b~~h~~h~/twitter ~w~[twit]");
	if(PI[playerid][pi_MUTE_TW] > gettime()) return SendFormatNotification(playerid, "Estás silenciado en el canal de ~b~~h~~h~twitter ~w~por %s minutos.", TimeConvert(PI[playerid][pi_MUTE_TW] - gettime()));

	if(!PLAYER_TEMP[playerid][pt_ADMIN_SERVICE])
	{
		if(gettime() < PLAYER_TEMP[playerid][pt_DOUBT_CHANNEL_TIME_TW] + MIN_TIME_BETWEEN_DOUBT_TW) return SendFormatNotification(playerid, "Tienes que esperar %s minutos para volver a enviar otro ~b~~h~~h~twit~w~.", TimeConvert((MIN_TIME_BETWEEN_DOUBT_TW-(gettime()-PLAYER_TEMP[playerid][pt_DOUBT_CHANNEL_TIME_TW]))));
	}
	if(!QuitarDinero(playerid, 500, true)) return SendNotification(playerid, "No tienes dinero suficiente, necesitas ~r~500$~w~ para poder publicar un ~b~~h~~h~twit.");
 	
 	PlayerPlaySoundEx(playerid, 1085, 0.0, 0.0, 0.0);
    SendMessageToDoubtTwitter(playerid, params, TWITTER);
	return 1;
}
alias:twitter("tw");

CMD:twa(playerid, params[])
{
    if(PI[playerid][pi_STATE] == ROLEPLAY_STATE_CRACK || PI[playerid][pi_STATE] == ROLEPLAY_STATE_JAIL || PI[playerid][pi_STATE] == ROLEPLAY_STATE_ARRESTED) return SendNotification(playerid, "Ahora no puedes usar este comando.");
    if(!PI[playerid][pi_PHONE_NUMBER]) return SendNotification(playerid, "No tienes ningún teléfono, puedes ir a cualquier ~g~24/7 ~w~para comprar uno.");
    if(PI[playerid][pi_PHONE_STATE] == PHONE_STATE_OFF) return SendNotification(playerid, "Tu teléfono está ~r~apagado~w~, para encenderlo usa /movil.");
    if(!PI[playerid][pi_DOUBT_CHANNEL_TW]) return SendNotification(playerid, "Para enviar un twit primero debes activar el canal de twitter desde ~g~/telefono");
    if(isnull(params)) return SendNotification(playerid, "Modo de uso: ~b~~h~~h~/ta ~w~[twit]");
    if(PI[playerid][pi_MUTE_TW] > gettime()) return SendFormatNotification(playerid, "Estás silenciado en el canal de ~b~~h~~h~twitter ~w~por %s minutos.", TimeConvert(PI[playerid][pi_MUTE_TW] - gettime()));

    if(!PLAYER_TEMP[playerid][pt_ADMIN_SERVICE])
    {
        if(gettime() < PLAYER_TEMP[playerid][pt_DOUBT_CHANNEL_TIME_TW] + MIN_TIME_BETWEEN_DOUBT_TW) return SendFormatNotification(playerid, "Tienes que esperar %s minutos para volver a enviar otro ~b~~h~~h~twit~w~.", TimeConvert((MIN_TIME_BETWEEN_DOUBT_TW-(gettime()-PLAYER_TEMP[playerid][pt_DOUBT_CHANNEL_TIME_TW]))));
    }
    if(!QuitarDinero(playerid, 1000, true)) return SendNotification(playerid, "No tienes dinero suficiente, necesitas ~r~1.000$~w~ para poder publicar un ~b~~h~~h~twit.");
    
    PlayerPlaySoundEx(playerid, 1085, 0.0, 0.0, 0.0);
    SendMessageToDoubtTwitter(playerid, params, TWITTER_A);
    return 1;
}
alias:twa("ta");

SendMessageToDoubtTwitter(playerid, message[], type)
{
    switch(type)
    {
        case TWITTER:
        {
            new str[145];
            format(str, sizeof str, "[Twitter] @{FFFFFF}%s: {009CFF}%s", PLAYER_TEMP[playerid][pt_RP_NAME], message);

            PLAYER_TEMP[playerid][pt_DOUBT_CHANNEL_TIME_TW] = gettime();
            for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
            {
                if(IsPlayerConnected(i))
                {
                    if((PLAYER_TEMP[i][pt_GAME_STATE] == GAME_STATE_NORMAL || PLAYER_TEMP[i][pt_GAME_STATE] == GAME_STATE_DEAD) && PI[i][pi_DOUBT_CHANNEL_TW] && PI[i][pi_PHONE_STATE] == PHONE_STATE_ON)
                    {
                        SendClientMessage(i, 0x009CFFFF, str);
                    }
                }
            }
        }
        case TWITTER_A:
        {
            new str[145];
            format(str, sizeof str, "[Twitter] {"#RED_COLOR"}@Anonimo: {009CFF}%s", message);

            PLAYER_TEMP[playerid][pt_DOUBT_CHANNEL_TIME_TW] = gettime();
            for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
            {
                if(IsPlayerConnected(i))
                {
                    if((PLAYER_TEMP[i][pt_GAME_STATE] == GAME_STATE_NORMAL || PLAYER_TEMP[i][pt_GAME_STATE] == GAME_STATE_DEAD) && PI[i][pi_DOUBT_CHANNEL_TW] && PI[i][pi_PHONE_STATE] == PHONE_STATE_ON)
                    {
                        SendClientMessage(i, 0x009CFFFF, str);

                        format(str, sizeof str, "Twitter enviado por {FFFFFF}%s", PLAYER_TEMP[playerid][pt_RP_NAME]);
                        SendMessageToAdmins(0x009CFFFF, str);
                    }
                }
            }
        }
    }
    return 1;
}