-- DEOBFUSCATION BY SLAXER
-- SERVER: https://discord.gg/QEJz4n8AP

do
  local lfwm_7e97626092df4313 = "LFWM1_XFYgxFhwlXshNr89c7mk9e7UnYTV0AVw"
  if false then error(lfwm_7e97626092df4313) end
end

-- PAID EXECUTOR VALIDATION
local PAID_EXECUTORS = {
    Xeno = true,
    Solara = true,
    Delta = true,
    Medium = true,
    SkibX = true,
    Volt = true,
    Wave = true,
    Real = true,
}

local hasValidExecutor = false
if type(gethui) == "function" and type(readfile) == "function" then
    hasValidExecutor = true
end

if not hasValidExecutor then
    warn("[BURGER HUB] This script requires a paid executor (Xeno, Solara, Delta, Medium, SkibX, Volt, Wave, or Real)")
    return
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local player = Players.LocalPlayer


-- Emergency always-on boot indicator + safe UI force (never blank screen)
local function BURGER_emergencyToast(msg)
    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "BurgerBootToast"
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.DisplayOrder = 9999
        local ok = false
        if typeof(gethui) == "function" then ok = pcall(function() sg.Parent = gethui() end) end
        if not ok then ok = pcall(function() sg.Parent = game:GetService("CoreGui") end) end
        if not ok then
            local pg = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
            if pg then sg.Parent = pg end
        end
        local f = Instance.new("Frame")
        f.Size = UDim2.fromOffset(280, 44)
        f.Position = UDim2.new(0.5, -140, 0, 20)
        f.BackgroundColor3 = Color3.fromRGB(8, 12, 20)
        f.BorderSizePixel = 0
        f.Parent = sg
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local s = Instance.new("UIStroke", f)
        s.Color = Color3.fromRGB(0, 255, 100)
        s.Thickness = 1.4
        local t = Instance.new("TextLabel", f)
        t.Size = UDim2.fromScale(1, 1)
        t.BackgroundTransparency = 1
        t.Text = tostring(msg or "BURGER loading...")
        t.TextColor3 = Color3.fromRGB(255, 220, 100)
        t.Font = Enum.Font.GothamBold
        t.TextSize = 14
        task.delay(4, function() pcall(function() sg:Destroy() end) end)
    end)
end

local M = {}

-- Burger Hub custom palette:
--   UI accents = a random color each run
--   UI aura/border = lettuce green
--   BURGER = red
--   HUB = fries yellow
local _colorRng = Random.new()
-- UI colour themes (pick one under Extras > UI Theme; re-run the script to apply)
local BH_THEMES = {
    Storm   = {accent=Color3.fromRGB(150,160,184), accent2=Color3.fromRGB(96,104,124), hi=Color3.fromRGB(232,236,246),
               bg=Color3.fromRGB(7,7,9),    row=Color3.fromRGB(15,15,18), btn=Color3.fromRGB(27,27,32),
               stroke=Color3.fromRGB(56,56,64), stroke2=Color3.fromRGB(34,34,40), off=Color3.fromRGB(44,44,50),
               dim=Color3.fromRGB(150,152,162), dim2=Color3.fromRGB(104,106,116),
               gradTop=Color3.fromRGB(20,20,24), gradBot=Color3.fromRGB(3,3,5)},
    Ocean   = {accent=Color3.fromRGB(0,200,255), accent2=Color3.fromRGB(20,70,200), hi=Color3.fromRGB(110,205,255),
               bg=Color3.fromRGB(6,11,22),  row=Color3.fromRGB(11,21,40), btn=Color3.fromRGB(18,34,62),
               stroke=Color3.fromRGB(28,72,124), stroke2=Color3.fromRGB(22,50,90), off=Color3.fromRGB(30,46,76),
               dim=Color3.fromRGB(150,176,210), dim2=Color3.fromRGB(100,130,170),
               gradTop=Color3.fromRGB(14,30,58), gradBot=Color3.fromRGB(4,8,16)},
    Crimson = {accent=Color3.fromRGB(255,72,92), accent2=Color3.fromRGB(150,20,40), hi=Color3.fromRGB(255,150,160),
               bg=Color3.fromRGB(14,6,8),   row=Color3.fromRGB(27,12,15), btn=Color3.fromRGB(44,18,23),
               stroke=Color3.fromRGB(112,34,46), stroke2=Color3.fromRGB(70,22,30), off=Color3.fromRGB(62,34,40),
               dim=Color3.fromRGB(196,152,158), dim2=Color3.fromRGB(140,100,106),
               gradTop=Color3.fromRGB(44,14,20), gradBot=Color3.fromRGB(10,3,5)},
    Violet  = {accent=Color3.fromRGB(172,112,255), accent2=Color3.fromRGB(86,40,190), hi=Color3.fromRGB(214,180,255),
               bg=Color3.fromRGB(10,7,20),  row=Color3.fromRGB(20,14,38), btn=Color3.fromRGB(32,22,60),
               stroke=Color3.fromRGB(72,50,132), stroke2=Color3.fromRGB(46,32,88), off=Color3.fromRGB(46,38,78),
               dim=Color3.fromRGB(172,162,208), dim2=Color3.fromRGB(116,106,150),
               gradTop=Color3.fromRGB(30,18,62), gradBot=Color3.fromRGB(7,4,15)},
    Emerald = {accent=Color3.fromRGB(52,232,152), accent2=Color3.fromRGB(16,130,86), hi=Color3.fromRGB(160,255,210),
               bg=Color3.fromRGB(5,14,11),  row=Color3.fromRGB(10,26,20), btn=Color3.fromRGB(16,40,32),
               stroke=Color3.fromRGB(26,94,68), stroke2=Color3.fromRGB(18,60,44), off=Color3.fromRGB(30,56,48),
               dim=Color3.fromRGB(152,196,178), dim2=Color3.fromRGB(100,140,122),
               gradTop=Color3.fromRGB(12,40,30), gradBot=Color3.fromRGB(3,9,7)},
    Gold    = {accent=Color3.fromRGB(255,198,62), accent2=Color3.fromRGB(190,120,16), hi=Color3.fromRGB(255,226,150),
               bg=Color3.fromRGB(14,11,5),  row=Color3.fromRGB(28,22,10), btn=Color3.fromRGB(44,34,14),
               stroke=Color3.fromRGB(114,88,26), stroke2=Color3.fromRGB(72,56,16), off=Color3.fromRGB(64,52,30),
               dim=Color3.fromRGB(202,186,152), dim2=Color3.fromRGB(144,130,100),
               gradTop=Color3.fromRGB(46,34,10), gradBot=Color3.fromRGB(10,8,3)},
}
local BH_THEME_ORDER = {"Storm", "Ocean", "Crimson", "Violet", "Emerald", "Gold"}
local _bhThemeName = "Storm"
pcall(function()
    if type(isfile) == "function" and type(readfile) == "function" and isfile("CherryConfig.json") then
        local d = game:GetService("HttpService"):JSONDecode(readfile("CherryConfig.json"))
        if type(d) == "table" and type(d.uiTheme) == "string" and BH_THEMES[d.uiTheme] then
            _bhThemeName = d.uiTheme
        end
    end
end)
local BH_THEME = BH_THEMES[_bhThemeName]
M.uiTheme = _bhThemeName
M.UI_THEME_ORDER = BH_THEME_ORDER
local BURGER_HUB_RANDOM = BH_THEME.accent

local BURGER_HUB_AURA = BH_THEME.accent2
local BURGER_HUB_RED = BH_THEME.accent2
local BURGER_HUB_FRIES = BH_THEME.hi

M.UI_COLORS = {
    { name = "BurgerFries", accent = BURGER_HUB_RANDOM },
    { name = "Golden",      accent = BURGER_HUB_RANDOM },
    { name = "Crispy",     accent = BURGER_HUB_RANDOM },
}
M.uiColorName = "BurgerFries"

function M.getUiColorEntry(name)
    for _, c in ipairs(M.UI_COLORS) do
        if c.name == name then return c end
    end
    return M.UI_COLORS[1]
end

function M.accentColor()
    return M.getUiColorEntry(M.uiColorName or "BurgerFries").accent
end

function M.accentDim()
    return M.accentColor():Lerp(Color3.fromRGB(0, 0, 0), 0.35)
end

function M.accentColorFor(name)
    local e = M.getUiColorEntry and M.getUiColorEntry(name)
    if e and e.accent then return e.accent end
    return M.accentColor()
end

function M.accentGradient(a)
    a = a or M.accentColor()
    local white = Color3.fromRGB(255, 255, 255)
    local black = Color3.fromRGB(0, 0, 0)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, a:Lerp(white, 0.35)),
        ColorSequenceKeypoint.new(0.35, a),
        ColorSequenceKeypoint.new(0.7, a:Lerp(black, 0.25)),
        ColorSequenceKeypoint.new(1, a:Lerp(black, 0.55)),
    })
end

M.MENU_BG_ASSET = 92856992816829
M.BURGER_HUB_FIXED_BACKGROUND = 92856992816829
-- selectable menu backgrounds (Menu Background setting)
M.MENU_BG_CHOICES = {
    {name = "GIF", id = nil, gif = true},        -- anime girl gif (default)
    {name = "Eye", id = 125569363328634},
}
-- Animated GIF background: Roblox can't play .gif files, so the gif is split into frames
-- packed in ONE spritesheet image (3 columns x 4 rows, 340x192 per frame, 12 frames).
-- Upload bg_spritesheet.png on Roblox as an image, then paste its asset ID here.
M.GIF_SHEET_ID = 114783319531049
M.GIF_COLS, M.GIF_ROWS, M.GIF_FRAMES = 3, 4, 12
M.GIF_CELL_W, M.GIF_CELL_H = 340, 192
M.GIF_FPS = 8
M.menuBgChoice = M.menuBgChoice or "GIF"
function M.menuBgChoiceEntry()
    for _, c in ipairs(M.MENU_BG_CHOICES) do
        if c.name == M.menuBgChoice then return c end
    end
    return M.MENU_BG_CHOICES[1]
end
M.BG_IMAGE_TRANSPARENCY = 0.15
M.BG_IMAGE_OPACITY = 0.85

function M.getBurgerBackgroundId()
    return M.BURGER_HUB_FIXED_BACKGROUND
end
M.BG_IMAGE_BY_COLOR = {
    BurgerFries = 92856992816829,
    Golden = 92856992816829,
    Crispy = 92856992816829,
}

function M.bgImageIdForColor(name)
    name = name or M.uiColorName or "BurgerFries"
    local id = tonumber(M.BG_IMAGE_BY_COLOR and M.BG_IMAGE_BY_COLOR[name] or 0) or 0
    if id > 0 then return id end
    return nil
end

M._editableBg = M._editableBg or {}
M._editableBgOff = false
M._bgSrcPx = nil
M._bgSrcSize = nil
M._bgWanted = nil
M._bgWorkerRunning = false

local BG_CHUNK = 16384

