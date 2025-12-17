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

    signal in_sync  : std_logic := '0';
    signal out_sync : std_logic := '0';

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
    
    --Detectores de flanco
    U_EDGE_IN : entity work.EDGEDTCTR
        port map(
            CLK     => clk,
            SYNC_IN => in_sync,
            EDGE    => pieza_ready_in
        );

   
    U_EDGE_OUT : entity work.EDGEDTCTR
        port map(
            CLK     => clk,
            SYNC_IN => out_sync,
            EDGE    => pieza_ready_exit
        );

    estado_in   <= in_sync;
    estado_exit <= out_sync;

end Behavioral;
