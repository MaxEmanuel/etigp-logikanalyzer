library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity VgaCore is
	Port(
		clock : in   std_logic;

		hsync : out  std_logic;
		vsync : out  std_logic;
		red   : out  std_logic_vector(1 downto 0);
		green : out  std_logic_vector(1 downto 0);
		blue  : out  std_logic_vector(1 downto 0)
	);
end VgaCore;

architecture Behavioral of VgaCore is
	signal clock25        : std_logic := '0';
	
	constant ScreenWidth  : integer := 640;
	constant ScreenHeight : integer := 480;

	signal currentRow     : integer range 0 to 524 := 0;
	signal currentColumn  : integer range 0 to 799 := 0;
	
	signal isVisible : boolean := true;
begin
	-- Den Takt halbieren, das heiﬂt, eine 25 MHz-Clock erzeugen (Pixeltakt)
	process(clock)
	begin
		if rising_edge(clock) then
			clock25 <= not clock25;
		end if;
	end process;

	-- Pr¸fung, ob momentan im sichtbaren Bereich.
	isVisible <= (currentColumn < ScreenWidth) and (currentRow < ScreenHeight);
	
	-- Erzeugung des VGA-Signals.
	process(clock25)
	begin
		if rising_edge(clock25) then
			-- currentColumn und currentRow hochz‰hlen
			currentColumn <= currentColumn + 1;
		
			if (currentColumn = 799) then
				currentColumn <= 0;
				currentRow <= currentRow + 1;
			end if;
			
			if (currentRow = 524) then
				currentRow <= 0;
			end if;
	
			-- Hier wird gezeichnet
			if isVisible then
				-- zeichnen
				red <= "11";
				green <= "00";
				blue <= "00";
			else
				-- blank
				red <= "00";
				green <= "00";
				blue <= "00";
			end if;		

			-- Verarbeitung der Sync-Signale
			-- Pr¸fen, ob horizontal sync auf low gesetzt werden muss...
			if (currentColumn >= ScreenWidth + 16) and (currentColumn < ScreenWidth + 16 + 96) then
				hsync <= '0';
			else
				hsync <= '1';
			end if;

			-- Pr¸fen, ob vertical sync auf low gesetzt werden muss...
			if (currentRow >= ScreenHeight + 10) and (currentRow < ScreenHeight + 10 + 2) then
				vsync <= '0';
			else
				vsync <= '1';
			end if;
		end if;
	end process;	
end Behavioral;
