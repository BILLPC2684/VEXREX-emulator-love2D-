--"C:\Program Files\LOVE\love.exe" ./ <ROM> --console
--SYSTEM_RUN--
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

		if love.graphics then
			love.graphics.origin()
			if love.draw then love.draw() end
			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end

end
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

function Def_Opcode(OPCODE,DATA0,DATA1)
 local opcode={OPCODE,DATA0,DATA1}
 if opcode[1] == 0x00 then
  return "LOAD"
 elseif opcode[1] == 0x01 then
  return "INKY"
 elseif opcode[1] == 0x02 then
  return "CRLC"
 elseif opcode[1] == 0x03 then
  return "CLIK"
 elseif opcode[1] == 0x04 then
  return "CRPS"
 elseif opcode[1] == 0x05 then
  return "SRWX"
 elseif opcode[1] == 0x06 then
  return "SRWY"
 elseif opcode[1] == 0x07 then
  return "MOV"
 elseif opcode[1] == 0x08 then
  return "ADD"
 elseif opcode[1] == 0x09 then
  return "SUB"
 elseif opcode[1] == 0x0A then
  return "DIV"
 elseif opcode[1] == 0x0B then
  return "PRNT"
 elseif opcode[1] == 0x0C then
  return "HALT"
 elseif opcode[1] == 0x0D then
  return "WRAM"
 elseif opcode[1] == 0x0E then
  return "RRAM"
 elseif opcode[1] == 0x0F then
  return "DETC"
 elseif opcode[1] == 0x10 then
  return "RNG"
 elseif opcode[1] == 0x11 then
  return "WAIT"
 elseif opcode[1] == 0x12 then
  return "RCOL"
 elseif opcode[1] == 0x13 then
  return "GCOL"
 elseif opcode[1] == 0x14 then
  return "BCOL"
 elseif opcode[1] == 0x15 then
  return "ACOL"
 elseif opcode[1] == 0x16 then
  return "XPOS"
 elseif opcode[1] == 0x17 then
  return "YPOS"
 elseif opcode[1] == 0x18 then
  return "REAR"
 elseif opcode[1] == 0x19 then
  return "REAG"
 elseif opcode[1] == 0x1A then
  return "REAB"
 elseif opcode[1] == 0x1B then
  return "PLOT"
 elseif opcode[1] == 0x1C then
  return "PONT"
 elseif opcode[1] == 0x1D then
  return "LINE"
 elseif opcode[1] == 0x1E then
  return "RECT"
 elseif opcode[1] == 0x1F then
  return "WSAV"
 elseif opcode[1] == 0x20 then
  return "RSAV"
 elseif opcode[1] == 0x21 then
  return "REXE"
 elseif opcode[1] == 0x22 then
  return "DEXE"
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

