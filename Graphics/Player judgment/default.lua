local sPlayer = Var "Player"

local CommandList = {
    TapNoteScore_W1 = {0,"W1Command"},
    TapNoteScore_W2 = {1,"W2Command"},
    TapNoteScore_W3 = {2,"W3Command"},
    TapNoteScore_W4 = {3,"W4Command"},
    TapNoteScore_W5 = {4,"W5Command"},
    TapNoteScore_Miss = {5,"MissCommand"},
}

local function GetJCMD(JCMD)
	return THEME:GetMetric( "Judgment", CommandList[JCMD][2] )
end

return Def.ActorFrame{
    Def.Sprite{
        Name="Judgment",
        Texture="Judgment",
        InitCommand=function(self)
            self:animate(0):visible(false):shadowlength(4)
        end
    },

    JudgmentMessageCommand=function(self,params)
        local Judg = self:GetChild("Judgment")
        if params.Player ~= sPlayer then return end
		if params.HoldNoteScore then return end
        if string.find(params.TapNoteScore, "Mine") then return end

        if CommandList[params.TapNoteScore][1] then
            local iFrame = CommandList[params.TapNoteScore][1]
            Judg:finishtweening():y(0):visible( true ):stopeffect():diffusealpha(1):setstate( iFrame )
            GetJCMD( params.TapNoteScore )(Judg)
        end
    end
}