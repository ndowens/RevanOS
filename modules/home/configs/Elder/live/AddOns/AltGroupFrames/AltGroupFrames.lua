
ZO_CreateStringId("SI_BINDING_NAME_ALTGF_TRAVEL_TO_LEADER", "Jump to group leader")

local NAME = 'AltGroupFrames'
local SV_VER = 4

local EVENT = {
    MANAGER_CREATED = 'AltGroupManagerCreated',
    UNIT_FRAME_CREATED = 'AltGroupUnitFrameCreated',
    UNIT_FRAME_ACTIVATED = 'AltGroupUnitFrameActivated',
    UNIT_FRAME_DEACTIVATED = 'AltGroupUnitFrameDisactivated',
    UNIT_FRAME_DATA_CHANGED = 'AltGroupUnitFrameDataChanged',
}
ALT_GROUP_FRAMES = {
    EVENT = EVENT
}

local ROLE_ORDER = {
    LFG_ROLE_TANK,
    LFG_ROLE_HEAL,
    LFG_ROLE_DPS,
    LFG_ROLE_INVALID
}

-------------------------------------
--Default Settings--
-------------------------------------
local DEFAULTS = {

    USE_CHARACTER_NAMES = false,
    SHOW_CLASS_ICONS = true,
    SHOW_LEVEL = false,
    SHOW_NOGROUP = false,

    FULL_ALPHA_VALUE = 1,
    FADED_ALPHA_VALUE = 0.4,

    FRAMES_PER_COLUMN = 12,

    FRAME_CONTAINER_BASE_OFFSET_X = 50,
    FRAME_CONTAINER_BASE_OFFSET_Y = 55,

    UNIT_FRAME_WIDTH = 230,
    UNIT_FRAME_HEIGHT = 32,
    UNIT_FRAME_PAD_X = 4,
    UNIT_FRAME_PAD_Y = 2,

    UNIT_FRAME_FONTSIZE = 22,
    UNIT_FRAME_ICONSIZE = 22,

    LFG_COLORS = {
        [LFG_ROLE_TANK] = ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_HEALTH],
        [LFG_ROLE_HEAL] = ZO_SKILL_XP_BAR_GRADIENT_COLORS,
        [LFG_ROLE_DPS] = ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_MAGICKA],
    },

    COMPANION_COLORS = {ZO_ColorDef:New('2F3630'), ZO_ColorDef:New('525C53')},

    SHIELD_COLOR = ZO_ColorDef:New(1, 0.49, 0.13, 0.80),
    TRAUMA_COLOR = ZO_ColorDef:New(0.8, 0.8, 0.8, 0.6),
}

local CONTANER_PAD = 5

local ALTGF_MostRecentPowerUpdateHandler = ZO_MostRecentEventHandler:Subclass()

do
    local function PowerUpdateEqualityFunction(existingEventInfo, unitTag, powerPoolIndex, powerType, powerPool, powerPoolMax)
        local existingUnitTag = existingEventInfo[1]
        local existingPowerType = existingEventInfo[3]
        return existingUnitTag == unitTag and existingPowerType == powerType
    end

    function ALTGF_MostRecentPowerUpdateHandler:New(namespace, handlerFunction, isCompanion)
        local obj = ZO_MostRecentEventHandler.New(self, namespace, EVENT_POWER_UPDATE, PowerUpdateEqualityFunction, handlerFunction)
        if isCompanion then
            obj:AddFilterForEvent(REGISTER_FILTER_UNIT_TAG, "companion")
        else
            obj:AddFilterForEvent(REGISTER_FILTER_UNIT_TAG_PREFIX, "group")
        end

        obj:AddFilterForEvent(REGISTER_FILTER_POWER_TYPE, POWERTYPE_HEALTH)

        return obj
    end
end

local function getVetIcon()
    if IsGroupUsingVeteranDifficulty() then
        return "esoui/art/lfg/gamepad/lfg_activityicon_veterandungeon.dds"
    else
        return "esoui/art/lfg/gamepad/lfg_activityicon_normaldungeon.dds"
    end
end

local function getVetPrefix()
    if IsGroupUsingVeteranDifficulty() then
        return "‡ "
    else
        return "† "
    end
end

local UnitFrames, UnitFramesManager, UnitFrame, UnitFrameCompanion, UnitFrameSettings

-------------------------------------
--Group Member Frame Settings--
-------------------------------------
UnitFrameSettings = ZO_DataSourceObject:Subclass()
function UnitFrameSettings:New(...)
    local obj = ZO_DataSourceObject.New(self)
    obj:Initialize(...)
    return obj
end

function UnitFrameSettings:Initialize(parent)
    self:SetDataSource(parent)
end

-------------------------------------
--Group Member Frame--
-------------------------------------

UnitFrame = ZO_Object:Subclass()
function UnitFrame:New(...)
    local obj = ZO_Object.New(self)
    obj:Initialize(...)
    return obj
end

