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

