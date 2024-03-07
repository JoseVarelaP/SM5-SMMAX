local gc = Var "GameCommand"
local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite{
    Name="Picture",
    Texture=THEME:GetPathG("SelectStyle/ScreenSelectStyle","picture".. gc:GetIndex()+1),
    InitCommand=function (self)
        self:xy( SCREEN_CENTER_X + (160-320), SCREEN_CENTER_Y + (280-240) )
    end,
    OnCommand=function (self)
        self:diffusealpha(0):glow(color("1,1,1,0")):linear(0.2)
        :glow(Color.White):linear(0):diffusealpha(1)
        :linear(0.2):glow(color("1,1,1,0"))
    end,
    GainFocusCommand=function (self)
        self:visible(true):playcommand("On")
    end,
    LoseFocusCommand=function (self)
        self:visible(false)
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("SelectStyle/ScreenSelectStyle","info".. gc:GetIndex()+1),
    InitCommand=function (self)
        self:xy( SCREEN_CENTER_X + (480-320), SCREEN_CENTER_Y + (280-240) )
    end,
    OnCommand=function (self)
        self:zoomy(0):bounceend(0.5):zoomy(1)
    end,
    GainFocusCommand=function (self)
        self:visible(true):playcommand("On")
    end,
    LoseFocusCommand=function (self)
        self:visible(false)
    end
}

return t