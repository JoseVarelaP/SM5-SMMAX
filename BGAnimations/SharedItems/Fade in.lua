return Def.Quad{
    StartTransitioningCommand=function(self)
        self:stretchto( 0,0, SCREEN_WIDTH, SCREEN_HEIGHT ):diffuse(Color.Black)
        :linear(0.3):diffusealpha(0)
    end
}