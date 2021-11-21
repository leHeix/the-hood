#if defined _DATABASE_CALLBACKS_
    #endinput
#endif
#define _DATABASE_CALLBACKS_

#include <YSI_Coding\y_hooks>

hook OnGameModeInit()
{
    print("[MySQL] Connecting to database...");

    g_hDatabase = mysql_connect_file("hood_sql.ini");
    if(mysql_errno(g_hDatabase) != 0)
    {
        mysql_error(YSI_UNSAFE_HUGE_STRING, .handle = g_hDatabase);
        print("[!] Failed to open database:");
        printf("[!]   %s", YSI_UNSAFE_HUGE_STRING);

        SendRconCommand(!"exit");
        return ~1;
    }

    print("~ Database connected successfully. Initializing tables...");
    mysql_query_file(g_hDatabase, "schema.sql", false);
    if(mysql_errno(g_hDatabase) != 0)
    {
        mysql_error(YSI_UNSAFE_HUGE_STRING, .handle = g_hDatabase);
        print("[!] Database initialization error caught:");
        printf("[!]   %s", YSI_UNSAFE_HUGE_STRING);
        mysql_close(g_hDatabase);
        SendRconCommand(!"exit");
        return ~1;
    }
    
    print("~ Database initialization completed.");

    return 1;
}

hook OnGameModeExit()
{
    print("[MySQL] Closing database connection...");
    mysql_close(g_hDatabase);
    return 1;
}

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
    printf("[MySQL] Caught error while exeuting query on handle %d.", _:handle);
    printf("[!] Error", error);
    printf("[!] Callback: \"%s\"", callback);
    print ("[!] Query:");
    printf("[!]    %s", query);

    return 1;
}