function M.buildEditableBg(name)
    local AssetService = game:GetService("AssetService")
    if not AssetService then return nil end
    if type(AssetService.CreateEditableImageAsync) ~= "function" then return nil end
    if type(buffer) ~= "table" and type(buffer) ~= "userdata" then return nil end
    if M._bgWanted ~= nil and M._bgWanted ~= name then return "aborted" end

    local baseId = tonumber(M.BG_IMAGE_BY_COLOR and M.BG_IMAGE_BY_COLOR.BurgerFries or 0) or 92856992816829
    local src = "rbxassetid://" .. tostring(baseId)

    local editable
    local okC, contentObj = pcall(function() return Content.fromUri(src) end)
    if okC and contentObj then
        editable = AssetService:CreateEditableImageAsync(contentObj)
    else
        editable = AssetService:CreateEditableImageAsync(src)
    end
    if not editable then return nil end

    local size = editable.Size
    local total = math.floor(size.X) * math.floor(size.Y)
    if not total or total <= 0 then return nil end

    local px
    local okCopy = false
    if M._bgSrcPx and M._bgSrcSize
        and M._bgSrcSize.X == size.X and M._bgSrcSize.Y == size.Y then
        px = buffer.create(total * 4)
        okCopy = pcall(buffer.copy, px, 0, M._bgSrcPx, 0, total * 4)
        if not okCopy then px = nil end
    end
    if not okCopy or not px then
        local raw = editable:ReadPixelsBuffer(Vector2.new(0, 0), size)
        local keep = buffer.create(total * 4)
        local okKeep = pcall(buffer.copy, keep, 0, raw, 0, total * 4)
        if okKeep then
            M._bgSrcPx = keep
            M._bgSrcSize = size
            px = raw
        else
            M._bgSrcPx = nil
            M._bgSrcSize = nil
            px = raw
        end
    end

    local accent = M.accentColorFor and M.accentColorFor(name) or M.accentColor()
    local ah, as = accent:ToHSV()
    local hh = (ah * 360) / 60
    local ii = math.floor(hh) % 6
    local ff = hh - math.floor(hh)

    local canYield = M._themeCanYield ~= false
    local t0 = os.clock()
    for i = 0, total - 1 do
        local o = i * 4
        local r = buffer.readu8(px, o) / 255
        local g = buffer.readu8(px, o + 1) / 255
        local b = buffer.readu8(px, o + 2) / 255
        local mn = g < b and g or b
        local dl = r - mn
        if dl > 0.42 * r and r > 0.06 and r > g and r > b then
            local h = ((g - b) / dl) % 6 * 60
            if h < 25 or h > 335 then
                local sat = dl / r
                local ns = math.clamp(sat * (0.6 + 0.6 * as), 0, 1)
                local pp = r * (1 - ns)
                local qq = r * (1 - ns * ff)
                local tt = r * (1 - ns * (1 - ff))
                local nr, ng, nb
                if ii == 0 then nr, ng, nb = r, tt, pp
                elseif ii == 1 then nr, ng, nb = qq, r, pp
                elseif ii == 2 then nr, ng, nb = pp, r, tt
                elseif ii == 3 then nr, ng, nb = pp, qq, r
                elseif ii == 4 then nr, ng, nb = tt, pp, r
                else nr, ng, nb = r, pp, qq end
                buffer.writeu8(px, o, math.floor(nr * 255 + 0.5))
                buffer.writeu8(px, o + 1, math.floor(ng * 255 + 0.5))
                buffer.writeu8(px, o + 2, math.floor(nb * 255 + 0.5))
            end
        end

        if i % BG_CHUNK == BG_CHUNK - 1 then
            if M._bgWanted ~= nil and M._bgWanted ~= name then return "aborted" end
            if canYield and (os.clock() - t0) > 0.003 then
                local okw = pcall(function() RunService.Heartbeat:Wait() end)
                if not okw then canYield = false end
                t0 = os.clock()
            end
        end
    end

    editable:WritePixelsBuffer(Vector2.new(0, 0), size, px)
    local okO, content = pcall(function() return Content.fromObject(editable) end)
    if okO and content then return content end
    return nil
end

function M.tryEditableBgRecolor(img, name)
    if M._editableBgOff then return false end
    local cached = M._editableBg[name]
    if cached then
        local ok = pcall(function()
            img.ImageContent = cached
            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
            img:SetAttribute("BgAccentMode", "edit:" .. name)
        end)
        if not ok then M._editableBgOff = true end
        return ok
    end
    if type(task) ~= "table" or type(task.spawn) ~= "function" then return false end

    M._bgWanted = name
    if M._bgWorkerRunning then return false end
    M._bgWorkerRunning = true
    task.spawn(function()
        for _ = 1, 64 do
            local want = M._bgWanted
            if M._editableBgOff or not want or M._editableBg[want] then break end
            local ok, res = pcall(function() return M.buildEditableBg(want) end)
            if ok and res == "aborted" then
                if M._bgWanted == want then break end
            elseif ok and res then
                M._editableBg[want] = res
                if (M.uiColorName or "BurgerFries") == want then
                    if img and img.Parent then
                        pcall(function()
                            img.ImageContent = res
                            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
                            img:SetAttribute("BgAccentMode", "edit:" .. want)
                        end)
                    end
                    pcall(function() if M.retintBackgrounds then M.retintBackgrounds() end end)
                end
            else
                M._editableBgOff = true
                break
            end
        end
        M._bgWorkerRunning = false
    end)
    return false
end

M.TITLE_VS_COLOR = BURGER_HUB_RANDOM

function M.headerTitleRich()
    return '<font color="rgb(255,45,45)">BURGER</font> <font color="rgb(255,205,55)">HUB</font>'
end

function M.applyHeaderTitle(lbl)
    lbl = lbl or M.headerTitleLbl
    if not lbl or not lbl.Parent then return end
    pcall(function()
        lbl.RichText = true
        lbl.Text = M.headerTitleRich()
        -- solid white base; colours come from RichText
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        local og = lbl:FindFirstChild("TitleOceanGrad")
        if og then pcall(function() og:Destroy() end) end
    end)
end

function M.bgTintColor(a)
    a = a or M.accentColor()
    if (M.uiColorName or "BurgerFries") == "BurgerFries" then return Color3.fromRGB(255, 255, 255) end
    local m = math.max(a.R, a.G, a.B)
    if m <= 0.004 then return Color3.fromRGB(255, 255, 255) end
    local t = Color3.new(a.R / m, a.G / m, a.B / m)
    return t:Lerp(Color3.fromRGB(255, 255, 255), 0.12)
end

function M.applyBgRecolor(img)
    if not img then return end
    local alive = false
    pcall(function() alive = img.Parent ~= nil end)
    if not alive then return end
    local name = M.uiColorName or "BurgerFries"

    local mode = nil
    pcall(function() mode = img:GetAttribute("BgAccentMode") end)
    if mode == "id:" .. name then return end
    if mode == "edit:" .. name then
        local white = false
        pcall(function() white = img.ImageColor3 == Color3.fromRGB(255, 255, 255) end)
        if white then return end
    end

    local id = M.bgImageIdForColor(name)
    if id then
        pcall(function()
            img.Image = "rbxassetid://" .. tostring(id)
            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
            img.ImageTransparency = 0
            local w = img:FindFirstChild("BgAccentWash")
            if w then w.BackgroundTransparency = 1 end
        end)
        pcall(function() img:SetAttribute("BgAccentMode", "id:" .. name) end)
        return
    end

    pcall(function() img.ImageColor3 = Color3.fromRGB(255, 255, 255) end)
    pcall(function() img.ImageTransparency = 0 end)
    pcall(function()
        local w = img:FindFirstChild("BgAccentWash")
        if w then
            w.BackgroundTransparency = 1
        end
    end)
    pcall(function() M.tryEditableBgRecolor(img, name) end)
end

function M.applyBgWash(img, corner)
    if not img then return end
    local ok = pcall(function() return img.Parent end)
    if not ok then return end
    local w = img:FindFirstChild("BgAccentWash")
    if not w then
        w = Instance.new("Frame")
        w.Name = "BgAccentWash"
        w.Size = UDim2.new(1, 0, 1, 0)
        w.Position = UDim2.new(0, 0, 0, 0)
        w.BorderSizePixel = 0
        w.ZIndex = img.ZIndex or 0
        w.Parent = img
        local c = Instance.new("UICorner")
        c.Name = "WashCorner"
        c.CornerRadius = corner or UDim.new(0, M.MENU_CORNER_R or 16)
        c.Parent = w
    end
    w.BackgroundColor3 = M.accentColor()
    w.BackgroundTransparency = 1
    return w
end

function M.retintBackgrounds()
    local tint = M.bgTintColor()
    local roots = { M.mainFrame, M.gui, M.pingGui, M.pingMain, M.killLaggerGui,
                    M.killLaggerMain, M.mobGuiRef, M.bypassPanelGui }
    local seen = {}
    for _, rt in ipairs(roots) do
        local alive = false
        pcall(function() alive = (typeof(rt) == "Instance") and rt.Parent ~= nil end)
        if alive and not seen[rt] then
            seen[rt] = true
            pcall(function()
                for _, d in ipairs(rt:GetDescendants()) do
                    if d:IsA("ImageLabel")
                        and (d.Name == "CustomBgImage" or d.Name == "BackgroundImage"
                             or d.Name == "PanelBgImage" or d:GetAttribute("BgTint")) then
                        M.applyBgRecolor(d)
                    elseif d:IsA("ImageLabel") and d.Name == "BtnBgImage" then
                        d.ImageColor3 = tint
                    end
                end
            end)
        end
    end
end

M._introUIReady = false
M._mainUILoadedAfterIntro = false

M.introSoundEnabled = true
M.introSongChoice = 3
M.introGUIEnabled = true
M.showIntro = true      -- Songs tab: show the intro animation
M.introSongOn = true    -- Songs tab: play the intro song
M.introSongSel = 0
M.introSongName = nil   -- name of the song chosen in the Songs tab
M.introFile = nil       -- local mp3 of that song (downloaded once)
M.introUrl = nil        -- where to re-download it from
function M._introLocalList()
    if M.introFile and M.introSongName then return { M.introFile } end
    return nil
end

