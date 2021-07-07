$alphabet = "abcdefghiklmnopqrstuvwxyz";
function PlayfairCipher_Encrypt($Text, $Key) {
    $Text = $Text.ToLower();
    $Text = $Text.Replace(" ", "");
    $Key = $Key.ToLower();
    $Key = $key.Replace(" ", "");
    $result = "";
    $table = Make-PlayfaireTable($Key);
    for ($i = 0; $i -lt $Text.Length; $i++){
        #split into pairs
        $pair = "";
        $pair += $Text[$i];
        if($Text[$i] -eq $Text[$i+1]){
            $pair += 'x';
        }
        else{
            $i++
            $pair += $Text[$i];
        }
        if ($pair.Length -eq 1 -and $i -eq $Text.Length){
            $pair += 'x';
        }
        Write-Host($pair);
        # get indices of each
        for($j = 0; $j -lt 5; $j++){
            for($k = 0; $k -lt 5; $k++){
                if ($table[$j,$k] -eq $pair[0]){
                    $a_index = [System.Tuple]::Create($j, $k);
                }
                elseif ($table[$j, $k] -eq $pair[1]){
                    $b_index = [System.Tuple]::Create($j, $k);
                }
            }
        }
        # Row rule
        if ($a_index.Item1 -eq $b_index.Item1){
            if($a_index.Item2 -eq 4){
                $result += $table[$a_index.Item1, 0];
                $result += $table[$b_index.Item1, ($b_index.Item2+1)];
            }
            elseif ($b_index.Item2 -eq 4) {
                $result += $table[$a_index.Item1, ($a_index.Item2+1)];
                $result += $table[$b_index.Item1, 0];
            }
            else {
                $result += $table[$a_index.Item1, ($a_index.Item2+1)];
                $result += $table[$b_index.Item1, ($b_index.Item2+1)];
            }
        }
        # Column Rule
        elseif ($a_index.Item2 -eq $b_index.Item2) {
            if($a_index.Item1 -eq 4){
                $result += $table[0, $a_index.Item2];
                $result += $table[($b_index.Item1+1), $b_index.Item2]
            }
            elseif($b_index.Item1 -eq 4){
                $result += $table[($a_index.Item1+1), $a_index.Item2]
                $result += $table[0, $b_index.Item2];
            }
        }
        # Rectangle Rule
        else{
            $result += $table[$a_index.Item1, $b_index.Item2];
            $result += $table[$b_index.Item1, $a_index.Item2];
        }
    }
    return $result;
}

function PlayfairCipher_Decrypt([string]$Text, [string]$Key) {
    $Text = $Text.ToLower();
    $Text = $Text.Replace(" ", "");
    $Key = $Key.ToLower();
    $Key = $key.Replace(" ", "");
    $result = "";
    # fill the table
    $table = Make-PlayfaireTable($Key)
    for ($i = 0; $i -lt $Text.Length; $i++){
        #split into pairs
        $pair = "";
        $pair += $Text[$i];
        if($Text[$i] -eq $Text[$i+1]){
            $pair += 'x';
        }
        else{
            $i++
            $pair += $Text[$i];
        }
        if ($pair.Length -eq 1 -and $i -eq $Text.Length){
            $pair += 'x';
        }
        Write-Host($pair);
        # get indices of each
        for($j = 0; $j -lt 5; $j++){
            for($k = 0; $k -lt 5; $k++){
                if ($table[$j,$k] -eq $pair[0]){
                    $a_index = [System.Tuple]::Create($j, $k);
                }
                elseif ($table[$j, $k] -eq $pair[1]){
                    $b_index = [System.Tuple]::Create($j, $k);
                }
            }
        }
        # Row rule
        if ($a_index.Item1 -eq $b_index.Item1){
            if($a_index.Item2 -eq 0){
                $result += $table[$a_index.Item1, 4];
                $result += $table[$b_index.Item1, ($b_index.Item2-1)];
            }
            elseif ($b_index.Item2 -eq 0) {
                $result += $table[$a_index.Item1, ($a_index.Item2-1)];
                $result += $table[$b_index.Item1, 4];
            }
            else {
                $result += $table[$a_index.Item1, ($a_index.Item2-1)];
                $result += $table[$b_index.Item1, ($b_index.Item2-1)];
            }
        }
        # Column Rule
        elseif ($a_index.Item2 -eq $b_index.Item2) {
            if($a_index.Item1 -eq 0){
                $result += $table[4, $a_index.Item2];
                $result += $table[($b_index.Item1-1), $b_index.Item2]
            }
            elseif($b_index.Item1 -eq 0){
                $result += $table[($a_index.Item1-1), $a_index.Item2]
                $result += $table[4, $b_index.Item2];
            }
        }
        # Rectangle Rule
        else{
            $result += $table[$a_index.Item1, $b_index.Item2];
            $result += $table[$b_index.Item1, $a_index.Item2];
        }
    }
    return $result;

}

function Make-PlayfaireTable([string]$key) {
    $table = New-Object 'string[,]' 5,5; 
    $key_it = 0;
    $alpha_it = 0;
    $Key_no_duplicates = "" #the key with no repeats (takes first instance only)
    for ($i = 0; $i -lt $key.Length; $i++){
        if ($Key_no_duplicates.IndexOf($key[$i]) -eq -1){
            $Key_no_duplicates += $key[$i];
        }
    }
    $Key = $Key_no_duplicates;
    # fill the table
    for($i = 0; $i -lt 5; $i++){
        for($j = 0; $j -lt 5; $j++){
            if($key_it -lt $key.Length){
                $table[$i, $j] = $key[$key_it];
                $key_it++;
            }
            else{
                while($key.IndexOf($alphabet[$alpha_it]) -ne -1){
                    $alpha_it++;
                }
                $table[$i, $j] = $alphabet[$alpha_it];
                $alpha_it++;
            }
        }
    }
    Write-Host("Created table");
    Draw-Table($table);
    return ,$table #interesting stuff https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.1#comma-operator-
}

function Draw-Table($table) {
    $row = "";
    for($i = 0; $i -lt 5; $i++){
        for($j= 0; $j -lt 5; $j++){
            $row += $table[$i, $j];
            $row += " ";
        }
        Write-Host($row);
        $row = "";
    }
}