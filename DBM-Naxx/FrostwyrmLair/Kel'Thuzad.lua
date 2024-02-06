local mod	= DBM:NewMod("Kel'Thuzad", "DBM-Naxx", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2574 $"):sub(12, -3))
mod:SetCreatureID(15990,26614,26615,26616,26617,26618,26619,26620,26621,26622,26623,26624,26625,26626,26627,26628,26629,26630)
mod:SetUsedIcons(8)
mod:RegisterCombat("yell", L.Yell)
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START", --This should allow the addon to process this Event using the scripting from Anub'Rekhan for Impale.
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_MONSTER_EMOTE",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_HEALTH",
	"UNIT_AURA",
	"UNIT_DIED",
	"PLAYER_ALIVE"
)

----------PHASE 1----------
local warnAbomination   		= mod:NewAnnounce("Abomination spawning", 1, 500335)
local timerAbomination			= mod:NewTimer(30, "Abomination spawning", 500335)
local warnBanshee				= mod:NewAnnounce("Soul Weaver spawning", 1, 58359)
local timerBanshee				= mod:NewTimer(30, "Soul Weaver spawning", 58359)
local warnPosess				= mod:NewTargetAnnounce(2124512, 2)
local timerPosess				= mod:NewTargetTimer(10, 2124512)
-----CONSTRICTING CHAINS-----
local warnChains				= mod:NewTargetAnnounce(1003114, 2)
-----WAIL OF SOULS-----
local warnWailSoul				= mod:NewSpellAnnounce(1003115, 2)
-----PHASE 1 -> 2 TRANSITION-----
local warnPhase2				= mod:NewPhaseAnnounce(2, 3)
local timerPhase2				= mod:NewTimer(178, "Phase Two", 500992, nil, "Show timer for Phase Two")
local timerPhase2Transition		= mod:NewTimer(15, "Phase Two starting", 500992)
----------PHASE 2----------
--Shuffle in all timers we want to kill--
--ANUB--
local timerLocust				= mod:NewNextTimer(90, 2123004)
local timerImpale				= mod:NewCDTimer(15, 2123001)
--Faerlina--	
local timerSadism				= mod:NewNextTimer(30, 2123101)
--NOTH--
local timerCurse				= mod:NewNextTimer(30, 2123805)
--LOATHEB--
local timerNextDeathbloom		= mod:NewNextTimer(30, 2122627)
local timerDeathblooming		= mod:NewTimer(15, "Deathbloom expires!", 2122627)
local timerNecrotic				= mod:NewBuffActiveTimer(16, 2122601)
--INSTRUCTOR--
local timerenrage				= mod:NewTimer(180, "Enrage", 2123914)
local timerKnife				= mod:NewNextTimer(15, 2123924)
--HORSEMEN--
local timerMark					= mod:NewNextTimer(12, 2124103)
local timerNextHolyWrath		= mod:NewNextTimer(20, 2124141)
local timerNextDeepChill		= mod:NewNextTimer(20, 2124167)
local timerNextMeteor			= mod:NewNextTimer(20, 2124128)
local timerNextFamine			= mod:NewNextTimer(20, 2124166)
--PATCH--
local timerGastric				= mod:NewNextTimer(20,2122517)
local timerGastricSelf			= mod:NewTargetTimer(15,2122517)
--GROBB--
local timerSpray				= mod:NewCDTimer(20, 2122818)
local timerNextInjection		= mod:NewNextTimer(15, 2122807)
--GLUTH--
local timerDecimate				= mod:NewNextTimer(120, 2122905)
--THADD--
local timerShiftCast			= mod:NewCastTimer(4, 2124201)
local timerNextShift			= mod:NewNextTimer(34, 2124201)
local warnShiftCasting			= mod:NewCastAnnounce(2124201, 3)
--SAPPH--
local timerNextBellowing		= mod:NewNextTimer(45, 2124332)
-----PHASE 2 -> 3 TRANSITION-----
local warnPhase3				= mod:NewPhaseAnnounce(3, 3)
local timerPhase3				= mod:NewTimer(10, "Phase Three", 802125, nil, "Show the timer for Phase Three")
----------PHASE 3----------
local warnFrostSoon				= mod:NewAnnounce("Frost Phase soon", 3, 2124594)
local warnFrostNow				= mod:NewAnnounce("Frost Phase now!", 2, 2124594)
local timerKTteleport			= mod:NewTimer(42, "Kel'Thuzad teleports", 46573)
local timerFrostPhase			= mod:NewTimer(45, "Frost Phase ends", 2124594)
local warnAddsSoon				= mod:NewAnnounce("Guardians spawn at 36%!, 2, 70965")
-----PHASE 3 ABILITIES-----
local specWarnDnD				= mod:NewSpecialWarningMove(2124575,1)
local warnDnD					= mod:NewSpellAnnounce(2124575, 2)
local timerDnD					= mod:NewNextTimer(20, 2124575)
local specWarnFissure			= mod:NewSpecialWarningMove(2124579,1)
local warnFissure				= mod:NewSpellAnnounce(2124579,1)
local timerFissure				= mod:NewCDTimer(20,2124579)
local warnFlashFreezeSoon		= mod:NewSoonAnnounce(2124587, 2)
local timerFlashFreeze			= mod:NewCDTimer(30, 2124587)
local specWarnManaBomb			= mod:NewSpecialWarningYou(2124572, 2)
local warnManaBomb				= mod:NewTargetAnnounce(2124572, 2)
local timerNextManaBomb			= mod:NewNextTimer(20, 2124572)
local timerManaBomb				= mod:NewBuffActiveTimer(8, 2124572)

