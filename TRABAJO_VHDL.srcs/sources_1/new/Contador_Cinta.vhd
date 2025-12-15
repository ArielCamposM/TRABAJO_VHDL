library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Contador_Cinta is
    Port (
        clk     : in std_logic;
        reset   : in std_logic;
        inc     : in std_logic; -- pieza_ready_in
        dec     : in std_logic; -- pieza_expulsada
        code    : out std_logic_vector(3 downto 0)
     );
end entity;

architecture Behavioral of Contador_Cinta is
    signal count : unsigned(3 downto 0) := (others => '0');
begin

process(clk, reset)
begin
    if reset = '1' then
        count <= (others=>'0');

    elsif rising_edge(clk) then

        if inc = '1' then
            if count < 9 then
                count <= count + 1;
            end if;

        elsif dec = '1' then
            if count > 0 then
                count <= count - 1;
            end if;
        end if;

    end if;
end process;

code <= std_logic_vector(count);

end Behavioral;
