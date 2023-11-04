with open("image_convertie.txt", "r") as fichier_texte:
    lignes = fichier_texte.readlines()

with open("rom.vhdl", "w") as fichier_vhdl:
    fichier_vhdl.write("""
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    Port (
        clk : in std_logic;
        address : in std_logic_vector(12 downto 0);
        data : out std_logic_vector(15 downto 0) -- color RVB 5-6-5
        );
end rom;

architecture Behavioral of rom is
    type rom_TYPE is array (0 to 6143) of std_logic_vector(15 downto 0);
    constant rom_DATA : rom_TYPE := (
    """)

    for i, ligne in enumerate(lignes):
        fichier_vhdl.write('        "{}",\n'.format(ligne.strip()))

    fichier_vhdl.write("""
    others => (others => '0')
    );
begin
                       
    process(clk)
    begin
        if rising_edge(clk) then
            data <= rom_DATA(to_integer(unsigned(address)));
        end if;
    end process;
                       
end Behavioral;
""")

fichier_texte.close()
fichier_vhdl.close()
