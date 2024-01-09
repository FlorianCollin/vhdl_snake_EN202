library ieee;
use ieee.std_logic_1164.all;

entity test_tb is
end test_tb;

architecture tb of test_tb is

    component test
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

    signal clk        : std_logic := '0';
    signal rsta_i     : std_logic;
    signal btnu       : std_logic := '0';
    signal btnl       : std_logic := '0';
    signal btnr       : std_logic := '0';
    signal btnd       : std_logic := '0';
    signal btnc       : std_logic := '0';
    signal PMOD_CS    : std_logic;
    signal PMOD_MOSI  : std_logic;
    signal PMOD_SCK   : std_logic;
    signal PMOD_DC    : std_logic;
    signal PMOD_RES   : std_logic;
    signal PMOD_VCCEN : std_logic;
    signal PMOD_EN    : std_logic;
    signal LED_OUT    : std_logic_vector (4 downto 0);


begin

    dut : test
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


    test_process : process
    begin
        rsta_i <= '1';
        wait for 10 ns;
        
        -- STATE_UP 1
        
        btnu <= '1';
        wait for 10 ns;
        btnu <= '0';
        wait for 200 ns;
        
        -- STATE_RIGHT 3
        
        btnr <= '1';
        wait for 10 ns;
        btnr <= '0';
        wait for 200 ns;
        
        -- STATE_DOWN 2
        
        btnd <= '1';
        wait for 10 ns;
        btnd <= '0';
        wait for 200 ns;
        
        -- STATE_LEFT 4
        
        btnl <= '1';
        wait for 10 ns;
        btnl <= '0';
        wait for 200 ns;
        
        -- STATE_WAIT 0       
        
        btnc <= '1';
        wait for 10 ns;
        btnc <= '0';
        wait for 200 ns;
        
        -- STATE_UP 1
        
        btnu <= '1';
        wait for 10 ns;
        btnu <= '0';
        wait for 200 ns;
        
        wait;
    end process;

end tb;