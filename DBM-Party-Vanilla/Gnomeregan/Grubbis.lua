local mod	= DBM:NewMod(419, "DBM-Party-Vanilla", 7, 231)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7361)
mod:SetEncounterID(379)

mod:RegisterCombat("combat")
