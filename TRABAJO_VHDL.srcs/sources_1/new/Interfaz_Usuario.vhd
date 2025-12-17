library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Interfaz_Usuario is
    port(
        clk         : in  std_logic;
        reset       : in  std_logic;

        -- Entradas físicas post debouncer
        sw_sensor_in  : in std_logic;
        sw_sensor_out : in std_logic;

        -- Señales internas 
        act1_push   : in std_logic;
        act2_move   : in std_logic;
        act3_eject  : in std_logic;

        count_cinta  : in std_logic_vector(3 downto 0);
        count_piezas : in std_logic_vector(7 downto 0); 

        -- Salidas físicas
        led         : out std_logic_vector(2 downto 0);
        seg         : out std_logic_vector(6 downto 0);
        an          : out std_logic_vector(7 downto 0);

        -- Salidas hacia el sistema
        sensor_in   : out std_logic;
        sensor_exit : out std_logic
    );
end entity;

architecture Behavioral of Interfaz_Usuario is

    --Contador para multiplexado
    signal mux_count : unsigned(15 downto 0) := (others => '0');
    signal seleccion : unsigned(2 downto 0) := (others => '0');

    -- dígitos a mostrar
    signal dig0, dig1 : std_logic_vector(3 downto 0);

    -- BCD seleccionado
    signal bcd_sel : std_logic_vector(3 downto 0);

begin
    -- Entradas físicas -> sistema
    sensor_in   <= sw_sensor_in;
    sensor_exit <= sw_sensor_out;

    -- LEDs de actuadores
    led(0) <= act1_push;   -- motor entrada
    led(1) <= act2_move;   -- motor cinta
    led(2) <= act3_eject;  -- motor salida

   
    dig0 <= count_piezas(3 downto 0); --Unidades
    dig1 <= count_piezas(7 downto 4); --Decenas
    
 
    process(clk, reset)
    begin
        if reset = '0' then
            mux_count <= (others => '0');
            seleccion <= (others => '0');

        elsif rising_edge(clk) then
            mux_count <= mux_count + 1;
   
            if mux_count = 0 then
                seleccion <= seleccion + 1;
            end if;
        end if;
    end process;

    

  --Multiplexado
    
   process(seleccion, dig0, dig1, count_cinta)
    begin
        
        an <= "11111111"; 
        bcd_sel <= "1111"; 

        case seleccion is
            
            when "000" => 
                an <= "11111110"; -- Display 1 activo
                bcd_sel <= dig0;
                
            when "001" => 
                an <= "11111101"; --Display 2 activo
                bcd_sel <= dig1;
                
           
            when "100" =>
                an <= "11101111"; --Display 5 activo
                bcd_sel <= count_cinta;
            
            when others =>
                an <= "11111111"; 
                bcd_sel <= "1111";
        end case;
    end process;

    -- Decodificador BCD -> 7 segmentos 
    with bcd_sel select
        seg <= "0000001" when "0000", -- 0
               "1001111" when "0001", -- 1
               "0010010" when "0010", -- 2
               "0000110" when "0011", -- 3
               "1001100" when "0100", -- 4
               "0100100" when "0101", -- 5
               "0100000" when "0110", -- 6
               "0001111" when "0111", -- 7
               "0000000" when "1000", -- 8
               "0000100" when "1001", -- 9
               "1111111" when others; 

end Behavioral;
