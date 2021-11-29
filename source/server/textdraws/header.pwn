#if defined _H_TEXTDRAWS_
    #endinput
#endif
#define _H_TEXTDRAWS_

new
	Text:g_tdRegisterAcc[25],
	Text:g_tdPlayerCustomization[20],
    Text:g_tdNeedBars[15],
    Text:g_tdNeedProgress[2],
    Text:g_tdShops[12],
    Text:g_tdSpeedometer[6],
    Text:g_tdKeyGame[4];

new
	PlayerText:p_tdTransition[MAX_PLAYERS char],
	PlayerText:p_tdRegisterAcc[MAX_PLAYERS][5 char],
	PlayerText:p_tdPlayerCustomization[MAX_PLAYERS char],
    PlayerText:p_tdNotifications[MAX_PLAYERS][3][5 char],
    PlayerText:p_tdBeatingText[MAX_PLAYERS char],
    PlayerText:p_tdKeyGame[MAX_PLAYERS char];