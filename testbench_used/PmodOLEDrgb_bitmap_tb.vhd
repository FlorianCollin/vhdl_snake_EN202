library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PmodOLEDrgb_bitmap_tb is
end PmodOLEDrgb_bitmap_tb;

architecture sim of PmodOLEDrgb_bitmap_tb is

    component PmodOLEDrgb_bitmap is
        Generic (CLK_FREQ_HZ : integer := 100000000;        -- by default, we run at 100MHz
                 BPP         : integer range 1 to 16 := 16; -- bits per pixel
                 GREYSCALE   : boolean := False;            -- color or greyscale ? (only for BPP>6)
                 LEFT_SIDE   : boolean := False);           -- True if the Pmod is on the left side of the board
        Port (clk          : in  STD_LOGIC;
              reset        : in  STD_LOGIC;
              
              pix_write    : in  STD_LOGIC;
              pix_col      : in  STD_LOGIC_VECTOR(    6 downto 0);
              pix_row      : in  STD_LOGIC_VECTOR(    5 downto 0);
              pix_data_in  : in  STD_LOGIC_VECTOR(BPP-1 downto 0);
              pix_data_out : out STD_LOGIC_VECTOR(BPP-1 downto 0);
              
              PMOD_CS      : out STD_LOGIC;
              PMOD_MOSI    : out STD_LOGIC;
              PMOD_SCK     : out STD_LOGIC;
              PMOD_DC      : out STD_LOGIC;
              PMOD_RES     : out STD_LOGIC;
              PMOD_VCCEN   : out STD_LOGIC;
              PMOD_EN      : out STD_LOGIC);
    end component; 

    -- Constants
    constant BPP : integer := 16;
    constant Th : time := 10 ns;  -- Adjust the clock period as needed

    -- Signals
    signal clk, reset, pix_write, PMOD_CS, PMOD_MOSI, PMOD_SCK, PMOD_DC, PMOD_RES, PMOD_VCCEN, PMOD_EN: std_logic;
    signal pix_data_in, pix_data_out: std_logic_vector(BPP-1 downto 0);
    signal pix_col : std_logic_vector(6 downto 0);
    signal pix_row : std_logic_vector(5 downto 0);

    begin
        -- Instantiate the DUT
        uut: PmodOLEDrgb_bitmap
            generic map (
                CLK_FREQ_HZ => 100000000,  -- Set the desired clock frequency
                BPP => BPP,
                GREYSCALE => False,
                LEFT_SIDE => False
            )
            port map (
                clk => clk,
                reset => reset,
                pix_write => pix_write,
                pix_col => pix_col,
                pix_row => pix_row,
                pix_data_in => pix_data_in,
                pix_data_out => pix_data_out,
                PMOD_CS => PMOD_CS,
                PMOD_MOSI => PMOD_MOSI,
                PMOD_SCK => PMOD_SCK,
                PMOD_DC => PMOD_DC,
                PMOD_RES => PMOD_RES,
                PMOD_VCCEN => PMOD_VCCEN,
                PMOD_EN => PMOD_EN
            );

        clk_process : process
        begin
            clk <= '1';
            wait for Th/2;
            clk <= '0';
            wait for Th/2;
        end process;
        

        test : process
        begin
            wait for 100 ns;
            reset <= '1';
            wait for Th;
            reset <= '0';
            wait for 100 ns;
            pix_write <= '1';
            pix_col  <= "0000001";
            pix_row  <= "000001";
            pix_data_in <= x"FFFF";
            wait for 2*Th;
            pix_write <= '0';
            wait for 2*Th;
            wait;
        end process;





    end architecture sim;
