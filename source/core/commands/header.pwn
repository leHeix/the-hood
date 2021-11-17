#if defined _H_CORE_COMMANDS_
    #endinput
#endif
#define _H_CORE_COMMANDS_

#define MZ_MAX_COMMANDS 100

enum eCommandStore 
{
    e_iCommandNameHash,
    e_szCommandDescription[50]
};

new g_rgeCommandStore[MZ_MAX_COMMANDS][eCommandStore];

#define command%4\32;%0(%1,%2,%3) \
    forward mz@cmd_%0();\
    public mz@cmd_%0() {\
        new id = Commands_GetFreeIndex();\
        if(id == -1) { print("[Commands] Failed to register command "#%0" (store out of space)"); return 0;}\
        g_rgeCommandStore[id][e_iCommandNameHash] = _I<%0>;\
        strcat(g_rgeCommandStore[id][e_szCommandDescription], %3);\
        return 1;\
    }\
    CMD:%0(%1,%2)