function UnitFrame:Initialize(unitTag, index, container)

    self.unitTag = unitTag
    self.index = index
    self.container = container

    self.isActive = false
    self.isCompanion = unitTag == 'companion' or IsGroupCompanionUnitTag(unitTag)

    -- data --
    self.role = LFG_ROLE_INVALID
    self.classId = nil
    self.accountName = ""
    self.characterName = ""
    self.isNearby = false
    self.isDead = false
    self.isOnline = false

    self.control = CreateControlFromVirtual("ALTGF_UnitFrame"..unitTag, container:GetControl(), "ALTGF_UnitFrame")
    self.control:SetParent(container:GetControl())
    self.control.m_object = self
    self.borderControl = GetControl(self.control, "Border")
    self.nameControl = GetControl(self.control, "Name")
    self.levelControl = GetControl(self.control, "Level")
    self.iconControl = GetControl(self.control, "Icon")
    self.resourceNumbersControl = GetControl(self.control, "ResourceNumbers")
    self.healthBarControl = GetControl(self.control, "HP")
    self.shieldBarControl = GetControl(self.control, "Shield")
    self.traumaBarControl = GetControl(self.control, "Trauma")

    self.levelControl:SetTransformRotationZ(math.rad(90))

    self.curHP = 0
    self.maxHP = 0
    self.curShield = 0
    self.curTrauma = 0

    self.fadeComponents = {
        self.nameControl,
        self.levelControl,
        self.iconControl,
        self.resourceNumbersControl,
        self.healthBarControl,
        self.shieldBarControl,
        self.traumaBarControl,
    }

    self:RefreshView()
    self:RefreshPosition()

    CALLBACK_MANAGER:FireCallbacks(EVENT.UNIT_FRAME_CREATED, self)
end

-- on change sort index or change settings
function UnitFrame:RefreshView()
    local settings = self.container.SETTINGS
    self.control:SetDimensions(settings.UNIT_FRAME_WIDTH, settings.UNIT_FRAME_HEIGHT)

    local font = '$(GAMEPAD_MEDIUM_FONT)|' .. settings.UNIT_FRAME_FONTSIZE .. '|soft-shadow-thick'
    self.nameControl:SetFont(font)
    self.resourceNumbersControl:SetFont(font)

    local fontLevel = '$(GAMEPAD_MEDIUM_FONT)|' .. settings.UNIT_FRAME_FONTSIZE*0.7 .. '|soft-shadow-thin'
    self.levelControl:SetFont(fontLevel)

    self.iconControl:ClearAnchors()
    if self.container.SETTINGS.SHOW_LEVEL then
        self.iconControl:SetAnchor(LEFT, self.iconControl:GetParent(), LEFT, 14, 0)
    else
        self.iconControl:SetAnchor(LEFT, self.iconControl:GetParent(), LEFT, 1, 0)
    end

    self.shieldBarControl:SetColor(settings.SHIELD_COLOR:UnpackRGBA())
    self.traumaBarControl:SetColor(settings.TRAUMA_COLOR:UnpackRGBA())
    self:RefreshColor()
end

function UnitFrame:RefreshPosition()
    local settings = self.container.SETTINGS
    local col = zo_ceil(self.index / settings.FRAMES_PER_COLUMN)
    local row = zo_mod(self.index - 1, settings.FRAMES_PER_COLUMN)
    local x = ((col - 1) * (settings.UNIT_FRAME_WIDTH + settings.UNIT_FRAME_PAD_X)) + CONTANER_PAD
    local y = (row * (settings.UNIT_FRAME_HEIGHT + settings.UNIT_FRAME_PAD_Y)) + CONTANER_PAD
    self.control:ClearAnchors()
    self.control:SetAnchor(TOPLEFT, self.container:GetControl(), TOPLEFT, x, y)
end

-- return bool isChanged
function UnitFrame:SetSortIndex(index)
    local isChanged = self.index ~= index
    self.index = index
    self:RefreshPosition()

    return isChanged
end

function UnitFrame:RefreshData(force)

    self.accountName = GetUnitDisplayName(self.unitTag)
    self.characterName = GetUnitName(self.unitTag)
    self.classId = GetUnitClassId(self.unitTag)

    self:RefreshName()
    self:RefreshLevel()
    self:RefreshIcon()
    self:OnRoleChange(self.unitTag == 'player' and GetSelectedLFGRole() or GetGroupMemberSelectedRole(self.unitTag))
    self:OnSupportRangeUpdate(IsUnitInGroupSupportRange(self.unitTag))
    self:OnDeathStatusChange(IsUnitDead(self.unitTag), true)
    self:OnOnlineStatusChange(IsUnitOnline(self.unitTag))

    if force then
        local health, maxHealth = GetUnitPower(self.unitTag, POWERTYPE_HEALTH)
        self:OnUpdateHp(health, maxHealth, true)
    end

    CALLBACK_MANAGER:FireCallbacks(EVENT.UNIT_FRAME_DATA_CHANGED, self)
end

function UnitFrame:OnLeaderChange()
    self:RefreshName()
    self:RefreshIcon()
end

function UnitFrame:OnDifficultyChange()
    self:RefreshName()
    self:RefreshIcon()
end

function UnitFrame:RefreshName()
    local name = self.accountName
    if self.container.SETTINGS.USE_CHARACTER_NAMES then
        name = self.characterName
    end
    if IsUnitGroupLeader(self.unitTag) then
        local xy = self.container.SETTINGS.UNIT_FRAME_ICONSIZE
        if not self.container.SETTINGS.USE_CHARACTER_NAMES then 
            name = name:sub(2) 
        end
        name = zo_iconTextFormatNoSpace(getVetIcon(), xy-2, xy-2, name)
    end
    self.nameControl:SetText(name)
