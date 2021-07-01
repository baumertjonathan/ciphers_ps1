$BaconianEncrypt26 = @{
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

$BaconianEncrypt24 = @{
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

$BaconianDecrypt26 = @{
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

$BaconianDecrypt24 = @{
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

function BaconianCipher26_Encrypt([string]$Text) {
    <#
        .SYNOPSIS
            Encrypts a string of text with a 26 character baconian cipher
        .DESCRIPTION
            Encrypts a string of text where each character is transformed into a 
            combination of "b" and "a" for example "D" could be represented as "aaabb"
            This is an altered version of the baconian cipher to account for a 26 letter alphabet.
        .EXAMPLE
            BaconianCipher26_Encrypt "Hello There"
            >> aabbbaabaaababbababbabbba baabbaabbbaabaabaaabaabaa
        .INPUTS
            [string] Text : The text to be encrypted using the baconian cipher. 
    #>
    $Text = $Text.ToUpper()
    [string]$result = ""
    for($i = 0; $i -lt $Text.Length; $i++){
        if($Text[$i] -eq " "){
            $result += " ";
        }
        else {
            $result += $BaconianEncrypt26.[string]$Text[$i];
        }
    }
    return $result;
}

function BaconianCipher24_Encrypt([string]$Text) {
        <#
        .SYNOPSIS
            Encrypts a string of text with a 24 character baconian cipher
        .DESCRIPTION
            Encrypts a string of text where each character is transformed into a 
            combination of "b" and "a" for example "D" could be represented as "aaabb"
            This traditional version of the cipher has two sets of letters that share the same 
            code I/J and U/V.
        .EXAMPLE
            BaconianCipher26_Encrypt "Hello There"
            >> aabbbaabaaababbababbabbba baabbaabbbaabaabaaabaabaa
        .INPUTS
            [string] Text : The text to be encrypted using the baconian cipher. 
    #>
    $Text = $Text.ToUpper();
    [string]$result = "";
    for($i = 0; $i -lt $Text.Length; $i++){
        if($Text[$i] -eq " "){
            $result += " ";
        }
        else {
            $result += $BaconianEncrypt24.[string]$Text[$i];
        }
    }
    return $result;
}

function BaconianCipher26_Decrypt([string]$Text) {
        <#
        .SYNOPSIS
            Decrypts a string of text with a 26 character baconian cipher
        .DESCRIPTION
            Decrypts a string of text consisting of sets of 5 a's and b's using a baconian cipher. 
            These sets of strings are not deliminated and decryption works properly wth spaces. 
            This uses an altered version of the traditional baconian cipher to account for a 26 character
            alphabet. 
        .EXAMPLE
            BaconianCipher26_Decrypt "aabbbaabaaababbababbabbba baabbaabbbaabaabaaabaabaa"
            > "HELLO THERE"
        .INPUTS
            [string] Text : The text to be decrypted using the baconian cipher.
    #>
    $Text = $Text.ToUpper();
    [string]$result = "";
    [string]$temp = "";
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
        $result += [string]$BaconianDecrypt26[$temp];
        $temp = "";
        $i--;
    }
    return $result;
}

function BaconianCipher24_Decrypt([string]$Text) {
    <#
        .SYNOPSIS
            Decrypts a string of text with a 26 character baconian cipher
        .DESCRIPTION
            Decrypts a string of text consisting of sets of 5 a's and b's using a baconian cipher. 
            These sets of strings are not deliminated and decryption works properly wth spaces. 
            This traditional version of the cipher has two sets of letters that share the same 
            code I/J and U/V.
        .EXAMPLE
            BaconianCipher24_Decrypt "aabbbaabaaababbababbabbba baabbaabbbaabaabaaabaabaa"
            > "HELLO THERE"
        .INPUTS
            [string] Text : The text to be decrypted using the baconian cipher.
    #>
    $Text = $Text.ToUpper();
    [string]$result = "";
    [string]$temp = "";
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
        $result += [string]$BaconianDecrypt24[$temp];
        $temp = "";
        $i--;
    }
    return $result;
}