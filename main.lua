HQSHADERS = SMODS.current_mod

if HQSHADERS.config.better_shaders then
    local background_shader = NFS.read(HQSHADERS.path..'assets/shaders/background.fs')
    local splash_shader = NFS.read(HQSHADERS.path..'assets/shaders/splash.fs')
    local flame_shader = NFS.read(HQSHADERS.path..'assets/shaders/flame.fs')
    G.SHADERS['background'] = love.graphics.newShader(background_shader)
    G.SHADERS['splash'] = love.graphics.newShader(splash_shader)
    G.SHADERS['flame'] = love.graphics.newShader(flame_shader)
end

local crt_shader = NFS.read(HQSHADERS.path..'assets/shaders/CRT.fs')
G.SHADERS['CRT'] = love.graphics.newShader(crt_shader)

if HQSHADERS.config.round_rects then
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
end

HQSHADERS.config_tab = function()
    return {
        n=G.UIT.ROOT,
        config = {align = "cm", padding = 0.05, r = 0.1, minw=9, minh=8, colour = G.C.BLACK}, 
        nodes = {
            {
                n=G.UIT.C,
                config = {align = "cm", colour = G.C.TRANSPARENT},
                nodes = {
                    create_toggle { label = localize('k_hqshader_shaders'), label_scale = 0.4, w = 0, scale = 0.8, ref_table = HQSHADERS.config, ref_value = 'better_shaders' },
                    create_toggle { label = localize('k_hqshader_smooth'), label_scale = 0.4, w = 0, scale = 0.8, ref_table = HQSHADERS.config, ref_value = 'round_rects' },
                    create_toggle { label = localize('k_hqshader_feathering'), label_scale = 0.4, w = 0, scale = 0.8, ref_table = HQSHADERS.config, ref_value = 'crt_feathering' },
                    {n=G.UIT.R, config = {minh=0.25}},
                    create_slider { label = localize('k_hqshader_scanlines'), w = 4, h = 0.3, text_scale = 0.3, label_scale = 0.4, ref_table = HQSHADERS.config, ref_value = 'crt_scanline', min = 0, max = 2, decimal_places = 2 },
                    create_slider { label = localize('k_hqshader_noise'), w = 4, h = 0.3, text_scale = 0.3, label_scale = 0.4, ref_table = HQSHADERS.config, ref_value = 'crt_noise', min = 0, max = 0.8, decimal_places = 2 },
                    create_slider { label = localize('k_hqshader_bloom'), w = 4, h = 0.3, text_scale = 0.3, label_scale = 0.4, ref_table = HQSHADERS.config, ref_value = 'crt_bloom', min = 0, max = 1, decimal_places = 2 },
                    create_slider { label = localize('k_hqshader_bloom_cutoff'), w = 4, h = 0.3, text_scale = 0.3, label_scale = 0.4, ref_table = HQSHADERS.config, ref_value = 'crt_bloom_cutoff', min = 0, max = 1, decimal_places = 2 },
                    create_slider { label = localize('k_hqshader_bloom_distance'), w = 4, h = 0.3, text_scale = 0.3, label_scale = 0.4, ref_table = HQSHADERS.config, ref_value = 'crt_bloom_distance', min = 1, max = 10, decimal_places = 0 },
                    create_slider { label = localize('k_hqshader_distortion'), w = 4, h = 0.3, text_scale = 0.3, label_scale = 0.4, ref_table = HQSHADERS.config, ref_value = 'crt_distortion', min = 0, max = 2, decimal_places = 2 },
                    create_slider { label = localize('k_hqshader_color'), w = 4, h = 0.3, text_scale = 0.3, label_scale = 0.4, ref_table = HQSHADERS.config, ref_value = 'color', min = 0, max = 2, decimal_places = 2 },
                }
            }
        }
    }
end

--[[

        local t = {
          n=G.UIT.ROOT, config = {align = "cm",colour = G.C.CLEAR}, nodes={   
            {n=G.UIT.R, config={align = "cm", padding = 0.05, r = 0.1, emboss = 0.1, colour = G.C.L_BLACK}, nodes={
              create_slider({label = 'Time', w = 2, h = 0.3, text_scale = 0.2, label_scale = 0.3, ref_table = G.SANDBOX, ref_value = 'vort_time', min = 0, max = 30}),
              create_option_cycle({options = {'PLAY','PAUSE'}, opt_callback = 'do_time', current_option = 1, colour = G.C.RED, w = 2, scale = 0.7}),
              create_slider({label = 'tilt', w = 2, h = 0.3, text_scale = 0.2, label_scale = 0.3, ref_table = G.SANDBOX, ref_value = 'tilt', min = 0, max = 3, decimal_places = 2}),
              create_slider({label = 'Card size', w = 2, h = 0.3, text_scale = 0.2, label_scale = 0.3, ref_table = G.SANDBOX, ref_value = 'card_size', min = 0.1, max = 3, callback = 'cb', decimal_places = 2}),
              create_option_cycle({options = G.SANDBOX.col_op, opt_callback = 'col1change', current_option = 1, colour = G.C.RED, w = 2, scale = 0.7}),
              create_option_cycle({options = G.SANDBOX.col_op, opt_callback = 'col2change', current_option = 2, colour = G.C.RED, w = 2, scale = 0.7}),
              {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes = {
                UIBox_button{ label = {"+"}, button = "spawn_joker", minw = 0.7, col = true},
                create_text_input({prompt_text = 'Joker key', extended_corpus = true, ref_table = G.SANDBOX, ref_value = 'joker_text', text_scale = 0.3, w = 1.5, h = 0.6}),
                UIBox_button{ label = {"-"}, button = "rem_joker", minw = 0.7, col = true},
              }},
              create_option_cycle({options = {'base', 'foil', 'holo', 'polychrome','negative'}, opt_callback = 'edition_change', current_option = 1, colour = G.C.RED, w = 2, scale = 0.7}),
            }}
          }}
          ]]