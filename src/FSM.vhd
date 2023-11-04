----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN
----------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FSM is
    Port ( 
        clk  : in std_logic;
        rst : in std_logic;
        btnu : in STD_LOGIC;
        btnl : in STD_LOGIC;
        btnr : in STD_LOGIC;
        btnd : in STD_LOGIC;

        ce_x : out STD_LOGIC;
        ce_y : out STD_LOGIC;
        decr_x : out STD_LOGIC;
        decr_y : out STD_LOGIC;
        
        led : out std_logic_vector(4 downto 0) -- affichage de controle
    );
end FSM;

architecture Behavioral of FSM is

    type state is (state_up, state_down, state_right, state_left, state_wait);
    signal current_state : state := state_wait;
    signal next_state : state := state_wait;

begin

    -- Processus combinatoire de calcul de l'etat futur
    process_next_state : process(current_state, rst, btnu, btnl, btnr, btnd)
    begin
    
        case current_state is
        
            when state_up =>
                if btnu = '1' then
                    null;
                elsif btnd = '1' then
                    next_state <= state_down;
                elsif btnr = '1' then
                    next_state <= state_right;
                elsif btnl = '1' then
                    next_state <= state_left;
                else
                    next_state <= current_state;
                end if;
                
            when state_down =>
                if btnu = '1' then
                    next_state <= state_up;
                elsif btnd = '1' then
                    null;
                elsif btnr = '1' then
                    next_state <= state_right;
                elsif btnl = '1' then
                    next_state <= state_left;
                else
                    next_state <= current_state;
                end if;
                
            when state_right =>
                if btnu = '1' then
                    next_state <= state_up;
                elsif btnd = '1' then
                    next_state <= state_down;
                elsif btnr = '1' then
                    null;
                elsif btnl = '1' then
                    next_state <= state_left;
                else
                    next_state <= current_state;
                end if;
                
            when state_left =>
                if btnu = '1' then
                    next_state <= state_up;
                elsif btnd = '1' then
                    next_state <= state_down;
                elsif btnr = '1' then
                    next_state <= state_right;
                elsif btnl = '1' then
                    null;
                else
                    next_state <= current_state;
                end if;
                
            when state_wait =>
                if btnu = '1' then
                    next_state <= state_up;
                elsif btnd = '1' then
                    next_state <= state_down;
                elsif btnr = '1' then
                    next_state <= state_right;
                elsif btnl = '1' then
                    next_state <= state_left;
                else
                    next_state <= current_state;
                end if; 
            
        end case;
        
    end process;

    
    process_current_state : process(current_state)
    begin
        case current_state is
            when state_up =>
                ce_x <= '0';
                ce_y <= '1';
                decr_x <= '0';
                decr_y <= '1';
                led <= "00010"; -- State 1
            when state_down =>
                ce_x <= '0';
                ce_y <= '1';
                decr_x <= '0';
                decr_y <= '0';
                led <= "00100"; -- State 2
            when state_right =>
                ce_x <= '1';
                ce_y <= '0';
                decr_x <= '0';
                decr_y <= '0';
                led <= "01000"; -- State 3
            when state_left =>
                ce_x <= '1';
                ce_y <= '0';
                decr_x <= '1';
                decr_y <= '0';
                led <= "10000"; -- State 4
            when state_wait =>
                ce_x <= '0';
                ce_y <= '0';
                decr_x <= '0';
                decr_y <= '0';
                led <= "00001"; -- State 0
        end case;
    end process;
        
    process_synch : process(clk, rst)
    begin
        if (rising_edge(clk)) then
            if (rst='1') then
                current_state <= state_wait;
            else 
                current_state <= next_state;
            end if;
        end if;
    end process;

end Behavioral;
