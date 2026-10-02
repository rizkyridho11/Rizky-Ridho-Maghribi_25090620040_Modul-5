library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_driver is
    generic (
        DIGITS : integer := 4
    );
    port (
        clk   : in STD_LOGIC;
        value : in STD_LOGIC_VECTOR(15 downto 0);
        seg   : out STD_LOGIC_VECTOR(6 downto 0);
        dp    : out STD_LOGIC;
        an    : out STD_LOGIC_VECTOR(3 downto 0)
    );
end seven_seg_driver;

architecture Behavioral of seven_seg_driver is
    constant REFRESH_COUNT : integer := 100000;

    signal refresh_cnt : integer range 0 to REFRESH_COUNT - 1 := 0;
    signal digit_sel   : integer range 0 to 3 := 0;
    signal digit       : STD_LOGIC_VECTOR(3 downto 0);

    function bcd_to_seg(
        d : STD_LOGIC_VECTOR(3 downto 0)
    ) return STD_LOGIC_VECTOR is
    begin
        case d is
            when "0000" => return "1000000"; -- 0
            when "0001" => return "1111001"; -- 1
            when "0010" => return "0100100"; -- 2
            when "0011" => return "0110000"; -- 3
            when "0100" => return "0011001"; -- 4
            when "0101" => return "0010010"; -- 5
            when "0110" => return "0000010"; -- 6
            when "0111" => return "1111000"; -- 7
            when "1000" => return "0000000"; -- 8
            when "1001" => return "0010000"; -- 9
            when others => return "0111111"; -- -
        end case;
    end function;

begin

    -- Multiplexing display
    process(clk)
    begin
        if rising_edge(clk) then
            if refresh_cnt = REFRESH_COUNT - 1 then
                refresh_cnt <= 0;

                if digit_sel = 3 then
                    digit_sel <= 0;
                else
                    digit_sel <= digit_sel + 1;
                end if;

            else
                refresh_cnt <= refresh_cnt + 1;
            end if;
        end if;
    end process;


    -- Pemilihan digit
    -- Dibalik agar angka bertambah dari kanan
    process(digit_sel, value)
    begin
        case digit_sel is
            when 0 =>
                digit <= value(3 downto 0);

            when 1 =>
                digit <= value(7 downto 4);

            when 2 =>
                digit <= value(11 downto 8);

            when 3 =>
                digit <= value(15 downto 12);

            when others =>
                digit <= "0000";
        end case;
    end process;


    -- Konversi angka ke seven segment
    seg <= bcd_to_seg(digit);

    -- Decimal point OFF
    dp <= '1';


    -- Pemilihan digit seven segment
    process(digit_sel)
    begin
        case digit_sel is
            when 0 => an <= "1110";
            when 1 => an <= "1101";
            when 2 => an <= "1011";
            when 3 => an <= "0111";
            when others => an <= "1111";
        end case;
    end process;

end Behavioral;