end

function UnitFrame:RefreshLevel()
    if self.container.SETTINGS.SHOW_LEVEL then
        local xy = self.container.SETTINGS.UNIT_FRAME_ICONSIZE
        -- Rather than showing icon, save space by showing Level as orange and CP as white
        local unitCP = GetUnitChampionPoints(self.unitTag) 
        if unitCP > 0 then
            self.levelControl:SetText(unitCP)
            self.levelControl:SetColor(1, 1, 1, 1)
        else
            self.levelControl:SetText(GetUnitLevel(self.unitTag))
            self.levelControl:SetColor(1, .25, 0, 1)
        end
        self.levelControl:SetHidden(false)
    else
        self.levelControl:SetHidden(true)
        self.levelControl:SetText("")
    end
end

function UnitFrame:RefreshIcon()
    if self.container.SETTINGS.SHOW_CLASS_ICONS then
        local xy = self.container.SETTINGS.UNIT_FRAME_ICONSIZE
        self.iconControl:SetHidden(false)
        if self.classId and self.classId > 0 then
            local classIconPath = select(8, GetClassInfo(GetClassIndexById(self.classId)))
            self.iconControl:SetText(zo_iconFormat(classIconPath, xy, xy))
        else
            self.iconControl:SetText(zo_iconFormat("esoui/art/lfg/gamepad/gp_lfg_menuicon_random.dds", xy, xy))
        end
    else
        self.iconControl:SetHidden(true)
        self.iconControl:SetText("")
    end
end

function UnitFrame:RefreshColor()
    if self.role ~= LFG_ROLE_INVALID then
        ZO_StatusBar_SetGradientColor(self.healthBarControl, self.container.SETTINGS.LFG_COLORS[self.role])
    elseif IsActiveWorldBattleground() then
        ZO_StatusBar_SetGradientColor(self.healthBarControl, self.container.SETTINGS.LFG_COLORS[LFG_ROLE_DPS])
    end
end

function UnitFrame:OnRoleChange(role)
    -- change role only if role changed to valid
    if role ~= LFG_ROLE_INVALID then
        self.role = role
        self:RefreshColor()
        return true
    elseif IsActiveWorldBattleground() then
        self:RefreshColor()
        return true
    end
    return false
end

function UnitFrame:OnDeathStatusChange(isDead)
    self.isDead = isDead
    if isDead then
        local xy = self.container.SETTINGS.UNIT_FRAME_ICONSIZE
        self.resourceNumbersControl:SetText(zo_iconFormat("esoui/art/icons/mapkey/mapkey_groupboss.dds", xy, xy))
        self:OnUpdateHp(0, self.maxHP, true)
        self:OnUpdateShield(0, true)
        self:OnUpdateTrauma(0, true)

        self:UpdateResurrectionState()
    end
end

function UnitFrame:OnOnlineStatusChange(isOnline)
    self.isOnline = isOnline
    if isOnline then
        local health, maxHealth = GetUnitPower(self.unitTag, POWERTYPE_HEALTH)
        self:OnUpdateHp(health, maxHealth, true)
        self:OnUpdateShield(0, true)
        self:OnUpdateTrauma(0, true)

        self.healthBarControl:SetHidden(false)
        self.shieldBarControl:SetHidden(false)
        self.resourceNumbersControl:SetHidden(false)
    else
        self.healthBarControl:SetHidden(true)
        self.shieldBarControl:SetHidden(true)
        self.resourceNumbersControl:SetText("")
        self.resourceNumbersControl:SetHidden(true)
    end
end

function UnitFrame:OnSupportRangeUpdate(isNearby)
    self.isNearby = isNearby
    local alphaValue = isNearby and self.container.SETTINGS.FULL_ALPHA_VALUE or self.container.SETTINGS.FADED_ALPHA_VALUE
    for i = 1, #self.fadeComponents do
        self.fadeComponents[i]:SetAlpha(alphaValue)
    end
end

function UnitFrame:OnUpdateShield(value, force)
    if self.isDead then
        value = 0
    end
    self.curShield = value
    ZO_StatusBar_SmoothTransition(self.shieldBarControl, value, self.maxHP, force)
    self:UpdateResourceNumbers(self.curHP, self.maxHP, value, self.curTrauma)
end

function UnitFrame:OnUpdateTrauma(value, force)
    if self.isDead then
        value = 0
    end
    self.curTrauma = value
    ZO_StatusBar_SmoothTransition(self.traumaBarControl, value, self.maxHP, force)
    self:UpdateResourceNumbers(self.curHP, self.maxHP, self.curShield, value)
end

function UnitFrame:OnUpdateHp(health, maxHealth, force)
    if self.isDead then
        health = 0
    end
    self.curHP = health
    self.maxHP = maxHealth
    ZO_StatusBar_SmoothTransition(self.healthBarControl, health, maxHealth, force)
    self:UpdateResourceNumbers(health, maxHealth, self.curShield, self.curTrauma)
end

