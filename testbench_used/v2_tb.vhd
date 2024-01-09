library ieee;
use ieee.std_logic_1164.all;

entity v2_tb is
end v2_tb;

architecture tb of v2_tb is

    component v2
        port (clk        : in std_logic;
              rsta_i     : in std_logic;
              btnu       : in std_logic;
              btnl       : in std_logic;
              btnr       : in std_logic;
              btnd       : in std_logic;
              btnc       : in std_logic;
              PMOD_CS    : out std_logic;
              PMOD_MOSI  : out std_logic;
              PMOD_SCK   : out std_logic;
              PMOD_DC    : out std_logic;
              PMOD_RES   : out std_logic;
              PMOD_VCCEN : out std_logic;
              PMOD_EN    : out std_logic;
              LED_OUT    : out std_logic_vector (4 downto 0));
    end component;

    signal clk        : std_logic;
    signal rsta_i     : std_logic;
    signal btnu       : std_logic;
    signal btnl       : std_logic;
    signal btnr       : std_logic;
    signal btnd       : std_logic;
    signal btnc       : std_logic;
    signal PMOD_CS    : std_logic;
    signal PMOD_MOSI  : std_logic;
    signal PMOD_SCK   : std_logic;
    signal PMOD_DC    : std_logic;
    signal PMOD_RES   : std_logic;
    signal PMOD_VCCEN : std_logic;
    signal PMOD_EN    : std_logic;
    signal LED_OUT    : std_logic_vector (4 downto 0);

begin

    dut : v2
    port map (clk        => clk,
              rsta_i     => rsta_i,
              btnu       => btnu,
              btnl       => btnl,
              btnr       => btnr,
              btnd       => btnd,
              btnc       => btnc,
              PMOD_CS    => PMOD_CS,
              PMOD_MOSI  => PMOD_MOSI,
              PMOD_SCK   => PMOD_SCK,
              PMOD_DC    => PMOD_DC,
              PMOD_RES   => PMOD_RES,
              PMOD_VCCEN => PMOD_VCCEN,
              PMOD_EN    => PMOD_EN,
              LED_OUT    => LED_OUT);

    clk_process : process
    begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process;

    test : process
    begin
        rsta_i <= '1';
        btnu <= '0';
        btnl <= '0';
        btnr <= '0';
        btnd <= '0';
        btnc <= '0';
        wait for 10 ns;

        -- STATE_RIGHT 3
        
        btnr <= '1';
        wait for 10 ns;
        btnr <= '0';
        wait for 10000 ms;

    end process;

end tb;