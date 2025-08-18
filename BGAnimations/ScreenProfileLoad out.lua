return Def.ActorFrame{
    Def.Actor{
        StartTransitioningCommand=function(self)
            SOUND:PlayOnce(THEME:GetPathB("","_swoosh.ogg"))
        end
    }
}