function UnitFrame:UpdateResourceNumbers(health, maxHealth, shield, trauma)
    if not self.isDead then
        local text = ""
        if (shield and shield > 0) or (trauma and trauma > 0) then
            text = ZO_AbbreviateAndLocalizeNumber(health, NUMBER_ABBREVIATION_PRECISION_LARGEST_UNIT, false) .. "["
            if (shield and shield > 0) then
                text = text .. ZO_AbbreviateAndLocalizeNumber(shield, NUMBER_ABBREVIATION_PRECISION_LARGEST_UNIT, false)
            end
            if (trauma and trauma > 0) then
                text = text .. "-" .. ZO_AbbreviateAndLocalizeNumber(trauma, NUMBER_ABBREVIATION_PRECISION_LARGEST_UNIT, false)
            end
            text = text .. "]"
        else
            text = ZO_AbbreviateAndLocalizeNumber(health, NUMBER_ABBREVIATION_PRECISION_TENTHS, false)
        end
        self.resourceNumbersControl:SetText(text)
    end
end

function UnitFrame:UpdateResurrectionState()
    EVENT_MANAGER:UnregisterForUpdate(NAME .. "UpdateResurrectionState" .. self.unitTag)
    local xy = self.container.SETTINGS.UNIT_FRAME_ICONSIZE

    if IsUnitDead(self.unitTag) then
        if IsUnitBeingResurrected(self.unitTag) then
            self.resourceNumbersControl:SetText(zo_iconTextFormat("esoui/art/icons/mapkey/mapkey_groupboss.dds", xy, xy, 'Ressing...'))
        elseif DoesUnitHaveResurrectPending(self.unitTag) then
            self.resourceNumbersControl:SetText(zo_iconTextFormat("esoui/art/icons/mapkey/mapkey_groupboss.dds", xy, xy, 'Pending...'))
        else
            self.resourceNumbersControl:SetText(zo_iconFormat("esoui/art/icons/mapkey/mapkey_groupboss.dds", xy, xy))
        end
        EVENT_MANAGER:RegisterForUpdate(NAME .. "UpdateResurrectionState" .. self.unitTag, 500, function()
            self:UpdateResurrectionState()
        end)

    elseif IsUnitReincarnating(self.unitTag) then
        self.resourceNumbersControl:SetText(zo_iconTextFormat("esoui/art/icons/mapkey/mapkey_groupboss.dds", xy, xy, 'Ghost...'))

        EVENT_MANAGER:RegisterForUpdate(NAME .. "UpdateResurrectionState" .. self.unitTag, 500, function()
            self:UpdateResurrectionState()
        end)
    else
         local health, maxHealth = GetUnitPower(self.unitTag, POWERTYPE_HEALTH)
         self:UpdateResourceNumbers(health, maxHealth, 0)
    end
end

function UnitFrame:ResetBorder()
    self.borderControl:SetEdgeColor(0, 0, 0, 0)
end

function UnitFrame:SetBorderColor(r, g, b, a)
    self.borderControl:SetEdgeColor(r, g, b, a)
end

function UnitFrame:IsActive()
    return self.isActive
end

function UnitFrame:SetActive(active)
    self.isActive = active
    self.control:SetHidden(not active)
    local e = active and EVENT.UNIT_FRAME_ACTIVATED or EVENT.UNIT_FRAME_DEACTIVATED
    CALLBACK_MANAGER:FireCallbacks(e, self)
end

function UnitFrame:IsCompanion()
    return self.isCompanion
end

function UnitFrame:GetControl()
    return self.control
end

function UnitFrame:GetUnitTag()
    return self.unitTag
end

function UnitFrame:HandleMouseEnter()
    InitializeTooltip(InformationTooltip, self.control, TOP, 0, 0)
    if IsUnitGroupLeader(self.unitTag) then
        SetTooltipText(InformationTooltip, zo_iconTextFormat(getVetIcon(), 22, 22, self.accountName))
    else
        SetTooltipText(InformationTooltip, self.accountName)
    end
    InformationTooltip:AddLine(self.characterName)
    ZO_Tooltip_AddDivider(InformationTooltip)

    if IsUnitOnline(self.unitTag) then
        local health, maxHealth = GetUnitPower(self.unitTag, POWERTYPE_HEALTH)
        local hp = health.." / "..maxHealth
        local classIconPath = select(8, GetClassInfo(GetClassIndexById(GetUnitClassId(self.unitTag))))
        InformationTooltip:AddLine(zo_iconFormat(classIconPath, 22, 22)..GetUnitClass(self.unitTag))
        InformationTooltip:AddLine(zo_iconTextFormat("esoui/art/icons/alchemy/crafting_alchemy_trait_restorehealth.dds", 22, 22, hp))
        InformationTooltip:AddLine(zo_iconTextFormatNoSpace("esoui/art/compass/ava_outpost_neutral.dds", 22, 22, ZO_CachedStrFormat(SI_ZONE_NAME, GetUnitZone(self.unitTag))))
    else
        InformationTooltip:AddLine(GetString(SI_PLAYERSTATUS4))
    end
end

function UnitFrame:HandleMouseExit()
    ClearTooltip(InformationTooltip)
end

