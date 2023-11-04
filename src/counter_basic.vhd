----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity counter_basic is
    generic (
        count_width : integer := 8;
        max_value : integer := 63 -- ATTENTION : Il faut respecter max_value < 2^count_width !!
    );
    port (
        clk : in std_logic;
        rsta : in std_logic;
        count : out std_logic_vector(count_width - 1 downto 0)
    );
end entity counter_basic;

architecture behav of counter_basic is

    signal count_reg : unsigned(count_width - 1 downto 0) := to_unsigned(30, count_width);

begin

    process(clk, rsta)
    begin
        if rsta = '1' then
            count_reg <= (others => '0'); -- A voir si l'on reset à start value ??
        
        elsif rising_edge(clk) then
            if (count_reg = to_unsigned(max_value, count_width)) then
                count_reg <= (others => '0');
            else
                count_reg <= count_reg + 1;
            end if;   
        end if;
    end process;

    count <= std_logic_vector(count_reg);

end architecture behav;
