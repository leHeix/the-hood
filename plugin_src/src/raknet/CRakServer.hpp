#pragma once

namespace net
{
    class CRakServer
    {
    private:
        urmem::address_t m_pRakServer, m_pfnSend, m_pfnGetPlayerIdFromIndex;
        static urmem::hook m_hkGetPacketID;

    public:
        CRakServer(void** plugin_data);

        PlayerID GetPlayerIDFromIndex(int index) const;
        static uint8_t GetPacketID(Packet* packet);

        bool Send(BitStream* bs, int index = -1, PacketPriority priority = LOW_PRIORITY, PacketReliability reliability = RELIABLE) const;
        bool Send(BitStream* bs, PlayerID playerid = UNASSIGNED_PLAYER_ID, PacketPriority priority = LOW_PRIORITY, PacketReliability reliability = RELIABLE) const;
    };
};