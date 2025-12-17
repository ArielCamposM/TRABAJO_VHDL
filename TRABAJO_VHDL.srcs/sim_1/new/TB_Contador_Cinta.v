library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Contador_Cinta is
end tb_Contador_Cinta;

architecture Behavioral of tb_Contador_Cinta is

    component Contador_Cinta
        Port (
            clk           : in std_logic;
            reset         : in std_logic;
            inc           : in std_logic;
            dec           : in std_logic;
            code          : out std_logic_vector(3 downto 0);
            cinta_ocupada : out std_logic
        );
    end component;

    signal clk_tb           : std_logic := '0';
    signal reset_tb         : std_logic := '0';
    signal inc_tb           : std_logic := '0';
    signal dec_tb           : std_logic := '0';
    signal code_tb          : std_logic_vector(3 downto 0);
    signal cinta_ocupada_tb : std_logic;


    constant CLK_PERIOD : time := 10 ns;

begin

    -- UUT
    uut: Contador_Cinta
        port map (
            clk           => clk_tb,
            reset         => reset_tb,
            inc           => inc_tb,
            dec           => dec_tb,
            code          => code_tb,
            cinta_ocupada => cinta_ocupada_tb
        );

   --Clock
    process
    begin
        while true loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Estimulos
    stim_proc: process
    begin
        -- Reset inicial
        reset_tb <= '0';
        wait for 100 ns;
        reset_tb <= '1';
        wait for CLK_PERIOD;

        --Vamos a 9
        
        for i in 1 to 9 loop
            wait until rising_edge(clk_tb);
            inc_tb <= '1';  
            wait until rising_edge(clk_tb);
            inc_tb <= '0';  
            
            wait for 20 ns; -- Espera visual
        end loop;

       
        wait for 50 ns;

       --Probamos a subir por encima de 9
        wait until rising_edge(clk_tb);
        inc_tb <= '1'; 
        wait until rising_edge(clk_tb);
        inc_tb <= '0';
        
     
        wait for 50 ns;

        --Vamos a 0
        
        for i in 1 to 9 loop
            wait until rising_edge(clk_tb);
            dec_tb <= '1'; 
            wait until rising_edge(clk_tb);
            dec_tb <= '0';
            wait for 20 ns;
        end loop;
        
        
        wait for 50 ns;

        --Intentamos bajar por debajo de 0
        report "Probando saturacion inferior (dec estando en 0)...";
        wait until rising_edge(clk_tb);
        dec_tb <= '1';
        wait until rising_edge(clk_tb);
        dec_tb <= '0';

        
        wait for 50 ns;

      --Probamos inc y dec a la vez
        -- Subimos a 1 primero 
        wait until rising_edge(clk_tb); inc_tb <= '1'; wait until rising_edge(clk_tb); inc_tb <= '0';
        wait for 20 ns;
        
        -- Los dos a la vez
        wait until rising_edge(clk_tb);
        inc_tb <= '1';
        dec_tb <= '1';
        wait until rising_edge(clk_tb);
        inc_tb <= '0';
        dec_tb <= '0';

        
        report "Simulacion finalizada.";
        wait;
    end process;

end Behavioral;
