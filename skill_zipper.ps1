# Provide `tobeZipped` and `dirName`

$tobeZipped = ".\skills"
# $tobeZipped = "C:\Users\maz\gstack"
$dirName = ".\outZips"

# Create output directory on your Desktop
$baseDir = "$HOME\dev\Projects_\SaaS\agent-skills"
$outDir = "$baseDir\outZips\$dirName"

echo "Zipping file in the folder: $outDir"
New-Item -ItemType Directory -Force -Path $outDir

# Get all skill directories from gstack
$skills = Get-ChildItem -Path "$tobeZipped" -Directory | Where-Object { 
    Test-Path "$($_.FullName)\SKILL.md" 
}

# Zip each skill folder
foreach ($skill in $skills) {
    $zipPath = Join-Path $outDir "$($skill.Name).zip"
    Compress-Archive -Path "$($skill.FullName)\*" -DestinationPath $zipPath -Force
    Write-Host "Created: $($skill.Name).zip"
}

Write-Host "`nAll skills zipped to: $outDir"