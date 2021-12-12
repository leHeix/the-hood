Account_RegisterConnection(playerid)
{
    mysql_format(g_hDatabase, YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH, "INSERT INTO `CONNECTION_LOGS` (ACCOUNT_ID, IP_ADDRESS) VALUES (%i, '%e');", Player_AccountID(playerid), RawIpToString(Player_GetIp(playerid)));
	return mysql_tquery(g_hDatabase, YSI_UNSAFE_HUGE_STRING);
}

Account_Register(playerid, Func:cb<> = F@_@:0)
{
	assert Bit_Get(Player_Flags(playerid), PFLAG_REGISTERED) == false;
	assert Player_AccountID(playerid) == 0;
	assert !isnull(p_szPassword[playerid]);

	if(_:cb != 0)
		Indirect_Claim(cb);

	inline const HashDone(string:hash[])
	{
		MemSet(p_szPassword[playerid], '\0');
		StrCpy(p_szPasswordHash[playerid], hash);

		inline const QueryDone()
		{
			Player_AccountID(playerid) = cache_insert_id();
			Account_RegisterConnection(playerid);

			if(_:cb != 0)
			{
				@.cb();
				Indirect_Release(cb);
			}
		}
        
		MySQL_TQueryInline(g_hDatabase, using inline QueryDone, "\
			INSERT INTO PLAYERS \
				(NAME, PASSWORD, SEX, AGE, POS_X, POS_Y, POS_Z, ANGLE, VW, INTERIOR, SKIN, CURRENT_CONNECTION, MONEY) \
			VALUES \
				('%e', '%e', %i, %i, %.2f, %.2f, %.2f, %.2f, %i, %i, %i, UNIX_TIMESTAMP(), %i);\
		",
			Player_GetName(playerid), p_szPasswordHash[playerid],
			Player_Sex(playerid), Player_Age(playerid),
			2110.2029, -1784.2820, 13.3874, 350.1182,
			0, 0, 
			Player_Skin(playerid),
			PLAYER_STARTING_MONEY
		);
	}
	BCrypt_HashInline(p_szPassword[playerid], 12, using inline HashDone);

	return 1;
}

Account_Save(playerid)
{
	if(!Player_AccountID(playerid))
		return 0;

    if(!Bit_Get(Player_Flags(playerid), PFLAG_IN_GAME))
        return 0;

	if(IsPlayerSpawned(playerid))
	{
		GetPlayerPos(playerid, g_rgePlayerData[playerid][e_fSpawnPosX], g_rgePlayerData[playerid][e_fSpawnPosY], g_rgePlayerData[playerid][e_fSpawnPosZ]);
		GetPlayerFacingAngle(playerid, g_rgePlayerData[playerid][e_fSpawnPosAngle]);
        g_rgePlayerData[playerid][e_iPlayerVirtualWorld] = GetPlayerVirtualWorld(playerid);
        g_rgePlayerData[playerid][e_iPlayerInterior] = GetPlayerInterior(playerid);
	}

	mysql_format(g_hDatabase, YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH, "\
			UPDATE `PLAYERS` SET \
				`PLAYED_TIME` = (`PLAYED_TIME` + (UNIX_TIMESTAMP() - `CURRENT_CONNECTION`)) - %i, \
				`LAST_CONNECTION` = CURRENT_TIMESTAMP(), \
				`POS_X` = %.2f, \
				`POS_Y` = %.2f, \
				`POS_Z` = %.2f, \
				`ANGLE` = %.2f, \
				`VW` = %i, \
				`INTERIOR` = %i, \
				`HUNGER` = %.2f, \
				`THIRST` = %.2f, \
				`SKIN` = %i, \
				`CURRENT_CONNECTION` = 0 \
			WHERE `ID` = %i;\
		",
		g_rgePlayerData[playerid][e_iPlayerPausedTime],
		g_rgePlayerData[playerid][e_fSpawnPosX], g_rgePlayerData[playerid][e_fSpawnPosY], g_rgePlayerData[playerid][e_fSpawnPosZ], g_rgePlayerData[playerid][e_fSpawnPosAngle], Player_VirtualWorld(playerid), Player_Interior(playerid),
		Player_Hunger(playerid), Player_Thirst(playerid),
		Player_Skin(playerid),
		Player_AccountID(playerid)
	);
    mysql_tquery(g_hDatabase, YSI_UNSAFE_HUGE_STRING);

	return 1;
}

