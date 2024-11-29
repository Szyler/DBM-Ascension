local mod	= DBM:NewMod("The Witch's Brew", "DBM-Party-Manastorm", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5022 $"):sub(12, -3))
mod:SetCreatureID(0000)
mod:RegisterCombat("combat")

mod:RegisterEvents(
    "PLAYER_ALIVE"
)
