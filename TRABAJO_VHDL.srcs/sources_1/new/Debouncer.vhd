library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debouncer is
    port (
        clk   : in  std_logic;      -- 100 MHz
        boton_entrada : in  std_logic;
        boton_salida: out std_logic
    );
end Debouncer;

architecture Behavioral of Debouncer is

    constant MAX_COUNT : integer := 1_000_000; -- 10 ms @ 100 MHz

    signal sync0, sync1 : std_logic := '0';
    signal estable      : std_logic := '0';
    signal contador     : integer range 0 to MAX_COUNT := 0;

begin

    -- Sincronización
    process(clk)
    begin
        if rising_edge(clk) then
            sync0 <= boton_entrada;
            sync1 <= sync0;
        end if;
    end process;

    -- Antirrebotes
    process(clk)
    begin
        if rising_edge(clk) then            
                if sync1 = estable then
                    contador <= 0;
                else
                    if contador = MAX_COUNT then
                        estable <= sync1;
                        contador <= 0;
                    else
                        contador <= contador + 1;
                    end if;
                end if;
            end if;
    end process;

    boton_salida <= estable;

end Behavioral;

