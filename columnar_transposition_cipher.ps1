function ColumnarTranspositionCipher {
    <#
        .SYNOPSIS
        .DESCRIPTION
        .EXAMPLE
        .EXAMPLE
        .INPUTS
    #>

    Param (
        [switch] $Decrypt,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)][string] $Text,
        [Parameter(Mandatory=$true)][string] $Key
    )

    #Constants

    #Variables
    New-Variable -Name Output -Value([String]"");
    [Array]$Table = @();

    #Normalize Inputs
    $Text = $Text.ToLower();
    $Text = $Text.Replace(" ", "");
    $Key = $Key.ToLower();
    $Key = $Key.Replace(" ", "");

    #Create table
    for($i = 0; $i -lt $Text.Length; $i++){
        $j = 0;
        $temp= @();
        while($j -lt $key.Length){
            $temp += $Text[$i];
            $i++;
        }
        $Table += ,$temp;
        $i--;
    }

    #Encrypt
    if(-not $Decrypt.IsPresent){

    }
    #Decrypt
    else{

    }
     
    return $Output;
}