# programming

This repository contains various programming projects. Each is written in both Python and R to allow the different approaches of Python and R to be clearly contrasted.

## procrustes

Given two matrices, $X, Y \in \mathbb{R} ^ {n \times p}$, the orthogonal Procrustes problem is to find the orthogonal matrix, $R \in \mathbb{R} ^ {p \times p}$, which minimises the distance between $X$ and $YR$ in terms of the Frobenius norm:

$$
R^* = \mathop{\arg \min}\limits_{R} \lVert YR - X \rVert _F^2,
$$

where the Frobenius norm of a $n \times m$ matrix, $A$, can be defined as

$$
\lVert A \rVert \_F = \left( \sum_{i=1}^{n} \sum_{j=1}^{m} \lvert A_{ij} \rvert^2 \right)^{1/2}.
$$

The solution to the problem (Schönemann, 1966) is found by computing the singular value decomposition (SVD) of $Y^T X$,

$$
Y^T X = U \Sigma V^T,
$$

where $\Sigma \in \mathbb{R} ^ {p \times p}$ contains the rank($Y^T X$) singular values and $U \in \mathbb{R} ^ {p \times p}$, $V \in \mathbb{R} ^ {p \times p}$ the corresponding left and right singular vectors. Then

$$
R^* = UV^T.
$$

Procrustes analysis is useful for comparing the shape of objects. Given observations $`y = \{ Y_t \in \mathbb{R} ^ {n \times p} \ : \ t = 1, \ldots, T \}`$, the goal is to apply an orthogonal transformation to each $Y_t$ (using the equation above) such that it is most closely aligned (in terms of the Frobenius norm) with some reference, $X_{\text{ref}} \in \mathbb{R} ^ {n \times p}$. Initially, $X_{\text{ref}}$ is set at random to one of the elements of $y$. In Generalised Procrustes Analysis (Gower, 1975), the sample mean of the transformed observations is computed as

$$
\overline{Y} = \frac{1}{T} \sum_{t=1}^{T} Y_t R_t^*,
$$

where $R_t^*$ is the optimal orthogonal transformation of $Y_t$. If

$$
d_P \equiv \lVert \overline{Y} - X_{\text{ref}} \rVert_F > \rho
$$

for a given threshold $\rho \in \mathbb{R}^+$, then $X_{\text{ref}}$ is set to $X_{\text{ref}} \leftarrow \overline{Y}$ and the optimal orthogonal transformations are recomputed for each $Y_t \in y$.

It is useful to be able to compute the sample mean sequentially. The sequential update formula at time $t$ is

$$
\overline{Y} \_t = \left( 1 - \frac{1}{t} \right) \overline{Y}_{t-1} + \frac{1}{t} Y_t
$$

for $t \geq 2$, after initialising $\overline{Y}_1 = Y_1$.

In this project, I design a class that Procrustes aligns $Y_t$ with $X_{\text{ref}}$, sequentially updates $\overline{Y}$ using the equation above, and computes the Procrustes distance, $d_P$.

## vigenere

A classic method for encrypting a message is the Caesar cipher, where encryption is performed by shifting each letter in the message by a fixed number of units; for example, Julius Caesar used a shift of 3 units, i.e. `a → D`, `b → E`, etc., so he would have encrypted the message `cat` as `FDW`. Decryption is performed by shifting the letters in the opposite direction. (We use lowercase letters to indicate the decrypted message and uppercase letters to indicate the encrypted message, and the standard order of the Latin alphabet.)

The Vigenère cipher is an advanced version of the Caesar cipher first described by Giovan Battista Bellaso in 1553. This method uses a secret keyword to shift the letters by different amounts, rather than a fixed amount as in the Caesar cipher.

One tool to aid in implementing the Vigenère cipher is the *tabula recta*, or table of alphabets, shown below. While the first row has the alphabet written out in the usual order A to Z, the following rows all start with subsequent letters, with the initial letters shifted cyclically to the end of the row. For example, the second row starts with B until Z, and ends in A, while the last row starts with Z, followed by A to Y.

$$
\begin{array}{ccccccccccccccccccccccccccc}
 & A & B & C & D & E & F & G & H & I & J & K & L & M & N & O & P & Q & R & S & T & U & V & W & X & Y & Z \\
