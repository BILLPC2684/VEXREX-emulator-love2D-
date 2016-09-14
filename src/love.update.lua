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

