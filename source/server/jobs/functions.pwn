#if defined _FUNCTIONS_JOBS_
    #endinput
#endif
#define _FUNCTIONS_JOBS_

Job_CreatePickupSite(eJobs:job_id, Float:pos_x, Float:pos_y, Float:pos_z, interior, vw, const extra_text[] = "")
{
    new labelstring[256];
    format(labelstring, sizeof(labelstring), "Trabajo de {ED2B2B}%s\n{DADADA}Presiona {ED2B2B}Y {DADADA}para empezar a trabajar", g_rgszJobNames[job_id]);
    if(!isnull(extra_text))
    {
        strcat(labelstring, !"\n");
        strcat(labelstring, extra_text);
    }

    CreateDynamic3DTextLabel(labelstring, 0xDADADAFF, pos_x, pos_y, pos_z, 10.0, .testlos = 1, .worldid = vw, .interiorid = interior);
    new area = CreateDynamicCircle(pos_x, pos_y, 1.0, .worldid = vw, .interiorid = interior);
    new info[2];
    info[0] = 0x4A4F42;
    info[1] = _:job_id;
    Streamer_SetArrayData(STREAMER_TYPE_AREA, area, E_STREAMER_EXTRA_ID, info);
    
    return 1;
}

Job_AddCallback(eJobs:job_id, Func:cb<ii>)
{
    Indirect_Claim(cb);
    if(g_rgpJobCallbacks[job_id])
        Indirect_Release(g_rgpJobCallbacks[job_id]);

    g_rgpJobCallbacks[job_id] = cb;
    return 1;
}