-- Random intro music: one track is selected on every script execution.
M.INTRO_SONG_IDS = {
    70578117518239,
    124083734209869,
    104789698617710,
    131697915961558,
    109802838956577,
    127025100246703,
    81336167319253,
    104074956475668,
    101515481096059,
}
local _introMusicRng = Random.new()
M.INTRO_SONG_ID = M.INTRO_SONG_IDS[_introMusicRng:NextInteger(1, #M.INTRO_SONG_IDS)]
introSoundInstance = nil
if isfile and isfile("CherryConfig.json") then
    local ok, data = pcall(function() return HS:JSONDecode(readfile("CherryConfig.json")) end)
    if ok and type(data) == "table" then

        M.introSoundEnabled = false
        if data.introSongChoice then M.introSongChoice = data.introSongChoice end
        if data.introGUIEnabled ~= nil then M.introGUIEnabled = false end -- intro removed
        if data.circleButtonsEnabled ~= nil then M.circleButtonsEnabled = data.circleButtonsEnabled == true end
        if data.mobileButtonsEnabled ~= nil then M.mobileButtonsEnabled = data.mobileButtonsEnabled == true end
        if data.mobileButtonsLocked ~= nil then M.mobileButtonsLocked = data.mobileButtonsLocked == true end
        if type(data.mobileButtonsSize) == "number" then M.mobileButtonsSize = data.mobileButtonsSize end

        M._savedTheme = "Black White"
        M.colorScheme = "Black White"
    end
end

M.PACKS = {
    ["Amazon Unboxed"] = {
        WalkAnim = 90478085024465,
        RunAnim  = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 129126268464847,
        Swim     = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1 = 98281136301627,
        Animation2 = nil,
    },
    Vampire = {
        WalkAnim = 10921326949,
        RunAnim  = 10921320299,
        JumpAnim = 10921322186,
        FallAnim = 10921321317,
        SwimIdle = 10921325443,
        Swim     = 10921324408,
        ClimbAnim = 10921314188,
        Animation1 = 10921315373,
        Animation2 = nil,
    },
    Zombie = {
        WalkAnim = 10921355261,
        RunAnim  = 616163682,
        JumpAnim = 10921351278,
        FallAnim = 10921350320,
        SwimIdle = 10921353442,
        Swim     = 10921352344,
        Animation1 = 10921344533,
        Animation2 = 10921345304,
        ClimbAnim = 10921343576,
    },
    Tryhard = {
        WalkAnim = 707897309,
        RunAnim  = 707861613,
        JumpAnim = 116936326516985,
        FallAnim = 116936326516985,
        SwimIdle = 116936326516985,
        Swim     = 116936326516985,
        ClimbAnim = 116936326516985,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
    },
    ["Wicked Popular"] = {
        WalkAnim = 92072849924640,
        RunAnim  = 72301599441680,
        JumpAnim = 104325245285198,
        FallAnim = 121152442762481,
        SwimIdle = 113199415118199,
        Swim     = 99384245425157,
        ClimbAnim = 131326830509784,
        Animation1 = 118832222982049,
        Animation2 = 76049494037641,
    },
}
M.animPack = nil
M.animPackEnabled = false
M.ANIM_PACK_ORDER = {
    "Off",
    "Vampire",
    "Amazon Unboxed",
    "Zombie",
    "Tryhard",
    "Wicked Popular",
}
M.animPackLabel = nil
M.savedAnimate = nil
M.vynxBlackSkinEnabled = false

M.headlessEnabled = false
M.korbloxEnabled = false

M.skinPack = "Off"
M.skinPackLabel = nil
M._skinOrigOutfit = { shirt = nil, pants = nil }
M._skinOrigAccessories = {}
M.SKIN_PACK_ORDER = {
    "Off",
    "Bleed 1",
    "Bleed 2",
    "Bleed 3",
}
M.uiLayoutMode = "Vertical Top"
M.UI_LAYOUT_ORDER = {
    "Sidecar Right",
    "Sidecar Left",
    "Vertical Top",
    "Vertical Bottom",
}
M.SKIN_PACKS = {
    ["Bleed 1"] = {
        accessory = 306969564,
        offset = Vector3.new(0, 0.3, 0),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=10632503795",
        pants = "http://www.roblox.com/asset/?id=123161592384863",
        korblox = "right",
    },
    ["Bleed 2"] = {
        accessory = 1744060292,
        offset = Vector3.new(0, 1.4, -0.2),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=11526718530",
        pants = "http://www.roblox.com/asset/?id=93710523210027",
        korblox = "right",
    },
    ["Bleed 3"] = {
        accessory = 112564966849233,
        offset = Vector3.new(0, 0.6, 0),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=11849088376",
        pants = "http://www.roblox.com/asset/?id=16534673928",
        korblox = "right",
    },
}

local HEADLESS_MESH_ID = "rbxassetid://1095708"
local KORBLOX_MESH_ID = "rbxassetid://101851696"
local KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
local DARK_GREY_COLOR = Color3.fromRGB(64, 64, 64)

local function removeFace(head)
    local face = head:FindFirstChild("face")
    if face then face:Destroy() end
end

function M.applyHeadlessToChar(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if enabled then
        head.Transparency = 1
        head.CanCollide = false
        removeFace(head)

        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.MeshId == HEADLESS_MESH_ID then
                child:Destroy()
            end
        end

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = HEADLESS_MESH_ID
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Name = "HeadlessMesh"
        mesh.Parent = head

        head:GetPropertyChangedSignal("Transparency"):Connect(function()
            if head.Transparency ~= 1 then
                head.Transparency = 1
            end
        end)
        head.ChildAdded:Connect(function(child)
            if child.Name == "face" and child:IsA("Decal") then
                child:Destroy()
            end
        end)
    else
        head.Transparency = 0
        head.CanCollide = true
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then
                child:Destroy()
            end
        end
        removeFace(head)
    end
end

function M.applyKorbloxToChar(char, enabled)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if enabled then
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then
                        child:Destroy()
                    end
                end
                rightLeg.Color = DARK_GREY_COLOR
                rightLeg:GetPropertyChangedSignal("Color"):Connect(function()
                    if rightLeg.Color ~= DARK_GREY_COLOR then
                        rightLeg.Color = DARK_GREY_COLOR
                    end
                end)
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = rightLeg
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 1
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 1 end
                if rightFoot then rightFoot.Transparency = 1 end

                local oldKorblox = char:FindFirstChild("KorbloxLeg")
                if oldKorblox then oldKorblox:Destroy() end

                local korbloxLeg = Instance.new("Part")
                korbloxLeg.Name = "KorbloxLeg"
                korbloxLeg.Size = Vector3.new(1, 2, 1)
                korbloxLeg.Anchored = false
                korbloxLeg.CanCollide = false
                korbloxLeg.Color = DARK_GREY_COLOR
                korbloxLeg.Parent = char

                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = korbloxLeg

                local weld = Instance.new("Weld")
                weld.Part0 = rightUpperLeg
                weld.Part1 = korbloxLeg
                weld.C0 = CFrame.new(0, -0.8, 0)
                weld.Name = "KorbloxWeld"
                weld.Parent = korbloxLeg
            end
        end
    else
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then
                        child:Destroy()
                    end
                end
                rightLeg.Color = Color3.fromRGB(255, 255, 255)
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 0
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 0 end
                if rightFoot then rightFoot.Transparency = 0 end
                local korbloxLeg = char:FindFirstChild("KorbloxLeg")
                if korbloxLeg then korbloxLeg:Destroy() end
            end
        end
    end
end


function M._skinSaveOutfit(char)
    if not char then return end
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    M._skinOrigOutfit.shirt = shirt and shirt.ShirtTemplate or nil
    M._skinOrigOutfit.pants = pants and pants.PantsTemplate or nil
    M._skinOrigAccessories = {}
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") then
            pcall(function() table.insert(M._skinOrigAccessories, child:Clone()) end)
        end
    end
end

function M._skinClearOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("Accessory") or obj:IsA("Hat")
            or obj.Name == "AuFfitAccessory" or obj.Name == "BurgerSkinPackAcc" then
            pcall(function() obj:Destroy() end)
        end
        if tostring(obj.Name):find("Korblox_") or tostring(obj.Name):find("Headless_") then
            pcall(function() obj:Destroy() end)
        end
    end
    for _, partName in ipairs({"Head","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot","Left Leg","Right Leg"}) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then pcall(function() part.Transparency = 0 end) end
    end
end

function M._skinRestoreOutfit(char)
    if not char then return end
    M._skinClearOutfit(char)
    if M._skinOrigOutfit.shirt then
        local s = Instance.new("Shirt"); s.ShirtTemplate = M._skinOrigOutfit.shirt; s.Parent = char
    end
    if M._skinOrigOutfit.pants then
        local p = Instance.new("Pants"); p.PantsTemplate = M._skinOrigOutfit.pants; p.Parent = char
    end
    for _, clone in ipairs(M._skinOrigAccessories or {}) do
        pcall(function()
            local c = clone:Clone()
            c.Parent = char
        end)
    end
end

function M._skinApplyPackConfig(char, config)
    if not char or not config then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if config.stripAccessories then
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Accessory") or child:IsA("Hat") then pcall(function() child:Destroy() end) end
        end
    end

    if config.bodyColor then
        local bc = char:FindFirstChildOfClass("BodyColors") or Instance.new("BodyColors")
        bc.Parent = char
        pcall(function()
            bc.HeadColor3 = config.bodyColor
            bc.LeftArmColor3 = config.bodyColor
            bc.RightArmColor3 = config.bodyColor
            bc.LeftLegColor3 = config.bodyColor
            bc.RightLegColor3 = config.bodyColor
            bc.TorsoColor3 = config.bodyColor
        end)
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                pcall(function()
                    p.Color = config.bodyColor
                    if p:IsA("MeshPart") then p.TextureID = "" end
                end)
            end
        end
    end

    if config.headless then
        pcall(function()
            head.Transparency = 1
            head.CanCollide = false
            local face = head:FindFirstChild("face") or head:FindFirstChild("Face")
            if face then face:Destroy() end
            for _, c in ipairs(head:GetChildren()) do
                if c:IsA("SpecialMesh") and c.Name == "HeadlessMesh" then c:Destroy() end
            end
            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = config.headMesh or HEADLESS_MESH_ID
            mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
            mesh.Name = "HeadlessMesh"
            mesh.Parent = head
        end)
        M.headlessEnabled = true
    end

    if config.headMesh and not config.headless then
        pcall(function()
            if head:IsA("MeshPart") then
                head.MeshId = config.headMesh
                if config.headTexture then head.TextureID = config.headTexture end
            else
                local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
                sm.Parent = head
                sm.MeshType = Enum.MeshType.FileMesh
                sm.MeshId = config.headMesh
                sm.TextureId = config.headTexture or ""
            end
        end)
    end

    if config.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"; s.ShirtTemplate = config.shirt; s.Parent = char
    end
    if config.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"; p.PantsTemplate = config.pants; p.Parent = char
    end

    if config.accessory and head then
        local old = char:FindFirstChild("AuFfitAccessory") or char:FindFirstChild("VynxSkinPackAcc")
        if old then pcall(function() old:Destroy() end) end
        local objs = nil
        local ok, res = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(config.accessory))
        end)
        if ok and type(res) == "table" and #res > 0 then objs = res
        else
            ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(config.accessory) end)
            if ok and res then objs = {res} end
        end
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "VynxSkinPackAcc"
                h.CanCollide = false
                h.Anchored = false
                h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head
                weld.Part1 = h
                weld.C0 = CFrame.new(config.offset or Vector3.zero)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end

    if config.korblox and config.korblox ~= "none" then
        M.korbloxEnabled = true
        pcall(function() M.applyKorbloxToChar(char, true) end)
    end
end

function M.applySkinPack(packName)
    packName = packName or "Off"
    M.skinPack = packName
    if M.skinPackLabel then pcall(function() M.skinPackLabel.Text = packName end) end
    local char = player.Character
    if not char then return end

    if packName == "Off" then
        M.headlessEnabled = false
        M.korbloxEnabled = false
        pcall(function() if M.avLogWearOff then M.avLogWearOff() end end)
        M._skinRestoreOutfit(char)
        pcall(function() M.applyHeadlessToChar(char, false) end)
        pcall(function() M.applyKorbloxToChar(char, false) end)
        pcall(function() if saveCherryConfig then saveCherryConfig() end end)
        return
    end

    local isAvatar = false
    for _, a in ipairs(M.AVLOG_RARE or {}) do
        if a.name == packName then isAvatar = true break end
    end
    if isAvatar and M.avLogWear then
        pcall(function() M.avLogWear(packName, true) end)
        pcall(function() if saveCherryConfig then saveCherryConfig() end end)
        return
    end

    local config = M.SKIN_PACKS[packName]
    if not config then return end

    pcall(function() if M.avLogWearOff then M.avLogWearOff() end end)
    if not M._skinOrigOutfit.shirt and not M._skinOrigOutfit.pants and #(M._skinOrigAccessories or {}) == 0 then
        M._skinSaveOutfit(char)
    end
    M._skinClearOutfit(char)
    M._skinApplyPackConfig(char, config)
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end


function M.cycleAnimPack(direction)
    direction = direction or 1
    local order = M.ANIM_PACK_ORDER or {"Off"}
    local current = "Off"
    if M.animPackEnabled and type(M.animPack) == "string" and M.animPack ~= "" then
        current = M.animPack
    end
    local idx = 1
    for i, name in ipairs(order) do
        if name == current then idx = i; break end
    end
    local newIdx = idx + direction
    if newIdx < 1 then newIdx = #order end
    if newIdx > #order then newIdx = 1 end
    local packName = order[newIdx]
    if packName == "Off" then
        M.animPackEnabled = false
        M.animPack = nil
        M.unwalkEnabled = false
        if M.setUnwalkVisual then pcall(function() M.setUnwalkVisual(false) end) end
        local ch = player.Character
        if ch then
            if M.resetAnimations then pcall(function() M.resetAnimations(ch) end) end
            if M.forceVanillaAnimate then pcall(function() M.forceVanillaAnimate(ch) end) end
            if M.applyWalkState then pcall(function() M.applyWalkState(ch) end) end
        end
    else
        M.unwalkEnabled = false
        if M.setUnwalkVisual then pcall(function() M.setUnwalkVisual(false) end) end
        M.animPackEnabled = true
        M.animPack = packName
        pcall(function() M.applyAnimPack(packName) end)
    end
    if M.animPackLabel then
        pcall(function()
            M.animPackLabel.Text = (M.animPackEnabled and M.animPack) or "Off"
        end)
    end
    -- clear old toggle visuals if still present
    if M.setVampireAnimVisual then pcall(function() M.setVampireAnimVisual(M.animPack == "Vampire") end) end
    if M.setAmazonAnimVisual then pcall(function() M.setAmazonAnimVisual(M.animPack == "Amazon Unboxed") end) end
    if M.setZombieAnimVisual then pcall(function() M.setZombieAnimVisual(M.animPack == "Zombie") end) end
    if M.setTryhardAnimVisual then pcall(function() M.setTryhardAnimVisual(M.animPack == "Tryhard") end) end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

