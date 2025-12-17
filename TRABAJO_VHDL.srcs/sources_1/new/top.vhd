library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port(
        clk   : in  std_logic;                     -- reloj 100 MHz
        reset : in  std_logic;

        SW    : in  std_logic_vector(1 downto 0); -- switches placa
        LED   : out std_logic_vector(2 downto 0); -- leds placa

        AN    : out std_logic_vector(7 downto 0);  -- anodos displays
        SEG   : out std_logic_vector(6 downto 0)   -- segmentos displays
    );
end entity top;

architecture Structural of top is

    -- Señales de sensores
    signal sensor_in  : std_logic;
    signal sensor_exit : std_logic;
    -- Señales después de pasar por el antirrebotes
    signal sw0_debounced : std_logic;
    signal sw1_debounced : std_logic;

    -- Gestor de sensores
    signal pieza_ready_in : std_logic;
    signal estado_exit     : std_logic;

    -- Control de cinta
    signal cmd_push        : std_logic;
    signal cmd_move        : std_logic;
    signal cmd_eject       : std_logic;
    signal pieza_expulsada : std_logic;

    -- Contadores
    signal count_cinta     : std_logic_vector(3 downto 0);
    signal cinta_ocupada : std_logic;

    signal count_piezas    : std_logic_vector(7 downto 0);
    
    --gestor actuadores
    signal act1_push  : std_logic;
    signal act2_move  : std_logic;
    signal act3_eject : std_logic;


    -- Temporizador
    signal tick_1ms : std_logic;

begin
    U_DEBOUNCER_0 : entity work.Debouncer
     port map 
     (
        clk            => clk,
        boton_entrada  => SW(0),
        boton_salida   => sw0_debounced
        );

    U_DEBOUNCER_1 : entity work.Debouncer
     port map 
     (
        clk            => clk,
        boton_entrada  => SW(1),
        boton_salida   => sw1_debounced
      );
    U_UI : entity work.Interfaz_Usuario
        port map(
            clk           => clk,
            reset         => reset,

            -- switches físicos
            sw_sensor_in  => sw0_debounced,
            sw_sensor_out => sw1_debounced,

            -- órdenes a actuadores
            act1_push      => act1_push,
            act2_move      => act2_move,
            act3_eject     => act3_eject,

            -- contadores
            count_cinta     => count_cinta,
            count_piezas    => count_piezas,

            -- salidas físicas
            led           => LED,
            seg           => SEG,
            an            => AN,

            -- sensores hacia el sistema
            sensor_in     => sensor_in,
            sensor_exit    => sensor_exit
        );
    
     U_SENS : entity work.Gestor_Sensores
        port map(
            clk            => clk,
            reset          => reset,
            sensor_in      => sensor_in,
            sensor_exit     => sensor_exit,
            pieza_ready_in => pieza_ready_in,
            estado_exit     => estado_exit
        );
        
     U_TIMER : entity work.Temporizador
        port map(
            clk      => clk,
            reset    => reset,
            tick_1ms => tick_1ms
        );
        
    U_CTRL : entity work.CNTRL_Cinta
        port map(
            clk             => clk,
            reset           => reset,
            pieza_ready_in  => pieza_ready_in,
            estado_exit     => estado_exit,
            tick_1ms        => tick_1ms,
            cinta_ocupada   => cinta_ocupada,
            cmd_push        => cmd_push,
            cmd_move        => cmd_move,
            cmd_eject       => cmd_eject,
            pieza_expulsada => pieza_expulsada
        );
        
    U_CNT_CINTA : entity work.Contador_Cinta
        port map(
            clk       => clk,
            reset     => reset,
            inc       => pieza_ready_in,
            dec       => pieza_expulsada,
            code      => count_cinta,
            cinta_ocupada => cinta_ocupada
        );
        
     U_CNT_PIEZAS : entity work.Contador_Pieza
        port map(
            clk      => clk,
            reset    => reset,
            inc      => pieza_expulsada,
            unidades => count_piezas(3 downto 0),
            decenas  => count_piezas(7 downto 4),
            cinta_activa => cinta_ocupada
        );
          
     U_ACT : entity work.Gestor_Actuadores
       port map(
        clk       => clk,
        reset     => reset,
        cmd_push  => cmd_push,
        cmd_move  => cmd_move,
        cmd_eject => cmd_eject,
        act1_push => act1_push,
        act2_move => act2_move,
        act3_eject=> act3_eject
    );

 end Structural;     
 
        




