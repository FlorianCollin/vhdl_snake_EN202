library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux8 is
    port (
        commande : in std_logic_vector(2 downto 0);
        e0, e1, e2, e3, e4, e5, e6, e7 : in std_logic_vector(6 downto 0);
        s : out std_logic_vector(6 downto 0)
    );
end mux8;

architecture behav of mux8 is
begin
    process(commande, e0, e1, e2, e3, e4, e5, e6, e7)
    begin
        case (commande) is
            when "000" =>
                s <= e0;
            when "001" =>
                s <= e1;
            when "010" =>
                s <= e2;
            when "011" =>
                s <= e3;
            when "100" =>
                s <= e4;
            when "101" =>
                s <= e5;
            when "110" =>
                s <= e6;
            when "111" =>
                s <= e7;
            when others =>
                null;
        end case;
        
    end process;
end behav;    