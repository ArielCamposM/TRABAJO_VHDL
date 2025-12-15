library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Gestor_Sensores is
    port(
        clk           : in  std_logic;         -- reloj 100 MHz
        reset         : in  std_logic;

        sensor_in     : in  std_logic;         -- sensor de entrada físico
        sensor_out    : in  std_logic;         -- sensor de salida físico

        pieza_ready_in  : out std_logic;       -- pulso en flanco subida entrada
        pieza_ready_out : out std_logic;       -- pulso en flanco subida salida

        estado_in     : out std_logic;         -- nivel estable
        estado_out    : out std_logic          -- nivel estable
    );
end entity;

architecture Behavioral of Gestor_Sensores is

    -- señales sincronizadas
    signal in_sync   : std_logic := '0';
    signal out_sync  : std_logic := '0';

    -- memorias para flancos
    signal in_prev   : std_logic := '0';
    signal out_prev  : std_logic := '0';

begin

    --------------------------------------------------------------------
    -- SINCRONIZADORES
    --------------------------------------------------------------------
    U_SYNC_IN : entity work.SYNCHRNZR
        port map(
            clk   => clk,
            RESET => reset,
            ASYNC_IN     => sensor_in,
            SYNC_OUT     => in_sync
        );

    U_SYNC_OUT : entity work.SYNCHRNZR
        port map(
            clk   => clk,
            RESET  => reset,
            ASYNC_IN     => sensor_out,
            SYNC_OUT     => out_sync
        );

    --------------------------------------------------------------------
    -- DETECCIÓN DE FLANCOS
    --------------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            in_prev  <= '0';
            out_prev <= '0';

            pieza_ready_in  <= '0';
            pieza_ready_out <= '0';

        elsif rising_edge(clk) then

            -- por defecto los pulsos están a 0
            pieza_ready_in  <= '0';
            pieza_ready_out <= '0';

            -- flanco subida sensor entrada
            if in_sync = '1' and in_prev = '0' then
                pieza_ready_in <= '1';
            end if;

            -- flanco subida sensor salida
            if out_sync = '1' and out_prev = '0' then
                pieza_ready_out <= '1';
            end if;

            -- actualizar memorias
            in_prev  <= in_sync;
            out_prev <= out_sync;

        end if;
    end process;

    --------------------------------------------------------------------
    -- niveles estables
    --------------------------------------------------------------------
    estado_in  <= in_sync;
    estado_out <= out_sync;

end Behavioral;
