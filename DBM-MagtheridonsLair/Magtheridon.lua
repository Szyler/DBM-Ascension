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

local WarnInfernal			= mod:NewSpellAnnounce(2132327, 2)
local WarnHeal				= mod:NewCastAnnounce(30528, 2, nil, false)
local WarnNova				= mod:NewSpellAnnounce(2132301, 2)
local specWarnNova			= mod:NewSpecialWarning("Pre-Quake Blast Nova in 10 seconds!")
local WarnQuake				= mod:NewSpellAnnounce(2132310, 2)
local specWarnDebris		= mod:NewSpecialWarningYou(85030)
local specWarnConflag		= mod:NewSpecialWarningYou(2132315)
local warnGlaiveCleave		= mod:NewAnnounce(L.MagCleave, 2, 2132300)
local warnInterrupt			= mod:NewAnnounce("Magtheridon interrupted", 3, "Interface\\Icons\\ability_kick")
local warnPhaseTwo			= mod:NewAnnounce("Magtheridon is free!", 3, "Interface\\Icons\\Achievement_Boss_Magtheridon")
local warnPhaseThree		= mod:NewAnnounce("Phase 3", 3, "Interface\\Icons\\Achievement_Boss_Magtheridon")

local timerNextQuake		= mod:NewNextTimer(60, 2132310)
local timerNextSpecialNova	= mod:NewTimer(55, "!!Pre-Quake Blast Nova!!", 2132301, 3)
local timerNextNova			= mod:NewTimer(55, "Blast Nova #%s", 2132301)
local timerPhaseTwo			= mod:NewPhaseTimer(120, 30205, "Magtheridon breaks free")
local timerFallingRoof		= mod:NewTimer(10, "Roof is collapsing!")

--Heroic
-- local AnnounceHandofDeath 	= mod:NewTargetAnnounce(2132323,2)
local specWarnYouHand			= mod:NewSpecialWarningYou(2132323)
local warnHandofDeath			= mod:NewTargetAnnounce(2132323, 3.8)
local timerHandofDeath			= mod:NewTargetTimer(4, 2132323)
local timerNextHandofDeath		= mod:NewNextTimer(30, 2132323)

-- local AnnounceFingerofDeath 	= mod:NewTargetAnnounce(2132319,2)
local specWarnYouFinger			= mod:NewSpecialWarningYou(2132319)
local warnFingerofDeath			= mod:NewTargetAnnounce(2132319, 3.8)
local timerFingerofDeath		= mod:NewTargetTimer(4, 2132319)
local timerNextFingerofDeath	= mod:NewNextTimer(30, 2132319)

local specWarnYouFelShock		= mod:NewSpecialWarningYou(2132333)
local timerNextFelShock			= mod:NewNextTimer(11, 2132333)

-- local 
local Nova					= 1;
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
	timerNextQuake:Cancel()
	timerNextSpecialNova:Cancel()
	timerNextNova:Cancel()
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(85030) and args:IsPlayer() then
		specWarnDebris:Show()
	elseif args:IsSpellID(2132337) then
		warnInterrupt:Show()
	elseif args:IsSpellID(2132331) then
		 if args:IsPlayer() then
			-- SendChatMessage("Fel Shock on "..UnitName("PLAYER")..", STACK ON ME!", "YELL")
			specWarnYouFelShock:Show()
		end
		timerNextFelShock:Start()
	elseif args:IsSpellID(2132300) then
		warnGlaiveCleave:Show(args.spellName, args.destName, args.amount or 1)
	elseif args:IsSpellID(2132315, 2132316, 2132317, 2132318) then
		if args:IsPlayer() then
			specWarnConflag:Show()
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2132300) and args.amount >= 4 then
		warnGlaiveCleave:Show(args.spellName, args.destName, args.amount or 1)
	elseif args:IsSpellID(2132315) then
		if args:IsPlayer() then
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
		timerNextQuake:Cancel()
		timerNextNova:Cancel()
		if mod:IsDifficulty("heroic10", "heroic25") then
		timerNextFingerofDeath:Start(21)
			timerNextHandofDeath:Start(36)
			self:ScheduleMethod(21,"NextFingerofDeath");
			self:ScheduleMethod(36,"NextHandofDeath");
		end
		timerPhaseTwo:Cancel()
		timerNextQuake:Start(41)
		timerNextNova:Start(66, tostring(Nova))
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
	elseif args:IsSpellID(2132310) then
		WarnQuake:Show()
		timerNextQuake:Start()

		local elapsedHand, totalHand = timerNextHandofDeath:GetTime()
		local remainingTimerNextHand = totalHand - elapsedHand
		local elapsedFinger, totalFinger = timerNextFingerofDeath:GetTime()
		local remainingTimerNextFinger = totalFinger - elapsedFinger
		if math.min(remainingTimerNextFinger, remainingTimerNextHand) - 7 < 0 then
			if remainingTimerNextFinger < remainingTimerNextHand then
				timerNextFingerofDeath:AddTime(7)
			else
				timerNextHandofDeath:AddTime(7)
			end
		end
	elseif args:IsSpellID(2132301) then
		Nova = Nova + 1;
		WarnNova:Show()
		if Nova >= 7 then
			timerNextSpecialNova:Start()
			specWarnNova:Schedule(45)
		else
			timerNextNova:Start(55, tostring(Nova))

			local elapsedHand, totalHand = timerNextHandofDeath:GetTime()
			local remainingTimerNextHand = totalHand - elapsedHand
			local elapsedFinger, totalFinger = timerNextFingerofDeath:GetTime()
			local remainingTimerNextFinger = totalFinger - elapsedFinger
			if math.min(remainingTimerNextFinger, remainingTimerNextHand) - 7 < 0 then
				if remainingTimerNextFinger < remainingTimerNextHand then
					timerNextFingerofDeath:AddTime(3)
				else
					timerNextHandofDeath:AddTime(3)
				end
			end
		end
	end

	if args:IsSpellID(2132323, 2132324, 2132325, 2132326) then
			self:ScheduleMethod(0.2, "HandofDeath")
	elseif args:IsSpellID(2132319, 2132320, 2132321, 2132322) then
			self:ScheduleMethod(0.2, "FingerofDeath")
	end
end



function mod:SPELL_SUMMON(args)
	if args:IsSpellID(85033) then
		WarnInfernal:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2132327, 2132328, 2132329, 2132330) then
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
			local elapsed, total = timerNextQuake:GetTime();
			timerNextQuake:Update(elapsed, total+12);
				if Nova >= 7 then
					local elapsed, total = timerNextSpecialNova:GetTime();
					timerNextSpecialNova:Update(elapsed, total+12);
				else
					local elapsed, total = timerNextNova:GetTime(tostring(Nova));
					timerNextNova:Update(elapsed, total+12, tostring(Nova));
				end 
			below30 = true;
        end
    end
end