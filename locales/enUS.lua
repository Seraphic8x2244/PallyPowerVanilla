SLASH_PALLYPOWER1 = "/pp"
SLASH_PALLYPOWER2 = "/pallypower"

BINDING_HEADER_PALLYPOWER_HEADER = "Pally Power"
BINDING_NAME_TOGGLE = "Toggle Buff Bar"
BINDING_NAME_REPORT = "Report Assignments"
BINDING_NAME_AUTOKEY1 = "Auto Normal Blessing Key"
BINDING_NAME_AUTOKEY2 = "Auto Greater Blessing Key"
BINDING_NAME_SEALKEY = "Cast Seal Key"

PallyPower_BlessingID = { };
PallyPower_BlessingID[0] = "Wisdom";
PallyPower_BlessingID[1] = "Might";
PallyPower_BlessingID[2] = "Salvation";
PallyPower_BlessingID[3] = "Light";
PallyPower_BlessingID[4] = "Kings";
PallyPower_BlessingID[5] = "Sanctuary";

PallyPower_AuraID = { };
PallyPower_AuraID[0] = "Devotion";
PallyPower_AuraID[1] = "Retribution";
PallyPower_AuraID[2] = "Concentration";
PallyPower_AuraID[3] = "Shadow Resistance";
PallyPower_AuraID[4] = "Frost Resistance";
PallyPower_AuraID[5] = "Fire Resistance";
PallyPower_AuraID[6] = "Sanctity";

PallyPower_SealID = { };
PallyPower_SealID[0] = "Wisdom";
PallyPower_SealID[1] = "the Crusader";
PallyPower_SealID[2] = "Light";
PallyPower_SealID[3] = "Justice";
PallyPower_SealID[4] = "Command";
PallyPower_SealID[5] = "Righteousness";

PallyPower_Greater = "Greater"
if (RegularBlessings == false) 
  then
    PallyPower_BlessingSpellSearch = "Greater Blessing of (.*)";
  else
    PallyPower_BlessingSpellSearch = "Blessing of (.*)";
end
PallyPower_AuraSpellSearch = "(.*) Aura";
PallyPower_SealSpellSearch = "Seal of (.*)";
PallyPower_SealSpellPrefix = "Seal of ";

PallyPower_Rank1 = "Rank 1"
PallyPower_RankSearch = "Rank (.*)"
PallyPower_Symbol = "Symbol of Kings"

-- _,class = UnitClass("player") returns....
PallyPower_Paladin = "PALADIN"

-- Used... ClassID .. ": Blessing of "..BlessingID
PallyPower_BuffFrameText = ": Blessing of "
PallyPower_Have = "Have: "
PallyPower_Need = "Need: "
PallyPower_NotHere = "Not Here: "
PallyPower_Dead = "Dead: "

PallyPower_Auras = " additional Auras:"
PallyPower_Seals = " additional Seals:"

PallyPower_BuffBarTitle = "Pally Buffs (%d)"

--- By Lines... Keep People the same, feel free to add yourself in the _Credits3 line if your localizing
--- And feel free to add a friend or two to special thanks
PallyPower_Credits1 = "Pally Power Vanilla"
PallyPower_Credits2 = "Version"
PallyPower_Credits3 = ""
PallyPower_Credits4 = "Original update by Hjorim / Sneakyfoot / Rake / Xerron / Azgaardian / Aznamir / ivanovlk / TheRealFayz"

-- Buff name, Class Name
PallyPower_CouldntFind = "Couldn't find a target for %s on %s!"
PallyPower_BlessingsDiffer = "Cannot cast Greater Blessing on pets when Warrior and Pet assignments differ. Use regular blessings for pets."

-- Buff name, Class name, Person Name
PallyPower_Casting = "Casting %s on %s (%s)"
-- Reporting
PallyPower_Assignments1 = "--- Paladin assignments ---"
PallyPower_Assignments2 = "--- end of assignments ---"

PallyPower_ClassID = { };
PallyPower_ClassID[0] = "Warrior";
PallyPower_ClassID[1] = "Rogue";
PallyPower_ClassID[2] = "Priest";
PallyPower_ClassID[3] = "Druid";
PallyPower_ClassID[4] = "Paladin";
PallyPower_ClassID[5] = "Hunter";
PallyPower_ClassID[6] = "Mage";
PallyPower_ClassID[7] = "Warlock";
PallyPower_ClassID[8] = "Shaman";
PallyPower_ClassID[9] = "Pet";

