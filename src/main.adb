with LSM303AGR;    use LSM303AGR;
with MicroBit.Console;
with MicroBit.Time;
with MicroBit.I2C; use MicroBit;
with MicroBit.Display;
with MicroBit.Display.Symbols;
with HAL;          use HAL;
with HAL.I2C;      use HAL.I2C;
with Ada.Text_IO;  use Ada.Text_IO;

procedure Main is
   Threshold : constant Integer := 10;
   type Abs_Axes_Value is range 0 .. 1_024;
   type Abs_Axes is record
      X : Abs_Axes_Value := 0;
      Y : Abs_Axes_Value := 0;
      Z : Abs_Axes_Value := 0;
   end record;

   function Absolute_Axes (Acc_Data : in All_Axes_Data) return Abs_Axes is
      Val : Abs_Axes := (X => 0, Y => 0, Z => 0);
   begin
      Val.X := Abs_Axes_Value (abs Acc_Data.X);
      Val.Y := Abs_Axes_Value (abs Acc_Data.Y);
      Val.Z := Abs_Axes_Value (abs Acc_Data.Z);
      return Val;
   end Absolute_Axes;

   function Below_Threshold (Axis_Info : Abs_Axes_Value) return Boolean is
   begin
      return Integer (Axis_Info) < Threshold;
   end Below_Threshold;

   Acc           : LSM303AGR.LSM303AGR_Accelerometer (MicroBit.I2C.Controller);
   Acc_Data      : All_Axes_Data := (X => 0, Y => 0, Z => 0);
   Good_Count    : Integer       := 0;
   Y_Good        : Boolean       := False;
   Abs_Axes_Data : Abs_Axes      := (X => 0, Y => 0, Z => 0);
begin
   if not MicroBit.I2C.Initialized then
      MicroBit.I2C.Initialize;
   end if;
   Acc.Configure (LSM303AGR.Freq_10);

   loop
      Acc_Data      := LSM303AGR.Read_Accelerometer (Acc);
      Abs_Axes_Data := Absolute_Axes (Acc_Data);
      Y_Good        := False;

      Console.Put (Integer'Image (Integer (Acc_Data.X)));
      Console.Put ("," & Integer'Image (Integer (Acc_Data.Y)));
      Console.Put ("," & Integer'Image (Integer (Acc_Data.Z)));
      Console.Put_Line ("");

      if Below_Threshold (Abs_Axes_Data.Y) then
         Y_Good := True;
      else
         Good_Count := 0;
         if Acc_Data.Y < 0 then
            Display.Clear;
            Display.Symbols.Up_Arrow;
         elsif Acc_Data.Y > 0 then
            Display.Clear;
            Display.Symbols.Down_Arrow;
         end if;
      end if;

      if Y_Good then
         if Below_Threshold (Abs_Axes_Data.X) then
            Good_Count := Good_Count + 1;
            if Good_Count > 50 then
               Console.Put_Line ("Great Job!");
               Display.Clear;
               Display.Symbols.Heart;
            elsif Good_Count >= 10 then
               Display.Clear;
               Display.Symbols.Smile;
            end if;
         else
            Good_Count := 0;
            if Acc_Data.X < 0 then
               Display.Clear;
               Display.Symbols.Left_Arrow;
            else
               Display.Clear;
               Display.Symbols.Right_Arrow;
            end if;
         end if;
      end if;

      Time.Sleep (50);
   end loop;
end Main;
