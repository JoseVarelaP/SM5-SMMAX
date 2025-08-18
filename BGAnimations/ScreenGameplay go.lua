return Def.ActorFrame{
    -- This implements FocusingSprite.  Three copies of the sprite; one stays
    -- put, one moves in and out from the top-left and one moves in and out
    -- from the bottom-right; each fades from 0 alpha to .5 alpha and back.
    Def.Sprite{
        Texture=THEME:GetPathG("","ScreenGameplay/go"),
        OnCommand=function(self)
            self:Center():diffusealpha(0):linear(0.5):diffusealpha(0.5):sleep(0.5):
            linear(0.5):diffusealpha(0)
        end
    },
    Def.Sprite{
        Texture=THEME:GetPathG("","ScreenGameplay/go"),
        OnCommand=function(self)
            self:xy( SCREEN_CENTER_X + (220-320), SCREEN_CENTER_Y + (140-240) )
            :diffusealpha(0):linear(0.5):diffusealpha(0.5):Center():sleep(0.5):
            linear(0.5):diffusealpha(0)
            :xy( SCREEN_CENTER_X + (220-320), SCREEN_CENTER_Y + (140-240) )
        end
    },
    Def.Sprite{
        Texture=THEME:GetPathG("","ScreenGameplay/go"),
        OnCommand=function(self)
            self:xy( SCREEN_CENTER_X + (420-340), SCREEN_CENTER_Y + (340-240) )
            :diffusealpha(0):linear(0.5):diffusealpha(0.5):Center():sleep(0.5):
            linear(0.5):diffusealpha(0)
            :xy( SCREEN_CENTER_X + (420-340), SCREEN_CENTER_Y + (340-240) )
        end
    }
}