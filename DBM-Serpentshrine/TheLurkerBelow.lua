local mod	= DBM:NewMod("LurkerBelow", "DBM-Serpentshrine")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(21217)
mod:RegisterCombat("combat", 21217)

mod:RegisterEvents(
	"RAID_BOSS_EMOTE",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED"
)

local warnSubmerge		= mod:NewAnnounce("WarnSubmerge", 2, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local warnEmerge		= mod:NewAnnounce("WarnEmerge", 1, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
local warnWhirl			= mod:NewSpellAnnounce(37363, 2)

local specWarnSpout		= mod:NewSpecialWarningSpell(37433)

local timerSubmerge		= mod:NewTimer(135, "TimerSubmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local timerEmerge		= mod:NewTimer(60, "TimerEmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
local timerSpoutCD		= mod:NewCDTimer(70, 37433) --heroic: 351337, Mythic:351338
local timerSpout		= mod:NewBuffActiveTimer(22, 37433)
local timerWhirlCD		= mod:NewCDTimer(20, 37363) --Whirl has 20s next timer, but pushed back by other casts. Need "GetTimer" to push it back (see maiden/mag)
local timerGeyser		= mod:NewCDTimer(20, 37478) --heroic: 351335, Mythic:351336

local submerged = false
local guardianKill = 0
local ambusherKill = 0

local function emerged(self)
	submerged = false
	timerEmerge:Cancel()
	warnEmerge:Show()
	timerSubmerge:Start()
end

function mod:OnCombatStart(delay)
	submerged = false
	timerWhirlCD:Start(5-delay)
	timerSpoutCD:Start(35-delay)
	timerSubmerge:Start(75-delay)
end

function mod:RAID_BOSS_EMOTE(_, source)
	if (source or "") == L.lurkerName then
		specWarnSpout:Show()
		timerSpout:Start()
		timerSpoutCD:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(37478) then
		timerGeyser:Start()
	end
end

function mod:UNIT_DIED(args)
	local cId = self:GetCIDFromGUID(args.destGUID)
	if cId == 21865 then
		ambusherKill = ambusherKill + 1
		if ambusherKill == 6 and guardianKill == 3 and submerged then
			self:Unschedule(emerged)
			self:Schedule(2, emerged, self)
		end
	elseif cId == 21873 then
		guardianKill = guardianKill + 1
		if ambusherKill == 6 and guardianKill == 3 and submerged then
			self:Unschedule(emerged)
			self:Schedule(2, emerged, self)
		end
	end
end
