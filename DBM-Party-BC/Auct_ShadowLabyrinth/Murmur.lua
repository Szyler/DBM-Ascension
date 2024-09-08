local mod = DBM:NewMod("Murmur", "DBM-Party-BC", 10)
local L = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(18708)
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"SPELL_CAST_START"
)

local warnBoom          		= mod:NewCastAnnounce(33923)
local timerBoomCast     		= mod:NewCastTimer(5, 33923)
local timerNextBoom     		= mod:NewNextTimer(45, 33923)
local timerNextPull     		= mod:NewNextTimer(45, 33923)
local warnTouch         		= mod:NewTargetAnnounce(38794)
local timerTouch        		= mod:NewTargetTimer(7, 38794)
local specWarnTouch				= mod:NewSpecialWarningMove(38794)
local timerNextTouch			= mod:NewNextTimer(27, 38794)
local warnStorm					= mod:NewSpecialWarningMove(39365)
local warnShock         		= mod:NewTargetAnnounce(38794)
local timerNextShock			= mod:NewNextTimer(60, 38794)

mod:AddBoolOption("SetIconOnTouchTarget", true)

function mod:OnCombatStart(delay)
	timerNextShock:Start(18-delay)
	timerNextTouch:Start(10-delay)
	timerNextBoom:Start(34-delay)
	timerNextPull:Start(30-delay)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 33923 or args.spellId == 38796 then
		warnBoom:Show()
		timerBoomCast:Start()
		timerNextBoom:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(33711, 38794) then
		warnTouch:Show(args.destName)
		timerTouch:Start(args.destName)
		if self.Options.SetIconOnTouchTarget then
			self:SetIcon(args.destName, 8, 14)
		end
		if args:IsPlayer() then
            specWarnTouch:Show()
        end
	elseif args:IsSpellID(33686) then
		warnShock:Show(args.destName)
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(39365) and args:IsPlayer() then
		warnStorm:Show()
	end
end

function mod:SPELL_MISSED(args)
	if args:IsSpellID(39365) and args:IsPlayer() then
		warnStorm:Show()
	end
end

-- 38794 - Murmur's Touch (old = 33711)
-- 33686 - Shockwave
-- 38796 - Sonic Boom
-- 39365 - Thundering Storm