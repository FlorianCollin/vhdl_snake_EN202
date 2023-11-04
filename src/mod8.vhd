library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod8 is
    port (
        clk, ce, rsta : in std_logic;
        an : out std_logic_vector(7 downto 0);
        sortie : out std_logic_vector(2 downto 0)
    );
end mod8;

architecture behav of mod8 is
    signal count : unsigned(2 downto 0):="000"; -- signal pour le compteur
begin
    process(clk, ce, rsta)
    begin
    if (rsta = '1') then
        count <= "000";
    else
        if (rising_edge(clk)) then
            if (ce = '1') then
                if count = "111" then -- 8
                    count <= "000";
                else
                    count <= count + 1; -- on incrémente
                end if;
            end if;
        end if;
    end if;
    
    case (count) is
        when "000" => an <= "01111111";
        when "001" => an <= "10111111"; 
        when "010" => an <= "11011111"; 
        when "011" => an <= "11101111"; 
        when "100" => an <= "11110111"; 
        when "101" => an <= "11111011"; 
        when "110" => an <= "11111101"; 
        when "111" => an <= "11111110"; 
    end case;
    
    end process;
    
    sortie <= std_logic_vector(count); -- permet de créer un signal de selection pour le mux
    
end behav;