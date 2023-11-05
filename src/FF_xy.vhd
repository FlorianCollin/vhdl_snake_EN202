----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.constants_pkg.all;

entity FF_xy is
    port(
        clk : in std_logic;
        rsta : in std_logic;
        ce : in std_logic;
        x : in std_logic_vector(X_LENGTH - 1 downto 0);
        y : in std_logic_vector(Y_LENGTH - 1 downto 0);
        x_out : out std_logic_vector(X_LENGTH - 1 downto 0);
        y_out : out std_logic_vector(Y_LENGTH - 1 downto 0)
        
    );
end FF_xy;

architecture Behavioral of FF_xy is

begin

    process(clk,rsta,ce)
    begin
        if rsta = '1' then
            x_out <= (others => '0');
            y_out <= (others => '0');
        elsif rising_edge(clk) and ce = '1' then
            x_out <= x;
            y_out <= y;
        end if;
    end process;

end Behavioral ; -- Behavioral