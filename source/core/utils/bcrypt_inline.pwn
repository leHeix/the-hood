#if defined _INLINE_BCRYPT_
    #endinput
#endif
#define _INLINE_BCRYPT_

forward mz_InlineBcryptHash(Func:cb<s>);
forward mz_InlineBcryptCheck(Func:cb<i>);

public mz_InlineBcryptHash(Func:cb<s>)
{
    new hash[61];
    bcrypt_get_hash(hash);
    @.cb(hash);
    Indirect_Release(cb);
    return 0;
}

public mz_InlineBcryptCheck(Func:cb<i>)
{
    @.cb(bcrypt_is_equal());
    Indirect_Release(cb);
    return 0;
}

stock BCrypt_HashInline(const text[], cost = 12, Func:cb<s>)
{
    new ret = bcrypt_hash(text, cost, !"mz_InlineBcryptHash", !"i", _:cb);
    if(ret)
    {
        Indirect_Claim(cb);
    }
    return ret;
}

stock BCrypt_CheckInline(const text[], const hash[], Func:cb<i>)
{
    new ret = bcrypt_check(text, hash, !"mz_InlineBcryptCheck", !"i", _:cb);
    if(ret)
    {
        Indirect_Claim(cb);
    }
    return ret;
}