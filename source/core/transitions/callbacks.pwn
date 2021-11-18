#if defined _TRANSITIONS_CALLBACKS_
	#endinput
#endif
#define _TRANSITIONS_CALLBACKS_

static RunTransitionCallback(playerid, count, bool:in, task_count, bool:task_in)
{
	if(p_rgeTransitionData[playerid][e_iTransitionCallback] != Func:0<> && in == task_in && count == task_count)
	{
		new Func:fun<> = p_rgeTransitionData[playerid][e_iTransitionCallback];
		p_rgeTransitionData[playerid][e_iTransitionCallback] = Func:0<>;

		@.fun();

		Indirect_Release(fun);
	}

	return 0;
}

public TRANSITION_Process(playerid, bool:in, task_count, bool:task_in)
{	
	new count = PlayerTextDrawGetBoxColor(playerid, p_tdTransition{playerid});

	if(in)
	{
		count += 5;
		PlayerTextDrawBoxColor(playerid, p_tdTransition{playerid}, count);

		if(count >= 260)
		{
			KillTimer(p_rgeTransitionData[playerid][e_iTransitionTimer]);
			p_rgeTransitionData[playerid][e_bTransitionIn] = true;
			p_rgeTransitionData[playerid][e_iTransitionTimer] = SetTimerEx(!"TRANSITION_Process", 30, true, "iiii", playerid, false, task_count, task_in);
		}
	}
	else
	{
		count -= 5;
		PlayerTextDrawBoxColor(playerid, p_tdTransition{playerid}, count);

		if(count <= 0)
		{
			RunTransitionCallback(playerid, count, in, task_count, task_in);
			Transition_Stop(playerid);
			return 0;
		}
	}

	PlayerTextDrawShow(playerid, p_tdTransition{playerid});
	RunTransitionCallback(playerid, count, in, task_count, task_in);

	return 1;
}