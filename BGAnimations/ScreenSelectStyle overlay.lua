local t = Def.ActorFrame{}

t[#t+1] = loadfile( THEME:GetPathB("ScreenWithMenuElements","overlay") )()

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("SelectStyle/ScreenSelectStyle","explanation"),
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X + (480-320), SCREEN_CENTER_Y + (170 - 240) )
    end,
    OnCommand=function(self)
        self:addx(SCREEN_WIDTH):bounceend(0.5):addx(-SCREEN_WIDTH)
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("SelectStyle/ScreenSelectStyle","warning"),
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X + (480-320), SCREEN_CENTER_Y + (400 - 240) )
    end,
    OnCommand=function(self)
        self:addy(-120):zoomy(0):decelerate(0.5):zoomy(1):addy(120):diffuseshift()
        :effectcolor1(Color.White):effectcolor2(color("0.4,0.4,0.4,1"))
    end
}

-- Premium counter
t[#t+1] = Def.Sprite{
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X + (530-320), SCREEN_CENTER_Y + (84 - 240) )

        -- Load appropiate image based on Premium type.
        if not GAMESTATE:IsEventMode() and GAMESTATE:GetCoinMode() == "CoinMode_Pay" then
            if GAMESTATE:GetPremium() == "Premium_2PlayersFor1Credit" then
                self:Load( THEME:GetPathG("SelectStyle/ScreenSelectStyle","joint premium") )
            end
            if GAMESTATE:GetPremium() == "Premium_DoubleFor1Credit" then
                self:Load( THEME:GetPathG("SelectStyle/ScreenSelectStyle","doubles premium") )
            end
        end
    end,
    OnCommand=function(self)
        self:addx(SCREEN_WIDTH):bounceend(0.5):addx(-SCREEN_WIDTH)
        :glowshift():effectcolor1(Color.White):effectcolor2(color("1,1,1,0.3"))
    end
}

return t