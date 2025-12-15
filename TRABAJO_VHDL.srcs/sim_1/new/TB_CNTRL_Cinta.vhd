library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_CNTRL_Cinta is
end entity;

architecture Behavioral of TB_CNTRL_Cinta is

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';

    signal pieza_ready_in : std_logic := '0';
    signal estado_exit    : std_logic := '0';
    signal tick_1ms       : std_logic := '0';
    signal cinta_ocupada  : std_logic := '0';

    signal cmd_push        : std_logic;
    signal cmd_move        : std_logic;
    signal cmd_eject       : std_logic;
    signal pieza_expulsada : std_logic;

    signal piezas_tb : integer := 0;--Contador piezas (solo TB)

begin

    clk <= not clk after CLK_PERIOD/2;


    tick_proc : process
    begin
        tick_1ms <= '0';
        wait for 1 us;
        tick_1ms <= '1';
        wait for CLK_PERIOD;
    end process;

    UUT : entity work.CNTRL_Cinta
        port map(
            clk             => clk,
            reset           => reset,
            pieza_ready_in  => pieza_ready_in,
            estado_exit     => estado_exit,
            tick_1ms        => tick_1ms,
            cinta_ocupada   => cinta_ocupada,
            cmd_push        => cmd_push,
            cmd_move        => cmd_move,
            cmd_eject       => cmd_eject,
            pieza_expulsada => pieza_expulsada
        );

 --Modelado Cinta
    process(clk, reset)
    begin
        if reset = '1' then
            piezas_tb <= 0;
            cinta_ocupada <= '0';

        elsif rising_edge(clk) then
            if pieza_ready_in = '1' then
                piezas_tb <= piezas_tb + 1;
            end if;

            if pieza_expulsada = '1' then
                piezas_tb <= piezas_tb - 1;
            end if;

            if piezas_tb > 0 then
                cinta_ocupada <= '1';
            else
                cinta_ocupada <= '0';
            end if;
        end if;
    end process;

--Estimulos
    stim_proc : process
    begin
    
        wait for 5 us;
        reset <= '0';

  --Entrada pieza 1
        wait for 10 us;
        pieza_ready_in <= '1';
        wait for CLK_PERIOD;
        pieza_ready_in <= '0';

     --Entrada pieza 2
        wait for 20 us;
        pieza_ready_in <= '1';
        wait for CLK_PERIOD;
        pieza_ready_in <= '0';

       --Expulsion pieza 1
        wait for 200 us;
        estado_exit <= '1';
        wait for 10 us;
        estado_exit <= '0';

 --Expulsion pieza 2
        wait for 200 us;
        estado_exit <= '1';
        wait for 10 us;
        estado_exit <= '0';

        wait for 300 us;
        assert false report "Fin de simulacion" severity failure;
    end process;

end architecture;