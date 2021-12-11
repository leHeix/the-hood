#if defined _H_ACCOUNT_
    #endinput
#endif
#define _H_ACCOUNT_

#define PLAYER_STARTING_MONEY (250)

enum {
	PLAYER_SEX_MALE = 0,
	PLAYER_SEX_FEMALE = 1
};

enum {
	RANK_LEVEL_USER = 0,
	RANK_LEVEL_ASSISTANT,
	RANK_LEVEL_MODERATOR,
	RANK_LEVEL_GAME_OPERATOR,
	RANK_LEVEL_ADMIN,
	RANK_LEVEL_MONG,
	RANK_LEVEL_OWNER = RANK_LEVEL_MONG
};

enum ePlayerData {
    Cache:e_pDataCache,
	e_iAccountId,
	e_szPlayerName[MAX_PLAYER_NAME],
	e_szPlayerFixedName[MAX_PLAYER_NAME],
	e_iPlayerIp,
	e_szPlayerLastConnection[20],
	Float:e_fPlayerHealth,
	Float:e_fPlayerArmor,
	e_iPlayerMoney,
	Float:e_fSpawnPosX,
	Float:e_fSpawnPosY,
	Float:e_fSpawnPosZ,
	Float:e_fSpawnPosAngle,
	e_iPlayerVirtualWorld,
	e_iPlayerInterior,
	e_iPlayerSex,
	e_iPlayerAge,
	e_iPlayerSkin,
	Float:e_fPlayerHunger,
	Float:e_fPlayerThirst,

	e_iRankLevel,
	e_iPlayedTime,
    e_iPlayerSettings,

	/* MISC DATA, PROBABLY NOT SAVED IN THE DABATASE */
	e_iCurrentConnectionTime, 
	e_iPlayerPausedBegin,
	e_iPlayerPausedTime,

    e_iPlayerEatCount,
    e_iPlayerPukeTick,
    Float:e_fPlayerThirstPerDrink,
    e_iPlayerDrinkClickedRemaining
};

enum {
	PFLAG_AUTHENTICATING = 0,
    PFLAG_IN_GAME,
	PFLAG_REGISTERED,
	PFLAG_CUSTOMIZING_PLAYER,
	PFLAG_INTRODUCTION_RUNNING,
    PFLAG_USING_SHOP,
    PFLAG_CAN_USE_SHOP_BUTTONS,
    PFLAG_IS_PUKING,
    PFLAG_ON_AUTO_DEALERSHIP,
    PFLAG_HAS_DRINK_ON_HANDS,
    PFLAG_CHUFFING_A_FAT_DART,

	MAX_PLAYER_FLAGS
};

new
	p_szPassword[MAX_PLAYERS][32],
	p_szPasswordHash[MAX_PLAYERS][61],
	g_rgePlayerData[MAX_PLAYERS + 1][ePlayerData],
	BitArray:g_rgiPlayerFlags[MAX_PLAYERS]<MAX_PLAYER_FLAGS>,
	Iterator:Admins<MAX_PLAYERS>,
	Iterator:LoggedIn<MAX_PLAYERS>;

// "functions"
#define Player_Flags(%0) Bit:(g_rgiPlayerFlags[(%0)])
#define Player_AccountID(%0) (g_rgePlayerData[(%0)][e_iAccountId])
#define Player_GetName(%0) (g_rgePlayerData[(%0)][e_szPlayerName])
#define Player_RPName(%0) (g_rgePlayerData[(%0)][e_szPlayerFixedName])
#define Player_GetIp(%0) (g_rgePlayerData[(%0)][e_iPlayerIp])
#define Player_GetIpString(%0) (RawIpToString(g_rgePlayerData[(%0)][e_iPlayerIp]))
#define Player_GetLastConnection(%0) (g_rgePlayerData[(%0)][e_szPlayerLastConnection])
#define Player_Health(%0) (g_rgePlayerData[(%0)][e_fPlayerHealth])
#define Player_Armor(%0) (g_rgePlayerData[(%0)][e_fPlayerArmor])
#define Player_Armour Player_Armor
#define Player_Money(%0) (g_rgePlayerData[(%0)][e_iPlayerMoney])
#define Player_VirtualWorld(%0) (g_rgePlayerData[(%0)][e_iPlayerVirtualWorld])
#define Player_Interior(%0) (g_rgePlayerData[(%0)][e_iPlayerInterior])
#define Player_Sex(%0) (g_rgePlayerData[(%0)][e_iPlayerSex])
#define Player_Age(%0) (g_rgePlayerData[(%0)][e_iPlayerAge])
#define Player_Skin(%0) (g_rgePlayerData[(%0)][e_iPlayerSkin])
#define Player_Hunger(%0) (g_rgePlayerData[(%0)][e_fPlayerHunger])
#define Player_Thirst(%0) (g_rgePlayerData[(%0)][e_fPlayerThirst])
#define Player_Rank(%0) (g_rgePlayerData[(%0)][e_iRankLevel])
#define Player_PlayedTime(%0) (g_rgePlayerData[(%0)][e_iPlayedTime])
#define Player_PlayedLocalTime(%0) ((gettime() - g_rgePlayerData[(%0)][e_iCurrentConnectionTime]) + g_rgePlayerData[(%0)][e_iPlayedTime] - g_rgePlayerData[(%0)][e_iPlayerPausedTime])
#define Player_Settings(%0) (g_rgePlayerData[(%0)][e_iPlayerSettings])
#define Player_Data(%0,%1) (g_rgePlayerData[(%0)][(%1)])

forward OnPlayerDataFetched(playerid);
forward OnPlayerDataLoaded(playerid);