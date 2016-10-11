servers = {}
connections = {}
function love.update()
 t1 = clock()
 if directopcode then
  opcode=tempOperate
  directopcode = false
 else
  opcode=split(tostring(ROM[PC]),"	" or " ")
 end
 if arg[3] == "--logs" or arg[3] == "-l" then
  print("PC:"..tostring(PC),"opcode:",opcode[1],opcode[2],opcode[3],"\nPOS/COL:",X,Y,R,G,B,A,"\nPOINTS:",points[1][1],points[1][2],points[2][1],points[2][2])
  print("REGS:\n"..int(REGS[1]),"["..tostring(REGS[1][1])..","..tostring(REGS[1][2])..","..tostring(REGS[1][3])..","..tostring(REGS[1][4]).."]")
  print(int(REGS[2]),"["..tostring(REGS[2][1])..","..tostring(REGS[2][2])..","..tostring(REGS[2][3])..","..tostring(REGS[2][4]).."]")
  print(int(REGS[3]),"["..tostring(REGS[3][1])..","..tostring(REGS[3][2])..","..tostring(REGS[3][3])..","..tostring(REGS[3][4]).."]")
  print(int(REGS[4]),"["..tostring(REGS[4][1])..","..tostring(REGS[4][2])..","..tostring(REGS[4][3])..","..tostring(REGS[4][4]).."]")
  print(int(REGS[5]),"["..tostring(REGS[5][1])..","..tostring(REGS[5][2])..","..tostring(REGS[5][3])..","..tostring(REGS[5][4]).."]")
  print(int(REGS[6]),"["..tostring(REGS[6][1])..","..tostring(REGS[6][2])..","..tostring(REGS[6][3])..","..tostring(REGS[6][4]).."]")
  print(int(REGS[7]),"["..tostring(REGS[7][1])..","..tostring(REGS[7][2])..","..tostring(REGS[7][3])..","..tostring(REGS[7][4]).."]")
  print(int(REGS[8]),"["..tostring(REGS[8][1])..","..tostring(REGS[8][2])..","..tostring(REGS[8][3])..","..tostring(REGS[8][4]).."]")
  print("SCREEN:",REGS[9][1],REGS[9][2],REGS[9][3],REGS[9][4],REGS[10][1],REGS[10][2],REGS[10][3],REGS[10][4])
 end
 if opcode[1] == "LOAD" then
  REGS[def_REG(opcode[2])]=bytes(tonumber(opcode[3]))
  PC=PC+1
 elseif opcode[1] == "INKY" then
  if is_REG(opcode[3]) then
   if love.keyboard.isDown(def_key(REGS[def_REG(opcode[3])])) then
    REGS[def_REG(opcode[2])]=bytes(1)
   else
    REGS[def_REG(opcode[2])]=bytes(0)
   end
  else
   if love.keyboard.isDown(def_key(tonumber(opcode[3]))) then
    REGS[def_REG(opcode[2])]=bytes(1)
   else
    REGS[def_REG(opcode[2])]=bytes(0)
   end
  end
  PC=PC+1
 elseif opcode[1] == "CRLC" then
  local mouseX,mouseY=love.mouse.getPosition()
  REGS[def_REG(opcode[2])],REGS[def_REG(opcode[3])]=bytes(mouseX),bytes(mouseY)
  PC=PC+1
 elseif opcode[1] == "CLIK" then
  if is_REG(opcode[3]) then
   if love.mouse.isDown(REGS[def_REG(opcode[3])]) then
    REGS[def_REG(opcode[2])]=bytes(1)
   else
    REGS[def_REG(opcode[2])]=bytes(0)
   end
  else
   if love.mouse.isDown(tonumber(opcode[3])) then
    REGS[def_REG(opcode[2])]=bytes(1)
   else
    REGS[def_REG(opcode[2])]=bytes(0)
   end
  end
  PC=PC+1
 elseif opcode[1] == "CRPS" then
  if is_REG(opcode[2]) then
   love.mouse.setX(int(REGS[opcode[2]]))
  else
   love.mouse.setX(tonumber(opcode[2]))
  end
  if is_REG(opcode[3]) then
   love.mouse.setY(int(REGS[opcode[2]]))
  else
   love.mouse.setY(tonumber(opcode[3]))
  end
  PC=PC+1
 elseif opcode[1] == "SRWX" then
  REGS[def_REG(opcode[2])]=bytes(scrollx)
  PC=PC+1
 elseif opcode[1] == "SRWY" then
  REGS[def_REG(opcode[2])]=bytes(scrolly)
  PC=PC+1
 elseif opcode[1] == "MOV" then
  if is_REG(opcode[3]) then
   REGS[def_REG(opcode[2])]=REGS[def_REG(opcode[3])]
  end
  PC=PC+1
 elseif opcode[1] == "SELB" then
  tempREG = REGS[def_REG(opcode[2])]
  PC=PC+1
 elseif opcode[1] == "SP8A" then
  REGS[def_REG(opcode[2])],REGS[def_REG(opcode[3])]={tempREG[1],0,0,0},{0,tempREG[2],0,0}
  tempREG = {0,0,0,0}
  PC=PC+1
 elseif opcode[1] == "SP8B" then
  REGS[def_REG(opcode[2])],REGS[def_REG(opcode[3])]={tempREG[3],0,0,0},{0,tempREG[4],0,0}
  tempREG = {0,0,0,0}
  PC=PC+1
 elseif opcode[1] == "SP16" then
  REGS[def_REG(opcode[2])],REGS[def_REG(opcode[3])]={tempREG[1],tempREG[2],0,0},{tempREG[3],tempREG[4],0,0}
  tempREG = {0,0,0,0}
  PC=PC+1
 elseif opcode[1] == "REMB" then
  tempREG[tonumber(opcode[3])] = 0
  if tempREG[4] == 0 then
   if tempREG[3] == 0 then
    if tempREG[2] == 0 then
     if tempREG[1] ~= 0 then
      REGS[def_REG(opcode[2])]={0,0,0,0}
     end
    else
     REGS[def_REG(opcode[2])]={0,0,0,tempREG[4]}
    end
   else
    REGS[def_REG(opcode[2])]={0,0,tempREG[3],tempREG[4]}
   end
  else
   REGS[def_REG(opcode[2])]={0,tempREG[2],tempREG[3],tempREG[4]}
  end
  tempREG = {0,0,0,0}
  PC=PC+1
 elseif opcode[1] == "SETB" then
  REGS[def_REG(opcode[2])]={REGS[def_REG(opcode[2])][2],REGS[def_REG(opcode[2])][3],REGS[def_REG(opcode[2])][4],REGS[def_REG(opcode[3])][1]}
  tempREG = {0,0,0,0}
  PC=PC+1
 elseif opcode[1] == "AND" then
  if is_REG(opcode[3]) then
   REGS[def_REG(opcode[2])]=bytes(bit32.band(int(REGS[def_REG(opcode[2])])+int(REGS[def_REG(opcode[3])])))
  else
   REGS[def_REG(opcode[2])]=bytes(bit32.band(int(REGS[def_REG(opcode[2])])+tonumber(opcode[3])))
  end
  PC=PC+1
 elseif opcode[1] == "OR" then
  if is_REG(opcode[3]) then
   REGS[def_REG(opcode[2])]=bytes(bit32.bor(int(REGS[def_REG(opcode[2])])+int(REGS[def_REG(opcode[3])])))
  else
   REGS[def_REG(opcode[2])]=bytes(bit32.bor(int(REGS[def_REG(opcode[2])])+tonumber(opcode[3])))
  end
  PC=PC+1
 elseif opcode[1] == "XOR" then
  if is_REG(opcode[3]) then
   REGS[def_REG(opcode[2])]=bytes(bit32.bxor(int(REGS[def_REG(opcode[2])])+int(REGS[def_REG(opcode[3])])))
  else
   REGS[def_REG(opcode[2])]=bytes(bit32.bxor(int(REGS[def_REG(opcode[2])])+tonumber(opcode[3])))
  end
  PC=PC+1
 elseif opcode[1] == "NOT" or opcode[1] == "INV" then
  if is_REG(opcode[3]) then
   REGS[def_REG(opcode[2])]=bytes(bit32.bnot(int(REGS[def_REG(opcode[2])]),int(REGS[def_REG(opcode[3])])))
  else
   REGS[def_REG(opcode[2])]=bytes(bit32.bnot(int(REGS[def_REG(opcode[2])]),tonumber(opcode[3])))
  end
  PC=PC+1
 elseif opcode[1] == "ADD" then
  if is_REG(opcode[3]) then
   REGS[def_REG(opcode[2])]=bytes(int(REGS[def_REG(opcode[2])])+int(REGS[def_REG(opcode[3])]))
  else
   REGS[def_REG(opcode[2])]=bytes(int(REGS[def_REG(opcode[2])])+tonumber(opcode[3]))
  end
  PC=PC+1
 elseif opcode[1] == "SUB" then
  if is_REG(opcode[3]) then
   REGS[def_REG(opcode[2])]=bytes(int(REGS[def_REG(opcode[2])])-int(REGS[def_REG(opcode[3])]))
  else
   REGS[def_REG(opcode[2])]=bytes(int(REGS[def_REG(opcode[2])])-tonumber(opcode[3]))
  end
  PC=PC+1
 elseif opcode[1] == "DIV" then
  if is_REG(opcode[3]) then
   REGS[def_REG(opcode[2])]=bytes(int(REGS[def_REG(opcode[2])])/int(REGS[def_REG(opcode[3])]))
  else
   REGS[def_REG(opcode[2])]=bytes(int(REGS[def_REG(opcode[2])])/tonumber(opcode[3]))
  end
  PC=PC+1
 elseif opcode[1] == "MUL" then
  if is_REG(opcode[3]) then
   REGS[def_REG(opcode[2])]=bytes(int(REGS[def_REG(opcode[2])])*int(REGS[def_REG(opcode[3])]))
  else
   REGS[def_REG(opcode[2])]=bytes(int(REGS[def_REG(opcode[2])])*tonumber(opcode[3]))
  end
  PC=PC+1
 elseif opcode[1] == "PRNT" then
  if is_REG(opcode[2]) then
   print(int(REGS[def_REG(opcode[2])]),"["..tostring(REGS[def_REG(opcode[2])][1]),REGS[def_REG(opcode[2])][2],REGS[def_REG(opcode[2])][3],tostring(REGS[def_REG(opcode[2])][4]).."]")
  end
  PC=PC+1
 elseif opcode[1] == "JMP" then
  if is_REG(opcode[2]) then
   PC=int(REGS[def_REG(opcode[2])])
  else
   PC=tonumber(opcode[2])
  end
 elseif opcode[1] == "IF" then
  if int(REGS[def_REG("F")]) == tonumber(opcode[2]) then
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
 elseif opcode[1] == "RMSZ" then
  REGS[def_REG(opcode[2])]=bytes(#RAM)
  PC=PC+1
 elseif opcode[1] == "WRAM" then
  if is_REG(opcode[2]) then
   if is_REG(opcode[3]) then
    i = REGS[def_REG(opcode[3])]
    print(i,#i)
    for j=1,#i do
     RAM[int(REGS[opcode[2]])+(j-1)] = i[j]
    end
   else
    if int(REGS[opcode[2]]) < 256 then
     RAM[int(REGS[opcode[2]])] = tonumber(opcode[3])
    end
   end
  else
   if is_REG(opcode[3]) then
    i = int(REGS[def_REG(opcode[3])])
    for j=1,#i do
     RAM[tonumber(opcode[2])+(j-1)] = i[j]
    end
   else
    if tonumber(opcode[3]) < 256 then
     RAM[tonumber(opcode[2])] = tonumber(opcode[3])
    end
   end
  end
  PC=PC+1
 elseif opcode[1] == "RRAM" then
  if is_REG(opcode[2]) then
   REGS[def_REG(opcode[2])]=bytes(RAM[REGS[def_REG(opcode[3])]])
  else
   REGS[def_REG(opcode[3])]=bytes(RAM[tonumber(opcode[2])])
  end
  PC=PC+1
 elseif opcode[1] == "CMP" then
  if is_REG(opcode[3]) then
--   if int(REGS[def_REG(opcode[2])]) == 0 and int(REGS[def_REG(opcode[3])]) == 0 then
--    REGS[def_REG("F")]=bytes(0)
   --elseif
   if int(REGS[def_REG(opcode[2])])<int(REGS[def_REG(opcode[3])]) then
    REGS[def_REG("F")]=bytes(1)
   elseif int(REGS[def_REG(opcode[2])])==int(REGS[def_REG(opcode[3])]) then
    REGS[def_REG("F")]=bytes(2)
   elseif int(REGS[def_REG(opcode[2])])>int(REGS[def_REG(opcode[3])]) then
    REGS[def_REG("F")]=bytes(3)
   end
  else
--   if int(REGS[def_REG(opcode[2])]) == 0 and tonumber(opcode[3]) == 0 then
--    REGS[def_REG("F")]=bytes(0)
--   elseif
   if int(REGS[def_REG(opcode[2])])<tonumber(opcode[3]) then
    REGS[def_REG("F")]=bytes(1)
   elseif int(REGS[def_REG(opcode[2])])==tonumber(opcode[3]) then
    REGS[def_REG("F")]=bytes(2)
   elseif int(REGS[def_REG(opcode[2])])>tonumber(opcode[3]) then
    REGS[def_REG("F")]=bytes(3)
   end
  end
  PC=PC+1
 elseif opcode[1] == "RNG" then
  REGS[def_REG(opcode[2])]=bytes(math.random(int(REGS[def_REG(opcode[2])]),int(REGS[def_REG(opcode[3])])))
  PC=PC+1
 --[[elseif opcode[1] == "WAIT" then
  if is_REG(opcode[2]) then
   sleep(REGS[def_REG(opcode[2])])
  else
   sleep(tonumber(opcode[2]))
  end
  PC=PC+1]]--
 elseif opcode[1] == "RCOL" then
  if is_REG(opcode[2]) then
   R=int(REGS[def_REG(opcode[2])])
  else
   R=tonumber(opcode[2])
  end
  PC=PC+1
 elseif opcode[1] == "GCOL" then
  if is_REG(opcode[2]) then
   G=int(REGS[def_REG(opcode[2])])
  else
   G=tonumber(opcode[2])
  end
  PC=PC+1
 elseif opcode[1] == "BCOL" then
  if is_REG(opcode[2]) then
   B=int(REGS[def_REG(opcode[2])])
  else
   B=tonumber(opcode[2])
  end
  PC=PC+1
 elseif opcode[1] == "ACOL" then
  if is_REG(opcode[2]) then
   A=int(REGS[def_REG(opcode[2])])
  else
   A=tonumber(opcode[2])
  end
  PC=PC+1
 elseif opcode[1] == "XPOS" then
  if is_REG(opcode[2]) then
   X=int(REGS[def_REG(opcode[2])])
  else
   X=tonumber(opcode[2])
  end
  PC=PC+1
 elseif opcode[1] == "YPOS" then
  if is_REG(opcode[2]) then
   Y=int(REGS[def_REG(opcode[2])])
  else
   Y=tonumber(opcode[2])
  end
  PC=PC+1
 elseif opcode[1] == "REAR" then
  if is_REG(opcode[2]) then
   REGS[def_REG(opcode[2])]=bytes(tempscreen[Y+1][X+1][1])
   --print(screen[Y+1][X+1][1],screen[Y+1][X+1][2],screen[Y+1][X+1][3])
  end
  PC=PC+1
 elseif opcode[1] == "REAG" then
  if is_REG(opcode[2]) then
   REGS[def_REG(opcode[2])]=bytes(tempscreen[Y+1][X+1][2])
   --print(screen[Y+1][X+1][1],screen[Y+1][X+1][2],screen[Y+1][X+1][3])
  end
  PC=PC+1
 elseif opcode[1] == "REAB" then
  if is_REG(opcode[2]) then
   REGS[def_REG(opcode[2])]=bytes(tempscreen[Y+1][X+1][3])
   --print(screen[Y+1][X+1][1],screen[Y+1][X+1][2],screen[Y+1][X+1][3])
  end
  PC=PC+1
 elseif opcode[1] == "PLOT" then
  if X>=0 and X<=resX-1 and Y>=0 and Y<=resY-1 then
   tempscreen[Y+1][X+1]={R,G,B}
  end
  PC=PC+1
 elseif opcode[1] == "REND" then
  screen = tempscreen
  drawmode = 1
  PC=PC+1
 elseif opcode[1] == "PONT" then
  points[tonumber(opcode[2])+1][1]=X
  points[tonumber(opcode[2])+1][2]=Y
  PC=PC+1
 elseif opcode[1] == "LINE" then
  --print(x,R,G,B,A)
  --print(points[1][1],points[1][2],points[2][1],points[2][2],"|",R,G,B)
  line(points[1][1],points[1][2],points[2][1],points[2][2],{R,G,B})
  PC=PC+1
 elseif opcode[1] == "RECT" then
  --print(x,R,G,B,A)
  --print(points[1][1],points[1][2],points[2][1],points[2][2],"|",R,G,B)
  rectangle(points[1][1],points[1][2],points[2][1],points[2][2],{R,G,B})
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
     i = REGS[def_REG(opcode[3])]
     print(#i)
     for j=1,#i do
      print(j,i[j],#i)
      SaveDrive[tonumber(int(REGS[def_REG(opcode[2])]))+(j)] = i[j]
     end
   else
    if tonumber(REGS[opcode[2]]) < 256 then
     SaveDrive[tonumber(REGS[opcode[2]])] = tonumber(opcode[3])
    end
   end
  else
   if is_REG(opcode[3]) then
    i = REGS[def_REG(opcode[3])]
    print(#i)
    for j=1,#i do
     print(j,i[j],#i)
     SaveDrive[tonumber(opcode[2])+(j)] = i[j]
    end
   else
    if tonumber(opcode[3]) < 256 then
     SaveDrive[tonumber(opcode[2])] = tonumber(opcode[3])
    end
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
    --print(SaveDrive[REGS[def_REG(opcode[2])]+1],REGS[def_REG(opcode[2])]+1)
	REGS[def_REG(opcode[3])]=bytes(SaveDrive[int(REGS[def_REG(opcode[2])])+1])
   else
    --print(SaveDrive[tonumber(opcode[2])+1],tonumber(opcode[2])+1,bytes(tonumber(opcode[2])+1)
    REGS[def_REG(opcode[3])]=bytes(SaveDrive[tonumber(opcode[2])+1])
   end
   --file:close()
   PC=PC+1
  else
   error("no drive...")
  end
 elseif opcode[1] == "REXE" then
  tempOperate={RAM[REGS[def_REG(opcode[2])]],RAM[REGS[def_REG(opcode[2])]+1],RAM[REGS[def_REG(opcode[2])]+2]}
  tempOperate={RAM[tonumber(opcode[2])],RAM[tonumber(opcode[2])+1],RAM[tonumber(opcode[2])+2]}
  PC=PC+1
 elseif opcode[1] == "DEXE" then
  tempOperate={SaveDrive[REGS[def_REG(opcode[2])]+1],SaveDrive[REGS[def_REG(opcode[2])]+2],SaveDrive[REGS[def_REG(opcode[2])]+3]}
  tempOperate={SaveDrive[tonumber(opcode[2])+1],SaveDrive[tonumber(opcode[2])+2],SaveDrive[tonumber(opcode[2])+3]}
  PC=PC+1
 elseif opcode[1] == "BIND" then
  table.insert(servers,assert(socket.bind(tostring(REGS[def_REG(opcode[2])][1]).."."..tostring(REGS[def_REG(opcode[2])][2]).."."..tostring(REGS[def_REG(opcode[2])][3]).."."..tostring(REGS[def_REG(opcode[2])][4]),tonumber(REGS[def_REG(opcode[3])]))))
  --local ip, port = server:getsockname()
  PC=PC+1
 elseif opcode[1] == "ACPT" then
  table.insert(connections,servers[tonumber(REGS[def_REG(opcode[2])])]:accept())
  PC=PC+1
 elseif opcode[1] == "CNNT" then
  table.insert(connections,assert(socket.connect(tostring(REGS[def_REG(opcode[2])][1]).."."..tostring(REGS[def_REG(opcode[2])][2]).."."..tostring(REGS[def_REG(opcode[2])][3]).."."..tostring(REGS[def_REG(opcode[2])][4]),tonumber(REGS[def_REG(opcode[3])]))))
  PC=PC+1
 elseif opcode[1] == "TOUT" then
  c:settimeout(tonumber(REGS[def_REG(opcode[2])]))
  PC=PC+1
 elseif opcode[1] == "SEND" then
  if is_REG(opcode[2]) then
   if is_REG(opcode[3]) then
    send(connections[int(REGS[def_REG(opcode[2])])],int(REGS[def_REG(opcode[3])]))
   else
    send(connections[int(REGS[def_REG(opcode[2])])],opcode[2])
   end
  else
   if is_REG(opcode[3]) then
    send(connections[tonumber(opcode[2])],REGS[def_REG(opcode[3])])
   else
    send(connections[tonumber(opcode[2])],opcode[2])
   end
  end
  PC=PC+1
 elseif opcode[1] == "RECV" then
  REGS[def_REG(opcode[3])]=bytes(tonumber(receive(connections[tonumber(opcode[2])])))
  PC=PC+1
 elseif opcode[1] == "CLSK" then
  close_socket(connections[tonumber(opcode[2])])
  PC=PC+1
 end
 t1=clock()-t1
 if arg[3] == "--cps" or arg[3] == "-c" then
  if t1 > t1max then
   t1max=t1
   print("hertz="..tostring(t1max).."/commands per sec="..tostring(CPS))
  end
  if clock() - t2 <= 1 then
   CPS=CPS+1
   print("hertz="..tostring(t1max).."/commands per sec="..tostring(CPS))
  end
 end
-- sleep(1)
 scrolly,scrolly=0,0
end
