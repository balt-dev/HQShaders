HQSHADERS = SMODS.current_mod

local background_shader = NFS.read(HQSHADERS.path..'assets/shaders/background.fs')
local splash_shader = NFS.read(HQSHADERS.path..'assets/shaders/splash.fs')
local flame_shader = NFS.read(HQSHADERS.path..'assets/shaders/flame.fs')
G.SHADERS['background'] = love.graphics.newShader(background_shader)
G.SHADERS['splash'] = love.graphics.newShader(splash_shader)
G.SHADERS['flame'] = love.graphics.newShader(flame_shader)

function UIElement:draw_pixellated_rect(_type, _parallax, _emboss, _progress)
    local ext_up = self.config.ext_up and self.config.ext_up*G.TILESIZE or 0
    local res = self.config.res or math.min(self.VT.w, self.VT.h + math.abs(ext_up)/G.TILESIZE) > 3.5 and 0.8 or math.min(self.VT.w, self.VT.h + math.abs(ext_up)/G.TILESIZE) > 0.3 and 0.6 or 0.15
    local totw, toth, subw, subh = self.VT.w*G.TILESIZE, (self.VT.h + math.abs(ext_up)/G.TILESIZE)*G.TILESIZE, self.VT.w*G.TILESIZE-4*res, (self.VT.h + math.abs(ext_up)/G.TILESIZE)*G.TILESIZE-4*res

    local dx, dy = 0, ext_up

    if _type == "emboss" then
    	dy = dy + _emboss*G.TILESIZE
    end
	if _type == "line_emboss" then
		dx = dx -0.7*_emboss*self.shadow_parrallax.x
		dy = dy -_emboss*self.shadow_parrallax.y
	end
    if _type == "shadow" then
    	dy = dy - self.shadow_parrallax.y*_parallax
    	dx = dx - self.shadow_parrallax.x*_parallax
    end

    if (_type == 'line' or _type == 'line_emboss') then
    	love.graphics.rectangle("line", dx, dy, totw*(_progress or 1), toth, 4*res)
    else
    	love.graphics.rectangle("fill", dx, dy, totw*(_progress or 1), toth, 4*res)
    end
end