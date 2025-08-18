local gc = Var "GameCommand"
local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("SelectStyle/ScreenSelectStyle","icon".. gc:GetIndex()+1),
    OnCommand=function (self)
        self:addx(-640):sleep(0.20 - (gc:GetIndex() * 0.05)):decelerate(0.3):addx(640)
    end,
    OffCommand=function(self)
        self:bouncebegin(0.5):zoomy(0)
    end,
    GainFocusCommand=function (self)
        self:glowshift():effectperiod(0.5)
    end,
    LoseFocusCommand=function (self)
        self:stopeffect()
    end,
    DisabledCommand=function(self)
        self:diffuse(color("0.2,0.2,0.2,1"))
    end
}

return t