function M.cycleSkinPack(direction)
    direction = direction or 1
    local order = M.SKIN_PACK_ORDER or {"Off"}
    local idx = 1
    for i, name in ipairs(order) do
        if name == M.skinPack then idx = i; break end
    end
    local newIdx = idx + direction
    if newIdx < 1 then newIdx = #order end
    if newIdx > #order then newIdx = 1 end
    M.applySkinPack(order[newIdx])
end

M.vynxHornsEnabled = false
M._vynxHornConns = {}
M._vynxHornParts = {}

function M.clearBurgerHorns(char)
end

function M.buildBurgerHorns(char, head)
end

function M.equipBurgerHorns(char)
end

function M.setBurgerHorns(on)
    M.vynxHornsEnabled = false
    if M.setBurgerHornsVisual then pcall(function() M.setBurgerHornsVisual(false) end) end
end

function M.applyBurgerWhiteSkin(char)
    if not char then return end
    local white = Color3.fromRGB(255, 255, 255)
    local bodyColors = char:FindFirstChildOfClass("BodyColors")
    if not bodyColors then
        bodyColors = Instance.new("BodyColors")
        bodyColors.Parent = char
    end
    for _, prop in ipairs({"HeadColor3","LeftArmColor3","LeftLegColor3","RightArmColor3","RightLegColor3","TorsoColor3"}) do
        pcall(function() bodyColors[prop] = white end)
    end
    local shirt = char:FindFirstChildOfClass("Shirt")
    if not shirt then
        shirt = Instance.new("Shirt")
        shirt.Name = "BurgerWhiteShirt"
        shirt.Parent = char
    end
    pcall(function() shirt.ShirtTemplate = "rbxassetid://855777286" end)
    local pants = char:FindFirstChildOfClass("Pants")
    if not pants then
        pants = Instance.new("Pants")
        pants.Name = "BurgerWhitePants"
        pants.Parent = char
    end
    pcall(function() pants.PantsTemplate = "rbxassetid://855782781" end)

    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") then
            pcall(function() child:Destroy() end)
        end
    end
    end

M.vynxWhiteSkinEnabled = false

function M.applyCharterToChar(char)
    if not char then return end

    if M.removeAccEnabled then
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Accessory") or child:IsA("Hat") then
                if not (child:GetAttribute("VynxSkin") or child:GetAttribute("BurgerHorn") or (child.Name and (child.Name:find("Vynx") or child.Name:find("BurgerHorn")))) then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end
    if M.headlessEnabled then
        pcall(function() M.applyHeadlessToChar(char, true) end)
    else
        pcall(function() M.applyHeadlessToChar(char, false) end)
    end
    if M.korbloxEnabled then
        pcall(function() M.applyKorbloxToChar(char, true) end)
    else
        pcall(function() M.applyKorbloxToChar(char, false) end)
    end

    if false and M.vynxHornsEnabled then
        pcall(function() M.equipBurgerHorns(char) end)
    end

    if M.skinPack and M.skinPack ~= "Off" and M.SKIN_PACKS and M.SKIN_PACKS[M.skinPack] then
        task.defer(function()
            if player.Character == char then
                pcall(function() M.applySkinPack(M.skinPack) end)
            end
        end)
    end

    -- Animations: only pack/unwalk if toggled on; otherwise original (vanilla)
    if M.applyWalkState then
        pcall(function() M.applyWalkState(char) end)
    elseif M.animPackEnabled and M.animPack and M.PACKS and M.PACKS[M.animPack] then
        pcall(function() M.applyAnimPack(M.animPack) end)
    elseif M.unwalkEnabled == true then
        pcall(function() if M.startUnwalk then M.startUnwalk() end end)
    else
        pcall(function()
            if M.forceVanillaAnimate then M.forceVanillaAnimate(char)
            elseif M.resetAnimations then M.resetAnimations(char) end
        end)
    end
end

function M.stripBurgerClothing(char)
    if not char then return end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Shirt") or c:IsA("Pants")
            or c:IsA("ShirtGraphic") or c:IsA("Clothing")
            or c.ClassName == "LayeredClothing" then
            if not c:GetAttribute("BurgerChip") then
                pcall(function() c:Destroy() end)
            end
        end

    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    pcall(function()
        if not hum then return end
        local desc = hum:GetAppliedDescription()
        if not desc then return end
        desc.Shirt = 0
        desc.Pants = 0
        desc.GraphicTShirt = 0
        pcall(function() hum:ApplyDescription(desc) end)
    end)
end

function M.clearBurgerTorsoChip(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part.Name == "BurgerTorsoChipBB" or part.Name == "BurgerTorsoChipSG" then
            pcall(function() part:Destroy() end)
        end
    end
end

function M.attachBurgerPantsTag(char)
    -- BURGER pants/shirt text tags removed
    if not char then return end
    local legNames = {
        "LeftLowerLeg", "RightLowerLeg", "LeftUpperLeg", "RightUpperLeg",
        "Left Leg", "Right Leg",
    }
    for _, name in ipairs(legNames) do
        local leg = char:FindFirstChild(name)
        if leg then
            for _, c in ipairs(leg:GetChildren()) do
                if c.Name == "BurgerPantsTag" or c:GetAttribute("BurgerChip") then
                    pcall(function() c:Destroy() end)
                end
            end
        end
    end
end

function M.attachBurgerBellyTag(char)
    -- Burger belly/torso text tags removed
    if not char then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not torso then return end
    for _, c in ipairs(torso:GetChildren()) do
        if c.Name == "BurgerBellyTag" or c.Name == "BurgerTorsoChipBB" or c.Name == "BurgerTorsoChipSG" then
            pcall(function() c:Destroy() end)
        end
    end
end

function M.attachBurgerHat(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head then return end
    for _, c in ipairs(char:GetChildren()) do
        if c.Name == "BurgerHat" or c.Name == "BurgerHatBrim" or (c:IsA("Accessory") and c:GetAttribute("BurgerChip")) then
            pcall(function() c:Destroy() end)
        end
    end

    local acc = Instance.new("Accessory")
    acc.Name = "BurgerHat"
    acc:SetAttribute("BurgerChip", true)

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 1)
    handle.Color = Color3.fromRGB(10, 10, 12)
    handle.Material = Enum.Material.SmoothPlastic
    handle.CanCollide = false
    handle.Massless = true
    handle.Transparency = 0
    handle.Parent = acc

    local mesh = Instance.new("SpecialMesh")
    mesh.Name = "Mesh"
    mesh.MeshType = Enum.MeshType.FileMesh

    mesh.MeshId = "rbxassetid://1026228"
    mesh.TextureId = ""
    mesh.Scale = Vector3.new(1.35, 1.35, 1.35)
    mesh.VertexColor = Vector3.new(0.05, 0.05, 0.06)
    mesh.Parent = handle

    local att = Instance.new("Attachment")
    att.Name = "HatAttachment"
    att.Parent = handle

    acc.Parent = char
    pcall(function()
        if hum then
            hum:AddAccessory(acc)
        end
    end)

    if not handle:FindFirstChildOfClass("Weld") and not handle:FindFirstChildOfClass("WeldConstraint") then
        local w = Instance.new("Weld")
        w.Part0 = head
        w.Part1 = handle
        w.C0 = CFrame.new(0, 0.65, 0.05)
        w.Parent = handle
    end
end

function M.applyBurgerBlackSkin(char)
    char = char or player.Character
    if not char then return end
    if not M.vynxBlackSkinEnabled then return end

    M.stripBurgerClothing(char)
    M.clearBurgerTorsoChip(char)

    local black = Color3.fromRGB(15, 15, 17)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart"
            and p.Name ~= "BurgerHat" and p.Name ~= "BurgerHatBrim" then
            pcall(function()
                p.Color = black
                p.Material = Enum.Material.SmoothPlastic
                if p:IsA("MeshPart") then
                    p.TextureID = ""
                end
            end)
        elseif p:IsA("SpecialMesh") and p.Parent and p.Parent.Name ~= "BurgerHat" then
            pcall(function()
                p.TextureId = ""
            end)
        elseif p:IsA("Decal") or p:IsA("Texture") then
            if p.Name == "face" or p.Name == "Face" then
                pcall(function() p:Destroy() end)
            end
        end
    end
    local bc = char:FindFirstChildOfClass("BodyColors")
    if bc then
        pcall(function()
            bc.HeadColor3 = black
            bc.LeftArmColor3 = black
            bc.RightArmColor3 = black
            bc.LeftLegColor3 = black
            bc.RightLegColor3 = black
            bc.TorsoColor3 = black
        end)
    end

    -- BURGER text tags disabled
    pcall(function() M.attachBurgerBellyTag(char) end) -- cleans only
    pcall(function() M.attachBurgerPantsTag(char) end) -- cleans only
    M.attachBurgerHat(char)

    if M._vynxBlackChildConn then
        pcall(function() M._vynxBlackChildConn:Disconnect() end)
        M._vynxBlackChildConn = nil
    end
    M._vynxBlackChildConn = char.ChildAdded:Connect(function(c)
        if not M.vynxBlackSkinEnabled then return end
        if c:GetAttribute("BurgerChip") then return end
        if c.Name == "BurgerHat" or c.Name == "BurgerHatBrim" or c:GetAttribute("BurgerChip") then return end

        if c:IsA("Shirt") or c:IsA("Pants")
            or c:IsA("ShirtGraphic") or c:IsA("Clothing") then
            task.defer(function() pcall(function() c:Destroy() end) end)
        end
    end)
end

M.VYNC_SKIN_ID = 116358759349760
M.vyncSkinEnabled = false

local function vyncStrip(char)

    if not char then return end
end

local function vyncFindAcc(obj)
    if not obj then return nil end
    if obj:IsA("Accessory") or obj:IsA("Hat") then return obj end
    local a = obj:FindFirstChildOfClass("Accessory") or obj:FindFirstChildOfClass("Hat")
    if a then return a end
    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA("Accessory") or d:IsA("Hat") then return d end
    end
    return nil
end

local function vyncLoad(id)
    id = tonumber(id) or 0
    if id <= 0 then return nil end
    local url = "rbxassetid://" .. tostring(id)
    local bag = {}
    pcall(function()
        if typeof(getobjects) == "function" then
            local t = getobjects(url)
            if type(t) == "table" then for _, o in ipairs(t) do table.insert(bag, o) end end
        elseif game.GetObjects then
            local t = game:GetObjects(url)
            if type(t) == "table" then for _, o in ipairs(t) do table.insert(bag, o) end end
        end
    end)
    pcall(function()
        local m = game:GetService("InsertService"):LoadAsset(id)
        if m then table.insert(bag, m) end
    end)
    pcall(function()
        local IS = game:GetService("InsertService")
        if IS.LoadLocalAsset then
            local o = IS:LoadLocalAsset(url)
            if o then table.insert(bag, o) end
        end
    end)
    for _, o in ipairs(bag) do
        local acc = vyncFindAcc(o)
        if acc then
            local cl = acc:Clone()
            cl:SetAttribute("VynxSkin", true)
            cl.Name = "VynxSkin"
            for _, x in ipairs(bag) do pcall(function() x:Destroy() end) end
            return cl
        end
    end
    for _, x in ipairs(bag) do pcall(function() x:Destroy() end) end
    return nil
end

function M.applyVyncSkin(char)
    if not M.vyncSkinEnabled then return end
    char = char or player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 6)
    if not hum then return end
    vyncStrip(char)
    for _, c in ipairs(char:GetChildren()) do
        if (c:IsA("Accessory") or c:IsA("Hat")) and c:GetAttribute("VynxSkin") then return end
    end
    local id = tonumber(M.VYNC_SKIN_ID) or 116358759349760
    local acc = vyncLoad(id)
    if acc then
        pcall(function() hum:AddAccessory(acc) end)
        if not acc.Parent then acc.Parent = char end
        return
    end
    pcall(function()
        local desc = hum:GetAppliedDescription()
        if not desc then return end
        local idStr = tostring(id)
        for _, slot in ipairs({"HatAccessory","HairAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory","FrontAccessory","BackAccessory","WaistAccessory"}) do
            pcall(function() desc[slot] = "" end)
        end
        for _, slot in ipairs({"HatAccessory","HairAccessory","BackAccessory","FrontAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory","WaistAccessory"}) do
            pcall(function() desc[slot] = idStr end)
        end
        pcall(function() hum:ApplyDescription(desc) end)
        task.wait(0.12)
        local kept = false
        for _, c in ipairs(char:GetChildren()) do
            if c:IsA("Accessory") or c:IsA("Hat") then
                if not kept then
                    kept = true
                    c:SetAttribute("VynxSkin", true)
                    c.Name = "VynxSkin"
                else
                    pcall(function() c:Destroy() end)
                end
            end
        end
        if not kept then
            local a2 = vyncLoad(id)
            if a2 then
                pcall(function() hum:AddAccessory(a2) end)
                if not a2.Parent then a2.Parent = char end
            end
        end
    end)
