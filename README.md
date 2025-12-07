Scoreboard for Basketball

✨ Features
Professional Broadcast Look: Modern design with dynamic animations and team logo integration.
Real-Time Data: Seamlessly integrates with Scoreboard OCR for live clock, score, and foul updates (100ms refresh rate). Alternatively has a browser-based scoreboard controller.
Automated Ticker: Optional PowerShell script scrapes Skordle to display scrolling scores for other games in your class.
Live Configuration: Change team names, logos, records, and colors instantly via a simple JSON file—no need to reload OBS.
Engagement Tools: Automated "Subscribe" popup for YouTube and rotating info bar (Quarter/Game Title).
Smart Logic: Automatically calculates and displays "BONUS" status based on foul counts and highlights the leading score.
📦 Step 1: Extract Files
Download the download.zip file from https://drive.google.com/drive/folders/1msb0gCTU4sKDdi_2ONyjYU292u2fdOBJ?usp=drive_link.
Right-click the zip file and choose Extract All...
Extract the contents to a permanent folder on your computer (e.g., C:\Scoreboard\).
Note: Do not run files from inside the zip folder. Extract them first.

🚫 Disabling the Ticker
If you do not want the scrolling score ticker at the bottom:
Simply delete (or rename) the SkordleScores.csv file.
Do not run the PowerShell script.
The scoreboard will automatically detect that there is no data and hide the ticker drawer completely.
Continue to Step 5: Configure Game Details (JSON)

⚡ Step 2: One-Time PowerShell Setup (if using ticker)
To run the automated ticker (which pulls scores from Skordle), you need to set up your computer to allow the script to run. You only need to do this once.
Open your Start Menu.
Type PowerShell.
Right-click on "Windows PowerShell" and select Run as Administrator.
Copy and paste the following command into the blue window and press Enter:

PS C:\Scoreboard> Set-ExecutionPolicy Bypass -Scope CurrentUser -Force




Next, install the required automation module by pasting this command and pressing Enter:

PS C:\Scoreboard> Install-Module Selenium




If asked to import the NuGet provider or trust the repository, type Y and press Enter.

🛠️ Step 3: Download ChromeDriver
The scraper requires a specific "driver" file to talk to Google Chrome. This is separate from the browser itself.

⚠️ IMPORTANT MAINTENANCE NOTE:
Google Chrome updates automatically. If this script suddenly stops working in the future, it is likely because your Chrome version updated, but your ChromeDriver did not. You will need to repeat this step periodically to match the versions.

Check your Chrome Version:
Open Google Chrome.
Click the three dots (top right) > Help > About Google Chrome.
Note the version number (e.g., 131.0.xxxx.xx).
Go to the Download Page:
Visit: https://googlechromelabs.github.io/chrome-for-testing/
Find the Correct File (IMPORTANT):
Scroll down to the Stable table (or the table matching your version).
Look at the Binary column.
⚠️ CRITICAL: You must select the row that says chromedriver.
Do NOT select the row that just says chrome (that is the web browser application).
Find the URL for win64 (assuming you are on Windows).
Copy that URL and paste it into your browser to download the zip file.
Install:
Open the downloaded zip file.
Inside, you will find chromedriver.exe.
Copy that file and paste it into a folder on your computer (e.g., C:\Scoreboard\chromedriver\).
You will need the path to this file for the next step..

⚙️ Step 4: Configure the Scraper Script 
The script needs to know where you put the files.
Navigate to your scoreboard folder (e.g., C:\Scoreboard\).
Right-click on skordle.ps1 and choose Edit (or Open with Notepad).
Look at the top section labeled # --- CONFIGURATION ---

# --- CONFIGURATION ---
$driverPath = "C:\Scoreboard\chromedriver"  <-- CHANGE THIS
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$outputFile = "C:\Scoreboard\SkordleScores.csv" <-- CHANGE THIS


