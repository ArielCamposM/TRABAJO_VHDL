library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Contador_Pieza is
end tb_Contador_Pieza;

architecture Behavioral of tb_Contador_Pieza is

    component Contador_Pieza
        Port (
            clk      : in std_logic;
            reset    : in std_logic;
            inc      : in std_logic;
            unidades : out std_logic_vector(3 downto 0);
            decenas  : out std_logic_vector(3 downto 0)
        );
    end component;

    signal clk_tb      : std_logic := '0';
    signal reset_tb    : std_logic := '0';
    signal inc_tb      : std_logic := '0';
    signal unidades_tb : std_logic_vector(3 downto 0);
    signal decenas_tb  : std_logic_vector(3 downto 0);
    
    
    constant CLK_PERIOD : time := 10 ns;
 

begin

    
    UUT: Contador_Pieza
        port map (
            clk      => clk_tb,
            reset    => reset_tb,
            inc      => inc_tb,
            unidades => unidades_tb,
            decenas  => decenas_tb
        );

 --Reloj
    process
    begin
        while true loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    --Estimulos
    stim_proc: process
    begin
        -- Estado inicial
        reset_tb <= '0'; 
        inc_tb   <= '0';
        wait for 100 ns;
        
        reset_tb <= '1';
        wait for CLK_PERIOD;

    --Primer tramo de cuenta hasta 25
       
        for i in 1 to 25 loop

            wait until rising_edge(clk_tb);
            inc_tb <= '1';
            wait until rising_edge(clk_tb);
            inc_tb <= '0';
            

            wait for 20 ns; 
        end loop;

        wait for 100 ns;

        --Segundo tramo, vamos pasados los 100 para ver como se comporta del 99 al 00
        
            for i in 1 to 80 loop
            wait until rising_edge(clk_tb);
            inc_tb <= '1';
            wait until rising_edge(clk_tb);
            inc_tb <= '0';
        end loop;

        wait for 50 ns;

        -- Fin de la prueba
        report "Test finalizado.";
        wait;
    end process;

end Behavioral;