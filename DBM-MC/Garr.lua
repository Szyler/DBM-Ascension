local mod	= DBM:NewMod("Garr", "DBM-MC", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(12057)--, 12099
mod:RegisterCombat("combat", 12057)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)
local ReverbSpam = 0

local warnReverb				= mod:NewSoonAnnounce(2105076)
local warnHarden				= mod:NewSpellAnnounce(2105073)

-- local warnImmolate				= mod:NewTargetAnnounce(15732)
-- local timerImmolate				= mod:NewTargetTimer(21, 15732)

local timerNextReverb			= mod:NewNextTimer(25, 2105076)

function mod:OnCombatStart(delay)
	timerNextReverb:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	-- if args:IsSpellID(15732) and self:IsInCombat() then
	-- 	-- warnImmolate:Show(args.destName)
	-- 	-- timerImmolate:Start(args.destName)
	-- else
	if args:IsSpellID(2105076) and GetTime() > ReverbSpam then
		ReverbSpam = GetTime()
		warnReverb:Schedule(22)
		timerNextReverb:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2105073) and (GetTime() - HardenSpam) > 5 and args.amount >= 75 and args.amount % 5 == 0 then
		HardenSpam = GetTime()
		warnHarden:Show()
	end
end

-- function mod:SPELL_AURA_REMOVED(args)
-- 	if args:IsSpellID(15732) then
-- 		-- timerImmolate:Cancel(args.destName)
-- 	end
-- end