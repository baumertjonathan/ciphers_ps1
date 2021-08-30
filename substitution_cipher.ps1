function SubstitutionCipher{
    
    <#
        .SYNOPSIS
            Encrypts or decrypts a string using a substitution cipher
        .DESCRIPTION
            Takes a 26 letter key and a string of any length (below 2147483647) to decrypt. 
            A Substitution cipher replaces each letter of the alphabet with another letter from 
            a key.
            NOTE: This, like powershell itself is case-insensitive. 
        .EXAMPLE
            SubstitutionCipher -Text "Hello There" -Key "qwertyuiopasdfghjklzxcvbnm"
            > itssg zitkt
        .EXAMPLE
            SubstitutionCipher -Text "itssg zitkt" -Key "qwertyuiopasdfghjklzxcvbnm" -Decrypt
            > hello there
        .INPUTS
            [Switch] Decrypt : If present decrypts the string of text rather than encrypting it. 
            [String] Text    : The string of text to be encrypted or decrypted.
            [String] Key     : The key to be used in encrypting or decrypting the string of text. 
    #>

    Param(
        [Switch]$Decrypt,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)][String]$Text,
        [Parameter(Mandatory=$true)][String]$Key
    )

    #Normalize Inputs
    $Text = $Text.ToLower();
    $Key = $Key.ToLower();

    #Variables
    [String]$output = "";

    #Constants
    Set-Variable -name alphabet -value([string]"abcdefghijklmnopqrstuvwxyz") -Option Constant;

    #Validate
    if($key.length -ne 26){
        throw "The key must be 26 characters long"
    }
    for($i = 0; $i -lt $key.length; $i++){
        for ($j = 0; $j -lt $key.length; $j++){
            if(($key[$i] -eq $key[$j] -and ($i -ne $j))){
                throw "The key must not have any repeating values"
            }
        }
    }

    #Encrypt/Decrypt
    for($i = 0; $i -lt $Text.Length; $i++){
        if($Text[$i] -eq " "){
            $output += " ";
            continue;
        }
        if(-not $Decrypt.IsPresent){
            $output += $key[$alphabet.IndexOf($Text[$i])];
        }
        else{
            $output += $alphabet[$key.IndexOf($Text[$i])];
        }
    }
    return $output;
}