----------------------------------------------------------------------------------------------------
--    (c)2023 F. COLLIN

-- not finish (temporary)
----------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ce_gen is
    port(
        horloge : in std_logic;
        rsta : in std_logic; 
        speed : in std_logic_vector(7 downto 0); -- v2_1
        ce : out std_logic
    );
end ce_gen;

 
architecture behav of ce_gen is

    -- Pour la simulation il faut ce très rapide pour ne pas avoir a faire des simulation de plusieurs seconde !!
    -- constant s0 : integer := 20;
    -- constant s1 : integer := 20;
    -- constant s2 : integer := 20;
    -- constant s3 : integer := 20;
    -- constant s4 : integer := 20;
    -- constant s5 : integer := 20;
    -- constant s6 : integer := 20;
    -- constant s7 : integer := 20;

    constant s0 : integer := 15000000;
    constant s1 : integer := 14000000;
    constant s2 : integer := 13000000;
    constant s3 : integer := 10000000;
    constant s4 : integer := 9000000;
    constant s5 : integer := 8000000;
    constant s6 : integer := 7500000;
    constant s7 : integer := 6000000;


    signal count : unsigned(26 downto 0) := (others => '0');
    
begin

    process(horloge, rsta)
    begin
        if rising_edge(horloge) then
            if rsta = '1' then
                count <= (others => '0');
                ce <= '0';
            else
                count <= count + 1;
                case speed is
                    when std_logic_vector(to_unsigned(0, speed'length)) =>
                        if count = to_unsigned(s0, count'length) then
                            count <= (others => '0');
                            ce <= '1';
                        else
                            ce <= '0';
                        end if;
                    
                    when std_logic_vector(to_unsigned(1, speed'length)) =>
                        if count = to_unsigned(s1, count'length) then
                            count <= (others => '0');
                            ce <= '1';
                        else
                            ce <= '0';
                        end if;

                    when std_logic_vector(to_unsigned(2, speed'length)) =>
                        if count = to_unsigned(s2, count'length) then 
                            count <= (others => '0');
                            ce <= '1';
                        else
                            ce <= '0';
                        end if;

                    when std_logic_vector(to_unsigned(3, speed'length)) =>
                        if count = to_unsigned(s3, count'length) then
                            count <= (others => '0');
                            ce <= '1';
                        else
                            ce <= '0';
                        end if;

                    when std_logic_vector(to_unsigned(4, speed'length)) =>
                        if count = to_unsigned(s4, count'length) then
                            count <= (others => '0');
                            ce <= '1';
                        else
                            ce <= '0';
                        end if;

                    when std_logic_vector(to_unsigned(5, speed'length)) =>
                        if count = to_unsigned(s5, count'length) then
                            count <= (others => '0');
                            ce <= '1';
                        else
                            ce <= '0';
                        end if;

                    when std_logic_vector(to_unsigned(6, speed'length)) =>
                        if count = to_unsigned(s6, count'length) then
                            count <= (others => '0');
                            ce <= '1';
                        else
                            ce <= '0';
                        end if;

                    when std_logic_vector(to_unsigned(7, speed'length)) =>
                        if count = to_unsigned(s7, count'length) then
                            count <= (others => '0');
                            ce <= '1';
                        else
                            ce <= '0';
                        end if;
                        
                    when others =>
                        if count = to_unsigned(s7, count'length) then
                            count <= (others => '0');
                            ce <= '1';
                        else
                            ce <= '0';
                        end if;
                end case;

            end if;
        end if;

    end process;


end behav ;