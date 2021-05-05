local mod	= DBM:NewMod("Maiden", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 164 $"):sub(12, -3))
mod:SetCreatureID(16457)
--mod:RegisterCombat("yell", L.DBM_MOV_YELL_PULL)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_REMOVED",
	"CHAT_MSG_RAID_WARNING"
)

local warningRepentanceSoon	= mod:NewSoonAnnounce(85177, 2)
local warningRepentance		= mod:NewSpellAnnounce(85177, 3)
local warningHolyFire		= mod:NewTargetAnnounce(85122, 3)
local warnWrath				= mod:NewSpellAnnounce(32445, 2)

-- local timerRepentance		= mod:NewBuffActiveTimer(6, 85177)
local timerRepentanceCD		= mod:NewCDTimer(44, 85177)

mod:AddBoolOption("RangeFrame", true)

-- Ascension specific
local warningSpecDespRun	= mod:NewSpecialWarning(L.WarnPrayerRun)
local warningDesperate		= mod:NewSpellAnnounce(85108, 2)
local timerDesperate		= mod:NewBuffActiveTimer(3, 85120)
local timerDesperateExplode	= mod:NewBuffActiveTimer(14, 85103)
local timerDesperateCD		= mod:NewCDTimer(44, 85120)
local timerWrath			= mod:NewCDTimer(16, 32445)
local timerWrathSkipped		= mod:NewCDTimer(12, 32445)

function mod:OnCombatStart(delay)
	timerRepentanceCD:Start(40-delay)
	timerDesperateCD:Start(20-delay)
	timerWrath:Start(15-delay)
	timerWrathSkipped:Schedule(35)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(10)
	end
	lastRepentance = GetTime()
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end	

function mod:CHAT_MSG_RAID_WARNING(msg)
	if msg == L.DesperatePrayer then
		warningDesperate:Show()
		timerDesperateCD:Start()
		timerDesperateExplode:Start()
		warningSpecDespRun:Schedule(10)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(85122) then
		warningHolyFire:Show(args.destName)
	elseif args:IsSpellID(85177, 85307) then
		warningRepentanceSoon:Cancel()
--		timerRepentance:Start()
		timerRepentanceCD:Start()
		warningRepentanceSoon:Schedule(40)
		if (GetTime() - lastRepentance) > 10 then--To not spam each target of Repentance
			warningRepentance:Show()
			lastRepentance = GetTime()
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(32445, 85228, 85229) then
		self:Unschedule(timerWrathSkipped);
		timerWrath:Start()
		timerWrathSkipped:Schedule(20)
		warnWrath:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(29522) then
		timerHolyFire:Cancel()
	end
end
