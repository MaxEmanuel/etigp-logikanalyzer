library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity Logikanalyzer is
	port(
		-- Takt
		clock    : in std_logic;

		-- VGA-Signale
		vgaHsync : out  std_logic;
		vgaVsync : out  std_logic;
		vgaRed   : out  std_logic_vector(1 downto 0);
		vgaGreen : out  std_logic_vector(1 downto 0);
		vgaBlue  : out  std_logic_vector(1 downto 0)
	);
end Logikanalyzer;

architecture Behavioral of Logikanalyzer is
	-- Für RAM-Test siehe unten
	signal ramClock : std_logic;
	signal writeEnable : std_logic_vector(0 downto 0);
	signal address : std_logic_vector(14 downto 0);
	signal dataIn : std_logic_vector(7 downto 0);
	signal dataOut : std_logic_vector(7 downto 0);
begin
	-- Instanzierung der verschiedenen Module
	-- VGA-Signal-Generator
	vga : entity work.VgaCore port map(
		clock => clock,
		hsync => vgaHsync,
		vsync => vgaVsync,
		red => vgaRed,
		green => vgaGreen,
		blue => vgaBlue
	);

	-- RAM
	ram : entity work.BlockRam port map(
		clka => ramClock,
		wea => writeEnable,
		addra => address,
		dina => dataIn,
		douta => dataOut
	);
	
	-- RAM-Test
	-- Funktioniert laut Simulator
	address <= "000000000000000";
	dataIn <= "10101010";
	writeEnable <= "1";
	ramClock <= clock;
end Behavioral;
