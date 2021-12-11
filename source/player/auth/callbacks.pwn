#if defined _CALLBACKS_AUTH_
    #endinput
#endif
#define _CALLBACKS_AUTH_

#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid)
{
	TogglePlayerSpectating(playerid, true);
    Chat_Clear(playerid);

	return 1;
}

hook OnPlayerRequestClass(playerid, classid)
{
    Chat_Clear(playerid);
    return 1;
}

public OnPlayerDataLoaded(playerid)
{
	inline const ScreenBlacked()
	{
		Transition_Pause(playerid);

		if(Bit_Get(Player_Flags(playerid), PFLAG_REGISTERED))
		{
			for(new i; i <= 13; ++i)
			{
				TextDrawShowForPlayer(playerid, g_tdRegisterAcc[i]);
			}

			for(new i = 18; i < sizeof(g_tdRegisterAcc); ++i)
			{
				TextDrawShowForPlayer(playerid, g_tdRegisterAcc[i]);
			}

			PlayerTextDrawSetString(playerid, p_tdRegisterAcc[playerid]{0}, Str_FixEncoding(Player_GetName(playerid)));
			PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{0});
			PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{1});
			PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{2});
			PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{3});

			TextDrawSetStringForPlayer(g_tdRegisterAcc[7], playerid, "Cuenta registrada");
			TextDrawSetStringForPlayer(g_tdRegisterAcc[19], playerid, Str_FixEncoding("Iniciar sesión"));
			TextDrawSetStringForPlayer(g_tdRegisterAcc[24], playerid, Str_FixEncoding("Último inicio de sesión: ~y~%s"), Player_GetLastConnection(playerid));

			SelectTextDraw(playerid, 0xD2B567FF);
		}
		else
		{
			SetPlayerCameraPos(playerid, 1585.296142, -2566.993652, 13.769470);
			SetPlayerCameraLookAt(playerid, 1580.729736, -2568.970458, 14.259890);

			Auth_ToggleTextdraws(playerid, true);
		}

		SetPlayerWeather(playerid, 0);
		SetPlayerTime(playerid, 23, 00);

		Transition_Resume(playerid);
	}
	Transition_StartInline(using inline ScreenBlacked, playerid, 255, TRANSITION_IN);

	return 1;
}

