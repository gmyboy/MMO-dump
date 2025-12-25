param(
    [string]$FolderName,
    [string]$AuthorName
)

if (-not $FolderName -or -not $AuthorName) {
    Write-Host "Usage: .\build_mod.ps1 <folder_name> <author_name>"
    exit 1
}

$InfoFile = "$FolderName\info.xml"
$ZipFile = "$FolderName.zip"

if (-not (Test-Path $FolderName)) {
    Write-Host "Error: Folder '$FolderName' does not exist."
    exit 1
}

if (-not (Test-Path $InfoFile)) {
    Write-Host "Error: '$FolderName' is not a valid MMO mod (missing info.xml)."
    exit 1
}

# Backup original info.xml
$BackupFile = "$InfoFile.bak"
Copy-Item $InfoFile $BackupFile

# Update author in info.xml temporarily
$content = Get-Content $InfoFile -Raw -Encoding UTF8
$content = $content -replace 'author=""', "author=`"$AuthorName`""
[IO.File]::WriteAllText($InfoFile, $content, [System.Text.Encoding]::UTF8)

# Create zip file with contents of the folder, excluding the backup
Get-ChildItem $FolderName | Where-Object { $_.Name -ne 'info.xml.bak' } | Compress-Archive -DestinationPath $ZipFile -Force

# Restore original info.xml
Move-Item $BackupFile $InfoFile -Force

Write-Host "Successfully created $ZipFile with author set to '$AuthorName'."