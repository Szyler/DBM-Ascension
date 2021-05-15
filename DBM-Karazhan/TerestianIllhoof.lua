local mod	= DBM:NewMod("TerestianIllhoof", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(15688)

mod:SetBossHealthInfo(
	15688, L.name,
	17229, L.Kilrek
)

mod:RegisterCombat("yell", L.DBM_TI_YELL_PULL)
--mod:RegisterCombat("combat", 15688)
--17229--imp, for future use

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS",
	"UNIT_DIED"
)

local warningWeakened	= mod:NewTargetAnnounce(30065, 2)
local warningImpSoon	= mod:NewSoonAnnounce(30066, 2)
local warningImp		= mod:NewSpellAnnounce(30066, 3)
local warningSacSoon	= mod:NewSoonAnnounce(85190, 3)
local warningSacrifice	= mod:NewTargetAnnounce(85190, 4)
local warnCurse			= mod:NewTargetAnnounce(85275, 3)
local warnLink			= mod:NewTargetAnnounce(85277, 3)

local specWarnSacrifice	= mod:NewSpecialWarningYou(85190)
local specWarnCurse		= mod:NewSpecialWarningYou(85275)

local timerWeakened		= mod:NewBuffActiveTimer(31, 30065)
local timerSacrifice	= mod:NewTargetTimer(30, 85190)
local timerSacrificeCD	= mod:NewNextTimer(43, 85190)
local TimerCurseDur		= mod:NewTargetTimer(10, 85275)
local timerNextCurse	= mod:NewNextTimer(20, 85275)
local timerLink			= mod:NewTargetTimer(10, 85277)
local timerAmplifyCD	= mod:NewNextTimer(9, 85289)

local berserkTimer		= mod:NewBerserkTimer(600)

mod:AddBoolOption("HealthFrame", true)

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerSacrificeCD:Start(30-delay)
	timerNextCurse:Start(20-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(85190) then
		DBM.BossHealth:AddBoss(17248, L.DChains)
		warningSacrifice:Show(args.destName)
		timerSacrifice:Start(args.destName)
		timerSacrificeCD:Start()
		warningSacSoon:Cancel()
		warningSacSoon:Schedule(38)
		if args:IsPlayer() then
			specWarnSacrifice:Show()
		end
	elseif args:IsSpellID(30065) then
		warningWeakened:Show(args.destName)
		timerWeakened:Start()
		warningImpSoon:Schedule(26)
		timerLink:Cancel()
		timerAmplifyCD:Cancel()
	elseif args:IsSpellID(85275) then
		warnCurse:Show(args.destName)
		TimerCurseDur:Start(args.destName)
		timerNextCurse:Start()
		if args:IsPlayer() then
			specWarnCurse:Show()
		end
	elseif args:IsSpellID(85277) then
		warnLink:Show(args.destName)
		timerLink:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(85190) then
		timerSacrifice:Cancel(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(30066) then
		warningImpSoon:Cancel()
		warningImp:Show()
		DBM.BossHealth:AddBoss(17229, L.Kilrek)
	elseif args:IsSpellID(85289) then
		timerAmplifyCD:Start()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 17229 then--Kil'rek
		DBM.BossHealth:RemoveBoss(cid)
		timerLink:Cancel()
		timerAmplifyCD:Cancel()
	elseif cid == 17248 then--Demon Chains
		DBM.BossHealth:RemoveBoss(cid)
	end
end
