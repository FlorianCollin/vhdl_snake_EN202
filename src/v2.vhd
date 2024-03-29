----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN

-- top level
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.constants_pkg.all;

entity v2_3 is
    port(
        clk    : in std_logic;
        rsta_i : in std_logic;

        btnu : in std_logic; -- up
        btnl : in std_logic; -- left
        btnr : in std_logic; -- right
        btnd : in std_logic; -- down
        btnc : in std_logic; -- center (rst : FSM)

        PMOD_CS      : out std_logic; -- 1
        PMOD_MOSI    : out std_logic; -- 2
        PMOD_SCK     : out std_logic; -- 4
        PMOD_DC      : out std_logic; -- 7
        PMOD_RES     : out std_logic; -- 8
        PMOD_VCCEN   : out std_logic; -- 9
        PMOD_EN      : out std_logic; -- 10
        
        -- for debug
        LED_OUT : out std_logic_vector(4 downto 0);
        led_col : out std_logic;
        led_ce : out std_logic;
        led_rst : out std_logic;
        sept_segments : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(7 downto 0)

    );
end v2_3;

----------------------------------------------------------------------------------------------------------------

architecture Behavioral of v2_3 is

    -- component
    -- counters 
    component counter is
        generic (
            count_width : integer := 8;
            max_value : integer := 255
        );
        port (
            clk : in std_logic;
            rsta : in std_logic;
            ce1 : in std_logic;
            ce2 : in std_logic;
            decr : in std_logic;
            count : out std_logic_vector(count_width - 1 downto 0)
        );
    end component;

    component counter_basic is
        generic (
            count_width : integer := 8;
            max_value : integer := SCREEN_LENGTH
        );
        port (
            clk : in std_logic;
            rsta : in std_logic;
            count : out std_logic_vector(count_width - 1 downto 0)
        );
    end component;

    component snake_size_counter is
        generic (
            count_width : integer := 4;
            max_value : integer := 7
        );
        port (
            clk : in std_logic;
            rsta : in std_logic;
            ce : in std_logic;
            decr : in std_logic;
            count : out std_logic_vector(count_width - 1 downto 0)
        );
    end component;

    -- elementary component

    component equal_xy is
        port (
            x0, x1 : in std_logic_vector(X_LENGTH - 1 downto 0);
            y0, y1 : in std_logic_vector(Y_LENGTH - 1 downto 0);
            f : out std_logic
        );
    end component;

    -- Pmod
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
              
              PMOD_CS      : out STD_LOGIC; -- 1
              PMOD_MOSI    : out STD_LOGIC; -- 2
              PMOD_SCK     : out STD_LOGIC; -- 4
              PMOD_DC      : out STD_LOGIC; -- 7
              PMOD_RES     : out STD_LOGIC; -- 8
              PMOD_VCCEN   : out STD_LOGIC; -- 9
              PMOD_EN      : out STD_LOGIC -- 10
       );
    end component;
    
    -- for input button
    component detect_impulsion is
        port (
            clock : in std_logic;
            btn_input : in std_logic;
            btn_output : out std_logic
        );
    end component;
    
    component ce_gen is
        port(
            horloge : in std_logic;
            rsta : in std_logic;
            speed : in std_logic_vector(7 downto 0); -- pilot by the snake size value
            ce : out std_logic
        );
    end component;

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
            led : out std_logic_vector(4 downto 0) -- debug
        );
    end component;

    component FSM_draw is
        port(
            clk : in std_logic;
            rst : in std_logic;
            ce : in std_logic;
            new_apple : in std_logic;
            col_detect : in std_logic;
            btn : in std_logic;
            rsta : out std_logic;
            appleFFsig : out std_logic;
            incr_size : out std_logic;
            we : out std_logic; -- 1 (not used)
            selector_menu : out std_logic_vector(1 downto 0);
            selector_mux : out std_logic_vector(1 downto 0);
            state_to_print : out std_logic_vector(3 downto 0) -- debug
       );
    end component;

    component mux is
        port(
            s : in std_logic_vector(1 downto 0);
            x0 : in std_logic_vector(X_LENGTH - 1 downto 0); -- head
            x1 : in std_logic_vector(X_LENGTH - 1 downto 0); -- tail
            x2 : in std_logic_vector(X_LENGTH - 1 downto 0); -- apple
            x3 : in std_logic_vector(X_LENGTH - 1 downto 0); -- full picture
            y0 : in std_logic_vector(Y_LENGTH - 1 downto 0); -- head
            y1 : in std_logic_vector(Y_LENGTH - 1 downto 0); -- tail
            y2 : in std_logic_vector(Y_LENGTH - 1 downto 0); -- apple
            y3 : in std_logic_vector(Y_LENGTH - 1 downto 0); -- full picture
            color : in std_logic_vector(RGB_LENGTH - 1 downto 0);
    
            x_out : out std_logic_vector(X_LENGTH - 1 downto 0);
            y_out : out std_logic_vector(Y_LENGTH - 1 downto 0);
            color_out : out std_logic_vector(RGB_LENGTH - 1 downto 0)
        );
    end component;


    component FF_dec_xy is
        port(
            clk : in std_logic;
            rsta : in std_logic;
            ce : in std_logic;
            n : in std_logic_vector(7 downto 0);
            x_in : in std_logic_vector(X_LENGTH - 1 downto 0);
            y_in : in std_logic_vector(Y_LENGTH - 1 downto 0);
            x_out : out std_logic_vector(X_LENGTH - 1 downto 0);
            y_out : out std_logic_vector(Y_LENGTH - 1 downto 0);

            col_detect : out std_logic
        );
    end component;
    
    -- custom flip-flop
    component FF_xy is
        port(
            clk : in std_logic;
            rsta : in std_logic;
            ce : in std_logic;
            x : in std_logic_vector(X_LENGTH - 1 downto 0);
            y : in std_logic_vector(Y_LENGTH - 1 downto 0);
            x_out : out std_logic_vector(X_LENGTH - 1 downto 0);
            y_out : out std_logic_vector(Y_LENGTH - 1 downto 0)
        );
    end component;

    -- sept_segments for debug
    component sept_segments_module is
        port (
            clk : in std_logic;
            rsta : in std_logic;
            n : in std_logic_vector(7 downto 0);
            fsm_draw_state : std_logic_vector(3 downto 0);
            sept_segments : out std_logic_vector(6 downto 0);
            an : out std_logic_vector(7 downto 0)
        );
    end component;
    
    -- menu 
    component menu is
        port(
            clk : in std_logic;
            rsta : in std_logic;
            -- s=0 : start_screen
            -- s=1 : game_over 
            -- s=2 : refresh_screen
            s : in std_logic_vector(1 downto 0);
            data : out std_logic_vector(RGB_LENGTH - 1 downto 0);
            x : out std_logic_vector(X_LENGTH - 1 downto 0);
            y : out std_logic_vector(Y_LENGTH - 1 downto 0)
        );
    end component;

    

