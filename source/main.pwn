/*


.......................................................................
.   o   \ o /  _ o        __|    \ /     |__         o _  \ o /   o   .
.  /|\    |     /\   __\o   \o    |    o/     o/__   /\     |    /|\  .
.  / \   / \   | \  /) |    ( \  /o\  / )    |   (\  / |   / \   / \  .
.       .......................................................       .
. \ o / .                                                     . \ o / .
.   |   .                                                     .   |   .
.  / \  .     **********THE BEST RAKSAMP EVER************     .  / \  .
.       .                                                     .       .
.  _ o  .     		   __    _____ _____ _____                .  _ o  .
.   /\  .     		  |  |  |     |  _  |     |               .   /\  .
.  | \  .     		  |  |__| | | |     |  |  |               .  | \  .
.       .     		  |_____|_|_|_|__|__|_____|               .       .
.       .      _____ __ __ _____ _____ _____ _____ _____      .       .
.  __\o .     |   __|  |  |_   _| __  |   __|     |   __|     .  __\o .
. /) |  .     |   __|-   -| | | |    -|   __| | | |   __|     . /) |  .
.       .     |_____|__|__| |_| |__|__|_____|_|_|_|_____|     .       .
. __|   .                                                     . __|   .
.   \o  .     >>>>>>>>>>>>>>>-- CREDITS --<<<<<<<<<<<<<<<     .    \o .
.   ( \ .                                                     .   ( \ .
.       .      .P3TI.     .TYT.      .FYP.        .OPCODE.    .       .
.  \ /  .               .HANDZ.       .BRAINZ.                .  \ /  .
.   |   .                                                     .   |   .
.  /o\  .     .-.            .-.                              .  /o\  .
.       .   .-| |-.        .-| |-.          _---~~(~~-_.      .       .
.   |__ .   | | | |  THX   | | | |        _{  KK    )   )     .   |__ .
. o/    . .-| | | |        | | | |-.    ,   ) -~~- ( ,-' )_   . o/    .
./ )    . | | | | |        | | | | |   (  `-,_..`., )-- '_,)  ./ )    .
.       . | | | | |-.    .-| | |*| |  (_-  _  ~_-~~~~`,  ,' ) .       .
.       . | '     | |    | |     ` |    `~ -^(    __;-,((())) .       .
. o/__  . |       | |    | |       |          ~~~~ {_ -_(())  . o/__  .
.  | (\ . |         |    |         |     THX        `\  }     . |  (\ .
.       . \         /    \         /                 `\  }    .       .
.  o _  .  |       |     |       |                            .  o _  .
.  /\   .  |       |     |       |                            .  /\   .
.  / |  .      +----------------------------------+           .  / |  .
.       .      |     MANY THANKS TO OUR HANDS     |           .       .
. \ o / .      | AND BRAINS TO MAKE THIS POSSIBLE |           . \ o / .
.   |   .      +----------------------------------+           .   |   .
.  / \  .                                                     .  / \  .
.       .......................................................       .
.   o   \ o /  _ o        __|    \ /     |__         o _  \ o /   o   .
.  /|\    |     /\   __\o   \o    |    o/     o/__   /\     |    /|\  .
.  / \   / \   | \  /) |    ( \  /o\  / )    |   (\  / |   / \   / \  .
.......................................................................

*/

#pragma option -;+
#pragma option -(+
#pragma semicolon 1
#pragma warning disable 239 // fuck off

#define PP_SYNTAX_@
#define PP_SYNTAX_STRING_OP
#define PP_SYNTAX_FOR_LIST
#define YSI_NO_OBNOXIOUS_HEADER
#define YSI_NO_ANDROID_CHECK
#define YSI_NO_VERSION_CHECK
#define YSI_NO_HEAP_MALLOC
#define YSI_NO_MODE_CACHE
#define YSI_NO_OPTIMISATION_MESSAGE
#define FOREACH_NO_LOCALS
#define FOREACH_NO_VEHICLES
#define FOREACH_NO_ACTORS
#define FOREACH_NO_BOTS
#define CGEN_MEMORY 22000

