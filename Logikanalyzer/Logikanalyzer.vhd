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
end Behavioral;
