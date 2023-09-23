local mod	= DBM:NewMod("RageWinterchill", "DBM-Hyjal", 1)

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(17767, 117767, 217767, 317767)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"UNIT_HEALTH"
)

local warnShatter5				= mod:NewSoonAnnounce(2140630, 3)
local warnShatter2				= mod:NewSoonAnnounce(2140630, 4)

local warnDeathAndDecay			= mod:NewSpecialWarningYou(2140600)
local warnFrostbite				= mod:NewSpecialWarningYou(2140613)
local warnIceBarrage			= mod:NewSpecialWarningSpell(2140624)

local timerNextChains			= mod:NewNextTimer(15, 2140654)
local timerNextWintersTouch		= mod:NewNextTimer(15, 2140606)
local timerNextDeathAndDecay	= mod:NewNextTimer(30, 2140600)
local timerNextIceBarrage		= mod:NewNextTimer(45, 2140624)
local timerNextLichSlap			= mod:NewNextTimer(10, 2140645)
-- local timerNextThreatDrop 	= mod:NewNextTimer(-1, 1)
local nwarns = 0

mod:AddBoolOption("TrackWintersTouch", false)
mod:AddBoolOption("TrackLichSlap", false)

function mod:DeathAndDecay()
	self:UnscheduleMethod("DeathAndDecay")
	timerNextDeathAndDecay:Start()
	self:ScheduleMethod(30, "DeathAndDecay")
end

-- function mod:ThreatDrop()
-- 	self:UnscheduleMethod("ThreatDrop")
-- 	nextThreatDrop:Start()
-- 	self:ScheduleMethod(30, "ThreatDrop")
-- end

function mod:OnCombatStart(delay)
	timerNextChains:Start(-delay)
	timerNextDeathAndDecay:Start(-delay)
	timerNextIceBarrage:Start(-delay)
	self:ScheduleMethod(30, "DeathAndDecay")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2140600, 2140601, 2140602, 2140603) and DBM:AntiSpam(nil, 2140600) then
		warnDeathAndDecay:Show()
	elseif args:IsSpellID(2140613, 2140614, 2140615, 2140616) then
		warnFrostbite:Show()
	elseif args:IsSpellID(2140654) then
		if args:IsPlayer() then
			SendChatMessage(string.format("Connected to %s!", args.sourceName), "YELL")
		elseif args.sourceName == UnitName("Player") then
			SendChatMessage(string.format("Connected to %s!", args.destName), "YELL")
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2140624, 2140625, 2140626, 2140627) then
		warnIceBarrage:Show()
		timerNextIceBarrage:Start()
	elseif (
		self.Options.TrackWintersTouch and
		args:IsSpellID(2140605, 2140606, 2140607, 2140608)
	) then
		timerNextWintersTouch:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if self.Options.TrackLichSlap and args:IsSpellID(2140645) then
		timerNextLichSlap:Start()
	end
end

function mod:UNIT_HEALTH(unit)
	local unit_id = mod:GetUnitCreatureId(unit)
	if unit_id == 17767 or unit_id == 117767 or unit_id == 217767 or unit_id == 317767 then
		local hp = math.max(0, UnitHealth(unit)) / math.max(1, UnitHealthMax(unit)) * 100
		if hp <= 35 and nwarns < 1 then
			nwarns = 1
			warnShatter2:Show()
		elseif hp <= 38 and nwarns < 2 then
			nwarns = 2
			warnShatter5:Show()
		elseif hp <= 68 and nwarns < 3 then
			nwarns = 3
			warnShatter2:Show()
		elseif hp <= 71 and nwarns < 4 then
			nwarns = 4
			warnShatter5:Show()
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == "It will be much colder in your grave." then -- Acolyte phase starts.
		timerNextWintersTouch:Stop()
		timerNextDeathAndDecay:Stop()
		timerNextIceBarrage:Stop()
		timerNextLichSlap:Stop()
		self:UnscheduleMethod("DeathAndDecay")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == "Rage Winterchill shatters his Ice Bullwark, continuing his assault!" then -- Acolyte phase ends.
		timerNextDeathAndDecay:Start(10)
		timerNextIceBarrage:Start(25)
		self:ScheduleMethod(10, "DeathAndDecay")
	end
end