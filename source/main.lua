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
local lastCrankPosition = playdate.getCrankPosition()  -- Initialize with the current crank position
-- local Character = require 'Character'
local screenWidth, screenHeight = playdate.display.getSize()
local offscreenImage = gfx.image.new(screenWidth, screenHeight)
if not offscreenImage then
    error("Failed to create offscreen image")
end

local pieces = {"Head", "Torso", "Arms", "Legs"}
local activeIndex = 1  -- Start with the first item as active
local myCharacter = Character.new()
myCharacter:selectPart("Torso")
myCharacter:movePart(5, 0)
-- myCharacter:rotatePart(10)
myCharacter:resetPart()

-- local mirrorCharacter = Character.new()
-- mirrorCharacter:selectPart("Head")
-- mirrorCharacter:movePart(5, 0)
-- mirrorCharacter:rotatePart(-10)
-- mirrorCharacter:resetPart()

local font = gfx.font.new('font/Mini Sans 2X') -- DEMO
local bg = gfx.image.new('images/bg.png')
local ui = gfx.image.new('images/ui.png')
local bgSprite = gfx.sprite.new(bg)
local uiSprite = gfx.sprite.new(ui)

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
uiSprite:add()

local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	gfx.setFont(font) -- DEMO
end

loadGame()
function pd.update()
    -- drawToOffscreenImage() -- Update the offscreen image
    -- gfx.sprite.updateAll() -- Update and draw all sprites
    -- Get the current position
    local x1, y1 = myCharacter:getPosition()
    -- local x2, y2 = spriteRight:getPosition()
    -- print(x1, y1)
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
	-- local currentAngle2 = mirrorCharacter:getPartRotation()
	-- spriteLeft:setRotation(currentAngle + crankChange)
	-- spriteRight:setRotation(currentAngle2 - crankChange)
    myCharacter:rotatePartFree(currentAngle+crankChange)
    -- mirrorCharacter:rotatePartFree(currentAngle2-crankChange)
	if playdate.buttonJustPressed(pd.kButtonA) then
		-- spriteLeft:setRotation(0)
		-- spriteRight:setRotation(0)
        gfx.sprite.update()

	end
	if playdate.buttonJustPressed(pd.kButtonB) then
		-- changeActivePiece()
        activeIndex = activeIndex + 1
        if activeIndex > #pieces then
            activeIndex = 1
        end
      
        myCharacter:selectPart(pieces[activeIndex])
	end
    -- Update the display
    gfx.sprite.update()
    -- myCharacter:update()

    playdate.timer.updateTimers()
	
end