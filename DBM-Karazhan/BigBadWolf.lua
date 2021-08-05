local mod	= DBM:NewMod("BigBadWolf", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))
mod:SetCreatureID(17521)
mod:RegisterCombat("yell", L.DBM_BBW_YELL_1)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"CHAT_MSG_RAID_WARNING"
)

local warningFearSoon		= mod:NewSoonAnnounce(30752, 2)
local warningFear			= mod:NewSpellAnnounce(30752, 3)
local warningRRHSoon		= mod:NewSoonAnnounce(30753, 3)
local warningRRH			= mod:NewTargetAnnounce(30753, 4)

local specWarnRRH			= mod:NewSpecialWarningYou(30753)

local timerTargetRRH		= mod:NewTargetTimer(20, 30753)
local timerRRH				= mod:NewNextTimer(60, 30753)
local timerFearCD			= mod:NewNextTimer(24, 30752)
local timerNextSpotlight	= mod:NewTimer(30, L.OperaSpotlight, 85112)

mod:AddBoolOption("RRHIcon")

local lastFear = 0

function mod:OnCombatStart(delay)
	timerRRH:Start(30-delay)
	timerFearCD:Start(25-delay)
	timerNextSpotlight:Start(30-delay)
end


function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(30753) then
		warningRRH:Show(args.destName)
		timerTargetRRH:Start(args.destName)
		timerRRH:Start()
		warningRRHSoon:Cancel()
		warningRRHSoon:Schedule(55)
		if args:IsPlayer() then
			specWarnRRH:Show()
		end
		RRHTimerStart = GetTime()
		if self.Options.RRHIcon then
			self:SetIcon(args.destName, 8, 20)
		end
	elseif args:IsSpellID(30752) and GetTime() - lastFear > 2 then
		warningFear:Show()
		warningFearSoon:Cancel()
		warningFearSoon:Schedule(19)
		timerFearCD:Start()
		lastFear = GetTime()
	--elseif args:IsSpellID(85112) then
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(30753) then
		local RRHRunDuration = GetTime() - RRHTimerStart
		if RRHRunDuration < 20 then
			local elapsed, total = timerRRH:GetTime();
			timerQuake:Update(elapsed, total+20-RRHRunTimerGetTime)
		end
	end
end