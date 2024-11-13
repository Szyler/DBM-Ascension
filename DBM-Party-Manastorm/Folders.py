import os

# Define the zones and bosses
zones = {
    "Westfall": ["Marisa du'Paige"],
    "The Grim Marsh": ["The Witch's Brew"],
    "Iskirr Village": ["Njernthir"],
    "Winterspring": ["High Chief Winterfall", "Manaclaw"],
    "Redridge Mountains": ["Gath'Ilzogg"],
    "Eastern Plaguelands": ["Surgeon Stitchflesh", "High General Abbendis"],
    "Hillsbrad Foothills": ["Justicar Keltraesa"],
    "Zangarmarsh": ["Beastmaster Tivan"],
    "Tanaris": ["High Priestess Razecta"],
    "Shadowmoon Valley": ["Varedis", "Warlord Vedrisian"]
}

# Template for the Lua file
lua_template = '''\
local mod	= DBM:NewMod("{boss_name}", "DBM-Party-Manastorm", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5022 $"):sub(12, -3))
mod:SetCreatureID(0000)
mod:RegisterCombat("combat")

mod:RegisterEvents(
    "PLAYER_ALIVE"
)
'''

# Main folder to create all zone folders
main_folder = os.getcwd()  # Use the current working directory as the main folder

# Iterate over each zone and its bosses
for zone, bosses in zones.items():
    # Create a folder for each zone
    zone_folder = os.path.join(main_folder, zone)
    os.makedirs(zone_folder, exist_ok=True)

    # Create a .lua file for each boss in the zone folder
    for boss in bosses:
        # Replace placeholder in the template with the boss name
        lua_content = lua_template.format(boss_name=boss)

        # Define the path for the .lua file
        lua_file_path = os.path.join(zone_folder, f"{boss}.lua")

        # Write the content to the .lua file
        with open(lua_file_path, "w") as lua_file:
            lua_file.write(lua_content)

print("Folders and Lua files created successfully!")
