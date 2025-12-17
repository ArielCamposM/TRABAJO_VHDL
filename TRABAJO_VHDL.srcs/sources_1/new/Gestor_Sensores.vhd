library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Gestor_Sensores is
    port(
        clk           : in  std_logic;         -- reloj 100 MHz
        reset         : in  std_logic;

        sensor_in     : in  std_logic;         -- sensor de entrada físico
        sensor_exit    : in  std_logic;         

        pieza_ready_in  : out std_logic;       -- pulso en flanco subida entrada
        pieza_ready_exit : out std_logic;       

        estado_in     : out std_logic;         -- nivel estable de sensores
        estado_exit    : out std_logic          
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

    -- SINCRONIZADORES
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
            ASYNC_IN     => sensor_exit,
            SYNC_OUT     => out_sync
        );

    -- Detecta flancos
    process(clk, reset)
    begin
        if reset = '0' then
            in_prev  <= '0';
            out_prev <= '0';

            pieza_ready_in  <= '0';
            pieza_ready_exit <= '0';

        elsif rising_edge(clk) then  
            pieza_ready_in  <= '0';
            pieza_ready_exit <= '0';

            -- flanco subida sensor entrada
            if in_sync = '1' and in_prev = '0' then
                pieza_ready_in <= '1';
            end if;

            -- flanco subida sensor salida
            if out_sync = '1' and out_prev = '0' then
                pieza_ready_exit <= '1';
            end if;

            -- actualizamos memorias
            in_prev  <= in_sync;
            out_prev <= out_sync;

        end if;
    end process;

    -- el estado será la salida del sincronizador (para entrada y para salida)
    estado_in  <= in_sync;
    estado_exit <= out_sync;

end Behavioral;
