local mod	= DBM:NewMod("Arynyes", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(1000000)
mod:SetUsedIcons()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_RAID_BOSS_YELL",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_EMOTE",
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

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_APPLIED(args)
end

function mod:SPELL_AURA_REMOVED(args)
end

function mod:SPELL_CAST_START(args)
end

function mod:UNIT_DIED(args)
end



function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)
end
mod.CHAT_MSG_RAID_BOSS_EMOTE = mod.CHAT_MSG_MONSTER_EMOTE
mod.CHAT_MSG_RAID_BOSS_EMOTE = mod.CHAT_MSG_RAID_WARNING

function mod:CHAT_MSG_MONSTER_YELL(msg)
end
mod.CHAT_MSG_MONSTER_YELL = mod.CHAT_MSG_RAID_BOSS_YELL

function mod:OnCombatEnd()
end