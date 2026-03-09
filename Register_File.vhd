library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
    Port (
        ReadReg1  : in  std_logic_vector(4 downto 0);
        ReadReg2  : in  std_logic_vector(4 downto 0);
        WriteReg  : in  std_logic_vector(4 downto 0);
        WriteData : in  std_logic_vector(31 downto 0);
        clk       : in  std_logic;
        RegWrite  : in  std_logic;
        ReadData1 : out std_logic_vector(31 downto 0);
        ReadData2 : out std_logic_vector(31 downto 0)
    );
end RegisterFile;

architecture Behavioral of RegisterFile is

type reg_file is array (31 downto 0) of std_logic_vector(31 downto 0);
signal Registers : reg_file := (others => (others => '0'));        --Intilaize all with zero

begin

-- WRITE OPERATION
process(clk)
begin
    if rising_edge(clk) then
        if RegWrite = '1' then
          if to_integer(unsigned(Writereg)) /= 0 then
            Registers(to_integer(unsigned(WriteReg))) <= WriteData;
          end if;
        end if;
    end if;
end process;

-- READ OPERATION
process(clk)
begin
    if falling_edge(clk) then
        ReadData1 <= Registers(to_integer(unsigned(ReadReg1)));
        ReadData2 <= Registers(to_integer(unsigned(ReadReg2)));
    end if;
end process;

end Behavioral;