function UnitFrame:HandleMouseUp(button, upInside)
    if button == MOUSE_BUTTON_INDEX_RIGHT and upInside then
        ClearMenu()

        local isPlayer = AreUnitsEqual(self.unitTag, "player")
        local modificationRequiresVoting = DoesGroupModificationRequireVote()

        if isPlayer or self.accountName == "" then
            -- Yourself or your own companion
            AddMenuItem(GetString(SI_GROUP_LIST_MENU_LEAVE_GROUP), function() GroupLeave() end)
        elseif IsUnitOnline(self.unitTag) then
            -- Other player or their companion, which is marked with the owner's accountName
            AddMenuItem(GetString(SI_SOCIAL_LIST_PANEL_WHISPER), function() StartChatInput("", CHAT_CHANNEL_WHISPER, self.accountName) end)
            AddMenuItem(GetString(SI_SOCIAL_MENU_JUMP_TO_PLAYER), function() JumpToGroupMember(self.accountName) end)
        end

        if IsUnitGroupLeader("player") then
            if isPlayer or self.accountName == "" then
                if not modificationRequiresVoting then
                    AddMenuItem(GetString(SI_GROUP_LIST_MENU_DISBAND_GROUP), function() ZO_Dialogs_ShowDialog("GROUP_DISBAND_DIALOG") end)
                end
            else
                if IsUnitOnline(self.unitTag) then
                    AddMenuItem(GetString(SI_GROUP_LIST_MENU_PROMOTE_TO_LEADER), function() GroupPromote(self.unitTag) end)
                end
                if not modificationRequiresVoting then
                    AddMenuItem(GetString(SI_GROUP_LIST_MENU_KICK_FROM_GROUP), function() GroupKick(self.unitTag) end)
                end
            end
        end

        if modificationRequiresVoting and not isPlayer then
            AddMenuItem(GetString(SI_GROUP_LIST_MENU_VOTE_KICK_FROM_GROUP), function() BeginGroupElection(GROUP_ELECTION_TYPE_KICK_MEMBER, ZO_GROUP_ELECTION_DESCRIPTORS.NONE, self.unitTag) end)
        end

        ShowMenu(self.container)
    end
end

-------------------------------------
--Companion Frame--
-------------------------------------

UnitFrameCompanion = UnitFrame:Subclass()
function UnitFrameCompanion:New(...)
    return UnitFrame.New(self, ...)
end

function UnitFrameCompanion:RefreshData(force)

    if self.unitTag == 'companion' or GetUnitDisplayName(GetGroupUnitTagByCompanionUnitTag(self.unitTag)) == GetUnitDisplayName('player') then
        self.accountName = ""
        self.characterName = zo_strformat(SI_COMPANION_NAME_FORMATTER, GetCompanionName(GetActiveCompanionDefId()))
    else
        self.accountName = GetUnitDisplayName(GetGroupUnitTagByCompanionUnitTag(self.unitTag))
        self.characterName = self.accountName
        if self.container.SETTINGS.USE_CHARACTER_NAMES then
            self.characterName = GetUnitName(GetGroupUnitTagByCompanionUnitTag(self.unitTag))
        end
        if string.sub(self.characterName, -1) == 's' then
            self.characterName = self.characterName .. '\' Companion'
        else
            self.characterName = self.characterName .. '\'s Companion'
        end
    end
    self.classId = GetUnitClassId(self.unitTag)

    self:RefreshName()
    self:RefreshIcon()
    self:OnRoleChange(GetGroupMemberSelectedRole(self.unitTag))
    self:OnSupportRangeUpdate(IsUnitInGroupSupportRange(self.unitTag))
    self:OnDeathStatusChange(IsUnitDead(self.unitTag), true)
    self:OnOnlineStatusChange(IsUnitOnline(self.unitTag))

    if force then
        local health, maxHealth = GetUnitPower(self.unitTag, POWERTYPE_HEALTH)
        self:OnUpdateHp(health, maxHealth, true)
    end

    CALLBACK_MANAGER:FireCallbacks(EVENT.UNIT_FRAME_DATA_CHANGED, self)
end

function UnitFrameCompanion:RefreshName()
    self.nameControl:SetText(self.characterName)
end

function UnitFrameCompanion:RefreshIcon()
    if self.container.SETTINGS.SHOW_CLASS_ICONS then
        local xy = self.container.SETTINGS.UNIT_FRAME_ICONSIZE
        self.iconControl:SetHidden(false)
        self.iconControl:SetText(zo_iconFormat("esoui/art/companion/gamepad/gp_category_u30_allies.dds", xy, xy))
    else
        self.iconControl:SetHidden(true)
        self.iconControl:SetText("")
    end
end

function UnitFrameCompanion:RefreshColor()
    ZO_StatusBar_SetGradientColor(self.healthBarControl, self.container.SETTINGS.COMPANION_COLORS)
end

function UnitFrameCompanion:HandleMouseEnter()
    return nil
end

-------------------------------------
--Group Frames Manager--
--Used to manage the UnitFrame objects according to UnitTags ("group1", "group2", etc...)--
-------------------------------------

UnitFramesManager = ZO_Object:Subclass()
function UnitFramesManager:New(...)
    local obj = ZO_Object.New(self)
    obj:Initialize(...)
    return obj
end

