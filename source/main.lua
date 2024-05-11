import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"

import 'Character'
local GameLogic = import("gameLogic") -- Assuming gamelogic.lua is in the same directory

-- Load the Character class
-- import "dvd" -- DEMO
-- local dvd = dvd(1, -1) -- DEMO
local pd <const> = playdate
local gfx <const> = pd.graphics
local snd <const> = pd.sound

local lastCrankPosition = playdate.getCrankPosition()  -- Initialize with the current crank position
local lastDCrankPosition = playdate.getCrankPosition() -- Initialize with the current crank position
-- local Character = require 'Character'
local screenWidth, screenHeight = playdate.display.getSize()
local offscreenImage = gfx.image.new(screenWidth, screenHeight)

local crankIdleTime = 0

fonts = {
    mini      = gfx.font.new("font/Mini-Sans-2X"),
    miniLight = gfx.font.new("font/Mini-Sans-Light-2X"),
    circ      = gfx.font.new("font/font-full-circle"),
    rains      = gfx.font.new("font/font-rains-1x"),

}


-- Load the sound file
local clickSound = snd.sample.new("sfx/click.wav")
assert(clickSound, "Failed to load sound file.")

if not offscreenImage then
    error("Failed to create offscreen image")
end

local pieces = { "Head", "Torso", "ArmsL", "ArmsR", "LegsL", "LegsR" }
local activeIndex = 1 -- Start with the first item as active
local myCharacter = Character.new()
myCharacter:selectPart("Torso")
-- myCharacter:movePart(5, 0)
-- -- myCharacter:rotatePart(10)
-- myCharacter:resetPart()

-- local mirrorCharacter = Character.new()
-- mirrorCharacter:selectPart("Head")
-- mirrorCharacter:movePart(5, 0)
-- mirrorCharacter:rotatePart(-10)
-- mirrorCharacter:resetPart()
imagetable = gfx.imagetable.new('images/sheets/ui-sheet')
titleTable = gfx.imagetable.new('images/sheets/title')
livetale = gfx.imagetable.new('images/sheets/live')


local font = gfx.font.new('font/Mini Sans 2X') -- DEMO
local bg = gfx.image.new('images/bg1.png')
local ui = gfx.image.new('images/ui.png')
local viewersImg = gfx.image.new('images/ui/viewers.png')
assert(viewersImg, "Failed to load viewers.png")
local titleScreen = gfx.image.new('images/titlescreen.png')


local bgSprite = gfx.sprite.new(bg)
local titleSprite = gfx.sprite.new(titleScreen)

local titleActive = true
local subTitleActive = true
local viewerCount = 3
local tempNum = 0
local titleAniSprite = AnimatedSprite.new(titleTable)
titleAniSprite:moveTo(screenWidth / 2, screenHeight / 2)
titleAniSprite:addState('idle', 17, 17, { tickStep = 11 })
titleAniSprite:addState('idlestory', 19, 19, { tickStep = 11 })

titleAniSprite:addState("appear", 1, 15, { tickStep = 30 }).asDefault()
titleAniSprite:addState("story", 17, 19, { tickStep = 100, loop = false })
titleAniSprite:addState("fade", 20, 25, { tickStep = 5, loop = false }) --

titleAniSprite:setZIndex(177)
titleAniSprite:playAnimation()
titleAniSprite:pauseAnimation()
-- local uiSprite = gfx.sprite.new(ui)
local uiSprite = AnimatedSprite.new(imagetable)
uiSprite:addState('idle', 0, 0, { tickStep = 15 })
uiSprite:changeState('idle')


-- uiSprite:playAnimation()
-- Creating an AnimatedSprite instance
-- headsprite = AnimatedSprite.new(imagetable)
-- Adding custom a animation state (Optional)
-- headsprite:addState('idle', 1, 12, { tickStep = 10 })
function setupUI()
    local liveUiSprite = AnimatedSprite.new(livetale)
    liveUiSprite:addState('idle', 1, 2, { tickStep = 40 })
    liveUiSprite:changeState('idle')
    liveUiSprite:moveTo(22 + 10, 10 + 10)
    liveUiSprite:playAnimation()
    liveUiSprite:setZIndex(176)
end
function drawInfo()
    gfx.setFont(fonts.rains)
    gfx.drawText("TPOS:" .. myCharacter:getTorsoPosition(), 100, 10)

end
function drawViewers()
    viewersImg:draw(314, 13)
    -- DREWLS NOTES
    -- DRAWING STUFF STILL CONFUSES ME WITH LUA
    -- YOU'D THINK CHANGING THE FONT COLOR WOULD BE SIMPLE BUT NOPE.
    -- AI SURE APPOLOGIZES A LOT WHEN ASKING FOR HELP
    -- IDEALLY SPENDING TIME READING THE DOCS WOULD BE A GOOD IDEA I READ DOCS AND STILL STRUGGLE THOUGH
    -- ITD BE NICE TO SEE EXAMPLES ALONG WITH THE DOCS
    -- END DREWLS NOTES
    gfx.setFont(fonts.miniLight)

    -- Set text color
    -- gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    -- gfx.setImageDrawMode(gfx.kDrawModeXOR)
    -- playdate.graphics.kDrawModeXOR
    -- gfx.setColor(gfx.kColorWhite)
    -- gfx.fontColor(gfx.kColorWhite)
    if tempNum >= 250 then
        -- All your movement will pay off with these random viewers!
        -- at some point maybe this will be based on your cool moves and requests from viewers
        -- DREWLS NOTES
        --  I asked ai how to make a random number in lua for playdate, it gave me several confident but wrong answers
        -- END DREWLS NOTES

        tempNum = math.random(-1, 1)

        viewerCount += tempNum

        if viewerCount < 0 then
            viewerCount = 0
        end
    end


    tempNum = tempNum + 1

    gfx.drawTextAligned(tostring(viewerCount), 380, 15, kTextAlignment.right) -- Adjust the position as needed to overlay the image


    -- gfx.drawText("* to continue", 320, 13)
