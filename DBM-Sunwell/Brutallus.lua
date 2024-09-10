local mod	= DBM:NewMod("Brutallus", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(24882)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7)

mod:RegisterCombat("combat")
mod:RegisterCombat("yell", L.Pull)

mod.disableHealthCombat = true


mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"UNIT_DIED"
)

local warnMeteorSlash			= mod:NewSpellAnnounce(2145705, 2) -- 2145704, 2145705, 2145707, 2145708
local warnMeteorSlashStack 		= mod:NewSpecialWarningStack(2145705, 5) -- 2145704, 2145705, 2145707, 2145708
local timerNextMeteorSlash		= mod:NewNextTimer(10, 2145705) -- 2145704, 2145705, 2145707, 2145708

-- 10%, 10%, 13%, 15%, 15%.

local warnTrample				= mod:NewTargetAnnounce(2145709, 3) -- 2145709, 2145710, 2145711 spell_aura_applied
local timerNextTrample			= mod:NewNextTimer(30, 2145709) -- 2145709, 2145710, 2145711 spell_aura_applied
local timerCastTrample			= mod:NewCastTimer(10, 2145709) -- 2145709, 2145710, 2145711 spell_aura_applied
local timerTargetTrample		= mod:NewTargetTimer(10, 2145709) -- 2145709, 2145710, 2145711 spell_aura_applied

local warnFelfireBreath			= mod:NewSpellAnnounce(2145717, 2) -- 2145717, 2145718, Spell_cast_start
local timerNextFelfireBreath	= mod:NewNextTimer(60, 2145717) -- 2145717, 2145718, Spell_cast_start
local warnFelfireBurn			= mod:NewSpecialWarningYou(2145719) -- 2145719, 2145720, 2145721 spell_damage dbm:antiSpam(5)

local timerExcitement			= mod:NewBuffActiveTimer(50, 2145703) -- 2145703 Aura_applied Spell_aura_removed

local berserkTimer				= mod:NewBerserkTimer(360)

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	timerMeteorSlash:Start(10-delay)
	timerNextTrample:Start(23-delay)
	timerNextFelfireBreath:Start(45-delay)
	berserkTimer:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2145705, 2145706, 2145707, 2145708) then
		warnMeteorSlashStack:Show(args.destName, args.amount or 1)
	elseif args:IsSpellID(2145709, 2145710, 2145711) then
		timerTargetTrample:Start(args.destName)
	elseif args:IsSpellID(2145717, 2145718) then
		warnFelfireBreath:Show(args.destName)
		timerNextFelfireBreath:Start()
	elseif args:IsSpellID(2145703) then
		timerExcitement:Start()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2145705, 2145706, 2145707, 2145708) then
		warnMeteorSlash:Show()
		timerNextMeteorSlash:Start()
	elseif args:IsSpellID(2145709, 2145710, 2145711) then
		timerNextTrample:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2145719, 2145720, 2145721) and dbm:antiSpam(5) then
		warnFelfireBurn:Show()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2145703) then
		timerExcitement:Stop()
		warnTrample:Show()
		timerCastTrample:Start()
		timerMeteorSlash:Start(13)
	end
end

function mod:OnCombatEnd()
end

--[[
Timers
	Meteor Slash		10 seconds after pull.  Happens twice, once 10 seconds after the other.  Rotation is approx Pull, 10s, 10s, 14s, 10s, 20s, 10s, 20s, 10s, etc.  The 20 seconds are random, between 17 seconds and 23 seconds.													
	Trample				23 seconds after pull, then every 60 seconds													
	Felfire Breath		45 seconds after pull, then every 60 seconds

Notes
	Meteor slash timer is fucked.  The 20 second timer is very approximate, and ranges from 17 to 23 seconds.
]]--
