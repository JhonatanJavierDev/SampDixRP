//Damage Informer by Naig

#include <a_samp>

new hit[MAX_PLAYERS];
new hit1[MAX_PLAYERS];
new Float:damage2[MAX_PLAYERS];
new Float:damage1[MAX_PLAYERS];
new timerdamage[MAX_PLAYERS];
new timerdamage1[MAX_PLAYERS];
new PlayerText:Indicator[MAX_PLAYERS];
new PlayerText:IndicatorBox[MAX_PLAYERS];
new PlayerText:Indicator1[MAX_PLAYERS];
new PlayerText:IndicatorBox1[MAX_PLAYERS];

public OnFilterScriptInit()
{
    print("\n Damage informer cargando..");
    return 1;
}
public OnFilterScriptExit()
{
    print("\n Damage informer cerrando..");
    return 1;
}
public OnPlayerConnect(playerid)
{
CreatePlayerTD(playerid);
return 1;
}
public OnPlayerDisconnect(playerid)
{
DeleteTDS(playerid);
return 1;
}
public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid, bodypart)
{
    if(timerdamage1[playerid] != 0) KillTimer(timerdamage1[playerid]);

    hit1[playerid]++;
    damage1[playerid] += amount;

    timerdamage1[playerid] = SetTimerEx("DamageReset1", 3000, 0, "i", playerid);

    PlayerTextDrawShow(playerid, IndicatorBox1[playerid]);
    PlayerTextDrawShow(playerid, Indicator1[playerid]);

    new str[50];
    format(str,sizeof(str)," DAMAGE: %d hit(s) %.0f dmg", hit1[playerid], damage1[playerid]);
    PlayerTextDrawSetString(playerid, Indicator1[playerid], str);
    return 1;
 }
public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
        if(timerdamage[playerid] != 0) KillTimer(timerdamage[playerid]);

        hit[playerid]++;
        damage2[playerid] += amount;

        timerdamage[playerid] = SetTimerEx("DamageReset", 3000, 0, "i", playerid);

        PlayerTextDrawShow(playerid, IndicatorBox[playerid]);
        PlayerTextDrawShow(playerid, Indicator[playerid]);

        new str[50];
        format(str,sizeof(str),"HIT: %d hit(s) %.0f dmg", hit[playerid], damage2[playerid]);
        PlayerTextDrawSetString(playerid, Indicator[playerid], str);
        return 1;
}
forward DamageReset(playerid);
public DamageReset(playerid)
{
    hit[playerid] = 0;
    damage2[playerid] = 0;
    PlayerTextDrawHide(playerid, IndicatorBox[playerid]);
    PlayerTextDrawHide(playerid, Indicator[playerid]);
    KillTimer(timerdamage[playerid]);
    return 1;
}
forward DamageReset1(playerid);
public DamageReset1(playerid)
{
    hit1[playerid] = 0;
    damage1[playerid] = 0;
    PlayerTextDrawHide(playerid, IndicatorBox1[playerid]);
    PlayerTextDrawHide(playerid, Indicator1[playerid]);
    KillTimer(timerdamage1[playerid]);
    return 1;
}
stock CreatePlayerTD(playerid)
{
        IndicatorBox[playerid] = CreatePlayerTextDraw(playerid, 428.444458, 398.753326, "usebox");
        PlayerTextDrawLetterSize(playerid, IndicatorBox[playerid], 0.000000, -2.584319);
        PlayerTextDrawTextSize(playerid, IndicatorBox[playerid], 622.444458, 0.000000);
        PlayerTextDrawAlignment(playerid, IndicatorBox[playerid], 1);
        PlayerTextDrawColor(playerid, IndicatorBox[playerid], 0);
        PlayerTextDrawUseBox(playerid, IndicatorBox[playerid], true);
        PlayerTextDrawBoxColor(playerid, IndicatorBox[playerid], 102);
        PlayerTextDrawSetShadow(playerid, IndicatorBox[playerid], 0);
        PlayerTextDrawFont(playerid, IndicatorBox[playerid], 0);

        Indicator[playerid] = CreatePlayerTextDraw(playerid, 540.000183, 380.826660, "Hit: 4 - 150 dmg");
        PlayerTextDrawLetterSize(playerid, Indicator[playerid], 0.227333, 1.346132);
        PlayerTextDrawAlignment(playerid, Indicator[playerid], 1);
        PlayerTextDrawColor(playerid, Indicator[playerid], -1);
        PlayerTextDrawSetShadow(playerid, Indicator[playerid], 0);
        PlayerTextDrawSetOutline(playerid, Indicator[playerid], 1);
        PlayerTextDrawBackgroundColor(playerid, Indicator[playerid], 51);
        PlayerTextDrawFont(playerid, Indicator[playerid], 1);
        PlayerTextDrawSetProportional(playerid, Indicator[playerid], 1);

        IndicatorBox1[playerid] = CreatePlayerTextDraw(playerid, 428.444458, 382.753326, "usebox");
        PlayerTextDrawLetterSize(playerid, IndicatorBox1[playerid], 0.000000, -2.584319);
        PlayerTextDrawTextSize(playerid, IndicatorBox1[playerid], 622.444458, 0.000000);
        PlayerTextDrawAlignment(playerid, IndicatorBox1[playerid], 1);
        PlayerTextDrawColor(playerid, IndicatorBox1[playerid], 0);
        PlayerTextDrawUseBox(playerid, IndicatorBox1[playerid], true);
        PlayerTextDrawBoxColor(playerid, IndicatorBox1[playerid], 102);
        PlayerTextDrawSetShadow(playerid, IndicatorBox1[playerid], 0);
        PlayerTextDrawFont(playerid, IndicatorBox1[playerid], 0);

        Indicator1[playerid] = CreatePlayerTextDraw(playerid, 430.000183, 363.826660, "Hit: 4 - 150 dmg");
        PlayerTextDrawLetterSize(playerid, Indicator1[playerid], 0.227333, 1.346132);
        PlayerTextDrawAlignment(playerid, Indicator1[playerid], 1);
        PlayerTextDrawColor(playerid, Indicator1[playerid], -1);
        PlayerTextDrawSetShadow(playerid, Indicator1[playerid], 0);
        PlayerTextDrawSetOutline(playerid, Indicator1[playerid], 1);
        PlayerTextDrawBackgroundColor(playerid, Indicator1[playerid], 51);
        PlayerTextDrawFont(playerid, Indicator1[playerid], 1);
        PlayerTextDrawSetProportional(playerid, Indicator1[playerid], 1);

        return 1;
}
stock DeleteTDS(playerid)
{
    PlayerTextDrawHide(playerid,Indicator1[playerid]);
    PlayerTextDrawDestroy(playerid,IndicatorBox1[playerid]);
    PlayerTextDrawHide(playerid,Indicator[playerid]);
    PlayerTextDrawDestroy(playerid,IndicatorBox[playerid]);
    return 1;
}
