library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FF_dec_xy is
    port(
        clk : in std_logic;
        rsta : in std_logic;
        ce : in std_logic;

        n : in std_logic_vector(7 downto 0);

        x_in : in std_logic_vector(6 downto 0);
        y_in : in std_logic_vector(5 downto 0);

        x_out : out std_logic_vector(6 downto 0);
        y_out : out std_logic_vector(5 downto 0);

        col_detect : out std_logic -- à 1 quand il y a une collision
    );
end FF_dec_xy;

architecture Behavioral of FF_dec_xy is
    component mux_xy_8 is
        port (
            mux_selector : in std_logic_vector(2 downto 0);
            x0, x1, x2, x3, x4, x5, x6, x7 : in std_logic_vector(6 downto 0);
            y0, y1, y2, y3, y4, y5, y6, y7 : in std_logic_vector(5 downto 0);

            x_out : out std_logic_vector(6 downto 0);
            y_out : out std_logic_vector(5 downto 0)
        );
    end component;
    component FF_xy is
        port(
            clk : in std_logic;
            rsta : in std_logic;
            ce : in std_logic;
            x : in std_logic_vector(6 downto 0);
            y : in std_logic_vector(5 downto 0);
            x_out : out std_logic_vector(6 downto 0);
            y_out : out std_logic_vector(5 downto 0)
        );
    end component;

    constant nb_FF : integer := 256;
    
    type inst_tab_x is array(0 to nb_FF) of std_logic_vector(6 downto 0);
    type inst_tab_y is array(0 to nb_FF) of std_logic_vector(5 downto 0);
    
    signal s_clk, s_rsta, s_ce : std_logic;

    signal s_x : inst_tab_x;
    signal s_y : inst_tab_y;

    signal collision_detected : std_logic := '0';


begin
    s_clk <= clk;
    s_rsta <= rsta;
    s_ce <= ce;
    
    s_x(0) <= x_in;
    s_y(0) <= y_in;

    gen_FF_xy : for i in 0 to nb_FF - 1 generate
        inst_FF_xy : FF_xy
            port map (
                clk => s_clk,
                rsta => s_rsta,
                ce => s_ce,
                x => s_x(i),
                y => s_y(i),
                x_out => s_x(i + 1),
                y_out => s_y(i + 1)
            );
    end generate;

    -- ask teacher !!!

--    process(clk, ce)
--    begin
--        if rising_edge(clk) then
--            if ce = '1' then
--                if n = x"00" then
--                    col_detect <= '0';
--                else
--                    for i in 1 to nb_FF -1 loop
--                        if (s_x(i) = s_x(0)) and (s_y(i) = s_y(0)) then
--                            if i < to_integer(unsigned(n)) then
--                                col_detect <= '1';
--                            else
--                                col_detect <= '0';
--                            end if;
--                        else
--                            col_detect <= '0';
--                        end if;
--                    end loop;
--                end if;
--            end if;
--        end if;
--    end process;


    -- test en passant par un signal (collision_detected)
    process(clk, ce)
    begin
        if rising_edge(clk) then
            if ce = '1' then
                if n = x"00" then
                    col_detect <= '0';
                else
                    collision_detected <= '0'; -- Réinitialiser la détection de collision

                    for i in 1 to 255 loop
                        if (i < to_integer(unsigned(n)) +1) then
                            if (s_x(i) = s_x(0)) and (s_y(i) = s_y(0)) then
                                collision_detected <= '1';
                            end if;
                        end if;
                    end loop;

                    col_detect <= collision_detected; -- Mettre à jour la sortie de la collision
                end if;
            end if;
        end if;
    end process;

    x_out <= s_x(to_integer(unsigned(n))+1);
    y_out <= s_y(to_integer(unsigned(n))+1);

end Behavioral;
