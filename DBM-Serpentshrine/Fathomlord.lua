local mod	= DBM:NewMod("Fathomlord", "DBM-Serpentshrine")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(21214)
mod:RegisterCombat("combat", 21214)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON"
)

local warnCariPower		= mod:NewSpellAnnounce(38451, 3)
local warnTidalPower	= mod:NewSpellAnnounce(38452, 3)
local warnSharPower		= mod:NewSpellAnnounce(38455, 3)
local warnBeastWithin	= mod:NewTargetAnnounce(351373, 3)

local specWarnHeal		= mod:NewSpellAnnounce(83535, 3)
local specWarnTotem		= mod:NewSpecialWarning("Move from Totem!")

local timerHeal			= mod:NewNextTimer(30, 83535)
local timerFreeze		= mod:NewCDTimer(18, 38357)
local timerCataclysmic	= mod:NewCDTimer(9, 38441)
local timerBeastWithin	= mod:NewNextTimer(30, 351373)

local berserkTimer		= mod:NewBerserkTimer(720)

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	isCasterKilled = false
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(38451, 85367) then -- 85367
		warnCariPower:Show()
	elseif args:IsSpellID(38452, 85368) then -- 85368
		warnTidalPower:Show()
	elseif args:IsSpellID(38455, 85369) then -- 85369
		warnSharPower:Show()
	elseif args.spellId == 38357 then -- Deep Freeze Caribdis
		if isCasterKilled == false then
			timerFreeze:Start()
		else
			timerFreeze:Start(30) -- Deep Freeze Fathom-Lord
		end
	elseif args:IsSpellID(351373) then -- Beast Within
		warnBeastWithin:Show(args.destName)
		timerBeastWithin:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(38330, 83535) then -- 83535
		specWarnHeal:Show(args.sourceName)
		timerHeal:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(38441, 351365, 351366) then
		timerCataclysmic:Start()
	end
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 38236 then
		specWarnTotem:Show()
		-- specWarnTotem:Play("attacktotem")
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 21964 then
		isCasterKilled = true
	end
end
