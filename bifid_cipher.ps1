function BifidCipher {
    <#
        .SYNOPSIS
            Encrypts or decrypts a string of text using the bifid cipher
        .DESCRIPTION
            Encrypts or decrypts a string by first mapping a 25 letter key (typically i and j share a space) to a polybius square, splitting the results by a period, then combining the results then enciphering again
            Here is an example with a key of "qwertyuiopasdfghklzxcvbnm", a period of 3, and text of "Testing"

            ==Polybius Square==
            q w e r t
            y u i o p
            a s d f g
            h k l z x
            c v b n m
            
            Text  : t e s t i n g
            Row   : 0 0 2 0 1 4 2
            Column: 4 2 1 4 2 3 4

            Split by periods
            002 014 2
            421 423 4

            Combine
            002421 014423 24

            Encipher again
            Text  : q g s w m f g
            Row   : 0 2 2 0 4 2 2
            Column: 0 4 1 1 4 3 4
            
            The key must have 25 unique letters
            The period cannot be longer than the text being enciphered. 
        .LINK
            https://github.com/baumertjonathan/CIPHER_INFO/blob/main/BIFID_CIPHER.md
        .EXAMPLE
            BifidCipher -Text "Hello There" -Key "qwertyuiopasdfghklzxcvbnm" -Period 5
            > hzydfrqtel
        .EXAMPLE
            BifidCipher -Text "hzydfrqtel" -Key "qwertyuiopasdfghklzxcvbnm" -Period 5 -Decrypt
            > hellothere
        .INPUTS
            [switch] Decrypt : If present decrypts the text rather than encrypting
            [string] Text    : The string of text to be encrypted or decrypted
            [string] Key     : The key to be used in encrypting or decrypting the text, must be 25 unique letters
            [int]    Period  : The period to be used in encrypting or decrypting the text, must be less than the length of Text to be encrypted. 
    #>

    Param (
        [switch]$Decrypt,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$Text,
        [Parameter(Mandatory=$true)][string]$Key,
        [Parameter(Mandatory=$true)][int]$Period
    )

    #Normalize Inputs
    $Text = $Text.ToLower();
    $Text = $Text.Replace(" ", "");
    $Key = $Key.ToLower();

    #Variables
    New-Variable -Name Output -Value([string]"");
    [Array]$polybiusTable = New-Object 'string[,]' 5,5; 
    [Array]$rowArray = New-Object 'string[]' $Text.Length;
    [Array]$columnArray = New-Object 'string[]' $Text.Length;
    [Array]$periodArray = @()

    #Validate
    if($Period -ge $Text.Length){
        throw('Period must be less than the length of the text')
    }
    if($Text -notmatch "^[a-z]*$"){
        throw('Text must only have alphabetical characters');  
    }
    if ($Key.Length -ne 25){
        throw('Key must be 25 characters in length');
    }
    if($Key -notmatch "^[a-z]*$"){
        throw('Key must only have alphabetical characters');  
    }
    for($i = 0; $i -lt 25; $i++){
        for($j = 0; $j -lt 25; $j++){
            if(($Key[$i] -eq $Key[$j]) -and ($i -ne $j)){
                throw('Key must have no repeating letters')
            }
        }
    }

    #Create Polybius square
    $letter = 0;
    for($i = 0; $i -lt 5; $i++){
        for($j = 0; $j -lt 5; $j++){
            $polybiusTable[$i, $j] = $Key[$letter];
            $letter++;
        }
    }

    #Encrypt
    if(-not $Decrypt.IsPresent){
        :letter for($i = 0; $i -lt $Text.Length; $i++){
            :row for($r = 0; $r -lt 5; $r++){
                :column for($c = 0; $c -lt 5; $c++){
                    if($Text[$i] -eq $polybiusTable[$r, $c]){
                        $rowArray[$i] = $r;
                        $columnArray[$i] = $c;
                        break row;
                    }
                }
            }
        }
        #divide by period
        $splitCounter = 0;
        $tempPeriod = @();
        for($i = 0; $i -lt $Text.Length; $i++){
            while($splitCounter -lt $Period -and ($i -lt $rowArray.Length) ){
                $tempPeriod += $columnArray[$i];
                $periodArray = $periodArray + $rowArray[$i];
                $splitCounter++;
                $i++;
            }
            $splitCounter = 0;
            $periodArray += $tempPeriod;
            $tempPeriod = @();
            $i--;
        }
        for($i = 0; $i -lt $periodArray.Length; $i+=2){
            $output += $polybiusTable[$periodArray[$i], $periodArray[$i+1]];
        }

    }
    #Decrypt
    else{
        $splitPeriodArray = @();
        $periodCounter = 0;
        for($i = 0; $i -lt $Text.Length; $i++){
            $tempPeriod = "";
            $periodCounter = 0;
            while($periodCounter -lt $Period){
                :row for($r = 0; $r -lt 5; $r++){
                    :column for($c = 0; $c -lt 5; $c++){
                        if($Text[$i] -eq $polybiusTable[$r, $c]){
                            $tempPeriod += $r
                            $tempPeriod += $c
                            
                            break row;
                        }
                    }
                }
                #$tempPeriod += $Text[$i];
                $i++
                $periodCounter++;
            }
            $i--;
            $splitPeriodArray += $tempPeriod;
        }
        #split into sections
        foreach ($periodSection in $splitPeriodArray) {
            for($i = 0; $i -lt $periodSection.Length/2; $i++){
                $output += $polybiusTable[[convert]::ToInt32($periodSection[$i], 10), [convert]::ToInt32($periodSection[$i+($periodSection.Length/2)], 10)]
            }
        }

    }
    return $output;
}   