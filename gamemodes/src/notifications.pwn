#include <YSI-Includes\YSI\y_hooks>

#include <td-string-width>

#define TD_NOTIFICATION_LETTER_X 0.195999
#define TD_NOTIFICATION_LETTER_Y 1.002667

enum InformationTDN
{
    Use,
    Line,
    Text[800],
    PlayerText:TextDraw,
    Float:MinPosY,
    Float:MaxPosY,
    Hide,
    Timer
}
new TextDrawsNotification[MAX_PLAYERS][4][InformationTDN],
    counter_@[MAX_PLAYERS];

forward TimerHideNotification(playerid);
public TimerHideNotification(playerid)
{
    for(new cycle; cycle < 4; cycle++)
    {
        if(TextDrawsNotification[playerid][cycle][Hide] == -1)
        {
            TextDrawsNotification[playerid][cycle][Use] = 0;
            if(TextDrawsNotification[playerid][cycle][TextDraw] != PlayerText:-1)
            {
                PlayerTextDrawDestroy(playerid, TextDrawsNotification[playerid][cycle][TextDraw]);
                TextDrawsNotification[playerid][cycle][Line] = 0;
                TextDrawsNotification[playerid][cycle][Text][0] = EOS;
                TextDrawsNotification[playerid][cycle][MinPosY] = 0;
                TextDrawsNotification[playerid][cycle][MaxPosY] = 0;
                TextDrawsNotification[playerid][cycle][TextDraw] = PlayerText:-1;
            }
            TextDrawsNotification[playerid][cycle][Hide] = -1;
            UpdateNotification(playerid);

            return 1;
        }
    }
    return 0;
}

forward SendNotification(playerid, const reason[]); 
public SendNotification(playerid, const reason[])
{
    for(new cycle; cycle < 4; cycle++)
    {
        if(!TextDrawsNotification[playerid][cycle][Use])
        {
            TextDrawsNotification[playerid][cycle][Text][0] = EOS;

            strcat(TextDrawsNotification[playerid][cycle][Text], reason, 800);
            FixTextDrawString(TextDrawsNotification[playerid][cycle][Text]);

            TextDrawsNotification[playerid][cycle][Use] = 1;
 
            LinesNotification(playerid, cycle);

            MinPosYNotification(playerid, cycle);
            MaxPosYNotification(playerid, cycle);

            TextDrawsNotification[playerid][cycle][Hide] = -1;

            CreateTDN(playerid, cycle);

            SetTimerEx("TimerHideNotification", 5000, false, "i", playerid);

            return 1;
        }
    }
    return -1;
}

forward SendNotification_Manual(playerid, const reason[]); 
public SendNotification_Manual(playerid, const reason[])
{
    for(new cycle; cycle < 4; cycle++)
    {
        if(!TextDrawsNotification[playerid][cycle][Use])
        {
            TextDrawsNotification[playerid][cycle][Text][0] = EOS;

            strcat(TextDrawsNotification[playerid][cycle][Text], reason, 800);
            FixTextDrawString(TextDrawsNotification[playerid][cycle][Text]);
 
            TextDrawsNotification[playerid][cycle][Use] = 1;
 
            LinesNotification(playerid, cycle);

            MinPosYNotification(playerid, cycle);
            MaxPosYNotification(playerid, cycle);

            CreateTDN(playerid, cycle);

            for(new i; i < 4; i++)
            {
                if(used(playerid, counter_@[playerid]))
                {
                    if(counter_@[playerid] == 4 - 1) counter_@[playerid] = 0;
                    else counter_@[playerid]++;
                }
                else break;
            }

            new TDN = counter_@[playerid];

            TextDrawsNotification[playerid][cycle][Hide] = TDN;

            if(counter_@[playerid] == 4 - 1) counter_@[playerid] = 0;
            else counter_@[playerid]++;

            return TDN;
        }
    }
    return -1;
}

stock used(playerid, id)
{
    for(new cycle; cycle < 4; cycle++)
    {
        if(TextDrawsNotification[playerid][cycle][Hide] == id) return 1;
    }
    return 0;
}

forward HideNotification(playerid, TDN);
public HideNotification(playerid, TDN)
{
    for(new cycle; cycle < 4; cycle++)
    {
        if(TextDrawsNotification[playerid][cycle][Hide] == TDN)
        {
            TextDrawsNotification[playerid][cycle][Use] = 0;
            if(TextDrawsNotification[playerid][cycle][TextDraw] != PlayerText:-1)
            {
                PlayerTextDrawDestroy(playerid, TextDrawsNotification[playerid][cycle][TextDraw]);
                TextDrawsNotification[playerid][cycle][Line] = 0;
                TextDrawsNotification[playerid][cycle][Text][0] = EOS;
                TextDrawsNotification[playerid][cycle][MinPosY] = 0;
                TextDrawsNotification[playerid][cycle][MaxPosY] = 0;
                TextDrawsNotification[playerid][cycle][TextDraw] = PlayerText:-1;
                TextDrawsNotification[playerid][cycle][Timer] = -1;
            }
            TextDrawsNotification[playerid][cycle][Hide] = -1;
            UpdateNotification(playerid);
            return 1;
        }
    }
    return 0;
}

