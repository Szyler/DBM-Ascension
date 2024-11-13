local mod	= DBM:NewMod("OdotheBlindwatcher", "DBM-Party-Vanilla", 14)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(4279)

mod:RegisterCombat("combat")
