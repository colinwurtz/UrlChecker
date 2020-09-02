$csv = Import-Csv "$PSScriptRoot\Urls.csv"
$outFile = "$PSScriptRoot\Results.csv"

'"ShortLink","Redirect","Result"' | Out-File -FilePath $outFile -Append
$lines = @()
$csv| ForEach-Object {
    
    Write-Host "Checking if" $_.ShortLink "redirects to:" $_.Redirect
    $line = $_

    $Response = Invoke-WebRequest -URI $_.ShortLink -UseBasicParsing
    Write-Host $Response.BaseResponse.uri

    
    
    if ($Response.BaseResponse.ResponseUri –eq $_.Redirect) {
         $result = "Works"
    } else {
        #Double redirect
        Write-Host "Double redirect check, if " $Response.BaseResponse.ResponseUri "redirects"
        $DoubleRedirect = Invoke-WebRequest -URI $Response.BaseResponse.ResponseUri -UseBasicParsing

        if ($DoubleRedirect.BaseResponse.StatusCode –eq "OK") {
            Write-Host "Double redirect loaded"
            $result = "Works"
        }else{
            $result = "Failed"
        }
    }

    
    $line | Add-Member -NotePropertyName Result -NotePropertyValue $result
    $lines += $line
     
}

$lines | Export-Csv -Path $outFile -NoTypeInformation