stock UpdateNotification(playerid)
{
    for(new cycle = 0; cycle < 4; cycle ++)
    {
        if(!TextDrawsNotification[playerid][cycle][Use])
        {
            if(cycle != 4 - 1)
            {
                if(TextDrawsNotification[playerid][cycle + 1][Use])
                {
                    TextDrawsNotification[playerid][cycle][Use] = TextDrawsNotification[playerid][cycle + 1][Use];
                    TextDrawsNotification[playerid][cycle][Line] = TextDrawsNotification[playerid][cycle + 1][Line];
                    strcat(TextDrawsNotification[playerid][cycle][Text], TextDrawsNotification[playerid][cycle + 1][Text], 800);
                    TextDrawsNotification[playerid][cycle][TextDraw] = TextDrawsNotification[playerid][cycle + 1][TextDraw];
                    TextDrawsNotification[playerid][cycle][Hide] = TextDrawsNotification[playerid][cycle + 1][Hide];

                    TextDrawsNotification[playerid][cycle + 1][Use] = 0;
                    TextDrawsNotification[playerid][cycle + 1][Line] = 0;
                    TextDrawsNotification[playerid][cycle + 1][Text][0] = EOS;
                    TextDrawsNotification[playerid][cycle + 1][TextDraw] = PlayerText:-1;
                    TextDrawsNotification[playerid][cycle + 1][MinPosY] = 0;
                    TextDrawsNotification[playerid][cycle + 1][MaxPosY] = 0;
                    TextDrawsNotification[playerid][cycle + 1][Hide] = -1;

                    MinPosYNotification(playerid, cycle);
                    MaxPosYNotification(playerid, cycle);
                }
            }
        }
        else if(TextDrawsNotification[playerid][cycle][Use])
        {
            if(cycle != 0)
            {
                if(!TextDrawsNotification[playerid][cycle - 1][Use])
                {
                    TextDrawsNotification[playerid][cycle - 1][Use] = TextDrawsNotification[playerid][cycle][Use];
                    TextDrawsNotification[playerid][cycle - 1][Line] = TextDrawsNotification[playerid][cycle][Line];
                    strcat(TextDrawsNotification[playerid][cycle - 1][Text], TextDrawsNotification[playerid][cycle][Text], 800);
                    TextDrawsNotification[playerid][cycle - 1][TextDraw] = TextDrawsNotification[playerid][cycle][TextDraw];
                    TextDrawsNotification[playerid][cycle - 1][Hide] = TextDrawsNotification[playerid][cycle][Hide];

                    TextDrawsNotification[playerid][cycle][Use] = 0;
                    TextDrawsNotification[playerid][cycle][Line] = 0;
                    TextDrawsNotification[playerid][cycle][Text][0] = EOS;
                    TextDrawsNotification[playerid][cycle][TextDraw] = PlayerText:-1;
                    TextDrawsNotification[playerid][cycle][MinPosY] = 0;
                    TextDrawsNotification[playerid][cycle][MaxPosY] = 0;
                    TextDrawsNotification[playerid][cycle][Hide] = -1;

                    MinPosYNotification(playerid, cycle - 1);
                    MaxPosYNotification(playerid, cycle - 1);
                }
            }
        }
        CreateTDN(playerid, cycle);
    }
    return 1;
}

stock MinPosYNotification(playerid, TDN)
{
    if(TDN == 0)
    {
        TextDrawsNotification[playerid][TDN][MinPosY] = PI[playerid][pi_WANTED_LEVEL] == 0 ? 130.000000 : 153.0;
    }
    else
    {
        TextDrawsNotification[playerid][TDN][MinPosY] = TextDrawsNotification[playerid][TDN - 1][MaxPosY] + 10;
    }
    return 1;
}

stock MaxPosYNotification(playerid, TDN)
{
    TextDrawsNotification[playerid][TDN][MaxPosY] = TextDrawsNotification[playerid][TDN][MinPosY] + (TD_NOTIFICATION_LETTER_Y * 2) + 2 + (TD_NOTIFICATION_LETTER_Y * 5.75 * TextDrawsNotification[playerid][TDN][Line]) + ((TextDrawsNotification[playerid][TDN][Line] - 1) * ((TD_NOTIFICATION_LETTER_Y * 2) + 2 + TD_NOTIFICATION_LETTER_Y)) + TD_NOTIFICATION_LETTER_Y + 4;
    return 1;
}

