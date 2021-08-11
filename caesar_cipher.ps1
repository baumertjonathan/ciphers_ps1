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
        [string]$Text,
        [int]$Key
    )

    #Normalize Inputs
    $Text = $Text.ToLower();

    #Encrypt/Decrypt
    $textascii = [int[]][char[]]"$text";
    $encrypt = foreach($ascii in $textascii){
        if($ascii -eq 32){
            $ascii;
            continue;
        }
        if($Decrypt.IsPresent){
            $ascii - $key;
        }
        else{
            $ascii + $key;
        }
    }
    $toText = [char[]]$encrypt;
    $toString = -join $toText;
    
    return $toString;
}