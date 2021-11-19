#if defined _INLINE_OBJECTS_
    #endinput
#endif
#define _INLINE_OBJECTS_

#include <YSI_Coding\y_hooks>

static stock
    SparseArray:s_PlayerObjects<>;

stock cb_MovePlayerObject({F@_@ii, F@_@}:onMoved, playerid, objectid, Float:x, Float:y, Float:z, Float:speed, Float:rx = -1000.0, Float:ry = -1000.0, Float:rz = -1000.0, tag = tagof(onMoved))
{
    new Func:cb<i>;
    if(Sparse_Exchange(s_PlayerObjects, objectid, _:cb, _:onMoved))
        Indirect_Release(cb);

    Indirect_Claim(onMoved);
    Indirect_SetMeta(onMoved, tag);

    return MovePlayerObject(playerid, objectid, x, y, z, speed, rx, ry, rz);
}

hook OnPlayerObjectMoved(playerid, objectid)
{
    new cb;
    if(Sparse_Exchange(s_PlayerObjects, _:objectid, _:cb))
    {
        new tag = Indirect_GetMeta(cb);
        if(tag == _:tagof(F@_@ii:))
        {
            @.cb(playerid, objectid);
        }
        else
        {
            @.cb();
        }

        Indirect_Release(cb);
    }

    return 1;
}