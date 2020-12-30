local mod	= DBM:NewMod("Heigan", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(15936)
mod:RegisterCombat("combat")
mod:EnableModel()
mod:RegisterEvents(
	"PLAYER_ALIVE"
)

-----TELEPORT-----
local warnTeleportSoon			= mod:NewAnnounce("Teleport to Platform Soon", 2, 46573, nil, "Show pre-warning for Heigan teleporting to the platform")
local warnTeleportNow			= mod:NewAnnounce("Teleport to Platform Now", 3, 46573, nil, "Show warning for Heigan teleporting to the platform")
local timerTeleport				= mod:NewTimer(90, "Teleport to Platform", 46573, nil, "Show timer for Heigan teleporting to the platform")
local soundTeleport				= mod:SoundInfoLong(46573, "Play the 'Long Info' sound effect when Heigan teleports to the platform")
-----DANCE ENDS----
local timerDanceEnds			= mod:NewTimer(47, "Dance Ends", 46573, nil, "Show timer for the end of the Safety Dance")
local warnDanceEndsSoon			= mod:NewAnnounce("Dance Ends Soon", 2, 46573, nil, "Show pre-warning for the end of the Safety Dance")
local warnDanceEnds				= mod:NewAnnounce("Dance Ends Now", 3, 46573, nil, "Show warning for the end of the Safety Dance")
local soundDanceEnds			= mod:SoundInfoLong(46573, "Play the 'Long Info' sound effect at the end of the Safety Dance")
-----SPELL DISRUPTION------
local specWarnSpellDisruption	= mod:NewSpecialWarningYou(29310, false)
local specWarnBurningFever		= mod:NewSpecialWarningYou(1003068)
-----MISC-----
local berserkTimer				= mod:NewBerserkTimer(540)

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	berserkTimer:Start(540-delay)

	mod:SlowDancePhase()
end

function mod:DancePhase()
	timer = 45
	timerDanceEnds:Show(timer)
	warnDanceEndsSoon:Schedule(timer-10, 10)
	warnDanceEnds:Schedule(timer)
	soundDanceEnds:Schedule(timer)
	self:ScheduleMethod(timer, "SlowDancePhase")
end

function mod:SlowDancePhase()
	timer = 90
	timerTeleport:Show(timer)
	warnTeleportSoon:Schedule(timer-15, 15)
	warnTeleportNow:Schedule(timer)
	soundTeleport:Schedule(timer)
	self:ScheduleMethod(timer, "DancePhase")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(29310) then 
		if args:IsPlayer() then
			specWarnSpellDisruption:Show();
		end
	elseif args:IsSpellID(1003068) then 
		if args:IsPlayer() then
			specWarnBurningFever:Show();
			SendChatMessage(L.YellBurningFever, "YELL")
			soundBurningFever:Play();
		end	
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(29310) then 
		if args:IsPlayer() then
			specWarnSpellDisruption:Show();
		end
	elseif args:IsSpellID(1003068) then 
		if args:IsPlayer() then
			specWarnBurningFever:Show();
			SendChatMessage(L.YellBurningFever, "YELL")
			soundBurningFever:Play();
		end
	end
end
