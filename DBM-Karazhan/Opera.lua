local mod		= DBM:NewMod("Opera", "DBM-Karazhan")
local L			= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))


mod:RegisterEvents(
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local warningSpotlight		= mod:NewAnnounce(L.OperaSpotlight, 3, 85112)

local timerNextSpotlight	= mod:NewTimer(30, L.OperaSpotlight, 85112)
local timerSpotlight		= mod:NewTimer(11, L.OperaSpotlightIn, 85112)
local timerStageFright		= mod:NewTimer(15, L.OperaSpotNotUse, 85112)

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.STAGE_FRIGHT then
		warningSpotlight:Show()
		timerNextSpotlight:Start()
		timerSpotlight:Start()
	else
		local spellName = msg:match("The audience does not want to see (.+)!");
		if spellName then
			timerStageFright:Start(15,spellName);
			local _,_,spellIcon = GetSpellInfo(spellName);
			if spellIcon then
				timerStageFright:UpdateIcon(spellIcon,spellName);
			end
		end
	end
end

