#pragma once

constexpr auto MAX_WEAPON_SLOTS = 13;

class CPlayer
{
public:
	struct stWeaponData
	{
		bool valid{ false };
		unsigned char weaponId;
		unsigned short ammo;
		bool usable{ true };

		inline cell ToCell() { return (ammo << 8) | weaponId; }

		static constexpr unsigned char GetSlot(unsigned char weaponid)
		{
			constexpr unsigned char WeaponSlots[] = {
				0, 0,
				1, 1, 1, 1, 1, 1, 1, 1,
				10, 10, 10, 10, 10, 10,
				8, 8, 8,
				0xFF, 0xFF, 0xFF,
				2, 2, 2,
				3, 3, 3,
				4, 4,
				5, 5,
				4,
				6, 6,
				7, 7, 7, 7,
				8,
				12,
				9, 9, 9,
				11, 11, 11
			};

			return WeaponSlots[weaponid];
		}
	};

private:
	unsigned short _id;
	std::array<stWeaponData, MAX_WEAPON_SLOTS> _weapons{};

public:
	explicit CPlayer(unsigned short id);

	inline unsigned short Id() const { return _id; }
	inline auto& Weapons() { return _weapons; }
	inline const auto& Weapons() const { return _weapons; }
};

namespace hood
{
	extern std::unordered_map<unsigned short, std::unique_ptr<CPlayer>> players;
}