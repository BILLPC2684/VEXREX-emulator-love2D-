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
    if love.mouse.isGrabbed() then
     -- love.mouse.setPosition(mouseX,mouseY)
    end
   end
  end
 end
 if frame > 0 then
  if love.mouse.isGrabbed() then
   --mouseX,mouseY=love.mouse.getPosition()
  end
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
