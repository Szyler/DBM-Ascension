local mod	= DBM:NewMod("Heigan", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(15936)
mod:RegisterCombat("combat")
mod:EnableModel()
mod:RegisterEvents(
	"PLAYER_ALIVE",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"UNIT_DIED"
)

-----TELEPORT-----
local warnTeleportSoon			= mod:NewAnnounce("The Dance is starting soon", 2, 46573, nil, "Show pre-warning for Heigan teleporting to the platform")
local warnTeleportNow			= mod:NewAnnounce("Teleport to Platform Now", 2, 46573, nil, "Show warning for Heigan teleporting to the platform")
local timerTeleport				= mod:NewTimer(90, "Heigan's Dance (Teleport)", 46573, nil, "Show timer for Heigan teleporting to the platform")
-----POSITIONS-----
local timerPositionOne			= mod:NewTimer(10, "Position: Entrance", 2122702)
local timerPositionTwo			= mod:NewTimer(10, "Position: Center West", 2122702)
local timerPositionThree		= mod:NewTimer(10, "Position: Center East", 2122702)
local timerPositionFour			= mod:NewTimer(10, "Position: Exit", 2122702)
-----DANCE ENDS----
local timerDanceEnds			= mod:NewTimer(50, "Dance Ends", 46573, nil, "Show timer for the end of the Safety Dance")
-----SPELL DISRUPTION------
local specWarnSpellDisruption	= mod:NewSpecialWarningYou(2122708)
local specWarnDecrepitFever		= mod:NewSpecialWarningYou(1003068)
-----Touch of the Unclean-----
local specWarnTouch				= mod:NewSpecialWarningStack(2122722, nil, 2)
local warnTouch					= mod:NewAnnounce("%s on >%s< (%d)",2, 2122722)
----PLAGUE NOVA----
local specWarnPlagueNova		= mod:NewSpecialWarningSpell(2122717, 2)
local timerPlagueNova			= mod:NewNextTimer(60, 2122717)
local timerCastPlagueNova		= mod:NewCastTimer(5, 2122717)
-----MISC-----
local berserkTimer				= mod:NewBerserkTimer(540)
local dance = 0
local forward = 1

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	berserkTimer:Start(540-delay)
	dance = 0
	self:ScheduleMethod(0-delay,"SlowDancePhase")
end

function mod:SlowDancePhase()
	dance = 0
	forward = 1
	timerPositionTwo:Stop()
	timerPositionThree:Stop()
	self:UnscheduleMethod("PositionTwo")
	self:UnscheduleMethod("PositionThree")
	timerTeleport:Start(90)
	warnTeleportSoon:Schedule(85)
	timerPositionOne:Start(15)
	self:ScheduleMethod(15,"PositionTwo")
end

function mod:DancePhase()
	dance = 1
	forward = 1
	timerPositionThree:Stop()
	self:UnscheduleMethod("PositionFour")
	timerDanceEnds:Start()
	timerPositionOne:Start(10)
	self:ScheduleMethod(10,"PositionTwo")
end

function mod:PositionOne()
	forward = 1
	if dance == 1 then
		timerPositionOne:Start(4)
		self:ScheduleMethod(4, "PositionTwo")
	else
		timerPositionOne:Start(10)
		self:ScheduleMethod(10, "PositionTwo")
	end
end

function mod:PositionTwo()
	if dance == 1 then
		timerPositionTwo:Start(4)
		if forward == 1 then
			self:ScheduleMethod(4, "PositionThree")
		else
			self:ScheduleMethod(4, "PositionOne")
		end
	else
		timerPositionTwo:Start(10)
		if forward == 1 then
			self:ScheduleMethod(10, "PositionThree")
		else
			self:ScheduleMethod(10, "PositionOne")
		end
	end
end

function mod:PositionThree()
	if dance == 1 then
		timerPositionThree:Start(4)
		if forward == 1 then
			self:ScheduleMethod(4, "PositionFour")
		else
			self:ScheduleMethod(4, "PositionTwo")
		end
	else
		timerPositionThree:Start(10)
		if forward == 1 then
			self:ScheduleMethod(10, "PositionFour")
		else
			self:ScheduleMethod(10, "PositionTwo")
		end
	end
end

function mod:PositionFour()
	forward = 0
	if dance == 1 then
		timerPositionFour:Start(4)
		self:ScheduleMethod(4, "PositionThree")
	else
		timerPositionFour:Start(10)
		self:ScheduleMethod(10, "PositionThree")
	end
end

function mod:KillPositions()
	timerPositionOne:Stop()
	timerPositionTwo:Stop()
	timerPositionThree:Stop()
	timerPositionFour:Stop()
	self:UnscheduleMethod("PositionOne")
	self:UnscheduleMethod("PositionTwo")
	self:UnscheduleMethod("PositionThree")
	self:UnscheduleMethod("PositionFour")
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2122717) then
		specWarnPlagueNova:Show()
		timerCastPlagueNova:Start()
		self:ScheduleMethod(0, "DancePhase")
		self:ScheduleMethod(50, "SlowDancePhase")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2122708) then
		if args:IsPlayer() then
			specWarnSpellDisruption:Show()
		end
	elseif args:IsSpellID(1003068) then
		if args:IsPlayer() then
			specWarnDecrepitFever:Show();
			SendChatMessage("Decrepit Fever on "..UnitName("PLAYER").."!", "Say")
		end
	elseif args:IsSpellID(196791) then
		warnTouch:Show(args.destName, args.amount or 1)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2122722) then
		if args:IsPlayer() then
			specWarnTouch:Show(args.amount)
		else
			warnTouch:Show(args.spellName, args.destName, args.amount or 1)
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 15936 or cid == 26618 then
		self:ScheduleMethod(0,"KillPositions")
	end
end

function mod:OnCombatEnd()
	self:ScheduleMethod(0,"KillPositions")
end