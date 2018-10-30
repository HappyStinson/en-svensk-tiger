player1 = { x = 160, y = 710, w = 20, h = 20, speed = 150, angle = 0, active = true, dead = false, deadDur = 0, highlight = false, head = nil, shirt = nil, pants = nil,   animation = { angle = 0, step = 0 }, exitAngle }
player2 = { x = -100, y = -100, w = 20, h = 20, speed = 200, angle = 0, timer = 0, attack = false, animation = { angle = 0, step = 0} }
player3 = { x = -100, y = -100, w = 20, h = 20, speed = 200, angle = 0, timer = 0, attack = false, animation = { angle = 0, step = 0} }

function spawnDot()
  local spawnPoint = math.random(1, 11)
	dot.x = dotSpawns[spawnPoint][1] - 25
	dot.y = dotSpawns[spawnPoint][2] - 25
end

function attack(player)
  local x = player.x - (player.w * 5)
  local y = player.y - (player.h * 5)
  local w = player.w * 10
  local h = player.h * 10
  local hit = false
  for i = 1, numberOfNPCs, 1 do
    if CheckCollision(x, y, w, h, npcs[i].x, npcs[i].y, npcs[i].w, npcs[i].h) then
        killNPC(npcs[i])
        hit = true
    end
  end
  
  if CheckCollision(x, y, w, h, player1.x, player1.y, player1.w, player1.h) then
    -- The swede was found by player
    player1.dead = true
    player1.deadDur = 8
    love.audio.play(attackSound)
    return true
  end
  
  if hit then
    love.audio.play(attackSound)
  else
    love.audio.play(missSound)
  end
  
end

function playerReset()
  local spawnPoint = math.random(1, 5)
	player1.x = npcSpawns[spawnPoint][1]
	player1.y = npcSpawns[spawnPoint][2]
  player1.head = headColors[math.random(1, 4)]
  player1.shirt = shirtColors[math.random(1, 3)]
  player1.pants = pantsColors[math.random(1, 3)]
  player1.dead = false
  player1.exitAngle = math.random() * 2 * math.pi
end

function highlightPlayer(dt)
  highlight.time = highlight.time + dt
  
  player1.active = false
  
  if highlight.time > 2 then
    player1.highlight = true
  end
end

function moveUp(player, dt)
  player.animation.step = player.animation.step + dt * 10
  player.animation.angle = math.sin(player.animation.step) / 4
  
  for i, box in ipairs(collision) do
      if CheckCollision(box.x, box.y, box.w, box.h, player.x, player.y - (player.speed*dt), player.w, player.h) then
        return
      end
  end

  player.y = player.y - player.speed * dt
end

function moveRight(player, dt)
  player.animation.step = player.animation.step + dt * 10
  player.animation.angle = math.sin(player.animation.step) / 4
  
  for i, box in ipairs(collision) do
      if CheckCollision(box.x, box.y, box.w, box.h, player.x + (player.speed*dt), player.y, player.w, player.h) then
        return
      end
  end

  player.x = player.x + player.speed * dt
end

function moveDown(player, dt)
  player.animation.step = player.animation.step + dt * 10
  player.animation.angle = math.sin(player.animation.step) / 4
  
  for i, box in ipairs(collision) do
      if CheckCollision(box.x, box.y, box.w, box.h, player.x, player.y + (player.speed*dt), player.w, player.h) then
        return
      end
  end

  player.y = player.y + player.speed * dt
end

function moveLeft(player, dt)
  player.animation.step = player.animation.step + dt * 10
  player.animation.angle = math.sin(player.animation.step) / 4
  
  for i, box in ipairs(collision) do
      if CheckCollision(box.x, box.y, box.w, box.h, player.x - (player.speed*dt), player.y, player.w, player.h) then
        return
      end
  end

  player.x = player.x - player.speed * dt
end

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
          x2 < x1+w1 and
          y1 < y2+h2 and
          y2 < y1+h1
