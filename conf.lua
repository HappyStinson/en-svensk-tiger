-- Configuration
function love.conf(t)
	t.version = "0.9.2"         -- The LÖVE version this game was made for (string)
	
	t.window.title = "En svensk tiger säger... Game by Mike & Happy for BOSS Jam 2015" -- The title of the window the game is in (string)
	t.window.width = 1366
  t.window.height = 768  
	t.window.fsaa = 16
	
	t.modules.math = false
	t.modules.physics = false
	t.modules.system = false
	t.modules.thread = false
end