function PolybiusCipher {
    <#
        .SYNOPSIS
            Encrypts or decrypts a string using a polybius square
        .DESCRIPTION
            Encrypts a string by replacing each letter with its coordinates on a polybius square
            Decrypts a string by taking the coordinates and replacing them wiht the letter from the square
            The key taken is used to create the square, row by row. 
            The key must be 25 characters in length with no repeating letters. traditionally i and j share a space.
            The default key is the traditional polybius square for the latin alphabet:
            a b c d e
            f g h i k
            l m n o p
            q r s t u
            v w x y z
        .EXAMPLE
            PolybiusCipher -Text "Hello There" -Key "qwertyuiopasdfghklzxcvbnm"
            > 30 02 32 13 04 30 02 03 02
        .EXAMPLE
            PolybiusCipher -Text "30 02 32 32 13 04 30 02 03 02" -Key "qwertyuiopasdfghklzxcvbnm" -Decrypt
            > hellothere
        .INPUTS
            [switch] Decrypt : If present decrypts the text rather than encrypting
            [string] Text    : The string of text to be encrypted or decrypted
            [string] Key     : The key to be used in encrypting or decrypting, has a default value of "abcdefghiklmnopqrstuvwxyz"
        
    #>

    Param(
        [switch]$Decrypt,
        [string]$Text,
        [string]$Key = "abcdefghiklmnopqrstuvwxyz"
    )

    #Normalize inputs
    $Text = $Text.ToLower();
    $Key = $Key.ToLower();

    #Variables
    [string]$output = "";
    $polybiusTable = New-Object 'string[,]' 5,5;

    #Validate
    if($Text -notmatch "^[a-z ]*$"  -and (-not $Decrypt.IsPresent)){
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

    #Create square
    $letter = 0;
    for($i = 0; $i -lt 5; $i++){
        for($j = 0; $j -lt 5; $j++){
            $polybiusTable[$i, $j] = $Key[$letter];
            $letter++;
        }
    }
    #Encrypt
    if(-not $Decrypt.IsPresent){
        $Text = $Text.Replace(" ", "");
        for($i = 0; $i -lt $Text.Length; $i++){
            for($j = 0; $j -lt 5; $j++){
                for($k = 0; $k -lt 5; $k++){
                    if ($polybiusTable[$j,$k] -eq $Text[$i]){
                        $result += [string]$j + [string]$k + " ";
                    }
                }
            }
        }
    }
    #Decrypt
    else{
        $SplitInput = $Text.Split(" ");
        foreach ($pair in $SplitInput) {
            $result += $polybiusTable[[convert]::ToInt32($pair[0], 10), [convert]::ToInt32($pair[1], 10)];
        }

    }

    return $result;
}