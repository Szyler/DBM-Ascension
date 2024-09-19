local mod	= DBM:NewMod("Kil", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(25657, 25588, 25696, 25315)
mod:SetUsedIcons(4, 5, 6, 7, 8)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_MONSTER_EMOTE",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_RAID_WARNING",
	"CHAT_MSG_MONSTER_SAY",
	"UNIT_DIED"
)

-- Apolyon
local warnSoulbomb 					= mod:NewTargetAnnounce(2146682, 2)
local YellSoulbomb 					= mod:NewFadesYell(2146682)
local timerTargetSoulbomb 			= mod:NewTargetTimer(10, 2146682)
local timerNextSoulbomb 			= mod:NewNextTimer(10, 2146682)

local warnSoulrend 					= mod:NewSpellAnnounce(2146680, 2) -- 2146680 Spell_cast_Start
local timerNextSoulRend 			= mod:NewNextTimer(30, 2146680) -- 2146680 Spell_cast_Start (20 yard radius)
local timerCastSoulRend				= mod:NewCastTimer(3, 2146680) -- 2146680 Spell_cast_Start


-- Agamath	
-- local warnRagingBlow 				= mod:NewSpellAnnounce(2146684, 3)
local timerNextRagingBlow 			= mod:NewNextTimer(10, 2146684)

local warnFelRage 					= mod:NewTargetAnnounce(2146688, 2)
local timerFelRage 					= mod:NewTargetTimer(5, 2146688)

-- Archonisus	
local warnSummonWildImps 			= mod:NewSpellAnnounce(2146676, 3) -- 2146676 Spell_cast_Start
local timerNextSummonWildImps 		= mod:NewNextTimer(30, 2146676) -- 2146676 Spell_cast_Start
local timerCastImplosion 			= mod:NewCastTimer(30, 2146691)
local warnImplosion 				= mod:NewSpellAnnounce(2146691, 3) -- Spell_Damage 2146691

-- local warnConflagration 			= mod:NewSpellAnnounce(2146673, 3)
-- local timerConflagrationCast 		= mod:NewCastTimer(3, 2146673)

-- make warnings and timers for 	these, and make the trigger in their respective functions
-- Change all args.spellID into 	args:IsSpellID() with comma separated for the spellIDs

local berserkTimer					= mod:NewBerserkTimer(900)

-- KJ timers	
local timerEmerge					= mod:NewTimer(17,"Kil'Jaeden is emerging")
local warnPhase2					= mod:NewAnnounce("Stage Two: KJ has tiny legs", 3, 801892)

local timerTargetLegionLightning	= mod:NewTargetTimer(4, 2146510) -- 2146510, 2146511 Spell_cast_start
local warnTargetLegionLightning		= mod:NewTargetAnnounce(2146510, 2) -- 2146510, 2146511 Spell_cast_start
local timerNextLegionLightning		= mod:NewNextTimer(20, 2146510) -- 2146510, 2146511 Spell_cast_start
local warnSpecYouLegionLightning	= mod:NewSpecialWarningYou(2146510) -- 2146510, 2146511 Spell_cast_start

local timerCastAnnihilate			= mod:NewCastTimer(4, 2146555) -- 2146555, 2146556, 2146557, 2146560 Spell_cast_start
local warnAnnihilate				= mod:NewSpellAnnounce(2146555, 3) -- 2146555, 2146556, 2146557, 2146560 Spell_cast_start
local timeSpellTimerAnnihilate		= mod:NewCastTimer(55, 2146555) -- 2146555, 2146556, 2146557, 2146560 Spell_cast_start
local timeSpellTimerAnnihilateShort	= mod:NewCastTimer(13, 2146555) -- 2146555, 2146556, 2146557, 2146560 Spell_cast_start
local timerNextAnnihilate			= mod:NewNextTimer(96, 2146555) -- 2146555, 2146556, 2146557, 2146560 Spell_cast_start

local timerNextWorldBreaker 		= mod:NewNextTimer(30, 2146520) -- 2146519, 2146520 Spell_cast_start
local warnWorldBreaker				= mod:NewSpellAnnounce(2146520, 3) -- 2146519, 2146520 Spell_cast_start

local timerCastAllConsuming	 		= mod:NewCastTimer(127, 2146521) -- 2146521 Spell_cast_start
local timerNextAllConsuming	 		= mod:NewNextTimer(68, 2146521) -- 2146521 Spell_cast_start

local warnDarkness 					= mod:NewSpellAnnounce(2146540, 3) -- 2146540, 2146541, 2146542 Spell_cast_start
local timerNextDarkness				= mod:NewNextTimer(30, 2146540) -- 2146540, 2146541, 2146542 Spell_cast_start

local warnReflections				= mod:NewSpellAnnounce(2146538, 3) -- 2146522 Spell_cast_start
local timerNextReflections			= mod:NewNextTimer(25, 2146538) -- 2146522 Spell_cast_start

local timerNextFireBloom			= mod:NewNextTimer(30, 2146523) -- 2146523, 2146524, 2146525, 2146526 Spell_cast_start
local timerTargetFireBloom			= mod:NewTargetTimer(12, 2146523) -- 2146523, 2146524, 2146525, 2146526 Spell_cast_start

