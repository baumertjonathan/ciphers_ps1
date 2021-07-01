function CaesarCipher_Encrypt([string]$text, [int]$key) {
    <#
        .SYNOPSIS
            Encrypts a standard string of alphabetical characters with a Caesar or Shift Cipher
        .DESCRIPTION
            Takes a string of text and an int to shift the alphabet with. Each letter is replaced
            with a letter (key) characters away.
            NOTE: This, like most of powershell is case-insensitive. 
        .EXAMPLE
            CaesarCipher_Encrypt "Hello There" 3
            >> khoor wkhuh
        .INPUTS
            [string] Text: the text to be encrypted
            [int]    Key: The key to be used in encrypting or shifting the text.
    #>
    $text = $text.ToLower();
    $textascii = [int[]][char[]]"$text";
    $encrypt = foreach($ascii in $textascii){
        if($ascii -eq 32){
            $ascii;
            continue;
        }
        $ascii + $key;
    }
    $toText = [char[]]$encrypt;
    $toString = -join $toText;
    return $toString;
}

function CaesarCipher_Decrypt([string]$text, [int]$key) {
        <#
        .SYNOPSIS
            Decrypts a standard string of alphabetical characters with a Caesar or Shift Cipher
        .DESCRIPTION
            Takes a string of text and an int to shift the alphabet with. Each letter is replaced
            with a letter (key) characters away.
            NOTE: This, like most of powershell is case-insensitive. 
        .EXAMPLE
            CaesarCipher_Decrypt "khoor wkhuh" 3
            >> hello there
        .INPUTS
            [string] Text: the text to be decrypted
            [int]    Key: The key to be used in decrypting or shifting the text.
    #>
    $text = $text.ToLower();
    $textascii = [int[]][char[]]"$text";
    $decrypt = foreach($ascii in $textascii){
        if($ascii -eq 32){
            $ascii;
            continue;
        }
        $ascii - $key;
    }
    $toText = [char[]]$decrypt;
    $toString = -join $toText;
    return $toString;
}