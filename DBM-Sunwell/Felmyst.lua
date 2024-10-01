local mod	= DBM:NewMod("Felmyst", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(25038)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON",
	"RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_EMOTE",
	"CHAT_MSG_RAID_WARNING",
	"CHAT_MSG_MONSTER_SAY"
)


local warnCastCorrosion 		= mod:NewSpellAnnounce(2145808, 2) -- 2145808, 2145809, 21458010 spell_cast_start
local timerNextCorrosion		= mod:NewNextTimer(45, 2145808) -- 2145808, 2145809, 21458010 spell_cast_start
local timerCastCorrosion		= mod:NewCastTimer(5, 2145808) -- 2145808, 2145809, 21458010 spell_cast_start
-- local warnCorrosion				= mod:NewTargetAnnounce(2145808, 2) -- 2145808, 2145809, 21458010 spell_aura_applied

local warnCastAcidicBreath 		= mod:NewSpellAnnounce(2145801, 2) -- 2145801, 2145802, 2145803, SPELL_CAST_START
local timerNextAcidicBreath		= mod:NewNextTimer(22, 2145801) -- 2145801, 2145802, 2145803, SPELL_CAST_START
local timerAcidicBreath			= mod:NewCastTimer(5, 2145801) -- 2145801, 2145802, 2145803, SPELL_CAST_START
-- local warnAcidicBreath			= mod:NewTargetAnnounce(2145801, 2) -- 2145801, 2145802, 2145803, SPELL_CAST_START

local warnCastNecroticBreath 	= mod:NewSpellAnnounce(2145801, 2) -- 2145817, 2145818, 2145819, 2145820, 2145821, 12 seconds after Acidic spell_cast_start
local timerNextNecroticBreath	= mod:NewNextTimer(12, 2145801) -- 2145817, 2145818, 2145819, 2145820, 2145821,  12 seconds after Acidic spell_cast_start
-- local warnNecroticBreath		= mod:NewTargetAnnounce(2145801, 2) -- 2145817, 2145818, 2145819, 2145820, 2145821, 12 seconds after Acidic spell_cast_start

local warnCastFreezingBreath 	= mod:NewSpellAnnounce(2145822, 2) -- 2145822, 2145823, 2145824, 2145825 12 seconds after Acidic spell_cast_start
local timerNextFreezingBreath	= mod:NewNextTimer(12, 2145822) -- 2145822, 2145823, 2145824, 2145825,  12 seconds after Acidic spell_cast_start
local timerCastFreezingBreath	= mod:NewCastTimer(15, 2145835) -- 2145835, spell_cast_start of inhale
-- local warnFreezingBreath		= mod:NewTargetAnnounce(2145822, 2) -- 2145822, 2145823, 2145824, 2145825, 12 seconds after Acidic spell_cast_start

local warnCastInhale 			= mod:NewSpellAnnounce(2145833, 2) -- 2145833, spell_cast_start
local timerNextInhale			= mod:NewNextTimer(17, 2145833) -- 2145833, spell_cast_start

local timerNextNecroticDeluge	= mod:NewNextTimer(5, 2145835) -- 2145835, spell_cast_start
local timerCastNecroticDeluge	= mod:NewCastTimer(15, 2145835) -- 2145835, spell_cast_start of inhale

local warnArcaneDetention 		= mod:NewSpellAnnounce(2145812, 2) -- 2145812, 2145814 spell_cast_start
local timerNextArcaneDetention 	= mod:NewNextTimer(60, 2145812) -- 2145812, 2145814 spell_cast_start
local timerTargetArcaneDetention = mod:NewTargetTimer(10, 2145812) -- 2145812, 2145814 spell_cast_start
local warnDebuffArcaneDetention  = mod:NewSpecialWarningStack(2145814, nil, 12) -- 2145814 spell_aura_applied


local warnTailSweep 			= mod:NewSpellAnnounce(2145806, 2) -- 2145806 spell_cast_success
local warnNextTailSweep			= mod:NewNextTimer(10, 2145806) -- 2145806 spell_cast_success 1 sec after Corrosion

local timerBreath				= mod:NewCDTimer(20, 45717)
local warnBreath				= mod:NewSpellAnnounce(45717, 4)
local warnPhase					= mod:NewAnnounce("WarnPhase", 1, 31550)

local timerPhase				= mod:NewTimer(60, "TimerPhase", 31550)
local berserkTimer				= mod:NewBerserkTimer(720)

--Exhale 2145834

local breathCounter = 0

function mod:Groundphase()
	breathCounter = 0
	warnPhase:Show(L.Ground)
	timerNextCorrosion:Start(2)
	warnNextTailSweep:Start(9)
	timerNextAcidicBreath:Start(14)
	timerNextArcaneDetention:Start(24)
end

function mod:OnCombatStart(delay)
	breathCounter = 0
	timerNextCorrosion:Start(15-delay)
	warnNextTailSweep:Start(22-delay)
	timerNextAcidicBreath:Start(27-delay)
	timerNextArcaneDetention:Start(37-delay)
	berserkTimer:Start(-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2145808, 2145809, 21458010) then
		warnTailSweep:Show()
		-- warnNextTailSweep:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2145814) and args:IsPlayer() then
		warnDebuffArcaneDetention:Show(args.destName, args.amount or 1)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2145808, 2145809, 2145810) then
		warnCastCorrosion:Show()
		timerNextCorrosion:Start()
		timerCastCorrosion:Start()
		-- warnCorrosion:Show()
	-- elseif args:IsSpellID(2145833) then
	-- 	timerNextInhale:Start()
	elseif args:IsSpellID(2145812) then
		warnArcaneDetention:Show()
		timerNextArcaneDetention:Start()
		timerTargetArcaneDetention:Start(args.destName)
	elseif args:IsSpellID(2145801, 2145802, 2145803) then
		warnCastAcidicBreath:Show()
		timerAcidicBreath:Start()
		timerNextAcidicBreath:Start()
	elseif args:IsSpellID(2145833) then
		breathCounter = breathCounter + 1
		warnCastInhale:Show()
		if breathCounter < 3 then
			timerNextInhale:Start(nil, breathCounter+1)
		end
	end
end

function mod:necroticBreath()
	timerCastNecroticDeluge:Start()
end

function mod:frostBreath()
	timerCastFreezingBreath:Start()
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L.AirPhase or msg:find(L.AirPhase)
	or msg == L.AirPhase2 or msg:find(L.AirPhase2) then
		timerNextCorrosion:Stop()
		warnNextTailSweep:Stop()
		timerNextAcidicBreath:Stop()
		timerNextArcaneDetention:Stop()
		
		breathCounter = 0
		timerBreath:Start(42, 1)
		timerNextNecroticBreath:Start(12)
		self:ScheduleMethod(12, "necroticBreath")
		timerNextFreezingBreath:Start(27)
		self:ScheduleMethod(27, "frostBreath")

		timerPhase:Start(107, L.Ground)
		self:ScheduleMethod(107, "Groundphase")
	end
end
mod.CHAT_MSG_MONSTER_YELL = mod.CHAT_MSG_MONSTER_EMOTE
mod.CHAT_MSG_RAID_BOSS_EMOTE = mod.CHAT_MSG_MONSTER_EMOTE
mod.CHAT_MSG_MONSTER_SAY = mod.CHAT_MSG_MONSTER_EMOTE
mod.CHAT_MSG_RAID_WARNING = mod.CHAT_MSG_MONSTER_EMOTE