-----RANGE CHECK-----
mod:AddBoolOption("ShowRange", true)
----------BOSS TRACKING----------

----------MISC----------
local phase 			= 0
local icy 				= 8
local mana				= 8
local necroticSpam		= 0
local bloomSpam			= 0
local warnFrost			= 0
local frostPhase		= 0
local fissure			= 20
local shadeCounter		= 0

-----CODE START-----
function mod:OnCombatStart(delay)
	icy 				= 8
	mana 				= 8
	warnFrost			= 0
	frostPhase			= 0
	shadeCounter		= 0
	fissure 			= 20
	self.vb.phase 		= 1
	mod:ScheduleMethod(0-delay,"PhaseOne")
end

function mod:PhaseOne()
	timerPhase2:Start()
	timerAbomination:Start(10)
	timerBanshee:Start(25)
	self:ScheduleMethod(10, "Abomination")
	self:ScheduleMethod(25, "Banshee")
	self:ScheduleMethod(178, "PhaseTwoTransition")
end

function mod:Abomination()
	warnAbomination:Show()
	timerAbomination:Start()
	self:ScheduleMethod(30, "Abomination")
end

function mod:Banshee()
	warnBanshee:Show()
	timerBanshee:Start()
	self:ScheduleMethod(30, "Banshee")
end

function mod:PhaseTwoTransition()
	self:UnscheduleMethod("Banshee")
	self:UnscheduleMethod("Abomination")
	timerAbomination:Stop()
	timerBanshee:Stop()
	timerPhase2Transition:Start()
end


function mod:PhaseTwo()
	phase = 2
	self.vb.phase = 2
end

function mod:PhaseThreeTransition()
	timerDnD:Start(10)
	timerPhase3:Start()
end

function mod:PhaseThree()
	phase = 3
	self.vb.phase = 3
	timerDnD:Start()
	timerNextManaBomb:Start(20)
	timerFissure:Start(10)
	timerFlashFreeze:Start()
	self:ScheduleMethod(20, "DnD")
end

--	self:ScheduleMethod(10, "Fissure")
	-- Flash Freeze (2124587) 
	-- Death and Decay (2124575) fixed
	-- Shadow Fissure (2124579) fixed
	-- Mana Bomb (2124572) fixed
--[[ CHECK
function mod:ShadowFissure()
fissure = fissure + 1
timerFissure:Start(fissure)
self:ScheduleMod(fissure, "ShadowFissure")
end
]]--

function mod:FrostPhase()
	self:UnscheduleMethod(0, "DnD")
	timerDnD:Cancel()
	timerFrostPhase:Start()
	self:ScheduleMethod(45, "FrostPhaseFinished")
end

function mod:FrostPhaseFinished()
	timerDnD:Start(25)
	self:ScheduleMethod(25, "DnD")
end

function mod:DnD()
	timerDnD:Start()
	warnDnD:Show()
	self:ScheduleMethod(20,"DnD")
end

function mod:SPELL_CAST_START(args)
end

function mod:SPELL_AURA_APPLIED(args)
	-----CONSTRICTING CHAINS-----
	if args:IsSpellID(2124516) then
		warnChains:Show(args.destName)
	-----SHADOW FISSURE-----
	elseif args:IsSpellID(2124579) and DBM:AntiSpam(5,5) then
		if args:IsPlayer() then
			specWarnFissure:Show()
		else
			warnFissure:Show()
		end
		timerFissure:Start()
	-----DEATH AND DECAY-----
	elseif args:IsSpellID(2124575, 2124576, 2124577, 2124578) then
		if args:IsPlayer() then
			specWarnDnD:Show()
		end
	elseif args:IsSpellID(2124512) then
		warnPosess:Show(args.destName)
		timerPosess:Start(args.destName)
	elseif args:IsSpellID(2124506) then
		self:SetIcon(args.destName, icy)
		icy = icy - 1
	elseif args:IsSpellID(2124587,2124588,2124589, 2124590) then
		timerFlashFreeze:Start()
		warnFlashFreezeSoon:Schedule(25)
	elseif args:IsSpellID(2124572) then
		if args:IsPlayer() then
			SendChatMessage("Mana Bomb on "..UnitName("PLAYER").."!", "Say")
			specWarnManaBomb:Show()
		else
			warnManaBomb:Show(args.destName)
		end
		self:SetIcon(args.destName, mana)
		mana = mana - 1
		timerNextManaBomb:Start()
		timerManaBomb:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
