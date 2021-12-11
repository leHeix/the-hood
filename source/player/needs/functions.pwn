#if defined _NEEDS_FUNCTIONS_
    #endinput
#endif
#define _NEEDS_FUNCTIONS_

Needs_ToggleBar(playerid, bool:toggle)
{
    if(toggle)
    {
        TextDrawShowForPlayer(playerid, g_tdNeedBars[0]);
        TextDrawShowForPlayer(playerid, g_tdNeedBars[1]);
        TextDrawShowForPlayer(playerid, g_tdNeedBars[2]);
        TextDrawShowForPlayer(playerid, g_tdNeedBars[3]);

        Needs_UpdateTextDraws(playerid, false);

        TextDrawShowForPlayer(playerid, g_tdNeedProgress[0]);

        TextDrawShowForPlayer(playerid, g_tdNeedBars[4]);
        TextDrawShowForPlayer(playerid, g_tdNeedBars[5]);
        TextDrawShowForPlayer(playerid, g_tdNeedBars[6]);
        TextDrawShowForPlayer(playerid, g_tdNeedBars[7]);
        TextDrawShowForPlayer(playerid, g_tdNeedBars[8]);

        TextDrawShowForPlayer(playerid, g_tdNeedProgress[1]);

        for(new i = 9; i < sizeof(g_tdNeedBars); ++i)
            TextDrawShowForPlayer(playerid, g_tdNeedBars[i]);
    }
    else
    {
        TextDrawHideForPlayer(playerid, g_tdNeedProgress[0]);
        TextDrawHideForPlayer(playerid, g_tdNeedProgress[1]);

        for(new i = sizeof(g_tdNeedBars) - 1; i != -1; --i)
            TextDrawHideForPlayer(playerid, g_tdNeedBars[i]);
    }

    return 0;
}

Needs_StartUpdating(playerid)
{
    g_rgiTimerUpdateNeeds[playerid][NEEDS_HUNGER] = SetTimerEx(!"NEEDS_UpdateThirst", 60000, true, !"i", playerid);
    g_rgiTimerUpdateNeeds[playerid][NEEDS_THIRST] = SetTimerEx(!"NEEDS_UpdateHunger", 120000, true, !"i", playerid);
    return 0;
}

Needs_StopUpdating(playerid)
{
    KillTimer(g_rgiTimerUpdateNeeds[playerid][NEEDS_HUNGER]);
    KillTimer(g_rgiTimerUpdateNeeds[playerid][NEEDS_THIRST]);

    return 
        g_rgiTimerUpdateNeeds[playerid][NEEDS_HUNGER] =
        g_rgiTimerUpdateNeeds[playerid][NEEDS_THIRST] = 0;
}

Needs_UpdateTextDraws(playerid, bool:show = false)
{
    const Float:thirst_full = 596.500;
    const Float:thirst_empty = 505.000;
    const Float:hunger_full = 510.500;
    const Float:hunger_empty = 608.000;

    new Float:thirst_coords = thirst_empty + (Player_Thirst(playerid) * 0.915);
    if(thirst_coords > thirst_full)
        thirst_coords = thirst_full;

    new Float:hunger_coords = hunger_empty - (Player_Hunger(playerid) * 0.975);
    if(hunger_coords < hunger_full)
        hunger_coords = hunger_full;

    // The AMX is single-threaded. This can, technically, never fail. (?)
    // Though it's really bad, it's the only way I've found around our textdraw order issue.
    TextDrawTextSize(g_tdNeedProgress[0], hunger_coords, 0.0);
    TextDrawTextSize(g_tdNeedProgress[1], thirst_coords, 0.0);

    if(show)
    {
        TextDrawShowForPlayer(playerid, g_tdNeedProgress[0]);
        TextDrawShowForPlayer(playerid, g_tdNeedProgress[1]);
    }

    return 1;
}

Player_Vomit(playerid)
{
    Bit_Set(Player_Flags(playerid), PFLAG_IS_PUKING, true);

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    SetPlayerFacingAngle(playerid, 0.0);
    ApplyAnimation(playerid, "FOOD", "EAT_VOMIT_P", 4.0, false, false, false, true, 0);
    PlayerPlaySound(playerid, 1, 0.0, 0.0, 0.0);
    PlayerPlaySound(playerid, 1169, 0.0, 0.0, 0.0);

    inline const StartPuking()
    {
        new puke_obj = CreateObject(18722, x + 0.355, y - 0.116, z - 1.6, 0.0, 0.0, 0.0);

        inline const AnimDone()
        {
            Bit_Set(Player_Flags(playerid), PFLAG_IS_PUKING, false);
            DestroyObject(puke_obj);
            ClearAnimations(playerid);
            PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
        }
        PlayerTimer_Start(playerid, 3500, false, using inline AnimDone);
    }
    PlayerTimer_Start(playerid, 4000, false, using inline StartPuking);
}

Player_SetHunger(playerid, Float:hunger)
{
    Player_Hunger(playerid) = fclamp(hunger, 0.0, 100.0);
    return 1;
}

Player_SetThirst(playerid, Float:thirst)
{
    Player_Thirst(playerid) = fclamp(thirst, 0.0, 100.0);
    return 1;
}

Player_DrinkFromHand(playerid)
{
    if(!Bit_Get(Player_Flags(playerid), PFLAG_HAS_DRINK_ON_HANDS))
        return 0;

    if(GetPlayerAnimationIndex(playerid) == 16) /* Check if player is already drinking (16 = BAR:DNK_STNDM_LOOP) */
        return 0;

    new maxclicks = Player_Data(playerid, e_iPlayerDrinkClickedRemaining) & 0xFF;
    new clicked = Player_Data(playerid, e_iPlayerDrinkClickedRemaining) >> 8;

    if(++clicked >= maxclicks)
    {
        new model, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:sx, Float:sy, Float:sz, c1, c2;
        GetPlayerAttachedObject(playerid, 0, model, .fX = x, .fY = y, .fZ = z, .fRotX = rx, .fRotY = ry, .fRotZ = rz, .fSacleX = sx, .fScaleY = sy, .fScaleZ = sz, .materialcolor1 = c1, .materialcolor2 = c2);
        SetPlayerAttachedObject(playerid, 0, model, 5, x, y, z, rx, ry, rz, sx, sy, sz, c1, c2);

        ApplyAnimation(playerid, "VENDING", "VEND_DRINK_P", 4.1, false, false, false, false, 0, false);
        Bit_Set(Player_Flags(playerid), PFLAG_HAS_DRINK_ON_HANDS, false);
        Player_Data(playerid, e_iPlayerDrinkClickedRemaining) = 0;
        Player_Data(playerid, e_fPlayerThirstPerDrink) = 0.0;

        inline const Due()
        {
            RemovePlayerAttachedObject(playerid, 0);
        }
        PlayerTimer_Start(playerid, 1500, false, using inline Due);
    }
    else
    {
        Player_Data(playerid, e_iPlayerDrinkClickedRemaining) = (clicked << 8) | maxclicks;

        ApplyAnimation(playerid, "BAR", "DNK_STNDM_LOOP", 4.1, false, false, false, false, 0, false);
    }

    Player_SetThirst(playerid, Player_Thirst(playerid) - Player_Data(playerid, e_fPlayerThirstPerDrink));
    Needs_UpdateTextDraws(playerid, false);
    TextDrawShowForPlayer(playerid, g_tdNeedProgress[1]);

    return 1;
}