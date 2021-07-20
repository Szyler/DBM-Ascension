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
local warnHurricane		= mod:NewSpellAnnounce(83541, 3)
local warnHurricaneYou	= mod:NewSpecialWarningYou(83541, 3)
local warnBlessingTides	= mod:NewAnnounce(L.BlessingTides, 2, 351302)

local specWarnHeal		= mod:NewSpellAnnounce(83535, 3)
local specWarnTotem		= mod:NewSpecialWarning("Move from Totem!")

local timerBlessingTides= mod:NewNextTimer(30, 351302)
local timerHeal			= mod:NewNextTimer(30, 83535)
local timerFreeze		= mod:NewCDTimer(18, 38357)
local timerHurricane	= mod:NewNextTimer(30, 83541) --351370, 351371
local timerCataclysmic	= mod:NewCDTimer(9, 38441)
local timerBeastWithin	= mod:NewNextTimer(30, 351373)

local berserkTimer		= mod:NewBerserkTimer(720)

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	isCasterKilled = false
	timerHeal:Start(25)
	timerFreeze:Start(7)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(38451, 85367) then -- 85367
		warnCariPower:Show()
	elseif args:IsSpellID(38452, 85368) then -- 85368
		warnTidalPower:Show()
	elseif args:IsSpellID(38455, 85369) then -- 85369
		warnSharPower:Show()
	elseif args.spellId == 38357 then -- Deep Freeze
		if args.sourceName == L.name then --Fathom-Lord Karathress
			timerFreeze:Start(30) -- Deep Freeze Fathom-Lord
		else
			timerFreeze:Start() -- Fathom-Guard Caribdis
		end
	elseif args:IsSpellID(351373) then -- Beast Within
		warnBeastWithin:Show(args.destName)
		timerBeastWithin:Start()
	elseif args:IsSpellID(83541, 351370, 351371) then -- Hurricane
		warnHurricane:Show(args.destName)
		timerHurricane:Start()
		if args:IsPlayer() then
			warnHurricaneYou:Show()
		end
	elseif args:IsSpellID(351302) then -- Blessing of the Tides
		warnBlessingTides:Show(args.destName)
		timerBlessingTides:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(351302) then -- Blessing of the Tides
		warnBlessingTides:Show(args.destName)
		timerBlessingTides:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(38330, 83535) then -- 83535
		specWarnHeal:Show()
		timerHeal:Start()
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
