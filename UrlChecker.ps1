$csv = Import-Csv "$PSScriptRoot\Urls.csv"
$outFile = "$PSScriptRoot\Results.csv"

'"ShortLink","Redirect","Result"' | Out-File -FilePath $outFile -Append
$lines = @()
$csv| ForEach-Object {
    
    Write-Host "Checking if" $_.ShortLink "redirects to:" $_.Redirect
    $line = $_

    $Response = Invoke-WebRequest -URI $_.ShortLink -UseBasicParsing
    Write-Host $Response.BaseResponse.ResponseUri
    
    if ($Response.BaseResponse.ResponseUri –eq $_.Redirect) {
         $result = "Works"
    } else {
         $result = "Failed"
    }

    Write-Host $line
    $line | Add-Member -NotePropertyName Result -NotePropertyValue $result
    $lines += $line
     
}

$lines | Export-Csv -Path $outFile -NoTypeInformation

# $_.ShortLink + ","  + $_.Redirect + "," + $result | Out-File -FilePath $outFile -Append