function def_key(key)
 if key == 0 then
  return "a"
 elseif key == 1 then
  return "b"
 elseif key == 2 then
  return "c"
 elseif key == 3 then
  return "d"
 elseif key == 4 then
  return "e"
 elseif key == 5 then
  return "f"
 elseif key == 6 then
  return "g"
 elseif key == 7 then
  return "h"
 elseif key == 8 then
  return "i"
 elseif key == 9 then
  return "j"
 elseif key == 10 then
  return "k"
 elseif key == 11 then
  return "l"
 elseif key == 12 then
  return "m"
 elseif key == 13 then
  return "n"
 elseif key == 14 then
  return "o"
 elseif key == 15 then
  return "p"
 elseif key == 16 then
  return "q"
 elseif key == 17 then
  return "r"
 elseif key == 18 then
  return "s"
 elseif key == 19 then
  return "t"
 elseif key == 20 then
  return "u"
 elseif key == 21 then
  return "v"
 elseif key == 22 then
  return "w"
 elseif key == 23 then
  return "x"
 elseif key == 24 then
  return "y"
 elseif key == 25 then
  return "z"
 elseif key == 26 then
  return "0"
 elseif key == 27 then
  return "1"
 elseif key == 28 then
  return "2"
 elseif key == 29 then
  return "3"
 elseif key == 30 then
  return "4"
 elseif key == 31 then
  return "5"
 elseif key == 32 then
  return "6"
 elseif key == 33 then
  return "7"
 elseif key == 34 then
  return "8"
 elseif key == 35 then
  return "9"
 elseif key == 36 then
  return (" " or "space")
 elseif key == 37 then
  return "!"
 elseif key == 38 then
  return '"'
 elseif key == 39 then
  return "#"
 elseif key == 40 then
  return "$"
 elseif key == 41 then
  return "&"
 elseif key == 42 then
  return "'"
 elseif key == 43 then
  return "("
 elseif key == 44 then
  return ")"
 elseif key == 45 then
  return "*"
 elseif key == 46 then
  return "+"
 elseif key == 47 then
  return ","
 elseif key == 48 then
  return "-"
 elseif key == 49 then
  return "."
 elseif key == 50 then
  return "/"
 elseif key == 51 then
  return ":"
 elseif key == 52 then
  return ";"
 elseif key == 53 then
  return "<"
 elseif key == 54 then
  return "="
 elseif key == 55 then
  return ">"
 elseif key == 56 then
  return "?"
 elseif key == 57 then
  return "@"
 elseif key == 58 then
  return "["
 elseif key == 59 then
  return "\\"
 elseif key == 60 then
  return "]"
 elseif key == 61 then
  return "^"
 elseif key == 62 then
  return "_"
 elseif key == 63 then
  return "`"
 elseif key == 64 then
  return "kp0"
 elseif key == 65 then
  return "kp1"
 elseif key == 66 then
  return "kp2"
 elseif key == 67 then
  return "kp3"
 elseif key == 68 then
  return "kp4"
 elseif key == 69 then
  return "kp5"
 elseif key == 70 then
  return "kp6"
 elseif key == 71 then
  return "kp7"
 elseif key == 72 then
  return "kp8"
 elseif key == 73 then
  return "kp9"
 elseif key == 74 then
  return "kp."
 elseif key == 75 then
  return "kp,"
 elseif key == 76 then
  return "kp/"
 elseif key == 77 then
  return "kp*"
 elseif key == 78 then
  return "kp-"
 elseif key == 79 then
  return "kp+"
 elseif key == 80 then
  return "kpenter"
 elseif key == 81 then
  return "kp="
 elseif key == 82 then
  return "up"
 elseif key == 83 then
  return "down"
 elseif key == 84 then
  return "right"
 elseif key == 85 then
  return "left"
 elseif key == 86 then
  return "home"
 elseif key == 87 then
  return "end"
 elseif key == 88 then
  return "pageup"
 elseif key == 89 then
  return "pagedown"
 elseif key == 90 then
  return "insert"
 elseif key == 91 then
  return "backspace"
 elseif key == 92 then
  return "tab"
 elseif key == 93 then
  return "clear"
 elseif key == 94 then
  return "return"
 elseif key == 95 then
  return "delete"
 elseif key == 96 then
  return "f1"
 elseif key == 97 then
  return "f2"
 elseif key == 98 then
  return "f3"
 elseif key == 99 then
  return "f4"
 elseif key == 100 then
  return "f5"
 elseif key == 101 then
  return "f6"
 elseif key == 102 then
  return "f7"
 elseif key == 103 then
  return "f8"
 elseif key == 104 then
  return "f9"
 elseif key == 105 then
  return "f10"
 elseif key == 106 then
  return "f11"
 elseif key == 107 then
  return "f12"
 elseif key == 108 then
  return "f13"
 elseif key == 109 then
  return "f14"
 elseif key == 110 then
  return "f15"
 elseif key == 111 then
  return "f16"
 elseif key == 112 then
  return "f17"
 elseif key == 113 then
  return "f18"
 elseif key == 114 then
  return "numlock"
 elseif key == 115 then
  return "capslock"
 elseif key == 116 then
  return "scrolllock"
 elseif key == 117 then
  return "rshift"
 elseif key == 118 then
  return "lshift"
 elseif key == 119 then
  return "rctrl"
 elseif key == 120 then
  return "lctrl"
 elseif key == 121 then
  return "ralt"
 elseif key == 122 then
  return "lalt"
 elseif key == 123 then
  return "rgui"
 elseif key == 124 then
  return "lgui"
 elseif key == 125 then
  return "mode"
 elseif key == 126 then
  return "www"
 elseif key == 127 then
  return "mail"
 elseif key == 128 then
  return "calculator"
 elseif key == 129 then
  return "computer"
 elseif key == 130 then
  return "appsearch"
 elseif key == 131 then
  return "apphome"
 elseif key == 132 then
  return "appback"
 elseif key == 133 then
  return "appforward"
 elseif key == 134 then
  return "apprefresh"
 elseif key == 135 then
  return "appbookmarks"
 elseif key == 136 then
  return "pause"
 elseif key == 137 then
  return "escape"
 elseif key == 138 then
  return "printscreen"
 elseif key == 139 then
  return "sysreq"
 elseif key == 140 then
  return "menu"
 elseif key == 141 then
  return "application"
 elseif key == 142 then
  return "power"
 elseif key == 143 then
  return "currencyunit"
 elseif key == 144 then
  return "undo"
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
function love.load()
 drivename = ""
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
 --print(h,w)
 REGS={0,0,0,0,0,0,0,0,resX,resY}
 R=0x00
 G=0x00
 B=0x00
 A=0xFF
 X=0x00
 Y=0x00
 RAM={}
 points={{0,0},{0,0}}
 for i=0,1023 do
  table.insert(RAM,#RAM+1,0)
 end
 --print(#RAM)
 drawmode = 1
 ResetAutoSaveDrive = 500
 autoSaveDrive=tonumber(ResetAutoSaveDrive)
 frame = skipframe
 SaveDrive={}
 skipframe=4
 --print(drivename,fileLangth)
 if drivename ~= "" then
  print("reading...")
  DriveLoad = assert(io.open(drivename, "rb"))
  for i=1,DriveLoad:seek("end") do
   DriveLoad:seek("set",i-1)
   SaveDrive[i]=string.byte(DriveLoad:read(1))
   print(i-1,SaveDrive[i],string.byte(SaveDrive[i]))
  end
  print("DONE...")
 end
end
t2 = clock()
directopcode = false
function love.update()
 t1 = clock()
 if directopcode then
  opcode=tempOperate
  directopcode = false
 else
  opcode=split(tostring(ROM[PC]),"	" or " ")
 end
 if arg[3] == "--logs" or arg[3] == "-l" then
  print("PC:"..tostring(PC),"opcode:",opcode[1],opcode[2],opcode[3],"REGS:",REGS[1],REGS[2],REGS[3],REGS[4],REGS[5],REGS[6],REGS[7],REGS[8],"\nSCREEN:",REGS[9],REGS[10],"POS/COL:",X,Y,R,G,B,A,"\nPOINTS:",points[1][1],points[1][2],points[2][1],points[2][2])
 end
 if opcode[1] == "LOAD" then
  REGS[def_REG(opcode[2])]=tonumber(opcode[3])
  PC=PC+1
 elseif opcode[1] == "INKY" then
  if is_REG(opcode[3]) then
   if love.keyboard.isDown(def_key(REGS[def_REG(opcode[3])])) then
    REGS[def_REG(opcode[2])]=1
   else
    REGS[def_REG(opcode[2])]=0
   end
  else
   if love.keyboard.isDown(def_key(tonumber(opcode[3]))) then
    REGS[def_REG(opcode[2])]=1
   else
    REGS[def_REG(opcode[2])]=0
   end
  end
  PC=PC+1
 elseif opcode[1] == "CRLC" then
  REGS[def_REG(opcode[2])],REGS[def_REG(opcode[3])]=love.mouse.getPosition()
  PC=PC+1
 elseif opcode[1] == "CLIK" then
  if is_REG(opcode[3]) then
   if love.mouse.isDown(REGS[def_REG(opcode[3])]) then
    REGS[def_REG(opcode[2])]=1
   else
    REGS[def_REG(opcode[2])]=0
   end
  else
   if love.mouse.isDown(tonumber(opcode[3])) then
    REGS[def_REG(opcode[2])]=1
   else
    REGS[def_REG(opcode[2])]=0
   end
  end
  PC=PC+1
 elseif opcode[1] == "CRPS" then
  if is_REG(opcode[2]) then
   love.mouse.setX(opcode[2])
  else
   love.mouse.setX(tonumber(opcode[2]))
  end
  if is_REG(opcode[3]) then
   love.mouse.setY(opcode[3])
  else
   love.mouse.setY(tonumber(opcode[3]))
  end
  PC=PC+1
 elseif opcode[1] == "SRWX" then
  REGS[def_REG(opcode[2])]=scrollx
  PC=PC+1
 elseif opcode[1] == "SRWY" then
  REGS[def_REG(opcode[2])]=scrolly
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
  if drivename ~= "" then
   print("writting...")
   local DriveLoad = assert(io.open(drivename, "wb"))
   for i=1,#SaveDrive do
    print(i,SaveDrive[i],string.byte(SaveDrive[i]))
    DriveLoad:seek("set",i-1)
    DriveLoad:write(string.char(SaveDrive[i]))
   end
   DriveLoad:close()
   print("DONE...")
  end
  error("CPU HALTED!!!")
 elseif opcode[1] == "WRAM" then
  if is_REG(opcode[2]) then
   RAM[REGS[def_REG(opcode[2])]]=REGS[def_REG(opcode[3])]
  else
   RAM[tonumber(opcode[2])]=REGS[def_REG(opcode[3])]
  end
  PC=PC+1
 elseif opcode[1] == "RRAM" then
  if is_REG(opcode[2]) then
   REGS[def_REG(opcode[2])]=RAM[REGS[def_REG(opcode[3])]]
  else
  REGS[def_REG(opcode[3])]=RAM[tonumber(opcode[2])]
  end
  PC=PC+1
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
  if X>=0 and X<=resX+1 and Y>=0 and Y<=resY+1 then
   screen[Y+1][X+1]={R,G,B}
  end
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
 elseif opcode[1] == "WSAV" then
  if drivename ~= nil then
   local file = io.open(drivename, "rb")
   data = {}
   if file:read() == "" then
    for i=1,fileLangth do
	 --print(i,0)
	 table.insert(SaveDrive,0)
	end
   end
   file:close()
   if is_REG(opcode[2]) then
    if is_REG(opcode[3]) then
     SaveDrive[REGS[def_REG(opcode[2])]] = REGS[def_REG(opcode[3])]
    else
     SaveDrive[REGS[def_REG(opcode[2])]] = tonumber(opcode[3])
    end
   else
    if is_REG(opcode[3]) then
     SaveDrive[tonumber(opcode[2])] = REGS[def_REG(opcode[3])]
    else
     SaveDrive[tonumber(opcode[2])] = tonumber(opcode[3])
    end
   end
   PC=PC+1
  else
   error("no drive...")
  end
 elseif opcode[1] == "RSAV" then
  if drivename ~= nil then
   --io.open(drivename, "rb"):read()
   if is_REG(opcode[2]) then
    print(SaveDrive[REGS[def_REG(opcode[2])]+1],REGS[def_REG(opcode[2])]+1)
	REGS[def_REG(opcode[3])]=SaveDrive[REGS[def_REG(opcode[2])]+1]
   else
    print(SaveDrive[tonumber(opcode[2])+1],tonumber(opcode[2])+1)
    REGS[def_REG(opcode[3])]=SaveDrive[tonumber(opcode[2])+1]
   end
   --file:close()
   PC=PC+1
  else
   error("no drive...")
  end
 elseif opcode[1] == "REXE" then
  tempOperate={RAM[REGS[def_REG(opcode[2])]],RAM[REGS[def_REG(opcode[2])]+1],RAM[REGS[def_REG(opcode[2])]+2]}
  tempOperate={RAM[tonumber(opcode[2])],RAM[tonumber(opcode[2])+1],RAM[tonumber(opcode[2])+2]}
 elseif opcode[1] == "DEXE" then
  tempOperate={SaveDrive[REGS[def_REG(opcode[2])]+1],SaveDrive[REGS[def_REG(opcode[2])]+2],SaveDrive[REGS[def_REG(opcode[2])]+3]}
  tempOperate={SaveDrive[tonumber(opcode[2])+1],SaveDrive[tonumber(opcode[2])+2],SaveDrive[tonumber(opcode[2])+3]}
 end
 t1=clock()-t1
 --[[if t1 > t1max then
  t1max=t1
  print("hertz="..tostring(t1max).."/commands per sec="..tostring(CPS))
 end
 if clock() - t2 <= 1 then
  CPS=CPS+1
  print("hertz="..tostring(t1max).."/commands per sec="..tostring(CPS))
 end]]--
 --sleep(1)
 scrolly,scrolly=0,0
end
function love.draw()
 if drawmode == 1 and frame < 1 then
  for renderX=1,resX do
   for renderY=1,resY do
    --print(renderY,renderX,screen[renderY+1][renderX+1][1],screen[renderY+1][renderX+1][2],screen[renderY+1][renderX+1][3])
    love.graphics.setColor(screen[renderY][renderX][1],screen[renderY][renderX][2],screen[renderY][renderX][3],255)
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
 if autoSaveDrive > 0 then
  autoSaveDrive=autoSaveDrive-1
 else
  if drivename ~= "" then
   print("writting...")
   DriveLoad = assert(io.open(drivename, "wb"))
   for i=1,#SaveDrive do
    --print(i,SaveDrive[i],string.byte(SaveDrive[i]))
    DriveLoad:seek("set",i-1)
    DriveLoad:write(string.char(SaveDrive[i]))
   end
   print("reading...")
   DriveLoad = assert(io.open(drivename, "rb"))
   for i=1,DriveLoad:seek("end") do
    DriveLoad:seek("set",i-1)
    SaveDrive[i]=string.byte(DriveLoad:read(1))
    --print(i,SaveDrive[i+1],string.byte(SaveDrive[i+1]))
   end
   print("DONE...")
   autoSaveDrive = ResetAutoSaveDrive
  end
 end
end
