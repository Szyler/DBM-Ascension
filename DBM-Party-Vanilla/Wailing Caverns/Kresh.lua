local mod	= DBM:NewMod(477, "DBM-Party-Vanilla", 19, 240)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(3653)
mod:SetEncounterID(587)

mod:RegisterCombat("combat")