#define DEBUG_MODE 1

#if defined DEBUG_MODE
    #pragma option -d3
#else
    #pragma option -d0 -O1
#endif

// Daniel-Cortez's Anti-DeAMX
////////////////////////////////
@__groyper_season__@();
@__groyper_season__@()
{
    #emit    stack    0x7FFFFFFF
    #emit    inc.s    cellmax

    static const ___[][] = {"fuck off", "BN"};

    #emit    retn
    #emit    load.s.pri    ___
    #emit    proc
    #emit    proc
    #emit    fill    cellmax
    #emit    proc
    #emit    stack    1
    #emit    stor.alt    ___
    #emit    strb.i    2
    #emit    switch    0
    #emit    retn
L1:
    #emit    jump    L1
    #emit    zero    cellmin
}

#include <a_samp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 150

#include <jit>
#include <YSF>
#include <PawnPlus>
#include <streamer>
#include <sscanf2>
#include <Pawn.CMD>
#include <a_mysql>
#include <bcrypt>
#include <md-sort/md-sort>
#include <td-string-width>
#include <colandreas>

#include <YSI_Coding\y_hooks>
#include <YSI_Coding\y_inline>
#include <YSI_Coding\y_stringhash>
#include <YSI_Coding\y_va>
#include <YSI_Core\y_cell>
#include <YSI_Core\y_compilerdata>
//#include <YSI_Core\y_profiling>
#include <YSI_Core\y_utils>
#include <YSI_Data\y_bit>
#include <YSI_Data\y_iterate>
#include <YSI_Data\y_sparsearray>
#include <YSI_Extra\y_inline_mysql>
#include <YSI_Server\y_scriptinit>
#include <YSI_Storage\y_amx> // For init functions, e.g. core/commands/callbacks
#include <YSI_Visual\y_dialog>

#include <tdw/tdw_vmath>
#include <tdw/tdw_vsa_data>

DEFINE_HOOK_REPLACEMENT__(OnPlayer, OP);

// Fixes
///////////
#include "core/fixes/textdraws.pwn"
#include "core/utils/bcrypt_inline.pwn"
#include "core/utils/objects_inline.pwn"
#include "core/utils/color.pwn"

// Headers
/////////////
#include "core/utils/header.pwn"
#include "core/config/header.pwn"
#include "core/transitions/header.pwn"
#include "core/timers/header.pwn"
#include "core/commands/header.pwn"
#include "server/database/header.pwn"
#include "server/textdraws/header.pwn"
#include "server/notifications/header.pwn"
#include "server/enter_exits/header.pwn"
#include "server/stores/header.pwn"
#include "server/chat/header.pwn"
#include "server/vehicles/header.pwn"
#include "server/chatbuffer/header.pwn"
#include "server/jobs/header.pwn"
#include "server/jobs/gunman/header.pwn"
#include "player/account/header.pwn"
#include "player/needs/header.pwn"
#include "player/auth/header.pwn"
#include "player/keygame/header.pwn"
#include "player/inventory/header.pwn"
#include "player/cellphone/header.pwn"
#include "player/weapons/header.pwn"

// Functions
///////////////
#include "core/utils/functions.pwn"
#include "core/config/functions.pwn"
#include "core/transitions/functions.pwn"
#include "core/timers/functions.pwn"
#include "core/commands/functions.pwn"
#include "server/notifications/functions.pwn"
#include "server/enter_exits/functions.pwn"
#include "server/stores/functions.pwn"
#include "server/chat/functions.pwn"
#include "server/vehicles/functions.pwn"
#include "server/chatbuffer/functions.pwn"
#include "server/jobs/functions.pwn"
#include "player/account/functions.pwn"
#include "player/needs/functions.pwn"
#include "player/auth/functions.pwn"
#include "player/keygame/functions.pwn"
#include "player/inventory/functions.pwn"
#include "player/cellphone/functions.pwn"
#include "player/weapons/functions.pwn"