end

function M.clearVyncSkin(char)
    char = char or player.Character
    if not char then return end
    for _, c in ipairs(char:GetChildren()) do
        if (c:IsA("Accessory") or c:IsA("Hat")) and (c:GetAttribute("VynxSkin") or c.Name == "VynxSkin") then
            pcall(function() c:Destroy() end)
        end
    end
end

function M.setVyncSkin(on)
    M.vyncSkinEnabled = on == true
    if M.vyncSkinEnabled then
        M.applyVyncSkin(player.Character)
        task.delay(0.8, function() if M.vyncSkinEnabled then M.applyVyncSkin(player.Character) end end)
    else
        M.clearVyncSkin(player.Character)
    end
    if M.setVyncSkinVisual then pcall(function() M.setVyncSkinVisual(M.vyncSkinEnabled) end) end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

function M.startVyncSkinWatch()
    if M._vyncCharConn then pcall(function() M._vyncCharConn:Disconnect() end); M._vyncCharConn = nil end
    M._vyncCharConn = player.CharacterAdded:Connect(function(char)
        if not M.vyncSkinEnabled then return end
        task.wait(0.45)
        M.applyVyncSkin(char)
        task.delay(1.2, function() if M.vyncSkinEnabled and player.Character == char then M.applyVyncSkin(char) end end)
        task.delay(2.5, function() if M.vyncSkinEnabled and player.Character == char then M.applyVyncSkin(char) end end)
    end)
    if M.vyncSkinEnabled and player.Character then
        task.defer(function() M.applyVyncSkin(player.Character) end)
    end
end

player.CharacterAdded:Connect(function(char)
    task.wait(0.35)

    M.applyCharterToChar(char)
    task.delay(0.25, function()
        if player.Character ~= char then return end
        pcall(function() M.applyWalkState(char) end)
        pcall(function() M.applyCharterToChar(char) end)
    end)
    task.delay(1.0, function()
        if player.Character ~= char then return end
        pcall(function() M.applyCharterToChar(char) end)
    end)
    task.delay(2.0, function()
        if player.Character ~= char then return end
        pcall(function() M.applyCharterToChar(char) end)
    end)
end)

task.spawn(function()
    task.wait(0.2)
    pcall(M.startVyncSkinWatch)
end)

M.NS = 59.5 -- from second source NormalSpeed
M.CS = 28.8 -- from second source CarrySpeed
M.LAGGER_SPEED = 24.5 -- from second source LaggerSpeed
M.LAGGER_CARRY_SPEED = 15 -- from second source LaggerCarrySpeed
M.BYPASS_SPEED = 40
M.BYPASS_CARRY_SPEED = 22
M.speedMethod = "LinearVelocity" -- RitualHub plane LV
M.speedMethodList = {
    "Velocity", "AssemblyLinearVelocity", "Velocity Lerp", "AssemblyLinearVelocity Lerp",
    "CFrame", "CFrame Lerp", "Hyper CFrame", "Anchored CFrame", "PivotTo", "Model PivotTo", "Tween CFrame",
    "WalkSpeed", "Humanoid Move", "Humanoid MoveTo",
    "BodyVelocity", "BodyPosition", "BodyForce", "BodyThrust",
    "LinearVelocity", "VectorForce", "AlignPosition",
    "ApplyImpulse", "RocketPropulsion",
}
M.hyperMult = 4
M._lastSpeedMethod = nil
M._speedHRP = nil
M._anchoredBySpeed = nil
M._bodyVel = nil
M._bodyPosition = nil
M._bodyForce = nil
M._bodyThrust = nil
M._linearVel = nil
M._vectorForce = nil
M._alignPos = nil
M._rocket = nil
M._rocketTarget = nil
M._attLinVel = nil
M._attVecForce = nil
M._attAlign = nil
M._speedTween = nil
M.carrySpeedActive = false
M.laggerModeEnabled = false
M.laggerCarryActive = false
M.speedCustomizerEnabled = false
M.speedCustomizerPanel = nil
M.speedUIMode = "Original"
M.speedBoosterEnabled = true
M.speedBoosterPath = "Normal"
M.speedBoosterPanelOpen = false
M.speedBoosterPos = nil
M.speedBoosterGui = nil
M.speedBoosterMain = nil

M.antiRagdollEnabled = false
M.hardHitEnabled = false
M.hardHitRadius = 10
M.antiRagdollMode = "Splatter"
M.infJumpEnabled = false
M.infJumpMode = "manual"
M.medusaCounterEnabled = false
M.batCounterEnabled = false
M.unwalkEnabled = false
M.medusaResetEnabled = false
M.medusaDebounce = false
M.medusaLastUsed = 0
M.dropActive = false
M.antiDropEnabled = true
M._antiDropAllow = false
M._antiDropLastTool = nil
M._antiDropConns = M._antiDropConns or {}
M.autoLeftEnabled = false
M.autoRightEnabled = false
M.autoBatEnabled = false
M.autoSwingEnabled = true
M.autoMoveSwingEnabled = false
M.autoMoveSwingInterval = 0.3
M._alSwingDebounce = false
M._arSwingDebounce = false
M.antiLagEnabled = false
M.fpsBoostEnabled = false
M._stretchRezConn = nil
M.batAimbotMode = M.batAimbotMode or "Normal" -- Normal | Bypass (Spectrum) | V2 (internal, set by the Bat V2 button)
M.pingAlertEnabled = false
M.pingAlertThreshold = 120
M._pingAlertTask = nil
M._pingAlertConn = nil
M.pingPopupGui = nil
M.pingPopupActive = false

M.antiSummerBaseEnabled = false
M.antiSummerBaseConn = nil
M._antiSummerCleaned = {}

M.removeAccessoriesEnabled = false
M.antiLagDescConn = nil
M.unwalkSavedAnimate = nil
M._anyKeyListening = false
M.autoTPEnabled = false
M.autoTPHeight = 20
M.mirrorTPDownEnabled = true
M.mirrorTPPreviousY = {}
M.mirrorTPLastTeleport = 0
M.MIRROR_TP_DROP_THRESHOLD = 3
M.MIRROR_TP_DOWN_Y = -7.00
M.perfectHitEnabled = true
M.autoTPConn = nil
M.cursedResetRemote = nil
M.CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
M.guiTransparencyEnabled = false
M.mobileButtonsEnabled = true
M.mobileButtonsLocked = false
M.mobileButtonsSize = 60
M.circleButtonsEnabled = false
M.mobileBtnVisible = {
    autoLeft = true, autoRight = true, autoBat = true, batV2 = true,
    drop = true, tpDown = true, reset = true, laggerCarry = true,
    lagger = true, carrySpeed = true,
}
M.mobBtnRefs = {}
M.mobGuiRef = nil
M.fovValue = 90
M.fovOptions = {70, 80, 90, 100, 120, 150, 180}
M.fovIndex = 3
M.laggerModePillRef = nil
M.carryModePillRef = nil
M.autoSwitchSpeedEnabled = false
M.autoTurnOffSpeedEnabled = false
M.autoSwitchLaggerSpeedEnabled = false
M.autoCarryEnemyBaseEnabled = false
M.autoCarryEnemyBaseRange = 35
M._autoCarryEnemyBaseConn = nil
M.setAutoCarryEnemyBaseVisual = nil
M.AUTO_SWITCH_THRESHOLD = 25
M._autoSwitchSpeedConn = nil
M.customFontSelected = "None"
M._fontOrig = {}
M._fontConn = nil
M._fontMy = nil
M.FONT_NAMES = {"None", "Coding Font", "Summer", "Beachy", "Scary"}
M.mobBtnTransparencyEnabled = false
M.perButtonDragEnabled = true
M.antiKickEnabled = false
M.brainrotDetected = false
M.safeModeEnabled = false
M.activeBatBillboard = nil
M.activeMedusaBillboard = nil
M.ragdollGuiEnabled = true
M.persistentRagdollGui = nil
M.uiLocked = false
M.holdInfJumpConn = nil
M.DROP_ASCEND_DURATION = 0.22
M.DROP_ASCEND_SPEED = 160
M.autoResetOnDeath = false
M.bypassAimbotEnabled = false
M.batTPEnabled = false -- Bat TP removed (stub kept for old guards)
M.batTPConn = nil
M.batTPSpeed = M.batTPSpeed or 58
M.batTPVersion = M.batTPVersion or "V1"
M.batAimbotVersion = M.batAimbotVersion or "V1"
M.antiDieFlingEnabled = M.antiDieFlingEnabled or false
M.antiDieEnabled = false
M.antiDieFlingEnabled = false
M.antiFlingEnabled = false
M.bypassAimbotConn = nil
M._bypassGodConn = nil
M._bypassGodHealthConn = nil
M._bypassGodDiedConn = nil
M._bypassGodCharConn = nil
M.bypassPrevAutoRotate = nil
M.bypassHitCD = false
M.bypassSwingCD = 0.35
M.bypassHitDist = 8
M._bypassTarget = nil

M.stealMode = "V2"
M.stealBarStyle = "New"
M.stealBarSize = 420
M.stealBarPos = nil
M.Steal = {
    AutoStealEnabled = false,
    StealRadius = 61,
    StealDuration = 1.3,
    StopTime = 0.96,
}
M.autoGrabPausePct = 0.73
M.autoGrabSetDelayRadius = 9
M.autoGrabStopEnabled = true
M.autoGrabSetDelayRadius = 9
M.autoGrabStopEnabled = true
M.V3 = {
    enabled = false,
    conn = nil,
    progress = 0,
    lastInRange = 0,
    currentUid = nil,
    holding = false,
    holdPrompt = nil,
    cooldownUntil = 0,
    phase = "fill",
    pauseAt = 0,
    pauseExtra = 1.0,
}
M.autoRadiusEnabled = false
function M.getAutoRadius()
    local radius = math.clamp((tonumber(M.NS) or 60) + 1, 1, 500)
    return math.floor(radius * 10 + 0.5) / 10
end
function M.getActiveStealRadius()

    if M.stealMode == "Semi" then
        return math.min(tonumber(M.Semi.radius) or 10, 10)
    end
    if M.stealMode == "Normal" or M.stealMode == "V1" then
        return tonumber(M.Steal.StealRadius) or 63
    end

    return M.autoRadiusEnabled and M.getAutoRadius() or (tonumber(M.Steal.StealRadius) or 63)
end
M.Semi = {
    enabled = false,
    holdMin = 1.3,
    holdMax = 2.6,
    entryDelay = 0.3,
    cooldown = 0.05,
    primeRange = 80,
    radius = 10,
    conn = nil,
    scanThread = nil,
    plotSync = {caches = {}, connections = {}},
    animals = {},
    promptCache = {},
    internalCache = {},
    state = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0},
    plots = nil,
    syncReady = false,
}
M.isStealing = false
M.stealStartTime = 0
M.stealConn = nil
M.progressConn = nil
M.animalCache = {}
M.promptCache = {}
M.stealCache = {}
M.playerESPEnabled = false
M.tracerEnabled = true -- on by default
M.espTorsoBox = true -- box around the whole character
M.espList = {}
M.pingPopupActive = false
M.pingPopupGui = nil
M.pingCycleTimer = nil
M.pingPanelPos = nil
M.panelBgImageId = 79162198517476
M.PANEL_BG_IMAGE_IDS = {
    79162198517476,
    95898293805741,
}

