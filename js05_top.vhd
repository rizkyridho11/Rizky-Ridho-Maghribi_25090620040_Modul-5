library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity js05_top is
    port (
        clk  : in  STD_LOGIC;
        btnU : in  STD_LOGIC;
        btnD : in  STD_LOGIC;
        btnC : in  STD_LOGIC;

        seg  : out STD_LOGIC_VECTOR(6 downto 0);
        dp   : out STD_LOGIC;
        an   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end js05_top;

architecture Behavioral of js05_top is

    -- Sinyal hasil debounce
    signal btnU_clean : STD_LOGIC;
    signal btnD_clean : STD_LOGIC;

    -- Pulsa hasil edge detector
    signal btnU_pulse : STD_LOGIC;
    signal btnD_pulse : STD_LOGIC;

    -- Nilai counter
    signal count_value : STD_LOGIC_VECTOR(15 downto 0);

begin

    ------------------------------------------------
    -- Debounce BTN U
    ------------------------------------------------
    debounce_U : entity work.debounce
        port map (
            clk     => clk,
            btn_in  => btnU,
            btn_out => btnU_clean
        );


    ------------------------------------------------
    -- Debounce BTN D
    ------------------------------------------------
    debounce_D : entity work.debounce
        port map (
            clk     => clk,
            btn_in  => btnD,
            btn_out => btnD_clean
        );


    ------------------------------------------------
    -- Edge Detector BTN U
    ------------------------------------------------
    edge_U : entity work.edge_detect
        port map (
            clk    => clk,
            sig_in => btnU_clean,
            pulse  => btnU_pulse
        );


    ------------------------------------------------
    -- Edge Detector BTN D
    ------------------------------------------------
    edge_D : entity work.edge_detect
        port map (
            clk    => clk,
            sig_in => btnD_clean,
            pulse  => btnD_pulse
        );


    ------------------------------------------------
    -- Up/Down Counter
    ------------------------------------------------
    counter : entity work.updown_counter
        port map (
            clk      => clk,
            rst      => btnC,
            up_pulse => btnU_pulse,
            dn_pulse => btnD_pulse,
            count    => count_value
        );


    ------------------------------------------------
    -- Seven Segment Driver
    ------------------------------------------------
    display : entity work.seven_seg_driver
        generic map (
            DIGITS => 4
        )
        port map (
            clk   => clk,
            value => count_value,
            seg   => seg,
            dp    => dp,
            an    => an
        );

end Behavioral;