----------------------------------------------------------------------------------------------------------------

    
    --  glocal constant can be found in "constant_pkg.vhd"

    -- constant for oledScreen
    constant CLK_FREQ_HZ : integer := 100000000;
    constant GREYSCALE   : boolean := False;
    constant LEFT_SIDE   : boolean := False;

----------------------------------------------------------------------------------------------------------------

    -- signaux

    signal s_clk, s_rsta, s_rsta_btn: std_logic;
    signal s_btnu, s_btnd, s_btnr, s_btnl, s_btnc : std_logic;

    signal s_color : std_logic_vector(RGB_LENGTH - 1 downto 0); -- sortie du mux

    signal s_decr_x, s_decr_y : std_logic;
    signal s_ce_x, s_ce_y : std_logic;

    signal s_ce_2 : std_logic;
    
    signal s_pix_write : std_logic;
    signal s_pix_data_out : std_logic_vector(RGB_LENGTH - 1 downto 0);

    signal s_x, s_x_new, s_x_FF_out, s_x_apple, s_x_apple_to_print: std_logic_vector(X_LENGTH - 1 downto 0);
    signal s_y, s_y_new, s_y_FF_out, s_y_apple, s_y_apple_to_print: std_logic_vector(Y_LENGTH - 1 downto 0);
    
    signal s_mux_select : std_logic_vector(1 downto 0);
    signal s_menu_select : std_logic_vector(1 downto 0);

    signal s_n : std_logic_vector(7 downto 0);
    
    signal s_new_apple : std_logic := '0';
    signal s_snake_damage : std_logic;
    signal s_incr_size : std_logic;
    signal s_appleFFsig : std_logic;

    signal s_col_detect : std_logic;

    signal s_color_menu : std_logic_vector(RGB_LENGTH - 1 downto 0);
    signal s_x_menu : std_logic_vector(X_LENGTH - 1 downto 0);
    signal s_y_menu : std_logic_vector(Y_LENGTH - 1  downto 0);

    signal s_fsm_draw_state : std_logic_vector(3 downto 0);

