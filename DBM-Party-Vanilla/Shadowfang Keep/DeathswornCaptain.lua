local mod	= DBM:NewMod("DeathswornCaptain", "DBM-Party-Vanilla", 14)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(3872)

mod:RegisterCombat("combat")
