
library ieee;
use ieee.std_logic_1164.all;

entity address_counter_tb is
end address_counter_tb;

architecture tb of address_counter_tb is

    component address_counter
        port (clk         : in std_logic;
              rsta        : in std_logic;
              address_rom : out std_logic_vector (12 downto 0);
              x_rom       : out std_logic_vector (6 downto 0);
              y_rom       : out std_logic_vector (5 downto 0));
    end component;

    signal clk         : std_logic;
    signal rsta        : std_logic;
    signal address_rom : std_logic_vector (12 downto 0);
    signal x_rom       : std_logic_vector (6 downto 0);
    signal y_rom       : std_logic_vector (5 downto 0);

begin

    dut : address_counter
    port map (clk         => clk,
              rsta        => rsta,
              address_rom => address_rom,
              x_rom       => x_rom,
              y_rom       => y_rom
        );

    clk_process : process
    begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process;



end tb;
