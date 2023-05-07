local mod	= DBM:NewMod("Gluth", "DBM-Naxx", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2869 $"):sub(12, -3))
mod:SetCreatureID(15932)
mod:RegisterCombat("combat")
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_DAMAGE",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE"
)

-----DECIMATE-----
local warnDecimateSoon	= mod:NewSoonAnnounce(2122905, 2)
local warnDecimateNow	= mod:NewSpellAnnounce(2122905, 3)
local timerDecimate		= mod:NewNextTimer(120, 2122905)
-------MOOD--------
local warnHungry		= mod:NewAnnounce("Gluth is Hungry", 2, 2122903, nil, "Show a warning when Gluth gets hungry")
local warnAngry			= mod:NewAnnounce("Gluth is Angry", 2, 2122904, nil, "Show a warning when Gluth gets angry")
local warnViciousStacks = mod:NewAnnounce("Vicious Strike stacks", 2, 2122901, nil, "Show a warning when Tanks gets the Vicious debuff")
-----MISC-----
local enrageTimer		= mod:NewBerserkTimer(480)

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
		if args.amount >= 4 then
			warnViciousStacks:Show(args.spellName, args.amount)
		end
	end
	if args:IsSpellID(2122904) then
		if args.amount >=2 then
			warnAngry:Show(args.spellName, args.amount)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2122904) then
		warnAngry:Show(args.spellName, args.amount)
	end
	if args:IsSpellID(2122903) then
		warnHungry:Show()
	end
end
