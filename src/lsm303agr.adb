package body LSM303AGR is

    function To_UInt10 is new Ada.Unchecked_Conversion (UInt6, UInt10);
    function To_UInt12 is new Ada.Unchecked_Conversion (UInt16, UInt12);
function To_Axis_Data is new Ada.Unchecked_Conversion (UInt10, Axis_Data);

    function Read_Register
       (This : LSM303AGR_Accelerometer'Class; Device_Address : I2C_Address;
        Register_Addr : Register_Address) return UInt8;

    procedure Write_Register
       (This : LSM303AGR_Accelerometer'Class; Device_Address : I2C_Address;
        Register_Addr : Register_Address; Val : UInt8);

    function Check_Device_Id
       (This : LSM303AGR_Accelerometer; Device_Address : I2C_Address;
        WHO_AM_I_Register : Register_Address; Device_Id : Device_Identifier)
        return Boolean;

    function To_Multi_Byte_Read_Address
       (Register_Addr : Register_Address) return UInt16;

    procedure Configure (This : LSM303AGR_Accelerometer; Date_Rate : Data_Rate)
    is
        CTRLA : CTRL_REG1_A_Register;
    begin
        CTRLA.Xen  := 1;
        CTRLA.Yen  := 1;
        CTRLA.Zen  := 1;
        CTRLA.LPen := 0;
        CTRLA.ODR  := Date_Rate'Enum_Rep;

        This.Write_Register
           (Accelerometer_Address, CTRL_REG1_A, To_UInt8 (CTRLA));
    end Configure;

    -------------------
    -- Read_Register --
    -------------------

    function Read_Register
       (This : LSM303AGR_Accelerometer'Class; Device_Address : I2C_Address;
        Register_Addr : Register_Address) return UInt8
    is
        Data   : I2C_Data (1 .. 1);
        Status : I2C_Status;
    begin
        This.Port.Mem_Read
           (Addr => Device_Address, Mem_Addr => UInt16 (Register_Addr),
            Mem_Addr_Size => Memory_Size_8b, Data => Data, Status => Status);

        if Status /= Ok then
            --  No error handling...
            raise Program_Error;
        end if;
        return Data (Data'First);
    end Read_Register;

    --------------------
    -- Write_Register --
    --------------------

    procedure Write_Register
       (This : LSM303AGR_Accelerometer'Class; Device_Address : I2C_Address;
        Register_Addr : Register_Address; Val : UInt8)
    is
        Status : I2C_Status;
    begin
        This.Port.Mem_Write
           (Addr => Device_Address, Mem_Addr => UInt16 (Register_Addr),
            Mem_Addr_Size => Memory_Size_8b, Data => (1 => Val),
            Status        => Status);

        if Status /= Ok then
            --  No error handling...
            raise Program_Error;
        end if;
    end Write_Register;

    -----------------------------------
    -- Check_Accelerometer_Device_Id --
    -----------------------------------

    function Check_Accelerometer_Device_Id
       (This : LSM303AGR_Accelerometer) return Boolean
    is
    begin
        return
           Check_Device_Id
              (This, Accelerometer_Address, WHO_AM_I_A,
               Accelerometer_Device_Id);
    end Check_Accelerometer_Device_Id;

    ----------------------------------
    -- Check_Magnetometer_Device_Id --
    ----------------------------------

    function Check_Magnetometer_Device_Id
       (This : LSM303AGR_Accelerometer) return Boolean
    is
    begin
        return
           Check_Device_Id
              (This, Magnetometer_Address, WHO_AM_I_M, Magnetometer_Device_Id);
    end Check_Magnetometer_Device_Id;

    ---------------------
    -- Check_Device_Id --
    ---------------------

    function Check_Device_Id
       (This : LSM303AGR_Accelerometer; Device_Address : I2C_Address;
        WHO_AM_I_Register : Register_Address; Device_Id : Device_Identifier)
        return Boolean
    is
    begin
        return
           Read_Register (This, Device_Address, WHO_AM_I_Register) =
           UInt8 (Device_Id);
    end Check_Device_Id;

    ------------------------
    -- Read_Accelerometer --
    ------------------------

    function Read_Accelerometer (This : LSM303AGR_Accelerometer) return UInt16
        --    (This : LSM303AGR_Accelerometer) return I2C_Data

    is
        Status : I2C_Status;
        -- ConvertedData : UInt16_Array (1 .. 3);
        Data : I2C_Data (1 .. 6) := (others => 0);
        Axis : UInt10            := 0;
        T2   : Axis_Data         := 0;
    begin
        This.Port.Mem_Read
           (Addr          => Accelerometer_Address,
            Mem_Addr      => To_Multi_Byte_Read_Address (OUT_X_L_A),
            Mem_Addr_Size => Memory_Size_8b, Data => Data, Status => Status);
        if Status /= Ok then
            --  No error handling...
            raise Program_Error;
        end if;
        declare
            Tmp : UInt10 := 0;

        begin
            -- Data 1: Low, Data 2: High
            Tmp  := UInt10 (Shift_Right (Data (1), 6));
            Tmp  := Tmp or UInt10 (Data (2)) * 2**2;
            Axis := Tmp;
            T2   := To_Axis_Data (Axis);
        end;
        -- UInt16 (Data (2)) or ...
        -- UInt16 (Data (1)) and 2#11#;
        -- Tmp := Shift_Left (, 2) or UInt10 (Data (1));
        return Axis;
        -- return Data;
    end Read_Accelerometer;

    function To_Multi_Byte_Read_Address
       (Register_Addr : Register_Address) return UInt16
    -- Based on the i2c behavior of the sensor p.38,
    -- high MSB address allows reading multiple bytes
    -- from slave devices.

    is
    begin
        return UInt16 (Register_Addr) or MULTI_BYTE_READ;
    end To_Multi_Byte_Read_Address;
end LSM303AGR;

-- ConvertedData (1) := Convert_Reading (Data (2), Data (3));
-- ConvertedData (2) := Convert_Reading (Data (2), Data (3));
-- ConvertedData (3) := Convert_Reading (Data (2), Data (3));

--------------------------------
-- Adjust_To_Operational_Mode --
--------------------------------

-- function Adjust_To_Operational_Mode (Raw : UInt16) return Axis_Data is
--     Tmp : UInt12;

-- begin
--     Tmp := To_UInt12 (Shift_Right (Raw, NORMAL_MODE_DIVISOR));
--     return To_Axis_Data (Tmp);
-- end Adjust_To_Operational_Mode;

---------------------
-- Convert_Reading --
---------------------

-- function Convert_Reading (LSB, MSB : UInt8) return UInt16 is

-- begin
--     return UInt16 (Shift_Left (MSB, 8) or LSB);
--     --     return Adjust_To_Operational_Mode (Tmp);
-- end Convert_Reading;
