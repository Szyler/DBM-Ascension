local mod	= DBM:NewMod("Gehennas", "DBM-MC", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(12259)--, 11661
mod:RegisterCombat("combat", 12259)

mod:RegisterEvents(
	-- "SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

--local warnRainFire	= mod:NewSpellAnnounce(19717)
local warnCurse			= mod:NewTargetAnnounce(19716)
local warnFist			= mod:NewTargetAnnounce(20277)
local specWarnRain		= mod:NewSpecialWarningYou(350076)

local timerNextCurse	= mod:NewNextTimer(20, 19716)
local timerNextRain		= mod:NewNextTimer(12, 20277)
local timerFist			= mod:NewBuffActiveTimer(4, 20277)
local timerEnrage		= mod:NewBerserkTimer(300)

local FistTargets = {}

function mod:OnCombatStart(delay)
	table.wipe(FistTargets)
	timerEnrage:Start(-delay)
	timerNextRain:Start(10-delay)
	timerNextCurse:Start()
end

function mod:warnFistTargets()
	warnFist:Show(table.concat(FistTargets, "<, >"))
	timerFist:Start(7-delay)
	table.wipe(FistTargets)
end

-- function mod:SPELL_CAST_SUCCESS(args)
-- 	if args:IsSpellID(19716) then
-- 		timerNextCurse:Start()
-- 		warnCurse:Show()
-- --	elseif args:IsSpellID(19717) and self:IsInCombat() then
-- --		warnRainFire:Show()
-- 	end
-- end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(20277) and args:IsDestTypePlayer() then
		self:UnscheduleMethod("warnFistTargets")
		FistTargets[#FistTargets + 1] = args.destName
		self:ScheduleMethod(0.3, "warnFistTargets")
	elseif args:IsSpellID(20277) then
		if args:IsPlayer() then
			specWarnRain:Show()
		end
		timerNextRain:Start()
	elseif args:IsSpellID(19716, 905063) then
		timerNextCurse:Start()
		warnCurse:Show()
	end
end