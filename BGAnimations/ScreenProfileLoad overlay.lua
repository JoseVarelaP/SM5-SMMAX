local t = Def.ActorFrame{
    BeginCommand=function(self)
		if SCREENMAN:GetTopScreen():HaveProfileToLoad() then self:sleep(0); end;
		self:queuecommand("Load");
	end;
	LoadCommand=function() SCREENMAN:GetTopScreen():Continue(); end;
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","_moveon"),
    InitCommand=function(self)
        self:Center()
    end
}

return t