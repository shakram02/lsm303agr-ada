------------------------------------------------------------------------------
--                                                                          --
--                       Copyright (C) 2019, AdaCore                        --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

with LSM303AGR;    use LSM303AGR;
with MicroBit.Console;
with MicroBit.Time;
with MicroBit.I2C; use MicroBit;

procedure Main is
   Acc          : LSM303AGR.LSM303AGR_Accelerometer (MicroBit.I2C.Controller);
   Check_Result : Boolean := False;
begin
   if not MicroBit.I2C.Initialized then
      MicroBit.I2C.Initialize;
   end if;
   
   loop
      Check_Result := LSM303AGR.Check_Accelerometer_Device_Id (Acc);
      Console.Put_Line
        ("Accelerometer CheckID:" & Boolean'Image (Check_Result));

      Check_Result := LSM303AGR.Check_Magnetometer_Device_Id (Acc);
      Console.Put_Line
        ("Magnetometer CheckID:" & Boolean'Image (Check_Result));

      Time.Sleep (3_000);
   end loop;
end Main;
