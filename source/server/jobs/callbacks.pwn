#if defined _CALLBACKS_JOBS_
    #endinput
#endif
#define _CALLBACKS_JOBS_

#include <YSI_Coding\y_hooks>

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_YES) != 0)
    {
        new info[2];
        new area_count = GetPlayerDynamicAreas(playerid, info, 1);
        if(!area_count)
            return 1;

        new area = info[0];
        Streamer_GetArrayData(STREAMER_TYPE_AREA, area, E_STREAMER_EXTRA_ID, info);

        // Area is from a job pickup
        if(info[0] == 0x4A4F42)
        {
            new eJobs:job_id = eJobs:info[1];
            if(job_id == JOB_NONE)
                return ~1;

            if(Player_Job(playerid) == JOB_NONE)
            {
                Player_Job(playerid) = job_id;
                new Func:cb<ii> = g_rgpJobCallbacks[job_id];
                if(cb != Func:0<ii>)
                {
                    @.cb(playerid, _:JOB_EVENT_JOIN);
                }
            }
            else if(Player_Job(playerid) == job_id)
            {
                Player_Job(playerid) = JOB_NONE;
                new Func:cb<ii> = g_rgpJobCallbacks[job_id];
                if(cb != Func:0<ii>)
                {
                    @.cb(playerid, _:JOB_EVENT_LEFT);
                }
            }

            return ~1;
        }
    }

    return 1;
}