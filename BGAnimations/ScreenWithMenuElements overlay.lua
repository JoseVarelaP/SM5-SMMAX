return Def.ActorFrame{
    Def.Sprite{
        Texture=THEME:GetPathG("_shared","footer"),
        OnCommand=function(self)
            self:align(0,1):y(SCREEN_BOTTOM)
        end
    },
    
    Def.HelpDisplay {
		File="Common normal",
		OnCommand=function(self)
			self:zoom(0.5):zoomy(0):linear(0.5):zoomy(0.5):diffuseblink()
		end,
		InitCommand=function(self)
            self:SetSecsBetweenSwitches( THEME:GetMetric("HelpDisplay","TipSwitchTime") )
            local screenname = Var "LoadingScreen"
            local UseSpecialText = function()
                -- Title Menu uses special types based on the coin mode.
                if screenname == "ScreenTitleMenu" then
                    local CoinMode = GAMESTATE:GetCoinMode()
                    return "HelpText".. ToEnumShortString( CoinMode )
                end
                return "HelpText"
            end
            self:SetTipsColonSeparated( THEME:GetString( Var "LoadingScreen" ,UseSpecialText()) )
            self:xy( THEME:GetMetric( Var "LoadingScreen", "HelpX" ), THEME:GetMetric( Var "LoadingScreen", "HelpY" ) )
		end,
		OffCommand=function(self)
			self:linear(0.5):zoomy(0)
		end
	}
}