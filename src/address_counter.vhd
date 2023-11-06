----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN
-- This counter allows writing the content of a ROM to the OLED screen by providing (x, y, address).
-- Thus, we iterate through all the addresses in our ROM and provide the coordinates associated with each address.
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.constants_pkg.all;


entity address_counter is
    port (
        clk : in std_logic;
        rsta : in std_logic;
        address_rom : out std_logic_vector(12 downto 0);
        x_rom : out std_logic_vector(X_LENGTH - 1 downto 0); -- [0;95]
        y_rom : out std_logic_vector(Y_LENGTH - 1 downto 0) -- [0;64]
    );
end address_counter;

architecture Behavioral of address_counter is
    signal count_x : unsigned(X_LENGTH - 1 downto 0) := (others => '0');
    signal count_y : unsigned(Y_LENGTH - 1 downto 0) := (others => '0');
    signal count_n : unsigned(12 downto 0) := (others => '0');
    constant max_x : unsigned(X_LENGTH - 1 downto 0) :=  (to_unsigned(95, X_LENGTH));
    constant max_y : unsigned(Y_LENGTH - 1 downto 0) := (to_unsigned(63, Y_LENGTH));
    constant max_n : unsigned(12 downto 0) := (to_unsigned(6143, 13));

begin
    process(clk, rsta)
    begin
        if rsta = '1' then
            count_x <= (others => '0');
            count_y <= (others => '0');
        elsif rising_edge(clk) then
            if count_x = max_x then
                count_x <= (others => '0');
                if count_y = max_y then
                    count_y <= (others => '0');
                else
                    count_y <= count_y + 1;
                end if;
            else
                count_x <= count_x + 1;
            end if;
        end if;
    end process;

    process(clk, rsta)
    begin
        if rsta = '1' then
            count_n <= (others => '0');
        elsif rising_edge(clk) then
            if count_n = max_n then
                count_n <= (others => '0');
            else
                count_n <= count_n + 1;
            end if;
        end if;
    end process;

    x_rom <= std_logic_vector(count_x);
    y_rom <= std_logic_vector(count_y);
    address_rom <= std_logic_vector(count_n);


end Behavioral;