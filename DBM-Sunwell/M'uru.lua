local mod	= DBM:NewMod("Muru", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(25741)--25741 Muru, 25840 Entropius

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"UNIT_DIED",
	"UNIT_HEALTH"
)


local warnVoidSpike				= mod:NewSpellAnnounce(2146314, 2)			
local warnDarkness				= mod:NewSpecialWarningYou(2146301, 4)
local timerDarkness				= mod:NewNextTimer(0, 2146301)
--local warnVoidRift				= mod:NewAnnounce("WarnVoidRift", 4, 2146310)
--local timerVoidRift				= mod:NewNextTimer(60, 2146310)
local warnVoidSentinel			= mod:NewSpellAnnounce(2146312, 2)
local timerVoidSentinel			= mod:NewNextTimer(60, 2146312)
local SpecWarnVoidSpawn			= mod:NewSpellAnnounce(2146330, 2)--("WarnVoidSpawn", 4, 2146330)
local warnDarkFiend				= mod:NewSpellAnnounce(2146320, 2)--("WarnFiend", 2, 2146320)
local timerDarkFiend			= mod:NewNextTimer(60, 2146320)
local warnVoidCutter			= mod:NewSpellAnnounce(2146303, 2)--("WarnVoidCutter", 2, 2146303)
local timerVoidCutterSpawn		= mod:NewNextTimer(64, 2146303)
--local timerVoidCutterActive		= mod:NewNextTimer(64, 2146303)
local timerVCutterDuration		= mod:NewTimer(30, "Void Cutter duration", 2146303)

local warnPhase2				= mod:NewPhaseAnnounce(2)
local warnBlackHole				= mod:NewSpellAnnounce(2146370, 3)
local timerBlackHole			= mod:NewNextTimer(30, 2146370)

local berserkTimer				= mod:NewBerserkTimer(600)

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	timerVoidSentinel:Start(10-delay)
	timerVoidCutterSpawn:Start(20-delay)
	timerVCutterDuration:Schedule(23-delay)
	timerDarkFiend:Start(30-delay)
	berserkTimer:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2146314) then
		if args:IsPlayer() then
			warnDarkness:Show()
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2146322) and DBM:AntiSpam() then
		warnDarkFiend:Show()
		timerDarkFiend:Start(60)

		timerVoidCutterSpawn:Start(55)
		timerVCutterDuration:Schedule(58)
		warnVoidCutter:Schedule(55)

		if self.vb.phase == 1 then
			warnVoidSentinel:Schedule(40)
			timerVoidSentinel:Start(40)
		end
	elseif args:IsSpellID(2146314) then
		warnVoidSpike:Show()
	end
end

function mod:UNIT_HEALTH(unit)
	if mod:GetUnitCreatureId(unit) == 25741 and self.vb.phase == 1 then
		local hp = (math.max(0,UnitHealth(unit)) / math.max(1, UnitHealthMax(unit))) * 100
		if hp <= 50 then
			self.vb.phase = 2
			warnPhase2:Show()
			timerDarkFiend:Cancel()
			timerVoidCutterSpawn:Cancel()
			timerVoidSentinel:Cancel()
			timerBlackHole:Start(25)
			timerDarkFiend:Start(15)
			timerVoidCutterSpawn:Start(20)
			timerVCutterDuration:Schedule(23)
		end
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

function mod:SPELL_SUMMON(args)
	if args.spellId == 46268 then
		warnFiend:Show()
	elseif args.spellId == 46282 and DBM:AntiSpam(2, 1) then
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