# Ordner, in dem dieses PowerShell-Skript liegt
$rootPath = $PSScriptRoot

# Slides-Ordner
$slidesPath = Join-Path $rootPath "slides"

# Ziel-Datei
$jsonPath = Join-Path $rootPath "slides.json"

# Prüfen, ob der Slides-Ordner existiert
if (-not (Test-Path $slidesPath)) {
    Write-Error "Der Ordner 'slides' wurde nicht gefunden."
    exit 1
}

# Alle HTML-Dateien im Slides-Ordner ermitteln
$slides = Get-ChildItem -Path $slidesPath -Filter "*.html" -File |
    Sort-Object Name |
    ForEach-Object {
        "slides/$($_.Name)"
    }

# Prüfen, ob Slides gefunden wurden
if ($slides.Count -eq 0) {
    Write-Warning "Es wurden keine HTML-Dateien im Ordner 'slides' gefunden."
}

# JSON erzeugen
$json = $slides | ConvertTo-Json

# UTF-8 ohne BOM schreiben
$utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)

[System.IO.File]::WriteAllText(
    $jsonPath,
    $json,
    $utf8WithoutBom
)

Write-Host ""
Write-Host "slides.json wurde erfolgreich erstellt."
Write-Host "Gefundene Slides: $($slides.Count)"
Write-Host ""

$slides | ForEach-Object {
    Write-Host " - $_"
}