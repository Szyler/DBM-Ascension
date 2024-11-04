local mod	= DBM:NewMod("Rethilgore", "DBM-Party-Vanilla", 14)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(3914)

mod:RegisterCombat("combat")
