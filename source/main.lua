import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"

import 'Character'

-- Load the Character class
-- import "dvd" -- DEMO
-- local dvd = dvd(1, -1) -- DEMO
local pd <const> = playdate
local gfx <const> = pd.graphics
local snd <const> = pd.sound 

local lastCrankPosition = playdate.getCrankPosition()  -- Initialize with the current crank position
local lastDCrankPosition = playdate.getCrankPosition()  -- Initialize with the current crank position
-- local Character = require 'Character'
local screenWidth, screenHeight = playdate.display.getSize()
local offscreenImage = gfx.image.new(screenWidth, screenHeight)




-- Load the sound file
local clickSound = snd.sample.new("sfx/click.wav")
assert(clickSound, "Failed to load sound file.")

if not offscreenImage then
    error("Failed to create offscreen image")
end

local pieces = {"Head", "Torso", "ArmsL","ArmsR", "LegsL", "LegsR"}
local activeIndex = 1  -- Start with the first item as active
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

local font = gfx.font.new('font/Mini Sans 2X') -- DEMO
local bg = gfx.image.new('images/bg1.png')
local ui = gfx.image.new('images/ui.png')
local titleScreen = gfx.image.new('images/titlescreen.png')


local bgSprite = gfx.sprite.new(bg)
local titleSprite = gfx.sprite.new(titleScreen)

local titleActive = true
local subTitleActive = true

local titleAniSprite = AnimatedSprite.new(titleTable)
titleAniSprite:moveTo(screenWidth / 2, screenHeight / 2)
titleAniSprite:addState('idle', 17, 17, { tickStep = 11 })
titleAniSprite:addState('idlestory', 19, 19, { tickStep = 11 })

titleAniSprite:addState("appear", 1, 15, {tickStep = 30}).asDefault()
titleAniSprite:addState("story", 17, 19, {tickStep = 100, loop=false})
titleAniSprite:addState("fade", 20, 25, {tickStep = 5, loop=false})--

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

function drawToOffscreenImage()
    gfx.pushContext(offscreenImage) -- Set the offscreen image as the current drawing target
    -- Draw your scene here, this could be drawing sprites, shapes, text, etc.
    gfx.setBackgroundColor(gfx.kColorWhite)
    gfx.clear() -- Clear with background color
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRoundRect(10, 10, 100, 100, 10) -- Example shape
    gfx.popContext() -- Restore previous drawing context
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
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	gfx.setFont(font) -- DEMO

    clickSound:play()
end

loadGame()



function pd.update()

    if titleActive or subTitleActive then
        if playdate.buttonJustPressed(pd.kButtonA) then
            -- titleSprite:remove()
            if subTitleActive and not titleActive  then
                titleAniSprite:changeState("fade")
                titleAniSprite:playAnimation()
                subTitleActive = false
            end
            if titleActive then
                titleAniSprite:changeState("story")
                titleAniSprite:playAnimation()
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
    lastCrankPosition = currentCrankPosition  -- Update the last position for the next frame

    -- Rotate the sprite based on crank movement
    local currentAngle = myCharacter:getPartRotation()
    
    local crankChange = playdate.getCrankChange()

    local crankPosition = playdate.getCrankPosition()
    local degreesChanged = math.abs(crankPosition - lastDCrankPosition)

    if degreesChanged >= 10 or degreesChanged <= -10 then
        clickSound:play()  -- Play sound every 10 degrees
        lastDCrankPosition = crankPosition -- Update the last position after playing the sound
    end

    
    myCharacter:rotatePartFree(currentAngle+crankChange)

	if playdate.buttonJustPressed(pd.kButtonA) then

	end
	if playdate.buttonJustPressed(pd.kButtonB) then
		-- changeActivePiece()
        activeIndex = activeIndex + 1
        if activeIndex > #pieces then
            activeIndex = 1
        end
        myCharacter:selectPart(pieces[activeIndex])

	end
 
    gfx.sprite.update()

end