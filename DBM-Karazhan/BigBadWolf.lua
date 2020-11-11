local mod	= DBM:NewMod("BigBadWolf", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))
mod:SetCreatureID(17521)
mod:RegisterCombat("yell", L.DBM_BBW_YELL_1)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"CHAT_MSG_RAID_WARNING"
)

local warningFearSoon	= mod:NewSoonAnnounce(30752, 2)
local warningFear		= mod:NewSpellAnnounce(30752, 3)
local warningRRHSoon	= mod:NewSoonAnnounce(30753, 3)
local warningRRH		= mod:NewTargetAnnounce(30753, 4)
local warningSpotlight  = mod:NewAnnounce("Spotlight", 3, 54428) 

local specWarnRRH		= mod:NewSpecialWarningYou(30753)

local timerRRH			= mod:NewTargetTimer(20, 30753)
local timerRRHCD		= mod:NewNextTimer(60, 30753)
local timerFearCD		= mod:NewNextTimer(24, 30752)
local timerNextSpotlight	= mod:NewTimer(30, "Spotlight", 85112)
local timerSpotlight	= mod:NewTimer(11, "Get into Spotlight", 85112)
local timerStageFright	= mod:NewTimer(15, "DO NOT USE: %s", 85112)

mod:AddBoolOption("RRHIcon")

local lastFear = 0

function mod:OnCombatStart(delay)
	timerRRHCD:Start(30-delay)
	timerFearCD:Start(55-delay)
	timerNextSpotlight:Start(30-delay)
end

function mod:CHAT_MSG_RAID_WARNING(msg)
	if msg == L.STAGE_FRIGHT then
		warningSpotlight:Show()
		timerNextSpotlight:Start()
		timerSpotlight:Start()
	else
		local spellName = msg:match("The Audience does not want to see (.+)!");
		if spellName then
			timerStageFright:Start(15,spellName);
			local _,_,spellIcon = GetSpellInfo(spellName);
			if spellIcon then
				timerStageFright:UpdateIcon(spellIcon,spellName);
			end
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(30753) then
		warningRRH:Show(args.destName)
		timerRRH:Start(args.destName)
		timerRRHCD:Start()
		warningRRHSoon:Cancel()
		warningRRHSoon:Schedule(25)
		if args:IsPlayer() then
			specWarnRRH:Show()
		end
		if self.Options.RRHIcon then
			self:SetIcon(targetname, 8, 20)
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
