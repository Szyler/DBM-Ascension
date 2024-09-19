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

local timerTargetLegionLightning	= mod:NewTargetTimer(4, 2146510) -- 2146510, 2146511 Spell_cast_start
local warnTargetLegionLightning		= mod:NewTargetAnnounce(2146510, 2) -- 2146510, 2146511 Spell_cast_start
local timerNextLegionLightning		= mod:NewNextTimer(20, 2146510) -- 2146510, 2146511 Spell_cast_start

local timerCastAnnihilate			= mod:NewCastTimer(3, 2146557) -- 2146557 Spell_cast_start
local warnAnnihilate				= mod:NewSpellAnnounce(2146557, 3) -- 2146557 Spell_cast_start
local timeTargetTimerAnnihilate		= mod:NewTargetTimer(53, 2146557) -- 2146557 Spell_cast_start

local timerNextWorldBreaker 		= mod:NewNextTimer(30, 2146520) -- 2146519, 2146520 Spell_cast_start
local warnWorldBreaker				= mod:NewSpellAnnounce(2146520, 3) -- 2146519, 2146520 Spell_cast_start

local timerCastAllConsuming	 		= mod:NewCastTimer(127, 2146521) -- 2146521 Spell_cast_start
local timerNextAllConsuming	 		= mod:NewNextTimer(30, 2146521) -- 2146521 Spell_cast_start

local timerNextDarkness				= mod:NewNextTimer(30, 2146540) -- 2146540, 2146541, 2146542 Spell_cast_start

local timerNextReflections			= mod:NewNextTimer(25, 2146538) -- 2146522 Spell_cast_start

local timerNextFireBloom			= mod:NewNextTimer(30, 2146523) -- 2146523, 2146524, 2146525, 2146526 Spell_cast_start
local timerTargetFireBloom			= mod:NewTargetTimer(4, 2146523) -- 2146523, 2146524, 2146525, 2146526 Spell_cast_start


self.vb.flamesDown = 0

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	self.vb.flamesDown = 0
	timerNextSoulbomb:Start(5-delay)
	timerNextSoulrend:Start(20-delay)
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
		warnTargetLegionLightning:Show(args.destName)
		timerTargetLegionLightning:Start(args.destName)
	elseif args:IsSpellID(2146557) then
		timerCastAnnihilate:Start()
		warnAnnihilate:Show()
		timeTargetTimerAnnihilate:Start(args.sourceName)
	elseif args:IsSpellID(2146520, 2146519) then
		warnWorldBreaker:Show()
		timerNextWorldBreaker:Start()
	elseif args:IsSpellID(2146521) then
		timerCastAllConsuming:Start()
		timerNextAllConsuming:Start()
	elseif args:IsSpellID(2146538) then
		timerNextReflections:Start()
	elseif args:IsSpellID(2146523, 2146524, 2146525, 2146526) then
		timerNextFireBloom:Start()
		timerTargetFireBloom:Start(args.destName)
	elseif args:IsSpellID(2146540, 2146541, 2146542) then
		timerNextDarkness:Start()

	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2146688) then
		warnFelRage:Show(args.destName)
		timerFelRage:Start(args.destName)
	elseif args:IsSpellID(2146682) then
		warnSoulbomb:Show(args.destName)
		timerNextSoulbomb:Start(args.destName)
		
		if args.destName == UnitName("player") then
			YellSoulbomb:Countdown(10, 3)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2146688) then
		timerFelRage:Stop(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)

end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L.KJPull or msg:find(L.KJPull) then
		self.vb.phase = 2
		warnPhase2:Show()
		timerEmerge:Start()
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




-- local warnBloom			= mod:NewTargetAnnounce(45641, 2)
-- local warnDarkOrb		= mod:NewAnnounce("WarnDarkOrb", 4, 45109)
-- local warnDart			= mod:NewSpellAnnounce(45740, 3)
-- local warnBomb			= mod:NewCastAnnounce(46605, 4, 8)
-- local warnShield		= mod:NewSpellAnnounce(45848, 3)
-- local warnBlueOrb		= mod:NewAnnounce("WarnBlueOrb", 1, 45109)
-- local warnPhase2		= mod:NewPhaseAnnounce(2)
-- local warnPhase3		= mod:NewPhaseAnnounce(3)
-- local warnPhase4		= mod:NewPhaseAnnounce(4)

-- local warnSpikeTarget	= mod:NewTargetAnnounce(46589, 3)
-- local specWarnSpike		= mod:NewSpecialWarningMove(46589)
-- local specWarnBloom		= mod:NewSpecialWarningMove(45641)
-- local specWarnBomb		= mod:NewSpecialWarningSpell(46605, nil, nil, nil, 3)
-- local specWarnShield	= mod:NewSpecialWarningSpell(45848)
-- local specWarnDarkOrb	= mod:NewSpecialWarning("SpecWarnDarkOrb", true)
-- local specWarnBlueOrb	= mod:NewSpecialWarning("SpecWarnBlueOrb", true)

-- local yellBloom			= mod:NewYell(45641)
-- local yellSpike			= mod:NewYell(46589)
-- local timerBloomCD		= mod:NewCDTimer(20, 45641)
-- local timerDartCD		= mod:NewCDTimer(20, 45740)
-- local timerBomb			= mod:NewCastTimer(9, 46605)
-- local timerBombCD		= mod:NewCDTimer(45, 46605)
-- local timerSpike		= mod:NewCastTimer(28, 46680)
-- local timerBlueOrb		= mod:NewTimer(37, "TimerBlueOrb", 45109)
-- local berserkTimer		= mod:NewBerserkTimer(900)

-- mod:AddBoolOption("BloomIcon", true)
-- mod:AddBoolOption("RangeFrame", true)

