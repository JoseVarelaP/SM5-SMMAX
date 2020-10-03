GameColor.PlayerColors["PlayerNumber_P1"] = color("0.4,1.0,0.8,1")
GameColor.PlayerColors["PlayerNumber_P2"] = color("1.0,0.5,0.2,1")



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