// Callbacks
///////////////
#include "core/config/callbacks.pwn"
#include "core/transitions/callbacks.pwn"
#include "core/timers/callbacks.pwn"
#include "core/commands/callbacks.pwn"
#include "server/database/callbacks.pwn"
#include "server/textdraws/callbacks.pwn"
#include "server/notifications/callbacks.pwn"
#include "server/enter_exits/callbacks.pwn"
#include "server/stores/callbacks.pwn"
#include "server/stores/pizza/callbacks.pwn"
#include "server/stores/convenience/callbacks.pwn"
#include "server/chat/callbacks.pwn"
#include "server/vehicles/callbacks.pwn"
#include "server/chatbuffer/callbacks.pwn"
#include "player/account/callbacks.pwn"
#include "player/needs/callbacks.pwn"
#include "player/auth/callbacks.pwn"
#include "player/keygame/callbacks.pwn"
#include "player/inventory/callbacks.pwn"
#include "server/jobs/callbacks.pwn"
#include "server/jobs/gunman/callbacks.pwn"

// Commands
//////////////
#include "server/chat/commands.pwn"
#include "server/vehicles/commands.pwn"
#include "player/needs/commands.pwn"

public const THE_HOOD__ = 1;

public OnGameModeInit()
{
    CA_Init();

    return 1;
}

CMD:w(playerid, const params[])
{
    extract params -> new weaponid, ammo = 32767; else {
        return SendClientMessage(playerid, -1, "/w <weaponid> [ammo]");
    }

    Player_GiveWeapon(playerid, weaponid, ammo);
    
    return 1;
}

CMD:sound(playerid, const params[])
{
    extract params -> new sound; else {
        return 1;
    }

    PlayerPlaySound(playerid, sound, 0.0, 0.0, 0.0);
    return 1;
}

#if defined DEBUG_MODE
SSCANF:specialaction(string[])
{
    if('0' <= string[0] <= '9')
    {
        new ret = strval(string);
        switch(ret)
        {
            case 0, 2, 5 .. 8, 10 .. 13, 20 .. 23, 68, 24, 25: return ret;
        }

        return 0;
    }
    else if(!strcmp(string, "SPECIAL_ACTION_NONE")) return 0;
    else if(!strcmp(string, "SPECIAL_ACTION_USEJETPACK")) return 2;
    else if(!strcmp(string, "SPECIAL_ACTION_DANCE1")) return 5;
    else if(!strcmp(string, "SPECIAL_ACTION_DANCE2")) return 6;
    else if(!strcmp(string, "SPECIAL_ACTION_DANCE3")) return 7;
    else if(!strcmp(string, "SPECIAL_ACTION_DANCE4")) return 8;
    else if(!strcmp(string, "SPECIAL_ACTION_HANDSUP")) return 10;
    else if(!strcmp(string, "SPECIAL_ACTION_USECELLPHONE")) return 11;
    else if(!strcmp(string, "SPECIAL_ACTION_SITTING")) return 12;
    else if(!strcmp(string, "SPECIAL_ACTION_STOPUSECELLPHONE")) return 13;
    else if(!strcmp(string, "SPECIAL_ACTION_DRINK_BEER")) return 20;
    else if(!strcmp(string, "SPECIAL_ACTION_SMOKE_CIGGY")) return 21;
    else if(!strcmp(string, "SPECIAL_ACTION_DRINK_WINE")) return 22;
    else if(!strcmp(string, "SPECIAL_ACTION_DRINK_SPRUNK")) return 23;
    else if(!strcmp(string, "SPECIAL_ACTION_PISSING")) return 68;
    else if(!strcmp(string, "SPECIAL_ACTION_CUFFED")) return 24;
    else if(!strcmp(string, "SPECIAL_ACTION_CARRY")) return 25;

    return 0;
}

