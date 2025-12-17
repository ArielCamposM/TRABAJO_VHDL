library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_Temporizador is
end entity;

architecture Behavioral of TB_Temporizador is

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal tick_1ms : std_logic;

begin

    clk <= not clk after CLK_PERIOD/2;
  
    DUT : entity work.Temporizador
        port map(
            clk      => clk,
            reset    => reset,
            tick_1ms => tick_1ms
        );

    stim_proc : process
    begin
        wait for 50 ns;
        reset <= '1';
        wait for 5 ms; --veremos cinco pulsos del temporizador

        assert false report "Fin de simulación" severity failure;
    end process;

end architecture;
