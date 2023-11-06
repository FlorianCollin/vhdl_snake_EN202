----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN
-- 'counter' is a counter that has 2 enable signals, which allow adjusting its speed through one signal
-- and activating it through another.
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity counter is
    generic (
        count_width : integer := 8;
        max_value : integer := 255
    );
    port (
        clk : in std_logic;
        rsta : in std_logic;
        ce1 : in std_logic;
        ce2 : in std_logic;
        decr : in std_logic;
        count : out std_logic_vector(count_width - 1 downto 0)
    );
end entity counter;

architecture behav of counter is

    signal count_reg : unsigned(count_width - 1 downto 0) := (others => '0');

begin

    process(clk, rsta)
    begin
        if rsta = '1' then
            count_reg <= (others => '0');
        
        elsif rising_edge(clk) then
            if ce1 = '1' and ce2 = '1' then
                if decr = '0' then
                    if (count_reg = to_unsigned(max_value, count_width)) then
                        count_reg <= (others => '0');
                    else
                        count_reg <= count_reg + 1;
                    end if;
                else -- decr = '1'
                    if count_reg = to_unsigned(0, count_width) then
                        count_reg <= to_unsigned(max_value, count_width);
                    else
                        count_reg <= count_reg - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    count <= std_logic_vector(count_reg);

end architecture behav;
