library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Temporizador is
    port(
        clk      : in  std_logic;      -- 100 MHz
        reset    : in  std_logic;
        tick_1ms : out std_logic --pulso 1 ciclo/ms
    );
end entity;

architecture Behavioral of Temporizador is
    constant MAX_COUNT : unsigned(16 downto 0) := to_unsigned(100000 - 1, 17); --valor maximo contadores
    signal count : unsigned(16 downto 0) := (others => '0');--registro contador interno. 17 bits
begin

    process(clk, reset)
    begin
        if reset = '0' then
            count    <= (others => '0');
            tick_1ms <= '0';

        elsif rising_edge(clk) then
            if count = MAX_COUNT then
                count    <= (others => '0');
                tick_1ms <= '1'; --cuenta 1 cada ms (vale 1 un ciclo de reloj cada 100k ciclos)
            else
                count    <= count + 1;
                tick_1ms <= '0';
            end if;
        end if;
    end process;

end Behavioral;
