import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/ui"
import "AnimatedSprite"

local gfx <const> = playdate.graphics

-- Character class definition
Character = {}
Character.__index = Character

local function getRotatedPosition(x, y, cx, cy, angle)
    local rad = math.rad(angle)
    local cos = math.cos(rad)
    local sin = math.sin(rad)
    -- Translate point back to origin:
    x, y = x - cx, y - cy
    -- Rotate point
    local xnew = x * cos - y * sin
    local ynew = x * sin + y * cos
    -- Translate point back:
    x, y = xnew + cx, ynew + cy
    return x, y
end


function Character.new()
    local self = setmetatable({}, Character)
    -- Loading imagetable from the disk
imagetable = gfx.imagetable.new('images/sheets/head-scar')
imagetableFlip = gfx.imagetable.new('images/sheets/head-scar-flip')

-- Creating an AnimatedSprite instance
headsprite = AnimatedSprite.new(imagetable )
-- Adding custom a animation state (Optional)
headsprite:addState('idle',1,12,{ tickStep = 10 })
headsprite:addState('highlighted',13,24,{ tickStep = 10 })
-- -- Playing the animation
headsprite:moveTo(200, 120)
headsprite:setZIndex(23)
headsprite:playAnimation()

local spriteImage = playdate.graphics.image.new("images/body/head.png")
local spriteH = playdate.graphics.sprite.new(spriteImage)
spriteH:moveTo(100, 100) -- Adjust position as necessary
spriteH:add()

local maskImage = gfx.image.new(200, 240)
gfx.pushContext(maskImage)
gfx.setColor(gfx.kColorBlack)
gfx.fillRect(0, 0,200, 240) -- Fill left half with black (visible part)
gfx.popContext()

local spriteM = playdate.graphics.sprite.new(maskImage)
spriteM:moveTo(100, 120) -- Adjust position as necessary
spriteM:setZIndex(15)
-- spriteM:add()


-- spriteH:setMaskImage(maskImage)


mheadsprite = AnimatedSprite.new(imagetableFlip)
-- Adding custom a animation state (Optional)
mheadsprite:addState('idle',1,12,{ tickStep = 10 })
mheadsprite:addState('highlighted',13,24,{ tickStep = 10 })
mheadsprite:setScale(-2, 1)

-- -- Playing the animation
mheadsprite:moveTo(200, 120)
mheadsprite:setZIndex(24)
mheadsprite:playAnimation()
-- local width, height = headsprite:getSize()
-- local flippedHead = gfx.image.new(width, height)

-- gfx.pushContext(flippedHead)
-- gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)
-- gfx:draw(-width, 0, width, height)
-- gfx.popContext()

-- mHeadSprite:setImage(flippedHead)
-- -- mHeadSprite:add()
    -- Initialize character parts with their respective images
    self.parts = {
        Head = {image = "images/body/head.png", rotateLimit = 45, moveLimit = {x = 10, y = 10}},
        Torso = {image = "images/body/torso.png", rotateLimit = 30, moveLimit = {x = 5, y = 5}},
        Arms = {image = "images/body/arm.png", rotateLimit = 90, moveLimit = {x = 15, y = 15}},
        Legs = {image = "images/body/leg.png", rotateLimit = 60, moveLimit = {x = 10, y = 20}}
    }
    self.mirrorparts = {
        -- Head = {image = "images/body/head.png", rotateLimit = 45, moveLimit = {x = 10, y = 10}},
        Arms = {image = "images/body/arm.png", rotateLimit = 90, moveLimit = {x = 15, y = 15}},
        Legs = {image = "images/body/leg.png", rotateLimit = 60, moveLimit = {x = 10, y = 20}}
    }
    -- self.parts.Head:setCenter(0.5, 0.5)  -- Set the center of the sprite to the middle
   
    -- Load images and create sprites for each part
    for partName, part in pairs(self.parts) do
        local img = gfx.image.new(part.image)
     
        assert(img, "Failed to load title screen image.")
        if not img then
            error("Failed to load image for " .. partName)
        end
      -- Set the center for each sprite
  
        part.sprite = gfx.sprite.new(img)

        if partName == "Head" then
            part.sprite:setCenter(0.5, 0.939)  -- Specific center for the head
            headsprite:setCenter(0.5, 0.939)
            part.sprite:setZIndex(4)
         elseif partName == "Legs" then
            part.sprite:setZIndex(2)
            part.sprite:setCenter(0.54, 0.1)
         elseif partName == "Arms" then
            part.sprite:setZIndex(5)
            part.sprite:setCenter(0.92, 0.5)
        elseif partName == "Torso" then
            part.sprite:setZIndex(3)
            part.sprite:setCenter(0.5, 0.5)
            else

                
            part.sprite:setCenter(0.5, 0.5)  -- Default center for other parts
         end

        part.sprite:moveTo(200, 120)  -- Initial position, adjust as necessary
        -- part.sprite:setZIndex(1)
        -- part.sprite:add()
    end
    for mirrorPartName, mpart in pairs(self.mirrorparts) do
        local img = gfx.image.new(mpart.image)
     
        assert(img, "Failed to load title screen image.")
        if not img then
            error("Failed to load image for " .. mirrorPartName)
        end
      -- Set the center for each sprite
  
       mpart.sprite = gfx.sprite.new(img)

        if mirrorPartName == "Head" then
           mpart.sprite:setCenter(0.5, 0.939)  -- Specific center for the head
         elseif mirrorPartName == "Legs" then
            mpart.sprite:setCenter(0.54, 0.1)
         elseif mirrorPartName == "Arms" then
            mpart.sprite:setCenter(0.92, 0.5)
            else
                
            mpart.sprite:setCenter(0.5, 0.5)  -- Default center for other parts
         end
        --  mpart.sprite:setScale(-1, 1)
        mpart.sprite:moveTo(220, 120)  -- Initial position, adjust as necessary
        mpart.sprite:setZIndex(1)
        mpart.sprite:add()
    end
    -- Default to first part selected
    self.currentPart = self.parts.Head
      -- Define clipping bounds for the character
    self.clipRect = {x = 0, y = 0, width = 200, height = 240}
    return self