hook OnPlayerPressEsc(playerid)
{
	if(Bit_Get(Player_Flags(playerid), PFLAG_AUTHENTICATING) && IsTextDrawVisibleForPlayer(playerid, g_tdRegisterAcc[0]))
	{
		TextDraw_DelayedSelect(playerid, Player_GetSelectionColor(playerid));
		return ~1;
	}
	else if(Bit_Get(Player_Flags(playerid), PFLAG_CUSTOMIZING_PLAYER) && IsTextDrawVisibleForPlayer(playerid, g_tdPlayerCustomization[0]))
	{
		Bit_Set(Player_Flags(playerid), PFLAG_CUSTOMIZING_PLAYER, false);
    
		for(new i = (sizeof(g_tdPlayerCustomization) - 1); i != -1; --i)
		{
			TextDrawHideForPlayer(playerid, g_tdPlayerCustomization[i]);
		}
		PlayerTextDrawHide(playerid, p_tdPlayerCustomization{playerid});

		inline const ScreenBlacked()
		{
			Transition_Pause(playerid);

			inline const OnRegister()
			{
				Bit_Set(Player_Flags(playerid), PFLAG_REGISTERED, true);
				Bit_Set(Player_Flags(playerid), PFLAG_AUTHENTICATING, false);

                SetPlayerPos(playerid, 2109.1204, -1790.6901, 13.5547);
                SetPlayerFacingAngle(playerid, 350.1182);
                SetPlayerInterior(playerid, 0);
                SetPlayerCameraPos(playerid, 2096.242675, -1779.497558, 15.979070);
                SetPlayerCameraLookAt(playerid, 2103.439697, -1783.191162, 14.913400);
                RemovePlayerAttachedObject(playerid, INTRO_PROP_OBJECT_INDEX);
                SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
                ApplyAnimation(playerid, "SMOKING", "null", 4.1, false, false, false, false, 0, false);
                ApplyAnimation(playerid, "SMOKING", "M_SMKLEAN_LOOP", 4.1, false, false, false, true, 0, false);

                Transition_Resume(playerid);

                inline const TimerDue()
                {
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
                    ApplyAnimation(playerid, "PED", "WALK_CIVI", 4.1, true, true, true, true, 0, false);
                    InterpolateCameraPos(playerid, 2100.242675, -1779.497558, 15.979070, 2109.331542, -1790.645874, 14.679038, 4000);
                    InterpolateCameraLookAt(playerid, 2103.439697, -1783.191162, 14.913400, 2109.276855, -1785.655639, 14.370956, 4000);

                    inline const SecondTimerDue()
                    {
                        PlayerPlaySound(playerid, 5205, 0.0, 0.0, 0.0);
                        ClearAnimations(playerid);
                        TogglePlayerWidescreen(playerid, false);
                        Chat_Clear(playerid);
                        SetCameraBehindPlayer(playerid);
                        TogglePlayerControllable(playerid, true);
                        SetPlayerVirtualWorld(playerid, 0);
                        Streamer_Update(playerid);

                        Needs_ToggleBar(playerid, true);
                        Needs_StartUpdating(playerid);

                        Bit_Set(Player_Flags(playerid), PFLAG_IN_GAME, true);
                    }
                    PlayerTimer_Start(playerid, 4000, false, using inline SecondTimerDue);
                }
                PlayerTimer_Start(playerid, 7500, false, using inline TimerDue);
			}
			Account_Register(playerid, using inline OnRegister);
		}
		Transition_StartInline(using inline ScreenBlacked, playerid, 255, TRANSITION_IN);
	}

	return 1;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
	if(playertextid == p_tdRegisterAcc[playerid]{1})
	{
		inline Response(response, listitem, string:inputtext[])
		{
			#pragma unused response, listitem

			if(!isnull(inputtext))
			{
				new len = strlen(inputtext);
				if(len >= 32)
					return Dialog_ShowCallback(playerid, using inline Response, DIALOG_STYLE_INPUT, "Introduce tu {D2B567}contraseña", "{FFFFFF}Introduce tu contraseña. Debe medir {D2B567}menos de 32 caracteres{FFFFFF}.", "Listo", "");
			
				StrCpy(p_szPassword[playerid], inputtext);

				new tdstring[32];
				if(!g_rgbPasswordShown{playerid})
					MemSet(tdstring, 'X', len);
				else
					StrCpy(tdstring, inputtext);

				PlayerTextDrawSetString(playerid, p_tdRegisterAcc[playerid]{1}, tdstring);
				PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{1});
			}
			else
			{
				p_szPassword[playerid][0] = '\0';

				PlayerTextDrawSetString(playerid, p_tdRegisterAcc[playerid]{2}, Str_FixEncoding("Mostrar contraseña"));
				PlayerTextDrawSetString(playerid, p_tdRegisterAcc[playerid]{1}, Str_FixEncoding("Tu contraseña"));
				PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{2});
				PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{1});

				g_rgbPasswordShown{playerid} = false;
			}
		}
		Dialog_ShowCallback(playerid, using inline Response, DIALOG_STYLE_INPUT, "Introduce tu {D2B567}contraseña", "{FFFFFF}Introduce tu contraseña. Debe medir {D2B567}menos de 32 caracteres{FFFFFF}.", "Listo", "");
	}
	else if(playertextid == p_tdRegisterAcc[playerid]{2})
	{
		if(!isnull(p_szPassword[playerid]))
		{
			if(!g_rgbPasswordShown{playerid})
			{
				PlayerTextDrawSetString(playerid, p_tdRegisterAcc[playerid]{2}, Str_FixEncoding("Ocultar contraseña"));
				PlayerTextDrawSetString(playerid, p_tdRegisterAcc[playerid]{1}, p_szPassword[playerid]);
				PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{2});
				PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{1});

				g_rgbPasswordShown{playerid} = true;
			}
			else
			{
				PlayerTextDrawSetString(playerid, p_tdRegisterAcc[playerid]{2}, Str_FixEncoding("Mostrar contraseña"));

				new pwd[32];
				MemSet(pwd, 'X', strlen(p_szPassword[playerid]));

				PlayerTextDrawSetString(playerid, p_tdRegisterAcc[playerid]{1}, pwd);
				PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{2});
				PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{1});

				g_rgbPasswordShown{playerid} = false;
			}
		}
	}
	else if(playertextid == p_tdPlayerCustomization{playerid})
	{
		if(Bit_Get(Player_Flags(playerid), PFLAG_CUSTOMIZING_PLAYER))
		{
            // Due to some bug in YSI, I have to define playerid and dialogid here too...
			inline const Response(p, d, response, listitem, string:inputtext[])
			{
				#pragma unused p, d, response, listitem

				if(isnull(inputtext))
					return Dialog_ShowCallback(playerid, using inline Response, DIALOG_STYLE_INPUT, "Introduce tu {D2B567}edad", "{FFFFFF}Introduce tu edad y no dejes el campo vacío. Debe ser {D2B567}mayor a 18{FFFFFF} y {D2B567}menor a 100{FFFFFF}.", "Listo", "");

				new age = strval(inputtext);
				if(NOT_IN_RANGE(age, 18, 100))
				{
					return Dialog_ShowCallback(playerid, using inline Response, DIALOG_STYLE_INPUT, "Introduce tu {D2B567}edad", "{FFFFFF}Introduce una edad válida. Debe ser {D2B567}mayor a 18{FFFFFF} y {D2B567}menor a 100{FFFFFF}.", "Listo", "");
				}

				Player_Age(playerid) = age;
				Player_Skin(playerid) = Auth_AdjustSkinToRange(playerid, g_rgiSelectedSkin{playerid});
                SetPlayerSkin(playerid, Player_Skin(playerid));
                ApplyAnimation(playerid, "CRIB", "PED_CONSOLE_LOOP", 4.1, true, false, false, false, 0, false);

				new agestr[4];
				valstr(agestr, age);

				PlayerTextDrawSetString(playerid, p_tdPlayerCustomization{playerid}, agestr);
				PlayerTextDrawShow(playerid, p_tdPlayerCustomization{playerid});
			}
			Dialog_ShowCallback(playerid, using inline Response, DIALOG_STYLE_INPUT, "Introduce tu edad", "{FFFFFF}Introduce tu edad. Debe ser {D2B567}mayor a 18{FFFFFF} y {D2B567}menor a 100{FFFFFF}.", "Listo", "");
		}
	}

	return 1;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	// continue button
	if(clickedid == g_tdRegisterAcc[19])
	{
		CancelSelectTextDraw(playerid);

		if(!Bit_Get(Player_Flags(playerid), PFLAG_REGISTERED))
		{
			if(isnull(p_szPassword[playerid]))
			{
				SelectTextDraw(playerid, 0xD2B567FF);
				Dialog_Show(playerid, DIALOG_STYLE_MSGBOX, "{D2B567}Error", "{3E3D53}- {FFFFFF}Introduce una {D2B567}contraseña válida {FFFFFF}para continuar.", "Entendido", "");
                return 1;
            }

			Bit_Set(Player_Flags(playerid), PFLAG_CUSTOMIZING_PLAYER, true);
            
			inline const ScreenBlacked()
			{                
				Transition_Pause(playerid);
				Auth_ToggleTextdraws(playerid, false);

				Player_Sex(playerid) = random(1);
				Player_Age(playerid) = Random(18, 100);

				g_rgiSelectedSkin{playerid} = (random(4) + 1) + (5 * Player_Sex(playerid));

				Player_Skin(playerid) = Auth_AdjustSkinToRange(playerid, g_rgiSelectedSkin{playerid});

                SetSpawnInfo(playerid, NO_TEAM, Player_Skin(playerid), 448.8462, 508.5697, 1001.4195, 284.2451, 0, 0, 0, 0, 0, 0);
                TogglePlayerSpectating(playerid, false);
                TogglePlayerWidescreen(playerid, true);
                Chat_Clear(playerid);
                SetPlayerInterior(playerid, 12);
				SetPlayerVirtualWorld(playerid, VW_PLAYER + playerid);
				SetPlayerCameraPos(playerid, 449.177429, 510.692901, 1001.518493);
				SetPlayerCameraLookAt(playerid, 447.455413, 506.018188, 1001.092041);
                ApplyAnimation(playerid, "CRIB", "PED_CONSOLE_LOOP", 4.1, true, false, false, false, 0, false);
                SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
                SetPlayerAttachedObject(playerid, INTRO_PROP_OBJECT_INDEX, 18875, 6, 0.15, 0.15, 0.0, 0.0, 0.0, -110.59, 1.0, 1.0, 1.0);

				for(new i = (sizeof(g_tdPlayerCustomization) - 1); i != -1; --i)
				{
					TextDrawShowForPlayer(playerid, g_tdPlayerCustomization[i]);
				}

				new age[4 char];
				valstr(age, Player_Age(playerid), true);

				PlayerTextDrawSetString(playerid, p_tdPlayerCustomization{playerid}, age);
				PlayerTextDrawShow(playerid, p_tdPlayerCustomization{playerid});

				Transition_Resume(playerid);

				SelectTextDraw(playerid, 0xD2B567FF);
			}
			Transition_StartInline(using inline ScreenBlacked, playerid, 255, TRANSITION_IN);
		}
		else
		{
			if(isnull(p_szPassword[playerid]))
			{
				SelectTextDraw(playerid, 0xD2B567FF);
				return Dialog_Show(playerid, DIALOG_STYLE_MSGBOX, "{D2B567}Error", "{3E3D53}- {FFFFFF}Introduce la {D2B567}contraseña {FFFFFF}de tu cuenta para continuar.", "Entendido", "");
			}

			inline const CheckResult(bool:result)
			{
				if(!result)
				{
					SelectTextDraw(playerid, 0xD2B567FF);
					return Dialog_Show(playerid, DIALOG_STYLE_MSGBOX, "{D2B567}Error", "{3E3D53}- {FFFFFF}La {D2B567}contraseña {FFFFFF}es incorrecta.", "Entendido", "");
				}

                Player_LoadData(playerid);
                cache_delete(g_rgePlayerData[playerid][e_pDataCache]);
                g_rgePlayerData[playerid][e_pDataCache] = MYSQL_INVALID_CACHE;

				Bit_Set(Player_Flags(playerid), PFLAG_AUTHENTICATING, false);
				MemSet(p_szPassword[playerid], '\0');

				inline const ScreenBlacked()
				{
					Auth_ToggleTextdraws(playerid, false);

					new Float:x, Float:y, Float:z, Float:angle;
					Player_GetSpawnPos(playerid, x, y, z, angle);

					SetSpawnInfo(playerid, NO_TEAM, Player_Skin(playerid), x, y, z, angle, 0, 0, 0, 0, 0, 0);
					TogglePlayerSpectating(playerid, false);

					SetPlayerVirtualWorld(playerid, Player_VirtualWorld(playerid));
					SetPlayerInterior(playerid, Player_Interior(playerid));
					SetPlayerHealth(playerid, Player_Health(playerid));
					SetPlayerArmour(playerid, Player_Armour(playerid));
					GivePlayerMoney(playerid, Player_Money(playerid));
                    Player_GiveAllWeapons(playerid);

					SetCameraBehindPlayer(playerid);

					Iter_Add(LoggedIn, playerid);

					if(Player_Rank(playerid))
						Iter_Add(Admins, playerid);

		            Notification_Show(playerid, @f("Bienvenido a The Hood, %s. Tu última conexión fue el ~y~%s~w~.", Player_GetName(playerid), Player_GetLastConnection(playerid)));
				
                    Needs_ToggleBar(playerid, true);
                    Needs_StartUpdating(playerid);

                    mysql_tquery(g_hDatabase, va_return("UPDATE `PLAYERS` SET `CURRENT_CONNECTION` = UNIX_TIMESTAMP() WHERE `ID` = %d LIMIT 1;", Player_AccountID(playerid)));
                    Account_RegisterConnection(playerid);
                    
                    Bit_Set(Player_Flags(playerid), PFLAG_IN_GAME, true);
                }
				Transition_StartInline(using inline ScreenBlacked, playerid, 255, TRANSITION_IN);
			}
			BCrypt_CheckInline(p_szPassword[playerid], p_szPasswordHash[playerid], using inline CheckResult);
		}
		
		return 1;
	}
	// MALE BUTTON
	else if(clickedid == g_tdPlayerCustomization[11])
	{
		if(Bit_Get(Player_Flags(playerid), PFLAG_CUSTOMIZING_PLAYER))
		{
			if(Player_Sex(playerid) == PLAYER_SEX_MALE)
				return 1;

			Player_Sex(playerid) = PLAYER_SEX_MALE;
            g_rgiSelectedSkin{playerid} -= 5;
			Player_Skin(playerid) = Auth_AdjustSkinToRange(playerid, g_rgiSelectedSkin{playerid});

            SetPlayerSkin(playerid, Player_Skin(playerid));
            ApplyAnimation(playerid, "CRIB", "PED_CONSOLE_LOOP", 4.1, true, false, false, false, 0, false);
		}

		return 1;
	}
	// FEMALE BUTTON
	else if(clickedid == g_tdPlayerCustomization[12])
	{
		if(Bit_Get(Player_Flags(playerid), PFLAG_CUSTOMIZING_PLAYER))
		{
			if(Player_Sex(playerid) == PLAYER_SEX_FEMALE)
				return 1;

			Player_Sex(playerid) = PLAYER_SEX_FEMALE;
			g_rgiSelectedSkin{playerid} += 5;
            Player_Skin(playerid) = Auth_AdjustSkinToRange(playerid, g_rgiSelectedSkin{playerid});

			SetPlayerSkin(playerid, Player_Skin(playerid));
            ApplyAnimation(playerid, "CRIB", "PED_CONSOLE_LOOP", 4.1, true, false, false, false, 0, false);
		}

		return 1;
	}
	// LEFT BUTTON
	else if(clickedid == g_tdPlayerCustomization[18])
	{
		new skin = g_rgiSelectedSkin{playerid} - (5 * Player_Sex(playerid));

		if(1 <= skin <= 5)
		{
			Player_Skin(playerid) = Auth_AdjustSkinToRange(playerid, --g_rgiSelectedSkin{playerid});
            SetPlayerSkin(playerid, Player_Skin(playerid));
            ApplyAnimation(playerid, "CRIB", "PED_CONSOLE_LOOP", 4.1, true, false, false, false, 0, false);
		}
	}
	// RIGHT BUTTON
	else if(clickedid == g_tdPlayerCustomization[19])
	{
		new skin = g_rgiSelectedSkin{playerid} - (5 * Player_Sex(playerid));

		if(1 <= skin <= 5)
		{
			Player_Skin(playerid) = Auth_AdjustSkinToRange(playerid, ++g_rgiSelectedSkin{playerid});
            SetPlayerSkin(playerid, Player_Skin(playerid));
            ApplyAnimation(playerid, "CRIB", "PED_CONSOLE_LOOP", 4.1, true, false, false, false, 0, false);
		}
	}

	return 1;
}