enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage('enemy.png')

function love.load()
  background_image = love.graphics.newImage('background.jpeg')
  love.window.setFullscreen(true, "desktop")
  player={}
  player.x=love.graphics.getWidth( )/2-5
  player.y=love.graphics.getHeight( )-40
  player.speed=5
  player.image = love.graphics.newImage('player.png')
  player.bullets={}
  player.cooldown=20
  player.fire=function()
    if player.cooldown<=0 then
    player.cooldown=20
    bullet={}
    bullet.x=player.x+35
    bullet.y=player.y
    table.insert(player.bullets,bullet)
    end
  end
  for i=0, 10 do
    enemies_controller:spawnEnemy((i*love.graphics.getWidth( )/10)+love.graphics.getWidth( )/40, 0)
  end
  for i=0, 10 do
    enemies_controller:spawnEnemy((i*love.graphics.getWidth( )/10)+love.graphics.getWidth( )/40, 60)
  end
  for i=0, 10 do
    enemies_controller:spawnEnemy((i*love.graphics.getWidth( )/10)+love.graphics.getWidth( )/40, 120)
  end
end

function enemies_controller:spawnEnemy(x, y)
  enemy = {}
  enemy.x = x
  enemy.y = y
  enemy.width = 50
  enemy.height = 50
  enemy.bullets = {}
  enemy.cooldown = 20
  enemy.speed = .1
  table.insert(self.enemies, enemy)
end

function enemy:fire()
  if self.cooldown <= 0 then
    self.cooldown = 20
    bullet = {}
    bullet.x = self.x + 35
    bullet.y = self.y
    table.insert(self.bullets, bullet)
  end
end

function checkCollisions(enemies, bullets)
  for i, e in ipairs(enemies) do
    for _, b in pairs(bullets) do
      if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
        table.remove(enemies, i)
        table.remove(bullets, _)
      end
    end
  end
end

function love.update(dt)
  --Movement
  player.cooldown=player.cooldown-1
  if love.keyboard.isDown("right") then 
    player.x=player.x+player.speed
  elseif love.keyboard.isDown("left") then
    player.x=player.x-player.speed
  end
  
  if love.keyboard.isDown("space") then
    player.fire()
  end
  
  if love.keyboard.isDown("escape") then
    love.event.quit()
  end
  
  if enemies_controller.enemies == 0 then
    game_win = true
  end
  
  for _,e in pairs(enemies_controller.enemies) do
    if e.y >= 3*(love.graphics.getHeight()/4) then
      game_over = true
    end
    e.y = e.y + 1 * e.speed
  end
  
  for i,v in ipairs(player.bullets) do
    if v.y<-10 then
      table.remove(player.bullets,i)
    end
    v.y=v.y-10
  end
  
  checkCollisions(enemies_controller.enemies, player.bullets)
end

function love.draw()
  if game_over then
    love.event.quit()
  end
 for i = 0, love.graphics.getWidth() / background_image:getWidth() do
        for j = 0, love.graphics.getHeight() / background_image:getHeight() do
            --Drawing background
            love.graphics.setColor(255,255, 255)
            love.graphics.draw(background_image, i * background_image:getWidth(), j * background_image:getHeight())
            --Yellow Line
            love.graphics.setColor(255,255, 0)
            love.graphics.line( 0, 3*(love.graphics.getHeight()/4), love.graphics.getWidth(), 3*(love.graphics.getHeight()/4))
            --Draws Exit info
            love.graphics.setColor(255,255, 255)
            love.graphics.print( "ESC to Exit", love.graphics.getWidth()/2-20, 0)
        end
  end
  love.graphics.setColor(255, 0, 0)
  love.graphics.draw(player.image, player.x, player.y)
  for _,e in pairs(enemies_controller.enemies) do
    love.graphics.setColor(0, 255, 0)
    love.graphics.draw(enemies_controller.image, e.x, e.y, 0)
  end
    for _,v in pairs(player.bullets) do
    love.graphics.setColor(255, 0, 0)
      love.graphics.rectangle("fill", v.x, v.y, 10, 10)
    end
end