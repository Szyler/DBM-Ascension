local mod	= DBM:NewMod("Sartura", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(15516)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"PLAYER_ALIVE"
)



function mod:PLAYER_ALIVE()
	if UnitIsDeadOrGhost("PLAYER") and self.Options.ResetOnRelease then
		--self:wipeAllTimers();
		self:Stop();
	end
end

-----MISC TIMERS-----
local berserkTimer				= mod:NewBerserkTimer(360)
local kickAnnounce				= mod:NewSpellAnnounce(1766, 4)
local meleeOut					= mod:NewAnnounce("MELEE OUT - MELEE OUT", 4)
-----PREWARNINGS-----
local prewarnSTranslocation		= mod:NewAnnounce("Song of Translocation Soon", 3, 1002345)
local prewarnDTranslocation		= mod:NewAnnounce("Dance of Translocation Soon", 3, 1002323)
local prewarnSColossus			= mod:NewAnnounce("Song of The Colossus Soon", 3, 1002346)
local prewarnDHaste				= mod:NewAnnounce("Dance of Haste Soon", 3, 1002324)
local prewarnSOppression		= mod:NewAnnounce("Song of Oppression Soon", 3, 1002347)
local prewarnDHunt				= mod:NewAnnounce("Dance of The Hunt Soon", 3, 1002325)
local prewarnSDeath				= mod:NewAnnounce("Song of Death Soon", 3, 1002348)
-----ALERTS-----
local warn1Stacks				= mod:NewAnnounce("1 Stack of Suspended Assault", 3, 1002328)
local warn2Stacks				= mod:NewAnnounce("2 Stacks of Suspended Assault", 3, 1002328)
local warn3Stacks				= mod:NewAnnounce("3 Stacks of Suspended Assault", 3, 1002328)
local warn4Stacks				= mod:NewAnnounce("4 Stacks of Suspended Assault", 3, 1002328)
local warnSTranslocation		= mod:NewSpellAnnounce(1002345, 2)
local warnDTranslocation		= mod:NewSpellAnnounce(1002323, 2)
local warnSColossus				= mod:NewSpellAnnounce(1002346, 2)
local warnDHaste				= mod:NewSpellAnnounce(1002324, 2)
local warnSOppression			= mod:NewSpellAnnounce(1002347, 2)
local warnDHunt					= mod:NewSpellAnnounce(1002325, 2)
local warnSDeath				= mod:NewSpellAnnounce(1002348, 2)
-----TIMERS-----
local timerStacks				= mod:NewTimer(60, "Time Remaining: Stacks", 1002328)
local timerSongRemaining		= mod:NewTimer(15, "Time Remaining: Song", 1002345)
local timerDanceRemaining		= mod:NewTimer(15, "Time Remaining: Dance", 1002323)
local timerSTranslocation		= mod:NewCDTimer(30, 1002345)
local timerDTranslocation		= mod:NewCDTimer(30, 1002323)
local timerSColossus			= mod:NewCDTimer(30, 1002346)
local timerDHaste				= mod:NewCDTimer(30, 1002324)
local timerSOppression			= mod:NewCDTimer(30, 1002347)
local timerDHunt				= mod:NewCDTimer(30, 1002325)
local timerSDeath				= mod:NewCDTimer(30, 1002348)
-----SOUND-----
local castNumber
local dancetimerFix
local songtimerFix
local isFourStack
local latestAuraFix
-----PREWARNING FUNCTIONS-----
function mod:preSTranslocation()
	prewarnSTranslocation:Show()
end
function mod:preDTranslocation()
	prewarnDTranslocation:Show()
end
function mod:preSColossus()
	prewarnSColossus:Show()
end
function mod:preDHaste()
	prewarnDHaste:Show()
end
function mod:preSOppression()
	prewarnSOppression:Show()
end
function mod:preDHunt()
	prewarnDHunt:Show()
end
function mod:preSDeath()
	prewarnSDeath:Show()
end

-----ALERT FUNCTIONS-----
function mod:alertSTranslocation()
	warnSTranslocation:Show()
end
function mod:alertDTranslocation()
	warnDTranslocation:Show()
end
function mod:alertSColossus()
	warnSColossus:Show()
end
function mod:alertDHaste()
	warnDHaste:Show()
end
function mod:alertSOppression()
	warnSOppression:Show()
end
function mod:alertDHunt()
	warnDHunt:Show()
