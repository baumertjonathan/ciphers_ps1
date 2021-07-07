$alphabet = "abcdefghiklmnopqrstuvwxyz";
function PlayfairCipher_Encrypt($Text, $Key) {
    $Text = $Text.ToLower();
    $Text = $Text.Replace(" ", "");
    $Key = $Key.ToLower();
    $Key = $key.Replace(" ", "");
    $result = "";
    $table = Make-PlayfaireTable($Key);
    Draw-Table($table);
    # split into pairs
    $paired_array = @();
    for ($i = 0; $i -lt $Text.Length; $i++){
        $temp = "";
        $temp += $Text[$i];
        if($Text[$i] -eq $Text[$i+1]){
            $temp += 'x';
        }
        else{
            $i++;
            $temp += $Text[$i];
        }
        if ($temp.Length -eq 1 -and $i -eq $Text.Length){
            $temp += 'x';
        }
        $paired_array += $temp;
        $temp = "";
    }
    # encrypt using the rules
    $paired_index_array = [System.Object[]]::new($paired_array.Length);
    for ($a = 0; $a -lt $paired_array.Length; $a++){
        $a_index = $null;
        $b_index = $null;
        for ($i = 0; $i -lt 5; $i++){
            for ($j = 0; $j -lt 5; $j++){
                if($table[$i, $j] -eq $paired_array[$a][0]){
                    $a_index = [System.Tuple]::Create($i, $j);
                }
                elseif ($table[$i, $j] -eq $paired_array[$a][1]) {
                    $b_index = [System.Tuple]::Create($i, $j);
                }
            }
        }
        $paired_index_array[$a] = [System.Tuple]::Create($a_index, $b_index);
    }

    for($i = 0; $i -lt $paired_index_array.Length; $i++){
        $LetterIndex1 = $paired_index_array[$i].Item1;
        $LetterIndex2 = $paired_index_array[$i].Item2;
        # Row Rule
        if($LetterIndex1.Item1 -eq $LetterIndex2.Item1){
            if($LetterIndex1.Item2 -eq 4){ 
                $result += $table[$LetterIndex1.Item1, 0];
                $result += $table[$LetterIndex2.Item1, ($LetterIndex2.Item2+1)];
                continue;
            }
            if ($LetterIndex2.Item2 -eq 4) {
                $result += $table[($LetterIndex1.Item1), ($LetterIndex1.Item2+1)];
                $result += $table[$LetterIndex2.Item1, 0]; 
                continue;
            }
            
                $result += $table[$LetterIndex1.Item1, ($LetterIndex1.Item2+1)];
                $result += $table[$LetterIndex2.Item1, ($LetterIndex2.Item2+1)];
            continue;
        }
        # Column Rule
        if ($LetterIndex1.Item2 -eq $LetterIndex2.Item2) {
            if($LetterIndex1.Item1  -eq 4){
                $result += $table[0, $LetterIndex1.Item2];
                $result += $table[($LetterIndex2.Item1+1), $LetterIndex2.Item2];
                continue;
            }
            if ($LetterIndex2.Item1 -eq 4) {
                $result += $table[($LetterIndex1.Item1+1), $LetterIndex1.Item2];
                $result += $table[0, $LetterIndex2.Item2]; 
                continue;
            }
                $result += $table[($LetterIndex1.Item1+1), ($LetterIndex1.Item2)];
                $result += $table[($LetterIndex2.Item1+1), ($LetterIndex2.Item2)];
            continue;
        }
        # Rectangle rule
            Write-Host("Rectangle pair found: ", $table[$LetterIndex1.Item1, $LetterIndex1.Item2], $table[$LetterIndex2.Item1, $LetterIndex2.Item2])
            $result += $table[$LetterIndex1.Item1, $LetterIndex2.Item2];
            $result += $table[$LetterIndex2.Item1, $LetterIndex1.Item2];
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
    $paired_array = @();
    for ($i = 0; $i -lt $Text.Length; $i++){
        $temp = "";
        $temp += $Text[$i];
        if($Text[$i] -eq $Text[$i+1]){
            $temp += 'x';
        }
        else{
            $i++;
            $temp += $Text[$i];
        }
        if ($temp.Length -eq 1 -and $i -eq $Text.Length){
            $temp += 'x';
        }
        $paired_array += $temp;
        $temp = "";
    }
    $paired_index_array = [System.Object[]]::new($paired_array.Length);
    for ($a = 0; $a -lt $paired_array.Length; $a++){
        $a_index = $null;
        $b_index = $null;
        for ($i = 0; $i -lt 5; $i++){
            for ($j = 0; $j -lt 5; $j++){
                if($table[$i, $j] -eq $paired_array[$a][0]){
                    $a_index = [System.Tuple]::Create($i, $j);
                }
                elseif ($table[$i, $j] -eq $paired_array[$a][1]) {
                    $b_index = [System.Tuple]::Create($i, $j);
                }
            }
        }
        $paired_index_array[$a] = [System.Tuple]::Create($a_index, $b_index);
    }
    for($i = 0; $i -lt $paired_index_array.Length; $i++){
        $LetterIndex1 = $paired_index_array[$i].Item1;
        $LetterIndex2 = $paired_index_array[$i].Item2;
        # Row Rule
        if($LetterIndex1.Item1 -eq $LetterIndex2.Item1){
            if($LetterIndex1.Item2 -eq 0){
                $result += $table[$LetterIndex1.Item1, 4];
                $result += $table[$LetterIndex2.Item1, ($LetterIndex2.Item2-1)];
                continue;
            }
            if ($LetterIndex2.Item2 -eq 0) {
                $result += $table[($LetterIndex1.Item1), ($LetterIndex1.Item2-1)];
                $result += $table[$LetterIndex2.Item1, 4]; 
                continue;
            }
            
                $result += $table[$LetterIndex1.Item1, ($LetterIndex1.Item2-1)];
                $result += $table[$LetterIndex2.Item1, ($LetterIndex2.Item2-1)];
            continue;
        }
        # Column Rule
        if ($LetterIndex1.Item2 -eq $LetterIndex2.Item2) {         
            if($LetterIndex1.Item1  -eq 0){
                $result += $table[4, $LetterIndex1.Item2];
                $result += $table[($LetterIndex2.Item1-1), $LetterIndex2.Item2];
                continue;
            }
            if ($LetterIndex2.Item1 -eq 0) {
                $result += $table[($LetterIndex1.Item1-1), $LetterIndex1.Item2];
                $result += $table[4, $LetterIndex2.Item2]; 
                continue;
            }
                $result += $table[($LetterIndex1.Item1-1), ($LetterIndex1.Item2)];
                $result += $table[($LetterIndex2.Item1-1), ($LetterIndex2.Item2)];
            continue;
        }
        # Rectangle rule
            $result += $table[$LetterIndex1.Item1, $LetterIndex2.Item2];
            $result += $table[$LetterIndex2.Item1, $LetterIndex1.Item2];
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