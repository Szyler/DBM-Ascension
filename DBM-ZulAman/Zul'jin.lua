local mod	= DBM:NewMod("ZulJin", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(23863)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"SPELL_DAMAGE",
	"UNIT_DIED",
	"UNIT_AURA",
	"CHAT_MSG_MONSTER_YELL"
)

local warnThrow					= mod:NewTargetAnnounce(43093, 3)
local warnClaw					= mod:NewTargetAnnounce(2136377, 3) --2136377, 2136378, 2136379, 2136380, 2136381
local warnFlame					= mod:NewSpellAnnounce(2135908, 3) --2135908, 2135909, 2135910, 2135911, 2135912
		
local warnPhase1				= mod:NewPhaseAnnounce(1)
local warnPhase2				= mod:NewPhaseAnnounce(2)
local warnPhase3				= mod:NewPhaseAnnounce(3)
local warnPhase4				= mod:NewPhaseAnnounce(4)

local warnPhaseBerserk			= mod:NewPhaseAnnounce(5) --2136318, 2136319

local warnPhaseEagle			= mod:NewSpecialWarningSpell(2136336) --2136336, Shape of the Bear, ASC D0 T5
local timerNextTurbulentWinds	= mod:NewNextTimer(15, 2136342) --2136342, 2136343, 2136344, 2136345, 2136346
local timerCastTurbulentWinds	= mod:NewCastTimer(5, 2136343) --2136342, 2136343, 2136344, 2136345, 2136346
local timerNextLightningWall	= mod:NewNextTimer(10, 2136349) --2136348, 2136349, 2136350, 2136351, 2136352
local timerNextStorm			= mod:NewNextTimer(50, 2136429) --2136429, 2136430, 2136431, 2136432, 2136433, 2136434
local timerStorm				= mod:NewCastTimer(10, 2136429) --2136429, 2136430, 2136431, 2136432, 2136433, 2136434
local nextLightningStrike 		= mod:NewNextTimer(10, 2136429)
local specWarnTurbulentWinds	= mod:NewSpecialWarningYou(2136342)
local warnTurbulentWindsTarget 	= mod:NewTargetAnnounce(2136342, 4)
local warnStorm					= mod:NewTargetAnnounce(2135724, 4)
local specWarnStorm				= mod:NewSpecialWarningSpell(2135724)

local warnPhaseBear				= mod:NewSpecialWarningSpell(2136337) --2136337, Shape of the Eagle, ASC D0 T5
local timerNextDeafeningRoar	= mod:NewNextTimer(15, 2135829) --2135829, 2135830, 2135831, 2135832
local timerNextStampede			= mod:NewNextTimer(10, 2136332) --2136332, 2136333, 2136334, 2136335


local warnPhaseDragonhawk		= mod:NewSpecialWarningSpell(2136357) --2136357, Shape of the Dragonhawk, ASC D0 T5
local timerNextScorchingBreath	= mod:NewNextTimer(26, 2136358) --2136358, 2136359, 2136360, 2136361, 2136362
local timerNextArmageddon		= mod:NewNextTimer(23, 2136372) --2136372, 2136373, 2136374, 2136375
local specWarnBomb				= mod:NewSpecialWarningSpell(2136404) --2136402, 2136403, 2136404, 2136405, 2136406, 2136407
local timerNextBomb				= mod:NewNextTimer(37, 2136404) --2136402, 2136403, 2136404, 2136405, 2136406, 2136407
local timerBombCast					= mod:NewCastTimer(7, 2136402) --2136402, 2136403, 2136404, 2136405, 2136406, 2136407
local timerNextFlameWhirl		= mod:NewNextTimer(50, 2135908)
local timerFlameWhirlCast			= mod:NewCastTimer(6, 2135908)



local warnPhaseLynx				= mod:NewSpecialWarningSpell(2136376) --2136376, Shape of the Lynx, ASC D0 T5
local timerNextLynxRush			= mod:NewNextTimer(24, 2136382) --2136382, 2136383, 2136384, 2136385
local specWarnSpiritLink		= mod:NewSpecialWarningRun(2136414) --2136413, 2136414, 2136415, 2136416, 2136417
		
local timerNextGrievous			= mod:NewNextTimer(10, 2136300) --2136301, 2136302, 2136303
local timerNextWhirlwind		= mod:NewNextTimer(45, 2136316) --2136316, Whirlwind
local timerNextImpale			= mod:NewNextTimer(45, 2136304) --2136304, 2136305, 2136306, 2136307, 2136308, 2136309

mod.vb.phase = 1
local eosSpam = 0


function mod:PhaseIncrease()
	if self.vb.phase == 2 then
		warnPhase2:Show()
	elseif self.vb.phase == 3 then
		warnPhase3:Show()
	elseif self.vb.phase == 4 then
		warnPhase4:Show()
	end
end

function mod:WallMechanic(wallType)
	if wallType == "Bear" then
		timerNextStampede:Start()
		self:ScheduleMethod(10, "WallMechanic", "Bear")
	elseif wallType == "Lightning" then
		timerNextLightningWall:Start()
		self:ScheduleMethod(10, "WallMechanic", "Lightning")
	end
end

function mod:LightningStrike()
	self:UnscheduleMethod("LightningStrike")
	nextLightningStrike:Start()
	self:ScheduleMethod(10,"LightningStrike")
