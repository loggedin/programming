# programming

This repository contains various programming projects. Each is written in both Python and R to allow the different approaches of Python and R to be clearly contrasted.

# procrustes

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
