function TrifidCipher {
    <#
        .SYNOPSIS
            Encrypts or decrypts a string of text using the trifid cipher
        .DESCRIPTION
            Encrypts or decrypts by first mapping 26 characters to three squares (a period being added to the alphabet), splitting the results by a period then combining the results and enciphering again
            Here is an example with a key of "qwertyuiopasdfghjklzxcvbnm.", a period of 3, and text of "Testing"

            ==Squares==
              0       1       2
            q w e   p a s   l z x
            r t y   d f g   c v b 
            u i o   h j k   n m .

            Text  : t e s t i n g
            Box   : 0 0 1 0 0 2 1
            Row   : 1 0 0 1 2 2 1
            Column: 1 2 2 1 1 0 2

            Split by periods
            tes tin g
            001 002 1
            100 122 1
            122 110 2

            Combine
            001100122 002122110 112

            Encipher again
            Text  : w p k e k d g
            Box   : 0 1 1 0 1 1 1
            Row   : 0 0 2 0 2 1 1
            Column: 1 0 2 2 2 0 2

            The key must have 26 letters and a period.
            The period cannot be longer than the text being enciphered. 
        .EXAMPLE
            TrifidCipher -Text "Hello There" -Key "zxcvbnm.asdfghjklqwertyuiop" -Period 5
            > llayhuosxl
        .EXAMPLE
            TrifidCipher -Text "llayhuosxl" -Key "zxcvbnm.asdfghjklqwertyuiop" -Period 5 -Decrypt
            > hellothere
        .INPUTS
            [switch] Decrypt : if present decrypts rather than encrypts the string of text
            [string] Text    : The string of text to be encrypted or decrypted
            [string] Key     : The key to be used in encrypting or decrypting the text
            [int]    Period  : The period to be used in encrypting or decrypting the text, must be less than the length of the text to be enciphered.
    #>

    Param(
        [switch]$Decrypt,
        [Parameter(Mandatory = $true, ValueFromPipeline=$true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Key,
        [Parameter(Mandatory = $true)][int]   $Period
    )
    #Variables
    [string]$validatestring = "abcdefghijklmnopqrstuvwxyz.";
    $Box1 = New-Object 'string[,]' 3,3;
    $Box2 = New-Object 'string[,]' 3,3;
    $Box3 = New-Object 'string[,]' 3,3;
    [Array]$EncodedArray = @();
    [Array]$PeriodArray = @();
    
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
    #Encode
    if(-not $Decrypt.IsPresent){
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
        for($i = 0; $i -lt 3; $i++){
            $temp = "";
            for($j = 0; $j -lt $EncodedArray.Length; $j++){
                $temp += $EncodedArray[$j][$i];
            }
            $temp = "";
        }
        #split by periods
        for($i = 0; $i -lt $Text.Length; $i++){
            $tempPeriod = @();
            $rowPeriod = @();
            $columnPeriod = @();
            $splitCounter = 0;
            while($splitCounter -lt $Period -and ($i -lt $Text.Length)){
                $tempPeriod += $EncodedArray[$i][0]; #box
                $rowPeriod += $EncodedArray[$i][1]; #row
                $columnPeriod += $EncodedArray[$i][2]; #column
                $splitCounter++;
                $i++;
            }
            $tempPeriod += $rowPeriod;
            $tempPeriod += $columnPeriod;
            $PeriodArray += ,$tempPeriod;
            $i--;
        }
        foreach ($period1 in $PeriodArray) {
            for($i = 0; $i -lt $period1.Length; $i+=3){
                $output += $boxes[$period1[$i]][$period1[$i+1], $period1[$i+2]];
            }
        }
    }
    #Decrypt
    else{
        $splitPeriodArray = @();
        $periodCounter = 0;
        for($i = 0; $i -lt $Text.Length; $i++){
            [string]$tempPeriod = ""
            $periodCounter = 0;
            while($periodCounter -lt $Period){
                :box for($b = 0; $b -lt 3; $b++){
                    :row for($r = 0; $r -lt 3; $r++){
                        :column for($c = 0; $c -lt 3; $c++){
                            if($Text[$i] -eq $boxes[$b][$r, $c]){
                                $tempPeriod += $b;
                                $tempPeriod += $r;
                                $tempPeriod += $c

                                break box;
                            }
                        }
                    }
                }
                $i++
                $periodCounter ++
            }
            $i--;
            $splitPeriodArray += $tempPeriod;
        }
        foreach ($periodSection in $splitPeriodArray) {
            for($i = 0; $i -lt $periodSection.Length/3; $i++){
                $output += $boxes[[convert]::ToInt32($periodSection[$i], 10)][[convert]::ToInt32($periodSection[$i+$periodSection.Length/3], 10), [convert]::ToInt32($periodSection[$i+(($periodSection.Length/3)*2)], 10)];
            }
        }
    }
    return $output;
}