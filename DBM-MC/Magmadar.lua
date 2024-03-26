local mod	= DBM:NewMod("Magmadar", "DBM-MC", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(11982)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"SPELL_PERIODIC_DAMAGE"
)

local warnPanic			= mod:NewSpellAnnounce(19408)
local warnEnrage		= mod:NewSpellAnnounce(19451)
local warnDog			= mod:NewSpellAnnounce(2105054)
local warnLavaBomb		= mod:NewSpecialWarningYou(2105054)

local timerNextDog		= mod:NewNextTimer(40, 5105044)
local timerNextPanic	= mod:NewNextTimer(30, 19408)
local timerNextLava		= mod:NewNextTimer(30, 2105054)
local timerNextBreath	= mod:NewNextTimer(10, 2105049)

local warnNextHysteria	= mod:NewSpellAnnounce(2105031)
local warnNextDread		= mod:NewSpellAnnounce(2105032)
local warnNextFury		= mod:NewSpellAnnounce(2105033)
local warnNextDispair	= mod:NewSpellAnnounce(2105030)

local timerNextHysteria	= mod:NewNextTimer(150, 2105031)
local timerNextDread	= mod:NewNextTimer(150, 2105032)
local timerNextFury		= mod:NewNextTimer(150, 2105033)
local timerNextDispair	= mod:NewNextTimer(150, 2105030)

local timerPanic		= mod:NewBuffActiveTimer(8, 19408)
local timerEnrage		= mod:NewBuffActiveTimer(8, 19451)

mod:AddBoolOption(L.lavaBombYellOpt)

function mod:OnCombatStart(delay)
	timerPanic:Start(-delay)
	timerNextDog:Start(25-delay)
	warnDog:Schedule(25-delay)
	self:ScheduleMethod(25, "DogSpawner")
	timerNextHysteria:Start(15-delay)
	timerNextDread:Start(45-delay)
	timerNextFury:Start(75-delay)
	timerNextDispair:Start(105-delay)
end

function mod:DogSpawner()
	self:UnscheduleMethod("DogSpawner")
	warnDog:Show()
	timerNextDog:Start()
	self:ScheduleMethod(40, "DogSpawner")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(19451) then
		warnEnrage:Show()
		timerEnrage:Start()
	elseif args:IsSpellID(2105054) then
		if args:IsPlayer() then
			warnLavaBomb:Show()
			if self.Options.lavaBombYellOpt then
				SendChatMessage(L.lavaBombYell, "YELL")
			end
		end
		timerNextLava:Start()
	elseif args:IsSpellID(2105054) then
		warnNextHysteria:Show()
		timerNextHysteria:Start()
	elseif args:IsSpellID(2105054) then
		warnNextDread:Show()
		timerNextDread:Start()
	elseif args:IsSpellID(2105054) then
		warnNextFury:Show()
		timerNextFury:Start()
	elseif args:IsSpellID(2105054) then
		warnNextDispair:Show()
		timerNextDispair:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(19451) then
		timerEnrage:Cancel()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(19408, 2105045) then
		warnPanic:Show()
		timerPanic:Start()
		timerNextPanic:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2105049) then
		timerNextBreath:Start()
	end
end


function mod:SPELL_PERIODIC_DAMAGE(args)
	if args:IsSpellID(2105054) then
		if args:IsPlayer() then
			warnLavaBomb:Show()
			if self.Options.lavaBombYellOpt then
				SendChatMessage(L.lavaBombYell, "YELL")
			end
		end
	end
end