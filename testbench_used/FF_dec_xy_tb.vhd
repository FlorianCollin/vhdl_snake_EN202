library ieee;
use ieee.std_logic_1164.all;

entity FF_dec_xy_tb is
end FF_dec_xy_tb;

architecture tb of FF_dec_xy_tb is

    component FF_dec_xy
        port (clk   : in std_logic;
              rsta  : in std_logic;
              ce    : in std_logic;
              n     : in std_logic_vector (2 downto 0);
              x_in  : in std_logic_vector (6 downto 0);
              y_in  : in std_logic_vector (5 downto 0);
              x_out : out std_logic_vector (6 downto 0);
              y_out : out std_logic_vector (5 downto 0)
        );
    end component;

    signal clk   : std_logic;
    signal rsta  : std_logic;
    signal ce    : std_logic;
    signal n     : std_logic_vector (2 downto 0);
    signal x_in  : std_logic_vector (6 downto 0);
    signal y_in  : std_logic_vector (5 downto 0);
    signal x_out : std_logic_vector (6 downto 0);
    signal y_out : std_logic_vector (5 downto 0);

begin

    dut : FF_dec_xy
    port map (clk   => clk,
              rsta  => rsta,
              ce    => ce,
              n     => n,
              x_in  => x_in,
              y_in  => y_in,
              x_out => x_out,
              y_out => y_out
    );

    clk_process : process
    begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process;

    ce_process : process
    begin
        ce <= '1';
        wait for 50 ns;
        ce <= '0';
        wait for 50 ns;
    end process;

    test : process
    begin
        rsta <= '0';
        ce <= '0';
        n <= (others => '0');
        x_in <= (others => '0');
        y_in <= (others => '0');
        wait;

    end process;

end tb;