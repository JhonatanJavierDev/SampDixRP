#include <YSI-Includes\YSI\y_hooks>

new
	Text:Wasted[7]
;

hook OnGameModeInit()
{
    WastedScreenLoad();
	return true;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	for(new i = 0; i < 7; i ++) TextDrawShowForPlayer(playerid, Wasted[i]);
	PlayAudioStreamForPlayer(playerid, "https://cdn.discordapp.com/attachments/720886743724982323/911050713969352785/wasted.mp3");
	return true;
}

hook OnPlayerSpawn(playerid)
{
	for(new i = 0; i < 7; i ++)  TextDrawHideForPlayer(playerid, Wasted[i]);
	return true;
}

WastedScreenLoad()
{
	Wasted[0] = TextDrawCreate(-31.000000, 0.000000, "_");
	TextDrawBackgroundColor(Wasted[0], 255);
	TextDrawFont(Wasted[0], 1);
	TextDrawLetterSize(Wasted[0], 0.500000, 55.000000);
	TextDrawColor(Wasted[0], -1);
	TextDrawSetOutline(Wasted[0], 0);
	TextDrawSetProportional(Wasted[0], 1);
	TextDrawSetShadow(Wasted[0], 1);
	TextDrawUseBox(Wasted[0], 1);
	TextDrawBoxColor(Wasted[0], 90);
	TextDrawTextSize(Wasted[0], 664.000000, 0.000000);
	TextDrawSetSelectable(Wasted[0], 0);

	Wasted[1] = TextDrawCreate(106.000000, 182.000000, "_");
	TextDrawBackgroundColor(Wasted[1], 255);
	TextDrawFont(Wasted[1], 1);
	TextDrawLetterSize(Wasted[1], 0.500000, 8.499998);
	TextDrawColor(Wasted[1], -1);
	TextDrawSetOutline(Wasted[1], 0);
	TextDrawSetProportional(Wasted[1], 1);
	TextDrawSetShadow(Wasted[1], 1);
	TextDrawUseBox(Wasted[1], 1);
	TextDrawBoxColor(Wasted[1], 50);
	TextDrawTextSize(Wasted[1], 553.000000, 0.000000);
	TextDrawSetSelectable(Wasted[1], 0);

	Wasted[2] = TextDrawCreate(1.000000, 182.000000, "_");
	TextDrawBackgroundColor(Wasted[2], 255);
	TextDrawFont(Wasted[2], 1);
	TextDrawLetterSize(Wasted[2], 0.500000, 8.499998);
	TextDrawColor(Wasted[2], -1);
	TextDrawSetOutline(Wasted[2], 0);
	TextDrawSetProportional(Wasted[2], 1);
	TextDrawSetShadow(Wasted[2], 1);
	TextDrawUseBox(Wasted[2], 1);
	TextDrawBoxColor(Wasted[2], 40);
	TextDrawTextSize(Wasted[2], 102.000000, 0.000000);
	TextDrawSetSelectable(Wasted[2], 0);

	Wasted[3] = TextDrawCreate(651.000000, 182.000000, "_");
	TextDrawBackgroundColor(Wasted[3], 255);
	TextDrawFont(Wasted[3], 1);
	TextDrawLetterSize(Wasted[3], 0.500000, 8.499998);
	TextDrawColor(Wasted[3], -1);
	TextDrawSetOutline(Wasted[3], 0);
	TextDrawSetProportional(Wasted[3], 1);
	TextDrawSetShadow(Wasted[3], 1);
	TextDrawUseBox(Wasted[3], 1);
	TextDrawBoxColor(Wasted[3], 40);
	TextDrawTextSize(Wasted[3], 553.000000, 0.000000);
	TextDrawSetSelectable(Wasted[3], 0);

	Wasted[4] = TextDrawCreate(255.000000, 202.000000, "wasted");
	TextDrawBackgroundColor(Wasted[4], 0);
	TextDrawFont(Wasted[4], 3);
	TextDrawLetterSize(Wasted[4], 1.040000, 3.299999);
	TextDrawColor(Wasted[4], -16776961);
	TextDrawSetOutline(Wasted[4], 1);
	TextDrawSetProportional(Wasted[4], 1);
	TextDrawSetSelectable(Wasted[4], 0);

	Wasted[5] = TextDrawCreate(651.000000, 422.000000, "_");
	TextDrawBackgroundColor(Wasted[5], 255);
	TextDrawFont(Wasted[5], 1);
	TextDrawLetterSize(Wasted[5], 0.500000, 8.499998);
	TextDrawColor(Wasted[5], -1);
	TextDrawSetOutline(Wasted[5], 0);
	TextDrawSetProportional(Wasted[5], 1);
	TextDrawSetShadow(Wasted[5], 1);
	TextDrawUseBox(Wasted[5], 1);
	TextDrawBoxColor(Wasted[5], 40);
	TextDrawTextSize(Wasted[5], -35.000000, 0.000000);
	TextDrawSetSelectable(Wasted[5], 0);

	Wasted[6] = TextDrawCreate(651.000000, -59.000000, "_");
	TextDrawBackgroundColor(Wasted[6], 255);
	TextDrawFont(Wasted[6], 1);
	TextDrawLetterSize(Wasted[6], 0.500000, 8.499998);
	TextDrawColor(Wasted[6], -1);
	TextDrawSetOutline(Wasted[6], 0);
	TextDrawSetProportional(Wasted[6], 1);
	TextDrawSetShadow(Wasted[6], 1);
	TextDrawUseBox(Wasted[6], 1);
	TextDrawBoxColor(Wasted[6], 40);
	TextDrawTextSize(Wasted[6], -35.000000, 0.000000);
	TextDrawSetSelectable(Wasted[6], 0);
	return true;
}
