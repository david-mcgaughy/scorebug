# --- CONFIGURATION ---
$driverPath = "C:\Scoreboard\chromedriver"
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$outputFile = "C:\Scoreboard\SkordleScores.csv"

Import-Module Selenium -ErrorAction Stop

# --- SETUP CHROME ---
$opts = New-Object OpenQA.Selenium.Chrome.ChromeOptions
$opts.BinaryLocation = $chromePath
$opts.AddArgument("--headless=new")
$opts.AddArgument("--disable-gpu")

$service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($driverPath)
$service.HideCommandPromptWindow = $true

$Driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($service, $opts)

# --- DATE SETUP ---
$today = (Get-Date).ToString("yyyy-MM-dd")

$urls = @{
    "Girls" = "https://skordle.com/scores/3/83/Oklahoma_Class_B-I_Girls_Basketball_Scores?dateweek=$today&clubid=1"
    "Boys"  = "https://skordle.com/scores/2/76/Oklahoma_Class_B-I_Boys_Basketball_Scores?dateweek=$today&clubid=1"
}

$results = @()

foreach ($category in $urls.Keys) {

    Write-Host "Loading $category..."

    $Driver.Navigate().GoToUrl($urls[$category])
    Start-Sleep -Seconds 4

    # find all game boxes
    $games = $Driver.FindElements([OpenQA.Selenium.By]::CssSelector(".scoretable"))

    if ($games.Count -eq 0) {
        Write-Host "No games for $category"
        continue
    }

    foreach ($g in $games) {

        $rows = $g.FindElements([OpenQA.Selenium.By]::CssSelector("tr"))

        if ($rows.Count -lt 2) { continue }

        #
        # --- VISITING TEAM ---
        #
        $visTeamElems = $rows[0].FindElements([OpenQA.Selenium.By]::CssSelector(".teamcell"))
        $visName = if ($visTeamElems.Count -gt 0) { $visTeamElems[0].Text.Trim() } else { "" }

        $visScoreElems = $rows[0].FindElements([OpenQA.Selenium.By]::CssSelector(".scorecell"))
        $visScore = if ($visScoreElems.Count -gt 0) { $visScoreElems[0].Text.Trim() } else { "" }

        #
        # --- HOME TEAM ---
        #
        $homeTeamElems = $rows[1].FindElements([OpenQA.Selenium.By]::CssSelector(".teamcell"))
        $homeName = if ($homeTeamElems.Count -gt 0) { $homeTeamElems[0].Text.Trim() } else { "" }

        $homeScoreElems = $rows[1].FindElements([OpenQA.Selenium.By]::CssSelector(".scorecell"))
        $homeScore = if ($homeScoreElems.Count -gt 0) { $homeScoreElems[0].Text.Trim() } else { "" }

        #
        # --- GAME STATE (3rd row might not exist!) ---
        #
        $gameState = ""

        if ($rows.Count -ge 3) {
            $progElems = $rows[2].FindElements([OpenQA.Selenium.By]::CssSelector(".progresscell"))
            if ($progElems.Count -gt 0) {
                $gameState = $progElems[0].Text.Trim()
            }
        }

        #
        # --- CLEANUP ---
        #

        # remove '@'
        $homeName = $homeName.TrimStart('@')

        # remove bogus scores
        if ($visScore -notmatch '^\d+$') { $visScore = "" }
        if ($homeScore -notmatch '^\d+$') { $homeScore = "" }

        # add to results
        $results += [PSCustomObject]@{
            Category  = $category
            AwayTeam  = $visName
            AwayScore = $visScore
            HomeTeam  = $homeName
            HomeScore = $homeScore
            GameState = $gameState
            Date      = $today
        }
    }
}

$results | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

Write-Host "SkordleScores.csv updated."

$Driver.Quit()
