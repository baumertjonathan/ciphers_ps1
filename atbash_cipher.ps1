function AtbashCipher {
    <#
        .SYNOPSIS
            Encrypts or Decrypts a string using an Atbash Cipher
        .DESCRIPTION
            Encrypts a string by substituting each letter with the letter that would be in 
            that position of the alphabet if it was flipped. 
            for example "a" would be substituted by "z" and "b" by "y"
            Decryption occours by following the same process.
        .EXAMPLE
            AtbashCipher "Hello There"
            > svool gsviv
        .EXAMPLE
            AtbashCipher "svool gsviv"
            > hello there
        .INPUTS
            [string] Text : The string to be encrypted using the Atbash Cipher
    #>

    Param (
        [string] $Text
    )
    
    #Variables
    $output = "";

    #Constants
    Set-Variable -name alphabet -value([string]"abcdefghijklmnopqrstuvwxyz") -Option Constant;
    Set-Variable -name tebahpla -value([string]"zyxwvutsrqponmlkjihgfedcba") -Option Constant;
    
    #Normalize Text
    $Text = $Text.ToLower();
    
    #Validate
    for($i = 0; $i -lt $Text.Length; $i++){
        if ($Text[$i] -notmatch '^[a-zA-Z\s]'){
            throw('Input must be letters only');
            return;
        }
    }
    #Encrypt/Decrypt
    if(-not ($Decrypt.IsPresent)){
        for($i = 0; $i -lt $Text.Length; $i++){
            if ($Text[$i] -eq " "){
                $output += " ";
                continue;
            }
            $index = $alphabet.IndexOf($Text[$i]);
            $output += $tebahpla[$index];
        }
        return $output;
    }
}