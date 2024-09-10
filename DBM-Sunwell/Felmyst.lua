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
	"UNIT_AURA"
)


local warnCastCorrosion 		= mod:NewSpellAnnounce(2145808, 2) -- 2145808, 2145809, 21458010 spell_cast_start
local timerNextCorrosion		= mod:NewNextTimer(10, 2145808) -- 2145808, 2145809, 21458010 spell_cast_start
local warnCorrosion				= mod:NewTargetAnnounce(2145808, 2) -- 2145808, 2145809, 21458010 spell_aura_applied

local warnCastAcidicBreath 		= mod:NewSpellAnnounce(2145801, 2) -- 2145801, 2145802, 2145803, SPELL_CAST_START
local timerNextAcidicBreath		= mod:NewNextTimer(12, 2145801) -- 2145801, 2145802, 2145803, SPELL_CAST_START
local timerAcidicBreath			= mod:NewCastTimer(5, 2145801) -- 2145801, 2145802, 2145803, SPELL_CAST_START
-- local warnAcidicBreath			= mod:NewTargetAnnounce(2145801, 2) -- 2145801, 2145802, 2145803, SPELL_CAST_START

local warnCastNecroticBreath 	= mod:NewSpellAnnounce(2145801, 2) -- 2145817, 2145818, 2145819, 2145820, 2145821, 12 seconds after Acidic spell_cast_start
local timerNextNecroticBreath	= mod:NewNextTimer(12, 2145801) -- 2145817, 2145818, 2145819, 2145820, 2145821,  12 seconds after Acidic spell_cast_start
-- local warnNecroticBreath		= mod:NewTargetAnnounce(2145801, 2) -- 2145817, 2145818, 2145819, 2145820, 2145821, 12 seconds after Acidic spell_cast_start

local warnCastInhale 			= mod:NewSpellAnnounce(2145833, 2) -- 2145833, spell_cast_start
local timerNextInhale			= mod:NewNextTimer(17, 2145833) -- 2145833, spell_cast_start

local timerNextNecroticDeluge	= mod:NewNextTimer(5, 2145835) -- 2145835, spell_cast_start
local timerCastNecroticDeluge	= mod:NewCastTimer(4, 2145835) -- 2145835, spell_cast_start of inhale


local warnTailSweep 			= mod:NewSpellAnnounce(2145806, 2) -- 2145806 spell_cast_success
local warnNextTailSweep			= mod:NewNextTimer(10, 2145806) -- 2145806 spell_cast_success 1 sec after Corrosion

local timerBreath			= mod:NewCDTimer(20, 45717)
local warnBreath			= mod:NewSpellAnnounce(45717, 4)
local warnPhase				= mod:NewAnnounce("WarnPhase", 1, 31550)

local timerPhase				= mod:NewTimer(60, "TimerPhase", 31550)
local berserkTimer				= mod:NewBerserkTimer(600)


local breathCounter = 0

function mod:Groundphase()
	breathCounter = 0
	warnPhase:Show(L.Ground)
	timerNextCorrosion:Start(2)
	warnNextTailSweep:Start(9)
	timerNextCorrosion:Start(16)
	-- timerPhase:Start(60, L.Air)
end

function mod:OnCombatStart(delay)
	breathCounter = 0
	timernextCorrosion:Start(21-delay)
	warnNextTailSweep:Start(29-delay)
	berserkTimer:Start(-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2145808, 2145809, 21458010) then
		warnTailSweep:Show()
		-- warnNextTailSweep:Start()
	end
end

-- function mod:SPELL_SUMMON(args)
-- 	if args.spellId == 45392 then
-- 		warnVapor:Show(args.sourceName)
-- 		if args.sourceName == UnitName("player") then
-- 			specWarnVapor:Show()
-- 		end
-- 		if self.Options.VaporIcon then
-- 			self:SetIcon(args.sourceName, 8, 10)
-- 		end
-- 	end
-- end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2145806) then
		warnCastCorrosion:Show()
		timerNextCorrosion:Start()
		warnCorrosion:Show()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.AirPhase or msg:find(L.AirPhase) then
		breathCounter = 0
		timerBreath:Start(42, 1)
		timerPhase:Start(60, L.Ground)
		timerNextInhale:Start()
		self:ScheduleMethod(60, "Groundphase")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.Breath or msg:find(L.Breath) then
		breathCounter = breathCounter + 1
		warnBreath:Show(breathCounter)
		specWarnBreath:Show()
		if breathCounter < 3 then
			timerBreath:Start(nil, breathCounter+1)
		end
	end
end
mod.CHAT_MSG_RAID_BOSS_EMOTE = mod.CHAT_MSG_MONSTER_EMOTE
mod.CHAT_MSG_RAID_BOSS_EMOTE = mod.CHAT_MSG_RAID_WARNING
