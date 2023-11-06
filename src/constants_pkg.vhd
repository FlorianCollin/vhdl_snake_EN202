----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN
-- constants_pkg.vhdl
-- This package contains all the global constants of the project.
-- I have chosen not to use generics for these constants; this may change in the future.
-- The purpose of these variables is to make the code cleaner and, more importantly, to enable code reuse
-- for different screens and display modes (VGA, black and white...).
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package constants_pkg is
  constant X_LENGTH : integer := 7;
  constant Y_LENGTH : integer := 6;
  constant RGB_LENGTH : integer := 16;
end package constants_pkg;

package body constants_pkg is
end package body constants_pkg;