end
function mod:alertSDeath()
	warnSDeath:Show()
end

-----MISC FUNCTIONS-----
function mod:alarmSound()
	soundKick:Play()
end
function mod:kickThisCunt()
	kickAnnounce:Show()
end
function mod:runBitch()
	soundMelee:Play()
	meleeOut:Show()
end

-----ACTUAL FUNCTIONS-----
function mod:OnCombatStart(delay)
	berserkTimer:Start()
	self:ScheduleMethod(0, "initialSarturaCast")
	castNumber = 0
	dancetimerFix = 0
	songtimerFix = 0
	isFourStack = 0
	latestAuraFix = 0
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(1002328) and (args.amount or 1) == 1 then
		warn1Stacks:Show()
		timerStacks:Start()
	elseif args:IsSpellID(1002328) and (args.amount or 1) == 2 then
		warn2Stacks:Show()
		timerStacks:Start()
	elseif args:IsSpellID(1002328) and (args.amount or 1) == 3 then
		warn3Stacks:Show()
		timerStacks:Start()
	elseif args:IsSpellID(1002328) and (args.amount or 1) == 4 then
		warn4Stacks:Show()
		timerStacks:Start()
		if isFourStack == 0 then
			isFourStack = 1
			self:ScheduleMethod(60, "fixFourStack")
		end
	elseif args:IsSpellID(1002323) then
		if dancetimerFix == 0 then
			timerDanceRemaining:Start()
			dancetimerFix = 1
			self:ScheduleMethod(20, "fixDanceTimer")
			self:ScheduleMethod(1, "checkFourCast")
			latestAuraFix = 1002323
		end
	elseif args:IsSpellID(1002324) then
		if dancetimerFix == 0 then
			timerDanceRemaining:Start()
			dancetimerFix = 1
			self:ScheduleMethod(20, "fixDanceTimer")
			self:ScheduleMethod(1, "checkFourCast")
			latestAuraFix = 1002324
		end
	elseif args:IsSpellID(1002325) then
		if dancetimerFix == 0 then
			timerDanceRemaining:Start()
			dancetimerFix = 1
			self:ScheduleMethod(20, "fixDanceTimer")
			self:ScheduleMethod(1, "checkFourCast")
			latestAuraFix = 1002325
		end
	elseif args:IsSpellID(1002345) then
		if songtimerFix == 0 then
			timerSongRemaining:Start()
			songtimerFix = 1
			self:ScheduleMethod(20, "fixSongTimer")
			self:ScheduleMethod(1, "checkFourCast")
			latestAuraFix = 1002345
		end
	elseif args:IsSpellID(1002346) then
		if songtimerFix == 0 then
			timerSongRemaining:Start()
			songtimerFix = 1
			self:ScheduleMethod(20, "fixSongTimer")
			self:ScheduleMethod(1, "checkFourCast")
			latestAuraFix = 1002346
		end
	elseif args:IsSpellID(1002347) then
		if songtimerFix == 0 then
			timerSongRemaining:Start()
			songtimerFix = 1
			self:ScheduleMethod(20, "fixSongTimer")
			self:ScheduleMethod(1, "checkFourCast")
			latestAuraFix = 1002347
		end
	elseif args:IsSpellID(1002348) then
		if songtimerFix == 0 then
			timerSongRemaining:Start()
			songtimerFix = 1
			self:ScheduleMethod(20, "fixSongTimer")
			self:ScheduleMethod(1, "checkFourCast")
			latestAuraFix = 1002348
		end
	end
end

function mod:fixDanceTimer()
	dancetimerFix = 0
end

function mod:fixSongTimer()
	songtimerFix = 0
end

function mod:fixFourStack()
	isFourStack = 0
end