-- local timerNextObliterate			= mod:NewNextTimer(30, 2146575)	-- 2146575, 2146576, 2146578 Spell_cast_start
local warnObliterate				= mod:NewSpellAnnounce(2146575, 3)	-- 2146575, 2146576, 2146578 Spell_cast_start
local timerCastObliterate			= mod:NewCastTimer(5, 2146575)	-- 2146575, 2146576, 2146578 Spell_cast_start
local timerTargetObliterate			= mod:NewTargetTimer(49, 2146575) -- 2146575, 2146576, 2146578 Spell_cast_start


function mod:OnCombatStart(delay)
	self.vb.phase = 1
	self.vb.flamesDown = 0
	timerNexttSoulbomb:Start(5-delay)
	timerNextSoulrend:Start(20-delay)
end

function mod:LegionLightningTarget()							
	local target = nil
	target = mod:GetBossTarget(25315)
	if target == UnitName("player") then
		warnSpecYouLegionLightning:Show()
	else
		warnTargetLegionLightning:Show(target)
	end
	timerTargetLegionLightning:Start(target)
	self:SetIcon(target, 7, 3)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2146680) then
		warnSoulrend:Show()
		timerNextSoulrend:Start()
		timerCastSoulRend:Start()
	elseif args:IsSpellID(2146684, 2146685) then
		-- warnRagingBlow:Show()
		timerNextRagingBlow:Start()
	elseif args:IsSpellID(2146673, 2146674, 2146675) then
		-- warnConflagration:Show()
		-- timerConflagrationCast:Start()
	elseif args:IsSpellID(2146676) then
		warnSummonWildImps:Show()
		timerNextSummonWildImps:Start()
		timerCastImplosion:Start()
		warnImplosion:Schedule(27)
	elseif args:IsSpellID(2146510, 2146511) then
		self:ScheduleMethod(0.2,"LegionLightningTarget");
		timerNextLegionLightning:Start()
	elseif args:IsSpellID(2146555, 2146560) then
		timerCastAnnihilate:Start()
		warnAnnihilate:Show()
	elseif args:IsSpellID(2146520, 2146519) then
		warnWorldBreaker:Show()
		timerNextWorldBreaker:Start()
	elseif args:IsSpellID(2146521) then
		timerCastAllConsuming:Start()
	elseif args:IsSpellID(2146523, 2146524, 2146525, 2146526) then
		timerNextFireBloom:Start()
	elseif args:IsSpellID(2146540, 2146541, 2146542) then
		warnDarkness:Show()
		-- timerNextDarkness:Start()
	elseif args:IsSpellID(2146575, 2146576, 2146578) then
		warnObliterate:Show()
		timerCastObliterate:Start()
		timerTargetObliterate:Start()
	elseif args:IsSpellID(2146538) then
		warnReflections:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2146688) then
		warnFelRage:Show(args.destName)
		timerFelRage:Start(args.destName)
	elseif args:IsSpellID(2146682) then
		warnSoulbomb:Show(args.destName)
		timerNextSoulbomb:Start()
		timerTargetSoulbomb:Start(args.destName)
		if args.destName == UnitName("player") then
			YellSoulbomb:Countdown(10, 3)
		end
	elseif args:IsSpellID(2146523, 2146524, 2146525, 2146526) then
		timerTargetFireBloom:Start(args.destName)
	elseif args:IsSpellID(2146555) then
		timeSpellTimerAnnihilate:Start()
	elseif args:IsSpellID(2146560) then
		timeSpellTimerAnnihilateShort:Start()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2146688) then
		timerFelRage:Stop(args.destName)
	elseif args:IsSpellID(2146555) then
		timerNextDarkness:Start(10)
		timerNextFireBloom:Start(24)
		timerNextReflections:Start(60)
	elseif args:IsSpellID(2146560) then

	elseif args:IsSpellID(2146575, 2146576, 2146578) then
		timerNextDarkness:Start(5)
	end
end

function mod:SPELL_CAST_SUCCESS(args)

end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L.KJPull or msg:find(L.KJPull) then
		self.vb.phase = 2
		warnPhase2:Show()
		timerEmerge:Start()
		timerNextFireBloom:Start(10)
		timerNextWorldBreaker:Start(15)
		timerNextReflections:Start(25)
		-- timerNextAllConsuming:Start(66) --Percent based. Need Unit_Health
		-- timerNextAnnihilate:Start(96)
	end
end
mod.CHAT_MSG_MONSTER_YELL = mod.CHAT_MSG_MONSTER_EMOTE
mod.CHAT_MSG_RAID_BOSS_EMOTE = mod.CHAT_MSG_MONSTER_EMOTE
mod.CHAT_MSG_MONSTER_SAY = mod.CHAT_MSG_MONSTER_EMOTE
mod.CHAT_MSG_RAID_WARNING = mod.CHAT_MSG_MONSTER_EMOTE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 25588 then -- 
		timerNextSoulbomb:Stop()
		timerNextSoulRend:Stop()
	elseif cid == 25657 then -- Agamath
		timerNextRagingBlow:Stop()
		timerFelRage:Stop()
	elseif cid == 25696 then -- Archonisus
		timerNextSummonWildImps:Stop()
	end
end


