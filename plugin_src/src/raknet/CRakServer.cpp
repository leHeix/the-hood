#include "../main.hpp"

namespace net
{
	urmem::hook CRakServer::m_hkGetPacketID;

	CRakServer::CRakServer(void** plugin_data)
	{
		urmem::address_t addr;
		urmem::sig_scanner scanner;

		if (!scanner.init(reinterpret_cast<urmem::address_t>(*plugin_data)))
		{
			sampgdk::logprintf("RakNet: Scanner initialization failed.");
			return;
		}

		m_pRakServer = reinterpret_cast<int(*)(void)>(plugin_data[PLUGIN_DATA_RAKSERVER])();
		const auto vmt = urmem::pointer(m_pRakServer).field<urmem::address_t*>(0);

#ifdef _WIN32
		m_pfnSend = vmt[7];
		m_pfnGetPlayerIdFromIndex = vmt[58];

		if (!scanner.find("\x8B\x44\x24\x04\x85\xC0\x75\x03\x0C\xFF\xC3", "xxxxxxx???x", addr) || !addr)
#else
		m_pfnSend = vmt[9];
		m_pfnGetPlayerIdFromIndex = vmt[59];

		if (!scanner.find("\x55\xB8\x00\x00\x00\x00\x89\xE5\x8B\x55\x00\x85\xD2", "xx????xxxx?xx", addr) || !addr)
#endif
		{
			sampgdk::logprintf("RakNet: GetPacketID not found.");
			return;
		}

		m_hkGetPacketID.install(addr, urmem::get_func_addr(&GetPacketID));
	}

	uint8_t CRakServer::GetPacketID(Packet* packet)
	{
		if (!packet || !packet->data || packet->length == 0)
			return 0xFF;

		int packet_id = packet->data[0];

		if (packet_id < 0 || packet_id > 255)
			return 0xFF;

		uint16_t packetid;

		std::unique_ptr<BitStream> bs = std::make_unique<BitStream>(&packet->data[0], (packet->length - 1), false);
		bs->Read<uint16_t>(packetid);

		switch (packetid)
		{
			case ID_PLAYER_SYNC:
			{
				if (packet->length != sizeof(stOnFootSyncData) + 1)
					return 0xFF;

				stOnFootSyncData* data = reinterpret_cast<stOnFootSyncData*>(&packet->data[1]);
				unsigned char weaponslot = CPlayer::stWeaponData::GetSlot(data->byteCurrentWeapon);
				CPlayer::stWeaponData& weapon = hood::players[packet->playerIndex]->Weapons()[weaponslot];

				if (!weapon.valid || weapon.weaponId != data->byteCurrentWeapon || !weapon.usable)
					return 0xFF;
			}
		}

		return m_hkGetPacketID.call<urmem::calling_convention::cdeclcall, uint8_t>(packet);
	}

	PlayerID CRakServer::GetPlayerIDFromIndex(int index) const
	{
		return urmem::call_function<urmem::calling_convention::thiscall, PlayerID>(m_pfnGetPlayerIdFromIndex, m_pRakServer, index);
	}

	bool CRakServer::Send(BitStream* bs, int index, PacketPriority priority, PacketReliability reliability) const
	{
		if (index == -1)
		{
			return urmem::call_function<urmem::calling_convention::thiscall, bool>(m_pfnSend, m_pRakServer, bs, priority, reliability, 0, UNASSIGNED_PLAYER_ID, true);
		}
		return urmem::call_function<urmem::calling_convention::thiscall, bool>(m_pfnSend, m_pRakServer, bs, priority, reliability, 0, GetPlayerIDFromIndex(index), 0);
	}

	bool CRakServer::Send(BitStream* bs, PlayerID playerid, PacketPriority priority, PacketReliability reliability) const
	{
		return urmem::call_function<urmem::calling_convention::thiscall, bool>(m_pfnSend, m_pRakServer, bs, priority, reliability, 0, playerid, (playerid == UNASSIGNED_PLAYER_ID));
	}
};