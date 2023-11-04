----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- mux est le multiplexer qui ce positionne en avant dernier bloc il est controllé par FSM_draw

entity mux is
    port(
        s : in std_logic_vector(1 downto 0);

        x0 : in std_logic_vector(6 downto 0); -- head
        x1 : in std_logic_vector(6 downto 0); -- tail
        x2 : in std_logic_vector(6 downto 0); -- apple
        x3 : in std_logic_vector(6 downto 0); -- full picture


        y0 : in std_logic_vector(5 downto 0); -- head
        y1 : in std_logic_vector(5 downto 0); -- tail
        y2 : in std_logic_vector(5 downto 0); -- apple
        y3 : in std_logic_vector(5 downto 0); -- full picture

        color : in std_logic_vector(15 downto 0);

        x_out : out std_logic_vector(6 downto 0);
        y_out : out std_logic_vector(5 downto 0);
        color_out : out std_logic_vector(15 downto 0)
    );
end mux;

architecture Behavioral of mux is

begin

    process(s, x0, y0, x1, y1)
    begin
        case s is
            when "00" => -- ecriture du nouveau pixel
                x_out <= x0;
                y_out <= y0;
                color_out <= (others => '1'); -- white

            when "01" => --affacege de la queu du snake
                x_out <= x1;
                y_out <= y1;
                color_out <= (others => '0');
            
            when "10" => -- dessin d'une nouvelle pomme
                x_out <= x2;
                y_out <= y2;
                color_out <= "1111100000000000";

            when "11" => -- menu
                x_out <= x3;
                y_out <= y3;
                color_out <= color;

            when others =>
                null;

        end case;
    end process;

end Behavioral ; -- Behavioral