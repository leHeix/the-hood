#if defined _TRANSITIONS_FUNCTIONS_
	#endinput
#endif
#define _TRANSITIONS_FUNCTIONS_

Transition_Start(playerid, bool:in = TRANSITION_IN, task_count = -1, task_in = -1)
{
	PlayerTextDrawBoxColor(playerid, p_tdTransition{playerid}, (in ? 0 : 255));

    p_rgeTransitionData[playerid][e_bTransitionIn] = in;
    p_rgeTransitionData[playerid][e_iTransitionTaskCount] = task_count;
    p_rgeTransitionData[playerid][e_bTransitionTaskIn] = bool:task_in;
    p_rgeTransitionData[playerid][e_iTransitionTimer] = SetTimerEx(!"TRANSITION_Process", 30, true, !"iiii", playerid, in, task_count, task_in);

	return 1;
}

Transition_Stop(playerid)
{
	if(!Transition_IsActive(playerid))
		return 0;

	if(p_rgeTransitionData[playerid][e_iTransitionCallback])
		Indirect_Release(p_rgeTransitionData[playerid][e_iTransitionCallback]);

	KillTimer(p_rgeTransitionData[playerid][e_iTransitionTimer]);

	p_rgeTransitionData[playerid] = p_rgeTransitionData[MAX_PLAYERS];

	PlayerTextDrawHide(playerid, p_tdTransition{playerid});

	return 1;
}

Transition_StartInline(Func:cb<>, playerid, count, bool:in)
{
	Indirect_Claim(cb);

	p_rgeTransitionData[playerid][e_iTransitionCallback] = cb;

	if(Transition_IsActive(playerid))
	{
		p_rgeTransitionData[playerid][e_iTransitionTaskCount] = count;
        p_rgeTransitionData[playerid][e_bTransitionTaskIn] = in;
		Transition_Resume(playerid);
	}
	else
	{
		Transition_Start(playerid, true, count, in);
	}

	return 1;
}

Transition_Pause(playerid)
{
	if(!Transition_IsActive(playerid))
		return 0;

	KillTimer(p_rgeTransitionData[playerid][e_iTransitionTimer]);

	return 1;
}

Transition_Resume(playerid)
{
	if(!Transition_IsActive(playerid))
		return 0;

	KillTimer(p_rgeTransitionData[playerid][e_iTransitionTimer]);
	p_rgeTransitionData[playerid][e_iTransitionTimer] = SetTimerEx(!"TRANSITION_Process", 30, true, !"iiii", playerid, p_rgeTransitionData[playerid][e_bTransitionIn], p_rgeTransitionData[playerid][e_iTransitionTaskCount], p_rgeTransitionData[playerid][e_bTransitionTaskIn]);

	return 1;
}