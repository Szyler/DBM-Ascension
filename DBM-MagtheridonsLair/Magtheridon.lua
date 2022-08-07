local mod		= DBM:NewMod("Magtheridon", "DBM-MagtheridonsLair")
local L			= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))
mod:SetCreatureID(17256, 17257)
mod:RegisterCombat("combat")
mod:SetMinCombatTime(120)

mod:RegisterEvents(
		"SPELL_AURA_APPLIED",
		"SPELL_CAST_START",
		"SPELL_CAST_SUCCESS",
		"SPELL_AURA_REMOVED",
		"CHAT_MSG_MONSTER_YELL",
		"CHAT_MSG_MONSTER_EMOTE",
		"CHAT_MSG_RAID_BOSS_EMOTE",
		"SPELL_DAMAGE",
		"SPELL_SUMMON",
		"UNIT_HEALTH",
		"SPELL_MISSED"
)

local WarnInfernal		= mod:NewSpellAnnounce(30511, 2)
local WarnHeal			= mod:NewCastAnnounce(30528, 2, nil, false)
local WarnNova			= mod:NewSpellAnnounce(30616, 2)
local specWarnNova		= mod:NewSpecialWarning("Pre-Quake Blast Nova in 10 seconds!")
local WarnQuake			= mod:NewSpellAnnounce(85026, 2)
local specWarnDebris	= mod:NewSpecialWarningYou(85030)
local specWarnConflag	= mod:NewSpecialWarningYou(351085)
local warnMortalCleave	= mod:NewAnnounce(L.MagCleave, 2, 85178)
local warnInterrupt		= mod:NewAnnounce("Magtheridon interrupted", 3, "Interface\\Icons\\ability_kick")
local warnPhaseTwo		= mod:NewAnnounce("Magtheridon is free!", 3, "Interface\\Icons\\Achievement_Boss_Magtheridon")
local warnPhaseThree	= mod:NewAnnounce("Phase 3", 3, "Interface\\Icons\\Achievement_Boss_Magtheridon")

local timerQuake		= mod:NewNextTimer(60, 85026)
local timerSpecialNova	= mod:NewTimer(55, "!!Pre-Quake Blast Nova!!", 30616, 3)
local Nova				= 1;
local timerNova			= mod:NewTimer(55, "Blast Nova #%s", 30616)
local timerPhaseTwo		= mod:NewPhaseTimer(120, 30205, "Magtheridon breaks free")
local timerFallingRoof	= mod:NewTimer(10, "Roof is collapsing!")

--Heroic
-- local AnnounceHandofDeath 	= mod:NewTargetAnnounce(85437,2)
local specWarnYouHand			= mod:NewSpecialWarningYou(85437)
local warnHandofDeath			= mod:NewTargetAnnounce(85437, 3.8)
local timerHandofDeath			= mod:NewTargetTimer(4, 85437)
local timerNextHandofDeath		= mod:NewNextTimer(30, 85437)

-- local AnnounceFingerofDeath 	= mod:NewTargetAnnounce(85408,2)
local specWarnYouFinger			= mod:NewSpecialWarningYou(85408)
local warnFingerofDeath			= mod:NewTargetAnnounce(85408, 3.8)
local timerFingerofDeath		= mod:NewTargetTimer(4, 85408)
local timerNextFingerofDeath	= mod:NewNextTimer(30, 85408)

local specWarnYouFelShock		= mod:NewSpecialWarningYou(85407)
local timerNextFelShock			= mod:NewNextTimer(11, 85407)

-- local 
local isMag				= false;
local below30			= false;
local deathAbility = 0;

function mod:HandofDeath()
	local target = nil
	target = mod:GetBossTarget(17257)
	local myName = UnitName("player")
	if target == myName then
		specWarnYouHand:Show()
		SendChatMessage("Hand of Death on "..UnitName("PLAYER")..", STACK ON ME!", "YELL")
	else
		warnHandofDeath:Show(target)
	end
	timerHandofDeath:Start(target)
	self:SetIcon(target, 8, 3)
end

function mod:FingerofDeath()
	local target = nil
	target = mod:GetBossTarget(17257)
	local myName = UnitName("player")
	if target == myName then
		specWarnYouFinger:Show()
		SendChatMessage("Finger of Death on "..UnitName("PLAYER")..", RUN AWAY!", "YELL")
	else
		warnFingerofDeath:Show(target)
	end
	timerFingerofDeath:Start(target)
		self:SetIcon(target, 8, 3)
end

function mod:OnCombatStart(delay)
	Nova = 1;
	timerPhaseTwo:Start()
	below30 = false;
	self.vb.phase = 1
end

function mod:NextFingerofDeath()							
	self:UnscheduleMethod("NextFingerofDeath")
	timerNextFingerofDeath:Start()
	deathAbility=1
	self:ScheduleMethod(30,"NextFingerofDeath")
end

function mod:NextHandofDeath()							
	self:UnscheduleMethod("NextHandofDeath")
	timerNextHandofDeath:Start()
	deathAbility=2
	self:ScheduleMethod(30,"NextHandofDeath")
end

