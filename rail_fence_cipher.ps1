function RailFenceCipher {
    <#
        .SYNOPSIS
            Encrypts or Decrypts a string using the rail fence cipher
        .DESCRIPTION
            Encrypts or Decrypts a string of text by shuffling the letters on a "rail fence"
            for example a text input of "Hello There" with 3 rails would be encrypted as so
            h---o---r-
            -e-l-t-e-e
            --l---h---
            resulting in "horelteelh"
        .EXAMPLE
            RailFenceCipher -Text "Hello There" -Rails 3
            > HorelTeelh
        .EXAMPLE
            RailFenceCipher -Text "HorelTeelh" -Rails 3 -Decrypt
            > HelloThere
        .EXAMPLE
            RailFenceCipher -Text "Hello There" -Rails 3 -DrawRail
            H---o---r-
            -e-l-t-e-e
            --l---h---
            > HorelTeelh
        .INPUTS
            [switch] Decrypt  : If Present Decrypts the string rather than encrypting it.
            [switch] DrawRail : If Present uses WriteHost to draw the rail used
            [string] Text     : The string of text to be encrypted or decrypted
            [int]    Rails    : The number of rails to be used in the cipher. 
    #>
    Param(
        [switch]$Decrypt,
        [switch]$DrawRail,
        [string]$Text,
        [int]$Rails
    )

    #Normalize inputs
    $Text = $Text.Replace(" ", "");

    #Variables
    $result = "";
    $rail = New-Object 'string[,]' $Text.Length, $Rails;
    $Direction = $true;
    $j = 0;
    $k = 0;
    $temp = "";

    #Validate
    if($Text.Length -lt $Rails){
        throw "Invalid Input";
        return;
    }
    
    #Make Rail
    for($i = 0; $i -lt $Text.Length; $i++){
        if(-not $Decrypt.IsPresent){
            $rail[$i, $j] = $Text[$i];
        }
        else{
            $rail[$i, $j] = '*';
            #Something here to input encoded text
        }
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
        if($Decrypt.IsPresent){
        }
    }
    #Iterate the rail
    for($i = 0; $i -lt $rails; $i++){
        for($j = 0; $j -lt $Text.Length; $j++){
            if($null -ne $rail[$j, $i]){
                if($Decrypt.IsPresent){
                    $rail[$j, $i] = $Text[$k];
                    $k++;
                }
                else{
                    $result += $rail[$j, $i];
                }
            }

            if($DrawRail.IsPresent){
                if($null -eq $rail[$j, $i]){
                    $temp += "-";
                }
                else{
                    $temp += $rail[$j, $i];
                }
            }     
        }
        if($DrawRail.IsPresent){
            Write-Host($temp);
            $temp = "";
        }
    }
    if($Decrypt.IsPresent){
        $Direction = $true;
        $j = 0;
        for($i = 0; $i -lt $Text.Length; $i ++){
            $result += $rail[$i, $j];
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
    }
    return $result;
}

