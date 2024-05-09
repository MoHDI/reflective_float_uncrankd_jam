import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/ui"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Hero').extends(gfx.sprite)

function Hero:init(x, y)
    Hero.super.init(self)
    
    -- Load images
    self.baseImage = gfx.image.new(200, 240)
    assert(self.baseImage, "Failed to create base image")

    -- Load each part with an image and rotation
    self.parts = {
        head = {image = gfx.image.new('images/body/head_tall.png'), rotation = 0, centerX = 100, centerY = 66},
        -- head = {image = gfx.image.new('images/body/head.png'), rotation = 0, centerX = 71, centerY = 1, wide = 60, tall=66},
        torso = {image = gfx.image.new('images/body/torso.png'), rotation = 0, centerX = 77, centerY = 58},
        leftArm = {image = gfx.image.new('images/body/arm.png'), rotation = 0, centerX = 0, centerY = 57},
        rightArm = {image = gfx.image.new('images/body/arm_r.png'), rotation =0, centerX = 84, centerY = 57},
        leftLeg = {image = gfx.image.new('images/body/leg.png'), rotation = 0, centerX = 52, centerY = 99},
        rightLeg = {image = gfx.image.new('images/body/leg_r.png'), rotation = 0, centerX = 94, centerY = 99},
    }

    self:moveTo(x, y)
    self:add()
end
-- Select a specific part of the character
function Hero:selectPart(partName)
    if self.parts[partName] then
        self.currentPart = self.parts[partName]
        print("Selected part: " .. partName)
    else
        print("Part not found: " .. partName)
    end
end
function Hero:movePart(x, y)
    self:moveTo(
       self.x + x, self.y + y
     )
 end
function Hero:rotatePart(angle)
    local current = self.currentPart
    if current then
        -- self.parts[partName].rotation = (self.parts[partName].rotation + angle) % 360
        current.rotation = angle

        -- partName.image:drawRotated(100,66, partName.rotation)
    end
end

function Hero:update()
    gfx.pushContext(self.baseImage)
    gfx.clear(gfx.kColorClear)  -- Clear with transparent color

    -- Draw all parts
    for name, part in pairs(self.parts) do
        -- print(name)
        -- if name == "head" then
        -- self.parts.head.image:drawRotated(100,66, self.parts.head.rotation)
        -- elseif name == "leftArm" then
        --         self.parts.leftArm.image:drawRotated(100,66, self.parts.leftArm.rotation)
        --  else
            -- self:draw(part)
            -- self:drawRotatedPart(part)
            part.image:drawRotated(part.centerX,part.centerY, part.rotation)  
        --  part.image:draw(part.centerX,part.centerY)

        -- end
    end

    gfx.popContext()  -- End drawing to base image
    self:setImage(self.baseImage)  -- Update the sprite's image
end

function Hero:drawRotatedPart(part)
    
    local rad = math.rad(part.rotation)
    print(rad )

    -- local rad = math.rad(angle)
    local cos = math.cos(rad)
    local sin = math.sin(rad)
    -- Calculate new position based on rotation
    -- local dx = -part.image:getWidth() / 2
    -- local dy = -part.image:getHeight() / 2
    -- local dx = -part.wide / 2
    -- local dy = -part.tall / 2
   -- Get the width and height of the image
--    print(part.image:getSize(), " <<<<<<<<<< ")
--    local width, height = part.image:getSize()
   local width, height = part.image:getSize()
--    print("Width:", width)   -- Print width
--    print("Height:", height) -- Print height
   -- Calculate the center of the image
   local dx = width / 2
   local dy = height / 2

    local rotatedX = cos * dx - sin * dy + part.centerX
    local rotatedY = sin * dx + cos * dy + part.centerY


    -- part.image:setRotation(part.rotation)
   
    part.image:drawRotated(100,66, part.rotation)
    -- part.image:draw(rotatedX, rotatedY)
    -- part.image:draw(0,0)

end
