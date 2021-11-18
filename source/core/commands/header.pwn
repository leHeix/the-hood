#if defined _H_CORE_COMMANDS_
    #endinput
#endif
#define _H_CORE_COMMANDS_

#define HOOD_MAX_COMMANDS 100
#define CMD_ADMIN<%0> ((%0) << 24)

enum _:eCommandFlags(<<=1)
{
    CMD_HIDDEN = 1,
    CMD_NO_COOLDOWN,

    CMD_INVALID_FLAG
};

#assert CMD_INVALID_FLAG < 0b100000000000000000000000

enum eCommandStore 
{
    e_iCommandNameHash,
    e_szCommandDescription[50]
};

new g_rgeCommandStore[HOOD_MAX_COMMANDS][eCommandStore];
new g_rgiPlayerCommandCooldown[MAX_PLAYERS];

#define command%4\32;%0(%1,%2,%3) \
    forward mz@cmd_%0();\
    public mz@cmd_%0() {\
        new id = Commands_GetFreeIndex();\
        g_rgeCommandStore[id][e_iCommandNameHash] = _I<%0>;\
        strcat(g_rgeCommandStore[id][e_szCommandDescription], %3);\
        return 1;\
    }\
    CMD:%0(%1,%2)