function mod:OnCombatEnd()
	timerQuake:Cancel()
	timerSpecialNova:Cancel()
	timerNova:Cancel()
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(85030) and args:IsPlayer() then
		specWarnDebris:Show()
	elseif args:IsSpellID(30168) then
		warnInterrupt:Show()
	elseif args:IsSpellID(85405) then
		 if args.destName == UnitName("player") then
			-- SendChatMessage("Fel Shock on "..UnitName("PLAYER")..", STACK ON ME!", "YELL")
			specWarnYouFelShock:Show()
		end
		timerNextFelShock:Start()
	elseif args:IsSpellID(30619) then
		warnMortalCleave:Show(args.spellName, args.destName, args.amount or 1)
	elseif args:IsSpellID(351085) then
		if args.destName == UnitName("player") then
			specWarnConflag:Show()
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(30619) and args.amount >= 4 then
		warnMortalCleave:Show(args.spellName, args.destName, args.amount or 1)
	elseif args:IsSpellID(351085) then
		if args.destName == UnitName("player") then
			specWarnConflag:Show()
		end
	end
end

-- function mod:SPELL_AURA_REMOVED(args)
-- 	if args:IsSpellID(30205) then
-- 		timerQuake:Start(41)
-- 		timerNova:Start(66, tostring(Nova))
-- 		timerNextFingerofDeath:Start(21)
-- 		timerNextHandofDeath:Start(36)
-- 		below30 = false;
-- 		isMag	= true;
-- 		warnPhaseTwo:Show()
-- 		timerPhaseTwo:Cancel()
-- 	end
-- end

--function mod:CHAT_MSG_RAID_BOSS_EMOTE(args)
--	if msg == L.DBM_MAG_EMOTE_PHASE2 and self.vb.phase == 1 then
--		timerQuake:Cancel()
--		timerNova:Cancel()
--		if mod:IsDifficulty("heroic10", "heroic25") then
--			timerNextFingerofDeath:Start(21)
--			timerNextHandofDeath:Start(36)
--			self:ScheduleMethod(21,"NextFingerofDeath");
--			self:ScheduleMethod(36,"NextHandofDeath");
--		end
--		timerPhaseTwo:Cancel()
--		self.vb.phase = 2
--		timerQuake:Start(41)
--		timerNova:Start(66, tostring(Nova))
--		below30 = false;
--		isMag	= true;
--		warnPhaseTwo:Show()
--	end
--end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_MAG_YELL_PHASE2 and self.vb.phase == 1 then
		timerQuake:Cancel()
		timerNova:Cancel()
		if mod:IsDifficulty("heroic10", "heroic25") then
		timerNextFingerofDeath:Start(21)
			timerNextHandofDeath:Start(36)
			self:ScheduleMethod(21,"NextFingerofDeath");
			self:ScheduleMethod(36,"NextHandofDeath");
		end
		timerPhaseTwo:Cancel()
		timerQuake:Start(41)
		timerNova:Start(66, tostring(Nova))
		below30 = false;
		isMag	= true;
		self.vb.phase = 2
		warnPhaseTwo:Show()
	end
	if msg == L.DBM_MAG_YELL_PHASE3 then
		warnPhaseThree:Show()
		timerFallingRoof:Start()
		if mod:IsDifficulty("heroic10", "heroic25") then
			timerNextFingerofDeath:Cancel()
			timerNextHandofDeath:Cancel()
			self:UnscheduleMethod("NextFingerofDeath")
			self:UnscheduleMethod("NextHandofDeath")
			if deathAbility == 2 then
				timerNextFingerofDeath:Start(21)
				timerNextHandofDeath:Start(36)
				self:ScheduleMethod(21,"NextFingerofDeath");
				self:ScheduleMethod(36,"NextHandofDeath");
			else
				timerNextFingerofDeath:Start(36)
				timerNextHandofDeath:Start(21)
				self:ScheduleMethod(36,"NextFingerofDeath");
				self:ScheduleMethod(21,"NextHandofDeath");
			end
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(30528) then
		WarnHeal:Show()
	elseif args:IsSpellID(85026) then
		WarnQuake:Show()
		timerQuake:Start()
	elseif args:IsSpellID(30616) then
		Nova = Nova + 1;
		WarnNova:Show()
		if Nova >= 7 then
			timerSpecialNova:Start()
			specWarnNova:Schedule(45)
		else
			timerNova:Start(55, tostring(Nova))
		end
	end

	if args:IsSpellID(85437, 85409) then
			self:ScheduleMethod(0.2, "HandofDeath")
	elseif args:IsSpellID(85408) then
			self:ScheduleMethod(0.2, "FingerofDeath")
		end
end



function mod:SPELL_SUMMON(args)
	if args:IsSpellID(85033) then
		WarnInfernal:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(30511) then
		WarnInfernal:Show()
	end
end

-- function mod:SPELL_DAMAGE(args)
--	if args:IsSpellID(85032) and args.destName and args:IsPlayer() then
--		specWarnDebris:Show()
--	end
--end

--function mod:SPELL_MISSED(args)
--	if args:IsSpellID(85031) and args.destName and args:IsPlayer() then
--		specWarnDebris:Show()
--	end
--end


function mod:UNIT_HEALTH(unit)
	if isMag and (not below30) and (mod:GetUnitCreatureId(unit) == 17257) then
		local hp = (math.max(0,UnitHealth(unit)) / math.max(1, UnitHealthMax(unit))) * 100;
		if (hp <= 30) then
			self.vb.phase = 3
			local elapsed, total = timerQuake:GetTime();
			timerQuake:Update(elapsed, total+12);
				if Nova >= 7 then
					local elapsed, total = timerSpecialNova:GetTime();
					timerSpecialNova:Update(elapsed, total+12);
				else
					local elapsed, total = timerNova:GetTime(tostring(Nova));
					timerNova:Update(elapsed, total+12, tostring(Nova));
				end 
			below30 = true;
        end
    end
end