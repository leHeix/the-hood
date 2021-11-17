#if defined _H_NEEDS_
    #endinput
#endif
#define _H_NEEDS_

enum {
    NEEDS_HUNGER = 0,
    NEEDS_THIRST = 1,
};

const Float:NEEDS_THIRST_INCREASE = 1.0;
const Float:NEEDS_HUNGER_INCREASE = 1.0;

new g_rgiTimerUpdateNeeds[MAX_PLAYERS][2];

forward NEEDS_UpdateThirst(playerid);
forward NEEDS_UpdateHunger(playerid);

#define Needs_BarShown(%0) (IsTextDrawVisibleForPlayer((%0), g_tdNeedBars[0]))