stock LinesNotification(playerid, TDN)
{
    new lines = 1, Float:width, lastspace = -1, supr, len = strlen(TextDrawsNotification[playerid][TDN][Text]);
 
    for(new i = 0; i < len; i ++)
    {
        if(TextDrawsNotification[playerid][TDN][Text][i] == '~')
        {
            if(supr == 0)
            {
                supr = 1;
                if(TextDrawsNotification[playerid][TDN][Text][i+2] != '~') return 1;
            }
            else if(supr == 1) supr = 0;
        }
        else
        {
            if(supr == 1)
            {
                if(TextDrawsNotification[playerid][TDN][Text][i] == 'n')
                {
                    lines ++;
                    lastspace = -1;
                    width = 0;
                }
            }
            else
            {
                if(TextDrawsNotification[playerid][TDN][Text][i] == ' ') lastspace = i;
 
                width += TD_NOTIFICATION_LETTER_X * GetTextDrawCharacterWidth(TextDrawsNotification[playerid][TDN][Text][i], 1, bool:1);

                if(width > 112.100000 - 3)
                {
                    if(lastspace != i && lastspace != -1)
                    {
                        lines ++;
                        i = lastspace;
                        lastspace = -1;
                        width = 0;
                    }
                    else
                    {
                        lines ++;
                        lastspace = -1;
                        width = 0;
                    }
                }
            }
        }
    }
    
    TextDrawsNotification[playerid][TDN][Line] = lines;
 
    return 1;
}

stock CreateTDN(playerid, TDN)
{
    if(TextDrawsNotification[playerid][TDN][Use] == 1)
    {
        if(TextDrawsNotification[playerid][TDN][TextDraw] != PlayerText:-1)
        {
            PlayerTextDrawDestroy(playerid, TextDrawsNotification[playerid][TDN][TextDraw]);
        }
    
        TextDrawsNotification[playerid][TDN][TextDraw] = CreatePlayerTextDraw(playerid, 499.000000, TextDrawsNotification[playerid][TDN][MinPosY], TextDrawsNotification[playerid][TDN][Text]);
        PlayerTextDrawFont(playerid, TextDrawsNotification[playerid][TDN][TextDraw], 1);
        PlayerTextDrawLetterSize(playerid, TextDrawsNotification[playerid][TDN][TextDraw], TD_NOTIFICATION_LETTER_X, TD_NOTIFICATION_LETTER_Y);
        PlayerTextDrawTextSize(playerid, TextDrawsNotification[playerid][TDN][TextDraw], floatadd(499.000000, 107.0), 1.000000);
        PlayerTextDrawSetOutline(playerid, TextDrawsNotification[playerid][TDN][TextDraw], 1);
        PlayerTextDrawSetShadow(playerid, TextDrawsNotification[playerid][TDN][TextDraw], 0);
        PlayerTextDrawAlignment(playerid, TextDrawsNotification[playerid][TDN][TextDraw], 1);
        PlayerTextDrawColor(playerid, TextDrawsNotification[playerid][TDN][TextDraw], -1);
        PlayerTextDrawBackgroundColor(playerid, TextDrawsNotification[playerid][TDN][TextDraw], 255);
        PlayerTextDrawBoxColor(playerid, TextDrawsNotification[playerid][TDN][TextDraw], 80);
        PlayerTextDrawUseBox(playerid, TextDrawsNotification[playerid][TDN][TextDraw], 1);
        PlayerTextDrawSetProportional(playerid, TextDrawsNotification[playerid][TDN][TextDraw], 1);
        PlayerTextDrawSetSelectable(playerid, TextDrawsNotification[playerid][TDN][TextDraw], 0);
        PlayerTextDrawShow(playerid, TextDrawsNotification[playerid][TDN][TextDraw]);
    }
    return 1;
}

hook OnGameModeInit()
{
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        for(new TDN = 0; TDN < 4; TDN++)
        {
            TextDrawsNotification[playerid][TDN][TextDraw] = PlayerText:-1;
            TextDrawsNotification[playerid][TDN][Hide] = -1;
            TextDrawsNotification[playerid][TDN][Timer] = -1;
        }
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    HideNotifications(playerid);
    return 1;
}

HideNotifications(playerid) 
{
    for(new cycle; cycle < 4; cycle++)
    {
        if(TextDrawsNotification[playerid][cycle][TextDraw] != PlayerText:-1) 
        {
            PlayerTextDrawDestroy(playerid, TextDrawsNotification[playerid][cycle][TextDraw]);
        }
        if(TextDrawsNotification[playerid][cycle][Timer] != -1) 
        {
            KillTimer(TextDrawsNotification[playerid][cycle][Timer]);
        }
        TextDrawsNotification[playerid][cycle][Use] = 0;
        TextDrawsNotification[playerid][cycle][Line] = 0;
        TextDrawsNotification[playerid][cycle][Text][0] = EOS;
        TextDrawsNotification[playerid][cycle][MinPosY] = 0;
        TextDrawsNotification[playerid][cycle][MaxPosY] = 0;
        TextDrawsNotification[playerid][cycle][Hide] = -1;
        TextDrawsNotification[playerid][cycle][TextDraw] = PlayerText:-1;
        TextDrawsNotification[playerid][cycle][Timer] = -1;
    }
}

SendFormatNotification(playerid, const text[], {Float, _}:...)
{
	static
	    args,
	    str[192];

	if ((args = numargs()) <= 2)
	{
	    SendNotification(playerid, text);
	}
	else
	{
		while (--args >= 2)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 192
		#emit PUSH.C str
		#emit LOAD.S.pri 8
		#emit CONST.alt 4
		#emit ADD
		#emit PUSH.pri
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendNotification(playerid, str);

		#emit RETN
	}
	return 1;
}
