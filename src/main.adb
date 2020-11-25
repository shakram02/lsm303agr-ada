with LSM303AGR;    use LSM303AGR;
with MicroBit.Console;
with MicroBit.Time;
with MicroBit.I2C; use MicroBit;
with HAL;          use HAL;
with HAL.I2C;      use HAL.I2C;
with Ada.Text_IO;  use Ada.Text_IO;

procedure Main is
   Acc     : LSM303AGR.LSM303AGR_Accelerometer (MicroBit.I2C.Controller);
   AccData : All_Axes_Data := (X => 0, Y => 0, Z => 0);
begin
   if not MicroBit.I2C.Initialized then
      MicroBit.I2C.Initialize;
   end if;
   Acc.Configure (LSM303AGR.Freq_100);

   loop
      AccData := LSM303AGR.Read_Accelerometer (Acc);

      Console.Put (Integer'Image (Integer (AccData.X)));
      Console.Put ("," & Integer'Image (Integer (AccData.Y)));
      Console.Put ("," & Integer'Image (Integer (AccData.Z)));

      Console.Put_Line ("");
      Time.Sleep (25);
   end loop;
end Main;
