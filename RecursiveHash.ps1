Clear-Host

$hash=Read-Host "Please enter an MD5 hash value to search"
$outputfolder="C:\test"
$outputfile="hashes.txt"

function HashTheFiles {
Get-ChildItem / -Recurse -ErrorAction SilentlyContinue | Get-FileHash -Algorithm MD5 -ErrorAction SilentlyContinue | Tee $outputfolder\$outputfile | Select-String "$hash"
}

function SearchForHash {
Write-Host "`n"
Write-Host "Scanning existing hashes - to rehash files, delete $outputfolder\$outputfile"
Write-Host "`n"
Get-Content $outputfolder\$outputfile | Select-String "$hash"
}

New-Item -ItemType Directory -Force -Path $outputfolder > $null

if (Test-Path $outputfolder\$outputfile)
{
    SearchForHash    
} else {
    HashTheFiles	
}

Pause
