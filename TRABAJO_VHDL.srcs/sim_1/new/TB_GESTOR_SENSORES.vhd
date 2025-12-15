library ieee;
use ieee.std_logic_1164.all;

entity TB_Gestor_Sensores is
end entity;

architecture tb of TB_Gestor_Sensores is

    -- Señales DUT
    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal sensor_in     : std_logic := '0';
    signal sensor_exit    : std_logic := '0';

    signal pieza_ready_in  : std_logic;
    signal pieza_ready_exit : std_logic;
    signal estado_in       : std_logic;
    signal estado_exit      : std_logic;

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin

    -- Reloj
    clk <= not clk after CLK_PERIOD / 2;

    -- Instancia del DUT
    DUT : entity work.Gestor_Sensores
        port map(
            clk             => clk,
            reset           => reset,
            sensor_in       => sensor_in,
            sensor_exit      => sensor_exit,
            pieza_ready_in  => pieza_ready_in,
            pieza_ready_exit => pieza_ready_exit,
            estado_in       => estado_in,
            estado_exit      => estado_exit
        );

    -- Estímulos
    stim_proc : process
    begin
        -- RESET
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        -- Sensor de entrada se activa
        wait for 40 ns;
        sensor_in <= '1';
        wait for 80 ns;
        sensor_in <= '0';

        -- Sensor de salida se activa
        wait for 60 ns;
        sensor_exit <= '1';
        wait for 80 ns;
        sensor_exit <= '0';

        -- Activación simultánea
        wait for 60 ns;
        sensor_in  <= '1';
        sensor_exit <= '1';

        wait for 60 ns;
        sensor_in  <= '0';
        sensor_exit <= '0';

        -- Fin
        wait for 100 ns;
        assert false report "FIN DE LA SIMULACION" severity failure;
    end process;

end architecture;
