local L

---------------
--  Nalorakk --
---------------
L = DBM:GetModLocalization("Nalorakk")

L:SetGeneralLocalization{
	name = "Nalorakk"
}

L:SetWarningLocalization{
	WarnBear		= "Bear Form",
	WarnBearSoon	= "Bear Form in 5 sec",
	WarnNormal		= "Normal Form",
	WarnNormalSoon	= "Normal Form in 5 sec"
}

L:SetTimerLocalization{
	TimerBear		= "Bear Form",
	TimerNormal		= "Normal Form"
}

L:SetOptionLocalization{
	WarnBear		= "Show warning for Bear form",
	WarnBearSoon	= "Show pre-warning for Bear form",
	WarnNormal		= "Show warning for Normal form",
	WarnNormalSoon	= "Show pre-warning for Normal form",
	TimerBear		= "Show timer for Bear form",
	TimerNormal		= "Show timer for Normal form"
}

L:SetMiscLocalization{
	YellBear 	= "You call on da beast, you gonna get more dan you bargain for!",
	YellNormal	= "Make way for Nalorakk!"
}

---------------
--  Akil'zon --
---------------
L = DBM:GetModLocalization("Akilzon")

L:SetGeneralLocalization{
	name = "Akil'zon"
}

L:SetOptionLocalization{
	StormIcon				= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(43648),
	RangeFrame				= "Show range frame",
	RodYellOpt  = "Yell when you are affected by $spell:2135700"
}

L:SetMiscLocalization{
	DBM_ROD_PLAYER = "Lightnig rod on "..UnitName("PLAYER").."! I have to run!",
	DBM_EOS_PLAYER = "Eye of storm on "..UnitName("PLAYER").."! Get under me!",
	DBM_TURBULENT_WINDS = "Turbulent winds on "..UnitName("PLAYER")..", Position! Move!"
}

---------------
--  Jan'alai --
---------------
L = DBM:GetModLocalization("Janalai")

L:SetGeneralLocalization{
	name = "Jan'alai"
}

L:SetMiscLocalization{
	YellBomb	= "I burn ya now!",
	YellAdds	= "Where ma hatcha? Get to work on dem eggs!",
	Hatchlings	= "Hatchlings alive >%s<" --(args.amount or 1)
}

L:SetOptionLocalization{
	FlameIcon				= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(43140),
	Hatchlings				= "Show warning for each increments of 5 Dragonhawk Hatchlings" --(args.spellName, args.destName, args.amount or 1)
}

--------------
--  Halazzi --
--------------
L = DBM:GetModLocalization("Halazzi")

L:SetGeneralLocalization{
	name = "Halazzi"
}

L:SetWarningLocalization{
	WarnSpirit	= "Spirit Phase",
	WarnNormal	= "Normal Phase"
}

L:SetOptionLocalization{
	WarnSpirit		= "Show warning for Spirit phase",
	WarnNormal		= "Show warning for Normal phase",
	ShockYellOpt	= "Yell when you are affected by $spell:2136003 , $spell:2136024 or $spell:2136016",
}

L:SetMiscLocalization{
	YellSpirit		= "I fight wit' untamed spirit....",
	YellNormal		= "Spirit, come back to me!",
	FlameShockYell  = "Flame Shock on "..UnitName("PLAYER"),
	EarthShockYell	= "Earth Shock on "..UnitName("PLAYER"),
	FrostShockYell	= "Frost Shock on "..UnitName("PLAYER")
}

--------------------------
--  Hex Lord Malacrass --
--------------------------
L = DBM:GetModLocalization("Malacrass")

L:SetGeneralLocalization{
	name = "Hex Lord Malacrass"
}

L:SetMiscLocalization{
	YellPull	= "Da shadow gonna fall on you...."
}

--------------
--  Zul'jin --
--------------
L = DBM:GetModLocalization("ZulJin")

L:SetGeneralLocalization{
	name = "Zul'jin"
}

L:SetMiscLocalization{
	YellPhase2	= "Got me some new tricks... like me brudda bear....",
	YellPhase3	= "Dere be no hidin' from da eagle!",
	YellPhase4	= "Let me introduce you to me new bruddas: fang and claw!",
	YellPhase5	= "Ya don' have to look to da sky to see da dragonhawk!",
	DBM_JANALAI_HATCHERS = "Where ma hatcha? Get to work on dem eggs!",
	DBM_ROD_PLAYER = "Lightnig rod on "..UnitName("PLAYER").."! I have to run!",
	DBM_EOS_PLAYER = "Eye of storm on "..UnitName("PLAYER").."! Get under me!"
}
