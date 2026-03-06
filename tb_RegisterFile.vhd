library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_RegisterFile is
end tb_RegisterFile;

architecture behavior of tb_RegisterFile is
    Port (
        ReadReg1  : in  STD_LOGIC_VECTOR (4 downto 0);
        ReadReg2  : in  STD_LOGIC_VECTOR (4 downto 0);
        WriteReg  : in  STD_LOGIC_VECTOR (4 downto 0);
        WriteData : in  STD_LOGIC_VECTOR (31 downto 0);
        clk       : in  STD_LOGIC;
        RegWrite  : in  STD_LOGIC;
        ReadData1 : out STD_LOGIC_VECTOR (31 downto 0);
        ReadData2 : out STD_LOGIC_VECTOR (31 downto 0)
    );
    end component;

    signal Read_reg1   : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal Read_reg2   : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal Write_reg   : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal Write_data  : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal clk         : STD_LOGIC := '0';
    signal RegWrite    : STD_LOGIC := '0';
    signal Read_data1  : STD_LOGIC_VECTOR (31 downto 0);
    signal Read_data2  : STD_LOGIC_VECTOR (31 downto 0);

    constant clk_period : time := 10 ns;

begin
    uut: RegisterFile PORT MAP (
        clk => clk,
        RegWrite => RegWrite,
        ReadReg1 => Read_reg1, 
        ReadReg2 => Read_reg2,
        WriteReg => Write_reg,
        WriteData => Write_data,
        ReadData1 => Read_data1,
        ReadData2 => Read_data2
    );

    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        wait for 20 ns;

        -- Test Case 1: Write to Register 5
        RegWrite <= '1'; 
        Write_reg <= "00101"; 
        Write_data <= x"AAAAAAAA";
        wait for clk_period;

        -- Test Case 2: Write to Register 10
        Write_reg <= "01010"; -- Reg 10
        Write_data <= x"55555555";
        wait for clk_period;

        -- Test Case 3: Set RegWrite to zero then write in register 5
        RegWrite <= '0'; 
        Write_reg <= "00101"; 
        Write_data <= x"FFFFFFFF";
        wait for clk_period;

        -- Test Case 4: Read from Register 5 and 10 to verify previous writes
        Read_reg1 <= "00101"; 
        Read_reg2 <= "01010"; 
        wait for clk_period;

        -- Test Case 5: Write and read in the same register in the same clock cycle 
        RegWrite <= '1';
        Write_reg <= "01111"; -- Reg 15
        Write_data <= x"BEEFCAFE";
        Read_reg1 <= "01111"; -- Read Reg 15 in the same cycle 
        wait for clk_period;

        -- Test Case 6: Consecutive Writes and Simultaneous Reads
        RegWrite <= '1';
        Write_reg <= "10000"; -- Reg 16
        Write_data <= x"11112222";
        wait for clk_period;
        
        Write_reg <= "10001"; -- Reg 17
        Write_data <= x"33334444";
        wait for clk_period;

        RegWrite <= '0';
        Read_reg1 <= "10000"; 
        Read_reg2 <= "10001"; 
        wait for clk_period;

        -- Test Case 7: Rapid toggling of RegWrite
        RegWrite <= '1';
        Write_reg <= "11111"; -- Reg 31
        Write_data <= x"99999999";
        wait for clk_period;
        
        RegWrite <= '0';
        Write_reg <= "11111"; 
        Write_data <= x"00000000"; 
        wait for clk_period;
        
        Read_reg2 <= "11111"; 
        wait for clk_period;

        wait;
    end process;
end behavior;