library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CNTRL_Cinta is
    port(
        clk             : in  std_logic;
        reset           : in  std_logic;

        pieza_ready_in  : in  std_logic;      -- pulso desde gestor sensores
        estado_out      : in  std_logic;      -- nivel estable sensor salida

        tick_1ms        : in  std_logic;      -- del temporizador

        cmd_push       : out std_logic;      -- 1s
        cmd_move       : out std_logic;      -- continuo
        cmd_eject      : out std_logic;      -- 1s

        pieza_expulsada : out std_logic       -- pulso al contador
    );
end entity;

architecture Behavioral of CNTRL_Cinta is

    type state_type is (IDLE, PUSH, MOVE, EJECT);
    signal state      : state_type := IDLE;

    signal counter_ms : unsigned(15 downto 0) := (others => '0');
    signal pieza_out_mem : std_logic := '0';  -- para recordar si había pieza

begin

    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            counter_ms <= (others => '0');
            cmd_push <= '0';
            cmd_move <= '0';
            cmd_eject <= '0';
            pieza_expulsada <= '0';
            pieza_out_mem <= '0';

        elsif rising_edge(clk) then

            pieza_expulsada <= '0'; -- valor por defecto

            case state is

                --------------------------------------------------------
                when IDLE =>
                    cmd_push <= '0';
                    cmd_move <= '0';
                    cmd_eject <= '0';

                    if pieza_ready_in = '1' then
                        state <= PUSH;
                        counter_ms <= (others => '0');
                    end if;

                --------------------------------------------------------
                when PUSH =>
                    cmd_push <= '1';  -- empujar 1 segundo

                    if tick_1ms = '1' then
                        counter_ms <= counter_ms + 1;
                    end if;

                    if to_integer(counter_ms) = 1000 then
                        cmd_push <= '0';
                        state <= MOVE;
                    end if;
                   

                --------------------------------------------------------
                when MOVE =>
                    cmd_move <= '1';  -- mover hasta sensor de salida

                    if estado_out = '1' then
                        pieza_out_mem <= '1';   -- había pieza real
                        state <= EJECT;
                        counter_ms <= (others => '0');
                    end if;

                --------------------------------------------------------
                when EJECT =>
                    cmd_move <= '0';
                    cmd_eject <= '1';

                    if tick_1ms = '1' then
                        counter_ms <= counter_ms + 1;
                    end if;

                    if to_integer(counter_ms) = 1000 then
                        cmd_eject <= '0';

                        if pieza_out_mem = '1' then
                            pieza_expulsada <= '1';  -- pulso para el contador
                        end if;

                        pieza_out_mem <= '0';
                        state <= IDLE;
                    end if;

            end case;
        end if;
    end process;

end Behavioral;