A & A & B & C & D & E & F & G & H & I & J & K & L & M & N & O & P & Q & R & S & T & U & V & W & X & Y & Z \\
B & B & C & D & E & F & G & H & I & J & K & L & M & N & O & P & Q & R & S & T & U & V & W & X & Y & Z & A \\
C & C & D & E & F & G & H & I & J & K & L & M & N & O & P & Q & R & S & T & U & V & W & X & Y & Z & A & B \\
D & D & E & F & G & H & I & J & K & L & M & N & O & P & Q & R & S & T & U & V & W & X & Y & Z & A & B & C \\
E & E & F & G & H & I & J & K & L & M & N & O & P & Q & R & S & T & U & V & W & X & Y & Z & A & B & C & D \\
F & F & G & H & I & J & K & L & M & N & O & P & Q & R & S & T & U & V & W & X & Y & Z & A & B & C & D & E \\
G & G & H & I & J & K & L & M & N & O & P & Q & R & S & T & U & V & W & X & Y & Z & A & B & C & D & E & F \\
H & H & I & J & K & L & M & N & O & P & Q & R & S & T & U & V & W & X & Y & Z & A & B & C & D & E & F & G \\
I & I & J & K & L & M & N & O & P & Q & R & S & T & U & V & W & X & Y & Z & A & B & C & D & E & F & G & H \\
J & J & K & L & M & N & O & P & Q & R & S & T & U & V & W & X & Y & Z & A & B & C & D & E & F & G & H & I \\
K & K & L & M & N & O & P & Q & R & S & T & U & V & W & X & Y & Z & A & B & C & D & E & F & G & H & I & J \\
L & L & M & N & O & P & Q & R & S & T & U & V & W & X & Y & Z & A & B & C & D & E & F & G & H & I & J & K \\
M & M & N & O & P & Q & R & S & T & U & V & W & X & Y & Z & A & B & C & D & E & F & G & H & I & J & K & L \\
N & N & O & P & Q & R & S & T & U & V & W & X & Y & Z & A & B & C & D & E & F & G & H & I & J & K & L & M \\
O & O & P & Q & R & S & T & U & V & W & X & Y & Z & A & B & C & D & E & F & G & H & I & J & K & L & M & N \\
P & P & Q & R & S & T & U & V & W & X & Y & Z & A & B & C & D & E & F & G & H & I & J & K & L & M & N & O \\
Q & Q & R & S & T & U & V & W & X & Y & Z & A & B & C & D & E & F & G & H & I & J & K & L & M & N & O & P \\
R & R & S & T & U & V & W & X & Y & Z & A & B & C & D & E & F & G & H & I & J & K & L & M & N & O & P & Q \\
S & S & T & U & V & W & X & Y & Z & A & B & C & D & E & F & G & H & I & J & K & L & M & N & O & P & Q & R \\
T & T & U & V & W & X & Y & Z & A & B & C & D & E & F & G & H & I & J & K & L & M & N & O & P & Q & R & S \\
U & U & V & W & X & Y & Z & A & B & C & D & E & F & G & H & I & J & K & L & M & N & O & P & Q & R & S & T \\
V & V & W & X & Y & Z & A & B & C & D & E & F & G & H & I & J & K & L & M & N & O & P & Q & R & S & T & U \\
W & W & X & Y & Z & A & B & C & D & E & F & G & H & I & J & K & L & M & N & O & P & Q & R & S & T & U & V \\
X & X & Y & Z & A & B & C & D & E & F & G & H & I & J & K & L & M & N & O & P & Q & R & S & T & U & V & W \\
Y & Y & Z & A & B & C & D & E & F & G & H & I & J & K & L & M & N & O & P & Q & R & S & T & U & V & W & X \\
Z & Z & A & B & C & D & E & F & G & H & I & J & K & L & M & N & O & P & Q & R & S & T & U & V & W & X & Y \\
\end{array}
$$

Let us look at how to implement the Vigenère cipher. Suppose the message to be encrypted is `imperialcollege` and the secret keyword is `MATRIX` (we also use uppercase letters for the keyword). The first step is to write out the letters of the keyword repeatedly until the new key string has the same number of letters as the message, i.e.

**Message:** `imperialcollege`  
**Key string:** `MATRIXMATRIXMAT`  
**Encrypted:** `UMIVZFMLVFTIQGX`

In the example above, you will notice that the key string has the keyword repeated twice and then ends in `MAT`, since this makes the key string the same number of letters as the message. (Usually, the keyword is shorter than the message, but if the message had $m$ letters and the keyword had $k > m$ letters, then only the first $m$ letters of the keyword need to be used).

Next, the message is encrypted one letter at a time. Each letter of the message is encrypted by shifting it according to the corresponding letter in the key string. For example, the first letter of the message is `i`, and the first letter in the key string is `M`, so we would shift the letter `i` by `M` units, where `A` is 0, `B` is 1, `C` is 2, etc. We can use the tabula recta to help us with this: in row `M` and column `I` we see the letter is `U`, so `i` is encrypted as `U`.

The second letter in the message is `m` and the corresponding (second) key string letter is `A`, so in row `A`, column `M` of the tabula recta, the encrypted letter is `M`. Repeating this procedure, leads to the encrypted text `UMIVZFMLVFTIQGX`.

Messages can also be decrypted using the inverse process. For example, the first letter of the encrypted message `U` corresponds with the first letter `M` in the key string. Therefore, to decrypt it, we look at the row starting with `M` and find the letter `U` in this row; we see that `U` is in column `I`, so the decrypted letter is `i`. If we look at the last letter of the encrypted message, `X`, which has the corresponding (last) key string letter `T`, we look in row `T` and find the `X` is in column `E`, so the decrypted letter is `e`.

Instead of using the tabula recta, it is also possible to implement the Vigenère cipher using modular arithmetic.
