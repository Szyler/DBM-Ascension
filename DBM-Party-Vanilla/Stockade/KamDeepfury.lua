local mod	= DBM:NewMod("KamDeepfury", "DBM-Party-Vanilla", 15)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(1666)

mod:RegisterCombat("combat")
