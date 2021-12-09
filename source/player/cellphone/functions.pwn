#if defined _FUNCTIONS_CELLPHONE_
    #endinput
#endif
#define _FUNCTIONS_CELLPHONE_

void:Cellphone_Register(playerid, Func:on_register<>)
{
    Indirect_Claim(on_register);

    inline const Result()
    {
        cache_get_value_name_int(0, !"NUMBER", Player_PhoneNumber(playerid));
        @.on_register();
        Indirect_Release(on_register);
    }
    MySQL_TQueryInline(g_hDatabase, using inline Result, "\
        CALL GENERATE_PHONE_NUMBER(@p); \
        UPDATE `PLAYERS` SET `PHONE_NUMBER` = @p WHERE `ID` = %d LIMIT 1;\
        SELECT @p AS `NUMBER`;\
    ", Player_AccountID(playerid));
}

bool:Cellphone_SetNumber(playerid, new_number, bool:update = false)
{
    if(!IS_IN_RANGE(new_number, 10000000, 99999999))
        return false;

    g_rgiPlayerCellphoneNumber[playerid] = new_number;
    if(update)
    {
        mysql_tquery(g_hDatabase, va_return("UPDATE `PLAYERS` SET `PHONE_NUMBER` = %d WHERE `ID` = %d LIMIT 1;", new_number, Player_AccountID(playerid)));
    }

    return true;
}