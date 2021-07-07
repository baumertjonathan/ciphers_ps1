$playfaire_alphabet = "abcdefghiklmnopqrstuvwxyz";
function PlayfairCipher_Encrypt($Text, $Key) {
    <#
        .SYNOPSIS
            Encrypts a string of text using a Playfair cipher
        .DESCRIPTION
            Encrypts a string by mapping a key into a 5x5 table, pairing the letters then following a series of rules:
            1: If both letters are the same add an `x` after the first letter and then continue. 
            2: If the letters are in the same row of the table replace them with the letters to the right of them (wrapping as needed)
            3: If the letters are in the same column of the table replace them with the letters dicectly belwo them (wrapping as needed)
            4: If the letters are in nether the same row or column replace them with the letters on the same row but column of the other (opposite corners of the rectangle)

        .EXAMPLE
            PlayfairCipher_Encrypt -Text "Hello There"  -Key "Alan Turing"
            > kfnwiwbqdifw
        .INPUTS
            [string]Text : The string of text to be encrypted using the cipher.
            [string]Key  : The key to be used in encrypting the text. 
    #>
    $Text = $Text.ToLower();
    $Text = $Text.Replace(" ", "");
    $result = "";
    $table = New-PlayfairTable($Key);
    for ($i = 0; $i -lt $Text.Length; $i++){
        #split into pairs
        $pair = "";
        $pair += $Text[$i];
        if($Text[$i] -eq $Text[$i+1]){
            $pair += 'x';
        }
        else{
            $i++
            $pair += $Text[$i];
        }
        if ($pair.Length -eq 1 -and $i -eq $Text.Length){
            $pair += 'x';
        }
        # get indices of each
        for($j = 0; $j -lt 5; $j++){
            for($k = 0; $k -lt 5; $k++){
                if ($table[$j,$k] -eq $pair[0]){
                    $a_index = [System.Tuple]::Create($j, $k);
                }
                elseif ($table[$j, $k] -eq $pair[1]){
                    $b_index = [System.Tuple]::Create($j, $k);
                }
            }
        }
        # Row rule
        if ($a_index.Item1 -eq $b_index.Item1){
            # this would be nicer as a ternery expression but ps 5 doesent support that. 
            if($a_index.Item2 -eq 4){
                $a2 = 0;
            }
            else{
                $a2 = $a_index.Item2+1;
            }
            if($b_index.Item2 -eq 4){
                $b2 = 0;
            }
            else{
                $b2 = $b_index.Item2+1;
            }
            $result += $table[$a_index.Item1, $a2];
            $result += $table[$b_index.Item1, $b2];
        }
        # Column Rule
        elseif ($a_index.Item2 -eq $b_index.Item2) {
            if($a_index.Item1 -eq 4){
                $a1 = 0;
            }
            else{
                $a1 = $a_index.Item1+1;
            }
            if($b_index.Item1 -eq 4){
                $b1 = 0;
            }
            else{
                $b1 = $b_index.Item1+1;
            }
            $result += $table[$a1, $a_index.Item2];
            $result += $table[$b1, $b_index.Item2];
        }
        # Rectangle Rule
        else{
            $result += $table[$a_index.Item1, $b_index.Item2];
            $result += $table[$b_index.Item1, $a_index.Item2];
        }
    }
    return $result;
}

