return Def.ActorFrame{
    Def.Sprite{
        Texture=THEME:GetPathG("_shared","footer"),
        OnCommand=function(self)
            self:align(0,1):y(SCREEN_BOTTOM)
        end
    },
    loadfile( THEME:GetPathB("","SharedItems/HelpDisplay.lua") )()
}