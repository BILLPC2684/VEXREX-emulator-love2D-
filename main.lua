function love.run()

	if love.math then
		love.math.setRandomSeed(os.time())
	end

	if love.load then love.load(arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			if love.draw then love.draw() end
			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end

end
--"C:\Program Files\LOVE\love.exe" ./ <ROM> --console
skipframe=8
t1max,CPS=0,0
state = true
love.mouse.setGrabbed(state)
love.mouse.setVisible(not state)
---FUNCIONS---
function love.keypressed(key)
 if key == "escape" then
  local state = not love.mouse.isGrabbed()   -- the opposite of whatever it currently is
  love.mouse.setGrabbed(state) --Use love.mouse.setGrab(state) for 0.8.0 or lower
  love.mouse.setVisible(not state)
 elseif key == "kp+" then
  skipframe=skipframe+1
  print(skipframe)
 elseif key == "kp-" then
  skipframe=skipframe-1
  print(skipframe)
 else
  keyin = key
 end
end
local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

function rectangle(x0, y0, x1, y1, color)
 local y=y0
 repeat
  line(x0,y,x1,y,color)
  if y1 > y then
   y=y+1
  elseif y1 < y then
   y=y-1
  end
 until y == y1
end

function line(x0, y0, x1, y1, color) -- most code from Voltzlive
 dx = math.abs(x1-x0)
 if x0<x1 then
  sx = 1
 else
  sx = -1
 end
 dy = -math.abs(y1-y0)
 if y0<y1 then
  sy = 1
 else
  sy = -1
 end
 err = dx + dy
 e2 = 0
 while true do
  local X=x0+1
  local Y=y0+1
--  print(X,Y,color[1],color[2],color[3])
  if X>=0 and X<=resX+1 and Y>=0 and Y<=resY+1 then
--   print("hi")
   screen[Y][X] = color
  end
  if x0==x1 and y0==y1 then
   break
  end
  e2 = 2*err
  if e2 >= dy then
   err = err + dy
   x0 = x0 + sx
  end
  if e2 <= dx then
   err = err + dx
   y0 = y0 + sy
  end
 end
end

function is_REG(ID)
 if ID == "A" or ID == "B" or ID == "C" or ID == "D" or ID == "E" or ID == "F" or ID == "G" or ID == "H" or ID == "SCW" or ID == "SCH" then
  return true
 else
  return false
 end
end

function def_REG(ID)
 if ID == "A" then
  return 1
 elseif ID == "B" then
  return 2
 elseif ID == "C" then
  return 3
 elseif ID == "D" then
  return 4
 elseif ID == "E" then
  return 5
 elseif ID == "F" then
  return 6
 elseif ID == "G" then
  return 7
 elseif ID == "H" then
  return 8
 elseif ID == "SCW" then
  return 9
 elseif ID == "SCH" then
  return 10
 end
end

function split(str, pat)
	local t = {}  -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pat
	local last_end = 1
	local s, e, cap = str:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(t,cap)
		end
		last_end = e+1
		s, e, cap = str:find(fpat, last_end)
	end
	if last_end <= #str then
		cap = str:sub(last_end)
		table.insert(t, cap)
	end
	return t
end
---------------
function love.load()
 keyin=""
 renderX,renderY=0,0
 resX,resY=240,120
 screen={}
 for i=1,resY+1 do
  temp={}
  for i=0,resX+1 do
   table.insert(temp,{0,0,0})
  end
  table.insert(screen,temp)
 end
--[[ screenl1={}
 for i=1,resY do
  temp={}
  for i=0,resX do
   table.insert(temp,{0,0,0,0})
  end
  table.insert(screenl1,temp)
 end
 screenl2={}
 for i=1,resY do
  temp={}
  for i=0,resX do
   table.insert(temp,{0,0,0,0})
  end
  table.insert(screenl2,temp)
 end]]--
 love.window.setMode(resX,resY,{vsync=false,fullscreen=false})
 FONT={""}
 PC=1
 SP=0
 STACK={}
 --[[if not(love.keyboard.hasTextInput()) then
  love.keyboard.setTextInput(true)
 end
 filename=""
 mode=0
 while true do
  if keyin == ("enter" or "return") then
   mode=1
   break
  else
   filename=filename..keyin
  end
 end]]--
 File=dofile(arg[2])
 print(h,w)
 REGS={0,0,0,0,0,0,0,0,resX,resY}
 R=0x00
 G=0x00
 B=0x00
 A=0xFF
 X=0x00
 Y=0x00
 RAM={}
 points={{0,0},{0,0}}
 for i=0,1024 do
  table.insert(RAM,#RAM+1,0)
 end
 drawmode = 1
end
clock1 = os.clock
clock2 = os.clock
t2 = clock2()
function love.update()
 t1 = clock1()
 opcode=split(tostring(ROM[PC]),"	" or " ")
 --print("PC:"..tostring(PC),"opcode:",opcode[1],opcode[2],opcode[3],"REGS:",REGS[1],REGS[2],REGS[3],REGS[4],REGS[5],REGS[6],REGS[7],REGS[8],"\nSCREEN:",REGS[9],REGS[10],"POS/COL:",X,Y,R,G,B,A,"\nPOINTS:",points[1][1],points[1][2],points[2][1],points[2][2])
 if opcode[1] == "LOAD" then
  REGS[def_REG(opcode[2])]=tonumber(opcode[3])
  PC=PC+1
 elseif opcode[1] == "INKY" then
  REGS[def_REG(opcode[2])]=love.keyboard.isDown(tonumber(opcode[3]))
  PC=PC+1
 elseif opcode[1] == "CRLC" then
  REGS[def_REG(opcode[2])],REGS[def_REG(opcode[3])]=love.mouse.getPosition()
  PC=PC+1
 elseif opcode[1] == "CLIK" then
  REGS[def_REG(opcode[2])]=love.mouse.isDown(tonumber(opcode[3]))
  PC=PC+1
 elseif opcode[1] == "MOV" then
  if is_REG(opcode[3]) then
   REGS[def_REG(opcode[2])]=REGS[def_REG(opcode[3])]
  end
  PC=PC+1
 elseif opcode[1] == "ADD" then
  if is_REG(opcode[3]) then
   REGS[def_REG(opcode[2])]=(REGS[def_REG(opcode[2])]+REGS[def_REG(opcode[3])])%(0xFFFFFFFF+1)
  else
   REGS[def_REG(opcode[2])]=(REGS[def_REG(opcode[2])]+tonumber(opcode[3]))%(0xFFFFFFFF+1)
  end
  PC=PC+1
 elseif opcode[1] == "SUB" then
  if is_REG(opcode[3]) then
   REGS[def_REG(opcode[2])]=(REGS[def_REG(opcode[2])]-REGS[def_REG(opcode[3])])%(0xFFFFFFFF+1)
  else
   REGS[def_REG(opcode[2])]=(REGS[def_REG(opcode[2])]-tonumber(opcode[3]))%(0xFFFFFFFF+1)
  end
  PC=PC+1
 elseif opcode[1] == "DIV" then
  if is_REG(opcode[3]) then
   REGS[def_REG(opcode[2])]=(REGS[def_REG(opcode[2])]/REGS[def_REG(opcode[3])])%(0xFFFFFFFF+1)
  else
   REGS[def_REG(opcode[2])]=(REGS[def_REG(opcode[2])]/tonumber(opcode[3]))%(0xFFFFFFFF+1)
  end
  PC=PC+1
 elseif opcode[1] == "MUL" then
  if is_REG(opcode[3]) then
   REGS[def_REG(opcode[2])]=(REGS[def_REG(opcode[2])]*REGS[def_REG(opcode[3])])%(0xFFFFFFFF+1)
  else
   REGS[def_REG(opcode[2])]=(REGS[def_REG(opcode[2])]*tonumber(opcode[3]))%(0xFFFFFFFF+1)
  end
  PC=PC+1
 elseif opcode[1] == "PRNT" then
  if is_REG(opcode[2]) then
   print(REGS[def_REG(opcode[2])])
  end
  PC=PC+1
 elseif opcode[1] == "JMP" then
  if is_REG(opcode[2]) then
   PC=REGS[def_REG(opcode[2])]
  else
   PC=tonumber(opcode[2])
  end
 elseif opcode[1] == "IF" then
  if REGS[6] == tonumber(opcode[2]) then
   PC=PC+1
  else
   PC=PC+2
  end
 elseif opcode[1] == "HALT" then
  error("CPU HALTED!!!")
 elseif opcode[1] == "WRAM" then
  RAM[REGS[def_REG(opcode[2])]]=REGS[def_REG(opcode[3])]
 elseif opcode[1] == "RRAM" then
  REGS[def_REG(opcode[2])]=RAM[REGS[def_REG(opcode[3])]]
 elseif opcode[1] == "DETC" then
  if is_REG(opcode[3]) then
   if REGS[def_REG(opcode[2])] == 0 and REGS[def_REG(opcode[3])] == 0 then
    REGS[def_REG("F")]=0
   elseif REGS[def_REG(opcode[2])]<REGS[def_REG(opcode[3])] then
    REGS[def_REG("F")]=1
   elseif REGS[def_REG(opcode[2])]==REGS[def_REG(opcode[3])] then
    REGS[def_REG("F")]=2
   elseif REGS[def_REG(opcode[2])]>REGS[def_REG(opcode[3])] then
    REGS[def_REG("F")]=3
   end
  else
   if REGS[def_REG(opcode[2])]<tonumber(opcode[3]) then
    REGS[def_REG("F")]=1
   elseif REGS[def_REG(opcode[2])]==tonumber(opcode[3]) then
    REGS[def_REG("F")]=2
   elseif REGS[def_REG(opcode[2])]>tonumber(opcode[3]) then
    REGS[def_REG("F")]=3
   end
  end
  PC=PC+1
 elseif opcode[1] == "RNG" then
  REGS[def_REG(opcode[2])]=math.random(REGS[def_REG(opcode[2])],REGS[def_REG(opcode[3])])
  PC=PC+1
 elseif opcode[1] == "WAIT" then
  if is_REG(opcode[2]) then
   sleep(REGS[def_REG(opcode[2])])
  else
   sleep(tonumber(opcode[2]))
  end
  PC=PC+1
 elseif opcode[1] == "RCOL" then
  if is_REG(opcode[2]) then
   R=REGS[def_REG(opcode[2])]
  else
   R=tonumber(opcode[2])
  end
  PC=PC+1
 elseif opcode[1] == "GCOL" then
  if is_REG(opcode[2]) then
   G=REGS[def_REG(opcode[2])]
  else
   G=tonumber(opcode[2])
  end
  PC=PC+1
 elseif opcode[1] == "BCOL" then
  if is_REG(opcode[2]) then
   B=REGS[def_REG(opcode[2])]
  else
   B=tonumber(opcode[2])
  end
  PC=PC+1
 elseif opcode[1] == "ACOL" then
  if is_REG(opcode[2]) then
   A=REGS[def_REG(opcode[2])]
  else
   A=tonumber(opcode[2])
  end
  PC=PC+1
 elseif opcode[1] == "XPOS" then
  if is_REG(opcode[2]) then
   X=REGS[def_REG(opcode[2])]
  else
   X=tonumber(opcode[2])
  end
  PC=PC+1
 elseif opcode[1] == "YPOS" then
  if is_REG(opcode[2]) then
   Y=REGS[def_REG(opcode[2])]
  else
   Y=tonumber(opcode[2])
  end
  PC=PC+1
 elseif opcode[1] == "REAR" then
  if is_REG(opcode[2]) then
   REGS[def_REG(opcode[2])]=screen[Y+1][X+1][1]
   --print(screen[Y+1][X+1][1],screen[Y+1][X+1][2],screen[Y+1][X+1][3])
  end
  PC=PC+1
 elseif opcode[1] == "REAG" then
  if is_REG(opcode[2]) then
   REGS[def_REG(opcode[2])]=screen[Y+1][X+1][2]
   --print(screen[Y+1][X+1][1],screen[Y+1][X+1][2],screen[Y+1][X+1][3])
  end
  PC=PC+1
 elseif opcode[1] == "REAB" then
  if is_REG(opcode[2]) then
   REGS[def_REG(opcode[2])]=screen[Y+1][X+1][3]
   --print(screen[Y+1][X+1][1],screen[Y+1][X+1][2],screen[Y+1][X+1][3])
  end
  PC=PC+1
 elseif opcode[1] == "PLOT" then
  --print(x,R,G,B,A)
  screen[Y+1][X+1]={R,G,B}
  drawmode = 1
  PC=PC+1
 elseif opcode[1] == "PONT" then
  points[tonumber(opcode[2])][1]=X
  points[tonumber(opcode[2])][2]=Y
  PC=PC+1
 elseif opcode[1] == "LINE" then
  --print(x,R,G,B,A)
  --print(points[1][1],points[1][2],points[2][1],points[2][2],"|",R,G,B)
  line(points[1][1],points[1][2],points[2][1],points[2][2],{R,G,B})
  drawmode = 1
  PC=PC+1
 elseif opcode[1] == "RECT" then
  --print(x,R,G,B,A)
  --print(points[1][1],points[1][2],points[2][1],points[2][2],"|",R,G,B)
  rectangle(points[1][1],points[1][2],points[2][1],points[2][2],{R,G,B})
  drawmode = 1
  PC=PC+1
 end
 t1=clock1()-t1
 if t1 > t1max then
  t1max=t1
  print("commands per ms="..tostring(t1max).."/commands per sec="..tostring(CPS))
 end
 if clock() - t2 <= 1 then
  CPS=CPS+1
  print("commands per ms="..tostring(t1max).."/commands per sec="..tostring(CPS))
 end
 --sleep(1)
end
frame = skipframe
function love.draw()
 if drawmode == 1 and frame < 1 then
  for renderX=0,resX do
   for renderY=0,resY do
    --print(renderY,renderX,screen[renderY+1][renderX+1][1],screen[renderY+1][renderX+1][2],screen[renderY+1][renderX+1][3])
    love.graphics.setColor(screen[renderY+1][renderX+1][1],screen[renderY+1][renderX+1][2],screen[renderY+1][renderX+1][3],255)
    love.graphics.rectangle('fill',renderX-1,renderY-1,1,1)
    --[[love.graphics.setColor(screenl1[renderY+1][renderX+1][1],screenl1[renderY+1][renderX+1][2],screenl1[renderY+1][renderX+1][3],screenl1[renderY+1][renderX+1][4])
    love.graphics.rectangle('fill',renderX-1,renderY-1,renderX-1,renderY-1)
    love.graphics.setColor(screenl2[renderY+1][renderX+1][1],screenl2[renderY+1][renderX+1][2],screenl2[renderY+1][renderX+1][3],screenl1[renderY+1][renderX+1][4])
    love.graphics.rectangle('fill',renderX-1,renderY-1,renderX-1,renderY-1)--]]
	drawmode = 0
	frame = skipframe
   end
  end
 end
 if frame > 0 then
  frame=frame-1
 end
end