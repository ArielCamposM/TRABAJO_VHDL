library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux7Seg_Piezas is
    Port (
        clk     : in std_logic;
        reset   : in std_logic;
        unidades : in std_logic_vector(3 downto 0);
        decenas  : in std_logic_vector(3 downto 0);
        seg     : out std_logic_vector(6 downto 0);
        an      : out std_logic_vector(3 downto 0)
    );
end entity;

architecture Behavioral of Mux7Seg_Piezas is

    signal refresh_cnt : unsigned(15 downto 0) := (others => '0');
    signal sel_digit   : std_logic := '0';
    signal digit       : std_logic_vector(3 downto 0);

begin

-- Divisor simple de frecuencia para multiplexar
process(clk, reset)
begin
    if reset='1' then
        refresh_cnt <= (others=>'0');
    elsif rising_edge(clk) then
        refresh_cnt <= refresh_cnt + 1;
    end if;
end process;

sel_digit <= refresh_cnt(15); -- alterna anodos entre uds y dec

-- Selección del dígito activo
digit <= unidades when sel_digit='0' else decenas;

an <= "1110" when sel_digit='0' else
      "1101";  -- solo usamos 2 displays

-- DECODER integrado (sin módulos externos)
with digit select
    seg <= "0000001" when "0000",  -- 0
           "1001111" when "0001",  -- 1
           "0010010" when "0010",  -- 2
           "0000110" when "0011",  -- 3
           "1001100" when "0100",  -- 4
           "0100100" when "0101",  -- 5
           "0100000" when "0110",  -- 6
           "0001111" when "0111",  -- 7
           "0000000" when "1000",  -- 8
           "0000100" when "1001",  -- 9
           "1111111" when others;  -- apagado

end Behavioral;
