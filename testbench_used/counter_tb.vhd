library ieee;
use ieee.std_logic_1164.all;

entity tb_counter is
end tb_counter;

architecture tb of tb_counter is

    component counter
        port (clk   : in std_logic;
              rsta  : in std_logic;
              ce1   : in std_logic;
              ce2   : in std_logic;
              decr  : in std_logic;
              count : out std_logic_vector (count_width - 1 downto 0));
    end component;

    signal clk   : std_logic;
    signal rsta  : std_logic;
    signal ce1   : std_logic;
    signal ce2   : std_logic;
    signal decr  : std_logic;
    signal count : std_logic_vector (count_width - 1 downto 0);

begin

    dut : counter
    port map (clk   => clk,
              rsta  => rsta,
              ce1   => ce1,
              ce2   => ce2,
              decr  => decr,
              count => count);

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        rsta <= '0';
        ce1 <= '0';
        ce2 <= '0';
        decr <= '0';

        -- EDIT Add stimuli here

        wait;
    end process;

end tb;