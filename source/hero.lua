import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/ui"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Hero').extends(gfx.sprite)

function Hero:init(x, y)
    Hero.super.init(self)  -- Initialize the base sprite class
    
    -- Load images
    self.baseImage = gfx.image.new(200, 240)
    gfx.setClipRect(0, 0, 200, 240)
    assert(self.baseImage, "Failed to create base image")

    self.head = gfx.image.new('images/full_head2.png')
    assert(self.head, "Failed to load head image")

    self.headRotation = 0  -- Starting rotation angle for the head
    self:moveTo(x, y)
    self:add()  -- Add the sprite to the display list
end

function Hero:rotateHead(angle)
    self.headRotation = (self.headRotation + angle) % 360  -- Increment and wrap the rotation
end
function Hero:movePart(x, y)
   self:moveTo(
      self.x + x, self.y + y
    )
   
end

function Hero:update()
    gfx.pushContext(self.baseImage)  -- Draw onto the base image
    gfx.clear()  -- Clear previous drawings

    -- Optionally draw static parts here (could add other parts like body, arms, etc.)

    -- Rotate and draw the head
    local headCenterX, headCenterY = 100, 120  -- Center for the head
    gfx.pushContext()  -- Save current drawing context
    -- gfx.translate(headCenterX, headCenterY)  -- Move context to where the head should be centered
    -- gfx.rotate(math.rad(self.headRotation))  -- Apply rotation in radians
    -- self.head:draw(-self.head:getWidth() / 2, -self.head:getHeight() / 2)  -- Draw head centered on its rotation point
    self.head:draw(0, 0)  -- Draw head centered on its rotation point
    gfx.popContext()  -- Restore the previous context

    gfx.popContext()  -- End drawing to base image

    self:setImage(self.baseImage)  -- Update the sprite's image
end