----------------------------------------------------------------------------------------------------------------

begin

    s_snake_damage <= '0'; -- pour le moment on ne prend pas en compte les dégats sur le snake decr = '0'

    -- inst
    s_clk <= clk;
    s_rsta_btn <= not rsta_i;
    -- s_n <= "010";
    
    inst_detect_impulsion_btnu : detect_impulsion
    port map (
        clock => s_clk,
        btn_input => btnu,
        btn_output => s_btnu
    ); 
    inst_detect_impulsion_btnd : detect_impulsion
    port map (
        clock => s_clk,
        btn_input => btnd,
        btn_output => s_btnd
    );
    inst_detect_impulsion_btnr : detect_impulsion
    port map (
        clock => s_clk,
        btn_input => btnr,
        btn_output => s_btnr
    );
    inst_detect_impulsion_btnl : detect_impulsion
    port map (
        clock => s_clk,
        btn_input => btnl,
        btn_output => s_btnl
    );
    inst_detect_impulsion_btnc : detect_impulsion
    port map (
        clock => s_clk,
        btn_input => btnc,
        btn_output => s_btnc
    );

    -- les compteurs

    -- counter basic pour les coo de la pomme

    inst_counter_apple_x : counter_basic
    generic map (
        count_width => X_LENGTH,
        max_value => SCREEN_LENGTH - 1 -- 63 for oledScreen
    )
    port map(
        clk => s_clk,
        rsta => s_rsta_btn,
        count => s_x_apple
    );

    inst_counter_apple_y : counter_basic
    generic map (
        count_width => Y_LENGTH,
        max_value => SCREEN_WIDTH - 1 -- 95 for oledScreen
    )
    port map(
        clk => s_clk,
        rsta => s_rsta_btn,
        count => s_y_apple
    );

    -- Compteur pour la taille du snake !
    
    inst_snake_size_counter : snake_size_counter
    generic map(
        count_width => 8,
        max_value => MAX_SNAKE_SIZE - 1
    )
    port map (
        clk => s_clk,
        rsta => s_rsta,
        ce => s_incr_size, -- doit durée 1 durée d'horloge exactement!
        decr => s_snake_damage,
        count => s_n
    );

    inst_counter_x : counter
    generic map (
        count_width => X_LENGTH,
        max_value => SCREEN_LENGTH - 1
    )
    port map(
        clk => s_clk,
        rsta => s_rsta,
        ce1 => s_ce_x,
        ce2 => s_ce_2,
        decr => s_decr_x,

        count => s_x_new
    );
    
    inst_counter_y : counter
    generic map (
        count_width => Y_LENGTH,
        max_value => SCREEN_WIDTH - 1
    )
    port map(
        clk => s_clk,
        rsta => s_rsta,
        ce1 => s_ce_y,
        ce2 => s_ce_2,
        decr => s_decr_y,

        count => s_y_new
    );

    -- equal_xy verifie si la nouvelle position de la tête du snake est égale à la c'elle de la pomme

    inst_equal_xy : equal_xy
    port map (
        x0 => s_x_apple_to_print, -- position actuelle de la pomme
        y0 => s_y_apple_to_print,
        x1 => s_x_new, --futur position de la tête
        y1 => s_y_new,
        f => s_new_apple -- entrée FSM_draw
    );
    
    

    -- Génère le signal qui permet de synchro variable !!
    inst_ce_gen : ce_gen
    port map (
        horloge => s_clk,
        rsta => s_rsta_btn,
        speed => s_n, -- commande la vitesse sur diférent niveau
        ce => s_ce_2
    );

    inst_PmodOLEDrgb_bitmap : PmodOLEDrgb_bitmap
    generic map (
        CLK_FREQ_HZ => CLK_FREQ_HZ,
        BPP         => RGB_LENGTH,
        GREYSCALE   => GREYSCALE,
        LEFT_SIDE   => LEFT_SIDE
    )
    port map (
        clk          => s_clk,
        reset        => s_rsta_btn,

        pix_write    => s_pix_write, -- wip
        pix_col      => s_x,
        pix_row      => s_y,
        pix_data_in  => s_color,
        pix_data_out => s_pix_data_out, -- not used

        PMOD_CS      => PMOD_CS, 
        PMOD_MOSI    => PMOD_MOSI,
        PMOD_SCK     => PMOD_SCK,
        PMOD_DC      => PMOD_DC,
        PMOD_RES     => PMOD_RES,
        PMOD_VCCEN   => PMOD_VCCEN,
        PMOD_EN      => PMOD_EN
    );

        -- FSM qui gère les déplacements du snake !
        -- Elle commande les deux conpteurs qui donne la position courrante de la tête du snake
        inst_FSM : FSM
        port map ( 
            clk  => s_clk,
            rst => s_btnc,
            btnu => s_btnu,
            btnl => s_btnl,
            btnr => s_btnr,
            btnd => s_btnd,
    
            ce_x => s_ce_x,
            ce_y => s_ce_y,
            decr_x => s_decr_x,
            decr_y => s_decr_y,
            led => LED_OUT
        );
        
        -- Registre à décalage + mux 
        -- permet de récupérer les anciennes positions de la tête du snake.
        inst_FF_dec_xy : FF_dec_xy
        port map (
            clk => s_clk,
            rsta => s_rsta_btn,
            ce => s_ce_2,
            n => s_n,
            x_in => s_x_new,
            y_in => s_y_new,
            x_out => s_x_FF_out,
            y_out => s_y_FF_out,
            col_detect => s_col_detect
        );


        inst_FSM_draw : FSM_draw
        port map(
            clk => s_clk,
            rst => s_rsta_btn, -- atttention confilt asynch/synch 
            ce => s_ce_2,
            new_apple => s_new_apple,
            col_detect => s_col_detect, -- v2.3
            btn => s_btnc, -- v2.3
            rsta => s_rsta,
            appleFFsig => s_appleFFsig,
            incr_size => s_incr_size,
            we => s_pix_write,
            selector_mux => s_mux_select, -- v2.3
            selector_menu => s_menu_select, -- v2.3
            state_to_print => s_fsm_draw_state
        );

        inst_mux : mux
        port map(
            s => s_mux_select,
            x0 => s_x_new, -- sortie des 'counter'
            y0 => s_y_new,
            x1 => s_x_FF_out, -- sortie du mux
            y1 => s_y_FF_out,
            x2 => s_x_apple_to_print,
            y2 => s_y_apple_to_print,
            x3 => s_x_menu, -- v2.3
            y3 => s_y_menu, -- v2.3
            color => s_color_menu, -- v2.3
            x_out => s_x,
            y_out => s_y,
            color_out => s_color 
        );

        inst_FF_apple : FF_xy
        port map(
            clk => s_clk,
            rsta => s_rsta_btn,
            ce => s_appleFFsig,
            x => s_x_apple,
            y => s_y_apple,
            x_out => s_x_apple_to_print,
            y_out => s_y_apple_to_print
        );

        -- sept segments

        inst_sept_segments_module : sept_segments_module
        port map (
            clk => s_clk,
            rsta => s_rsta_btn,
            n => s_n,
            fsm_draw_state => s_fsm_draw_state,
            sept_segments => sept_segments,
            an => an
        );

        inst_menu : menu -- v2.3
        port map (
            clk => s_clk,
            rsta => s_rsta_btn,
            s => s_menu_select,
            data => s_color_menu,
            x => s_x_menu,
            y => s_y_menu
        );

    led_col <= s_col_detect;
    led_ce <= s_ce_2;
    led_rst <= s_rsta;
    
end Behavioral;
