library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Contador_Pieza is
    Port (
        clk    : in std_logic;
        reset   : in std_logic;
        inc     : in std_logic; -- pieza_expulsada (pulso)
        unidades    : out std_logic_vector(3 downto 0); -- BCD 0..9
        decenas   : out std_logic_vector(3 downto 0) -- BCD 0..9
     );
end entity;

architecture Behavioral of Contador_Pieza is
    signal unidades_int : unsigned(3 downto 0);    
    signal decenas_int : unsigned(3 downto 0);
    
begin

process(clk, reset)
begin
    if reset = '1' then
        unidades_int <= (others=>'0');
        decenas_int <= (others=>'0');
        
    elsif rising_edge(clk) then
        if inc = '1' then
            if unidades_int = 9 then
                unidades_int <= (others=>'0');
            if decenas_int = 9 then
                    decenas_int <= (others => '0');
                else
                    decenas_int <= decenas_int + 1;
                end if;
          else
            unidades_int <=unidades_int+1;
            end if;  
        end if;
    end if;
end process;

unidades <= std_logic_vector(unidades_int);
decenas <= std_logic_vector(decenas_int);

end Behavioral;
