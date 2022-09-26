local mod	= DBM:NewMod("TwinEmpsAQ", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(15276, 15275)
mod:RegisterCombat("combat")
mod:RegisterEvents(
	"PLAYER_ALIVE",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE"
)
mod:SetBossHealthInfo(
	15276, L.Veklor,
	15275, L.Veknil
)

local warnTeleportSoon	= mod:NewSoonAnnounce(800, 2)
local warnTeleport		= mod:NewSpellAnnounce(800, 3)
local timerTeleport			= mod:NewNextTimer(30, 800)
local berserkTimer	=	mod:NewBerserkTimer(600)


local specWarnBlizzard		= mod:NewSpecialWarningMove(26607, true, "Special warning when standing in Blizzard", true)

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	self:ScheduleMethod(-delay, "twinTeleport")
	self:ScheduleMethod(30-delay, "twinTeleport")
	self:ScheduleMethod(60-delay, "twinTeleport")
	self:ScheduleMethod(90-delay, "twinTeleport")
	self:ScheduleMethod(120-delay, "twinTeleport")
	self:ScheduleMethod(150-delay, "twinTeleport")
	self:ScheduleMethod(180-delay, "twinTeleport")
	self:ScheduleMethod(210-delay, "twinTeleport")
	self:ScheduleMethod(240-delay, "twinTeleport")
	self:ScheduleMethod(270-delay, "twinTeleport")
	self:ScheduleMethod(300-delay, "twinTeleport")
	self:ScheduleMethod(330-delay, "twinTeleport")
	self:ScheduleMethod(360-delay, "twinTeleport")
	self:ScheduleMethod(390-delay, "twinTeleport")
	self:ScheduleMethod(420-delay, "twinTeleport")
	self:ScheduleMethod(450-delay, "twinTeleport")
	self:ScheduleMethod(480-delay, "twinTeleport")
	self:ScheduleMethod(510-delay, "twinTeleport")
	self:ScheduleMethod(540-delay, "twinTeleport")
	self:ScheduleMethod(570-delay, "twinTeleport")
	self:ScheduleMethod(600-delay, "twinTeleport")
end

function mod:teleSoon()
	warnTeleportSoon:Show()
end

function mod:teleNow()
	warnTeleport:Show()
	self:ScheduleMethod(0, "alarmSound")
end

function mod:twinTeleport()
	timer = 30
	timerTeleport:Start(timer)
	self:ScheduleMethod(timer-5, "teleSoon")
	self:ScheduleMethod(timer, "teleNow")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(26607) then 
		if args:IsPlayer() then
			specWarnBlizzard:Show();
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(26607) then -- Miasma (Eye Tentacles)
		if args:IsPlayer() then
			specWarnBlizzard:Show();
		end
	end
end