function UnitFramesManager:Initialize(topLevelControl)
    self.EVENT = EVENT
    self.dirty = false
    self.control = topLevelControl
    self.control.m_object = self
    self.groupSize = 0
    self.unitFrames = {}
    self.SAVEVARS = ZO_SavedVars:NewAccountWide("AltGroupFramesSavedVariables", SV_VER, nil, DEFAULTS)
    self.DEFAULTS = DEFAULTS

    -- RECREATE color objects
    for k, v in pairs(self.SAVEVARS.LFG_COLORS) do
        self.SAVEVARS.LFG_COLORS[k] = {ZO_ColorDef:New(v[1]), ZO_ColorDef:New(v[2])}
    end
    self.SAVEVARS.COMPANION_COLORS = {ZO_ColorDef:New(self.SAVEVARS.COMPANION_COLORS[1]), ZO_ColorDef:New(self.SAVEVARS.COMPANION_COLORS[2])}
    self.SAVEVARS.SHIELD_COLOR = ZO_ColorDef:New(self.SAVEVARS.SHIELD_COLOR)
    self.SAVEVARS.TRAUMA_COLOR = ZO_ColorDef:New(self.SAVEVARS.TRAUMA_COLOR)

    self.SETTINGS = UnitFrameSettings:New(self.SAVEVARS)

    --self:RefreshData()
    --self:RefreshView()
    self:RegisterEvents(topLevelControl)

    CALLBACK_MANAGER:FireCallbacks(EVENT.MANAGER_CREATED, self)
end

