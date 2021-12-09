#if defined _H_CELLPHONE_
    #endinput
#endif
#define _H_CELLPHONE_

new
    g_rgiPlayerCellphoneNumber[MAX_PLAYERS];

#define Player_PhoneNumber(%0) (g_rgiPlayerCellphoneNumber[(%0)])

forward Cellphone_Register(playerid, Func:on_register<>);
forward bool:Cellphone_SetNumber(playerid, new_number, bool:update = false);