function PortaCipher {
    <#
        .SYNOPSIS
            Encrypts and decrypts a string of text using a Porta cipher
        .DESCRIPTION
            Encrypts and decrypts a string by replacing letters with corrosponding letters on a tabula based on letters in the string and key.
            Encrypting a string twice will result in the original string of text being returned. 
            Because two letters represent each row of the tabula text can sometimes be encoded with two different keys resulting in the same result. 
        .EXAMPLE
            PortaCipher "Hello There" "Turing"
            > qotpidqojv
        .EXAMPLE
            PortaCipher "qotpidqojv" "Turing"
            > hellothere
        .INPUTS
            [string] Text : The text to be encoded or decoded using the Porta Cipher. Accepts pipeline input
            [string] Key  : The key to be used in encoding or decoding the text. 
    #>

    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)][String]$Text,
        [Parameter(Mandatory=$true)][String]$Key
    )
    #tables
    [Array]$tabula = @(
    ( 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm' ),
    ( 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'n', 'm', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l' ),
    ( 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'n', 'o', 'l', 'm', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k' ),
    ( 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'n', 'o', 'p', 'k', 'l', 'm', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j' ),
    ( 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'n', 'o', 'p', 'q', 'j', 'k', 'l', 'm', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i' ),
    ( 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'n', 'o', 'p', 'q', 'r', 'i', 'j', 'k', 'l', 'm', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' ),
    ( 't', 'u', 'v', 'w', 'x', 'y', 'z', 'n', 'o', 'p', 'q', 'r', 's', 'h', 'i', 'j', 'k', 'l', 'm', 'a', 'b', 'c', 'd', 'e', 'f', 'g' ),
    ( 'u', 'v', 'w', 'x', 'y', 'z', 'n', 'o', 'p', 'q', 'r', 's', 't', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'a', 'b', 'c', 'd', 'e', 'f' ),
    ( 'v', 'w', 'x', 'y', 'z', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'a', 'b', 'c', 'd', 'e' ),
    ( 'w', 'x', 'y', 'z', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'a', 'b', 'c', 'd' ),
    ( 'x', 'y', 'z', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'a', 'b', 'c' ),
    ( 'y', 'z', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'a', 'b' ),
    ( 'z', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'a' )
)

    [Hashtable]$row_map = @{
        'a' = 0;
        'b' = 0;
        'c' = 1;
        'd' = 1;
        'e' = 2;
        'f' = 2;
        'g' = 3; 
        'h' = 3; 
        'i' = 4; 
        'j' = 4;
        'k' = 5;
        'l' = 5;
        'm' = 6;
        'n' = 6;
        'o' = 7;
        'p' = 7;
        'q' = 8;
        'r' = 8;
        's' = 9;
        't' = 9;
        'u' = 10;
        'v' = 10;
        'w' = 11;
        'x' = 11;
        'y' = 12;
        'z' = 12;
    }

    Set-Variable -name alphabet -value([string]"abcdefghijklmnopqrstuvwxyz") -Option Constant;

    #normalizing inputs
    $Text = $Text.Replace(" ", "");
    $Text = $Text.ToLower();
    $Key = $Key.Replace(" ", "");
    $key = $Key.ToLower();
    $Output = "";

    #adjusting key size
    while($Key.Length -lt $Text.Length){
        $Key += $Key;
    }

    #Encrypting/Decrypting
    for ($i = 0; $i -lt $Text.Length; $i++){
        $Output += $tabula[$row_map[[string]$Key[$i]]][$alphabet.IndexOf($Text[$i])];
    }
    return $Output;
}