end

function mod:SPELL_CAST_SUCCESS(args)
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 15990 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.80 and warnFrost == 0 then
		warnFrost = 1
		warnFrostSoon:Show()
	elseif self:GetUnitCreatureId(uId) == 15990 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.55 and warnFrost == 1 then
			warnFrost = 2
			warnFrostSoon:Show()
	elseif self:GetUnitCreatureId(uId) == 15990 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.75 and frostPhase == 0 then
		frostPhase = 1
		self:ScheduleMethod(43, "FrostPhase")
		timerKTteleport:Start(43)
	elseif self:GetUnitCreatureId(uId) == 15990 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.50 and frostPhase == 1 then
		frostPhase = 2
		self:ScheduleMethod(43, "FrostPhase")
		timerKTteleport:Start(43)
	elseif self:GetUnitCreatureId(uId) == 15990 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.45 and frostPhase == 2 then
		frostPhase = 3
		warnAddsSoon:Show()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.EmotePhase3 or msg:find(L.EmotePhase3) then
		self:ScheduleMethod(0, "PhaseThree")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L.EmotePhase3 or msg:find(L.EmotePhase3) then
		self:ScheduleMethod(0, "PhaseThree")
	end
end

function mod:UNIT_DIED(args)
    local cid = self:GetCIDFromGUID(args.destGUID)
    if cid == 15928 then
        icy = 8
    elseif (cid >= 26614 and cid <= 26629) then
        shadeCounter = shadeCounter + 1
        if (mod:IsDifficulty("heroic10") or mod:IsDifficulty("heroic25")) and shadeCounter == 17 then
            self:ScheduleMethod(0, "phaseThreeTransition")
        elseif not (mod:IsDifficulty("heroic10") or mod:IsDifficulty("heroic25")) and shadeCounter == 16 then
            self:ScheduleMethod(0, "phaseThreeTransition")
        end
		
		if cid == 26614 then --Anub
			timerLocust:Stop()
			timerImpale:Stop()
		elseif cid == 26615 then -- Faerlina
			timerSadism:Stop()
		elseif cid == 26617 then -- Noth
			timerCurse:Stop()
		elseif cid == 26619 then -- Loatheb
			timerNextDeathbloom:Stop()
			timerDeathblooming:Stop()
			timerNecrotic:Stop()
		elseif cid == 26620 then -- Raz
			timerenrage:Stop()
			timerKnife:Stop()
		elseif (cid >= 26622 and cid <= 26625) then -- Horsemen
			timerMark:Stop()
			timerNextHolyWrath:Stop()
			timerNextDeepChill:Stop()
			timerNextMeteor:Stop()
			timerNextFamine:Stop()
		elseif cid == 26626 then -- Patch
			timerGastric:Stop()
			timerGastricSelf:Stop()
		elseif cid == 26627 then -- Grobb
			timerNextInjection:Stop()
			timerSpray:Stop()
		elseif cid == 26628 then -- Gluth
			timerDecimate:Stop()
		elseif cid == 26629 then -- Thadd
			timerNextShift:Stop()
			self:UnscheduleMethod("ShiftingPolarity")
		elseif cid == 26630 then -- Sapph
			timerNextBellowing:Stop()
		end
	end
end

function mod:OnCombatEnd()
	self:UnscheduleMethod("DnD")
	timerLocust:Stop()
	timerImpale:Stop()
	timerSadism:Stop()
	timerCurse:Stop()
	timerNextDeathbloom:Stop()
	timerDeathblooming:Stop()
	timerNecrotic:Stop()
	timerenrage:Stop()
	timerKnife:Stop()
	timerMark:Stop()
	timerNextHolyWrath:Stop()
	timerNextDeepChill:Stop()
	timerNextMeteor:Stop()
	timerNextFamine:Stop()
	timerGastric:Stop()
	timerGastricSelf:Stop()
	timerNextInjection:Stop()
	timerSpray:Stop()
	timerDecimate:Stop()
	timerNextShift:Stop()
	timerNextBellowing:Stop()
end