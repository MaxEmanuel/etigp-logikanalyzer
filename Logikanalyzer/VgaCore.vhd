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
	signal currentRow     : unsigned(9 downto 0) := (others => '0');
	signal currentColumn  : unsigned(9 downto 0) := (others => '0');
	signal clock25        : std_logic := '0';
	
	constant ScreenWidth  : integer := 640;
	constant ScreenHeight : integer := 480;
		
begin
	
	process(clock)
	begin
		if rising_edge(clock) then
			clock25 <= not clock25;
		end if;
	end process;
	
	process(clock25)
	begin
		if rising_edge(clock25) then
			if (currentColumn >= 640 + 16) and (currentColumn <= 640 + 16 + 96) then
				hsync <= '0';
			else
				hsync <= '1';
			end if;
			
			if (currentColumn >= 799) then
				currentColumn <= (others => '0');
				
				if (currentRow >= 524) then
					currentRow <= (others => '0');
				else
					currentRow <= currentRow + 1;
				end if;
			else
				currentColumn <= currentColumn + 1;
			end if;
			
			if (currentColumn >= 640) or (currentRow >= 480) then
				red <= "00";
				blue <= "00";
				green <= "00";
			else
				red <= "11";
				blue <= "00";
				green <= "00";
			end if;
			
			if (currentRow >= 492) and (currentRow <= 493) then
				vsync <= '0';
			else
				vsync <= '1';
			end if;
		end if;
	end process;
	
end Behavioral;
