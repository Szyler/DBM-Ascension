local mod	= DBM:NewMod("Patchwerk", "DBM-Naxx", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2869 $"):sub(12, -3))
mod:SetCreatureID(16028)
mod:RegisterCombat("yell", L.yell1, L.yell2)
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"UNIT_DIED",
	"PLAYER_ALIVE"
)

mod:AddBoolOption("WarningHateful", false, "announce")
mod:AddBoolOption("SetIconOnGastricTarget", true)
local mutateIcons = {}
local MT

-----GASTRIC AFFLICTION-----
local specWarnGastric		= mod:NewSpecialWarningYou(1003086)
local warnGastric 			= mod:NewTargetAnnounce(2122517, 2)
local timerGastric			= mod:NewNextTimer(20,2122517)
local timerGastricSelf		= mod:NewTargetTimer(15,2122517)
-----MISC-----
local enrageTimer			= mod:NewBerserkTimer(360)
local timerAchieve			= mod:NewAchievementTimer(180, 1857, "TimerSpeedKill")
----TOY-----
local specWarnNotFavToy		= mod:NewSpecialWarningYou(2122516)
local timerNotFavToy		= mod:NewTargetTimer(20,2122516)
local specWarnFavToy		= mod:NewSpecialWarningYou(2122515)
local timerFavToy			= mod:NewTargetTimer(20,2122515)


-----BOSS FUNCTIONS-----
local function announceStrike(target, damage)
	SendChatMessage(L.HatefulStrike:format(target, damage), "RAID")
end

function mod:OnCombatStart(delay)
	enrageTimer:Start(-delay)
	timerAchieve:Start(-delay)
	timerGastric:Start(15-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2122517,2122518,2122519,2122520) then
		if args:IsPlayer() then
			specWarnGastric:Show();
		else
			warnGastric:Show(args.destName)
		end
		timerGastricSelf:Start(args.destName)
		self:SetIcon(args.destName, 8, 15)
		timerGastric:Start()
	elseif args:IsSpellID(2122516) then
		if args:IsPlayer() then
			specWarnNotFavToy:Show(args.destName)
			timerNotFavToy:Start(args.destName)
		end
		MT = args.destName
	elseif args:IsSpellID(2122515) then
		if args:IsPlayer() then
			specWarnFavToy:Show(args.destName)
			timerFavToy:Start(args.destName)
		end
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(28308, 59192) and self.Options.WarningHateful and DBM:GetRaidRank() >= 1 then
		announceStrike(args.destName, args.amount or 0)
	elseif args:IsSpellID(2122505) and (args.destName == MT) then
		timerNotFavToy:Stop()
		timerNotFavToy:Start(MT)
	end
end

function mod:SPELL_MISSED(args)
	if args:IsSpellID(28308, 59192) and self.Options.WarningHateful and DBM:GetRaidRank() >= 1 then
		announceStrike(args.destName, getglobal("ACTION_SPELL_MISSED_"..(args.missType)) or "")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2122517,2122518,2122519,2122520) then
		timerGastricSelf:Cancel(args.destName)--Cancel timer if someone is dumb and dispels it.
		self:SetIcon(args.destName, 0)
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 16028 or cid == 26626 then
		timerGastric:Stop()
		timerGastricSelf:Stop()
	end
end

function mod:OnCombatEnd()
	timerGastric:Stop()
	timerGastricSelf:Stop()
end