Player_GetSpawnPos(playerid, &Float:x, &Float:y, &Float:z, &Float:angle)
{
	x = g_rgePlayerData[playerid][e_fSpawnPosX];
	y = g_rgePlayerData[playerid][e_fSpawnPosY];
	z = g_rgePlayerData[playerid][e_fSpawnPosZ];
	angle = g_rgePlayerData[playerid][e_fSpawnPosAngle];
	return 1;
}

Player_GiveMoney(playerid, money, bool:update = false)
{
    Player_Money(playerid) += money;

	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, Player_Money(playerid));

	if(update)
	{
        mysql_format(g_hDatabase, YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH, "UPDATE `PLAYERS` SET `MONEY` = %i WHERE `ID` = %i;", Player_Money(playerid), Player_AccountID(playerid));
		mysql_tquery(g_hDatabase, YSI_UNSAFE_HUGE_STRING);
	}

	return 1;
}

Player_SetMoney(playerid, money, bool:give = false, bool:update = false)
{
    Player_Money(playerid) = money;

	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, money);

	if(update)
	{
        mysql_format(g_hDatabase, YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH, "UPDATE `PLAYERS` SET `MONEY` = %i WHERE `ID` = %i;", Player_Money(playerid), Player_AccountID(playerid));
		mysql_tquery(g_hDatabase, YSI_UNSAFE_HUGE_STRING);
	}

	return 1;
}

Player_LoadData(playerid)
{
    if(g_rgePlayerData[playerid][e_pDataCache] == MYSQL_INVALID_CACHE)
        return 0;

    cache_set_active(g_rgePlayerData[playerid][e_pDataCache]);

    cache_get_value_name_int(0, !"ID", Player_AccountID(playerid));
    cache_get_value_name(0, !"PASSWORD", p_szPasswordHash[playerid]);
    cache_get_value_name_int(0, !"SEX", Player_Sex(playerid));
    cache_get_value_name_int(0, !"AGE", Player_Age(playerid));
    cache_get_value_name_int(0, !"MONEY", Player_Money(playerid));
    cache_get_value_name_float(0, !"HEALTH", Player_Health(playerid));
    cache_get_value_name_float(0, !"ARMOUR", Player_Armour(playerid));
    cache_get_value_name_float(0, !"POS_X", g_rgePlayerData[playerid][e_fSpawnPosX]);
    cache_get_value_name_float(0, !"POS_Y", g_rgePlayerData[playerid][e_fSpawnPosY]);
    cache_get_value_name_float(0, !"POS_Z", g_rgePlayerData[playerid][e_fSpawnPosZ]);
    cache_get_value_name_float(0, !"ANGLE", g_rgePlayerData[playerid][e_fSpawnPosAngle]);
    cache_get_value_name_int(0, !"VW", Player_VirtualWorld(playerid));
    cache_get_value_name_int(0, !"INTERIOR", Player_Interior(playerid));
    cache_get_value_name(0, !"LAST_CONNECTION", Player_GetLastConnection(playerid));
    cache_get_value_name_int(0, !"SKIN", Player_Skin(playerid));
    cache_get_value_name_float(0, !"HUNGER", Player_Hunger(playerid));
    cache_get_value_name_float(0, !"THIRST", Player_Thirst(playerid));
    cache_get_value_name_int(0, !"ADMIN", Player_Rank(playerid));
    cache_get_value_name_int(0, !"PLAYED_TIME", Player_PlayedTime(playerid));
    cache_get_value_name_int(0, !"SETTINGS", g_rgePlayerData[playerid][e_iPlayerSettings]);
    cache_get_value_name_int(0, !"PHONE_NUMBER", Player_PhoneNumber(playerid));

    g_rgePlayerData[playerid][e_iCurrentConnectionTime] = gettime();

    for(new i = 1; i < MAX_WEAPON_SLOTS; ++i)
    {
        new weapon_and_ammo;
        cache_get_value_name_int(0, va_return("SLOT_%d", i), weapon_and_ammo);
        if(weapon_and_ammo)
        {
            Player_GiveWeapon(playerid, (weapon_and_ammo & 0xFF), (weapon_and_ammo << 8), false);
        }
    }
    
    cache_unset_active();

    return 1;
}
