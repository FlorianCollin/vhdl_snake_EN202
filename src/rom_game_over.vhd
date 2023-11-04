library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_game_over is
    Port (
        clk : in std_logic;
        address : in std_logic_vector(12 downto 0); -- 6144 adresse (2^13 = 8192 < 6144)
        data : out std_logic_vector(15 downto 0) -- color RVB 5-6-5
        );
end rom_game_over;

architecture Behavioral of rom_game_over is
    type rom_type is array (0 to 6143) of std_logic_vector(15 downto 0);
    constant rom_data : rom_type := (others => (others => '0'));

begin
                    
    process(clk)
    begin
        if rising_edge(clk) then
            data <= rom_data(to_integer(unsigned(address)));
        end if;
    end process;
                        
end Behavioral;