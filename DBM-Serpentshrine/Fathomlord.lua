local mod	= DBM:NewMod("Fathomlord", "DBM-Serpentshrine")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(21214)
mod:RegisterCombat("combat", 21214)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON"
)

local warnCariPower		= mod:NewSpellAnnounce(2137927, 3)
local warnTidalPower	= mod:NewSpellAnnounce(2137928, 3)
local warnSharPower		= mod:NewSpellAnnounce(2137929, 3)
local warnBeastWithin	= mod:NewTargetAnnounce(2137939, 3)
local warnHurricane		= mod:NewSpellAnnounce(2137918, 3)
local warnHurricaneYou	= mod:NewSpecialWarningYou(2137918, 3)
local warnBlessingTides	= mod:NewAnnounce(L.BlessingTides, 2, 2137931)

local specWarnHeal		= mod:NewSpellAnnounce(2137916, 3)
local specWarnTotem		= mod:NewSpecialWarning("Move from Totem!")

local timerBlessingTides	= mod:NewNextTimer(30, 2137931)
local timerTornado			= mod:NewNextTimer(30, 38517)
local timerHeal				= mod:NewNextTimer(30, 2137916)
local timerFreeze			= mod:NewCDTimer(20, 2137909)
local timerHurricane		= mod:NewNextTimer(30, 2137918) --351370, 351371
local timerCataclysmic		= mod:NewCDTimer(9, 2137912)
local timerBeastWithin		= mod:NewNextTimer(30, 2137939)

local berserkTimer		= mod:NewBerserkTimer(720)

local CariPowerActive	= false
local TidalPowerActive	= false
local SharPowerActive	= false

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	isCasterKilled = false
	timerHeal:Start(25-delay)
	timerFreeze:Start(8-delay)
	timerTornado:Start(30-delay)
	timerHurricane:Start(11-delay)
	self:ScheduleMethod(30, "Tornado")
	timerCataclysmic:Start(10-delay)
	local CariPowerActive	= false
	local TidalPowerActive	= false
	local SharPowerActive	= false
end

function mod:Tornado()
	timerTornado:Start(30)
	self:ScheduleMethod(30, "Tornado")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2137927, 85367) then -- 85367
		warnCariPower:Show()
		CariPowerActive = true
	elseif args:IsSpellID(2137928, 85368) then -- 85368
		warnTidalPower:Show()
		TidalPowerActive = true
	elseif args:IsSpellID(2137929, 85369) then -- 85369
		warnSharPower:Show()
		SharPowerActive = true
	elseif args.spellId == 2137909 then -- Deep Freeze
		if args.sourceName == L.name then --Fathom-Lord Karathress
			timerFreeze:Start(30) -- Deep Freeze Fathom-Lord
		else
			timerFreeze:Start() -- Fathom-Guard Caribdis
		end
	elseif args:IsSpellID(2137939) then -- Beast Within
		warnBeastWithin:Show(args.destName)
		timerBeastWithin:Start()
	elseif args:IsSpellID(2137918, 2137919, 2137920, 2137921) then -- Hurricane
		warnHurricane:Show(args.destName)
		timerHurricane:Start()
		if args:IsPlayer() then
			warnHurricaneYou:Show()
		end
	elseif args:IsSpellID(2137931) then -- Blessing of the Tides
		warnBlessingTides:Show(args.destName)
		timerBlessingTides:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2137931) then -- Blessing of the Tides
		warnBlessingTides:Show(args.destName)
		timerBlessingTides:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2137916, 83535) then -- 83535
		specWarnHeal:Show()
		timerHeal:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2137912, 2137913, 2137914, 2137915) and CariPowerActive == true and TidalPowerActive == true and SharPowerActive == true then
		timerCataclysmic:Start()
	end
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 38236 then
		specWarnTotem:Show()
	end
end