-- local warnBloomTargets = {}
-- local orbGUIDs = {}
-- local bloomIcon = 8
-- mod.vb.phase = 1

-- local function showBloomTargets()
-- 	warnBloom:Show(table.concat(warnBloomTargets, "<, >"))
-- 	table.wipe(warnBloomTargets)
-- 	bloomIcon = 8
-- 	timerBloomCD:Start()
-- end

-- function mod:OnCombatStart(delay)
-- 	table.wipe(warnBloomTargets)
-- 	table.wipe(orbGUIDs)
-- 	bloomIcon = 8
-- 	self.vb.phase = 1
-- 	berserkTimer:Start(-delay)
-- 	if self.Options.RangeFrame then
-- 		DBM.RangeCheck:Show()
-- 	end
-- end

-- function mod:OnCombatEnd()
-- 	if self.Options.RangeFrame then
-- 		DBM.RangeCheck:Hide()
-- 	end
-- end

-- function mod:SPELL_AURA_APPLIED(args)
-- 	if args.spellId == 45641 then
-- 		warnBloomTargets[#warnBloomTargets + 1] = args.destName
-- 		self:Unschedule(showBloomTargets)
-- 		if self.Options.BloomIcon then
-- 			self:SetIcon(args.destName, bloomIcon)
-- 			bloomIcon = bloomIcon - 1
-- 		end
-- 		if args:IsPlayer() then
-- 			specWarnBloom:Show()
-- 			yellBloom:Yell()
-- 		end
-- 		if #warnBloomTargets >= 5 then
-- 			showBloomTargets()
-- 		else
-- 			self:Schedule(0.3, showBloomTargets)
-- 		end
-- 	end
-- end

-- function mod:SPELL_AURA_REMOVED(args)
-- 	if args.spellId == 45641 then
-- 		if self.Options.BloomIcon then
-- 			self:SetIcon(args.destName, 0)
-- 		end
-- 	end
-- end

-- function mod:SPELL_CAST_START(args)
-- 	if args.spellId == 46605 then
-- 		warnBomb:Show()
-- 		specWarnBomb:Show()
-- 		timerBomb:Start()
-- 		if self.vb.phase == 4 then
-- 			timerBombCD:Start(25)
-- 		else
-- 			timerBombCD:Start()
-- 		end
-- 	elseif args.spellId == 45737 then
-- 		warnDart:Show()
-- 		timerDartCD:Start()
-- 	elseif args.spellId == 46680 then
-- 		timerSpike:Start()
-- 	end
-- end

-- function mod:SPELL_CAST_SUCCESS(args)
-- 	if args.spellId == 45680 and not orbGUIDs[args.sourceGUID] then
-- 		orbGUIDs[args.sourceGUID] = true
-- 		warnDarkOrb:Show()
-- 		specWarnDarkOrb:Show()
-- 	elseif args.spellId == 45848 then
-- 		warnShield:Show()
-- 		specWarnShield:Show()
-- 	elseif args.spellId == 46589 and args.destName ~= nil then
-- 		warnSpikeTarget:Show(args.destName)
-- 		if args.destName == UnitName("player") then
-- 			specWarnSpike:Show()
-- 			yellSpike:Yell()
-- 		end
-- 	end
-- end

-- function mod:CHAT_MSG_MONSTER_EMOTE(msg)
-- 	if msg == L.OrbYell1 or msg:find(L.OrbYell1) or msg == L.OrbYell2 or msg:find(L.OrbYell2) or msg == L.OrbYell3 or msg:find(L.OrbYell3) or msg == L.OrbYell4 or msg:find(L.OrbYell4) then
-- 		warnBlueOrb:Show()
-- 		specWarnBlueOrb:Show()
-- 	elseif msg == L.ReflectionYell1 or msg:find(L.ReflectionYell1) or msg == L.ReflectionYell2 or msg:find(L.ReflectionYell2) then
-- 		self.vb.phase = self.vb.phase + 1
-- 		if self.vb.phase == 2 then
-- 			warnPhase2:Show()
-- 			timerBlueOrb:Start()
-- 			timerDartCD:Start(59)
-- 			timerBombCD:Start(77)
-- 		elseif self.vb.phase == 3 then
-- 			warnPhase3:Show()
-- 			timerBlueOrb:Cancel()
-- 			timerDartCD:Cancel()
-- 			timerBombCD:Cancel()
-- 			timerBlueOrb:Start()
-- 			timerDartCD:Start(59)
-- 			timerBombCD:Start(77)
-- 		elseif self.vb.phase == 4 then
-- 			warnPhase4:Show()
-- 			timerBlueOrb:Cancel()
-- 			timerDartCD:Cancel()
-- 			timerBombCD:Cancel()
-- 			timerBlueOrb:Start(45)
-- 			timerDartCD:Start(49)
-- 			timerBombCD:Start(58)
-- 		end
-- 	end
-- end
-- mod.CHAT_MSG_MONSTER_YELL 		= mod.CHAT_MSG_MONSTER_EMOTE
-- mod.CHAT_MSG_RAID_BOSS_EMOTE 	= mod.CHAT_MSG_MONSTER_EMOTE
-- mod.CHAT_MSG_MONSTER_SAY 		= mod.CHAT_MSG_MONSTER_EMOTE
-- mod.CHAT_MSG_RAID_WARNING 		= mod.CHAT_MSG_MONSTER_EMOTE

-- function mod:SPELL_DAMAGE(args)
-- 	if args.spellId == 45680 and not orbGUIDs[args.sourceGUID] then
-- 		orbGUIDs[args.sourceGUID] = true
-- 		warnDarkOrb:Show()
-- 		specWarnDarkOrb:Show()
-- 	end
-- end