end

function mod:TurbulentWinds()
	local target = nil
	local myName = UnitName("player")
	target = mod:GetBossTarget(80468) -- need to confirm ID !
	if target == myName then
		specWarnTurbulentWinds:Show(target)
		SendChatMessage(L.DBM_TURBULENT_WINDS,  "YELL")
	else
		warnTurbulentWindsTarget:Show(target)
	end

end

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	timerNextGrievous:Start(5)
	timerNextImpale:Start(12)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2136301) then
		warnThrow:Show(args.destName)
	elseif args:IsSpellID(2136301, 2136302, 2136303) then
		timerNextGrievous:Start()
	elseif args:IsSpellID(2136378, 2136379, 2136380, 2136381) then
		warnClaw:Show(args.destName)
	--elseif args:IsSpellID(2135909) then
	--	warnFlame:Show()
	elseif args:IsSpellID(2136318, 2136319) then
		warnPhaseBerserk:Show()
		self.vb.phase = 5
		timerNextGrievous:Start(7)
		timerNextImpale:Start(15)
		timerNextWhirlwind:Start(33)
	elseif args:IsSpellID(2136436, 2136196) then --Phase 6-7-8-9
		if args.sourceName == "Akil'zon" then
			self.vb.phase = self.vb.phase + 1
			self:PhaseIncrease()
			warnPhaseEagle:Show()
			nextLightningStrike:Start(21)
			self:ScheduleMethod(21,"LightningStrike")
			timerNextStorm:Start(5)
		elseif args.sourceName == "Nalorakk" then
			self.vb.phase = self.vb.phase + 1
			self:PhaseIncrease()
			warnPhaseBear:Show()
		elseif args.sourceName == "Jan'alai" then
			self.vb.phase = self.vb.phase + 1
			self:PhaseIncrease()
			warnPhaseDragonhawk:Show()
			timerNextBomb:Start(7)
			timerNextScorchingBreath:Start(22)
		elseif args.sourceName == "Halazzi" then
			self.vb.phase = self.vb.phase + 1
			self:PhaseIncrease()
			warnPhaseLynx:Show()
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2136336) then --Phase 2-3-4-5
		warnPhaseEagle:Show()
		timerNextTurbulentWinds:Start()
		self:ScheduleMethod(10, "WallMechanic", "Lightning")
		self:PhaseIncrease()
	elseif args:IsSpellID(2136337) then --Phase 2-3-4-5
		warnPhaseBear:Show()
		timerNextDeafeningRoar:Start(8)
		timerNextStampede:Start()
		self:ScheduleMethod(10, "WallMechanic", "Bear")
		self:PhaseIncrease()
	elseif args:IsSpellID(2136357) then --Phase 2-3-4-5
		warnPhaseDragonhawk:Show()
		timerNextScorchingBreath:Start()
		timerNextArmageddon:Start()
		timerNextFlameWhirl:Start(1.5)
		self:PhaseIncrease()
	elseif args:IsSpellID(2136376) then --Phase 2-3-4-5
		warnPhaseLynx:Show()
		self:PhaseIncrease()
		timerNextLynxRush:Start()
	elseif args:IsSpellID(2136316) then
		timerNextWhirlwind:Start()
	elseif args:IsSpellID(2136402) then
		timerBombCast:Start()
		specWarnBomb:Show()
	elseif args:IsSpellID(2136363) then
		timerFlameWhirlCast:Start()
		timerNextFlameWhirl:Start() -- timer is probably wrong
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2136342) then
		timerNextTurbulentWinds:Start()
		timerCastTurbulentWinds:Start()
		self:ScheduleMethod(0.2, "TurbulentWinds")
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2135829, 2135830, 2135831, 2135832) and DBM:AntiSpam() then
		timerNextDeafeningRoar:Start()
	elseif args:IsSpellID(2136414, 2136415, 2136416, 2136417) and args:IsPlayer() and DBM:AntiSpam(1) then --2136413, 2136414, 2136415, 2136416, 2136417
		specWarnSpiritLink:Show()
	end
end

-- function mod:UNIT_AURA(unit) -- triggers from Akilzon (same code)
-- 	local Name = UnitName(unit)
-- 	if (UnitDebuff(unit, "Eye of the storm")) and (GetTime() - eosSpam) > 15  then
-- 		eosSpam = GetTime()
-- 		timerStorm:Start()
-- 		warnStorm:Show(Name)
-- 		specWarnStorm:Show()
-- 		-- timerNextStorm:Start()
-- 		if Name == UnitName("player") then
-- 			SendChatMessage(L.DBM_EOS_PLAYER, "YELL")
-- 		end
-- 	end
-- end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	self:UnscheduleMethod("LightningStrike")
end

function mod:UNIT_DIED(args)
	if args.destName == "Akil'zon" then
		self.vb.phase = self.vb.phase + 1
	elseif args.destName == "Nalorakk" then
		self.vb.phase = self.vb.phase + 1
	elseif args.destName == "Jan'alai" then
		self.vb.phase = self.vb.phase + 1
	elseif args.destName == "Halazzi" then
		self.vb.phase = self.vb.phase + 1
	else 
		return
	end
	print("Should only appear if phase = 10, otherwise contact DBM developers.")
end
