#if defined _TRANSITIONS_FUNCTIONS_
    #endinput
#endif
#define _TRANSITIONS_FUNCTIONS_

Transition_StartInline(Func:cb<>, playerid, count, bool:in)
{
    Indirect_Claim(cb);

    new color = (in ? 0 : 0xFF);
    PlayerTextDrawBoxColor(playerid, p_tdTransition{playerid}, color);
    PlayerTextDrawShow(playerid, p_tdTransition{playerid});

    g_rgeTransitionData[playerid][e_pCallback] = cb;
    g_rgeTransitionData[playerid][e_bActive] = true;
    g_rgeTransitionData[playerid][e_bPaused] = false;
    g_rgeTransitionData[playerid][e_bTransitionIn] = in;
    g_rgeTransitionData[playerid][e_iEndOpacity] = count;
    g_rgeTransitionData[playerid][e_iUpdateTimer] = SetTimerEx(!"TRANSITION_Process", 20, true, "i", playerid);
    
    return 1;
}

void:Transition_Pause(playerid)
{
    KillTimer(g_rgeTransitionData[playerid][e_iUpdateTimer]);
    g_rgeTransitionData[playerid][e_bPaused] = true;
}

void:Transition_Resume(playerid)
{
    g_rgeTransitionData[playerid][e_bPaused] = false;
    g_rgeTransitionData[playerid][e_iUpdateTimer] = SetTimerEx(!"TRANSITION_Process", 20, true, "i", playerid);
}

void:Transition_Stop(playerid)
{
    PlayerTextDrawHide(playerid, p_tdTransition{playerid});
    KillTimer(g_rgeTransitionData[playerid][e_iUpdateTimer]);
    g_rgeTransitionData[playerid][e_bActive] = false;
    if(g_rgeTransitionData[playerid][e_pCallback])
        Indirect_Release(g_rgeTransitionData[playerid][e_pCallback]);
}