----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sept_segments_freq is
    port(
        clk : in std_logic;
        rsta : in std_logic;
        ce_perception : out std_logic
    );
end sept_segments_freq;

 
architecture behav of sept_segments_freq is
    signal count_perception : unsigned(15 downto 0) := (others => '0');
begin
    process(clk, rsta)
    begin
        if rising_edge(clk) then
            if rsta = '1' then
                count_perception <= (others => '0');
                ce_perception <= '0';
            else
                count_perception <= count_perception + 1;
                if count_perception = to_unsigned(33333, count_perception'length) then
                    count_perception <= (others => '0');
                    ce_perception <= '1';
                else
                    ce_perception <= '0';
                end if;
            end if;
        end if;

    end process;


end behav ;