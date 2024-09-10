local mod	= DBM:NewMod("Muru", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(25741)--25741 Muru, 25840 Entropius

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON",
	"UNIT_DIED",
	"UNIT_HEALTH"
)

local warnDarkness			= mod:NewSpellAnnounce(2146301, 2)
local timerDarkness			= mod:NewNextTimer(0, 2146301)
--local warnVoidRift			= mod:NewAnnounce("WarnVoidRift", 4, 2146310)
--local timerVoidRift			= mod:NewNextTimer(60, 2146310)
local warnVoidSentinel		= mod:NewAnnounce("WarnSentinel", 4, 2146312)
local timerVoidSentinel		= mod:NewNextTimer(60, 2146312)
local SpecWarnVoidSpawn		= mod:NewAnnounce("WarnVoidSpawn", 4, 2146330)
local warnDarkFiend			= mod:NewAnnounce("WarnFiend", 2, 2146320)
local timerDarkFiend		= mod:NewNextTimer(60, 2146320)
local warnVoidCutter		= mod:NewAnnounce("WarnVoidCutter", 2, 2146303)
local timerVoidCutterSpawn	= mod:NewNextTimer(64, 2146303)
--local timerVoidCutterActive	= mod:NewNextTimer(64, 2146303)

local warnPhase2			= mod:NewPhaseAnnounce(2)
local warnBlackHole			= mod:NewSpellAnnounce(2146370, 3)
local timerBlackHole		= mod:NewNextTimer(20, 2146370)


local isphase2 = false

function mod:OnCombatStart(delay)
	isphase2 = false

	--timerVoidRift:Start(5-delay)
	timerVoidSentinel:Start(10-delay)
	timerVoidCutterSpawn:Start(20-delay)
	--timerVoidCutterActive:Start(25-delay)
	timerDarkness:Start(30-delay)
	timerDarkFiend:Start(30-delay)

	-- if self.Options.ShowFrame then
	-- 	self:CreateFrame()
	-- end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show()
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 25741 and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.5 and isphase2 == false and DBM:AntiSpam(5,2) then
		isphase2 = true
		warnPhase2:Show()
		timerBlackHole:Start(23-delay)
	end
end

--[[
Timers
	Portals + Sentinal			10 seconds after pull, then every 60 seconds while in Phase 1									
	Void Cutter					20 seconds after pull, then 55 seconds, then every 60 seconds. Spawns, becomes active after 5 seconds, then is active for 30 seconds.  Visible for 35 seconds total.									
	Darkness + Dark Fiends		30 seconds after pull, then every 60 seconds									
	Black Hole					23 seconds after Entropius spawns, then every 20 seconds

Note
	Timers for Portals stop when Muru hits 50%
	Timers for Void Cutters and Dark Fiends are not affected by phase transition
	When timers would happen at the same time, one is pushed to be earlier by 1 second.  Appears that Cutter is the main spell that gets pushed.
]]--

--[[
local function phase2()
	warnPhase2:Show()
	warned_phase2 = true
	mod:UnscheduleMethod("HumanSpawn")
	mod:UnscheduleMethod("VoidSpawn")
	timerBlackHoleCD:Start(15)
	if mod.Options.HealthFrame then
		DBM.BossHealth:Clear()
		DBM.BossHealth:AddBoss(25840, L.Entropius)
	end
end

function mod:VoidSpawn()
	warnVoid:Show(voidCount)
	voidCount = voidCount + 1
	timerVoid:Start(nil, voidCount)
	specWarnVW:Schedule(25)
	self:ScheduleMethod(30, "VoidSpawn")
end

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	voidCount = 1
	warned_phase2 = false
	timerHuman:Start(10-delay, humanCount)
	timerVoid:Start(36.5-delay, voidCount)
	specWarnVW:Schedule(31.5)
	timerNextDarkness:Start(47-delay)
	specWarnDarknessSoon:Schedule(42)
	self:ScheduleMethod(10, "HumanSpawn")
	self:ScheduleMethod(36.5, "VoidSpawn")
	berserkTimer:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 45996 and args:GetDestCreatureID() == 25741 then
		warnDarkness:Show()
		specWarnVoid:Show()
		timerNextDarkness:Start()
		timerDarknessDura:Start()
		specWarnDarknessSoon:Schedule(40)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 46177 then
		warned_phase2 =  true
		timerNextDarkness:Cancel()
		timerHuman:Cancel()
		timerVoid:Cancel()
		specWarnVW:Cancel()
		timerPhase:Start()
		specWarnDarknessSoon:Cancel()
		self:Schedule(6, phase2)
	end
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 46268 then
		warnFiend:Show()
	elseif args.spellId == 46282 and self:AntiSpam(2, 1) then
		warnBlackHole:Show()
		specWarnBH:Show()
		timerBlackHoleCD:Start()
		timerSingularity:Start()
	end
end

function mod:UNIT_DIED(args)
	if self:GetCIDFromGUID(args.destGUID) == 25840 then
		DBM:EndCombat(self)
	end
end

function mod:UNIT_HEALTH(uId)
	if not warned_phase2 and self:GetUnitCreatureId(uId) == 25840 and UnitHealth(uId) / UnitHealthMax(uId) > 0.9 and self.vb.phase == 1 then
		warned_phase2 = true
		timerNextDarkness:Cancel()
		timerHuman:Cancel()
		timerVoid:Cancel()
		specWarnDarknessSoon:Cancel()
		phase2()
	end
end
]]--