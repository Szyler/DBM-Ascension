if (GetLocale() == "zhTW") then

-- Maulgar
DBM_MAULGAR_NAME		= "大君王莫卡爾";
DBM_MAULGAR_DESCRIPTION		= "提示盾,補血 和 提供旋風斬;圓弧斬;野生地獄行者計時";
DBM_MAULGAR_OPTION_1		= "提示強效真言術：盾";
DBM_MAULGAR_OPTION_2		= "提示法術護盾";
DBM_MAULGAR_OPTION_3		= "提示治療禱言";
DBM_MAULGAR_OPTION_4		= "提示補血";
DBM_MAULGAR_OPTION_5		= "提示旋風斬";
DBM_MAULGAR_OPTION_6		= "提示圓弧斬";
DBM_MAULGAR_OPTION_7		= "提示野生地獄行者";

DBM_MAULGAR_WARN_GPWS		= "*** 盾在盲眼身上 ***";
DBM_MAULGAR_WARN_SHIELD		= "*** 法術護盾在克羅斯身上 ***";
DBM_MAULGAR_WARN_SMASH		= "圓弧斬在 >%s<: %s";
DBM_MAULGAR_WARN_POH		= "*** 盲眼施放治療禱言 ***";
DBM_MAULGAR_WARN_HEAL		= "*** 盲眼施放治療術 ***";

DBM_MAULGAR_WARN_WHIRLWIND	= "*** 旋風斬 ***";
DBM_MAULGAR_WARN_WW_SOON	= "*** 旋風斬即將到來 ***";
DBM_MAULGAR_WARN_FELHUNTER	= "*** 野生地獄行者 ***";

DBM_MAULGAR_GPWS		= "先知盲眼獲得了強效真言術:盾的效果。";
DBM_MAULGAR_SPELLSHIELD		= "克羅斯·火手獲得了法術護盾的效果。";

DBM_MAULGAR_POH			= "先知盲眼開始施放治療禱言。";
DBM_MAULGAR_HEAL		= "先知盲眼開始施放治療術。";
DBM_MAULGAR_FELHUNTER		= "召喚者歐莫施放了召喚野生地獄獵犬。";
DBM_MAULGAR_SHIELD_STOLEN	= "(.+)獲得了法術護盾的效果。";
DBM_MAULGAR_SHIELD_STOLEN2	= "你獲得了法術護盾的效果。";

DBM_MAULGAR_WHIRLWIND		= "大君王莫卡爾獲得了旋風斬的效果。";
DBM_MAULGAR_ARCING_SMASH	= "大君王莫卡爾的圓弧斬";
DBM_MAULGAR_SMASH_HIT		= "大君王莫卡爾的圓弧斬擊中(.+)造成(%d+)點(.*)";
DBM_MAULGAR_SMASH_MISS		= "大君王莫卡爾的圓弧斬(.+)(.*)。"; --未完成
DBM_MAULGAR_SMASH_MISS_2	= "大君王莫卡爾的圓弧斬被(.+)(.*)。"; --未完成
DBM_MAULGAR_SMASH_MISS_3	= "大君王莫卡爾的圓弧斬(.*)(.+)。"; --未完成
DBM_MAULGAR_SMASH_YOU_HIT	= "大君王莫卡爾的圓弧斬擊中你造成(%d+)點(.*)";
DBM_MAULGAR_SMASH_YOU_MISS	= "大君王莫卡爾的圓弧斬沒有擊中你。";
DBM_MAULGAR_SMASH_YOU_DODGE	= "大君王莫卡爾的圓弧斬被閃躲過去。";
DBM_MAULGAR_SMASH_YOU_PARRY	= "大君王莫卡爾的圓弧斬被招架過去。";

DBM_MAULGAR_DODGED	= "閃躲過去";
DBM_MAULGAR_PARRIED	= "招架了";
DBM_MAULGAR_MISSED	= "沒有擊中";

DBM_SBT["Arcing Smash"]			= "圓弧斬";
DBM_SBT["Next Whirlwind"]		= "下一次旋風斬";
DBM_SBT["Whirlwind"]			= "旋風斬";
DBM_SBT["Prayer of Healing"]		= "治療禱言";
DBM_SBT["Heal"]				= "補血";
DBM_SBT["Felhunter"]			= "野生地獄行者";
DBM_SBT["Maulgar"] = {
	{"Spell Shield: (.*)","法術護盾: %1"},
};

-- Gruul
DBM_GRUUL_NAME				= "弒龍者戈魯爾";
DBM_GRUUL_DESCRIPTION			= "提示破碎,成長,沉默,及塌下技能";

DBM_GRUUL_RANGE_OPTION			= "顯示距離框";
DBM_GRUUL_GROW_OPTION			= "提示成長";
DBM_GRUUL_SHATTER_OPTION		= "提示大地猛擊及破碎";
DBM_GRUUL_SILENCE_OPT			= "提示沉默";
DBM_GRUUL_CAVE_OPTION			= "顯示特別警告當你中了塌下";
DBM_GRUUL_OPTION_GROWBAR		= "成長"

DBM_GRUUL_SAY_PULL			= "來……受死吧。"
DBM_GRUUL_GROW_EMOTE			= "%s變大了!";
DBM_GRUUL_EMOTE_SHATTER			= "%s吼叫!";
DBM_GRUUL_CAVE_IN_YOU			= "你受到了塌下效果的影響。";
DBM_GRUUL_SHATTER_CAST			= "弒龍者戈魯爾開始施放破碎。";
DBM_GRUUL_SLAM_CAST			= "弒龍者戈魯爾開始施放大地猛擊。";
DBM_GRUUL_SILENCE			= "迴響";

DBM_GRUUL_GROW_ANNOUNCE			= "*** 成長 #%s ***";
DBM_GRUUL_SHATTER_WARN			= "*** 破碎 ***";
DBM_GRUUL_SHATTER_20WARN		= "*** 10秒後發動大地猛擊 ***";
DBM_GRUUL_SHATTER_10WARN		= "*** 大地猛擊 - 10秒後發動破碎 ***";
DBM_GRUUL_SHATTER_SOON			= "*** 即將發動破碎 ***";
DBM_GRUUL_SILENCE_WARN			= "*** 沉默 ***";
DBM_GRUUL_SILENCE_SOON_WARN		= "*** 即將發動沉默 ***";
DBM_GRUUL_CAVE_IN_WARN			= "塌下";

DBM_SBT["Shatter"]			= "破碎";
DBM_SBT["Ground Slam"]			= "大地猛擊";
DBM_SBT["Silence"]			= "沉默";
DBM_SBT["Grow #1"]			= "成長 #1";
	
DBM_SBT["Gruul"] = {
	{"Grow #", "成長 #"},
}

end
