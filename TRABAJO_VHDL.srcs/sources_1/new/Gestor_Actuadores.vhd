library ieee;
use ieee.std_logic_1164.all;

entity Gestor_Actuadores is
    port(
        clk      : in  std_logic;
        reset    : in  std_logic;

        cmd_push : in  std_logic;   -- comando desde Control_Cinta
        cmd_move : in  std_logic;
        cmd_eject: in  std_logic;

        act1_push  : out std_logic; -- actuadores reales
        act2_move  : out std_logic;
        act3_eject : out std_logic
    );
end entity;

architecture Behavioral of Gestor_Actuadores is
begin

    process(clk, reset)
    begin
        if reset = '1' then
            act1_push  <= '0';
            act2_move  <= '0';
            act3_eject <= '0';

        elsif rising_edge(clk) then
            act1_push  <= cmd_push;
            act2_move  <= cmd_move;
            act3_eject <= cmd_eject;
        end if;
    end process;

end Behavioral;