end

function drawToOffscreenImage()
    gfx.pushContext(offscreenImage) -- Set the offscreen image as the current drawing target
    -- Draw your scene here, this could be drawing sprites, shapes, text, etc.
    gfx.setBackgroundColor(gfx.kColorWhite)
    gfx.clear()                             -- Clear with background color
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRoundRect(10, 10, 100, 100, 10) -- Example shape
    gfx.popContext()                        -- Restore previous drawing context
end

-- Create a sprite from the offscreen image
-- local sceneSprite = gfx.sprite.new(offscreenImage)
-- sceneSprite:moveTo(screenWidth / 2, screenHeight / 2)
-- sceneSprite:add()
bgSprite:moveTo(screenWidth / 2, screenHeight / 2)
uiSprite:moveTo(screenWidth / 2, screenHeight / 2)
bgSprite:setZIndex(0)
uiSprite:setZIndex(4)
bgSprite:add()
uiSprite:playAnimation()

-- titleSprite:moveTo(screenWidth / 2, screenHeight / 2)
-- titleSprite:setZIndex(222)
-- titleSprite:add()



local function loadGame()
    playdate.display.setRefreshRate(50)           -- Sets framerate to 50 fps
    math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
    gfx.setFont(font)                             -- DEMO
    GameLogic.initialize()                        -- Initialize the game logic
    clickSound:play()
end

loadGame()



function pd.update()
    gfx.clear()
    if titleActive or subTitleActive then
        -- PRESSABUTON
        if playdate.buttonJustPressed(pd.kButtonA) then
            -- titleSprite:remove()
            if subTitleActive and not titleActive then
                titleAniSprite:changeState("fade")
                titleAniSprite:playAnimation()
                subTitleActive = false
            end
            if titleActive then
                titleAniSprite:changeState("story")
                titleAniSprite:playAnimation()
                setupUI()
                titleActive = false
            end
            -- PLAY A CASCADE SOUND
            -- clickSound:play()
        end
        gfx.sprite.update()
        return
    end
    local x1, y1 = myCharacter:getPosition()

    -- Check for D-pad inputs and adjust position
    if playdate.buttonIsPressed(playdate.kButtonUp) then
        myCharacter:movePart(0, -2)
        -- mirrorCharacter:movePart(0, -2)
    elseif playdate.buttonIsPressed(playdate.kButtonDown) then
        myCharacter:movePart(0, 2)
        -- mirrorCharacter:movePart(0, 2)
    end
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        myCharacter:movePart(-2, 0)
        -- mirrorCharacter:movePart(2, 0)
    elseif playdate.buttonIsPressed(playdate.kButtonRight) then
        myCharacter:movePart(2, 0)
        -- mirrorCharacter:movePart(-2, 0)
    end

    local currentCrankPosition = playdate.getCrankPosition()
    local crankChange = currentCrankPosition - lastCrankPosition
    lastCrankPosition = currentCrankPosition -- Update the last position for the next frame

    -- Rotate the sprite based on crank movement
    local currentAngle = myCharacter:getPartRotation()

    local crankChange = playdate.getCrankChange()

    local crankPosition = playdate.getCrankPosition()
    local degreesChanged = math.abs(crankPosition - lastDCrankPosition)

    if degreesChanged >= 10 or degreesChanged <= -10 then
        clickSound:play()                  -- Play sound every 10 degrees
        crankIdleTime = 0
        lastDCrankPosition = crankPosition -- Update the last position after playing the sound
    end

    crankIdleTime += 1
    if crankIdleTime >= 400 then
        viewerCount = 0
        -- clickSound:play()  -- Play sound every 10 degrees
    end
    myCharacter:rotatePartFree(currentAngle + crankChange)

    if playdate.buttonJustPressed(pd.kButtonA) then
        -- viewerCount+=1
    end
    if playdate.buttonJustPressed(pd.kButtonB) then
        -- changeActivePiece()
        -- viewerCount-=1
        print("crankIdleTime: " .. crankIdleTime)
        if (viewerCount < 0) then
            viewerCount = 0
            -- GameLogic.endGame()
        end
        activeIndex = activeIndex + 1
        if activeIndex > #pieces then
            activeIndex = 1
        end
        myCharacter:selectPart(pieces[activeIndex])
    end
    gfx.sprite.update()
    myCharacter:update()
    drawViewers()
    -- drawInfo()
end