end

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  love.mouse.setVisible(false) -- make default mouse invisible
  
  -- NPC
  require('palette')
 	math.randomseed(os.time())
	npcs = {}
  numberOfNPCs = 30
	for i = 1, numberOfNPCs, 1 do
		newNPC()
  end
  
  -- load ttf file font. set 20px font-size
  scoreFont = love.graphics.newFont("assets/1942.ttf", 15);
  timerFont = love.graphics.newFont("assets/1942.ttf", 30);
  
  map = love.graphics.newImage("assets/bg.png")
  folder = love.graphics.newImage("assets/folder.png")
  head = love.graphics.newImage("assets/head.png")
  shirt = love.graphics.newImage("assets/body.png")
  pants = love.graphics.newImage("assets/legs.png")
  russian = love.graphics.newImage("assets/ryss.png")
  german = love.graphics.newImage("assets/tysk.png")
  warnRussian = love.graphics.newImage("assets/warRus.png")
  warnGerman = love.graphics.newImage("assets/warGer.png")
  warnRusScore = love.graphics.newImage("assets/warRusScore.png")
  warnGerScore = love.graphics.newImage("assets/warGerScore.png")
  warnBoth = love.graphics.newImage("assets/warBoth.png")
  warnHighlight = love.graphics.newImage("assets/warHL.png")
  missionSuccess = love.graphics.newImage("assets/infoSweSuccess.png")
  missionFailed = love.graphics.newImage("assets/warSweFail.png")
  infoDot = love.graphics.newImage("assets/infoMission.png")
  
  attackSound = love.audio.newSource("assets/attack.mp3")
  hr1Sound = love.audio.newSource("assets/homerun1.mp3")
  hr2Sound = love.audio.newSource("assets/homerun2.mp3")
  missSound = love.audio.newSource("assets/miss.mp3")
  plingSound = love.audio.newSource("assets/pling.mp3")
  
  playerReset()
  
  overlay = { timer = 0, show = false, sprite = infoDot }
  highlight = { time = 0 }
  
  score = { p1 = 0, p2 = 0, p3 = 0 }
  dot = { x, y, w = 50, h = 50, timer = 0, success = false, gotScore = false }
  dotCountdown = overlay.timer
  
  spawnTimer = 0
  
  local joysticks = love.joystick.getJoysticks()
  joystick = joysticks[1]
  
  collision = {
	{x = 0, y = 0, w = 1366, h = 14},
	{x = 0, y = 0, w = 14, h = 768},
	{x = 1352, y = 0, w = 14, h = 768},
	{x = 0, y = 754, w = 1366, h = 14},
	{x = 0, y = 96, w = 103, h = 81},
	{x = 184, y = 96, w = 185, h = 81},
	{x = 449, y = 96, w = 84, h = 81},
	{x = 964, y = 96, w = 104, h = 81},
	{x = 1150, y = 96, w = 216, h = 81},
	{x = 0, y = 258, w = 103, h = 511},
	{x = 184, y = 258, w = 185, h = 81},
	{x = 450, y = 258, w = 83, h = 81},
	{x = 614, y = 258, w = 84, h = 81},
	{x = 778, y = 258, w = 105, h = 307},
	{x = 964, y = 258, w = 105, h = 307},
	{x = 1150, y = 258, w = 215, h = 307},
	{x = 184, y = 420, w = 185, h = 145},
	{x = 183, y = 645, w = 185, h = 123},
	{x = 450, y = 645, w = 248, h = 123},
	{x = 779, y = 645, w = 290, h = 123},
	{x = 1150, y = 645, w = 215, h = 123}
}

  love.window.setFullscreen(true, "desktop")
  
  spawnDot()
end

