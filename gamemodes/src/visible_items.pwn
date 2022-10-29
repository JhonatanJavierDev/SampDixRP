#include <YSI-Includes\YSI\y_hooks>

#define DEFAULT_VISIBLE_ITEMS 500

hook OnPlayerConnect(playerid) {
    Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, DEFAULT_VISIBLE_ITEMS, playerid);
}

hook OnPlayerEnterInterior(playerid, index) {
    new items = DEFAULT_VISIBLE_ITEMS;
    
    if(ENTER_EXIT[index][ee_VISIBLE_ITEMS] >= 0) items = ENTER_EXIT[index][ee_VISIBLE_ITEMS];
    Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, items, playerid);
}

hook OnPlayerExitInterior(playerid, index) {
    Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, DEFAULT_VISIBLE_ITEMS, playerid);
}