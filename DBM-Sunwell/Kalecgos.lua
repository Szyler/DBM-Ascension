local mod	= DBM:NewMod("Kalecgos", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(24850)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"UNIT_DIED"
)

local warnPortal						= mod:NewAnnounce("WarnPortal", 4, 46021)


local specWarnBuffet         			= mod:NewSpecialWarningStack(2145512, 10)   	-- 2145512, 2145513 SPELL_AURA_APPLIED
local timerNextBuffet        			= mod:NewNextTimer(8, 2145512)               	-- 2145512, 2145513 SPELL_AURA_APPLIED

local timerBreathCast        			= mod:NewCastTimer(2, 2145511)               	-- 2145509, 2145510, 2145511 SPELL_CAST_START
local timerNextBreath        			= mod:NewNextTimer(20, 2145511)              	-- 2145509, 2145510, 2145511 SPELL_CAST_START

local timerSpectralBlast     			= mod:NewCastTimer(4, 2145504)               	-- 2145503, 2145504 SPELL_CAST_START
local timerNextSpectralBlast 			= mod:NewNextTimer(25, 2145504)              	-- 2145503, 2145504 SPELL_CAST_START

local timerNextTailSweep     			= mod:NewNextTimer(30, 2145506)              	-- 2145506 Spell_cast_success 

local warnDescentIntoMadness 			= mod:NewSpecialWarningStack(2145501, 5)     	-- 2145500, 2130501, 2130502 SPELL_AURA_APPLIED


mod:AddBoolOption("HealthFrame", true)
mod:AddBoolOption("RangeFrame", true)
mod:AddBoolOption("ShowFrame", true)
mod:AddBoolOption("FrameLocked", false)
mod:AddBoolOption("FrameClassColor", true, nil, function()
	mod:UpdateColors()
end)
mod:AddBoolOption("FrameUpwards", false, nil, function()
	mod:ChangeFrameOrientation()
end)
mod:AddEditboxOption("FramePoint", "CENTER")
mod:AddEditboxOption("FrameX", 150)
mod:AddEditboxOption("FrameY", -50)

local portCount = 1

function mod:OnCombatStart(delay)
	portCount = 1

	timerNextBreath:Start(15-delay)
	timerNextBuffet:Start(10-delay)
	timerNextSpectralBlast:Start(7-delay)
	timerNextTailSweep:Start(20-delay)

	if self.Options.ShowFrame then
		self:CreateFrame()
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show()
	end
	if self.Options.HealthFrame then
		DBM.BossHealth:Clear()
		DBM.BossHealth:AddBoss(24850, L.name)
		DBM.BossHealth:AddBoss(24892, L.Demon)
	end
end

function mod:OnCombatEnd()
	self:DestroyFrame()
	DBM.RangeCheck:Hide()
end


function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2145512, 2145513) and args.amount and args.amount >= 3 then
		specWarnBuffet:Show(args.destName, args.amount or 1)
		timerNextBuffet:Start()
	elseif args:IsSpellID(2145501, 2145502) and args.amount and args.amount >= 10 and args.amount % 5 == 0 then
		warnDescentIntoMadness:Show(args.destName, args.amount or 1)
	end
end

function mod:SPELL_CAST_START(args)
		if args:IsSpellID(2145511) then
			timerBreathCast:Start()
			timerNextBreath:Start()
		elseif args:IsSpellID(2145504) then
			timerSpectralBlast:Start()
			timerNextSpectralBlast:Start()
		end
	end

	function mod:SPELL_CAST_SUCCESS(args)
		if args:IsSpellID(2145506) then
		timernextTailSweep:Start()
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED


function mod:UNIT_DIED(args)
	if self:GetCIDFromGUID(args.destGUID) == 24892 then
		DBM:EndCombat(self)
	end
	-- if bit.band(args.destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 then
	-- 	local grp
	-- 	if GetNumRaidMembers() > 0 then
	-- 		for i = 1, GetNumRaidMembers() do
	-- 			local name, _, subgroup = GetRaidRosterInfo(i)
	-- 			if name == args.destName then
	-- 				grp = subgroup
	-- 				break
	-- 			end
	-- 		end
	-- 	else
	-- 		grp = 0
	-- 	end
	-- 	self:RemoveEntry(("%s (%d)"):format(args.destName, grp or 0))
	-- end
end