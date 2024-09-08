local mod	= DBM:NewMod("Azgalor", "DBM-Hyjal")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(17842)
mod:SetUsedIcons(8)
mod:RegisterCombat("combat", 17842)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"SPELL_DAMAGE",
	"UNIT_DIED"
)
-- mark of Azgalor
local warnMark					= mod:NewSpellAnnounce(2141211, 2)
local timerNextMark				= mod:NewNextTimer(60, 2141211)

-- Rain of Fire
local specWarnFire				= mod:NewSpecialWarning("Rain of Fire on you!", 2141200, 2)
local warnRoF					= mod:NewSpellAnnounce(2141200, 2)
local timerRoF					= mod:NewCastTimer(3, 2141200)
local timerNextRoF				= mod:NewNextTimer(25, 2141200)

--Howl of Terror
local warnHowl					= mod:NewSpellAnnounce(2141209, 2)
local timerHowl					= mod:NewCastTimer(2, 2141209)
local timerNextHowl				= mod:NewNextTimer(30, 2141209)

-- Legion Portal	
local warnPortal				= mod:NewAnnounce("Legion Portal spawning!", 2, 254274)
local timerNextPortal			= mod:NewTimer(45, "Next Legion Portal", 2, 254274)

--Add abilities
local warnDoom					= mod:NewAnnounce("Curse of Doom on %s!", 2141250)
local specWarnDoom				= mod:NewSpecialWarning("Curse of Doom on you!", 2141250)
local warnShadowStorm			= mod:NewAnnounce("Shade is casting Shadow Bolt Storm!", 2140494)
local warnAntiMagic				= mod:NewAnnounce("Anti-Magic Shield on %s!", 2140322)

--Impending Doom
local warnImpending				= mod:NewAnnounce("Impending Doom on %s!", 2141216)
local specWarnImpending			= mod:NewSpecialWarning("Impending Doom on you!", 2141216)
local timerImpending			= mod:NewTimer(8, "Impending Doom on %s", 2141216)

--fight
local berserkTimer				= mod:NewBerserkTimer(600)

--combat start
function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerNextRoF:Start(20-delay)
	timerNextPortal:Start(31-delay)
	timerNextMark:Start(15-delay)
	timerNextHowl:Start(35-delay)
	self:ScheduleMethod(31-delay,"LegionPortal")
end

function mod:LegionPortal()
	self:UnscheduleMethod("LegionPortal")
	warnPortal:Show()
	timerNextPortal:Start()
	DBM.BossHealth:AddBoss(26665, L.LegionPortal)
	self:ScheduleMethod(45,"LegionPortal")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2141200,2141201,2141202,2141203) and args:IsPlayer() and DBM:AntiSpam(5, 1) then
		specWarnFire:Show()
	end
	if args:IsSpellID(2141212) and args:IsPlayer() then
	warnMark:Show()
	timerNextMark:Start()
	end
	if args:IsSpellID(2141250,2141251,2141252,2141253) then
		if args:IsPlayer() then
		specWarnDoom:Show()
		else
		warnDoom:Show(args.destName)
		end
	end
	if args:IsSpellID(2140322) then
		warnAntiMagic:Show(args.destName)
	end
	if args:IsSpellID(2141216) then
		if args:IsPlayer() then
			specWarnImpending:Show()
		else
			warnImpending:Show(args.destName)
		end
		timerImpending:Show(args.destName)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2141200,2141201,2141202,2141203) and args:IsPlayer() and DBM:AntiSpam(5, 1) then
		specWarnFire:Show()
	end
	if args:IsSpellID(2141212) and args:IsPlayer() then
		warnMark:Show(args.amount)
		timerNextMark:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2141226) and DBM:AntiSpam(40,2) then
		self:SetIcon(args.sourceGUID, 8)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2141200,2141201,2141202,2141203) then
		warnRoF:Show()
		timerRoF:Start()
		timerNextRoF:Start()
	end
	if args:IsSpellID(2141209) then
		warnHowl:Show()
		timerHowl:Start()
		timerNextHowl:Start()
	end
	if args:IsSpellID(2140494) then
		warnShadowStorm:Show()
	end
end

function mod:UNIT_DIED(args)
	if args.destName == "Legion Portal" then
		DBM.BossHealth:Clear()
	end
end
