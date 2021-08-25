# Ciphers_ps1

## Atbash Cipher
The Atbash cipher is a cipher where in the alphabet is mapped in reverse so the first letter becomes the last letter, the second becomes the second to last and so on. [Wikipedia](https://en.wikipedia.org/wiki/Atbash)

## Autokey Cipher
The autokey cipher is a cipher where each letter in plaintext is mapped to the [tabula recta](https://en.wikipedia.org/wiki/Tabula_recta) using a key wod or phrase [Wikipedia](https://en.wikipedia.org/wiki/Autokey_cipher). The keyword is appended with the text if it is too short for the mapping. 

## Baconian Cipher
The Baconian cipher is a type of mesage encoding wherea as each letter of the plaintext is replaced by a group of five letters consisting of either 'a' or 'b'. [Wikipedia](https://en.wikipedia.org/wiki/Bacon%27s_cipher)

## Beaufort Cipher
The Beaufort cipher is a type of substitution cipher using the [tabula recta](https://en.wikipedia.org/wiki/Tabula_recta) it works similarly to the Vigenère cipher except rather than finding the intersiection of the key and letter, you find the column with the letter then within that column of that you find the key, then the head letter of that row is the result. 

## Bifid Cipher
The Bifid cipher combines the Polybius square with transposition, it takes a key (the polybius square) and a period, used in transposition. [Wikipedia](https://en.wikipedia.org/wiki/Bifid_cipher)

Here is an example of how this might work in practice with a key of "qwertyuiopasdfghklzxcvbnm", a period of 3, and text of "Testing"

A Polybius square would be formed as such from the key 
```
q w e r t 
y u i o p 
a s d f g 
h k l z x 
c v b n m 
```
The text to be encrypted will then be put through getting the following results
```
Text  : t e s t i n g 
Row   : 0 0 2 0 1 4 2 
Column: 4 2 1 4 2 3 4 
```
Then the data will be split by period
```
Text  : tes tin g
Row   : 002 014 2
Column: 421 423 4
```
The data is then combined:
```
002421 014423 24
```
Encipher again
```
Text  : q g s w m f g 
Row   : 0 2 2 0 4 2 2
Column: 0 4 1 1 4 3 4
```
## Caesar Cipher
The Caesar cipher is a type of substitution cipher where each letter is replaced by another letter a fixed number of positions away in the alphabet. [Wikipedia](https://en.wikipedia.org/wiki/Caesar_cipher)

## Playfair Cipher
The Playfair cipher is a type of diagram substitution cipher where the key is maped to a 5x5 square filling in the rest of the alphabet afterward (typically i/j are combined) then the text is split into pairs and a series of rules determine how those letters are substituted using the diagram. 
[Wikipedia](https://en.wikipedia.org/wiki/Playfair_cipher)

## Polybius Cipher
The Polybius cipher is a substitution cipher using the [Polybius Square](https://en.wikipedia.org/wiki/Polybius_square) each letter is replaced with its coordinates in the square. 

## Porta Cipher
The porta cipher is a cipher where each letter of plaintext is mapped to a tabula using a keyword, this is a tabula specific to this cipher. The key is repeated if it is shorter than the text being encoded. 

## Rail-Fence Cipher
The rail-fence cipher is a type of transposition cipher. Each letter is taken and written in a zig zag fashion based on a numerical key, for example a message of 'hello there' with a key of 3 could be transposed as so:
```
h . . . o . . . r . 
. e . l . t . e . e 
. . l . . . h . . . 
```
which is then read from left to right providing the following ciphertext: 'horelteelh'
[Wikipedia](https://en.wikipedia.org/wiki/Rail_fence_cipher)

## Substitution Cipher
A simple substitution cipher is a cipher where each letter of an alphabet is replaced by a different letter of the alphabet provided by a key. [Wikipedia](https://en.wikipedia.org/wiki/Substitution_cipher)

## Trifid Cipher
combines substitution and transposition ciphers, it takes a key (three squares of characters) and a period (to be used in transposition)
[Wikipedia](https://en.wikipedia.org/wiki/Trifid_cipher)

Here is an example with a key of "qwertyuiopasdfghjklzxcvbnm.", a period of 3, and text of "Testing" <br />
Three squares are created from the key as shown below:
```
  0       1       2
q w e   p a s   l z x
r t y   d f g   c v b 
u i o   h j k   n m .
```
The text is then be put through the squares producing the following result
```
Text  : t e s t i n g
Box   : 0 0 1 0 0 2 1
Row   : 1 0 0 1 2 2 1
Column: 1 2 2 1 1 0 2
```
Split by periods
```
tes tin g
001 002 1
100 122 1
122 110 2
```
Combine
```
001100122 002122110 112
```
Encipher again
```
Text  : w p k e k d g
Box   : 0 1 1 0 1 1 1
Row   : 0 0 2 0 2 1 1
Column: 1 0 2 2 2 0 2
```

## Vigenère Cipher
The vigenere cipher works by substituting each letter with the corrosponding letter in the key in the tabula recta. If the key is shorter than the text it is repeated untill it is as long. [Wikipedia](https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher)