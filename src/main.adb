with LSM303AGR;    use LSM303AGR;
with MicroBit.Console;
with MicroBit.Time;
with MicroBit.I2C; use MicroBit;
with HAL;          use HAL;
with HAL.I2C;      use HAL.I2C;
with Ada.Text_IO;  use Ada.Text_IO;

-- function To_Base16 (Number : in out Integer) return String is
--    Result : String  := "";
--    Index  : Integer := 0;
-- begin
--    while Number /= 0 loop
--       Result := Result & Integer'Image (Number rem 16) & " ";
--       Number := Number / 16;
--    end loop;

--    return Result;
-- end To_Base16;

procedure Main is
   Acc     : LSM303AGR.LSM303AGR_Accelerometer (MicroBit.I2C.Controller);
   AccData : I2C_Data (1 .. 6) := (others => 0);

begin
   if not MicroBit.I2C.Initialized then
      MicroBit.I2C.Initialize;
   end if;
   Acc.Configure (LSM303AGR.Freq_100);

   loop
      AccData := LSM303AGR.Read_Accelerometer (Acc);

      Console.Put (Integer'Image (Integer (AccData (2))));
      Console.Put ("," & Integer'Image (Integer (AccData (1))));

      Console.Put ("," & Integer'Image (Integer (AccData (4))));
      Console.Put ("," & Integer'Image (Integer (AccData (3))));

      Console.Put ("," & Integer'Image (Integer (AccData (6))));
      Console.Put ("," & Integer'Image (Integer (AccData (5))));

      Console.Put_Line ("");

      Time.Sleep (50);
   end loop;
end Main;
