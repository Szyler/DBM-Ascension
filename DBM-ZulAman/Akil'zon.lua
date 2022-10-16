local mod	= DBM:NewMod("Akilzon", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(23574)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"UNIT_AURA",
	"UNIT_HEALTH"
)

local warnVortexSoon			= mod:NewSoonAnnounce(2135733, 5, 3)

local timerNextStorm			= mod:NewNextTimer(50, 2135724)
local timerStorm				= mod:NewCastTimer(10, 2135724)
local nextLightningStrike 		= mod:NewNextTimer(10, 2135702)
local timerNextVortex			= mod:NewNextTimer(10, 2135733)
local timerNextRod				= mod:NewNextTimer(20, 2135700)

local timerNextTurbulentWinds	= mod:NewNextTimer(3, 2135710)
local timerCastTurbulentWinds	= mod:NewCastTimer(5, 2135710)
local specWarnTurbulentWinds	= mod:NewSpecialWarningYou(2135710)
local warnTurbulentWindsTarget 	= mod:NewTargetAnnounce(2135710, 4)
local warnStorm					= mod:NewTargetAnnounce(2135724, 4)
local specWarnStorm				= mod:NewSpecialWarningSpell(2135724)
local specWarnRodYou			= mod:NewSpecialWarningYou(2135700)
local specWarnRod				= mod:NewSpecialWarningTarget(2135700, false)
local warnTalon					= mod:NewTargetAnnounce(2135747)
local warnTalonStacks			= mod:NewSpecialWarningStack(2135747)

local berserkTimer				= mod:NewBerserkTimer(600)

local eosSpam = 0

mod:SetUsedIcons(1)
mod:AddBoolOption(L.RodYellOpt)
mod:AddBoolOption("RangeFrame", true)
mod:AddBoolOption("StormIcon")
local platform1, platform2, platform3, platform4 = true , true , true , true

function mod:LightningStrike()
	self:UnscheduleMethod("LightningStrike")
	nextLightningStrike:Start()
	self:ScheduleMethod(10,"LightningStrike")
end

function mod:TurbulentWinds()
	local target = nil
	target = mod:GetBossTarget(23574)
	if target == UnitName("player") then
		specWarnTurbulentWinds:Show(target)
		SendChatMessage(L.DBM_TURBULENT_WINDS,  "YELL")
	else
		warnTurbulentWindsTarget:Show(target)
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerNextStorm:Start(40)
	nextLightningStrike:Start(6.5)
	timerNextRod:Start(13)
	self:ScheduleMethod(6.5,"LightningStrike")
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show()
	end
	self.vb.phase = 1
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	self:UnscheduleMethod("LightningStrike")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2135700) then
		timerNextRod:Start()
		specWarnRod:Show(args.destName)
		if args:IsPlayer() then
			specWarnRodYou:Show()
			if self.Options.RodYellOpt and args:IsPlayer() then
				SendChatMessage(L.DBM_ROD_PLAYER, "YELL")
			end
		end
	elseif args:IsSpellID(2135747, 2135748, 2135749, 2135750) then
		warnTalon:Show(args.destName)
		if args.amount and args.amount > 5 then
			warnTalonStacks:Show(args.amount,args.destName)
		end
	elseif args:IsSpellID(2135715) then
		self:UnscheduleMethod("LightningStrike")
		nextLightningStrike:Cancel()
		timerNextRod:Cancel()
		self.vb.phase = 2
		timerNextTurbulentWinds:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2135710) then
		timerCastTurbulentWinds:Start()
		self:ScheduleMethod(0.2, "TurbulentWinds")
	end
end

function mod:UNIT_HEALTH(unit)
	
	if (self.vb.phase == 2) and (mod:GetUnitCreatureId(unit) == 23574) then
		local hp = (math.max(0,UnitHealth(unit)) / math.max(1, UnitHealthMax(unit))) * 100;
		if (hp>60 and hp<=65) and platform1 then
			warnVortexSoon:Show()
			platform1 = false
			timerNextTurbulentWinds:Start(6)
		elseif (hp>50 and hp<=55) and platform2  then
			warnVortexSoon:Show()
			platform2 = false
			timerNextTurbulentWinds:Start(6)
		elseif (hp>40 and hp<=45) and platform3  then
			warnVortexSoon:Show()
			platform3 = false
			timerNextTurbulentWinds:Start(6)
		elseif (hp>30 and hp<=35) and platform4 then
			warnVortexSoon:Show()
			platform4 = false
			timerNextTurbulentWinds:Start(6)
		elseif (hp<=30) then
			self.vb.phase = 3
			timerNextVortex:Start()
			nextLightningStrike:Start(21)
			self:ScheduleMethod(21, "LightningStrike")
			timerNextRod:Start(28)
		end
	end

function mod:UNIT_AURA(unit)
	local Name = UnitName(unit)
	if (UnitDebuff(unit, "Eye of the storm")) and (GetTime() - eosSpam) > 15  then
		eosSpam = GetTime()
		timerStorm:Start()
		warnStorm:Show(Name)
		specWarnStorm:Show()
		timerNextStorm:Start()
		if Name == UnitName("player") then
			SendChatMessage(L.DBM_EOS_PLAYER, "YELL")
		end
	end
end

end
