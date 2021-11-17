#if defined _FUNCTIONS_AUTH_
    #endinput
#endif
#define _FUNCTIONS_AUTH_

Auth_ToggleTextdraws(playerid, bool:show)
{
	if(show)
	{
		for (new i = (sizeof(g_tdRegisterAcc) - 2); i != -1; --i)
		{
			TextDrawShowForPlayer(playerid, g_tdRegisterAcc[i]);
		}

		PlayerTextDrawSetString(playerid, p_tdRegisterAcc[playerid]{0}, Str_FixEncoding(Player_GetName(playerid)));
		PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{0});
		PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{1});
		PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{2});
		PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{3});
		PlayerTextDrawShow(playerid, p_tdRegisterAcc[playerid]{4});

		SelectTextDraw(playerid, 0xD2B567FF);
	}
	else
	{
		for (new i = (sizeof(g_tdRegisterAcc) - 1); i != -1; --i)
		{
			TextDrawHideForPlayer(playerid, g_tdRegisterAcc[i]);
		}

		PlayerTextDrawHide(playerid, p_tdRegisterAcc[playerid]{0});
		PlayerTextDrawHide(playerid, p_tdRegisterAcc[playerid]{1});
		PlayerTextDrawHide(playerid, p_tdRegisterAcc[playerid]{2});
		PlayerTextDrawHide(playerid, p_tdRegisterAcc[playerid]{3});
		PlayerTextDrawHide(playerid, p_tdRegisterAcc[playerid]{4});

		CancelSelectTextDraw(playerid);
	}

	return 1;
}

Auth_AdjustSkinToRange(playerid, skin)
{
	assert skin >= 1 && skin <= 10;

	new age = Player_Age(playerid);

	if(IS_IN_RANGE(age, 35, 60))
	{
		skin += 10;
	}
	else if(IS_IN_RANGE(age, 61, 100))
	{
		skin += 20;
	}

	return g_rgiIntroSkins[skin];
}