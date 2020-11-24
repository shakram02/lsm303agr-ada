package body LSM303AGR is

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

    procedure Configure (This : LSM303AGR_Accelerometer; Date_Rate : Data_Rate)
    is
        CTRLA : CTRL_REG1_A_Register;
    begin
        CTRLA.ODR  := Date_Rate'Enum_Rep;
        CTRLA.LPen := False;
        CTRLA.Xen  := True;
        CTRLA.Yen  := True;
        CTRLA.Zen  := True;

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
end LSM303AGR;
