#if defined _NEEDS_COMMANDS_
    #endinput
#endif
#define _NEEDS_COMMANDS_

command set_needs(playerid, const params[], "Asigna las necesidades de un jugador.")
{
    new dest_player, Float:hunger, Float:thirst;
    if(sscanf(params, "rF(-1.0)F(-1.0)", dest_player, hunger, thirst))
    {
        return SendClientMessage(playerid, 0xDADADAFF, "USO: /{ED2B2B}set_needs {DADADA}<usuario> {969696}[hambre] [sed]");
    }

    new message[120];
    format(message, sizeof(message), "{ED2B2B}› {DADADA}Se le asignó a {ED2B2B}%s{DADADA}", Player_GetName(playerid));

    if(hunger >= 0.0)
    {
        format(message, sizeof(message), "%s %.1f puntos de hambre%s", message, hunger, (thirst >= 0.0 ? !" y" : !"."));
        Player_Hunger(dest_player) = hunger;
    }

    if(thirst >= 0.0)
    {
        format(message, sizeof(message), "%s %.2f puntos de sed.", message, thirst);
        Player_Thirst(dest_player) = thirst;
    }

    Needs_UpdateTextDraws(playerid, true);
    SendClientMessage(playerid, -1, message);
    return 1;
}
flags:set_needs(CMD_ADMIN<RANK_LEVEL_MODERATOR>)