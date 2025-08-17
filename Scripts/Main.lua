GameColor.PlayerColors.PLAYER_1 = color("0.4,1.0,0.8,1")
GameColor.PlayerColors.PLAYER_2 = color("1.0,0.5,0.2,1")

GameColor.Difficulty.Beginner = color("0.0,0.9,1,1")
GameColor.Difficulty.Easy = color("0.9,0.9,0,1")
GameColor.Difficulty.Medium = color("1,0.1,0.1,1")
GameColor.Difficulty.Hard = color("0.2,1,0.2,1")
GameColor.Difficulty.Challenge = color("0.2,0.6,1.0,1")

function TextBannerAfterSet(self)
    local Title=self:GetChild("Title")
	local Subtitle=self:GetChild("Subtitle")
    local Artist=self:GetChild("Artist")
    
    local hassubtitle = Subtitle:GetText() ~= ""
    Subtitle:visible( hassubtitle )
    if hassubtitle then
        Title:maxwidth(180):y(-10)
        Subtitle:zoom(0.5):maxwidth(360)
        Artist:zoom(0.6):maxwidth(266):y(10)
    else
        Title:y(-8):maxwidth(180)
        Artist:zoom(0.6):maxwidth(266):y(8)
    end
end