local children = {
	Def.BitmapText{
		Font="_shared1",
		Text=THEME:GetString( 'ScreenTitleMenu', Var("GameCommand"):GetText() );
		InitCommand=function(self)
			self:shadowlength(5)
		end;
		GainFocusCommand=function(self)
			self:stoptweening():linear(0.25):zoom(1.3):diffuse( color(".5,1,.5,1") )
		end;
		LoseFocusCommand=function(self)
			self:stoptweening():linear(0.25):zoom(1):diffuse( Color.White )
		end;
		DisabledCommand=function(self)
			self:diffuse(0.5,0.5,0.5,1)
		end;
	};
};

return Def.ActorFrame { children = children };