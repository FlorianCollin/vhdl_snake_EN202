library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sept_segments_module is
    port (
        clk : in std_logic;
        rsta : in std_logic;
        n : in std_logic_vector(7 downto 0);
        fsm_draw_state : std_logic_vector(3 downto 0);
        sept_segments : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(7 downto 0)
    );
end sept_segments_module;

architecture top of sept_segments_module is

    component trans is
        port (
            nb_binaire : in std_logic_vector(7 downto 0); -- [0;255]
            s_cent, s_diz, s_unit : out std_logic_vector(6 downto 0)
        );
    end component;

    component trans_fsm_draw_state is
        port (
            state : in std_logic_vector(3 downto 0); -- 8 states
            sept_seg_state : out std_logic_vector(6 downto 0)
        );
    end component;

    component mux8 is
        port (
            commande : in std_logic_vector(2 downto 0);
            e0, e1, e2, e3, e4, e5, e6, e7 : in std_logic_vector(6 downto 0);
            s : out std_logic_vector(6 downto 0)
        );
    end component;

    component mod8 is
        port (
            clk, ce, rsta : in std_logic;
            an : out std_logic_vector(7 downto 0);
            sortie : out std_logic_vector(2 downto 0)
        );
    end component;

    component sept_segments_freq is
        port(
            clk : in std_logic;
            rsta : in std_logic;
            ce_perception : out std_logic
        );
    end component;

--------------------------------------------------------------------------------------------------------

    signal s_clk, s_rsta : std_logic;
    signal s_ce : std_logic;
    signal s_commande : std_logic_vector(2 downto 0);
    signal s_e0, s_e1, s_e2, s_e3, s_e4, s_e5, s_e6, s_e7 : std_logic_vector(6 downto 0) := (others => '1');

begin

    s_clk <= clk;
    s_rsta <= rsta;

    inst_sept_segments_freq : sept_segments_freq
    port map (
        clk => s_clk,
        rsta => s_rsta,
        ce_perception => s_ce
    );

    inst_mod8 : mod8
    port map (
        clk => s_clk,
        ce => s_ce,
        rsta => s_rsta,
        an => an,
        sortie => s_commande
    );

    inst_mux8 : mux8
    port map (
        commande => s_commande,
        e0 => s_e0,
        e1 => s_e1,
        e2 => s_e2,
        e3 => s_e3,
        e4 => s_e4,
        e5 => s_e5,
        e6 => s_e6,
        e7 => s_e7,
        s => sept_segments
    );

    inst_trans : trans
    port map (
        nb_binaire => n,
        s_cent => s_e0,
        s_diz => s_e1,
        s_unit => s_e2
    );

    inst_trans_fsm_draw : trans_fsm_draw_state
    port map (
        state => fsm_draw_state,
        sept_seg_state => s_e7
    );

    

end top ;