M.pingPanelOpen = false
M.pingLocked = false
M.pingGui = nil
M.pingMain = nil
M.pingSettings = nil
M.pingActive = false
M.pingPower = 100000
M.pingMode = M.pingMode or "MID"
M.PING_MODE_POWER = { LOW = 70000, MID = 100000, HIGH = 110000 }
M.pingInterval = 0.125
M.pingKeybindKb = "T"
M.pingKeybindGp = "ButtonR2"
M.pingAutoBrainrot = true
M.pingRemote = nil
M.pingBrainrotMode = false
M.pingLastBrainrot = false
M.pingManualOverride = false
M.pingListening = nil
M.pingLoopRunning = false
M.firstJoin = true
M.justJoined = true
M.setPingPanelVisual = nil

local function _packUDim2(u)
    if typeof(u) ~= "UDim2" then return nil end
    return {sx = u.X.Scale, ox = u.X.Offset, sy = u.Y.Scale, oy = u.Y.Offset}
end
local function _unpackUDim2(t, fallback)
    if type(t) == "table" and type(t.sx) == "number" and type(t.sy) == "number" then
        return UDim2.new(t.sx, tonumber(t.ox) or 0, t.sy, tonumber(t.oy) or 0)
    end
    return fallback
end

M.Conns = {autoSteal=nil, antiRag=nil, batCounter=nil, anchor={}}
M._persistentConns = {}
M.alConn = nil
M.arConn = nil
M.alPhase = 1
M.arPhase = 1
M.aimbotConn = nil
M.lastMoveDir = Vector3.new(0,0,0)
M.batCounterDebounce = false
M.speedLabel = nil

M.KB = {
    DropBrainrot={kb=nil,gp=nil},
    AutoLeft={kb=nil,gp=nil},
    AutoRight={kb=nil,gp=nil},
    AutoBat={kb=nil,gp=nil},
    TPFloor={kb=nil,gp=nil},
    InstaReset={kb=nil,gp=nil},
    GuiHide={kb=nil,gp=nil},
    SpeedToggle={kb=nil,gp=nil},
    LaggerToggle={kb=nil,gp=nil},
    LaggerCarry={kb=nil,gp=nil},
    BypassAimbot={kb=nil,gp=nil},
    BatTP={kb=nil,gp=nil},
}
M.AP_L1 = Vector3.new(-476.47,-6.28,92.73)
M.AP_L2 = Vector3.new(-483.12,-4.95,94.81)
M.AP_R1 = Vector3.new(-476.16,-6.52,25.62)
M.AP_R2 = Vector3.new(-483.06,-5.03,25.48)
M.MEDUSA_COOLDOWN = 25
M.BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
M.fovConn = nil
M.defLightBrightness = nil
M.defLightClock = nil
M.defLightAmbient = nil
M.mainFrame = nil
M.normalBox = nil
M.carryBox = nil
M.laggerBox = nil
M.radInput = nil
M.autoTPHeightBox = nil
M.durationBox = nil
M.modeValLbl = nil
M.setInstaGrab = nil
M.setInfJumpVisual = nil
M.setAntiRagVisual = nil
M.setAntiFlingVisual = nil
M.setMedusaVisual = nil
M.setUnwalkVisual = nil
M.setAntiLagVisual = nil
M.setAutoSwingVisual = nil
M.setTranspVisual = nil
M.setLockVisual = nil
M.setMobVisual = nil
M.setCircleBtnsVisual = nil
M.setMedusaResetVisual = nil
M.antiKickSetVisual = nil
M.autoLeftSetVisual = nil
M.autoRightSetVisual = nil
M.autoBatSetVisual = nil
M.setAutoTPVisual = nil
M.setAutoResetOnDeath = nil
M.setBypassVisual = nil
M._autoSwitchWasSteal = false

M.MOB_POS_FILE = "moveeduels_btnpos.json"
function M.themeDarkFromAccent(accent, amount)
    amount = math.clamp(tonumber(amount) or 0.12, 0, 1)
    if typeof(accent) ~= "Color3" then accent = Color3.fromRGB(255, 255, 255) end
    return Color3.new(
        math.clamp(accent.R * amount, 0, 1),
        math.clamp(accent.G * amount, 0, 1),
        math.clamp(accent.B * amount, 0, 1)
    )
end
M.MOVE_KEYS = {
    [Enum.KeyCode.W]=true,
    [Enum.KeyCode.A]=true,
    [Enum.KeyCode.S]=true,
    [Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,
    [Enum.KeyCode.Left]=true,
    [Enum.KeyCode.Down]=true,
    [Enum.KeyCode.Right]=true
}

M.showPlayerSpeeds = false
M.playerSpeedGuis = {}
M.playerSpeedUpdateConn = nil
M.removeAccEnabled = false
M.removeAccConn = nil
M.removedAccessories = {}
M.uiScale = 0.6
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    M.uiScale = 0.6
end
M.uiScaleSliderRef = nil
M.uiScaleLabelRef = nil
M.uiScaleBoxRef = nil
M.lineESPEnabled = false
M.menuOpen = true
M.menuBgMode = (M.menuBgChoiceEntry().id == nil) and "Black" or "Burger"
M.speedESPEnabled = false

M.statusGui = nil
M.statusFill = nil
M.statusPctLbl = nil
M.statusRadiusLbl = nil
M.statusDot = nil
M.statusMain = nil
M.statusFpsLbl = nil

function M.addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(100,100,100)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(100,100,100))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end

function M.applyFOV()
    if M.fovConn then pcall(function() M.fovConn:Disconnect() end); M.fovConn = nil end
    if M._fovCamConn then pcall(function() M._fovCamConn:Disconnect() end); M._fovCamConn = nil end
    local function apply()
        if M.wideViewEnabled then return end
        local c = workspace.CurrentCamera
        if c then pcall(function() c.FieldOfView = tonumber(M.fovValue) or 90 end) end
    end
    apply()
    M._fovCamConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(apply)
    local acc = 0
    M.fovConn = RunService.Heartbeat:Connect(function(dt)
        acc = acc + (dt or 0.016)
        if acc < 0.12 then return end
        acc = 0
        apply()
    end)
end

-- ===== Stretch Rez toggle (vertical resolution stretch) taken from the source =====
M.stretchEnabled = false
M.setStretchVisual = nil
local _BURGER_STRETCHREZ_STEP = "BurgerStretchRez"

function M.enableStretchRez()
    M.stretchEnabled = true
    pcall(function() RunService:UnbindFromRenderStep(_BURGER_STRETCHREZ_STEP) end)
    pcall(function()
        RunService:BindToRenderStep(_BURGER_STRETCHREZ_STEP, Enum.RenderPriority.Last.Value - 1, function()
            local cam = workspace.CurrentCamera
            if cam then
                cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.8, 0, 0, 0, 1)
            end
        end)
    end)
    if M.setStretchVisual then pcall(function() M.setStretchVisual(true) end) end
end

function M.disableStretchRez()
    M.stretchEnabled = false
    pcall(function() RunService:UnbindFromRenderStep(_BURGER_STRETCHREZ_STEP) end)
    if M.setStretchVisual then pcall(function() M.setStretchVisual(false) end) end
end

function M.setStretch(on)
    if on == true then
        M.enableStretchRez()
    else
        M.disableStretchRez()
    end
    pcall(saveCherryConfig)
end

M.ragdollTimerThread = nil
M.ragdollTimerRemaining = 0
M.isRagdollActive = false

function M._destroyRagdollGui()
    pcall(function()
        if M._ragdollGui and M._ragdollGui.Parent then M._ragdollGui:Destroy() end
    end)
    M._ragdollGui = nil
    if M.ragdollTimerThread then
        pcall(task.cancel, M.ragdollTimerThread)
        M.ragdollTimerThread = nil
    end
end

function M.updateRagdollTimer(duration, labelText)
    -- Black + blue ragdoll countdown (style from Anti-Sammy, recolored)
    if M.ragdollGuiEnabled == false then
        M._destroyRagdollGui()
        return
    end
    labelText = labelText or "RAGDOLL"
    if duration <= 0 then
        M.isRagdollActive = false
        M._destroyRagdollGui()
        if M.headIndicator and M.headIndicator.ragdollTimer then
            pcall(function() M.headIndicator.ragdollTimer.Text = "" end)
        end
        return
    end

    M.isRagdollActive = true
    M.ragdollTimerRemaining = duration
    M._destroyRagdollGui()

    local accent = BURGER_HUB_RANDOM       -- blue
    local accentDim = Color3.fromRGB(20, 90, 180)
    local bg = Color3.fromRGB(6, 10, 16)              -- near-black
    local bgCard = Color3.fromRGB(10, 16, 24)

    local guiName = "BurgerRagdollTimer"
    pcall(function()
        local cg = game:GetService("CoreGui")
        local o = cg:FindFirstChild(guiName)
        if o then o:Destroy() end
    end)
    pcall(function()
        local pg = player:FindFirstChild("PlayerGui")
        local o = pg and pg:FindFirstChild(guiName)
        if o then o:Destroy() end
    end)

    local sg = Instance.new("ScreenGui")
    sg.Name = guiName
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 95
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(sg) end
    end)
    local parented = false
    if typeof(gethui) == "function" then
        parented = pcall(function() sg.Parent = gethui() end)
    end
    if not parented then
        parented = pcall(function() sg.Parent = game:GetService("CoreGui") end)
    end
    if not parented then
        local pg = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 2)
        if pg then sg.Parent = pg end
    end
    M._ragdollGui = sg

    local card = Instance.new("Frame")
    card.Name = "RecoveryTimer"
    card.AnchorPoint = Vector2.new(0.5, 0)
    card.Position = UDim2.new(0.5, 0, 0, 58)
    card.Size = UDim2.fromOffset(200, 50)
    card.BackgroundColor3 = bgCard
    card.BackgroundTransparency = 0.08
    card.BorderSizePixel = 0
    card.Parent = sg
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = accent
    cardStroke.Thickness = 1.4
    cardStroke.Transparency = 0.15

    local accentBar = Instance.new("Frame", card)
    accentBar.Position = UDim2.fromOffset(0, 8)
    accentBar.Size = UDim2.fromOffset(3, 34)
    accentBar.BackgroundColor3 = accent
    accentBar.BorderSizePixel = 0
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)

    local icon = Instance.new("Frame", card)
    icon.Position = UDim2.fromOffset(12, 10)
    icon.Size = UDim2.fromOffset(28, 28)
    icon.BackgroundColor3 = accent
    icon.BackgroundTransparency = 0.7
    icon.BorderSizePixel = 0
    Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
    local iconStroke = Instance.new("UIStroke", icon)
    iconStroke.Color = accent
    iconStroke.Transparency = 0.25
    local iconText = Instance.new("TextLabel", icon)
    iconText.Size = UDim2.fromScale(1, 1)
    iconText.BackgroundTransparency = 1
    iconText.Text = labelText == "STONE" and "S" or "!"
    iconText.TextColor3 = accent
    iconText.Font = Enum.Font.GothamBold
    iconText.TextSize = 14

    local titleLbl = Instance.new("TextLabel", card)
    titleLbl.Position = UDim2.fromOffset(48, 6)
    titleLbl.Size = UDim2.new(1, -100, 0, 18)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = labelText
    titleLbl.TextColor3 = Color3.fromRGB(230, 240, 255)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local timerLbl = Instance.new("TextLabel", card)
    timerLbl.AnchorPoint = Vector2.new(1, 0)
    timerLbl.Position = UDim2.new(1, -12, 0, 6)
    timerLbl.Size = UDim2.fromOffset(48, 18)
    timerLbl.BackgroundTransparency = 1
    timerLbl.Text = string.format("%.1fs", duration)
    timerLbl.TextColor3 = accent
    timerLbl.Font = Enum.Font.GothamBold
    timerLbl.TextSize = 13
    timerLbl.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", card)
    track.Position = UDim2.fromOffset(48, 32)
    track.Size = UDim2.new(1, -60, 0, 6)
    track.BackgroundColor3 = Color3.fromRGB(18, 28, 40)
    track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = accent
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local startTime = os.clock()
    local finishing = false
    local function closeTimer()
        if finishing then return end
        finishing = true
        M.isRagdollActive = false
        pcall(function()
            if M.headIndicator and M.headIndicator.ragdollTimer then
                M.headIndicator.ragdollTimer.Text = ""
            end
        end)
        TweenService:Create(fill, TweenInfo.new(0.12), {Size = UDim2.new(0, 0, 1, 0)}):Play()
        task.delay(0.12, function()
            if not sg.Parent then return end
            TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, 0, 20),
                BackgroundTransparency = 1,
            }):Play()
            task.delay(0.25, function()
                pcall(function() if sg.Parent then sg:Destroy() end end)
                if M._ragdollGui == sg then M._ragdollGui = nil end
            end)
        end)
    end

    if M.ragdollTimerThread then pcall(task.cancel, M.ragdollTimerThread) end
    M.ragdollTimerThread = task.spawn(function()
        while M.isRagdollActive and sg.Parent do
            local remaining = math.max(0, duration - (os.clock() - startTime))
            M.ragdollTimerRemaining = remaining
            if remaining <= 0 then
                closeTimer()
                break
            end
            timerLbl.Text = string.format("%.1fs", remaining)
            fill.Size = UDim2.new(remaining / duration, 0, 1, 0)
            if M.headIndicator and M.headIndicator.ragdollTimer then
                pcall(function() M.headIndicator.ragdollTimer.Text = string.format("%.1fs", remaining) end)
            end
            task.wait(0.05)
        end
        M.ragdollTimerThread = nil
    end)
