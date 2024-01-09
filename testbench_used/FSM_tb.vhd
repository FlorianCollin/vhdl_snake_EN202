library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_tb is
end FSM_tb;

architecture Behavioral of FSM_tb is

    component FSM is
        Port ( 
            clk  : in std_logic;
            rst : in std_logic;
            btnu : in STD_LOGIC;
            btnl : in STD_LOGIC;
            btnr : in STD_LOGIC;
            btnd : in STD_LOGIC;
    
            ce_x : out STD_LOGIC;
            ce_y : out STD_LOGIC;
            decr_x : out STD_LOGIC;
            decr_y : out STD_LOGIC;
            color : out std_logic_vector(15 downto 0); -- pour tester color : 5-6-5
            
            led : out std_logic_vector(4 downto 0)
        );
    end component;

    signal clk, rst, btnu, btnl, btnr, btnd, ce_x, ce_y, decr_x, decr_y : std_logic := '0';
    signal color : std_logic_vector(15 downto 0) := (others => '0');
    signal led : std_logic_vector(4 downto 0) := (others => '0');

begin

    uut : FSM
    port map(
        clk => clk,
        rst => rst,
        btnu => btnu,
        btnl => btnl,
        btnr => btnr,
        btnd => btnd,

        ce_x => ce_x,
        ce_y => ce_y,
        decr_x => decr_x,
        decr_y => decr_y,
        color => color,
        
        led => led
    );

    clk_process : process
    begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
        
    end process;

    test_process : process
    begin

        btnu <= '1';
        wait for 10 ns;
        btnu <= '0';
        wait for 25 ns;
        btnu <= '1';
        wait for 10 ns;
        btnu <= '0';
        wait for 20 ns;

        btnd <= '1';
        wait for 10 ns;
        btnd <= '0';
        wait for 20 ns;

        btnr <= '1';
        wait for 10 ns;
        btnr <= '0';
        wait for 20 ns;

        btnl <= '1';
        wait for 10 ns;
        btnl <= '0';
        wait for 20 ns;

        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 20 ns;

        btnr <= '1';
        wait for 10 ns;
        btnr <= '0';
        wait for 10 ns;
    
        wait;

    end process;



end Behavioral ; -- Behavioral


