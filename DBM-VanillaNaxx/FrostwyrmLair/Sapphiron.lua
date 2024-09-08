local mod	= DBM:NewMod("Sapphiron", "DBM-Naxx", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(15989)
mod:RegisterCombat("combat")
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_EMOTE",
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"PLAYER_ALIVE",
	"UNIT_DIED"
)

-----DEEP BREATH-----
local warnDeepBreath		= mod:NewSpecialWarning("WarningDeepBreath")
local timerDeepBreath		= mod:NewTimer(16.5, "Deep Breath", 2106817)
-----AIR PHASE------
local warnAirPhaseSoon		= mod:NewAnnounce("WarningAirPhaseSoon", 3, 2124314)
local warnAirPhaseNow		= mod:NewAnnounce("WarningAirPhaseNow", 4, 2124314)
local timerAirPhase			= mod:NewTimer(120, "TimerAir", 2124314)
local warnLanded			= mod:NewAnnounce("WarningLanded", 4, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local timerLanding			= mod:NewTimer(26, "TimerLanding", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
----ICE SPIKES & BLIZZARD----
local specWarningBlizzard	= mod:NewSpecialWarningMove(2124328, 2)
-- FROST BREATH--
local timerNextBreath		= mod:NewNextTimer(20, 2124322)
local timerBreath			= mod:NewCastTimer(2, 2124322)

----BELLOWING ROAR----
local timerBellowing		= mod:NewCastTimer(5, 2124332)
local timerNextBellowing	= mod:NewNextTimer(45, 2124332)
local timerTerrified		= mod:NewTimer(5, "Terrified!", 2124332)
local specWarnBellowing		= mod:NewSpecialWarningSpell(2124332, 2)
--- CURSE OF SAPPHIRON----
local timerNextCurse		= mod:NewNextTimer(30, 2124338)
local warnCurse				= mod:NewTargetAnnounce(2124338, 2)
----FROST TOMB----
local specWarnTombTarget	= mod:NewSpecialWarningYou(2124344, 2)
local warnTombTarget		= mod:NewTargetAnnounce(2124344, 2)

mod:AddBoolOption("WarningIceblock", true, "announce")
-----MISC-----

-- Frost Breath (2124323, 2124324, 2124325, 2124326)
-- Curse of Sapphiron (2124338)
-- Bellowing Roar (2124332)
-- Bellowing Roar effect ()
-- Frost Tomb target (2124344)
-- Frost Tomb (2124309)
-- Blizzard (2124328, 2124329, 2124330, 2124331)
-- Ice Spikes (2124333, 2124334, 2124335, 2124336)
-- "%s lifts off into the air!"
-- "%s takes a deep breath."
-- "%s resumes his attacks!"


-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	warnAirPhaseSoon:Schedule(80-delay)
	timerAirPhase:Start(90-delay)
	timerNextBreath:Start(-delay)
	timerNextCurse:Start(15-delay)
end

function mod:GroundPhase()
	warnAirPhaseSoon:Schedule(110)
	warnLanded:Show()
	timerAirPhase:Start()
	timerNextBreath:Start()
	timerNextCurse:Start(15)
end

function mod:AirPhase()
	timerLanding:Start()
	warnLanded:Schedule(27)
	timerDeepBreath:Start()
	warnDeepBreath:Schedule(16.5)
	timerNextBreath:Stop()
	timerNextCurse:Stop()
	timerNextBellowing:Stop()
	timerNextBellowing:Start(27.5)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2124344) then
		if args:IsPlayer() then
			specWarnTombTarget:Show()
			SendChatMessage("Ice Tomb incoming on "..UnitName("PLAYER").."!", "Say")
		else
			warnTombTarget:Show(args.destName)
		end
	elseif args:IsSpellID(2124328) and args.IsPlayer() then
		specWarningBlizzard:Show()
	elseif args:IsSpellID(2124338) then
		timerNextCurse:Start()
		warnCurse:Show(args.destName)
	elseif args:IsSpellID(2124332) and DBM:AntiSpam(2,7) then
		timerTerrified:Start()
	end
end


function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2124332) then
		specWarnBellowing:Show()
		timerBellowing:Start()
		timerNextBellowing:Start()
		timerTerrified:Schedule(4.5)
	elseif args:IsSpellID(2124322) then
		timerNextBreath:Start()
		timerBreath:Start()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.EmoteFlying or msg:find(L.EmoteFlying) then
		self:ScheduleMethod(0, "AirPhase")
	elseif msg == L.EmoteLanding or msg:find(L.EmoteLanding) then
		self:ScheduleMethod(0, "GroundPhase")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L.EmoteFlying or msg:find(L.EmoteFlying) then
		self:ScheduleMethod(0, "AirPhase")
	elseif msg == L.EmoteLanding or msg:find(L.EmoteLanding) then
		self:ScheduleMethod(0, "GroundPhase")
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 15989 or cid == 26630 then
		timerAirPhase:Stop()
		timerLanding:Stop()
		timerNextBellowing:Stop()
		timerNextBreath:Stop()
		timerNextCurse:Stop()
	end
end

function mod:OnCombatEnd()
	timerAirPhase:Stop()
	timerLanding:Stop()
	timerNextBellowing:Stop()
	timerNextBreath:Stop()
	timerNextCurse:Stop()
end

