[string]$alphabet = "abcdefghijklmnopqrstuvwxyz"
[string]$tebahpla = "zyxwvutsrqponmlkjihgfedcba" #variable name funny, alphabet backwards

function Validate([string]$Text) {
    <#
        .SYNOPSIS
            validates string for the atbash cipher
        .DESCRIPTION
            checks that the string contains only letters and spaces
        .EXAMPLE
            Validate "Hello There"
            > True
        .INPUTS
            [string] Text : the string to be validated
    #>
    for($i = 0; $i -lt $Text.Length; $i++){
        if ($Text[$i] -notmatch '^[a-zA-Z\s]'){
            return $false
        }
    }
    return $true
}
function AtbashCipher_Encrypt([string]$Text) {
        <#
        .SYNOPSIS
            Encrypts a string using an Atbash Cipher
        .DESCRIPTION
            Encrypts a string by substituting each letter with the letter that would be in 
            that position of the alphabet if it was flipped. 
            for example "a" would be substituted by "z" and "b" by "y"
            This, like much of powershell is case insensitive. 
        .EXAMPLE
            AtbashCipher_Encrypt "Hello There"
            > svool gsviv
        .INPUTS
            [string] Text the string to be encrypted using the Atbash Cipher
    #>
    $Text = $Text.ToLower();
    if(Validate($Text)){
        [string]$output = "";
        for($i = 0; $i -lt $Text.Length; $i++){
            if ($Text[$i] -eq " "){
                $output += " "
                continue;
            }
            $index = $alphabet.IndexOf($Text[$i]);
            $output += $tebahpla[$index];
        }
        return $output;
    }
    else {
        throw "Input must be letters only";
    }
}

function AtbashCipher_Decrypt([string]$Text) {
        <#
        .SYNOPSIS
            Decrypts a string using an Atbash Cipher
        .DESCRIPTION
            Decrypts a string by substituting each letter with the letter that would be in 
            that position if the alphabet was flipped.
            for example "a" would be substituted by "z" and "b" by "y"
        .EXAMPLE
            AtbashCipher_Decrypt "svool gsviv"
            > hello there
        .INPUTS
            [string] Text : the string to be decrypted. 
    #>
    $Text = $Text.ToLower()
    if(Validate($Text)){
        [string]$output = "";
        for($i = 0; $i -lt $Text.Length; $i++){
            if ($Text[$i] -eq " "){
                $output += " "
                continue;
            }
            $index = $tebahpla.IndexOf($Text[$i]);
            $output += $alphabet[$index];
        }
        return $output;
    }
    else{
        throw "Input must be letters only";
    }
}

