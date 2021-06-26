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

local timerSubmerge		= mod:NewTimer(105, "TimerSubmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local timerEmerge		= mod:NewTimer(60, "TimerEmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
local timerSpoutCD		= mod:NewCDTimer(50, 37433)
local timerSpout		= mod:NewBuffActiveTimer(22, 37433)
local timerWhirlCD		= mod:NewCDTimer(18, 37363)

mod.vb.submerged = false
mod.vb.guardianKill = 0
mod.vb.ambusherKill = 0

local function emerged(self)
	self.vb.submerged = false
	timerEmerge:Cancel()
	warnEmerge:Show()
	timerSubmerge:Start()
end

function mod:OnCombatStart(delay)
	self.vb.submerged = false
	timerWhirlCD:Start(15-delay)
	timerSpoutCD:Start(37-delay)
	timerSubmerge:Start(90-delay)
end

function mod:RAID_BOSS_EMOTE(_, source)
	if (source or "") == L.name then
		specWarnSpout:Show()
		timerSpout:Start()
		timerSpoutCD:Start()
	end
end

function mod:UNIT_DIED(args)
	local cId = self:GetCIDFromGUID(args.destGUID)
	if cId == 21865 then
		self.vb.ambusherKill = self.vb.ambusherKill + 1
		if self.vb.ambusherKill == 6 and self.vb.guardianKill == 3 and self.vb.submerged then
			self:Unschedule(emerged)
			self:Schedule(2, emerged, self)
		end
	elseif cId == 21873 then
		self.vb.guardianKill = self.vb.guardianKill + 1
		if self.vb.ambusherKill == 6 and self.vb.guardianKill == 3 and self.vb.submerged then
			self:Unschedule(emerged)
			self:Schedule(2, emerged, self)
		end
	end
end
