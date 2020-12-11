if (GetLocale() == "ruRU") then

-- Maulgar
DBM_MAULGAR_NAME			= "Король Молгар";
DBM_MAULGAR_DESCRIPTION		= "Объявляет щит и исцеление и показывает таймеры для Удар по дуге, Вихрь и Охотник Скверны spawn.";
DBM_MAULGAR_OPTION_1		= "Объявить Большее слово силы: щит";
DBM_MAULGAR_OPTION_2		= "Объявить Щит заклятий";
DBM_MAULGAR_OPTION_3		= "Объявить Молитва исцеления";
DBM_MAULGAR_OPTION_4		= "Объявить Исцеление";
DBM_MAULGAR_OPTION_5		= "Объявить Вихрь";
DBM_MAULGAR_OPTION_6		= "Объявить Удар по дуге";
DBM_MAULGAR_OPTION_7		= "Объявить Охотник Скверны";

DBM_MAULGAR_WARN_GPWS		= "*** Щит заклятий на Слепоглазе Ясновидце ***";
DBM_MAULGAR_WARN_SHIELD		= "*** Щит заклятий на Кроше Огненная Рука ***";
DBM_MAULGAR_WARN_SMASH		= "Удар по дуге на >%s<: %s";
DBM_MAULGAR_WARN_POH		= "*** Слепоглаз Ясновидец читает Молитва исцеления ***";
DBM_MAULGAR_WARN_HEAL		= "*** Слепоглаз Ясновидец читает Исцеление ***";

DBM_MAULGAR_WARN_WHIRLWIND	= "*** Вихрь ***";
DBM_MAULGAR_WARN_WW_SOON	= "*** Скоро Вихрь ***";
DBM_MAULGAR_WARN_FELHUNTER	= "*** Охотник Скверны ***";


DBM_MAULGAR_DODGED	= "уклоняется";
DBM_MAULGAR_PARRIED	= "отражает";
DBM_MAULGAR_MISSED	= "промахивается";

DBM_SBT["Arcing Smash"]			= "Удар по дуге";
DBM_SBT["Next Whirlwind"]		= "Следующий Вихрь";
DBM_SBT["Whirlwind"]			= "Вихрь";
DBM_SBT["Prayer of Healing"]	= "Молитва исцеления";
DBM_SBT["Heal"]					= "Исцеление";
DBM_SBT["Felhunter"]			= "Охотник Скверны";
DBM_SBT["Maulgar"]				= {
		[1]	= {
			[1]	= "Spell Shield: (.*)",
			[2]	= "Щит заклятий: %1",
		},
	};

-- Gruul
DBM_GRUUL_NAME				= "Груул Драконобой";
DBM_GRUUL_DESCRIPTION		= "Объявляет Обледенение, Рык, Отзвук и Завал.";

DBM_GRUUL_RANGE_OPTION		= "Показать область границы контроля";
DBM_GRUUL_GROW_OPTION		= "Объявить Рык";
DBM_GRUUL_SHATTER_OPTION	= "Объявить Прах земной и Обледенение";
DBM_GRUUL_SILENCE_OPT		= "Объявить Молчание";
DBM_GRUUL_CAVE_OPTION		= "Показать спец-предупреждение для Завал";
DBM_GRUUL_OPTION_GROWBAR	= "Рык"

DBM_GRUUL_SAY_PULL			= "Иди… и умри."
DBM_GRUUL_GROW_EMOTE		= "%s увеличивается!";
DBM_GRUUL_EMOTE_SHATTER		= "%s ревет!";
DBM_GRUUL_SILENCE			= "Отзвук";

DBM_GRUUL_GROW_ANNOUNCE		= "*** Рык #%s ***";
DBM_GRUUL_SHATTER_WARN		= "*** Обледенение ***";
DBM_GRUUL_SHATTER_20WARN	= "*** Скоро Прах земной ***";
DBM_GRUUL_SHATTER_10WARN	= "*** Прах земной - Обледенение через 10 секунд ***";
DBM_GRUUL_SHATTER_SOON		= "*** Скоро Обледенение ***";
DBM_GRUUL_SILENCE_WARN		= "*** Молчание ***";
DBM_GRUUL_SILENCE_SOON_WARN	= "*** Скоро Молчание ***";
DBM_GRUUL_CAVE_IN_WARN		= "Завал";

DBM_SBT["Shatter"]			= "Обледенение";
DBM_SBT["Ground Slam"]		= "Прах земной"
DBM_SBT["Silence"]			= "Молчание";
DBM_SBT["Gruul"] = {
		[1] = {
			"Grow #",
			"Рык #"
		},
	}



end
