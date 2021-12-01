#if defined _CALLBACKS_TRANSITIONS_
    #endinput
#endif
#define _CALLBACKS_TRANSITIONS_

public TRANSITION_Process(playerid)
{
    new colour = PlayerTextDrawGetBoxColor(playerid, p_tdTransition{playerid});
    new alpha = (colour & 0xFF);

    alpha = clamp((g_rgeTransitionData[playerid][e_bTransitionIn] ? alpha + 5 : alpha - 5), 0, 255);
    if(alpha == 255)
    {
        g_rgeTransitionData[playerid][e_bTransitionIn] = false;
    }
    else if(!alpha)
    {
        Transition_Stop(playerid);
        return 1;
    }

    colour = RGBA_SetAlpha(colour, alpha);

    PlayerTextDrawBoxColor(playerid, p_tdTransition{playerid}, colour);
    PlayerTextDrawShow(playerid, p_tdTransition{playerid});

    if(g_rgeTransitionData[playerid][e_pCallback] && alpha == g_rgeTransitionData[playerid][e_iEndOpacity])
    {
        new Func:cb<> = g_rgeTransitionData[playerid][e_pCallback];
        g_rgeTransitionData[playerid][e_pCallback] = Func:0<>;
        @.cb();
        Indirect_Release(cb);
    }
    
    return 1;
}