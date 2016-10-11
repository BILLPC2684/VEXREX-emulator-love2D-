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
 tempscreen={}
 for i=1,resY do
  temp={}
  for i=0,resX do
   table.insert(temp,{0,0,0,0})
  end
  table.insert(tempscreen,temp)
 end
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
 REGS={bytes(0),bytes(0),bytes(0),bytes(0),bytes(0),bytes(0),bytes(0),bytes(0),bytes(resX),bytes(resY)}
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

