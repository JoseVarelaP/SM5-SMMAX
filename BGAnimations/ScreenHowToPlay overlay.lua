local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","ScreenHowToPlay/howtoplay"),
    InitCommand=function(self)
        self:zbuffer(true):z(20):Center():diffusealpha(0):zoom(4):linear(0.3):diffusealpha(1):zoom(1):sleep(1.8)
        :linear(0.3):zoom(0.5):xy( SCREEN_CENTER_X + (170-320), SCREEN_CENTER_Y + (60-240) )
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","ScreenHowToPlay/feet"),
    InitCommand=function(self)
        self:zbuffer(true):z(20):Center():addx(-SCREEN_WIDTH):sleep(2.4):decelerate(0.3):addx(SCREEN_WIDTH):sleep(2)
        :linear(0.3):zoomy(0)
    end
}

-- Pre-Step message
t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","ScreenHowToPlay/taphand"),
    InitCommand=function(self)
        self:rotationy(180):rotationz(270):xy( SCREEN_CENTER_X + (290-320), SCREEN_CENTER_Y + (110-240) ):bob()
        :effectperiod(1):effectmagnitude(20,0,0):diffusealpha(0):sleep(6):linear(0):diffusealpha(1)
        :sleep(2):linear(0):diffusealpha(0)
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","ScreenHowToPlay/tapmessage"),
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X + (480-320), SCREEN_CENTER_Y + (280-240) )
        :diffusealpha(0):sleep(6):linear(0):diffusealpha(1):sleep(2):linear(0):diffusealpha(0)
    end
}

-- 1st Step -- DOWN
local singleNotes = {448, 512, 384}
for i,v in ipairs(singleNotes) do
    local sleepTime = 9.7 + (3*(i-1))
    t[#t+1] = Def.Sprite{
        Texture=THEME:GetPathG("","ScreenHowToPlay/taphand"),
        InitCommand=function(self)
            self:xy( SCREEN_CENTER_X + (v-320), SCREEN_CENTER_Y + (180-240) ):bob()
            :effectperiod(1):effectmagnitude(0,20,0):diffusealpha(0):sleep(sleepTime):linear(0):diffusealpha(1)
            :sleep(2):linear(0):diffusealpha(0)
        end
    }

    t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","ScreenHowToPlay/tapmessage"),
        InitCommand=function(self)
            self:xy( SCREEN_CENTER_X + (480-320), SCREEN_CENTER_Y + (280-240) )
            :diffusealpha(0):sleep(sleepTime):linear(0):diffusealpha(1):sleep(2):linear(0):diffusealpha(0)
        end
    }
end

-- 4th Step -- JUMP
t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","ScreenHowToPlay/jumphands"),
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X + (480-320), SCREEN_CENTER_Y + (180-240) ):bob()
        :effectperiod(1):effectmagnitude(0,20,0):diffusealpha(0):sleep(18.7):linear(0):diffusealpha(1)
        :sleep(1.7):linear(0):diffusealpha(0)
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","ScreenHowToPlay/jumpmessage"),
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X + (480-320), SCREEN_CENTER_Y + (280-240) )
        :diffusealpha(0):sleep(18.7):linear(0):diffusealpha(1):sleep(1.7):linear(0):diffusealpha(0)
    end
}

-- Misstep
t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","ScreenHowToPlay/taphand"),
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X + (548-320), SCREEN_CENTER_Y + (110-240) ):bob()
        :effectperiod(1):effectmagnitude(0,20,0):diffusealpha(0):sleep(22.7):linear(0):diffusealpha(1)
        :sleep(1.7):linear(0):diffusealpha(0)
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","ScreenHowToPlay/missmessage"),
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X + (480-320), SCREEN_CENTER_Y + (280-240) )
        :diffusealpha(0):sleep(22.7):linear(0):diffusealpha(1):sleep(22.7):linear(0):diffusealpha(0)
    end
}
return t

--[[
//Misstep
[Layer13]
Type=0
File=taphand.png
Command=x,548;y,110;bob;effectperiod,1;effectmagnitude,0,20,0;diffusealpha,0;sleep,22.7;linear,0;diffusealpha,1;sleep,1.7;linear,0;diffusealpha,0

[Layer14]
Type=0
File=missmessage.png
Command=x,480;y,280;diffusealpha,0;sleep,22.7;linear,0;diffusealpha,1;sleep,22.7;linear,0;diffusealpha,0
]]