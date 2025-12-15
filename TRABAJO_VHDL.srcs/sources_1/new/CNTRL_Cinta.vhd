library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CNTRL_Cinta is
    port(
        clk             : in  std_logic;
        reset           : in  std_logic;

        pieza_ready_in  : in  std_logic;--Pulso desde gestor sensores
        estado_exit     : in  std_logic;

        tick_1ms        : in  std_logic;--pulso periodico de 1 ms
                
        cinta_ocupada   : in  std_logic;

        cmd_push        : out std_logic;-- Actuador de entrada 1s
        cmd_move        : out std_logic;-- Cinta
        cmd_eject       : out std_logic;-- Actuador de salida 1s

        pieza_expulsada : out std_logic
    );
end entity;

architecture Behavioral of CNTRL_Cinta is

    -- FSM de empuje
    type FSM_Push is (P_IDLE, P_PUSH);
    signal push_state : FSM_Push := P_IDLE;
    signal push_count   : unsigned(15 downto 0) := (others => '0');

    -- FSM de expulsión
    type FSM_Eject is (E_IDLE, E_EJECT);
    signal eject_state : FSM_Eject := E_IDLE;
    signal eject_count   : unsigned(15 downto 0) := (others => '0');

begin
    --FSM PUSH
    process(clk, reset)
    begin
        if reset = '1' then
            push_state <= P_IDLE;
            push_count   <= (others => '0');
            cmd_push   <= '0';

        elsif rising_edge(clk) then
            case push_state is
                when P_IDLE =>
                    cmd_push <= '0';
                    if pieza_ready_in = '1' then
                        push_state <= P_PUSH;
                        push_count   <= (others => '0');
                    end if;

                when P_PUSH =>
                    cmd_push <= '1';
                    if tick_1ms = '1' then
                        push_count <= push_count + 1;
                    end if;

                    if push_count = 500 then
                        cmd_push   <= '0';
                        push_state <= P_IDLE;
                    end if;
            end case;
        end if;
    end process;

 --FMS EJECT
    process(clk, reset)
    begin
        if reset = '1' then
            eject_state      <= E_IDLE;
            eject_count        <= (others => '0');
            cmd_eject        <= '0';
            pieza_expulsada  <= '0';

        elsif rising_edge(clk) then
            pieza_expulsada <= '0';

            case eject_state is
                when E_IDLE =>
                    cmd_eject <= '0';
                    if estado_exit = '1' then
                        eject_state <= E_EJECT;
                        eject_count   <= (others => '0');
                    end if;

                when E_EJECT =>
                    cmd_eject <= '1';
                    if tick_1ms = '1' then
                        eject_count <= eject_count + 1;
                    end if;

                    if eject_count = 500 then
                        cmd_eject       <= '0';
                        eject_state     <= E_IDLE;
                        pieza_expulsada <= '1';
                    end if;
            end case;
        end if;
    end process;

    cmd_move <= '1' when cinta_ocupada > '0' else '0';
    

end Behavioral;