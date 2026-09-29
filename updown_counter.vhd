library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity updown_counter is
    port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        up_pulse : in  STD_LOGIC;
        dn_pulse : in  STD_LOGIC;
        count    : out STD_LOGIC_VECTOR(15 downto 0)
    );
end updown_counter;

architecture Behavioral of updown_counter is

    signal counter : unsigned(15 downto 0) := (others => '0');

begin

    process(clk)
    begin

        if rising_edge(clk) then

            if rst = '1' then
                counter <= (others => '0');

            elsif up_pulse = '1' then
                counter <= counter + 1;

            elsif dn_pulse = '1' then
                counter <= counter - 1;

            end if;

        end if;

    end process;

    count <= STD_LOGIC_VECTOR(counter);

end Behavioral;