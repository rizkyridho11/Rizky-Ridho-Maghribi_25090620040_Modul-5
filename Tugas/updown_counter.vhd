library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity updown_counter is
    Port (
        clk    : in  STD_LOGIC;
        inc    : in  STD_LOGIC; -- Pulsa bertambah (btnU)
        dec    : in  STD_LOGIC; -- Pulsa berkurang (btnD)
        rst    : in  STD_LOGIC; -- Reset ke nol (btnC)
        freeze : in  STD_LOGIC; -- Fitur Freeze / Pause (sw(0))
        count  : out STD_LOGIC_VECTOR (15 downto 0)
    );
end updown_counter;

architecture Behavioral of updown_counter is
    signal internal_count : unsigned(15 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                internal_count <= (others => '0');
            elsif freeze = '0' then -- Hanya menghitung jika sakelar freeze = '0'
                if inc = '1' then
                    internal_count <= internal_count + 1;
                elsif dec = '1' then
                    internal_count <= internal_count - 1;
                end if;
            end if;
        end if;
    end process;

    count <= std_logic_vector(internal_count);
end Behavioral;