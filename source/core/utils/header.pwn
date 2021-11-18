#if defined _H_CORE_UTILS_
    #endinput
#endif
#define _H_CORE_UTILS_

enum {
	VW_PLAYER = 1
};

native PlayerTextDrawSetString_s(playerid, PlayerText:text, ConstAmxString:string) = PlayerTextDrawSetString;

#define @f str_format