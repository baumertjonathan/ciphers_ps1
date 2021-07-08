function RailFenceCipher_Encrypt([string]$Text, [int]$Rails, [bool]$DrawRail = $false) {
    <#
        .SYNOPSIS
            Encrypts a string of text with a rail-fence cipher
        .DESCRIPTION
            Encrypts a string of text by shuffling the letters on a "rail fence"
            for example a text input of "Hello There" with 3 rails would be encrypted as so
            h---o---r-
            -e-l-t-e-e
            --l---h---
            resulting in "horelteelh"
        .EXAMPLE
            RailFenceCiphber_Encrypt -Text "Hello There" -Rails 3 -DrawRail $false
            > horelteelh
        .INPUTS
            [string] Text   : The string of text to be encrypted
            [int] Rails     : The number of rails to be used in encrypting, must be shorter than the string of text
            [bool] DrawRail : (Optional) Draws the rail used if selected defaults to $false
    #>
    $Text = $Text.ToLower();
    $Text = $Text.Replace(" ", "");
    $Direction = $true
    if ($Text.Length -lt $Rails){
        throw "Invalid input";
        return;
    }
    $result = "";
    [bool]$direction = $true;
    $j = 0;
    $rail = New-Object 'string[,]' $Text.Length, $Rails;
    #Fill the rail
    for($i = 0; $i -lt $Text.Length; $i++){
        $rail[$i, $j] = $Text[$i];
        if($Direction){
            $j++
        }
        else{
            $j--;
        }
        if($j -eq $rails-1){
            $Direction = $false;
        }
        if($j -eq 0){
            $Direction = $true;
        }
    }
    #read the rail
    Write-Host('Reading the Rail');
    for($i = 0; $i -lt $Rails; $i++){
        for($j = 0; $j -lt $Text.Length; $j++){
            if($rail[$j, $i] -ne ""){
                $result += $rail[$j, $i];
            }
        }
    }
    #display the rail
    if($DrawRail){
        $temp = ""
        for($i = 0; $i -lt $Rails; $i++){
            for($j = 0; $j -lt $Text.Length; $j++){
                if($null -eq $rail[$j,$i]){
                    $temp+= ".";
                }
                else {
                    $temp += $rail[$j, $i];
                }
            }
            Write-Host($temp);
            $temp = "";
        }
    }
    return $result;
}


function RailFenceCipher_Decrypt([string]$Text, [int]$Rails, [bool]$DrawRail = $false) {
    <#
        .SYNOPSIS
            Decrypts a piece of text using a rail fence cipher
        .DESCRIPTION
            Decrypts a string of text by shuffling the letters on a "rail fence"
            for example a text input of "Hello There" with 3 rails would be encrypted as so
            h---o---r-
            -e-l-t-e-e
            --l---h---
            resulting in "horelteelh"
        .EXAMPLE
            RailFenceCipher_Decrypt -Text "horelteelh" -Rails 3 -DrawRail $false
            >hellothere
        .INPUTS
            [string] Text   : The string of text to be decrypted
            [int] Rails     : The number of rails to be used in decrypting
            [bool] DrawRail : (Optional) Draws the rail used if selected defaults to $false
    #>
    $rail = New-Object 'string[,]' $Text.Length, $Rails;
    $Direction = $true;
    Write-Host($Text.Length, $Rails);
    if($Text.Length -lt $Rails){
        throw "Invalid input";
        return;
    }
    #Mark the rail
    $j = 0;
    $k = 0;
    for($i = 0; $i -lt $Text.Length; $i++){
        $rail[$i, $j] = '*';
        if($Direction){
            $j++;
        }
        else{
            $j--;
        }
        if($j -eq $rails-1){
            $Direction = $false;
        }
        if($j -eq 0){
            $Direction = $true;
        }
    }
    #Fill the rail
    for($i = 0; $i -lt $rails; $i++){
        for($j = 0; $j -lt $Text.Length; $j++){
            if($rail[$j, $i] -eq '*'){
                $rail[$j, $i] = $Text[$k];
                $k++;
            }
        }
    }
    #Read the rail
    $Direction = $true;
    $j = 0;
    for($i = 0; $i -lt $Text.Length; $i++){
        $result += $rail[$i, $j];
        if($Direction){
            $j++;
        }
        else{
            $j--;
        }
        if($j -eq $Rails-1){
            $Direction = $false;
        }
        if($j -eq 0){
            $Direction = $true;
        }
    }
    #display the rail
    if($DrawRail){
        $temp = ""
        for($i = 0; $i -lt $Rails; $i++){
            for($j = 0; $j -lt $Text.Length; $j++){
                if($null -eq $rail[$j,$i]){
                    $temp+= ".";
                }
                else {
                    $temp += $rail[$j, $i];
                }
            }
            Write-Host($temp);
            $temp = "";
        }
    }
    return $result
}

