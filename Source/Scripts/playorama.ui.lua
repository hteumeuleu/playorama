import "Scripts/ui/header/Header"
import "Scripts/ui/menu/Menu"

local pd <const> = playdate
local gfx <const> = pd.graphics

playorama = playorama or {}
playorama.ui = {}
playorama.ui.fonts = {}
playorama.ui.fonts.medium = gfx.font.new("Fonts/Cuberick-Bold", playdate.graphics.font.kVariantBold)
playorama.ui.fonts.large = gfx.font.new("Fonts/Cuberick-Bold-24", playdate.graphics.font.kVariantBold)

