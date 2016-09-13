--"C:\Program Files\LOVE\love.exe" ./ <ROM> --console
--SYSTEM_RUN--
dofile("./love.run.lua")
t4=0
SaveDrive={}
skipframe=4
t1max,CPS=0,0
state = true
love.mouse.setGrabbed(state)
love.mouse.setVisible(not state)
---FUNCIONS---
clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end
scrolly,scrolly=0,0
function love.wheelmoved(x, y)
 if y > 0 then
  scrolly=1
 elseif y < 0 then
  scrolly=-1
 end
 if x > 0 then
  scrollx=1
 elseif x < 0 then
  scrollx=-1
 end
end
function love.keypressed(key)
 if key == "escape" then
  t4 = clock()
  local state = not love.mouse.isGrabbed()   -- the opposite of whatever it currently is
  love.mouse.setGrabbed(state) --Use love.mouse.setGrab(state) for 0.8.0 or lower
  love.mouse.setVisible(not state)
 --[[elseif key == "kp+" then
  skipframe=skipframe+1
  print(skipframe)
 elseif key == "kp-" then
  skipframe=skipframe-1
  print(skipframe)]]--
 else
  keyin = key
 end
end
function love.keyreleased(key)
 if key == "escape" then
  if clock() - t4 > 1 then
   error("POWERED OFF!!!")
  end
 end
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

dofile("./opcodes.lua")

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

dofile("./keys.lua")

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
function Split(str)
 local leng=#tostring(str)
 local out = {}
 --print(str)
 local i=0
 if str == "" then
  return ""
 else
  repeat
   i=i+1
   local num = string.byte(tostring(str),i)
   print(">",num,"<")
   --print(leng)
   table.insert(out,num)
  until i==leng
 end
 return out
end

function bytes(x)
    local b4=x%256  x=(x-x%256)/256
    local b3=x%256  x=(x-x%256)/256
    local b2=x%256  x=(x-x%256)/256
    local b1=x%256  x=(x-x%256)/256
    return string.char(b1,b2,b3,b4)
end

---------------
dofile("./love.load.lua")
t2 = clock()
directopcode = false
dofile("./love.update.lua")
dofile("./love.draw.lua")
