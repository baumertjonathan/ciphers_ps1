
<#
setup

. ./trifid_cipher.ps1



TrifidCipher -Text "Hello There" -Key "EPSDUCVWYM.ZLKXNBTFGORIJHAQ"

#> 

function TrifidCipher {
    Param(
        [switch]$Decrypt,
        [string]$Text,
        [string]$Key,
        [int]   $Period
    )
    #Variables
    [string]$validatestring = "abcdefghijklmnopqrstuvwxyz.";
    [string]$allInputString = "";
    $Box1 = New-Object 'string[,]' 3,3;
    $Box2 = New-Object 'string[,]' 3,3;
    $Box3 = New-Object 'string[,]' 3,3;
    $EncodedArray = @();
    $PeriodArray = @();
    $PeriodString = "";
    
    #Normalize Inputs
    $Key = $Key.ToLower();
    $Text = $Text.ToLower();
    $Text = $Text.Replace(" ", "");
    
    #Validate
    if($Key.Length -ne 27){
        throw 'Invalid Key Length'
    }
    for($i = 0; $i -lt 27; $i++){
        if($validatestring.IndexOf($Key[$i]) -eq -1){
            throw 'Invalid Key';
        }
    }

    #Split key into boxes
    $KeyIndex = 0;
    $boxes = @($Box1, $Box2, $Box3);

    foreach($box in $boxes){
        for($j = 0; $j -lt 3; $j++){
            for($k = 0; $k -lt 3; $k++){
                $box[$j, $k] = $Key[$KeyIndex];
                $KeyIndex++;
            }
        }
    }
    Write-Host($boxes);
    #Encode
    for($l = 0; $l -lt $Text.Length; $l++){
        for($b = 0; $b -lt 3; $b++){
            for($i = 0; $i -lt 3; $i++){
                for($j = 0; $j -lt 3; $j++){
                    if($boxes[$b][$i, $j] -eq $Text[$l]){
                        $EncodedArray += ,@($b, $i, $j); #https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.1#comma-operator-
                    }
                }
            }
        }
    }

    #split into periods
    $splitCounter = 0;
    $tempPeriod = @();
    for($i = 0; $i -lt $EncodedArray.Length; $i++){
        while($splitCounter -lt $Period -and ($i -lt $EncodedArray.Length)){
            $tempPeriod += ,$EncodedArray[$i];
            $splitCounter++;
            $i++;
        }
        $splitCounter = 0;
        $PeriodArray += ,$tempPeriod;
        $tempPeriod = @();
        $i--;
    }

    foreach($PeriodSection in $PeriodArray){
        for($i = 0; $i -lt 3; $i++){
            for($j = 0; $j -lt $PeriodSection.Length; $j++){
                Write-Host($PeriodSection[$j][$i]);
                $PeriodString += $PeriodSection[$j][$i];
            }
        }
        $PeriodString += " ";
    }
    Write-Host("period string:", $PeriodString);

    $counter = 0;
    for($i = 0; $i -lt $PeriodString.Length; $i ++){
        while($counter -lt 3){
            $counter++;
        }
        $counter = 0;
    }

    Write-Host($Text);
    for($i = 0; $i -lt 3; $i++){
        $temp = "";
        for($j = 0; $j -lt $EncodedArray.Length; $j++){
            $temp += $EncodedArray[$j][$i];
        }
        Write-Host($temp);
        $temp = "";
    }
    
    #Decrypt
}