----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.constants_pkg.all;

----------------------------------------------------------------------------------------------------------------

entity menu is
    port(
        clk : in std_logic;
        rsta : in std_logic;
        -- s=0 : start_screen / s=1 : game_over / s=2 : refresh_screen
        s : in std_logic_vector(1 downto 0);
        data : out std_logic_vector(RGB_LENGTH - 1 downto 0);
        x : out std_logic_vector(X_LENGTH - 1 downto 0);
        y : out std_logic_vector(Y_LENGTH - 1 downto 0)
    );
end menu;


architecture top of menu is

-- component

    component address_counter is
        port (
            clk : in std_logic;
            rsta : in std_logic;
            address_rom : out std_logic_vector(12 downto 0);
            x_rom : out std_logic_vector(X_LENGTH - 1 downto 0); -- [0;95]
            y_rom : out std_logic_vector(Y_LENGTH - 1 downto 0) -- [0;64]
        );
    end component;

    component rom_start_screen is
        Port (
            clk : in std_logic;
            address : in std_logic_vector(12 downto 0);
            data : out std_logic_vector(RGB_LENGTH - 1 downto 0)
            );
    end component;

    component rom_game_over is
        Port (
            clk : in std_logic;
            address : in std_logic_vector(12 downto 0);
            data : out std_logic_vector(RGB_LENGTH - 1 downto 0)
            );
    end component;

----------------------------------------------------------------------------------------------------------------

    -- signaux
    signal s_clk, s_rsta : std_logic;
    signal s_address : std_logic_vector(12 downto 0);
    signal s_x : std_logic_vector(X_LENGTH - 1 downto 0);
    signal s_y : std_logic_vector(Y_LENGTH - 1 downto 0);
    signal s_data_start_screen, s_data_game_over : std_logic_vector(RGB_LENGTH - 1 downto 0);


begin
    s_clk <= clk;
    s_rsta <= rsta;

    -- les différents rom avec les images complètes
    inst_rom_start_screen : rom_start_screen
    port map (
        clk => s_clk,
        address => s_address,
        data => s_data_start_screen
    );

    inst_rom_game_over : rom_game_over
    port map (
        clk => s_clk,
        address => s_address,
        data => s_data_game_over
    );

    -- le compteur qui fournit (x,y) et l'addresse
    inst_counter : address_counter
    port map (
        clk => s_clk,
        rsta => s_rsta,
        address_rom => s_address,
        x_rom => s_x,
        y_rom => s_y
    );

    x <= s_x;
    y <= s_y;

    -- process qui permet de selectionner la bonne rom
    process(s)
    begin
        case s is
            when "00" =>
                data <= s_data_start_screen;
            when "01" =>
                data <= s_data_game_over;
            when "10" =>
                data <= (others => '0');
            when others =>
                data <= (others => '0');
        end case;
    end process;



end top ; -- top