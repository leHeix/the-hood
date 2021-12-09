#if defined _JOBS_GUNSMAN_CALLBACKS_
    #endinput
#endif
#define _JOBS_GUNSMAN_CALLBACKS_

#include <YSI_Coding\y_hooks>

static GunManBuildingCallback(playerid, bool:enter, d)
{    
    #pragma unused d

    if(enter)
    {
        Notification_ShowBeatingText(playerid, 5000, 0xED2B2B, 255, 100, "Habla con el armero para fabricar armas");
    }
    else
    {
        if(Player_Job(playerid) == JOB_GUNMAN)
        {
            Notification_ShowBeatingText(playerid, 5000, 0xED2B2B, 255, 100, "Fuiste despedido de la armería por abandonar el edificio");
            Player_Job(playerid) = JOB_NONE;
            
            new Func:cb<ii> = Func:g_rgpJobCallbacks[JOB_GUNMAN]<ii>;
            if(cb != Func:0<ii>)
            {
                @.cb(playerid, _:JOB_EVENT_LEFT);
            }
        } 
    }

    return 1;
}

static GunManEvent(playerid, _event_id)
{
    new eJobEvent:event_id = eJobEvent:_event_id;

    switch(event_id)
    {
        case JOB_EVENT_JOIN:
        {
            new id = Cell_GetLowestBlank(g_iUsedGunmanBenchs);
            if(id == sizeof(g_rgfGunmanBenchSites))
            {
                Iter_Add(GunmanBenchQueue, playerid);
                Notification_ShowBeatingText(playerid, 7500, 0xED2B2B, 255, 100, "Todas las mesas estan usadas. Se te notificará cuando se libere una");
                
                return 1;
            }

            g_rgiPlayerBenchUsed[playerid] = id;
            TogglePlayerDynamicCP(playerid, g_rgiBenchCheckpoint[id], true);
            Streamer_Update(playerid, STREAMER_TYPE_CP);
            Notification_ShowBeatingText(playerid, 7500, 0xED2B2B, 255, 100, "Dirijete a tu mesa asignada para empezar a trabajar");
        }
        case JOB_EVENT_LEFT:
        {
            if(g_rgiPlayerJobPaycheck[playerid] > 0)
            {
                Player_Job(playerid) = JOB_GUNMAN;
                Player_GiveMoney(playerid, g_rgiPlayerJobPaycheck[playerid], true);
                Notification_Show(playerid, @f("Te pagaron ~g~%d$~w~ por tus trabajos. Vuelve a tu mesa o presiona ~k~~CONVERSATION_YES~ para dejar de trabajar", g_rgiPlayerJobPaycheck[playerid]), 5000);
                g_rgiPlayerJobPaycheck[playerid] = 0;
                return 1;
            }

            if(g_rgiPlayerBenchUsed[playerid] != -1)
            {
                TogglePlayerDynamicCP(playerid, g_rgiBenchCheckpoint[g_rgiPlayerBenchUsed[playerid]], false);
                g_iUsedGunmanBenchs &= ~(1 << g_rgiPlayerBenchUsed[playerid]);
                g_rgiPlayerBenchUsed[playerid] = -1;
            }

            Iter_Remove(GunmanBenchQueue, playerid);
        }
    }

    return 1;
}

hook OnGameModeInit()
{
    // Actors
    CreateDynamicActor(168, 2548.1860, -1293.0232, 1045.1250, 182.7474, .worldid = 0, .interiorid = 2);

    // Jobs
    Job_CreatePickupSite(JOB_GUNMAN, 2548.1860, -1293.0232, 1044.1250, 2, 0, "{DADADA}Presiona {ED2B2B}Y {DADADA}para recibir tu paga");
    Job_AddCallback(JOB_GUNMAN, using function GunManEvent<ii>);
    
    // EnExs
    EnterExit_Create(19902, "{ED2B2B}Taller de armas\n{DADADA}Presiona {ED2B2B}H {DADADA}para entrar", "{DADADA}Presiona {ED2B2B}H {DADADA}para salir", 1976.0343, -1923.4221, 13.5469, 180.1644, 0, 0, 2570.4001, -1301.9230, 1044.1250, 88.4036, 0, 2, -1, __addressof(GunManBuildingCallback));

    // MapIcons
    CreateDynamicMapIcon(1976.0343, -1923.4221, 13.5469, 18, -1);

    new tmpobjectid = CreateDynamicObject(19447, 2571.55078, -1301.67456, 1044.49414, 0.00000, 0.00000, 0.00000, .worldid = 0, .interiorid = 2);
    SetDynamicObjectMaterial(tmpobjectid, 0, 19297, "matlights", "emergencylights64", 0x00FFFFFF);
    tmpobjectid = CreateDynamicObject(19447, 2530.55127, -1306.86475, 1048.78259, 0.00000, 0.00000, 0.00000, .worldid = 0, .interiorid = 2);
    SetDynamicObjectMaterial(tmpobjectid, 0, 19297, "matlights", "emergencylights64", 0x00FFFFFF);

    for(new i = sizeof(g_rgfGunmanBenchSites) - 1; i != -1; --i)
    {
        g_rgiBenchCheckpoint[i] = CreateDynamicCP(g_rgfGunmanBenchSites[i][0], g_rgfGunmanBenchSites[i][1], g_rgfGunmanBenchSites[i][2], 1.0, .worldid = 0, .interiorid = 2);
    }

    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
#if defined DEBUG_MODE
    printf("OnPlayerEnterDynamicCP(%d, %d)", playerid, checkpointid);
#endif

    if(g_rgiPlayerBenchUsed[playerid] != -1)
    {
        if(checkpointid == g_rgiBenchCheckpoint[g_rgiPlayerBenchUsed[playerid]])
        {
            TogglePlayerDynamicCP(playerid, checkpointid, false);
            TogglePlayerControllable(playerid, false);

            inline const ScreenBlacked()
            {
                TogglePlayerWidescreen(playerid, true);
                Player_ResendChat(playerid);

                SetPlayerFacingAngle(playerid, g_rgfGunmanBenchSites[g_rgiPlayerBenchUsed[playerid]][3]);

                inline const Game(bool:success)
                {
                    static const GunNames[][] = {
                        !"un rifle rudimentario",
                        !"un revólver",
                        !"un subfusil",
                        !"un rifle",
                        !"una carabina",
                        !"un rifle de asalto",
                        !"un fusil de francotirador"
                    };

                    ClearAnimations(playerid);
                    TogglePlayerControllable(playerid, true);
                    TogglePlayerWidescreen(playerid, false);
                    Player_ResendChat(playerid);

                    new crafted_gun = random(sizeof(GunNames));

                    if(success)
                    {
                        g_rgiPlayerJobPaycheck[playerid] += 150 * (crafted_gun + 1);
                        Notification_Show(playerid, @f("Fabricaste ~y~%s~w~. Ve con el armero para que te paguen o fabrica otra arma.", GunNames[crafted_gun]), 10000);
                    }
                    else
                    {
                        Notification_Show(playerid, @f("Fallaste al construir ~r~%s~w~. Intentalo nuevamente.", GunNames[crafted_gun]), 10000);
                    }

                    TogglePlayerDynamicCP(playerid, checkpointid, true);
                }
                Player_StartKeyGame(playerid, using inline Game);
            }
            Transition_StartInline(using inline ScreenBlacked, playerid, 255, TRANSITION_IN);
        }
    }

    return 1;
}