local t = Def.ActorFrame{}

-- A fade in
t[#t+1] = Def.Quad{
    OnCommand=function(self)
        self:FullScreen():diffuse(Color.Black):sleep(0.5):linear(0.8):diffusealpha(0)
    end
}

local sWidth = SCREEN_WIDTH + 480

-- 6 LeftToRight wiping stars.
for i = 1,6 do
    -- 6 LeftToRight leading bars
    t[#t+1] = Def.Quad{
        OnCommand=function(self)
            self:halign(0):diffuse(Color.Black):zoomto(sWidth,32):xy(
                SCREEN_CENTER_X + ((-64 * i) - 320),
                SCREEN_CENTER_Y + (64 * i - 240)
            )
            :linear(2):addx(sWidth):sleep(0):diffusealpha(0)
        end
    }

    t[#t+1] = Def.Sprite{
        Texture=THEME:GetPathG("","ScreenGameplay/LeftToRight"),
        OnCommand=function(self)
            self:xy(
                SCREEN_CENTER_X + ((-64 * i) - 320),
                SCREEN_CENTER_Y + (64 * i - 240)
            )
            :linear(2):addx(sWidth):sleep(0):diffusealpha(0)
        end
    }
end

-- 6 RightToLeft wiping stars.
for i = 1,6 do
    -- 6 RightToLeft leading bars
    t[#t+1] = Def.Quad{
        OnCommand=function(self)
            self:halign(1):diffuse(Color.Black):zoomto(sWidth,32):xy(
                SCREEN_CENTER_X + ((-64 * i) - 320),
                SCREEN_CENTER_Y + (64 * i - 240) + 32
            )
            :addx(sWidth):linear(2):addx(-sWidth):sleep(0):diffusealpha(0)
        end
    }

    t[#t+1] = Def.Sprite{
        Texture=THEME:GetPathG("","ScreenGameplay/RightToLeft"),
        OnCommand=function(self)
            self:xy(
                SCREEN_CENTER_X + ((-64 * i) - 320),
                SCREEN_CENTER_Y + (64 * i - 240) + 32
            )
            :addx(sWidth):linear(2):addx(-sWidth):sleep(0):diffusealpha(0)
        end
    }
end

return t