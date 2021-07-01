[string]$alphabet = "abcdefghijklmnopqrstuvwxyz";

function IsValidKey($key) {
    <#
        .SYNOPSIS
            checks the validity of a key for a substitution cipher
        .DESCRIPTION
            Checks that a key is 26 characters long and has no repeated characters. 
    #>

    $key = $key.ToLower();
    if($key.length -ne 26){
        return $False
    }
    for($i = 0; $i -lt $key.length; $i++){
        for ($j = 0; $j -lt $key.length; $j++){
            if(($key[$i] -eq $key[$j] -and ($i -ne $j))){
                return $False;
            }
        }
    }
    return $True;
}
function SubstitutionCipher_Encrypt([string]$text, [string]$key) {
    <#
        .SYNOPSIS
            Encrypts a standard string of alphabetical characters with a substitution cipher
        .DESCRIPTION
            Takes a 26 letter key and a string of any length (below 2147483647) to encrypt. 
            A Substitution cipher replaces each letter of the alphabet with another letter from 
            a key.
            NOTE: This, like powershell itself is case-insensitive. 
        .EXAMPLE
            SubstitutionCipher_Encrypt "Hello There" "qwertyuiopasdfghjklzxcvbnm"
            >> "tssg zitkt"
        .INPUTS
            [string] Text: the text to be encrypted
            [string] Key: The key to be used in encrypting/decrypting the message (26 characters)
    #>
    $text = $text.ToLower();
    $key = $text.ToLower();
    [string]$output = "";
    if (IsValidKey($key)){
        for ($i = 0; $i -lt $text.length; $i++){
            if($text[$i] -eq " "){
                $output += " ";
                continue;
            }
            [int]$oldCharIndex = $alphabet.IndexOf($text[$i]);
            $output += $key[$oldCharIndex];
        }
        return $output;
    }
    else{
        throw "Invalid Key"
    }
}

function SubstitutionCipher_Decrypt([string]$text, [string]$key) {
        <#
        .SYNOPSIS
            Decrypts a standard string of alphabetical characters with a substitution cipher
        .DESCRIPTION
            Takes a 26 letter key and a string of any length (below 2147483647) to decrypt. 
            A Substitution cipher replaces each letter of the alphabet with another letter from 
            a key.
            NOTE: This, like powershell itself is case-insensitive. 
        .EXAMPLE
            SubstitutionCipher_Encrypt "tssg zitkt" "qwertyuiopasdfghjklzxcvbnm"
            >> "Hello There"
        .INPUTS
            [string] Text: the text to be decrypted.
            [string] Key: The key to be used in encrypting/decrypting the message (26 characters)
    #>
    $text = $text.ToLower();
    $key = $key.ToLower();
    [string]$output = "";
    if(IsValidKey($key)){
        for($i = 0; $i -lt $text.length; $i++){
            if($text[$i] -eq " "){
                $output+= " ";
                continue;
            }
            [int]$index = $key.IndexOf($text[$i]);
            $output += $alphabet[$index];
        }
        return $output;
    }
    else{
        throw "Invalid Key"
    }
}