function love.update(dt)
  -- Handle joystick movement
  if not joystick then
    love.graphics.print("No joystick detected")
  else
    love.graphics.print("Joystick detected")
  end

  if joystick and player1.active and player1.dead == false then
    if joystick:isDown(5) then
      moveUp(player1, dt)
    elseif joystick:isDown(6) then
      moveRight(player1, dt)
    elseif joystick:isDown(7) then
      moveDown(player1, dt)
    elseif joystick:isDown(8) then
      moveLeft(player1, dt)
    else
      player1.animation.angle = 0
    end
  end
  
  if love.keyboard.isDown('w') then
    moveUp(player2, dt)
  elseif love.keyboard.isDown('d') then
    moveRight(player2, dt)
  elseif love.keyboard.isDown('s') then
    moveDown(player2, dt)
  elseif love.keyboard.isDown('a') then
    moveLeft(player2, dt)
  else
    player2.animation.angle = 0
  end
  
  if love.keyboard.isDown('lalt') and player2.timer > 0 and player2.attack == false then
    player2.attack = true
    player2.timer = 3
    love.audio.play(attackSound)
    if attack(player2) then
      score.p2 = score.p2 + 10
      overlay.show = true
      overlay.sprite = warnGerScore
      overlay.timer = 2
      love.audio.play(hr1Sound)
      love.audio.play(hr2Sound)
    end
  end
  
  if love.keyboard.isDown('ralt') and player3.timer > 0 and player3.attack == false then
    player3.attack = true
    player3.timer = 3
    if attack(player3) then
      score.p3 = score.p3 + 10
      overlay.show = true
      overlay.sprite = warnRusScore
      overlay.timer = 2
      love.audio.play(hr1Sound)
      love.audio.play(hr2Sound)
    end
  end
  
  if love.keyboard.isDown('up') then
    moveUp(player3, dt)
  elseif love.keyboard.isDown('right') then
    moveRight(player3, dt)
  elseif love.keyboard.isDown('down') then
    moveDown(player3, dt)
  elseif love.keyboard.isDown('left') then
    moveLeft(player3, dt)
  else
    player3.animation.angle = 0
  end
  
  for i = 1, numberOfNPCs, 1 do
    updateNPC(npcs[i], dt)
  end
  
  if joystick and joystick:isDown(13) then
    highlightPlayer(dt)
    pling = true
  else
    if pling then
      love.audio.play(plingSound)
    end
    pling = false
    highlight.time = 0
    player1.active = true
    player1.highlight = false
  end
  
  overlay.timer = overlay.timer - dt
  
  spawnTimer = spawnTimer + dt
  if spawnTimer > 10 then
    -- Slumpa om det blir ryss/tysk eller bada
    choice = math.random(1, 3)
    if choice == 1 and player2.timer <= 0 then
      player2.x = 30
      player2.y = 50
      player2.timer = 1000
      player2.attack = false
      overlay.sprite = warnGerman
      overlay.show = true
      overlay.timer = 2
    elseif choice == 2 and player3.timer <= 0 then
      player3.x = 1300
      player3.y = 210
      player3.timer = 1000
      player3.attack = false
      overlay.sprite = warnRussian
      overlay.show = true
      overlay.timer = 2
    elseif choice == 3 and player2.timer <= 0 and player3.timer <= 0 then
      player2.x = 30
      player2.y = 50
      player3.x = 1300
      player3.y = 210
      player2.attack = false
      player3.attack = false
      player2.timer = 1000
      player3.timer = 1000
      overlay.sprite = warnBoth
      overlay.show = true
      overlay.timer = 2
    end
    
    spawnTimer = 0
  end
  
  if player2.timer < 0 then
    player2.x = -100
    player2.y = -100
  else
    player2.timer = player2.timer - dt
  end
  
  if player3.timer < 0 then
    player3.x = -100
    player3.y = -100
  else
    player3.timer = player3.timer - dt
  end
  
  if dot.timer > 0 then
    dot.timer = dot.timer - dt
    if CheckCollision(dot.x, dot.y, dot.w, dot.h, player1.x, player1.y, player1.w, player1.h) then
      dot.success = true
    end
  end
  
  if dot.success == false and dot.timer < 0 then
    score.p1 = score.p1 - 1
    overlay.show = true
    overlay.timer = 2
    overlay.sprite = missionFailed
  end
  
  if dotCountdown > 0 then
    dotCountdown = dotCountdown - dt
  elseif dot.timer <= 0 then
    dot.timer = math.random(10, 20)
    
    overlay.show = true
    overlay.timer = 2
    
    if dot.success then
      score.p1 = score.p1 + 2
      overlay.sprite = missionSuccess
      dot.success = false
    end
    
    dotCountdown = 2
    spawnDot()
  end
  
  if player1.dead and player1.deadDur < 0 then
    playerReset()
  end
  
  -- Player death animation
  if player1.dead then
    player1.deadDur = player1.deadDur - dt
    player1.x = player1.x + dt * 500 * math.cos(player1.exitAngle)
    player1.y = player1.y + dt * 500 * math.sin(player1.exitAngle)
    player1.animation.step = player1.animation.step + dt * 10
    player1.animation.angle = player1.animation.step * 10
  end

  -- I always start with an easy way to exit the game
	if love.keyboard.isDown('escape') or
      joystick and joystick:isDown(4) then
		love.event.push('quit')
	end
  
  if love.keyboard.isDown(" ") then
    love.window.setFullscreen(false, "desktop")
  end
end

