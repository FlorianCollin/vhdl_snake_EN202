
library ieee;
use ieee.std_logic_1164.all;

entity ce_gen_tb is
end ce_gen_tb;

architecture tb of ce_gen_tb is

    component ce_gen
        port (horloge : in std_logic;
              rsta    : in std_logic;
              speed   : in std_logic_vector (7 downto 0);
              ce      : out std_logic);
    end component;

    signal horloge : std_logic;
    signal rsta    : std_logic;
    signal speed   : std_logic_vector (7 downto 0);
    signal ce      : std_logic;

begin

    dut : ce_gen
    port map (horloge => horloge,
              rsta    => rsta,
              speed   => speed,
              ce      => ce);


    clk_process : process
    begin
        horloge <= '1';
        wait for 5 ns;
        horloge <= '0';
        wait for 5 ns;
    end process;

    stimuli : process
    begin
        rsta <= '0';
        speed <= (others => '0');
        wait for 200 ns;
        speed <= x"01";
        wait for 200 ns;
        speed <= x"04";
        
    end process;

end tb;