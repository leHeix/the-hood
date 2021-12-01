#if defined _H_TRANSITIONS_
    #endinput
#endif
#define _H_TRANSITIONS_

enum eTransitionData
{
    bool:e_bActive,
    bool:e_bPaused,
    e_iEndOpacity,
    Func:e_pCallback<>,
    bool:e_bTransitionIn,
    e_iUpdateTimer
};

#define TRANSITION_IN (true)
#define TRANSITION_OUT (false)

new g_rgeTransitionData[MAX_PLAYERS + 1][eTransitionData];

forward Transition_StartInline(Func:cb<>, playerid, count, bool:in);
forward Transition_Stop(playerid);
forward Transition_Pause(playerid);
forward Transition_Resume(playerid);

forward TRANSITION_Process(playerid);