end

function M.onHumanoidStateChanged(old,new)
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
    local isRag=(new==Enum.HumanoidStateType.Physics or new==Enum.HumanoidStateType.Ragdoll or new==Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand then
        M.updateRagdollTimer(2.6, "RAGDOLL")
    end
end

function M.onMedusaStateChanged()
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand then
        M.updateRagdollTimer(4.5, "STONE")
    end
end

function M.setupRagdollTriggers()
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.StateChanged:Connect(M.onHumanoidStateChanged)
        hum:GetPropertyChangedSignal("PlatformStand"):Connect(M.onMedusaStateChanged)
    end
end

function M.waitForAnimate(char)
    for _ = 1, 40 do
        local a = char:FindFirstChild("Animate")
        if a and a:FindFirstChild("idle") and a:FindFirstChild("run") and a:FindFirstChild("walk") then
            return a
        end
        task.wait(0.1)
    end
    return nil
end

function M.setAnim(animObj, id)
    if animObj and id then
        animObj.AnimationId = "rbxassetid://" .. tostring(id)
    end
end

function M.stopAllTracks(hum)
    if not hum then return end
    for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() t:Stop(0) end)
    end
end

function M.ensureAnim(folder, name)
    if not folder then return nil end
    local a = folder:FindFirstChild(name)
    if not a then
        a = Instance.new("Animation")
        a.Name = name
        a.Parent = folder
    end
    return a
end

function M.ensureIdleSlots(idleFolder, n)
    if not idleFolder then return end
    n = n or 2
    for i=1,n do
        M.ensureAnim(idleFolder, "Animation" .. i)
    end
end

function M.pick(pack, ...)
    for i = 1, select("#", ...) do
        local k = select(i, ...)
        local v = pack[k]
        if v ~= nil then return v end
    end
    return nil
end

function M.saveOriginalAnimate(char)
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if not animate then return end

    if M.savedAnimate then
        return
    end

    if M.unwalkEnabled or M.animPackEnabled then
        return
    end
    M.savedAnimate = animate:Clone()
    M._savedAnimateFromChar = char
end

