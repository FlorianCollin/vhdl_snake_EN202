----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN
-- 'detect_impulse' is one of my basic blocks that conditions signals coming from buttons
-- to be '1' for a single clock period following a press.
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity detect_impulsion is
    port (
        clock : in std_logic;
        btn_input : in std_logic;
        btn_output : out std_logic
    );
end detect_impulsion;

architecture behav of detect_impulsion is
signal one_detect : std_logic := '0';

begin
    process(clock, btn_input)
    begin
        if (rising_edge(clock)) then
            if btn_input = '1' and one_detect = '0' then
                btn_output <= '1';
                one_detect <= '1';
            elsif btn_input = '1' and one_detect = '1' then
                btn_output <= '0';
                one_detect <= '1';
            elsif btn_input = '0' then
                btn_output <= '0';
                one_detect <= '0';
            end if;
        end if;
    end process;

end behav ; 