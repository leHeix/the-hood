#if defined _FUNCTIONS_CELLPHONE_
    #endinput
#endif
#define _FUNCTIONS_CELLPHONE_

void:Cellphone_Register(playerid, Func:on_register<>)
{
    Indirect_Claim(on_register);

    inline const Result()
    {
        cache_get_value_name_int(0, "PHONE_NUMBER", Player_PhoneNumber(playerid));
        mysql_tquery(g_hDatabase, va_return("UPDATE `PLAYERS` SET `PHONE_NUMBER` = %d WHERE `ID` = %d LIMIT 1;", Player_PhoneNumber(playerid), Player_AccountID(playerid)));
        @.on_register();
        Indirect_Release(on_register);
    }
    MySQL_TQueryInline(g_hDatabase, using inline Result, "\
        SELECT RIGHT(UUID_SHORT() + ROUND((RAND() * (99999999-10000000))+10000000), 8) AS `PHONE_NUMBER`;\
    ");
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