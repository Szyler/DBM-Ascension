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
		"SPELL_MISSED",
		"UNIT_AURA",
		"UNIT_TARGET",
)

local WarnInfernal		= mod:NewSpellAnnounce(30511, 2)
local WarnHeal			= mod:NewCastAnnounce(30528, 2, nil, false)
local WarnNova			= mod:NewSpellAnnounce(30616, 2)
local specWarnNova		= mod:NewSpecialWarning("Pre-Quake Blast Nova in 10 seconds!")
local WarnQuake			= mod:NewSpellAnnounce(85026, 2)
local specWarnDebris	= mod:NewSpecialWarningYou(85030)
local warnMortalCleave	= mod:NewAnnounce(L.MagCleave, 2, 85178)
local warnInterrupt		= mod:NewAnnounce("Magtheridon interrupted", 3, "Interface\\Icons\\ability_kick")
local warnPhaseTwo		= mod:NewAnnounce("Magtheridon is free!", 3, "Interface\\Icons\\Achievement_Boss_Magtheridon")

local timerQuake		= mod:NewNextTimer(60, 85026)
local timerSpecialNova	= mod:NewTimer(55, "!!Pre-Quake Blast Nova!!", 30616, 3)
local Nova				= 1;
local timerNova			= mod:NewTimer(55, "Blast Nova #%s", 30616)
local timerPhaseTwo		= mod:NewPhaseTimer(120, 30205, "Magtheridon breaks free")

--Heroic
-- local AnnounceHandofDeath 	= mod:NewTargetAnnounce(85437,2)
local HandTarget = "the target of $spell:85437"
local specWarnYouHand			= mod:NewSpecialWarningYou(85437, nil, 3)
local warnHandofDeath			= mod:NewAnnounce("Stack on %s", 3, "Interface\\Icons\\Shadow_ChillTouch", nil, 3)
local timerHandofDeath			= mod:NewTargetTimer(4, 85437, nil, nil, 3)
local timerNextHandofDeath		= mod:NewNextTimer(30, 85437, nil, nil, 3)

-- local AnnounceFingerofDeath 	= mod:NewTargetAnnounce(85408,2)
local FingerTarget = "the target of $spell:85408"
local specWarnYouFinger			= mod:NewSpecialWarningYou(85408, nil, 3)
local warnFingerofDeath			= mod:NewAnnounce("Move away from %s", 3, "Interface\\Icons\\Spell_Shadow_FingerOfDeath", nil, 3)
local timerFingerofDeath		= mod:NewTargetTimer(4, 85408, nil, nil, 3)
local timerNextFingerofDeath	= mod:NewNextTimer(30, 85408, nil, nil, 3)

local specWarnYouFelShock		= mod:NewSpecialWarningYou(85407, nil, 3)
local timerNextFelShock			= mod:NewNextTimer(11, 85407, nil, nil, 3)

-- local 
local isMag				= false;
local below30			= false;
local extraTimer = 0;


------

function mod:HandAndFinger(target,spell)
	if spell == "hand" then
		if(target == UnitName("player")) then
			SendChatMessage("Hand of Death on "..target..", STACK ON ME!", "YELL")
			specWarnYouHand:Show()
		else
			warnHandofDeath:Show(target)
		end
		timerHandofDeath:Start(target)
		self:SetIcon(target, 8, 4)
	elseif spell == "finger" then
		if(target == UnitName("player")) then
			SendChatMessage("Finger of Death on "..target..", RUN AWAY!", "YELL")
			specWarnYouFinger:Show()
		else
			warnFingerofDeath:Show(target)
		end
		timerFingerofDeath:Start(target)
		self:SetIcon(target, 8, 4)
	end
end

function mod:UNIT_TARGET(unit)
	if self.CheckingTarget and (DBM:GetUnitCreatureId(unit) == 17257) then
		local target = UnitName(unit.."target");
		if target and (target ~= self.CheckingTarget) then
			self:HandAndFinger(target,self.CheckingSpell);
			self:CheckTarget_Stop();
			self:UnscheduleMethod("CheckTarget_Stop");
		end
	end
end

function mod:CheckTarget(spell)
	self.CheckingTarget = mod:GetBossTarget(17257) or true;
	self.CheckingSpell = spell;
	self:ScheduleMethod(4,"CheckTarget_Stop");
end

function mod:CheckTarget_Stop()
	self.CheckingTarget = nil;
	self.CheckingSpell = nil;
end

------


function mod:OnCombatStart(delay)
	Nova = 1;
	timerPhaseTwo:Start()
end

function mod:OnCombatEnd()
	timerQuake:Cancel()
	timerSpecialNova:Cancel()
	timerNova:Cancel()
end

function mod:UNIT_AURA(unit)
	if UnitIsUnit(unit,"PLAYER") then
		--local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff(unit, "Debris");
		if UnitDebuff(unit,"Debris") then
			specWarnDebris:Show();
		end
	end
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
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(30619) and args.amount >= 4 then
		warnMortalCleave:Show(args.spellName, args.destName, args.amount or 1)
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

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_MAG_YELL_PHASE2 then
		timerQuake:Cancel()
		timerNova:Cancel()
		timerNextFingerofDeath:Cancel()
		timerNextHandofDeath:Cancel()
		timerPhaseTwo:Cancel()

		timerQuake:Start(41)
		timerNova:Start(66, tostring(Nova))
		timerNextFingerofDeath:Start(21)
		timerNextHandofDeath:Start(36)
		below30 = false;
		isMag	= true;
		warnPhaseTwo:Show()
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
	elseif args:IsSpellID(85437) then
		self:CheckTarget("hand");
		-- if Nova <= 2 then
		local extraTimer = (timerNova:GetTime() < 34) and (timerNova:GetTime() > 26) and 30 or 0;
		timerNextHandofDeath:Start(30+extraTimer)
	elseif args:IsSpellID(85408) then
		self:CheckTarget("finger");
		-- if Nova >= 3 then
		local extraTimer = (timerNova:GetTime() < 34) and (timerNova:GetTime() > 26) and 30 or 0;
		timerNextFingerofDeath:Start(30+extraTimer)
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