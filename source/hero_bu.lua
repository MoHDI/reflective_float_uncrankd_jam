import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/ui"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Hero_BU').extends(gfx.sprite)

function Hero_BU:init(x, y)
    Hero.super.init(self)  -- Initialize the base sprite class
    
    -- Load images
    self.baseImage = gfx.image.new(200, 240)
    -- self.baseImage = gfx.image.new(200, 240, gfx.kImageFormatGrayscale)
    gfx.setClipRect(0, 0, 200, 240)
    assert(self.baseImage, "Failed to create base image")

    self.head = gfx.image.new('images/body/head.png')
    self.torso = gfx.image.new('images/body/torso.png')
    self.leftArm = gfx.image.new('images/body/arm.png')
    self.leftLeg = gfx.image.new('images/body/leg.png')
    self.rightArm = gfx.image.new('images/body/arm_r.png')
    self.rightLeg = gfx.image.new('images/body/leg_r.png')
    


    assert(self.torso, "Failed to load body image")
    assert(self.head, "Failed to load head image")
    assert(self.leftArm, "Failed to load leftArm image")
    assert(self.leftLeg, "Failed to load leftLeg image")
    assert(self.rightArm, "Failed to load rightArm image")
    assert(self.rightLeg, "Failed to load rightLeg image")

    self.headRotation = 0  -- Starting rotation angle for the head
    self:moveTo(x, y)
    self:add()  -- Add the sprite to the display list
end

function Hero:rotateHead(angle)
    self.headRotation = (self.headRotation + angle)  -- Increment and wrap the rotation
end
function Hero_bu:movePart(x, y)
   self:moveTo(
      self.x + x, self.y + y
    )
   
end

function Hero_bu:update()
    gfx.pushContext(self.baseImage)  -- Draw onto the base image
    gfx.clear(gfx.kColorClear)  -- Clear with transparent color

    -- Optionally draw static parts here (could add other parts like body, arms, etc.)

    -- Rotate and draw the head
    local headCenterX, headCenterY = 100, 120  -- Center for the head
    gfx.pushContext()  -- Save current drawing context
    
    -- gfx.translate(headCenterX, headCenterY)  -- Move context to where the head should be centered
    -- gfx.rotate(math.rad(self.headRotation))  -- Apply rotation in radians
    -- self.head:draw(-self.head:getWidth() / 2, -self.head:getHeight() / 2)  -- Draw head centered on its rotation point
    self.head:draw(70, 0)  -- Draw head centered on its rotation point
    self.leftLeg:draw(52, 99)  -- Draw left leg       
    self.rightArm:draw(84, 57)  -- Draw right arm
    self.leftArm:draw(0, 57)  -- Draw left arm
    self.rightLeg:draw(94, 99)  -- Draw right leg
    self.torso:draw(77, 58)  -- Draw body       
    gfx.popContext()  -- Restore the previous context
    gfx.popContext()  -- End drawing to base image

    self:setImage(self.baseImage)  -- Update the sprite's image
end
