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
	"PLAYER_ALIVE"
)

mod:AddBoolOption("WarningHateful", false, "announce")
mod:AddBoolOption("SetIconOnGastricTarget", true)
local mutateIcons = {}

-----GASTRIC AFFLICTION-----
local specWarnGastric		= mod:NewSpecialWarningYou(1003086)
local warnGastric 			= mod:NewTargetAnnounce(2122517, 4)
local timerGastric			= mod:NewNextTimer(20,2122517)
local timerGastricSelf		= mod:NewTargetTimer(15,2122517)
-----MISC-----
local enrageTimer	= mod:NewBerserkTimer(360)
local timerAchieve	= mod:NewAchievementTimer(180, 1857, "TimerSpeedKill")



-----BOSS FUNCTIONS-----
local function announceStrike(target, damage)
	SendChatMessage(L.HatefulStrike:format(target, damage), "RAID")
end

function mod:OnCombatStart(delay)
	enrageTimer:Start(-delay)
	timerAchieve:Start(-delay)
	if mod:IsDifficulty("heroic25") then
		timerGastric:start(15-delay)
		table.wipe(mutateIcons)
	end
end

local function addIcon()
	for i,j in ipairs(mutateIcons) do
		local icon = 9 - i
		mod:SetIcon(j, icon)
	end
end

local function removeIcon(target)
	for i,j in ipairs(mutateIcons) do
		if j == target then
			table.remove(mutateIcons, i)
			mod:SetIcon(target, 0)
		end
	end
	addIcon()
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2122517) then
		if args:IsPlayer() then
			specWarnGastric:Show();
		else
		warnGastric:Show(args.destName)
		end
		timerGastricSelf:Start(args.destName)
		table.insert(mutateIcons, args.destName)
		addIcon()
		timerGastric:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(28308, 59192) and self.Options.WarningHateful and DBM:GetRaidRank() >= 1 then
		announceStrike(args.destName, args.amount or 0)
	end
end

function mod:SPELL_MISSED(args)
	if args:IsSpellID(28308, 59192) and self.Options.WarningHateful and DBM:GetRaidRank() >= 1 then
		announceStrike(args.destName, getglobal("ACTION_SPELL_MISSED_"..(args.missType)) or "")
	end	
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2122517) then
		timerGastricSelf:Cancel(args.destName)--Cancel timer if someone is dumb and dispels it.
		removeIcon(args.destName)
	end
end


