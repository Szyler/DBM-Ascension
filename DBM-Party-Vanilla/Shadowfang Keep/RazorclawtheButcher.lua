local mod	= DBM:NewMod("RazorclawtheButcher", "DBM-Party-Vanilla", 14)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(3886)

mod:RegisterCombat("combat")
