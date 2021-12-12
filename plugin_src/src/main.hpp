#pragma once

//
// STL
#include "pch.h"

//
// Libraries
#include <urmem/urmem.hpp>
#include <raknet/RakNet.h>
#include <raknet/BitStream.h>
#include <samp-gdk/sampgdk.h>
#include <samp-sdk/plugincommon.h>
#include <samp-sdk/amx/amx.h>
#include <samp-sdk/amx/amx2.h>

//
// The Hood
#include "raknet/RakUtil.hpp"
#include "raknet/CRakServer.hpp"
#include "natives/Natives.hpp"
#include "Player.hpp"

namespace hood {
	extern void** plugin_data;
	extern AMX* main_amx;
	extern std::unique_ptr<net::CRakServer> RakServer;
}