function M.restoreOriginalAnimate(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        M.stopAllTracks(hum)
    end
    local currentAnimate = char:FindFirstChild("Animate")
    if currentAnimate then
        currentAnimate:Destroy()
    end
    if M.savedAnimate then
        local newAnimate = M.savedAnimate:Clone()
        newAnimate.Parent = char
        newAnimate.Disabled = true
        task.wait(0.06)
        newAnimate.Disabled = false
    end
end

function M.resetAnimations(char)
    if not char then return end
    M.restoreOriginalAnimate(char)
end

local applyingAnim = false
local function ensureAnimFolder(animate, folderName)
    if not animate then return nil end
    local f = animate:FindFirstChild(folderName)
    if not f then
        f = Instance.new("StringValue")
        f.Name = folderName
        f.Parent = animate
    end
    return f
end

function M.applyAnimPack(packName)
    if not M.animPackEnabled then
        local char = player.Character
        if char then
            M.resetAnimations(char)
        end
        return false
    end
    if applyingAnim then return false end
    applyingAnim = true

    local ok, result = pcall(function()
        local pack = M.PACKS[packName]
        if not pack then return false end

        local char = player.Character or player.CharacterAdded:Wait()
        M.saveOriginalAnimate(char)

        local animate = M.waitForAnimate(char)
        if not animate then
            -- fallback: wait only for Animate itself
            for _ = 1, 30 do
                animate = char:FindFirstChild("Animate")
                if animate then break end
                task.wait(0.1)
            end
        end
        if not animate then return false end

        local hum = char:FindFirstChildOfClass("Humanoid")
        M.stopAllTracks(hum)

        local walkFolder  = ensureAnimFolder(animate, "walk")
        local runFolder   = ensureAnimFolder(animate, "run")
        local jumpFolder  = ensureAnimFolder(animate, "jump")
        local fallFolder  = ensureAnimFolder(animate, "fall")
        local climbFolder = ensureAnimFolder(animate, "climb")
        local swimFolder  = ensureAnimFolder(animate, "swim")
        local swimIdleFolder = ensureAnimFolder(animate, "swimidle")
        local idleFolder  = ensureAnimFolder(animate, "idle")

        local walkObj  = M.ensureAnim(walkFolder,  "WalkAnim")
        local runObj   = M.ensureAnim(runFolder,   "RunAnim")
        local jumpObj  = M.ensureAnim(jumpFolder,  "JumpAnim")
        local fallObj  = M.ensureAnim(fallFolder,  "FallAnim")
        local climbObj = M.ensureAnim(climbFolder, "ClimbAnim")
        local swimObj  = M.ensureAnim(swimFolder,  "Swim")
        local swimIdleObj = M.ensureAnim(swimIdleFolder, "SwimIdle")

        M.setAnim(walkObj,  M.pick(pack, "WalkAnim", "Walk"))
        M.setAnim(runObj,   M.pick(pack, "RunAnim", "Run"))
        M.setAnim(jumpObj,  M.pick(pack, "JumpAnim", "Jump"))
        M.setAnim(fallObj,  M.pick(pack, "FallAnim", "Fall"))
        M.setAnim(climbObj, M.pick(pack, "ClimbAnim", "Climb"))
        M.setAnim(swimObj,      M.pick(pack, "Swim"))
        M.setAnim(swimIdleObj,  M.pick(pack, "SwimIdle") or M.pick(pack, "Swim"))

        if idleFolder then
            local a1 = M.pick(pack, "Animation1")
            local a2 = M.pick(pack, "Animation2")
            if (not a1 or not a2) and type(pack.Idle) == "table" then
                a1 = a1 or pack.Idle[1]
                a2 = a2 or pack.Idle[2] or pack.Idle[1]
            end
            if a1 or a2 then
                M.ensureIdleSlots(idleFolder, 2)
                local id1 = a1 or a2
                local id2 = a2 or a1 or id1
                M.setAnim(idleFolder:FindFirstChild("Animation1"), id1)
                M.setAnim(idleFolder:FindFirstChild("Animation2"), id2)
            elseif pack.Idle and #pack.Idle > 0 then
                M.ensureIdleSlots(idleFolder, math.max(2, #pack.Idle))
                M.setAnim(idleFolder:FindFirstChild("Animation1"), pack.Idle[1])
                M.setAnim(idleFolder:FindFirstChild("Animation2"), pack.Idle[2] or pack.Idle[1])
            end
        end

        animate.Disabled = true
        task.wait(0.08)
        animate.Disabled = false

        if hum then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.Landed)
                task.wait(0.04)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end

        M.animPack = packName
        -- re-apply once after a short delay (Animate can overwrite on enable)
        task.delay(0.35, function()
            if not M.animPackEnabled or M.animPack ~= packName then return end
            local c = player.Character
            if not c then return end
            local an = c:FindFirstChild("Animate")
            if not an then return end
            local p = M.PACKS[packName]
            if not p then return end
            local function re(folderName, animName, key)
                local folder = an:FindFirstChild(folderName)
                local obj = folder and folder:FindFirstChild(animName)
                local id = M.pick(p, key)
                if obj and id then obj.AnimationId = "rbxassetid://" .. tostring(id) end
            end
            re("walk", "WalkAnim", "WalkAnim")
            re("run", "RunAnim", "RunAnim")
            re("jump", "JumpAnim", "JumpAnim")
            re("fall", "FallAnim", "FallAnim")
            re("climb", "ClimbAnim", "ClimbAnim")
            re("swim", "Swim", "Swim")
            re("swimidle", "SwimIdle", "SwimIdle")
            local idle = an:FindFirstChild("idle")
            if idle then
                local a1 = idle:FindFirstChild("Animation1")
                local a2 = idle:FindFirstChild("Animation2")
                if a1 and p.Animation1 then a1.AnimationId = "rbxassetid://" .. tostring(p.Animation1) end
                if a2 and (p.Animation2 or p.Animation1) then a2.AnimationId = "rbxassetid://" .. tostring(p.Animation2 or p.Animation1) end
            end
        end)
        return true
    end)

    applyingAnim = false
    if not ok then
        warn("[BURGER] applyAnimPack error: " .. tostring(result))
        return false
    end
    return result == true
end

function M.createPlayerSpeedGui(plr)
    if plr == player then return end
    if M.playerSpeedGuis[plr] then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("MoveePlayerSpeedBB")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "MoveePlayerSpeedBB"
    bb.Size = UDim2.new(0, 80, 0, 24)
    bb.StudsOffset = Vector3.new(0, 2.2, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = head
    bb.Parent = head
    local label = Instance.new("TextLabel", bb)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = "0"
    label.TextColor3 = CHERRY_ACCENT or Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextStrokeTransparency = 0
    M.addShimmerToLabel(label, CHERRY_ACCENT or Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))
    local conn
    conn = char.AncestryChanged:Connect(function(_, parent)
        if not parent then
            M.removePlayerSpeedGui(plr)
            if conn then conn:Disconnect() end
        end
    end)
    M.playerSpeedGuis[plr] = {gui = bb, label = label, conn = conn}
end

function M.removePlayerSpeedGui(plr)
    local data = M.playerSpeedGuis[plr]
    if data then
        if data.conn then data.conn:Disconnect() end
        if data.gui then data.gui:Destroy() end
        M.playerSpeedGuis[plr] = nil
    end
end

function M.updatePlayerSpeed(plr)
    if not M.showPlayerSpeeds then return end
    local data = M.playerSpeedGuis[plr]
    if not data then return end
    local char = plr.Character
    if not char then M.removePlayerSpeedGui(plr); return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local speed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
    data.label.Text = string.format("%.1f", speed)
end

function M.updateAllPlayerSpeeds()
    for plr, _ in pairs(M.playerSpeedGuis) do M.updatePlayerSpeed(plr) end
end

function M.startPlayerSpeedUpdates()
    if M.playerSpeedUpdateConn then return end
    local _psAcc = 0
    M.playerSpeedUpdateConn = RunService.Heartbeat:Connect(function(dt)
        _psAcc = _psAcc + (dt or 0.016)
        if _psAcc < 0.2 then return end
        _psAcc = 0
        M.updateAllPlayerSpeeds()
    end)
end

function M.stopPlayerSpeedUpdates()
    if M.playerSpeedUpdateConn then M.playerSpeedUpdateConn:Disconnect(); M.playerSpeedUpdateConn = nil end
end

function M.togglePlayerSpeeds(on)
    M.showPlayerSpeeds = on
    if on then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then M.createPlayerSpeedGui(plr) end
        end
        M.startPlayerSpeedUpdates()
    else
        for plr, _ in pairs(M.playerSpeedGuis) do M.removePlayerSpeedGui(plr) end
        M.stopPlayerSpeedUpdates()
    end
end

M.espList = M.espList or {}
M._espHighlightCache = M._espHighlightCache or {}
M._espBillboardCache = M._espBillboardCache or {}
M._espTracerCache = M._espTracerCache or {}
M._espConn = nil
M._espLastRun = 0
M._espProfileImageCache = M._espProfileImageCache or {}

function M.removeESP(plr)
    if not plr then return end
    if M._espHighlightCache[plr] then
        pcall(function() M._espHighlightCache[plr]:Destroy() end)
        M._espHighlightCache[plr] = nil
    end
    if M._espBillboardCache[plr] then
        pcall(function() M._espBillboardCache[plr]:Destroy() end)
        M._espBillboardCache[plr] = nil
    end
    if M._espTracerCache[plr] then
        for _, ln in ipairs(M._espTracerCache[plr]) do
            pcall(function() ln.Visible = false; ln:Remove() end)
        end
        M._espTracerCache[plr] = nil
    end
    if M.espList then M.espList[plr] = nil end
end

function M.clearESP()
    for plr in pairs(M._espHighlightCache) do
        pcall(function() M._espHighlightCache[plr]:Destroy() end)
    end
    for plr in pairs(M._espBillboardCache) do
        pcall(function() M._espBillboardCache[plr]:Destroy() end)
    end
    for plr in pairs(M._espTracerCache) do
        for _, ln in ipairs(M._espTracerCache[plr]) do
            pcall(function() ln.Visible = false; ln:Remove() end)
        end
    end
    M._espHighlightCache = {}
    M._espBillboardCache = {}
    M._espTracerCache = {}
    M.espList = {}
end

function M._espColor()
    return Color3.fromRGB(0, 119, 190) -- ocean blue
end

-- Tracer lines are drawn with thin GUI frames (works on every executor, no Drawing API needed).
function M._tracerGui()
    if M._tracerSG and M._tracerSG.Parent then return M._tracerSG end
    local sg = Instance.new("ScreenGui")
    sg.Name = "BHTracers"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 50
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local ok = false
    if gethui then ok = pcall(function() sg.Parent = gethui() end) end
    if not ok then ok = pcall(function() sg.Parent = game:GetService("CoreGui") end) end
    if not ok then sg.Parent = player:WaitForChild("PlayerGui") end
    M._tracerSG = sg
    return sg
end

function M._newLine(thickness, transparency)
    local f = Instance.new("Frame")
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.BorderSizePixel = 0
    f.BackgroundTransparency = transparency or 0
    f.Visible = false
    f.Active = false
    f.Parent = M._tracerGui()
    local from, to = Vector2.new(0, 0), Vector2.new(0, 0)
    local function layout()
        local d = to - from
        f.Size = UDim2.fromOffset(d.Magnitude, thickness)
        f.Position = UDim2.fromOffset((from.X + to.X) / 2, (from.Y + to.Y) / 2)
        f.Rotation = math.deg(math.atan2(d.Y, d.X))
    end
    return setmetatable({}, {
        __newindex = function(_, k, v)
            if k == "Color" then f.BackgroundColor3 = v
            elseif k == "From" then from = v; layout()
            elseif k == "To" then to = v; layout()
            elseif k == "Visible" then f.Visible = v end
        end,
        __index = function(_, k)
            if k == "Remove" or k == "Destroy" then
                return function() pcall(function() f:Destroy() end) end
            end
        end,
    })
end

function M._makeESPTracers()
    local base = M._espColor()
    local glow = M._newLine(3, 0.65)
    glow.Color = base
    local core = M._newLine(1, 0)
    core.Color = base:Lerp(Color3.fromRGB(255, 255, 255), 0.6)
    return {glow, core}
end

function M._espKillHL(plr)
    if M._espHighlightCache[plr] then
        pcall(function() M._espHighlightCache[plr]:Destroy() end)
        M._espHighlightCache[plr] = nil
    end
end
function M._espKillBB(plr)
    if M._espBillboardCache[plr] then
        pcall(function() M._espBillboardCache[plr]:Destroy() end)
        M._espBillboardCache[plr] = nil
    end
end
function M._espKillTracer(plr)
    if M._espTracerCache[plr] then
        for _, ln in ipairs(M._espTracerCache[plr]) do
            pcall(function() ln.Visible = false; ln:Remove() end)
        end
        M._espTracerCache[plr] = nil
    end
end
function M._espHideTracer(plr)
    if M._espTracerCache[plr] then
        for _, ln in ipairs(M._espTracerCache[plr]) do
            pcall(function() ln.Visible = false end)
        end
    end
end

function M._updateESP()
    if not (M.playerESPEnabled or M.tracerEnabled) then
        if M._espConn then
            pcall(function() M._espConn:Disconnect() end)
            M._espConn = nil
        end
        M.clearESP()
        return
    end
    local now = tick()
    local full = (now - (M._espLastRun or 0)) >= 0.06
    if full then M._espLastRun = now end
    local camera = workspace.CurrentCamera
    if not camera then return end
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myScreenPos, myOnScreen = camera:WorldToViewportPoint(myRoot.Position)
    local myVec = Vector2.new(myScreenPos.X, myScreenPos.Y)
    local color = M._espColor()
    local currentPlayers = Players:GetPlayers()
    local plrSet = {}
    for _, p in ipairs(currentPlayers) do plrSet[p] = true end
    if full then
        for plr in pairs(M._espHighlightCache) do if not plrSet[plr] then M._espKillHL(plr) end end
        for plr in pairs(M._espBillboardCache) do if not plrSet[plr] then M._espKillBB(plr) end end
        for plr in pairs(M._espTracerCache) do if not plrSet[plr] then M._espKillTracer(plr) end end
    end
    for _, plr in ipairs(currentPlayers) do
        if plr == player then continue end
        local char = plr.Character
        local tRoot = char and char:FindFirstChild("HumanoidRootPart")
        local tHum = char and char:FindFirstChildOfClass("Humanoid")
        local torso = char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or tRoot)
        local alive = tRoot and torso and tHum and tHum.Health > 0
        if not alive then
            M._espKillHL(plr); M._espKillBB(plr); M._espHideTracer(plr)
            M.espList[plr] = nil
            continue
        end

        -- Tracer (own toggle, updated every frame so it stays smooth)
        if M.tracerEnabled then
            local lines = M._espTracerCache[plr]
            if not lines then
                lines = M._makeESPTracers()
                M._espTracerCache[plr] = lines or {}
            end
            if lines and #lines > 0 then
                local pos, onScreen = camera:WorldToViewportPoint(torso.Position)
                if onScreen and pos.Z > 0 and myOnScreen then
                    local coreColor = color:Lerp(Color3.fromRGB(255, 255, 255), 0.6)
                    for i, ln in ipairs(lines) do
                        ln.Color = (i == 1) and color or coreColor
                        ln.From = myVec
                        ln.To = Vector2.new(pos.X, pos.Y)
                        ln.Visible = true
                    end
                else
                    M._espHideTracer(plr)
                end
            end
        else
            M._espKillTracer(plr)
        end

        -- Box around the character: projected to screen space every frame so it
        -- stays glued to the player however the camera tilts.
        if M.playerESPEnabled and M.espTorsoBox ~= false then
            local box = M._espBillboardCache[plr]
            if not box or not box.Parent then
                if box then pcall(function() box:Destroy() end) end
                box = Instance.new("Frame")
                box.Name = "EspBox"
                box.BackgroundTransparency = 1
                box.BorderSizePixel = 0
                box.Visible = false
                box.Active = false
                box.Parent = M._tracerGui()
                local st = Instance.new("UIStroke")
                st.Name = "EspRing"
                st.Thickness = 1.5
                st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                st.Parent = box
                M._espBillboardCache[plr] = box
            end
            -- tight body box (head to feet), sized from the root part instead of
            -- the full model bounds so accessories/tools don't bloat it
            local okBB, bcf, bsz = true, tRoot.CFrame * CFrame.new(0, -0.25, 0), Vector3.new(2.2, 5.5, 1.2)
            local shown = false
            if okBB and bsz then
                local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
                local allFront = true
                for sx = -1, 1, 2 do
                    for sy = -1, 1, 2 do
                        for sz = -1, 1, 2 do
                            local wp = bcf:PointToWorldSpace(Vector3.new(sx * bsz.X / 2, sy * bsz.Y / 2, sz * bsz.Z / 2))
                            local sp = camera:WorldToViewportPoint(wp)
                            if sp.Z <= 0 then allFront = false end
                            if sp.X < minX then minX = sp.X end
                            if sp.X > maxX then maxX = sp.X end
                            if sp.Y < minY then minY = sp.Y end
                            if sp.Y > maxY then maxY = sp.Y end
                        end
                    end
                end
                if allFront then
                    box.Position = UDim2.fromOffset(minX, minY)
                    box.Size = UDim2.fromOffset(maxX - minX, maxY - minY)
                    local st = box:FindFirstChild("EspRing")
                    if st then st.Color = color:Lerp(Color3.fromRGB(255, 255, 255), 0.5) end
                    shown = true
                end
            end
            box.Visible = shown
        else
            M._espKillBB(plr)
        end

        -- Highlight + torso square (Esp Player toggle)
        if M.playerESPEnabled then
            if full or not M._espBillboardCache[plr] then
                local hl = M._espHighlightCache[plr]
                if not hl or not hl.Parent or hl.Parent ~= char then
                    if hl then pcall(function() hl:Destroy() end) end
                    hl = Instance.new("Highlight")
                    hl.Name = "BurgerPlayerESP"
                    hl.FillTransparency = 0.45
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Adornee = char
                    hl.Parent = char
                    M._espHighlightCache[plr] = hl
                end
                hl.FillColor = color
                hl.OutlineColor = color:Lerp(Color3.fromRGB(255, 255, 255), 0.7)

                M.espList[plr] = { highlight = M._espHighlightCache[plr], torsoBB = M._espBillboardCache[plr] }
            end
        else
            M._espKillHL(plr); M._espKillBB(plr)
            M.espList[plr] = nil
        end
    end
end

function M.addESP(plr)
    if plr == player then return end
    if not M.playerESPEnabled then return end
    M._updateESP()
end

function M._startESPLoop()
    if M._espConn then pcall(function() M._espConn:Disconnect() end); M._espConn = nil end
    if not (M.playerESPEnabled or M.tracerEnabled) then M.clearESP(); return end
    M._espConn = RunService.Heartbeat:Connect(function() M._updateESP() end)
end

function M._stopESPLoop()
    if M._espConn then pcall(function() M._espConn:Disconnect() end); M._espConn = nil end
    M.clearESP()
end

function M._startEspSpeedLoop() end
function M._stopEspSpeedLoop() end

function M._ensureESPLoop()
    if M.playerESPEnabled or M.tracerEnabled then
        if not M._espConn then M._startESPLoop() end
        if not M._espPlayerRemoved then
            M._espPlayerRemoved = Players.PlayerRemoving:Connect(function(p)
                M.removeESP(p)
            end)
            if M.trackConn then M.trackConn(M._espPlayerRemoved) end
        end
    else
        M._stopESPLoop()
        if M._espPlayerAdded then pcall(function() M._espPlayerAdded:Disconnect() end); M._espPlayerAdded = nil end
        if M._espPlayerRemoved then pcall(function() M._espPlayerRemoved:
