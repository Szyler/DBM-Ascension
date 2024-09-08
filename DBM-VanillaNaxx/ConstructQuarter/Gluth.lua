local mod	= DBM:NewMod("Gluth", "DBM-Naxx", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2869 $"):sub(12, -3))
mod:SetCreatureID(15932)
mod:RegisterCombat("combat")
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_DAMAGE",
	"PLAYER_ALIVE",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"UNIT_DIED"
)

-----DECIMATE-----
local warnDecimateSoon		= mod:NewSoonAnnounce(2122905, 2)
local warnDecimateNow		= mod:NewSpellAnnounce(2122905, 2)
local timerDecimate			= mod:NewNextTimer(120, 2122905)
local timerFeedFrenzy 		= mod:NewTimer(30, "Gluth is in a Frenzy", 2122923)
-------MOOD--------
local warnHungry			= mod:NewAnnounce("Gluth is Hungry", 2, 2122903, nil, "Show a warning when Gluth gets hungry")
local specWarnAngry			= mod:NewSpecialWarning("%s on >%s< (%d)", 2, 2122904)
local warnViciousStacks		= mod:NewAnnounce("%s on >%s< (%d)", 2, 2122901)
local SpecWarnVicStacks 	= mod:NewSpecialWarningStack(2122901, 2)

-----MISC-----
local enrageTimer			= mod:NewBerserkTimer(480)

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	enrageTimer:Start(480 - delay)
	timerDecimate:Start(120 - delay)
	warnDecimateSoon:Schedule(115 - delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2122905)then
		warnDecimateNow:Show()
		timerDecimate:Start()
		warnDecimateSoon:Schedule(115)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2122901) then
		if args:IsPlayer() then
			SpecWarnVicStacks:Show(args.amount)
		else
			warnViciousStacks:Show(args.spellName, args.destName, args.amount or 1)
		end
	elseif args:IsSpellID(2122904) then
		if args.amount >=1 then
			specWarnAngry:Show(args.spellName, args.destName, args.amount or 1)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2122901) then
		if args:IsPlayer() then
			SpecWarnVicStacks:Show(args.amount or 1)
		else
			warnViciousStacks:Show(args.spellName, args.destName, args.amount or 1)
		end
	elseif args:IsSpellID(2122904) then
		specWarnAngry:Show(args.spellName, args.destName, args.amount or 1)
	elseif args:IsSpellID(2122903) then
		warnHungry:Show()
	elseif args:IsSpellID(2122923) and (args.destName == "Gluth") then
		timerFeedFrenzy:Start()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 15932 or cid == 26628 then
		timerDecimate:Stop()
	end
end

function mod:OnCombatEnd()
	timerDecimate:Stop()
end

--Vicious Strike debuff 2122901 || Feeding Frenzy 2122923
--DBM_MOROES_GARROTE		= "%s on >%s< (%d)" --(args.spellName, args.destName, args.amount or 1)
--local warningGarrote		= mod:NewAnnounce(DBM_GLUTH_VICIOUS_BITE, 3, 37066)
--warningGarrote:Show(args.spellName, args.destName, args.amount or 1)
--L:SetWarningLocalization{