--XML
PALLYPOWER_CLEAR = "Clear";
PALLYPOWER_REFRESH = "Refresh";
PALLYPOWER_RESETPOSITION = "Reset Position";
PALLYPOWER_PRESETS = "Presets";
PALLYPOWER_OPTIONS = "Options";
PALLYPOWER_OPTIONS_TITLE = "Pally Power Options";
PALLYPOWER_OPTIONS_SCAN = "Scan Frequency (seconds):";
PALLYPOWER_OPTIONS_SCAN2 = "Poll Per Frame: ";
PALLYPOWER_OPTIONS_FEEDBACK_CHAT = "Show feedback in chat";
PALLYPOWER_OPTIONS_SMARTBUFFS = "Smart Buffs";
PALLYPOWER_OPTIONS_LOCK = "Lock All Frames";
PALLYPOWER_OPTIONS_RF = "Show Righteous Fury on BuffBar";
PALLYPOWER_OPTIONS_AURA = "Show Aura on BuffBar";
PALLYPOWER_OPTIONS_SEAL = "Show Seal on BuffBar";
PALLYPOWER_OPTIONS_MINIMAP_BUTTON = "Show Minimap Button";
PALLYPOWER_OPTIONS_MINIMAP_BUTTONPOS = "Minimap Button Position";
PALLYPOWER_OPTIONS_PLAY_SOUND = "Play sound when blessings expire";
PALLYPOWER_OPTIONS_HORIZONTAL_LAYOUT = "Horizontal BuffBar layout";
PALLYPOWER_OPTIONS_HIDE_BLIZZ_AURA = "Hide Blizzard aura frame";
PALLYPOWER_OPTIONS_USE_UNITXP_SP3_LOS = "Use UnitXP_SP3.dll for Line of Sight check";
PALLYPOWER_OPTIONS_USE_HDICONS = "Use HD Icons";
PALLYPOWER_OPTIONS_TRANSPARENCY = "Global Transparency";

PALLYPOWER_TEXT_DROPDOWN_SAVENEW = "Save New Set";
PALLYPOWER_TEXT_DROPDOWN_SAVECURRENT = "Save Current Set";
PALLYPOWER_TEXT_DROPDOWN_DELETE = "Delete Set";
PALLYPOWER_TEXT_DROPDOWN_SETS = "Apply Set";
PALLYPOWER_TEXT_DROPDOWN_NONE = "No sets";
PALLYPOWER_TEXT_WARNING = "Warning";
PALLYPOWER_TEXT_OK = "Ok";
PALLYPOWER_TEXT_CANCEL = "Cancel";
PALLYPOWER_TEXT_SAVENEW = "Save New Set As";
PALLYPOWER_TEXT_NEWNAME = "Type in the name of the new set:";
PALLYPOWER_TEXT_ALREADYEXISTS = "This name is already used by another set.";
PALLYPOWER_TEXT_MUSTENTER = "|cffff0000You must enter a name for the new set.";
PALLYPOWER_TEXT_OVERWRITE = "|cffff0000This set already exists, save over it?";
PALLYPOWER_TEXT_SAVING = "Saving set ";
PALLYPOWER_TEXT_DELETE = "Deleting set ";

PALLYPOWER_TEXT_WARNING_DELETE = "You are about to delete set '|cffffffff%s|r'.\nDo you really want to delete this set?";
PALLYPOWER_TEXT_WARNING_SAVE = "You are about to save changes to set '|cffffffff%s|r'";

PALLYPOWER_MESSAGE_BB_CENTERED = "PallyPowerBuffBar centered on the screen."
PALLYPOWER_MESSAGE_BB_NOTFOUND = "Frame PallyPowerBuffBar not found."

PALLYPOWER_MESSAGE_NEWVERSION = "New version of PallyPowerVanilla available"

PALLYPOWER_FREEASSIGN = "Free Assignment"
PALLYPOWER_FREEASSIGN_DESC = "Allow others to change your blessings without being Party Leader / Raid Assistant."

PALLYPOWER_MSG_PREFIX = "[PallyPower] "
PALLYPOWER_MSG_NOTPALLYORRAID = "Not in raid or not a paladin"
PALLYPOWER_MSG_BARHIDDEN = "Bar hidden"
PALLYPOWER_MSG_BARVISIBLE = "Bar visible"
PALLYPOWER_MSG_NOTPALLY = "|cffffff00PallyPower: You are not a paladin.|r"
PALLYPOWER_MSG_NOASSIGNMENTS ="|cffffff00PallyPower: No assignments found.|r"


