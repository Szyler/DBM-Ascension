local mod	= DBM:NewMod("Oggleflint", "DBM-Party-Vanilla", 9)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(11517)

mod:RegisterCombat("combat")