function love.draw()
  love.graphics.draw(map)
  
  for i = 1, numberOfNPCs, 1 do
    drawNPC(npcs[i])
  end
  
  if dot.timer > 0 then
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(folder, dot.x + 10, dot.y + 15)
  end
  
  love.graphics.setColor(player1.shirt)
  love.graphics.draw(shirt, player1.x + 10, player1.y + 10, player1.animation.angle, 1, 1, 10, 10)
  love.graphics.setColor(player1.pants)
  love.graphics.draw(pants, player1.x + 10, player1.y + 10, player1.animation.angle, 1, 1, 10, 0)
  love.graphics.setColor(player1.head)
  love.graphics.draw(head, player1.x + 10, player1.y + 10, player1.animation.angle, 1, 1, 7, 19)
  
  love.graphics.setColor(255,255,255,255)
  
  love.graphics.draw(german, player2.x + 10, player2.y + 10, player2.animation.angle, 1, 1, 20, 50)
  love.graphics.draw(russian, player3.x + 10, player3.y + 10, player3.animation.angle, 1, 1, 20, 50)

  if overlay.show and overlay.timer > 0 then
    love.graphics.setColor(255, 255, 255, 220)
    love.graphics.draw(overlay.sprite, 246, 522)
  end
  
  if player1.active == false then
    love.graphics.setColor(255, 255, 255, 220)
    love.graphics.draw(warnHighlight, 246, 522)
  end
  
  if player1.highlight then
    love.graphics.setColor(255, 0, 0, 180)
    love.graphics.circle("fill", player1.x + 10, player1.y + 10, 30)
  end
  
  -- Show some score
  love.graphics.setFont(scoreFont);
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.print(""..score.p1, 1320, 325)
  love.graphics.print(""..score.p2, 1320, 345)
  love.graphics.print(""..score.p3, 1320, 365)
  
  -- set font before draw text
  love.graphics.setFont(timerFont);
  love.graphics.setColor(255, 85, 85, 255)
  love.graphics.print(""..math.floor(dot.timer), 1290, 450)
  
  -- Helper when placing objects
  local x, y = love.mouse.getPosition() -- get the position of the mouse
  --love.graphics.print(""..x..", "..y, 10, 10)
  
  love.graphics.setColor(255, 255, 255, 255)
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end

function newNPC()
	local npc = {}
  local spawnPoint = math.random(1, 5);
	npc.x = npcSpawns[spawnPoint][1]
	npc.y = npcSpawns[spawnPoint][2]
	npc.w = 20
	npc.h = 20
  npc.speed = 150
  npc.exitAngle = math.random()*2*math.pi
  npc.action = {}
  npc.action.duration = 0
  npc.action.type = "stop"
  npc.outfit = {}
  
  npc.outfit.headColor = headColors[math.random(1, 4)]
  npc.outfit.shirtColor = shirtColors[math.random(1, 3)]
  npc.outfit.pantsColor = pantsColors[math.random(1, 3)]
  npc.animation = {}
  npc.animation.angle = 0
  npc.animation.step = 0
	table.insert(npcs, npc)
end

function updateNPC(npc, dt)
  npc.action.duration = npc.action.duration - dt
  
  --NEW ACTION
  if(npc.action.duration <= 0) then
    if(npc.action.type == "dead") then
        local spawnPoint = math.random(1, 5);
        npc.x = npcSpawns[spawnPoint][1]
        npc.y = npcSpawns[spawnPoint][2]
    end
    local newAction = math.random(1, 5)
    
    if(newAction == 1) then
      npc.action.type = "up"
    elseif(newAction == 2) then
      npc.action.type = "right"
    elseif(newAction == 3) then
      npc.action.type = "down"
    elseif(newAction == 4) then
      npc.action.type = "left"
    else
      npc.action.type = "stop"
    end
    
    local newDuration = math.random(1, 2)
    npc.action.duration = newDuration
  end
  
  --DO ACTION
  if(npc.action.type == "up") then
    moveUp(npc, dt)
  elseif(npc.action.type == "right") then
    moveRight(npc, dt)
  elseif(npc.action.type == "down") then
    moveDown(npc, dt)
  elseif(npc.action.type == "left") then
    moveLeft(npc, dt)
  elseif(npc.action.type == "dead") then
    npc.x = npc.x + dt * 500 * math.cos(npc.exitAngle)
    npc.y = npc.y + dt * 500 * math.sin(npc.exitAngle)
  else
    npc.x = npc.x
    npc.y = npc.y
  end
  
  --UPDATE ANIMATION
  if(npc.action.type ~= "stop" and npc.action.type ~= "dead") then 
    --npc.animation.step = npc.animation.step + dt * 10
    --npc.animation.angle = math.sin(npc.animation.step) / 4
  elseif(npc.action.type == "dead") then
    npc.animation.step = npc.animation.step + dt * 10
    npc.animation.angle = npc.animation.step * 10
  else
    npc.animation.angle = 0
  end
end

function drawNPC(npc)
  love.graphics.setColor(npc.outfit.pantsColor)
  love.graphics.draw(pants, npc.x + 10, npc.y + 10, npc.animation.angle, 1, 1, 10, 0)
  love.graphics.setColor(npc.outfit.shirtColor)
  love.graphics.draw(shirt, npc.x + 10, npc.y + 10, npc.animation.angle, 1, 1, 10, 10)
  love.graphics.setColor(npc.outfit.headColor)
  love.graphics.draw(head, npc.x + 10, npc.y + 10, npc.animation.angle, 1, 1, 7, 19)
end

function killNPC(npc)
  npc.action.type = "dead"
  npc.action.duration = 15
end