-- Modernized UI / status text
PALLYPOWER_UI_TITLE = "PallyPower"
PALLYPOWER_UI_ASSIGNMENTS_TITLE = "PallyPower - Blessing Management"
PALLYPOWER_UI_ADVANCED = "Advanced"
PALLYPOWER_UI_ADVANCED_TITLE = "PallyPower - Advanced Options"
PALLYPOWER_UI_SECTION_MINIMAP = "Minimap"
PALLYPOWER_UI_SECTION_VISUAL = "Visual"
PALLYPOWER_UI_SECTION_LAYOUT = "Layout"
PALLYPOWER_UI_SECTION_SCANNING = "Scanning"
PALLYPOWER_UI_NAMPOWER = "Nampower"
PALLYPOWER_UI_UNITXP_SP3 = "UnitXP_SP3"
PALLYPOWER_UI_SCAN_UNITFRAMES_EVERY = "Scan Unitframes every"
PALLYPOWER_UI_UNITS_SCANNED_PER_FRAME = "Units Scanned per Frame"
PALLYPOWER_UI_SHOW_BUTTON = "Show Button"
PALLYPOWER_UI_BUTTON_POSITION = "Button Position"
PALLYPOWER_UI_HIDE_BLIZZARD_AURA_FRAME = "Hide Blizzard Aura Frame"
PALLYPOWER_UI_COMBINE_SELF_BUFFS = "Combine Self Buffs"
PALLYPOWER_UI_SELF_BUFFS_ABOVE_HEADER = "Self Buffs Above Header"
PALLYPOWER_UI_JUDGEMENT_ABOVE_HEADER = "Judgement Above Header"
PALLYPOWER_UI_VERBOSE_JUDGEMENT_REFRESH = "Verbose Judgement Refresh"
PALLYPOWER_UI_STATUS_ENABLED = "|cff00ff00Enabled|r"
PALLYPOWER_UI_STATUS_NOT_DETECTED = "|cff808080Not Detected|r"
PALLYPOWER_UI_UNAVAILABLE = "Unavailable"

PALLYPOWER_TOOLTIP_JUDGEMENT_SUFFIX = " - Judgement"
PALLYPOWER_TOOLTIP_JUDGEMENT_REFRESH = "Dodges/parries refresh Judgements"
PALLYPOWER_TOOLTIP_CAPABILITY_UNKNOWN = "Capability unknown (legacy PallyPower client)"
PALLYPOWER_TOOLTIP_ASSIGNED_JUDGEMENT = "Assigned: Judgement of "
PALLYPOWER_TOOLTIP_JUDGEMENT_OF = "Judgement of "
PALLYPOWER_TOOLTIP_NO_HOSTILE_TARGET = "No hostile target"
PALLYPOWER_TOOLTIP_BLESSINGS_SUFFIX = "'s Blessings"
PALLYPOWER_TOOLTIP_AURAS_SUFFIX = "'s Auras"
PALLYPOWER_TOOLTIP_SEALS_SUFFIX = "'s Seals"

PALLYPOWER_TEXT_WIPE_ASSIGNMENTS = "Wipe all assignments?"
PALLYPOWER_MSG_RF_REMOVED = "Righteous Fury Removed"
PALLYPOWER_MSG_SALVATION_REMOVED = "Salvation Removed"
PALLYPOWER_MSG_UNITXP_AUTO_ENABLED = "[PallyPower] UnitXP SP3 detected and auto-enabled for range/LOS checking"
PALLYPOWER_MSG_UNITXP_NOT_DETECTED = "|cffff0000[PallyPower] UnitXP SP3 is not detected/loaded|r"
PALLYPOWER_MSG_UNITXP_ENABLED = "|cff00ff00[PallyPower] UnitXP SP3 range/LOS checking ENABLED|r"
PALLYPOWER_MSG_UNITXP_DISABLED = "|cffff9900[PallyPower] UnitXP SP3 range/LOS checking DISABLED|r"