Update $driverPath: Change this to the folder where you placed chromedriver.exe in Step 3.
Example: C:\Users\YourName\Documents\Scoreboard\chromedriver
Update $outputFile: Change this to the full path where you want the CSV file to be saved (usually the same folder as the script).
Example: C:\Users\YourName\Documents\Scoreboard\SkordleScores.csv
Save the file and close it.
Changing the Sport or Class (Optional)
If you need scores for a different class (e.g., Class 3A instead of B-I), follow these steps to update the $urls list in the script:
Go to Skordle.com and click Scores.
Select the specific Sport.
Right click on your desired class and choose Copy link address if using chrome, other browsers will be phrased similarly, e.g. Firefox says copy link instead of copy link address.
Example: https://skordle.com/scores/3/83/Oklahoma_Class_B-I_Girls_Basketball_Scores?dateweek=2023-12-05&clubid=1
Paste it into the $urls list in the script, but replace the hardcoded date with the $today variable.
Find: dateweek=2023-12-05
Replace with: dateweek=$today
Correct Format: "https://skordle.com/...Scores?dateweek=$today&clubid=1"
Save the file and close it.
Test the Script
Right-click skordle.ps1 and select Run with PowerShell.
A window should pop up briefly (or run in the background), and you should now see teams and scores populated in the SkordleScores.csv file.
Automate the Script (Task Scheduler)
To keep the scores fresh during the game without clicking the script every time, set up a Windows Task.
Open the Start Menu and search for Task Scheduler and open it.
On the right, click Create Task.
General Tab:
Name: Scoreboard Scraper
(Optional) Check "Run whether user is logged on or not" if this is a dedicated streaming PC.
Triggers Tab:
Click New...
Begin the task: On a schedule.
Settings: Select One time.
Start: Verify the Start time is set to the current time (or a few minutes in the past) to ensure it triggers immediately.
Under "Advanced settings", check Repeat task every: and select 5 minutes (or type 5 minutes).
Set for a duration of: Indefinitely.
Click OK.
Actions Tab:
Click New...
Action: Start a program.
Program/script: powershell.exe
Add arguments: -ExecutionPolicy Bypass -File "C:\Scoreboard\Get-SkordleScores.ps1"
Make sure to change the path inside the quotes to where your script actually is.
Click OK.
Click OK to save the task.
Important: In the main list, Right-click your new Scoreboard Scraper task and select Run. This kicks off the cycle immediately.
🎮 Step 5: Configure Game Details (JSON)
You can customize team names, colors, and logos without touching the code.
Open GameConfig.json with Notepad.
Edit the settings between the quotes:

Setting
Description
homeName
Name of the Home Team (e.g., "Boise City").
homeLogo
Filename of the logo in the logos/ folder (e.g., logos/bclogo.png).
homeRecord
Text record to display (e.g., "10-0").
opponentName
Name of the Visiting Team.
opponentLogo
Filename of the opponent logo in the logos/ folder.
gameLevel
Text for the info bar (e.g., "BOYS VARSITY").
youtubeHandle
Your channel name for the popup (e.g., "@bcpsd").
accentColor
Hex color code for highlights (e.g., #FE5C00 for Orange, #FF0000 for Red).
backgroundColor
Background color of the scoreboard. Use #000000 for black, or rgba(...) for transparent.


Save the file. The scoreboard updates automatically every 3 seconds.

🎥 Step 6: Add to OBS Studio
Open OBS Studio.
In your Sources dock, click the + icon and select Browser.
Name it "Scoreboard".
Check the box Local file.
Click Browse and select overlay.html from your folder.
Set Width to 1920 and Height to 1080.
Check Refresh browser when scene becomes active.
Click OK.

🔢 Scoreboard OCR Setup
Scoreboard OCR software is required to automate the clock and score:
Set Output type to HTTP Server.
Set Port to 8080.
Map your fields to: clock, period, home_score, away_score, home_fouls, away_fouls.
⚠️ IMPORTANT: Make sure that you choose the correct format for your fields, e.g. clock should be set to Time(mm:ss, ss.d) for basketball so that it will correctly parse the time when you’re in the last minute of the period.
⚠️ CRITICAL: If you do not name your fields exactly this, you will have to edit the javascript in overlay.html to match your field names or it will not work.
🎛️ Step 7: Optional Manual Control Setup
The scoreboard comes with a browser-based Control Panel (control.html). This allows you to:
Manually update the score/clock if the OCR fails.
Live-edit team names, colors, and logos via a polished interface. (You can still edit the JSON file directly, but this tool makes it easier and provides file browsing).
1. Enable OBS WebSockets
This allows the controller in your web browser to talk to OBS.
In OBS Studio, click Tools in the top menu bar.
Select WebSocket Server Settings.
Check the box Enable WebSocket server.
Set the Server Port to 4455 (default).
Set the Server Password to exactly: ScoreboardRemote
Note: This password is case-sensitive.
Click Apply and OK.
2. Launch the Controller
Ensure the file obs-websocket.min.js is in the same folder as control.html (it should be included in the download).
Double-click control.html to open it in Chrome or Edge.
Look at the status bar at the bottom:
Green Dot: You are connected! You can now control the board.
Red Dot: Connection failed. Check that OBS is open and the password in OBS matches ScoreboardRemote.
3. Using the Controller
Scoreboard Control Tab: Use this for manual scoring.
Clicking START/STOP on the clock or adding points will immediately override the OCR data for 10 seconds to ensure your manual input takes priority.
Game Setup & Logos Tab: Use this for pre-game or mid-game configuration.
Type new team names or records.
Click Browse to select logo images from your computer.
Click Apply to Overlay to instantly update the graphics on the stream.
⚠️ IMPORTANT: Click Download JSON to save these settings permanently. This will download a new gameconfig.json file. You must overwrite the old file in your Scoreboard folder if you want these settings to load automatically next time.

