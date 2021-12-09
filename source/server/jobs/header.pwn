#if defined _H_JOBS_
    #endinput
#endif
#define _H_JOBS_

enum eJobs
{
    JOB_NONE,
    JOB_GUNMAN,
    JOB_POSTMAN
};

enum eJobEvent
{
    JOB_EVENT_JOIN,
    JOB_EVENT_LEFT
};

new const g_rgszJobNames[eJobs][] = {
    "Ninguno",
    "Armero",
    "Cartero"
};

new
    eJobs:g_rgePlayerCurrentJobShift[MAX_PLAYERS char],
    g_rgiPlayerJobPaycheck[MAX_PLAYERS],
    Func:g_rgpJobCallbacks[eJobs]<ii>;

#define Player_Job(%0) (g_rgePlayerCurrentJobShift{(%0)})

forward Job_CreatePickupSite(eJobs:job_id, Float:pos_x, Float:pos_y, Float:pos_z, interior, vw, const extra_text[] = "");
forward Job_AddCallback(eJobs:job_id, Func:cb<ii>);