function mod:checkFourCast()
	if isFourStack == 1 then
		if latestAuraFix == 1002323 then
			self:ScheduleMethod(0, "dotCast")
			latestAuraFix = 0
		elseif latestAuraFix == 1002324 then
			self:ScheduleMethod(0, "dohCast")
			latestAuraFix = 0
		elseif latestAuraFix == 1002325 then
			self:ScheduleMethod(0, "dothCast")
			latestAuraFix = 0
		elseif latestAuraFix == 1002345 then
			self:ScheduleMethod(0, "sotCast")
			latestAuraFix = 0
		elseif latestAuraFix == 1002346 then
			self:ScheduleMethod(0, "socCast")
			latestAuraFix = 0
		elseif latestAuraFix == 1002347 then
			self:ScheduleMethod(0, "sooCast")
			latestAuraFix = 0
		elseif latestAuraFix == 1002348 then
			self:ScheduleMethod(0, "sodCast")
			latestAuraFix = 0 
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(1002345) then --Song of Translocation
		self:ScheduleMethod(0, "sotCast")
		mod:alarmSound()
		mod:kickThisCunt()		
		if castNumber == 0 then
			castNumber = castNumber+1
		elseif castNumber == 7 then
			castNumber = castNumber+1
		end
	elseif args:IsSpellID(1002323) then --Dance of Translocation
		self:ScheduleMethod(0, "dotCast")
		mod:alarmSound()
		mod:kickThisCunt()
		if castNumber == 1 then
			castNumber = castNumber+1
		elseif castNumber == 8 then
			castNumber = castNumber+1
		end
	elseif args:IsSpellID(1002346) then --Song of the Colossus
		self:ScheduleMethod(0, "socCast")
		if castNumber == 2 then
			castNumber = castNumber+1
			mod:alarmSound()
			mod:kickThisCunt()
		elseif castNumber == 9 then
			castNumber = castNumber+1 
			mod:runBitch()
		end
	elseif args:IsSpellID(1002324) then --Dance of Haste
		self:ScheduleMethod(0, "dohCast")
		if castNumber == 3 then
			castNumber = castNumber+1
		elseif castNumber == 10 then
			castNumber = castNumber+1
		end
	elseif args:IsSpellID(1002347) then --Song of Oppression
		self:ScheduleMethod(0, "sooCast")
		if castNumber == 4 then
			castNumber = castNumber+1
			mod:runBitch()
		elseif castNumber == 11 then
			castNumber = castNumber+1
			mod:alarmSound()
			mod:kickThisCunt()
		end
	elseif args:IsSpellID(1002325) then --Dance of the Hunt
		self:ScheduleMethod(0, "dothCast")
		if castNumber == 5 then
			castNumber = castNumber+1
		elseif castNumber == 12 then
			castNumber = castNumber+1
			mod:alarmSound()
			mod:kickThisCunt()
		end
	elseif args:IsSpellID(1002348) then --Song of Death
		self:ScheduleMethod(0, "sodCast")
		mod:alarmSound()
		mod:kickThisCunt()
		if castNumber == 6 then
			castNumber = castNumber+1
		elseif castNumber == 13 then
			castNumber = castNumber+1
			mod:alarmSound()
			mod:kickThisCunt()
		end
	end
end

function mod:initialSarturaCast()
	local timer1 = 10
	timerSTranslocation:Start(timer1)
	self:ScheduleMethod(timer1-5, "preSTranslocation")
	self:ScheduleMethod(timer1, "alertSTranslocation")
end

function mod:sodCast()
	local timer1 = 50
	timerSTranslocation:Start(timer1)
	self:ScheduleMethod(timer1-5, "preSTranslocation")
	self:ScheduleMethod(timer1, "alertSTranslocation")
end

function mod:sotCast()
	local timer2 = 25
	timerDTranslocation:Start(timer2)
	self:ScheduleMethod(timer2-5, "preDTranslocation")
	self:ScheduleMethod(timer2, "alertDTranslocation")
end

function mod:dotCast()
	local timer3 = 25
	timerSColossus:Start(timer3)
	self:ScheduleMethod(timer3-5, "preSColossus")
	self:ScheduleMethod(timer3, "alertSColossus")
end

function mod:socCast()
	local timer4 = 25
	timerDHaste:Start(timer4)
	self:ScheduleMethod(timer4-5, "preDHaste")
	self:ScheduleMethod(timer4, "alertDHaste")
end

function mod:dohCast()
	local timer5 = 25
	timerSOppression:Start(timer5)
	self:ScheduleMethod(timer5-5, "preSOppression")
	self:ScheduleMethod(timer5, "alertSOppression")
end

function mod:sooCast()
	local timer6 = 25
	timerDHunt:Start(timer6)
	self:ScheduleMethod(timer6-5, "preDHunt")
	self:ScheduleMethod(timer6, "alertDHunt")
end

function mod:dothCast()
	local timer7 = 25
	timerSDeath:Start(timer7)
	self:ScheduleMethod(timer7-5, "preSDeath")
	self:ScheduleMethod(timer7, "alertSDeath")
end