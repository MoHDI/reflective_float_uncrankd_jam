import "CoreLibs/graphics"
import "CoreLibs/object"

import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"

-- import "dvd" -- DEMO
-- local dvd = dvd(1, -1) -- DEMO
local pd <const> = playdate
local gfx <const> = pd.graphics 
local lastCrankPosition = playdate.getCrankPosition()  -- Initialize with the current crank position


local font = gfx.font.new('font/Mini Sans 2X') -- DEMO
local head = gfx.image.new('images/full_head2.png')
local screen_ui = gfx.image.new('images/screen.png')
local leg = gfx.image.new('images/leg.png')
-- Create a sprite with the loaded image
local spriteLeft = gfx.sprite.new(head)
local spriteRight = gfx.sprite.new(head)
local screenSprite = gfx.sprite.new(screen_ui)
local legSprite = gfx.sprite.new(leg)

spriteLeft:moveTo(160, 120)  -- Set the initial position for sprite 1
spriteRight:moveTo(240, 120)  -- Set the initial position for sprite 2
spriteLeft:setClipRect(0, 0, 200, 240)  -- Set the clipping rectangle for sprite 2
spriteRight:setClipRect(200, 0, 200, 240)  -- Set the clipping rectangle for sprite 2

screenSprite:moveTo(200, 120)  -- Set the initial position for sprite 2
screenSprite:add()
spriteLeft:add()  -- Add spriteLeft to the drawing system
spriteRight:add()  -- Add spriteRight to the drawing system
legSprite:add()  -- Add spriteRight to the drawing system
-- Flip spriteRight horizontally to make it mirrored-- Create the central sprite
local screenWidth, screenHeight = playdate.display.getSize()
local centralSprite = gfx.sprite.new()
local pieces = {"piece1", "piece2", "piece3", "piece4"}
local activeIndex = 1  -- Start with the first item as active

-- Function to change the active piece
function changeActivePiece()
    -- Increment the index to point to the next piece
    activeIndex = activeIndex + 1
    
    -- Loop back to the first piece if we exceed the number of items
    if activeIndex > #pieces then
        activeIndex = 1
    end
    
    -- Trace out the current active piece
    print("Active piece is now: " .. pieces[activeIndex])
end

-- Build one container for the whole caracter 
centralSprite:setSize(screenWidth / 2, screenHeight)  -- Half the screen width, full height
centralSprite:moveTo(screenWidth / 2, screenHeight / 2)  -- Center it

-- centralSprite:setBackgroundColor(gfx.kColorBlack)  -- Set a background color
-- centralSprite:setColor(gfx.kColorBlack)  -- Set a color
-- gfx.setColor(gfx.kColorBlack)
-- centralSprite.graphics.fillRect(50, 50, 100, 100)
-- centralSprite.setBackgroundColor(gfx.kColorBlack)  -- Set a background color

centralSprite:add()
-- spriteRight:setScale(-1, 1)
spriteRight:setCenter(0.5, 0.5)  -- Set the center of the sprite to the middle
-- spriteRight:setRotation(90)

local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	gfx.setFont(font) -- DEMO
end

local function updateGame()
	-- dvd:update() -- DEMO
end

local function drawGame()
	gfx.clear() -- Clears the screen
	head:draw( 100, 120) -- Draw the image at coordinates (x, y)
-- dvd:draw() -- DEMO
end

loadGame()
function playdate.updatesss()
    -- Get the current position
    local x1, y1 = spriteLeft:getPosition()
    local x2, y2 = spriteRight:getPosition()
    
    -- Check for D-pad inputs and adjust position
    if playdate.buttonIsPressed(playdate.kButtonUp) then
        y1 = y1 - 2
        y2 = y2 - 2
    elseif playdate.buttonIsPressed(playdate.kButtonDown) then
        y1 = y1 + 2
        y2 = y2 + 2
    end
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        x1 = x1 - 2
        x2 = x2 + 2
    elseif playdate.buttonIsPressed(playdate.kButtonRight) then
        x1 = x1 + 2
        x2 = x2 - 2
    end
  
    -- Update sprite positions
    spriteLeft:moveTo(x1, y1)
    spriteRight:moveTo(x2, y2)
    -- spriteRight:moveTo(100,100)
	local currentCrankPosition = playdate.getCrankPosition()
    local crankChange = currentCrankPosition - lastCrankPosition
    lastCrankPosition = currentCrankPosition  -- Update the last position for the next frame

    -- Rotate the sprite based on crank movement
    local currentAngle = spriteLeft:getRotation()
	local currentAngle2 = spriteRight:getRotation()
	spriteLeft:setRotation(currentAngle + crankChange)

	spriteRight:setRotation(currentAngle2 - crankChange)
	if playdate.buttonJustPressed(pd.kButtonA) then
		spriteLeft:setRotation(0)
		spriteRight:setRotation(0)
	end
	if playdate.buttonJustPressed(pd.kButtonB) then
		changeActivePiece()
	end
    -- Update the display
    gfx.sprite.update()
    playdate.timer.updateTimers()
	
end
