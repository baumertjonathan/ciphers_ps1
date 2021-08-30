function PlayfairCipher{
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
            PlayfairCipher -Text "Hello There"  -Key "Alan Turing"
            > kfnwiwbqdifw
        .EXAMPLE
            PlayfairCipher -Text "kfnwiwbqdifw" -Key "Alan Turing" -Decrypt
            > helxlotherex
        .EXAMPLE
            PlayfairCipher -Text "kfnwiwbqdifw" -Key "AlanTuring" -Decrypt -CleanOutput
            > hellothere
        .INPUTS
            [Switch] Decrypt     : If present decrypts the string rather than encrypting.
            [Switch] CleanOutput : If present removes excess 'x' from the output, this can casue issues in some words(ie: annex, hexes)
            [String] Text        : The string of text to be encrypted or decrypted using the cipher.
            [String] Key         : The key to be used in encrypting or decrypting the text. 
    #>
    Param(
        [Switch]$Decrypt,
        [Switch]$CleanOutput,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)][String]$Text,
        [Parameter(Mandatory=$true)][String]$Key
    )

    #Normalize Inputs
    $Key = $Key.ToLower();
    $Key = $key.Replace(" ", "");
    $Text = $Text.ToLower();
    $Text = $Text.Replace(" ", "");

    #Variables
    [String]$Output = "";
    [Array]$table = New-Object 'string[,]' 5,5; 
    [Int]$key_it = 0;
    [Int]$alpha_it = 0;
    $edge = $null;
    $start = $null;
    $incrementer = $null;
    
    #Constants
    Set-Variable -name playfaire_alphabet -value([string]"abcdefghiklmnopqrstuvwxyz") -Option Constant;

    #Make Playfair Table
    [String]$Key_no_duplicates = "" #the key with no repeats (takes first instance only)
    for ($i = 0; $i -lt $key.Length; $i++){
        if ($Key_no_duplicates.IndexOf($key[$i]) -eq -1){
            $Key_no_duplicates += $key[$i];
        }
    }
    $Key = $Key_no_duplicates
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
    #Encrypt/Decrypt
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
        #Encrypt/Decrypt
        if(-not ($Decrypt.IsPresent)){
            $edge = 4;
            $start = 0;
            $incrementer = 1;
        }
        else{
            $edge = 0;
            $start = 4;
            $incrementer = -1;
        }
        # Row rule
        if ($a_index.Item1 -eq $b_index.Item1){
            # this would be nicer as a ternery expression but powershell 5 doesent support that. 
            if($a_index.Item2 -eq $edge){
                $a2 = $start;
            }
            else{
                $a2 = $a_index.Item2 + $incrementer;
            }
            if($b_index.Item2 -eq $edge){
                $b2 = $start;
            }
            else{
                $b2 = $b_index.Item2 + $incrementer;
            }
            $Output += $table[$a_index.Item1, $a2];
            $Output += $table[$b_index.Item1, $b2];
        }
        # Column Rule
        elseif ($a_index.Item2 -eq $b_index.Item2) {
            if($a_index.Item1 -eq $edge){
                $a1 = $start;
            }
            else{
                $a1 = $a_index.Item1 + $incrementer;
            }
            if($b_index.Item1 -eq $edge){
                $b1 = $start;
            }
            else{
                $b1 = $b_index.Item1 + $incrementer;
            }
            $Output += $table[$a1, $a_index.Item2];
            $Output += $table[$b1, $b_index.Item2];
        }
        #Rectangle Rule
        else{
            $Output += $table[$a_index.Item1, $b_index.Item2];
            $Output += $table[$b_index.Item1, $a_index.Item2];
        }
    }
    if($Decrypt.IsPresent -and $CleanOutput.IsPresent){
        for($i = 0; $i -lt $Output.Length; $i++){
            if(($Output[$i] -eq "x") -and (($Output[$i-1] -eq $Output[$i+1]) -or ($i -eq $Output.Length-1))){
                $Output = $Output.remove($i, 1);
            }
        }
    }

    return $Output;
}