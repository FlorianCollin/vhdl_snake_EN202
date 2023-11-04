----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_xy_8 is
    port (
        mux_selector : in std_logic_vector(2 downto 0);
        x0, x1, x2, x3, x4, x5, x6, x7 : in std_logic_vector(6 downto 0);
        y0, y1, y2, y3, y4, y5, y6, y7 : in std_logic_vector(5 downto 0);

        x_out : out std_logic_vector(6 downto 0);
        y_out : out std_logic_vector(5 downto 0)
    );
end mux_xy_8;

architecture Behavioral of mux_xy_8 is

begin

    process(mux_selector, x0, x1, x2, x3, x4, x5, x6, x7, y0, y1, y2, y3, y4, y5, y6, y7)
    begin
        case mux_selector is
            when "000" =>
                x_out <= x0;
                y_out <= y0;
            when "001" =>
                x_out <= x1;
                y_out <= y1;
            when "010" =>
                x_out <= x2;
                y_out <= y2;
            when "011" =>
                x_out <= x3;
                y_out <= y3;
            when "100" =>
                x_out <= x4;
                y_out <= y4;
            when "101" =>
                x_out <= x5;
                y_out <= y5;
            when "110" =>
                x_out <= x6;
                y_out <= y6;
            when "111" =>
                x_out <= x7;
                y_out <= y7;
            when others =>
                null;
        end case;
    end process;

end Behavioral ; -- Behavioral