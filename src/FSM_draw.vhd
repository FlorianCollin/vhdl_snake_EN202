----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM_draw is
    port(
        clk : in std_logic;
        rst : in std_logic;
        ce : in std_logic;
        new_apple : in std_logic;
        col_detect : in std_logic;
        btn : in std_logic;

        rsta : out std_logic;
        appleFFsig : out std_logic;
        incr_size : out std_logic;
        we : out std_logic; -- 1
        selector_menu : out std_logic_vector(1 downto 0);
        selector_mux : out std_logic_vector(1 downto 0);
        state_to_print : out std_logic_vector(3 downto 0)
   );
end FSM_draw;


architecture Behavioral of FSM_draw is

    type state is (
        start, -- affichage de l'écran de démarrage
        refresh,
        game_over,
        draw_head, -- dessin du nouveaux pixel head
        delete_tail, -- réecriture d'un pixel vide sur la queux du snake
        wait_ce, -- attente de ce
        draw_apple, -- dessin d'une nouvelle pomme
        draw_first_apple, -- dessin de la première pomme
        appleFF -- actualisation de la valeur des coordonée de la pomme
    );
    signal current_state : state := start;
    signal next_state : state := start;

begin

    process_next_state : process(current_state,ce,new_apple,btn, col_detect)
    begin
        case current_state is
            --0
            when start =>
                if btn = '1' then
                    next_state <= refresh;
                else
                    next_state <= current_state;
                end if;
            -- 1
            when refresh =>
                if ce = '1' then
                    next_state <= draw_first_apple;
                else
                    next_state <= current_state;
                end if;
            -- 2
            when draw_first_apple =>
                if ce = '1' then
                    next_state <= draw_head;
                else
                    next_state <= current_state;
                end if;
            -- 3
            when draw_head =>
                if col_detect = '1' then
                    next_state <= game_over;
                elsif new_apple = '1' then
                    next_state <= appleFF;
                else
                    next_state <= delete_tail;
                end if;
            -- 4
            when delete_tail =>
                next_state <= wait_ce; -- Wait
            -- 5
            when wait_ce =>
                if ce = '1' then
                    next_state <= draw_head;
                else
                    next_state <= current_state;
                end if;
            -- 6
            when appleFF =>
                next_state <= draw_apple;
            -- 7
            when draw_apple =>
                next_state <= wait_ce;
            -- 8
            when game_over =>
                next_state <= game_over;
            
        end case;
    end process;

    process_current_state : process(current_state)
    begin
        case current_state is
            -- 0
            when start =>
                state_to_print <= x"0";
                appleFFsig <= '1';
                selector_mux <= "11";
                selector_menu <= "00";
            -- 1
            when refresh =>
                state_to_print <= x"1";
                rsta <= '1';
                selector_mux <= "11";
                selector_menu <= "10";
            -- 2
            when draw_first_apple =>
                state_to_print <= x"2";
                rsta <= '0';
                appleFFsig <= '0';
                incr_size <= '0';
                we <= '1';
                selector_mux <= "10";
            -- 3
            when draw_head =>
                state_to_print <= x"3";
                we <= '1';
                selector_mux <= "00";
            -- 4
            when delete_tail =>
                state_to_print <= x"4";
                selector_mux <= "01";
            -- 5
            when wait_ce =>
                state_to_print <= x"5";
                incr_size <= '0';
            -- 6
            when appleFF =>
                state_to_print <= x"6";
                appleFFsig <= '1';
            -- 7
            when draw_apple =>
                state_to_print <= x"7";
                appleFFsig <= '0';
                selector_mux <= "10";
                incr_size <= '1';
            -- 8
            when game_over =>
                state_to_print <= x"8";
                selector_mux <= "11";
                selector_menu <= "10";
            when others =>
                null;
        end case;
    end process;

    process_synch : process(clk, rst)
    begin
        if (rising_edge(clk)) then
            if (rst='1') then
                current_state <= start;
            else 
                current_state <= next_state;
            end if;
        end if;
    end process;

end Behavioral ; -- Behavioral
