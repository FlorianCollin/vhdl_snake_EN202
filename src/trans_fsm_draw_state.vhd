----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trans_fsm_draw_state is
    port (
        state : in std_logic_vector(3 downto 0); -- 8 states
        sept_seg_state : out std_logic_vector(6 downto 0)
    );
end trans_fsm_draw_state;

architecture behav of trans_fsm_draw_state is
begin
    process(state)
    begin
        case (state) is
            when "0000" =>
                sept_seg_state <= "0000001";            
            when "0001" =>
                sept_seg_state <= "1001111";            
            when "0010" =>
                sept_seg_state <= "0010010";            
            when "0011" =>
                sept_seg_state <= "0000110";            
            when "0100" =>
                sept_seg_state <= "1001100";            
            when "0101" =>
                sept_seg_state <= "0100100";            
            when "0110" =>
                sept_seg_state <= "0100000";            
            when "0111" =>
                sept_seg_state <= "0001111";            
            when "1000" =>
                sept_seg_state <= "0000000";            
            when "1001" =>
                sept_seg_state <= "0000100";            
            when "1010" =>
                sept_seg_state <= "0000001";            
            when "1011" =>
                sept_seg_state <= "1001111";            
            when "1100" =>
                sept_seg_state <= "0010010";            
            when "1101" =>
                sept_seg_state <= "0000110";            
            when "1110" =>
                sept_seg_state <= "1001100";            
            when "1111" =>
                sept_seg_state <= "0100100";
            when others =>
                null;
        end case;
    end process;

end behav; 