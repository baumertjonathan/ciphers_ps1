function CaesarCipher {
    <#
        .SYNOPSIS
            Encrypts or Decrypts a standard string of alphabetical characters with a Caesar or Shift Cipher
        .DESCRIPTION
            Takes a string of text and an int to shift the alphabet with. Each letter is replaced
            with a letter (key) characters away.
            NOTE: This, like most of powershell is case-insensitive. 
        .EXAMPLE
            CaesarCipher_Decrypt -Text "Hello There" -Key 3
            > khoor wkhuh
        .EXAMPLE
            CaesarCipher -Text "khoor wkhuh" -Key 3 -Decrypt
            > hello there
        .INPUTS
            [switch] Decrypt : If present decrypts the string of text rather than encrypting
            [string] Text    : the text to be decrypted
            [int]    Key     : The key to be used in decrypting or shifting the text.
    #>
    Param (
        [switch]$Decrypt,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$Text,
        [Parameter(Mandatory=$true)][int]$Key
    )

    #Normalize Inputs
    $Text = $Text.ToLower();

    #Variables
    New-Variable -name Output -value([string]"");
    #Constants
    New-Variable -name alphabet -value([string]"abcdefghijklmnopqrstuvwxyz") -Option Constant;

    #Encrypt/Decrypt
    for($i = 0; $i -lt $Text.Length; $i++){
        if($Text[$i] -eq " "){
            $Output += " ";
        }
        else{
            if($Decrypt.IsPresent){
                $Output += $alphabet[($alphabet.IndexOf($Text[$i]) - $Key)]; 
            }
            else{
                #wraparound only works in the negatives in powershell
                [int]$index = $alphabet.IndexOf($text[$i])+$Key
                if($index -gt 26){
                    $index = $index-26
                }
                $Output += $alphabet[$index]; 
            }
        }
    }
    return $Output;
}