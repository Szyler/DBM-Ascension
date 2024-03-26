local mod		= DBM:NewMod("mobs", "DBM-TheEye", 1)
local L			= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))

mod:RegisterEvents(
	"SPELL_CAST_START"
)

local warningElectroPulse		= mod:NewCastAnnounce(2135057)
local warningElectroPulse		= mod:NewCastTimer(6, 2135057)

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2135057, 2135058, 2135059, 2135060) then
		warningElectroPulse:Show()
		warningElectroPulse:Start()
	elseif args:IsSpellID(2135064, 2135065, 2135066, 2135067) then
		--TODO Disintegrate announcement
	end
end

