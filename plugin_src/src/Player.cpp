#include "main.hpp"

std::unordered_map<unsigned short, std::unique_ptr<CPlayer>> hood::players;

CPlayer::CPlayer(unsigned short id) : _id(id)
{

}