PALLYPOWER_MSG_TEST_ENABLED = "|cffff8800[PallyPower] Test mode ENABLED: |cffffffff"
PALLYPOWER_MSG_TEST_FAKE = "|cffff8800[PallyPower] Faking paladin spells/talents. Use |cffffffff/pp test off|cffff8800 to disable."
PALLYPOWER_MSG_TEST_DISABLED = "|cff00ff00[PallyPower] Test mode DISABLED. Real spell data restored."
PALLYPOWER_MSG_TEST_INACTIVE = "|cffffff00[PallyPower] Test mode is not active."
PALLYPOWER_MSG_TEST_PROFILES = "|cffffff00[PallyPower] Test profiles: |cffffffffprot|cffffff00, |cffffffffholy|cffffff00, |cffffffffret|cffffff00, |cffffffffoff"
PALLYPOWER_MSG_TEST_COMMON = "|cffffff00  All profiles include: Wisdom 6, Might 7, Salvation 1, Light 3, Devo 7, Ret 5, Conc 1"
PALLYPOWER_MSG_TEST_PROT = "|cffffff00  /pp test prot |r- + Sanctuary 4, Sanctity Aura"
PALLYPOWER_MSG_TEST_HOLY = "|cffffff00  /pp test holy |r- + Wisdom +5, Might +5 talents, Kings, Sanctity Aura"
PALLYPOWER_MSG_TEST_RET = "|cffffff00  /pp test ret  |r- + Kings, Devo Aura +5 talent, Sanctity Aura"
PALLYPOWER_MSG_TEST_OFF = "|cffffff00  /pp test off  |r- Disable test mode"

PALLYPOWER_MSG_DEBUG_LOGGER = "|cff00ff00PallyPower debug output sent to _OGAALogger|r"
PALLYPOWER_MSG_DEBUG_CHAT = "|cffff9900PallyPower debug output (install _OGAALogger for copy/paste)|r"

PALLYPOWER_UI_SHORT_TITLE = "PP"
PALLYPOWER_UI_ADDON_NAME = "PallyPowerVanilla"
PALLYPOWER_UI_UNKNOWN = "Unknown"
PALLYPOWER_UI_VERSION_PREFIX = "v"
PALLYPOWER_UI_MEMORY_SUFFIX = "MB"
PALLYPOWER_MSG_SHORT_PREFIX = "[PP] "

PALLYPOWER_TOOLTIP_VISIBILITY_DESC = "Click to show or hide this button on the Buff Bar."
PALLYPOWER_TOOLTIP_AURA_ON_BUFF_BAR = "Aura on Buff Bar"
PALLYPOWER_TOOLTIP_RF_ON_BUFF_BAR = "Righteous Fury on Buff Bar"
PALLYPOWER_TOOLTIP_SEAL_ON_BUFF_BAR = "Seal on Buff Bar"
PALLYPOWER_TOOLTIP_JUDGEMENT_ON_BUFF_BAR = "Judgement on Buff Bar"

PALLYPOWER_TOOLTIP_FRAME_LOCK_TITLE = "Frame Lock"
PALLYPOWER_TOOLTIP_FRAME_LOCK_DESC = "Click to lock or unlock PallyPower frames."
PALLYPOWER_TOOLTIP_BUFF_FEEDBACK_TITLE = "Buff Feedback"
PALLYPOWER_TOOLTIP_BUFF_FEEDBACK_DESC = "Show or hide routine Blessing cast and failure messages."
PALLYPOWER_TOOLTIP_EXPIRY_SOUND_TITLE = "Blessing Expiry Sound"
PALLYPOWER_TOOLTIP_EXPIRY_SOUND_DESC = "Toggle the sound played when Blessings expire."
PALLYPOWER_TOOLTIP_ORIENTATION_TITLE = "Buff Bar Orientation"
PALLYPOWER_TOOLTIP_ORIENTATION_DESC = "Switch between vertical and horizontal layouts."
PALLYPOWER_TOOLTIP_ANNOUNCE_TITLE = "Announce Assignments"
PALLYPOWER_TOOLTIP_ANNOUNCE_DESC = "Print current assignments to party or raid chat."
PALLYPOWER_TOOLTIP_REFRESH_TITLE = "Refresh"
PALLYPOWER_TOOLTIP_REFRESH_DESC = "Refresh PallyPower assignment data."
PALLYPOWER_TOOLTIP_CLEAR_TITLE = "Clear Assignments"
PALLYPOWER_TOOLTIP_CLEAR_DESC = "Wipe all assignments."
PALLYPOWER_TOOLTIP_ADVANCED_TITLE = "Advanced"
PALLYPOWER_TOOLTIP_ADVANCED_DESC = "Open Advanced Options."
PALLYPOWER_TOOLTIP_RESET_POSITION_TITLE = "Reset Position"
PALLYPOWER_TOOLTIP_RESET_POSITION_DESC = "Reset PallyPower frame positions."

--PALLYPOWER_HUNTER_FEIGN_DEATH = "Feign Death"
