local sPlayer = Var "Player"
local ShowComboAt = 4

local ZoomCoords = {
    Min = 0.5,
    Max = 0.9,
    Range = 300
}

local TweenSeconds = 0.05
local PulseZoom = 1.2

local t = Def.ActorFrame{
    Def.Sprite{
        Name = "Label",
        Texture = "Combo label",
        InitCommand=function(self)
            self:xy( 6, 20 ):align(0,1)
        end
    },
    Def.BitmapText{
        Name = "Number",
        Font = "Combo Numbers",
        InitCommand = function(self)
            self:xy( 0, 20 ):align(1,1)
        end
    },

    InitCommand = function(self)
		c = self:GetChildren()
		c.Number:visible(false)
		c.Label:visible(false)
	end,
    ComboCommand=function(self, param)
        local iCombo = param.Misses or param.Combo;
        if not iCombo or iCombo < ShowComboAt then
            c.Label:visible(false)
            c.Number:visible(false)
            return
        end

        if param.Combo then
            c.Label:visible(true)
            c.Number:visible(true)

            param.Zoom = scale( iCombo, 0, ZoomCoords.Range, ZoomCoords.Min, ZoomCoords.Max )
            param.Zoom = clamp( param.Zoom, ZoomCoords.Min, ZoomCoords.Max )

            c.Number:settext( string.format("%i", iCombo) )
            :stoptweening():zoom( param.Zoom * PulseZoom ):linear( TweenSeconds ):zoom( param.Zoom )

            -- There is support for MidPoint coloring like ITG in 3.9's Src, but the default theme
            -- never used it, so it won't be included here.
        end
    end
}

return t