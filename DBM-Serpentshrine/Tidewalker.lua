local mod	= DBM:NewMod("Tidewalker", "DBM-Serpentshrine")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(21213)
mod:RegisterCombat("combat", 21213)
mod:SetUsedIcons(5, 6, 7, 8)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	-- "SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON"
)

local warnTidal			= mod:NewSpellAnnounce(37730, 3)
local warnGrave			= mod:NewTargetAnnounce(38049, 4)--TODO, make run out special warning instead?
local warnBubble		= mod:NewSpellAnnounce(37854, 4)
local warnEarthquakeSoon= mod:NewSoonAnnounce(37764, 3)

local specWarnMurlocs	= mod:NewSpecialWarning("SpecWarnMurlocs")

local timerTidal		= mod:NewNextTimer(20, 37730)
local timerGraveCD		= mod:NewCDTimer(20, 38049)
local timerMurlocs		= mod:NewTimer(60, "TimerMurlocs", 39088)
local timerBubble		= mod:NewNextTimer(30, 37858)

local berserkTimer		= mod:NewBerserkTimer(600)

mod:AddBoolOption("GraveIcon", true)

local warnGraveTargets = {}
local bubblespam = 0
mod.vb.graveIcon = 8

local function showGraveTargets()
	warnGrave:Show(table.concat(warnGraveTargets, "<, >"))
	table.wipe(warnGraveTargets)
	timerGraveCD:Show()
end

function mod:OnCombatStart(delay)
	self.vb.graveIcon = 8
	table.wipe(warnGraveTargets)
	timerGraveCD:Start(20-delay)
	timerMurlocs:Start(41-delay)
	berserkTimer:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(37850, 38023, 38024, 38025, 38049) then
		warnGraveTargets[#warnGraveTargets + 1] = args.destName
		self:Unschedule(showGraveTargets)
		if self.Options.GraveIcon then
			self:SetIcon(args.destName, self.vb.graveIcon)
		end
		self.vb.graveIcon = self.vb.graveIcon - 1
		if #warnGraveTargets >= 4 then
			showGraveTargets()
		else
			self:Schedule(0.3, showGraveTargets)
		end
	end
end

-- function mod:SPELL_CAST_START(args)
-- end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(37730, 351345, 351346) then
		warnTidal:Show()
		timerTidal:Start()
	elseif args.spellId == 37764 then
		warnEarthquakeSoon:Show()
		specWarnMurlocs:Show()
		timerMurlocs:Start()
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(37861, 37858) and bubblespam - GetTime() > 20 then
		bubblespam = GetTime()
		warnBubble:Show()
		timerBubble:Start()
	end
end
