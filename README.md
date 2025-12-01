# Skordle Scoreboard Overlay (Beginner-Friendly Guide)

This project provides a clean, animated scoreboard overlay for livestreaming sports using OBS.  
The system combines:

- ScoreboardOCR for live score detection  
- Selenium + Chrome (Chrome for Testing) for Skordle score scraping  
- A browser-based overlay for OBS  
- A simple configuration file for team and game information  

The goal is to make setup as easy as possible, even for users who are new to OBS or PowerShell.

---

# Features

## Live Scoreboard Overlay
The overlay displays:
- Home and away scores  
- Fouls and bonus indicators  
- Game clock  
- Quarter or period  
- Team logos  
- Team names  
- Team records  
- Game level (e.g., BOYS VARSITY, GIRLS VARSITY)  
- Smooth animations for score changes  
- Highlighting for the leading team  

## Skordle Ticker
The ticker scrolls live scores pulled from Skordle.  
By default, it is configured for **B-I Boys Basketball**, but the PowerShell script can be modified to scrape other sports or classes if needed.

## Simple Configuration
All team and game information is stored in `gameconfig.json`:
- Team names  
- Team logos  
- Team records  
- **Game level (e.g., BOYS VARSITY, GIRLS VARSITY)**  

There is no need to edit the HTML overlay.

## OBS Compatibility
overlay.html loads directly as a Browser Source inside OBS.

---

# Project Structure

    /SkordleScoreboardOverlay
    │
    ├── overlay.html            ← The animated OBS overlay
    ├── gameconfig.json         ← Team and game settings
    ├── SkordleScores.csv       ← Updated automatically by the scraper
    ├── skordle.ps1             ← PowerShell Skordle scraping script
    ├── chromedriver/           ← Chrome for Testing folder
    ├── COPYING                 ← GPL v3 license
    └── README.md               ← This documentation

---

# Required Setup

The following steps must be completed before running the overlay.

---

## 1. Install the PowerShell Selenium Module

Open PowerShell (Run as Administrator) and enter:

    Install-Module Selenium -Scope CurrentUser

This enables PowerShell to control Chrome.

---

## 2. Install Google Chrome + Chrome for Testing  
### (No PATH setup required)

ChromeDriver is now included as part of Chrome for Testing. There is no separate `chromedriver.exe`.

### Step A — Install Google Chrome  
If Chrome is already installed, this step can be skipped.

### Step B — Download Chrome for Testing  
1. Visit:  
   https://googlechromelabs.github.io/chrome-for-testing/#stable  
2. Select your platform (Windows x64).  
3. Download the ZIP file (example: `chrome-win64.zip`).  
4. Extract the ZIP.  
5. Inside the extracted folder, you will see files such as:  
   - chrome.exe  
   - chrome.pak  
   - resources.pak  
   - icudtl.dat  
6. Create a folder named **chromedriver** next to `skordle.ps1`.  
7. Copy all extracted Chrome-for-Testing contents into the `chromedriver` folder.

Your folder layout should look like:

    SkordleScoreboardOverlay/
        overlay.html
        gameconfig.json
        skordle.ps1
        chromedriver/
            chrome.exe
            chrome.pak
            resources.pak
            icudtl.dat
            ...other Chrome files...
        README.md

No PATH or system configuration is necessary.

---

## 3. Install and Run ScoreboardOCR

ScoreboardOCR can be downloaded from:  
https://scoreboard-ocr.com/

It must be running and available at:

    http://localhost:8080/results.json

This provides the overlay with:
- live scores  
- fouls  
- clock updates  
- quarter/period  

If help is needed installing or configuring ScoreboardOCR, their support team is the best point of contact.

---

# Editing gameconfig.json

This file controls all custom game and team settings.

Example:

    {
      "opponentName": "Texhoma",
      "opponentLogo": "texhoma.png",
      "opponentRecord": "8-2",

      "homeTeamName": "Boise City Wildcats",
      "homeTeamLogo": "bclogo.png",
      "homeRecord": "10-0",

      "gameLevel": "BOYS VARSITY"
    }

Notes:
- Put logo image files in the same folder as `overlay.html`.
- PNG images are recommended.
- Keep filenames simple (letters, numbers, underscores).

---

# Example Skordle URLs

The Skordle scraping script uses URLs like these:

    B-I Boys:
    https://skordle.com/scores/2/76/Oklahoma_Class_B-I_Boys_Basketball_Scores?dateweek=&clubid=1

    B-I Girls:
    https://skordle.com/scores/3/83/Oklahoma_Class_B-I_Girls_Basketball_Scores?dateweek=&clubid=1

    Class A Girls:
    https://skordle.com/scores/3/82/Oklahoma_Class_A_Girls_Basketball_Scores?dateweek=&clubid=1

The default script is set to scrape B-I Boys Basketball, but these URLs can be swapped out to scrape other classes or sports if needed.

---

# Running the Skordle Scraper (skordle.ps1)

The scraper opens Chrome, loads a Skordle scoreboard page, extracts the game results, and writes them to `SkordleScores.csv`.  
The ticker in the overlay displays the contents of this CSV file.

### Basic usage:

    ./skordle.ps1

This uses the default class and sport (B-I Boys Basketball).  
To scrape a different class or sport, edit the URL inside the script.

---

# How overlay.html Works

The overlay:
- Reads `gameconfig.json`  
- Reads live scoreboard values from ScoreboardOCR  
- Updates the score and fouls in real time  
- Displays team info and logos  
- Scrolls through Skordle scores from `SkordleScores.csv`  
- Animates score changes  

No HTML editing is needed once your config and files are in place.

---

# Adding the Overlay to OBS

1. Open OBS  
2. In the **Sources** panel, click **+**  
3. Choose **Browser**  
4. Name the source something like “Scoreboard Overlay”  
5. Enable **Local File**  
6. Browse to and select `overlay.html`  
7. Set the following:

       Width: 1920
       Height: 1080
       FPS: 60

8. Recommended settings:
   - “Shutdown source when not visible” → OFF  
   - “Refresh browser when scene becomes active” → ON  

If a logo fails to load, try using a full file path such as:

    file:///C:/OBS/Assets/bclogo.png

---

# License

This project is licensed under **GNU GPL v3**.  
See the COPYING file for details.

---

# Need Help?

If questions come up regarding setup, OBS integration, or modifying the Skordle script, feel free to reach out for guidance.
