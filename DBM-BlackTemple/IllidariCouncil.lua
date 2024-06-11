local mod	= DBM:NewMod("Council", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(22949, 22950, 22951, 22952)
mod:SetUsedIcons(4,5,6)
mod:RegisterCombat("combat", 22949, 22950, 22951, 22952)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_HEAL",
	"SPELL_INTERRUPT",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"UNIT_DIED"
)

--Lady Malande
local warnPaintoPleasure			= mod:NewSpellAnnounce(2144463, 3)
local timerNextPaintoPleasure		= mod:NewNextTimer(15, 2144463)
local timerPaintoPleasure			= mod:NewCastTimer(1.5, 2144463)

local warnSadism					= mod:NewSpellAnnounce(2144464, 3)
local timerNextSadism				= mod:NewNextTimer(45, 2144464)
local timerSadism					= mod:NewCastTimer(3.5, 2144464)

--- Mythic/Ascended
local specWarnEmpoweredSadism		= mod:NewSpecialWarningSpell(2144514)
local timerCastEmpoweredSadism		= mod:NewCastTimer(3.5, 2144514)


--Veras Darkshadow
local warnSmokeBomb					= mod:NewSpellAnnounce(2144560, 3)
local timerNextSmokeBomb			= mod:NewNextTimer(60, 2144560)

--Gathios the Shatterer
local warnDeathSentence				= mod:NewTargetAnnounce(2144260, 3)
local warnEmpoweredDeathSentence	= mod:NewTargetAnnounce(2144310, 3)
local specWarnDeathSentence			= mod:NewSpecialWarningYou(2144260)
local specWarnEmpoweredDeathSentence= mod:NewSpecialWarningYou(2144310, 4)

local timerNextDeathSentence		= mod:NewNextTimer(60, 2144260)
local timerDeathSentence			= mod:NewTargetTimer(10, 2144260)
local timerNextConsecrate			= mod:NewNextTimer(15, 2144256, nil, false)

--High Nethermancer Zerevor
local timerNextRuneofPower			= mod:NewNextTimer(60, 2144368)
local warnNetherprotection			= mod:NewSpellAnnounce(2144351, 3)
local timerNextNetherProtection		= mod:NewNextTimer(30, 2144351)
local timerTargetNetherProtection	= mod:NewTargetTimer(120, 2144351)

--Authority
local timerCrownofCommand			= mod:NewTargetTimer(18, 2144201)
local warnCrownofCommand			= mod:NewSpellAnnounce(2144201, 3)
local councilDeath = 0

function mod:OnCombatStart(delay)
	councilDeath = 0
	timerNextPaintoPleasure:Start(25-delay)
	timerNextSmokeBomb:Start(33-delay)
	timerNextDeathSentence:Start(15-delay)
	timerNextConsecrate:Start(10-delay)
	timerNextRuneofPower:Start(45-delay)
	timerNextSadism:Start(60-delay)
	self:ScheduleMethod(33-delay,"SmokeBomb")
end

