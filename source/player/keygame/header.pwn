#if defined _H_KEYGAME_
    #endinput
#endif
#define _H_KEYGAME_

enum eKeyGameTimers
{
    KG_TIMER_DECREASE_BAR,
    KG_TIMER_PROCESS_KEY
};

const Float:KEYGAME_BAR_MAX_Y = 115.0;
const Float:KEYGAME_BAR_MIN_Y = 16.0;

new const g_rgiRandomKeys[] = {
    KEY_YES, KEY_NO, KEY_CTRL_BACK, KEY_CROUCH,
    KEY_UP
};

new const g_rgszKeyNames[][] = {
    "~k~~CONVERSATION_YES~", 
    "~k~~CONVERSATION_NO~", 
    "~k~~GROUP_CONTROL_BWD~",
    "~k~~PED_DUCK~",
    "~k~~GO_FORWARD~"
};

enum eKeyGameData
{
    Func:e_pKgCallback<i>,
    e_iKgTimers[eKeyGameTimers],
    e_iKgLastKeyAppearance,
    e_iKgCurrentKey,
    Float:e_fKgPercentagePerKey,
    Float:e_fKgDecreaseSec,
    Float:e_fKgCurrentSize,

    bool:e_bKgKeyRed,
    e_iKgKeyRedTick
};

new g_rgeKeyGameData[MAX_PLAYERS + 1][eKeyGameData];

// 9.9% per key = 10 keys to finish
// 1.0% per key = 99 keys to finish

forward Player_StartKeyGame(playerid, Func:cb<i>, Float:key_percentage_up = 9.9, Float:decrease_sec = 2.5);
forward Player_StopKeyGame(playerid, bool:free_cb = true);

forward KEYGAME_DecreaseBar(playerid);
forward KEYGAME_ProcessKey(playerid);