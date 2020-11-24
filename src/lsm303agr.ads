with HAL;     use HAL;
with HAL.I2C; use HAL.I2C;

private with Ada.Unchecked_Conversion;

package LSM303AGR is
  type Register_Address is new UInt8;
  type Device_Identifier is new UInt8;
  type Data_Rate is
   (PowerDown, Freq_1, Freq_10, Freq_25, Freq_50, Freq_100, Freq_200, Freq_400,
    Low_Power, Hi_Res_1k6_Low_power_5k3);

  type LSM303AGR_Accelerometer (Port : not null Any_I2C_Port) is
   tagged limited private;
  -- procedure Write_Register
  --   (This : LSM303AGR_Accelerometer'Class; Addr : Register_Address;
  --    Val  : UInt8);

  function Check_Accelerometer_Device_Id
   (This : LSM303AGR_Accelerometer) return Boolean;

  function Check_Magnetometer_Device_Id
   (This : LSM303AGR_Accelerometer) return Boolean;

  procedure Configure (This : LSM303AGR_Accelerometer; Date_Rate : Data_Rate);

private

  type LSM303AGR_Accelerometer (Port : not null Any_I2C_Port)
  is tagged limited null record;

  for Data_Rate use
   (PowerDown => 0, Freq_1 => 1, Freq_10 => 2, Freq_25 => 3, Freq_50 => 4,
    Freq_100 => 5, Freq_200 => 6, Freq_400 => 7, Low_Power => 8,
    Hi_Res_1k6_Low_power_5k3 => 9);

  Accelerometer_Address   : constant I2C_Address       := 16#32#;
  Accelerometer_Device_Id : constant Device_Identifier := 2#0011_0011#;

  Magnetometer_Address   : constant I2C_Address       := 16#3C#;
  Magnetometer_Device_Id : constant Device_Identifier := 2#0100_0000#;

  WHO_AM_I_A : constant Register_Address := 16#0F#;
  OUT_X_L_A  : constant Register_Address := 16#28#;
  OUT_X_H_A  : constant Register_Address := 16#29#;
  OUT_Y_L_A  : constant Register_Address := 16#2A#;
  OUT_Y_H_A  : constant Register_Address := 16#2B#;
  OUT_Z_L_A  : constant Register_Address := 16#2C#;
  OUT_Z_H_A  : constant Register_Address := 16#2D#;

  CTRL_REG1_A   : constant Register_Address := 16#20#;
  CTRL_REG2_A   : constant Register_Address := 16#21#;
  CTRL_REG3_A   : constant Register_Address := 16#22#;
  CTRL_REG4_A   : constant Register_Address := 16#23#;
  CTRL_REG5_A   : constant Register_Address := 16#24#;
  CTRL_REG6_A   : constant Register_Address := 16#25#;
  DATACAPTURE_A : constant Register_Address := 16#26#;

  STATUS_REG_A : constant Register_Address := 16#27#;

  WHO_AM_I_M : constant Register_Address := 16#4F#;

  type CTRL_REG1_A_Register is record
    ODR  : UInt4   := 0;
    LPen : Boolean := False;
    Zen  : Boolean := True;
    Yen  : Boolean := True;
    Xen  : Boolean := True;
  end record;

  for CTRL_REG1_A_Register use record
    ODR at 0 range 0 .. 3;
  end record;

  function To_UInt8 is new Ada.Unchecked_Conversion
   (CTRL_REG1_A_Register, UInt8);
  function To_Reg is new Ada.Unchecked_Conversion
   (UInt8, CTRL_REG1_A_Register);

  type STATUS_REG_A_Register is record
    ZYXOVR : Boolean := False;
    ZOVR   : Boolean := False;
    YOVR   : Boolean := False;
    XOVR   : Boolean := False;

    ZYXDA : Boolean := False;
    ZDA   : Boolean := False;
    YDA   : Boolean := False;
    XDA   : Boolean := False;
  end record;

  for STATUS_REG_A_Register use record
    ZYXOVR at 0 range 0 .. 0;
    ZOVR   at 0 range 1 .. 1;
    YOVR   at 0 range 2 .. 2;
    XOVR   at 0 range 3 .. 3;

    ZYXDA at 0 range 4 .. 4;
    ZDA   at 0 range 5 .. 5;
    YDA   at 0 range 6 .. 6;
    XDA   at 0 range 7 .. 7;
  end record;

  function To_UInt8 is new Ada.Unchecked_Conversion
   (STATUS_REG_A_Register, UInt8);
  function To_Reg is new Ada.Unchecked_Conversion
   (UInt8, STATUS_REG_A_Register);

end LSM303AGR;