function mod:SmokeBomb()
	warnSmokeBomb:Show()
	timerNextSmokeBomb:Cancel()
	if councilDeath == 0 then
		timerNextSmokeBomb:Start(60)
	elseif councilDeath == 1 then
		timerNextSmokeBomb:Start(45)
	elseif councilDeath == 2 then
		timerNextSmokeBomb:Start(30)
	elseif councilDeath == 3 then
		timerNextSmokeBomb:Start(15)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2144560, 2144610) and DBM:AntiSpam(16, 1) then
		warnSmokeBomb:Show()
		if councilDeath == 0 then
			timerNextSmokeBomb:Start(60)
		elseif councilDeath == 1 then
			timerNextSmokeBomb:Start(45)
		elseif councilDeath == 2 then
			timerNextSmokeBomb:Start(30)
		elseif councilDeath == 3 then
			timerNextSmokeBomb:Start(15)
		end
	elseif args:IsSpellID(2144260) then
		if args:IsPlayer() then
			specWarnDeathSentence:Show();
		else
			warnDeathSentence:Show(args.destName)
		end
		timerDeathSentence:Start(args.destName)
		if DBM:AntiSpam(2) then
			self:SetIcon(args.destName, 6, 15)
		elseif DBM:AntiSpam(2) then
			self:SetIcon(args.destName, 5, 10)
		else
			self:SetIcon(args.destName, 4, 10)
		end
		if DBM:AntiSpam(2,5) then
			if councilDeath == 0 then
				timerNextDeathSentence:Start(60)
			elseif councilDeath == 1 then
				timerNextDeathSentence:Start(45)
			elseif councilDeath == 2 then
				timerNextDeathSentence:Start(30)
			elseif councilDeath == 3 then
				timerNextDeathSentence:Start(15)
			end
		end
	elseif args:IsSpellID(2144310) then
		if args:IsPlayer() then
			specWarnEmpoweredDeathSentence:Show();
		else
			warnEmpoweredDeathSentence:Show(args.destName)
		end
		timerDeathSentence:Start(args.destName)
		if DBM:AntiSpam(2) then
			self:SetIcon(args.destName, 6, 15)
		elseif DBM:AntiSpam(2) then
			self:SetIcon(args.destName, 5, 10)
		else
			self:SetIcon(args.destName, 4, 10)
		end
		if DBM:AntiSpam(2,4) then
			if councilDeath == 0 then
				timerNextDeathSentence:Start(60)
			elseif councilDeath == 1 then
				timerNextDeathSentence:Start(45)
			elseif councilDeath == 2 then
				timerNextDeathSentence:Start(30)
			elseif councilDeath == 3 then
				timerNextDeathSentence:Start(15)
			end
		end
	elseif args:IsSpellID(2144256) then
		timerNextConsecrate:Start()
	elseif args:IsSpellID(2144368, 2144418) and DBM:AntiSpam(20, 2) then
		timerNextRuneofPower:Start()
	elseif args:IsSpellID(2144351, 2144401) then
		warnNetherprotection:Show()
		timerTargetNetherProtection:Start()
	end
	if args:IsSpellID(2144201) then
		timerCrownofCommand:Start(args.destName)
		warnCrownofCommand:Show(args.destName)
	end
	if args:IsSpellID(2144559) and args.sourceName == "Veras DarkShadow" and DBM:AntiSpam(14,3) then
		self:ScheduleMethod(2,"SmokeBomb")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2144351, 2144401) then
		timerNextNetherProtection:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2144462, 2144463, 2144512, 2144513) then
		warnPaintoPleasure:Show()
		timerNextPaintoPleasure:Start()
		timerPaintoPleasure:Start()
		--when rogue splits, 22951 is fake 22952 is real.
	elseif args:IsSpellID(2144464, 2144465, 2144466, 2144467) then
		warnSadism:Show()
		timerSadism:Start()
		if councilDeath == 0 then
			timerNextSadism:Start(60)
		elseif councilDeath == 1 then
			timerNextSadism:Start(45)
		elseif councilDeath == 2 then
			timerNextSadism:Start(30)
		elseif councilDeath == 3 then
			timerNextSadism:Start(15)
		end
	elseif args:IsSpellID(2144514, 2144515, 2144516, 2144517) then
		specWarnEmpoweredSadism:Show()
		timerCastEmpoweredSadism:Start()
		if councilDeath == 0 then
			timerNextSadism:Start(60)
		elseif councilDeath == 1 then
			timerNextSadism:Start(45)
		elseif councilDeath == 2 then
			timerNextSadism:Start(30)
		elseif councilDeath == 3 then
			timerNextSadism:Start(15)
		end
	end
end

function mod:SPELL_INTERRUPT(args)
	if args:IsSpellID(2144462, 2144463, 2144512, 2144513) then
		timerPaintoPleasure:Cancel()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 22952 and DBM:AntiSpam(2,8) then
		self:UnscheduleMethod("SmokeBomb")
		councilDeath = councilDeath + 1
	end
	if  args.destName =="Lady Malande" and DBM:AntiSpam(2,5) then
		councilDeath = councilDeath + 1
		timerNextSadism:Cancel()
	end
	if  args.destName =="High Nethermancer Zerevor" and DBM:AntiSpam(2,6) then
		councilDeath = councilDeath + 1
		timerNextRuneofPower:Cancel()
	end
	if  args.destName =="Gathios the Shatterer" and DBM:AntiSpam(2,7) then
		councilDeath = councilDeath + 1
		timerNextDeathSentence:Cancel()
	end
end