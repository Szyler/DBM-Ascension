local mod	= DBM:NewMod("Ragnaros", "DBM-MC", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 172 $"):sub(12, -3))
mod:SetCreatureID(11502)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"CHAT_MSG_MONSTER_YELL"
)

local timerCombatStart	= mod:NewTimer(78, "TimerCombatStart", 2457)

local warnSunder		= mod:NewAnnounce(L.RagFire, 2, 2105107)
local warnHand			= mod:NewSpellAnnounce(2105119)
local warnBlast			= mod:NewSpellAnnounce(2105103)
local warnMerge			= mod:NewSpellAnnounce(975068)
local warnSubmergeSoon	= mod:NewAnnounce("WarnSubmergeSoon", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")

local timerNextHand		= mod:NewNextTimer(15, 2105120)
local timerNextBurst	= mod:NewNextTimer(15, 2105107)

local timerSubmerge		= mod:NewTimer(90, "TimerSubmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local timerEmerge		= mod:NewTimer(60, "TimerEmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")

-- local warnWrathRag		= mod:NewSpellAnnounce(20566)
-- --local warnHandRag		= mod:NewSpellAnnounce(19780)--does not show in combat log. need transciptor to get more data on this later
-- local warnSubmerge		= mod:NewAnnounce("WarnSubmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
-- local warnEmergeSoon	= mod:NewAnnounce("WarnEmergeSoon", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
-- local warnEmerge		= mod:NewAnnounce("WarnEmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")

-- local timerWrathRag		= mod:NewNextTimer(30, 20566)
-- --local timerHandRag		= mod:NewNextTimer(111, 19780)


function mod:OnCombatStart(delay)
	timerNextHand:Start(-delay)
	warnSubmergeSoon:Schedule(85-delay)
	timerSubmerge:Start(-delay)
	timerEmerge:Schedule(90-delay)
	self:ScheduleMethod(150, "Emerged")
end

function mod:Emerged()
	timerNextHand:Start(-delay)
	warnSubmergeSoon:Schedule(85-delay)
	timerSubmerge:Start(-delay)
	timerEmerge:Schedule(90-delay)
	self:ScheduleMethod(150, "Emerged")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2105107, 2105108) or args:IsSpellID(2105109, 2105110) and args.amount >= 5 then
		warnSunder:Show(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2105119, 2105120) or args:IsSpellID(2105121, 2105122) then
		warnHand:Show()
		timerNextHand:Start()
	elseif args:IsSpellID(2105103, 2105104) or args:IsSpellID(2105105, 2105106) then
		warnBlast:Show()
	elseif args:IsSpellID(975068) and args.sourceName == "Son of Flame" then
		warnMerge:Show()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2105115, 2105116) or args:IsSpellID(2105117, 2105118) then
		timerNextBurst:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Pull then
		timerCombatStart:Start()
	end
end

-- function mod:OnSync(msg, arg)
	-- 	if msg == "Submerge" and not submerge then
		-- 		submerge = true
		-- 		warnSubmerge:Show()
		-- 		timerEmerge:Start()
		-- 		warnEmergeSoon:Schedule(80)
		-- 		self:ScheduleMethod(90, "emerged")
		-- 	elseif msg == "Emerge" then
			-- 		emerged()
			-- 	end
			-- end