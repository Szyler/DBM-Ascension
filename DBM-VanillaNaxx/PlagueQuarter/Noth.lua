local mod	= DBM:NewMod("Noth", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(15954)
mod:RegisterCombat("combat")
mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"PLAYER_ALIVE",
	"UNIT_HEALTH",
	"UNIT_DIED",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

-----TELEPORT-----
local warnIntermissionNow	= mod:NewAnnounce("Intermission now", 2, 46573, nil, "Show warning for Noth teleporting to the balcony")
local warnIntermissionSoon	= mod:NewAnnounce("Intermission soon", 2, 46573, nil, "Show pre-warning for Noth teleporting to the balcony")
local timerTeleportBack		= mod:NewTimer(60, "Noth returns to the battlefield", 46573, nil, "Show timer for Noth teleporting from the balcony")
local warnNothReturn		= mod:NewAnnounce("Noth has returned to the battlefield", 46573, nil, "Show warning for Noth returning from the balcony")
-----CURSE-----
local timerCurse			= mod:NewNextTimer(30, 2123805)
local warnCurse				= mod:NewSpellAnnounce(2123805, 2)
local specWarnCurse			= mod:NewSpecialWarningYou(2123805)
-----Adds-----
local timerWarriorSkeletons	= mod:NewTimer(30,"Wave of Warrior Skeletons", 52611)
local timerSkeletonWave		= mod:NewTimer(26, "Wave of Skeletons", 52611)
local timerArcaneExplo		= mod:NewNextTimer(30, 2123828)
--Rise, my soldiers! Rise and fight once more!
-----MISC-----
-- local berserkTimer			= mod:NewBerserkTimer(375)
local phase = 0
local prePhase = 0
local curseSpam = 0

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	phase = 0
	prePhase = 0
	curseSpam = 0
	self:ScheduleMethod(0-delay,"NothFight")
end

function mod:Intermission()
	warnIntermissionNow:Show()
	timerCurse:Stop()
	timerWarriorSkeletons:Stop()
	timerArcaneExplo:Start(15)
	timerSkeletonWave:Start(10)
	self:UnscheduleMethod("WarriorSkeletons")
	self:ScheduleMethod(15,"SkeletonWaves")
	timerTeleportBack:Start()
	self:ScheduleMethod(60, "NothFight")
end

function mod:NothFight()
	timerWarriorSkeletons:Start(22)
	timerCurse:Start()
	self:ScheduleMethod(22,"WarriorSkeletons")
	if phase >= 1 then
	warnNothReturn:Show()
	end
end

function mod:WarriorSkeletons()
	timerWarriorSkeletons:Start()
	self:ScheduleMethod(30,"WarriorSkeletons")
end

function mod:SkeletonWaves()
	timerSkeletonWave:Start()
	timerArcaneExplo:Start()
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2123805) and DBM:AntiSpam(5,1) then
		if args:IsPlayer() then
		specWarnCurse:Show()
		end
		timerCurse:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(29213, 54835, 350288) then
		if args:IsPlayer() then
			specWarnCurse:Show();
		end
	end
end


function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 15954 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.80 and prePhase ==0 then
		warnIntermissionSoon:Show()
		prePhase = 1
		-- end
	--if self:GetUnitCreatureId(uId) == 15954 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.753 and phase ==0 then
	--self:ScheduleMethod(0,"Intermission")
	--phase = 1
	--end
	elseif self:GetUnitCreatureId(uId) == 15954 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.55 and prePhase ==1 then
		warnIntermissionSoon:Show()
		prePhase = 2
		-- end
	--if self:GetUnitCreatureId(uId) == 15954 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.503 and phase ==1 then
	--	self:ScheduleMethod(0,"Intermission")
	--	phase = 2
	--end
	elseif self:GetUnitCreatureId(uId) == 15954 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.30 and prePhase ==2 then
		warnIntermissionSoon:Show()
		prePhase = 3
		-- end
	--if self:GetUnitCreatureId(uId) == 15954 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.253 and phase ==2 then
	--	self:ScheduleMethod(0,"Intermission")
	--	phase = 3
	--end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.Teleport or msg:find(L.Teleport) then
		self:ScheduleMethod(0,"Intermission")
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 15954 or cid == 26617 then
		timerCurse:Stop()
		self:UnscheduleMethod("WarriorSkeletons")
	end
end

function mod:OnCombatEnd()
	self:UnscheduleMethod("WarriorSkeletons")
	timerCurse:Stop()
	timerWarriorSkeletons:Stop()
end


