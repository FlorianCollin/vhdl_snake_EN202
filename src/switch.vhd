library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- switch permettra de debugger notre architecture, pour le moment elle retourne uniquement la valeur donées par les switches !

entity switch is
    port (
        SW : in std_logic_vector(15 downto 0);
        sw_value : out std_logic(15 downto 0);
    );
end switch;

architecture Behavioral of switch is

begin

    sw_value <= SW;

end Behavioral ; -- Behavioral