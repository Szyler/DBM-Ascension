local mod	= DBM:NewMod("CommanderSpringvale", "DBM-Party-Vanilla", 14)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(4278)

mod:RegisterCombat("combat")
