----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN
-- not used (directly implement in a top level for the moment !)
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity equal_xy is
    port (
        x0, x1 : in std_logic_vector(6 downto 0);
        y0, y1 : in std_logic_vector(5 downto 0);
        f : out std_logic
    );
end equal_xy;

architecture Behavioral of equal_xy is
begin
    process(x0, x1, y0, y1)
    begin
        if (x0 = x1) and (y0 = y1) then
            f <= '1';
        else
            f <= '0';
        end if;
   end process;
end Behavioral ; -- Behavioral