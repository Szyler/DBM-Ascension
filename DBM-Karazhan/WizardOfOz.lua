local mod	= DBM:NewMod("Oz", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))
mod:SetCreatureID(18168)
mod:RegisterCombat("yell", L.DBM_OZ_YELL_DOROTHEE)
mod:SetMinCombatTime(25)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_RAID_WARNING"
)

local WarnRoar			= mod:NewAnnounce("Roar", 2, nil, nil, false)
local WarnStrawman		= mod:NewAnnounce("Strawman", 2, nil, nil, false)
local WarnTinhead		= mod:NewAnnounce("Tinhead", 2, nil, nil, false)
local WarnTido			= mod:NewAnnounce("Tito", 2, nil, nil, false)
local WarnCrone			= mod:NewAnnounce("The Crone", 2, nil, nil, false)
local WarnCL			= mod:NewCastAnnounce(32337, 3)
local warnScream		= mod:NewSpellAnnounce(31013, 3)

local timerRoar				= mod:NewTimer(14.5, "Roar", "Interface\\Icons\\Ability_Druid_ChallangingRoar", nil, false)
local timerStrawman			= mod:NewTimer(24, "Strawman", "Interface\\Icons\\INV_Helmet_34", nil, false)
local timerTinhead			= mod:NewTimer(34, "Tinhead", "Interface\\Icons\\INV_Helmet_02", nil, false)
local timerTito				= mod:NewTimer(11, "Tito", "Interface\\Icons\\Ability_Mount_WhiteDireWolf", nil, false)
local timerScream			= mod:NewTimer(30, "Frightened Scream", 31013)
local timerCL				= mod:NewCDTimer(10, 32337)
local timerNextSpotlight	= mod:NewTimer(30, L.OperaSpotlight, 85112)

mod:AddBoolOption("AnnounceBosses", true, "announce")
mod:AddBoolOption("ShowBossTimers", true, "timer")
mod:AddBoolOption("DBM_OZ_OPTION_1")

function mod:OnCombatStart(delay)
	if self.Options.ShowBossTimers then
		timerRoar:Start(-delay)
		timerStrawman:Start(-delay)
		timerTinhead:Start(-delay)
		timerTito:Start(-delay)
		timerNextSpotlight:Start(20-delay)
		timerScream:Start(15-delay)
		self.vb.phase = 1
	end
end

function mod:OnCombatEnd()
	if self.Options.DBM_OZ_OPTION_1 then
		DBM.RangeCheck:Hide()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_OZ_YELL_ROAR then
		if self.Options.AnnounceBosses then
			WarnRoar:Show()
		end
	elseif msg == L.DBM_OZ_YELL_STRAWMAN then
		if self.Options.AnnounceBosses then
			WarnStrawman:Show()
		end
	elseif msg == L.DBM_OZ_YELL_TINHEAD then
		if self.Options.AnnounceBosses then
			WarnTinhead:Show()
		end
	elseif msg == L.DBM_OZ_YELL_CRONE then
		if self.Options.AnnounceBosses then
			WarnCrone:Show()
		end
		if self.Options.DBM_OZ_OPTION_1 then
			DBM.RangeCheck:Show(10)
			self.vb.phase = 2
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(31013) then
		timerScream:Start()
		warnScream:Show()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(31014) then
		if self.Options.AnnounceBosses then
			WarnTido:Schedule(1)
		end
	elseif args:IsSpellID(32337) then
		WarnCL:Show()
		timerCL:Start()
		end
	end
