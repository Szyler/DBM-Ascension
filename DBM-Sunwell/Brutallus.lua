local mod	= DBM:NewMod("Brutallus", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(24882)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7)

mod:RegisterCombat("combat")
mod:RegisterCombat("yell", L.Pull)

mod.disableHealthCombat = true


mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"UNIT_DIED"
)


local berserkTimer		= mod:NewBerserkTimer(360)


function mod:OnCombatStart(delay)
	self.vb.phase = 1
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_APPLIED(args)
end

function mod:SPELL_AURA_REMOVED(args)
end

function mod:SPELL_CAST_START(args)
end

function mod:UNIT_DIED(args)
end

function mod:OnCombatEnd()
end