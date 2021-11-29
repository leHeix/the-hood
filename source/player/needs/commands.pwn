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

forward SHIT_StepOne(playerid, objectid);
public SHIT_StepOne(playerid, objectid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new
        vw = GetPlayerVirtualWorld(playerid),
        int = GetPlayerInterior(playerid);

    if(int != 0)
        z -= 0.5;
    else
        CA_FindZ_For2DCoord(x, y, z);

    DestroyDynamicObject(objectid);
    new fx = CreateDynamicObject(18678, x, y, z, 0.0, 0.0, 0.0, .worldid = vw, .interiorid = int); // fart effect
    new object_one = CreateDynamicObject(18894, x, y, z, 102.09998, 0.0, 0.0, .worldid = vw, .interiorid = int); // shit
    new object_two = CreateDynamicObject(18894, x, y + 0.037354, z + 0.01104, 55.699939, -0.3999, -5.6999, .worldid = vw, .interiorid = int); // shit
    SetDynamicObjectMaterialText(object_one, 0, "AAAAAAAAAAAAA", 10, "courier", 20, 0, 0xFF574336, 0xFF854C24, 0);
    SetDynamicObjectMaterialText(object_two, 0, "AAAAAAAAAAAAA", 10, "courier", 20, 0, 0xFF574336, 0xFF854C24, 0);
    new trash_object = CreateDynamicObject(1265, x, y, z - 0.4, 0.0, 0.0, 0.0, .worldid = vw, .interiorid = int);
    new odor_fx = CreateDynamicObject(18735, x, y, z - 1.2, 0.0, 0.0, 0.0, .worldid = vw, .interiorid = int);
    ClearAnimations(playerid);

    new Text3D:label = CreateDynamic3DTextLabel(va_return("{DADADA}Cago de {ED2B2B}%s", Player_RPName(playerid)), -1, x, y, z + 0.6, 5.0, .testlos = 1, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid));

    foreach(new i : StreamedPlayer[playerid])
    {
        Streamer_Update(i);
    }

    Streamer_Update(playerid);

    SetTimerEx("SHIT_StepTwo", 30000, false, "iiiiiii", playerid, fx, object_one, object_two, odor_fx, trash_object, _:label);

    return 1;
}

forward SHIT_StepTwo(playerid, effect_one, shit_object_one, shit_object_two, effect_two, trash_object, Text3D:label);
public SHIT_StepTwo(playerid, effect_one, shit_object_one, shit_object_two, effect_two, trash_object, Text3D:label)
{
    DestroyDynamicObject(effect_one);
    DestroyDynamicObject(shit_object_one);
    DestroyDynamicObject(shit_object_two);
    DestroyDynamicObject(effect_two);
    DestroyDynamicObject(trash_object);
    DestroyDynamic3DTextLabel(label);
    return 1;
}

command cagar(playerid, const params[], "Defeca")
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
        return SendClientMessage(playerid, 0xDADADAFF, "No estas {ED2B2B}de pie{DADADA}.");

    if(GetPlayerSurfingObjectID(playerid) != INVALID_OBJECT_ID)
        return SendClientMessage(playerid, 0xDADADAFF, "No puedes cagar {ED2B2B}encima de un objeto{DADADA}.");

    if(GetPlayerSurfingVehicleID(playerid) != INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, 0xDADADAFF, "No puedes cagar {ED2B2B}encima de un vehículo{DADADA}.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z),

    ApplyAnimation(playerid, "PED", "SEAT_IDLE", 4.1, false, false, false, true, 0, false);
    new fx_object = CreateDynamicObject(18672, x, y, z - 1.0, 0.0, 0.0, 0.0);

    SetTimerEx("SHIT_StepOne", 2000, false, "ii", playerid, fx_object);

    return 1;
}