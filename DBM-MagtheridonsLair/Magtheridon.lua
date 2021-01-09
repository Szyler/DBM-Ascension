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
local warnInterrupt		= mod:NewAnnounce("Magtheridon interrupted", 3, "Interface\\Icons\\ability_kick")
local warnPhaseTwo		= mod:NewAnnounce("Magtheridon is free!", 3, "Interface\\Icons\\Achievement_Boss_Magtheridon")

--Heroic
local HandTarget
local specWarnYouHand			= mod:NewSpecialWarningYou(85437)
-- local AnnounceHandofDeath 	= mod:NewTargetAnnounce(85437,2)
local warnHandofDeath			= mod:NewAnnounce("Stack on "..HandTarget.." to soak", 3, "Interface\\Icons\\Achievement_Boss_Magtheridon")
local timerHandofDeath			= mod:NewTargetTimer(4, 85437)

local FingerTarget
local specWarnYouFinger			= mod:NewSpecialWarningYou(85408)
-- local AnnounceFingerofDeath 	= mod:NewTargetAnnounce(85408,2)
local warnFingerofDeath			= mod:NewAnnounce("Move away from "..FingerTarget.." or die", 3, "Interface\\Icons\\Achievement_Boss_Magtheridon")
local timerFingerofDeath		= mod:NewTargetTimer(4, 85408)
--

local timerQuake		= mod:NewNextTimer(60, 85026)
local timerSpecialNova	= mod:NewTimer(55, "!!Pre-Quake Blast Nova!!", 30616)
local Nova				= 1;
local timerNova			= mod:NewTimer(55, "Blast Nova #%s", 30616)
local timerPhaseTwo		= mod:NewTimer(90, "Magtheridon", "Interface\\Icons\\Achievement_Boss_Magtheridon")

local isMag				= false;
local below30			= false;

function mod:OnCombatStart(delay)
	Nova = 1;
	timerPhaseTwo:Start()
end

function mod:OnCombatEnd()
	timerQuake:Cancel()
	timerSpecialNova:Cancel()
	timerNova:Cancel()
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(30205) then
		timerQuake:Start(41)
		timerNova:Start(66, tostring(Nova))
		below30 = false;
		isMag	= true;
		warnPhaseTwo:Show()
		timerPhaseTwo:Cancel()
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
		-- AnnounceHandofDeath:Show(args.destName)
		HandTarget = args.destName
		if(args.destName == You) then
			specWarnYouHand:Show()
		else
			warnHandofDeath:Show(args.destName) 
		end
		timerHandofDeath:Start(args.destName)
		self:SetIcon(args.destName, 8, 4)
	elseif args:IsSpellID(85408) then
		-- AnnounceHandofDeath:Show(args.destName)
		FingerTarget = args.destName
		if(args.destName == You) then
			specWarnYouHand:Show()
		else
			warnFingerofDeath:Show(args.destName) 
		end
		timerFingerofDeath:Start(args.destName)
		self:SetIcon(args.destName, 8, 4)
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

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(85030) and args:IsPlayer() then
		specWarnDebris:Show()
	elseif args:IsSpellID(30168) then
		warnInterrupt:Show()
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