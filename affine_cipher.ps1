function AffineCipher {
    <#
        .SYNOPSIS
            Encrypts and decrypts a string of text using an affine cipher
        .DESCRIPTION
            Encrypts text by taking the position of the letter in the alphabet and the two supplied numbers (a, b) in the following function 
            E(x) = (ax + b) mod m
            where M is the alphabet size (26), and x is the position of the letter in the alphabet (0-25)
            Decryption follows a similar function
            D(x) = (a^-1)(x-b) mod m
            a must be coprime with 26. 
            both a and b must be between 1 and 26.
        .EXAMPLE
            AffineCipher -Text "Hello There" -a 5 -b 9
            > sdmmbasdqd
        .EXAMPLE
            AffineCipher -Text 'sdmmbasdqd' -a 5 -b 9 -Decrypt
            > hellothere
        .INPUTS
            [switch] Decrypt : If present decrypts rather than encrypts
            [string] Text    : The string of text to be encrypted or decrypted. Accepts pipeline input
            [int]    a       : The first number to be used in encrypting (must be coprime with 26)
            [int]    b       : The second number to be used in encrypting
    #>
    Param(
        [Switch]$Decrypt,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$Text,
        [Parameter(Mandatory=$true)][Int]$a,
        [Parameter(Mandatory=$true)][Int]$b
    )
    #normalize text
    $text = $text.ToLower();
    $text = $text.Replace(" ", "");

    #Variables
    New-Variable -name Output -value([string]"");

    #Constants
    New-Variable -name alphabet -value([string]"abcdefghijklmnopqrstuvwxyz") -Option Constant;

    #Validate a and b
    if($a -lt 1 -or $a -gt 26){
        throw('$a must be between 1 and 26')
    }
    if($b -lt 1 -or $b -gt 26){
        throw('$b must be between 1 and 26')
    }
    $p = $a;
    $q = 26;
    while($q -ne 0){
        $temp = $q
        $q = ($p % $q)
        $p = $temp;
    }
    if(-not ($p -eq 1)){
    
        throw('$a must be coprime with 26')
    }

    #Encrypt
    if(-not $Decrypt.IsPresent){
        for($i = 0; $i -lt $Text.Length; $i++){
            $p = $alphabet.IndexOf($Text[$i]);
            $c = (($a * $p + $b) % 26);
            $Output += $alphabet[$c];
        }
        return $Output;
    }
    #Decrypt
    else{
        $a_inv = 0;
        $f = 0;
        for($i = 0; $i -lt 26; $i++){
            $f = ($a * $i) % 26;
            if($f -eq 1){
                $a_inv = $i;
            }
        }
    
        for($i = 0; $i -lt $Text.Length; $i++){
            $c = $alphabet.IndexOf($Text[$i]);
            $p = ($a_inv * ($c - $b)) % 26;
            $Output += $alphabet[$p];
        }
        return $Output;
    }
}