local mod	= DBM:NewMod("Brutallus", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(24882)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterCombat("yell", L.Pull)
mod.disableHealthCombat = true

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_MONSTER_YELL",
    "CHAT_MSG_MONSTER_EMOTE",
    "CHAT_MSG_RAID_BOSS_EMOTE",
    "CHAT_MSG_MONSTER_SAY",
    "CHAT_MSG_RAID_WARNING",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"UNIT_DIED"
)


local berserkTimer		= mod:NewBerserkTimer(360)


function mod:OnCombatStart(delay)
	self.vb.phase = 1
end



function mod:SPELL_AURA_APPLIED(args)

end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)

end

function mod:SPELL_CAST_START(args)

end

function mod:UNIT_DIED(args)

end



function mod:CHAT_MSG_MONSTER_EMOTE(msg)

end
mod.CHAT_MSG_MONSTER_YELL = mod.CHAT_MSG_MONSTER_EMOTE
mod.CHAT_MSG_RAID_BOSS_EMOTE = mod.CHAT_MSG_MONSTER_EMOTE
mod.CHAT_MSG_MONSTER_SAY = mod.CHAT_MSG_MONSTER_EMOTE
mod.CHAT_MSG_MONSTER_SAY = mod.CHAT_MSG_MONSTER_EMOTE

function mod:OnCombatEnd()
end