function UnitFramesManager:RegisterEvents(topLevelControl)

    local function RegisterDelayedRefresh()
        self:SetIsDirty(true)
    end

    local function OnPlayerActivated()
        self:SetIsDirty(true)
        for _, unitFrame in pairs(self.unitFrames) do
            if unitFrame:IsActive() then
                unitFrame:OnSupportRangeUpdate(IsUnitInGroupSupportRange(unitFrame.unitTag))
            end
        end
    end

    local function OnLeaderUpdate()
        for _, unitFrame in pairs(self.unitFrames) do
            if unitFrame:IsActive() then
                unitFrame:OnLeaderChange()
            end
        end
    end

    local function OnConnectedStatus(_, unitTag, isOnline)
        self:GetFrame(unitTag):OnOnlineStatusChange(isOnline)
        self:ReorderByRole()
    end

    local function OnRoleChanged(_, unitTag, newRole)
        if self:GetFrame(unitTag):OnRoleChange(newRole) then
            self:ReorderByRole()
        end
    end

    local function onVisualPower(_, unitTag, unitAttributeVisual, statType, attributeType, powerType, oldValue, newValue, oldMaxValue, newMaxValue)
        local value = oldMaxValue == nil and oldValue or newValue
        if unitAttributeVisual == ATTRIBUTE_VISUAL_POWER_SHIELDING then
            self:GetFrame(unitTag):OnUpdateShield(value, false)
        elseif unitAttributeVisual == ATTRIBUTE_VISUAL_TRAUMA then
            self:GetFrame(unitTag):OnUpdateTrauma(value, false)
        end
    end

    local function onVisualPowerRemoved(_, unitTag, unitAttributeVisual, statType, attributeType, powerType, value, maxValue)
        if unitAttributeVisual == ATTRIBUTE_VISUAL_POWER_SHIELDING then
            self:GetFrame(unitTag):OnUpdateShield(0, false)
        elseif unitAttributeVisual == ATTRIBUTE_VISUAL_TRAUMA then
            self:GetFrame(unitTag):OnUpdateTrauma(0, false)
        end
    end

    local function OnPowerUpdate(unitTag, _, _, powerPool, powerPoolMax)
        -- already filtered with AddFilterForEvent in ALTGF_MostRecentPowerUpdateHandler
        self:GetFrame(unitTag):OnUpdateHp(powerPool, powerPoolMax, false)
    end

    topLevelControl:RegisterForEvent(EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
    topLevelControl:RegisterForEvent(EVENT_GROUP_MEMBER_LEFT, RegisterDelayedRefresh)
    topLevelControl:RegisterForEvent(EVENT_GROUP_UPDATE, RegisterDelayedRefresh)
    topLevelControl:RegisterForEvent(EVENT_LEADER_UPDATE, OnLeaderUpdate)
    topLevelControl:RegisterForEvent(EVENT_GROUP_VETERAN_DIFFICULTY_CHANGED, function() self:GetFrame(GetGroupLeaderUnitTag()):OnDifficultyChange() end)
    topLevelControl:RegisterForEvent(EVENT_GROUP_MEMBER_CONNECTED_STATUS , OnConnectedStatus)
    topLevelControl:AddFilterForEvent(EVENT_GROUP_MEMBER_CONNECTED_STATUS, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")
    topLevelControl:RegisterForEvent(EVENT_UNIT_CREATED, RegisterDelayedRefresh)
    topLevelControl:AddFilterForEvent(EVENT_UNIT_CREATED, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")
    topLevelControl:RegisterForEvent(EVENT_UNIT_DESTROYED, RegisterDelayedRefresh)
    topLevelControl:AddFilterForEvent(EVENT_UNIT_DESTROYED, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")
    topLevelControl:RegisterForEvent(EVENT_ACTIVE_COMPANION_STATE_CHANGED, RegisterDelayedRefresh)
    topLevelControl:RegisterForEvent(EVENT_GROUP_MEMBER_ROLE_CHANGED, OnRoleChanged)
    topLevelControl:AddFilterForEvent(EVENT_GROUP_MEMBER_ROLE_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")
    topLevelControl:RegisterForEvent(EVENT_GROUP_SUPPORT_RANGE_UPDATE , function(_, unitTag, isNearby) self:GetFrame(unitTag):OnSupportRangeUpdate(isNearby) end)
    topLevelControl:AddFilterForEvent(EVENT_GROUP_SUPPORT_RANGE_UPDATE, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")
    topLevelControl:RegisterForEvent(EVENT_UNIT_DEATH_STATE_CHANGED, function(_, unitTag, isDead) self:GetFrame(unitTag):OnDeathStatusChange(isDead) end) -- может баговаться
    topLevelControl:AddFilterForEvent(EVENT_UNIT_DEATH_STATE_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")
    topLevelControl:RegisterForEvent(EVENT_UNIT_ATTRIBUTE_VISUAL_ADDED, onVisualPower)
    topLevelControl:AddFilterForEvent(EVENT_UNIT_ATTRIBUTE_VISUAL_ADDED, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")
    topLevelControl:RegisterForEvent(EVENT_UNIT_ATTRIBUTE_VISUAL_UPDATED, onVisualPower)
    topLevelControl:AddFilterForEvent(EVENT_UNIT_ATTRIBUTE_VISUAL_UPDATED, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")
    topLevelControl:RegisterForEvent(EVENT_UNIT_ATTRIBUTE_VISUAL_REMOVED, onVisualPowerRemoved)
    topLevelControl:AddFilterForEvent(EVENT_UNIT_ATTRIBUTE_VISUAL_REMOVED, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")

    ALTGF_MostRecentPowerUpdateHandler:New("ALTGF_GroupList_Manager", OnPowerUpdate, false)
    ALTGF_MostRecentPowerUpdateHandler:New("ALTGF_GroupList_ManagerComp", OnPowerUpdate, true)

    local gamepadSettingsOverride
    local function applyGamepadStyle()
        gamepadSettingsOverride = self:OverrideSettings()
        gamepadSettingsOverride.UNIT_FRAME_WIDTH = self.SAVEVARS.UNIT_FRAME_WIDTH + 40
        gamepadSettingsOverride.UNIT_FRAME_HEIGHT = self.SAVEVARS.UNIT_FRAME_HEIGHT + 10
        gamepadSettingsOverride.UNIT_FRAME_PAD_X = self.SAVEVARS.UNIT_FRAME_PAD_X + 2
        gamepadSettingsOverride.UNIT_FRAME_PAD_Y = self.SAVEVARS.UNIT_FRAME_PAD_Y + 2
        gamepadSettingsOverride.UNIT_FRAME_FONTSIZE = 27
        gamepadSettingsOverride.UNIT_FRAME_ICONSIZE = 27
        self:RefreshView(true)
    end
    ZO_PlatformStyle:New(function(styleFunc) styleFunc() end, function()
        if gamepadSettingsOverride ~= nil then
            self:RemoveOverrideSettings(gamepadSettingsOverride)
            gamepadSettingsOverride = nil
            self:RefreshView(true)
        end
    end, applyGamepadStyle)
end

-- use only once per module/addon
function UnitFramesManager:OverrideSettings()
    local current = self.SETTINGS
    local new = UnitFrameSettings:New(current)
    current.overridenBy = new
    self.SETTINGS = new
    return new
end

function UnitFramesManager:RemoveOverrideSettings(settingsObj)
    local parent = settingsObj:GetDataSource()
    local overridenBy = rawget(settingsObj, "overridenBy")
    if overridenBy ~= nil then
        -- if settings was already overriden by other, current pointer (self.SETTINGS) will point to other object
        -- so we need to remove settingsObj from chain, and "connect" ends
        overridenBy:SetDataSource(parent)
    else
        -- if it was last element in chain, just update pointer
        parent.overridenBy = nil
        self.SETTINGS = parent
    end
    settingsObj = nil
end

function UnitFramesManager:ForEach(callback)
    for _, unitFrame in pairs(self.unitFrames) do
        callback(unitFrame)
    end
end

function UnitFramesManager:GetControl()
    return self.control
end

function UnitFramesManager:SaveLoc()
    self.SAVEVARS.FRAME_CONTAINER_BASE_OFFSET_X = zo_round(self.control:GetLeft())
    self.SAVEVARS.FRAME_CONTAINER_BASE_OFFSET_Y = zo_round(self.control:GetTop())
end

function UnitFramesManager:RefreshView(withElems)
    local maxCol = zo_ceil(self.groupSize / self.SETTINGS.FRAMES_PER_COLUMN)
    local maxRow = zo_min(self.groupSize, self.SETTINGS.FRAMES_PER_COLUMN)

    local x = maxCol * (self.SETTINGS.UNIT_FRAME_WIDTH + self.SETTINGS.UNIT_FRAME_PAD_X)
    local y = maxRow * (self.SETTINGS.UNIT_FRAME_HEIGHT + self.SETTINGS.UNIT_FRAME_PAD_Y)

    self.control:SetDimensions(x + (CONTANER_PAD * 2), y + (CONTANER_PAD * 2))
    self.control:ClearAnchors()
    self.control:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, self.SETTINGS.FRAME_CONTAINER_BASE_OFFSET_X, self.SETTINGS.FRAME_CONTAINER_BASE_OFFSET_Y)

    if withElems then
        for _, unitFrame in pairs(self.unitFrames) do
            -- Refresh whether or not a frame is active, so that when switching between keyboard and
            -- controller, the frames are properly resized and ready for new group members
            unitFrame:RefreshView()
            unitFrame:RefreshPosition()
        end
    end
end

function UnitFramesManager:ReorderByRole()
    local newIndex = 0

    local function posRole(role)
        for _, unitFrame in pairs(self.unitFrames) do
            if unitFrame:IsActive() and unitFrame.role == role then
                newIndex = newIndex + 1
                unitFrame:SetSortIndex(newIndex)
            end
        end
    end

    for _, role in ipairs(ROLE_ORDER) do
        posRole(role)
    end
end

function UnitFramesManager:RefreshData()
    local newGroupSize = GetGroupSize() + GetNumCompanionsInGroup()

    for i = 1, GROUP_SIZE_MAX do
        local unitTag = "group"..i
        local frame = self:GetFrame(unitTag)
        if DoesUnitExist(unitTag) then
            frame:RefreshData()
            frame:SetActive(true)
        else
            frame:SetActive(false)
        end

        local compUnitTag = GetCompanionUnitTagByGroupUnitTag(unitTag)
        if compUnitTag then
            local compFrame = self:GetFrame(compUnitTag)
            if DoesUnitExist(compUnitTag) then
                compFrame:RefreshData()
                compFrame:SetActive(true)
            else
                compFrame:SetActive(false)
            end
        end
    end

    if self.SETTINGS.SHOW_NOGROUP then
        local playerFrame = self:GetFrame('player')
        if newGroupSize > 0 then
            playerFrame:SetActive(false)
        else
            playerFrame:RefreshData()
            playerFrame:SetActive(true)
            newGroupSize = newGroupSize + 1
        end
    else
        self:GetFrame('player'):SetActive(false)
    end

    local compFrame = self:GetFrame('companion')
    if newGroupSize > 0 then
        compFrame:SetActive(false)
    else
        if HasActiveCompanion() then
            compFrame:RefreshData()
            compFrame:SetActive(true)
            newGroupSize = newGroupSize + 1
        else
            compFrame:SetActive(false)
        end
    end

    self:ReorderByRole()

    if self.groupSize ~= newGroupSize then
        self.groupSize = newGroupSize
        self:RefreshView(false)
    end

    self:SetIsDirty(false)
end

function UnitFramesManager:GetFrame(unitTag)
    local unitFrame = self.unitFrames[unitTag]
    if unitFrame == nil then
        if unitTag == 'companion' or IsGroupCompanionUnitTag(unitTag) then
            unitFrame = UnitFrameCompanion:New(unitTag, NonContiguousCount(self.unitFrames) + 1, self)
        else
            unitFrame = UnitFrame:New(unitTag, NonContiguousCount(self.unitFrames) + 1, self)
        end
        self.unitFrames[unitTag] = unitFrame
    end

    return unitFrame
end

function UnitFramesManager:TravelToLeader()
    d('Jumping to Group Leader')
    JumpToGroupLeader()
end

function UnitFramesManager:GetIsDirty()
    return self.dirty
end

function UnitFramesManager:SetIsDirty(flag)
    self.dirty = flag
end

local function DisableZoFrames()
    ZO_UnitFramesGroups:SetHidden(true)
    zo_callLater(function () UNIT_FRAMES:DisableGroupAndRaidFrames() end, 1000)

    ZO_UnitFrames:UnregisterForEvent(EVENT_LEADER_UPDATE)
    ZO_UnitFrames:UnregisterForEvent(EVENT_GROUP_SUPPORT_RANGE_UPDATE)
    ZO_UnitFrames:UnregisterForEvent(EVENT_GROUP_UPDATE)
    ZO_UnitFrames:UnregisterForEvent(EVENT_GROUP_MEMBER_LEFT)
    ZO_UnitFrames:UnregisterForEvent(EVENT_GROUP_MEMBER_CONNECTED_STATUS)
    ZO_UnitFrames:UnregisterForEvent(EVENT_GROUP_MEMBER_ROLE_CHANGED)
end

function ALTGF_UnitFrames_Initialize(topLevelControl)
    local function OnAddOnLoaded(_, addonName)
        if addonName == NAME then

            DisableZoFrames()

            UnitFrames = UnitFramesManager:New(topLevelControl)

            ALT_GROUP_FRAMES = UnitFrames

            local fragment = ZO_SimpleSceneFragment:New(topLevelControl)
            HUD_SCENE:AddFragment(fragment)
            HUD_UI_SCENE:AddFragment(fragment)
            SIEGE_BAR_SCENE:AddFragment(fragment)
            SIEGE_BAR_UI_SCENE:AddFragment(fragment)

            EVENT_MANAGER:UnregisterForEvent(NAME, EVENT_ADD_ON_LOADED)
        end
    end

    EVENT_MANAGER:RegisterForEvent(NAME, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
end

function ALTGF_UnitFrames_OnUpdate()
    if UnitFrames and UnitFrames:GetIsDirty() then
        UnitFrames:RefreshData()
    end
end