function PlayfairCipher_Decrypt([string]$Text, [string]$Key, [bool]$CleanOutput = $false) {
        <#
        .SYNOPSIS
            Decrypts a string of text using a Playfair cipher
        .DESCRIPTION
            Decrypts a string by mapping a key into a 5x5 table, pairing the letters then following the inverse of a series of rules:
            1: If the letters are in the same row of the table replace them with the letters to the right of them (wrapping as needed)
            2: If the letters are in the same column of the table replace them with the letters dicectly belwo them (wrapping as needed)
            3: If the letters are in nether the same row or column replace them with the letters on the same row but column of the other (opposite corners of the rectangle)
            There is an optional third parameter to remove x's likely introduced in encoding, this can break some words though (eg: annex, hexes)
        .EXAMPLE
            PlayfairCipher_Decrypt -Text "kfnwiwbqdifw"  -Key "Alan Turing"
            > hellotherex
        .EXAMPLE
            PlayfairCipher_Decrypt -Text "kfnwiwbqdifw" -Key "Alan Turing" -CleanOutput $true
            > hellothere
        .INPUTS
            [string]Text       : The string of text to be decrypting using the cipher.
            [string]Key        : The key to be used in decrypting the text. 
            [bool] CleanOutput : DEFAULT = $True If true, cleans out x's from the output likely inserted during encryption
    #>
    $Text = $Text.ToLower();
    $Text = $Text.Replace(" ", "");
    $result = "";
    # fill the table
    $table = New-PlayfairTable($Key)
    for ($i = 0; $i -lt $Text.Length; $i++){
        #split into pairs
        $pair = "";
        $pair += $Text[$i];
        if($Text[$i] -eq $Text[$i+1]){
            $pair += 'x';
        }
        else{
            $i++
            $pair += $Text[$i];
        }
        if ($pair.Length -eq 1 -and $i -eq $Text.Length){
            $pair += 'x';
        }
        # get indices of each
        for($j = 0; $j -lt 5; $j++){
            for($k = 0; $k -lt 5; $k++){
                if ($table[$j,$k] -eq $pair[0]){
                    $a_index = [System.Tuple]::Create($j, $k);
                }
                elseif ($table[$j, $k] -eq $pair[1]){
                    $b_index = [System.Tuple]::Create($j, $k);
                }
            }
        }
        # Row rule
        if ($a_index.Item1 -eq $b_index.Item1){
            # this would be nicer as a ternery expression but powershell 5 doesent support that. 
            if($a_index.Item2 -eq 0){
                $a2 = 4;
            }
            else{
                $a2 = $a_index.Item2-1;
            }
            if($b_index.Item2 -eq 0){
                $b2 = 4;
            }
            else{
                $b2 = $b_index.Item2-1;
            }
            $result += $table[$a_index.Item1, $a2];
            $result += $table[$b_index.Item1, $b2];
        }
        # Column Rule
        elseif ($a_index.Item2 -eq $b_index.Item2) {
            if($a_index.Item1 -eq 0){
                $a1 = 4;
            }
            else{
                $a1 = $a_index.Item1-1;
            }
            if($b_index.Item1 -eq 0){
                $b1 = 4;
            }
            else{
                $b1 = $b_index.Item1-1;
            }
            $result += $table[$a1, $a_index.Item2];
            $result += $table[$b1, $b_index.Item2];
        }
        # Rectangle Rule
        else{
            $result += $table[$a_index.Item1, $b_index.Item2];
            $result += $table[$b_index.Item1, $a_index.Item2];
        }
    }
    if($CleanOutput -eq $true){
        for($i = 0; $i -lt $result.Length; $i++){
            if(($result[$i] -eq "x") -and (($result[$i-1] -eq $result[$i+1]) -or ($i -eq $result.Length-1))){
                $result = $result.remove($i, 1);
            }
        }
    }
    return $result;

}

function New-PlayfairTable([string]$key) {
    $Key = $Key.ToLower();
    $Key = $key.Replace(" ", "");
    $table = New-Object 'string[,]' 5,5; 
    $key_it = 0;
    $alpha_it = 0;
    $Key_no_duplicates = "" #the key with no repeats (takes first instance only)
    for ($i = 0; $i -lt $key.Length; $i++){
        if ($Key_no_duplicates.IndexOf($key[$i]) -eq -1){
            $Key_no_duplicates += $key[$i];
        }
    }
    $Key = $Key_no_duplicates;
    # fill the table
    for($i = 0; $i -lt 5; $i++){
        for($j = 0; $j -lt 5; $j++){
            if($key_it -lt $key.Length){
                $table[$i, $j] = $key[$key_it];
                $key_it++;
            }
            else{
                while($key.IndexOf($playfaire_alphabet[$alpha_it]) -ne -1){
                    $alpha_it++;
                }
                $table[$i, $j] = $playfaire_alphabet[$alpha_it];
                $alpha_it++;
            }
        }
    }
    return ,$table #interesting stuff https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.1#comma-operator-
}

function Write-PlayfairTable($table) {
    $row = "";
    for($i = 0; $i -lt 5; $i++){
        for($j= 0; $j -lt 5; $j++){
            $row += $table[$i, $j];
            $row += " ";
        }
        Write-Host($row);
        $row = "";
    }
}

