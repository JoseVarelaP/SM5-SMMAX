return Def.ActorFrame{
    Def.Quad{
        InitCommand=function(self)
            self:FullScreen():diffuse(Color.Black)
        end
    },
    Def.Sprite{ Texture="caution.png", OnCommand=function(self)
        self:Center()
        SOUND:PlayAnnouncer("caution")
    end },
}