end

-- Select a specific part of the character
function Character:selectPart(partName)
    if self.parts[partName] then
        self.currentPart = self.parts[partName]
        print("Selected part: " .. partName)
    else
        print("Part not found: " .. partName)
    end
end

-- Move the current active selected part within limits
function Character:movePart(x, y)
   
    -- local current = self.currentPart
    local current = self.parts.Torso
    local torso = self.parts.Torso
    -- print(current)
    local newAngle =  torso.sprite:getRotation()
current.sprite:moveTo(
    math.max(math.min(current.sprite.x + x, current.sprite.x + current.moveLimit.x), current.sprite.x - current.moveLimit.x),
    math.max(math.min(current.sprite.y + y, current.sprite.y + current.moveLimit.y), current.sprite.y - current.moveLimit.y)
)

    headsprite:moveTo(getRotatedPosition(torso.sprite.x, torso.sprite.y-20, torso.sprite.x, torso.sprite.y, newAngle))
    self.parts.Head.sprite:moveTo(getRotatedPosition(torso.sprite.x, torso.sprite.y-20, torso.sprite.x, torso.sprite.y, newAngle))
    self.parts.Arms.sprite:moveTo(getRotatedPosition(torso.sprite.x-15, torso.sprite.y-10, torso.sprite.x, torso.sprite.y, newAngle))
    self.parts.Legs.sprite:moveTo(getRotatedPosition(torso.sprite.x-15, torso.sprite.y+20, torso.sprite.x, torso.sprite.y, newAngle))

   self.mirrorparts.Arms.sprite:moveTo(getRotatedPosition(torso.sprite.x+15, torso.sprite.y-10, torso.sprite.x, torso.sprite.y, newAngle))
    self.mirrorparts.Legs.sprite:moveTo(getRotatedPosition(torso.sprite.x+15, torso.sprite.y+20, torso.sprite.x, torso.sprite.y, newAngle))
    torso.sprite:setRotation(newAngle) 

end

function Character:rotatePartFree(angle)
    local current = self.currentPart
    local torso = self.parts.Torso
    local newAngle =  angle
    if current == self.parts.Torso then 
        -- self.parts.Head.sprite:moveTo(getRotatedPosition(self.parts.Head.sprite.x, self.parts.Head.sprite.y, current.sprite.x, current.sprite.y, newAngle))
        -- self.parts.Head.sprite:moveTo(getRotatedPosition(current.sprite.x, current.sprite.y-20, current.sprite.x, current.sprite.y, newAngle))
        headsprite:moveTo(getRotatedPosition(current.sprite.x, current.sprite.y-20, current.sprite.x, current.sprite.y, newAngle))
  
        self.parts.Arms.sprite:moveTo(getRotatedPosition(current.sprite.x-15, current.sprite.y-10, current.sprite.x, current.sprite.y, newAngle))
        self.parts.Legs.sprite:moveTo(getRotatedPosition(current.sprite.x-15, current.sprite.y+20, current.sprite.x, current.sprite.y, newAngle))

        -- self.mirrorparts.Head.sprite:moveTo(getRotatedPosition(current.sprite.x, current.sprite.y-20, current.sprite.x, current.sprite.y, newAngle))
        self.mirrorparts.Arms.sprite:moveTo(getRotatedPosition(current.sprite.x+15, current.sprite.y-10, current.sprite.x, current.sprite.y, newAngle))
        self.mirrorparts.Legs.sprite:moveTo(getRotatedPosition(current.sprite.x+15, current.sprite.y+20, current.sprite.x, current.sprite.y, newAngle))
        headsprite:changeState('idle')
    end

    if(current == self.parts.Head) then
        headsprite:changeState('highlighted')
        --  headsprite:forceNextAnimation(true, 'idle') -- Used to change state to the next animation (from current state's nextAnimation param) or to the specified state now or in the end of the current animation loop.
        headsprite:setRotation(newAngle)
        -- self.mirrorparts.Head.sprite:setRotation(-newAngle)
    end
    if(current == self.parts.Arms) then

        self.mirrorparts.Arms.sprite:setRotation(-newAngle)
    end
    if(current == self.parts.Legs) then
        self.mirrorparts.Legs.sprite:setRotation(-newAngle)
    end

    current.sprite:setRotation(newAngle)

end

function Character:getPartRotation()
    local current = self.currentPart
    return current.sprite:getRotation()
end
function Character:getPosition()
    local current = self.currentPart
    return current.sprite:getPosition()
end
-- Reset the current selected part to default position and rotation
function Character:resetPart()
    local current = self.currentPart
    current.sprite:setRotation(0)
    current.sprite:moveTo(200, 120)  -- Reset to some default position, modify as needed
end
function Character:update()
    gfx.sprite.update()
end
