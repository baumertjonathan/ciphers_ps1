function BaconianCipher {
    
    <#
        .SYNOPSIS
            Encrypts/Decrypts a string of text using a Baconian Cipher
        .DESCRIPTION
            Encrypts a string of text by replacing each letter with a string of 5 A's and B's. 
            Decrypts by replacing each set of 5 A's and B's with the corrosponding letter. 
            This cipher traditionally uses a 24 letter alphabet with i/j sharing and u/v sharing. 
            The cipher can be toggled to  decrypt by adding the -Decrypt parameter
            The cipher can be toggled to use a 36 letter version of the cipher by adding the -Modern parameter 
        .EXAMPLE
            BaconianCipher -Text "Very Cool"
            > baabbaabaabaaaababba aaabaabbababbabababa
        .EXAMPLE
            BaconianCipher -Text 'baabbaabaabaaaababba aaabaabbababbabababa' -Decrypt
            > (U/V)ERY COOL
        .EXAMPLE
            BaconianCipher -Text "Very Cool" -Modern
            > bababaabaabaaabbbaaa aaabaabbbaabbbaababb
        .EXAMPLE
            BaconianCipher -Text "bababaabaabaaabbbaaa aaabaabbbaabbbaababb" -Decrypt -Modern
            > VERY COOL
        .INPUTS
            [switch] Decrypt : If present decrypts rather than encrypts the text
            [switch] Modern  : If present encrypts/decrypts using a 26 letter version of the cipher
            [string] Text    : The string of text to be encrypted/decrypted
    #>

    Param(
        [switch]$Decrypt,
        [switch]$Modern,
        [string]$Text
    )

    #Normalize Text
    $Text = $Text.ToUpper();

    #Variables
    $result = "";

    #Constants
    Set-Variable -name BaconianEncrypt26 -Option Constant -value(
        @{   
            'A' = "aaaaa";
            'B' = "aaaab";
            'C' = "aaaba";
            'D' = "aaabb";
            'E' = "aabaa";
            'F' = "aabab";
            'G' = "aabba";
            'H' = "aabbb";
            'I' = "abaaa";
            'J' = "abaab";
            'K' = "ababa";
            'L' = "ababb";
            'M' = "abbaa";
            'N' = "abbab";
            'O' = "abbba";
            'P' = "abbbb";
            'Q' = "baaaa";
            'R' = "baaab";
            'S' = "baaba";
            'T' = "baabb";
            'U' = "babaa";
            'V' = "babab";
            'W' = "babba";
            'X' = "babbb";
            'Y' = "bbaaa";
            'Z' = "bbaab";
        }
    )

    Set-Variable -name BaconianEncrypt24 -Option Constant -value(
        @{
            'A' = "aaaaa";
            'B' = "aaaab";
            'C' = "aaaba";
            'D' = "aaabb";
            'E' = "aabaa";
            'F' = "aabab";
            'G' = "aabba";
            'H' = "aabbb";
            'I' = "abaaa";
            'J' = "abaaa";
            'K' = "abaab";
            'L' = "ababa";
            'M' = "ababb";
            'N' = "abbaa";
            'O' = "abbab";
            'P' = "abbba";
            'Q' = "abbbb";
            'R' = "baaaa";
            'S' = "baaab";
            'T' = "baaba";
            'U' = "baabb";
            'V' = "baabb";
            'W' = "babaa";
            'X' = "babab";
            'Y' = "babba";
            'Z' = "babbb";
        }
    )
    Set-Variable -name BaconianDecrypt26 -Option Constant -value(
        @{
            "aaaaa" = 'A';
            "aaaab" = 'B';
            "aaaba" = 'C';
            "aaabb" = 'D';
            "aabaa" = 'E';
            "aabab" = 'F';
            "aabba" = 'G';
            "aabbb" = 'H';
            "abaaa" = 'I';
            "abaab" = 'J';
            "ababa" = 'K';
            "ababb" = 'L';
            "abbaa" = 'M';
            "abbab" = 'N';
            "abbba" = 'O';
            "abbbb" = 'P';
            "baaaa" = 'Q';
            "baaab" = 'R';
            "baaba" = 'S';
            "baabb" = 'T';
            "babaa" = 'U';
            "babab" = 'V';
            "babba" = 'W';
            "babbb" = 'X';
            "bbaaa" = 'Y';
            "bbaab" = 'Z';
        }
    )
    Set-Variable -name BaconianDecrypt24 -Option Constant -value(
        @{
            "aaaaa" = "A";
            "aaaab" = "B";
            "aaaba" = "C";
            "aaabb" = "D";
            "aabaa" = "E";
            "aabab" = "F";
            "aabba" = "G";
            "aabbb" = "H";
            "abaaa" = "(I/J)";
            "abaab" = "K";
            "ababa" = "L";
            "ababb" = "M";
            "abbaa" = "N";
            "abbab" = "O";
            "abbba" = "P";
            "abbbb" = "Q";
            "baaaa" = "R";
            "baaab" = "S";
            "baaba" = "T";
            "baabb" = "(U/V)";
            "babaa" = "W";
            "babab" = "X";
            "babba" = "Y";
            "babbb" = "Z";
        }
    )

    #Encrypt
    if(-not $Decrypt.IsPresent){
        #Select table
        if($Modern.IsPresent){
            $table = $BaconianEncrypt26;
        }
        else{
            $table = $BaconianEncrypt24;
        }        
        #Encrypt
        for($i = 0; $i -lt $Text.Length; $i++){
            if($Text[$i] -eq " "){
                $result += " ";
            }
            else {
                $result += $table.[string]$Text[$i];
            }
        }
    }
    #Decrypt
    else{
        #Select table
        if($Modern.IsPresent){
            $table = $BaconianDecrypt26;
        }
        else{
            $table = $BaconianDecrypt24;
        }
        for($i = 0; $i -lt $Text.Length; $i++){
            while($temp.Length -lt 5){
                if($Text[$i] -eq " "){
                    $result += " ";  
                    $i++;
                }
                else{
                    $temp += $Text[$i];
                    $i++;
                }
            }
            $result += [string]$table[$temp];
            $temp = "";
            $i--;
        }
    }
    return $result;
}