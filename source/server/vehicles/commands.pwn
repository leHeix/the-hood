#if defined _VEHICLES_COMMANDS_
    #endinput
#endif
#define _VEHICLES_COMMANDS_

command veh(playerid, const params[], "Invoca un vehículo en tu posición")
{
    new modelid, color1, color2;
    if(sscanf(params, "k<vehicle>D(-1)D(-1)", modelid, color1, color2) || modelid == -1)
    {
        return SendClientMessage(playerid, 0xDADADAFF, "USO: /{ED2B2B}veh {DADADA}<modelo> {969696}[color 1] [color 2]");
    }

    new Float:x, Float:y, Float:z, Float:ang;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, ang);

    new vehicleid = CreateVehicle(modelid, x, y, z, ang, color1, color2, 0);
    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
    SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));

    new model_name[32];
    GetModelStaticNameFromId(modelid, model_name);

    SendClientMessagef(playerid, 0xDADADAFF, "Se creó un {ED2B2B}%s {DADADA}(modelo {ED2B2B}%d{DADADA}) {DADADA}en tu posición.", model_name, modelid);
    
    return 1;
}
alias:veh("v")
flags:veh(CMD_ADMIN<RANK_LEVEL_GAME_OPERATOR>)

command give_veh(playerid, const params[], "Registra un vehículo para un jugador")
{
    new destination_player, vehicle = INVALID_VEHICLE_ID;
    if(sscanf(params, "ri", destination_player, vehicle) || !IsValidVehicle(vehicle))
    {
        return SendClientMessage(playerid, 0xDADADAFF, "USO: {ED2B2B}/give_veh {DADADA}<jugador> <id vehículo>");
    }

    if(Player_RegisterVehicle(destination_player, vehicle))
    {
        new model[50];
        GetModelStaticNameFromId(GetVehicleModel(vehicle), model);
        va_SendClientMessage(playerid, 0xED2B2BFF, "{ED2B2B}› {DADADA}Se registró un {ED2B2B}%s {DADADA}en la cuenta de {ED2B2B}%s{DADADA}.", model, Player_RPName(destination_player));
    }

    return 1;
}
flags:give_veh(CMD_ADMIN<RANK_LEVEL_ADMIN>)