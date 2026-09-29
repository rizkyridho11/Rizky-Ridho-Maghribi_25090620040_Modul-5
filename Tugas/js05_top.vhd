library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity js05_top is
    Port (
        clk  : in  STD_LOGIC;
        sw   : in  STD_LOGIC_VECTOR (0 downto 0); -- Sakelar freeze sw(0)
        btnU : in  STD_LOGIC;                     -- Tombol Tambah
        btnD : in  STD_LOGIC;                     -- Tombol Kurang
        btnC : in  STD_LOGIC;                     -- Tombol Reset
        seg  : out STD_LOGIC_VECTOR (6 downto 0);  -- Tujuh segmen
        dp   : out STD_LOGIC;                     -- Titik desimal
        an   : out STD_LOGIC_VECTOR (3 downto 0)   -- Anoda
    );
end js05_top;

architecture Structural of js05_top is
    signal btnU_db, btnD_db, btnC_db : STD_LOGIC;
    signal btnU_pulse, btnD_pulse    : STD_LOGIC;
    signal counter_val               : STD_LOGIC_VECTOR(15 downto 0);
begin
    -- 1. Instansiasi Debounce
    db_U : entity work.debounce port map (clk => clk, btn_in => btnU, btn_out => btnU_db);
    db_D : entity work.debounce port map (clk => clk, btn_in => btnD, btn_out => btnD_db);
    db_C : entity work.debounce port map (clk => clk, btn_in => btnC, btn_out => btnC_db);

    -- 2. Instansiasi Edge Detector
    ed_U : entity work.edge_detect port map (clk => clk, sig_in => btnU_db, pulse => btnU_pulse);
    ed_D : entity work.edge_detect port map (clk => clk, sig_in => btnD_db, pulse => btnD_pulse);

    -- 3. Instansiasi Up-Down Counter (dengan masukan freeze sw(0))
    cnt  : entity work.updown_counter port map (
        clk    => clk,
        inc    => btnU_pulse,
        dec    => btnD_pulse,
        rst    => btnC_db,
        freeze => sw(0),
        count  => counter_val
    );

    -- 4. Instansiasi Driver Display (Heksadesimal)
    driver : entity work.seven_seg_driver port map (
        clk     => clk,
        data_in => counter_val,
        seg     => seg,
        dp      => dp,
        an      => an
    );
end Structural;