CMD:special_action(playerid, const params[])
{
    new action;
    sscanf(params, "K<specialaction>(SPECIAL_ACTION_NONE)", action);

    SetPlayerSpecialAction(playerid, action);
    return 1;
}

CMD:attach(playerid, const params[])
{
    new model, bone, index;
    if(sscanf(params, "iI(1)I(0)", model, bone, index))
    {
        RemovePlayerAttachedObject(playerid, 0);
        return SendClientMessage(playerid, -1, "USAGE: /attach <model> [bone] [index]");
    }

    SetPlayerAttachedObject(playerid, index, model, bone);
    EditAttachedObject(playerid, index);

    return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    SendClientMessagef(playerid, -1, "X: %.2f", fOffsetX);
    SendClientMessagef(playerid, -1, "Y: %.2f", fOffsetY);
    SendClientMessagef(playerid, -1, "Z: %.2f", fOffsetZ);
    SendClientMessagef(playerid, -1, "rX: %.2f", fRotX);
    SendClientMessagef(playerid, -1, "rY: %.2f", fRotY);
    SendClientMessagef(playerid, -1, "rZ: %.2f", fRotZ);
    SendClientMessagef(playerid, -1, "sX: %.2f", fScaleX);
    SendClientMessagef(playerid, -1, "sY: %.2f", fScaleY);
    SendClientMessagef(playerid, -1, "sZ: %.2f", fScaleZ);
    return 1;
}

CMD:goto(playerid, const params[])
{
    extract params -> new Float:x, Float:y, Float:z, world = -1, interior = -1; else {
        return SendClientMessage(playerid, -1, "USAGE: /goto <x> <y> <z> [world] [interior]");
    }

    SetPlayerPos(playerid, x, y, z);
    if(world != -1)
        SetPlayerVirtualWorld(playerid, world);

    if(interior != -1)
        SetPlayerInterior(playerid, interior);

    return 1;
}

CMD:desbug(playerid, const params[])
{
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    return 1;
}

CMD:create_n_edit(playerid, const params[])
{
    extract params -> new model, Float:x = 0.0, Float:y = 0.0, Float:z = 0.0, Float:rX = 0.0, Float:rY = 0.0, Float:rZ = 0.0; else return 1;

    if(x == 0.0 && y == 0.0 && z == 0.0)
    {
        GetPlayerPos(playerid, x, y, z);
    }

    new o = CreateObject(model, x, y, z, rX, rY, rZ);
    EditObject(playerid, o);

    return 1;
}

public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ )
{
    SendClientMessagef(playerid, -1, "X: %.2f", fX);
    SendClientMessagef(playerid, -1, "Y: %.2f", fY);
    SendClientMessagef(playerid, -1, "Z: %.2f", fZ);
    SendClientMessagef(playerid, -1, "rX: %.2f", fRotX);
    SendClientMessagef(playerid, -1, "rY: %.2f", fRotY);
    SendClientMessagef(playerid, -1, "rZ: %.2f", fRotZ);
    return 1;
}
#endif

CMD:text(playerid, const params[])
{
    Notification_ShowBeatingText(playerid, 20000, 0xED2B2B, 255, 100, "mamaguebo");
    return 1;
}

CMD:keygame(playerid, const params[])
{
    TogglePlayerControllable(playerid, false);

    inline const KeyGame(bool:success)
    {
        if(success)
        {
            SendClientMessage(playerid, -1, "felisidades pasaste el juego de las teklas");
        }
        else
        {
            SendClientMessage(playerid, -1, "maldito sonso perdistes");
        }

        TogglePlayerControllable(playerid, true);
    }
    Player_StartKeyGame(playerid, using inline KeyGame);

    return 1;
}

CMD:resend_chat(playerid, const params[])
{
    ChatBuffer_Unhook();
    SendClientMessage(playerid, -1, "Resending messages... (except this one)");
    ChatBuffer_Rehook();
    
    Player_ResendChat(playerid);
    return 1;
}
