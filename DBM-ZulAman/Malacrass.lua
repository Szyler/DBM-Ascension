local mod	= DBM:NewMod("Malacrass", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20210404052635")
mod:SetCreatureID(24239)
mod:RegisterCombat("combat_yell", L.YellPull)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON"
)

--TODO, GTFO for standing in shit
local warnSiphon	= mod:NewTargetAnnounce(43501, 3)
local warnBoltSoon	= mod:NewPreWarnAnnounce(43383, 5, 3)
local warnHeal1		= mod:NewCastAnnounce(43548, 3)
local warnHeal2		= mod:NewCastAnnounce(43451, 3)
local warnHeal3		= mod:NewCastAnnounce(43431, 3)
local warnHeal4		= mod:NewTargetAnnounce(43421, 3)
local warnPatch		= mod:NewSpellAnnounce(43429, 3)

local specWarnBolt	= mod:NewSpecialWarningSpell(43383, nil, nil, nil, 2, 2)
local specWarnHeal1	= mod:NewInterruptAnnounce(43548)
local specWarnHeal2	= mod:NewInterruptAnnounce(43451)
local specWarnHeal3	= mod:NewInterruptAnnounce(43431)
local specWarnHeal4	= mod:NewSpecialWarningDispel(43421)
local specWarnTotem	= mod:NewSpecialWarningSwitch(43436)

local timerSiphon	= mod:NewTargetTimer(30, 43501, nil, nil, nil, 6)
local timerBoltCD	= mod:NewCDTimer(41, 43383, nil, nil, nil, 2, nil, DBM_CORE_L.HEALER_ICON)
local timerBolt		= mod:NewCastTimer(10, 43383, nil, nil, nil, 5, nil, DBM_CORE_L.HEALER_ICON)
local timerPatch	= mod:NewCastTimer(20, 43429, nil, nil, nil, 3)

function mod:OnCombatStart(delay)
	timerBoltCD:Start(30)
	warnBoltSoon:Schedule(25)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(43501) then
		warnSiphon:Show(args.destName)
		timerSiphon:Show(args.destName)
	elseif args:IsSpellID(43421) and not args:IsDestTypePlayer() then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHeal4:Show(args.destName)
			specWarnHeal4:Play("dispelboss")
		else
			warnHeal4:Show(args.destName)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(43548) then
		if self.Options.SpecWarn43548interrupt and self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHeal1:Show(args.sourceName)
			specWarnHeal1:Play("kickcast")
		else
			warnHeal1:Show()
		end
	elseif args:IsSpellID(43451) then
		if self.Options.SpecWarn43451interrupt and self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHeal2:Show(args.sourceName)
			specWarnHeal2:Play("kickcast")
		else
			warnHeal2:Show()
		end
	elseif args:IsSpellID(43431) then
		if self.Options.SpecWarn43431interrupt and self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHeal3:Show(args.sourceName)
			specWarnHeal3:Play("kickcast")
		else
			warnHeal3:Show()
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(43383) then
		specWarnBolt:Show()
		specWarnBolt:Play("aesoon")
		warnBoltSoon:Schedule(35)
		timerBolt:Start()
		timerBoltCD:Start()
	elseif args:IsSpellID(43329) then
		warnPatch:Show()
		timerPatch:Start()
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(43436) then
		specWarnTotem:Show()
		specWarnTotem:Play("attacktotem")
	end
end
