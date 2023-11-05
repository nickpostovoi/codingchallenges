## Task at hand:

## Formulation:

### Decision variables

- $x_{ij}$ : kilometers of Type-A cable produced in plant $i$ in month $j$
- $y_{ij}$ : kilometers of Type-B cable produced in plant $i$ in month $j$
- $invX_j$ : inventory of Type-A cable at the end of month $j$
- $invY_j$ : inventory of Type-B cable at the end of month $j$

where $i \in \{1,2\}$ (plants) and $j \in \{1,2,3\}$ (months).

### Objective function

Maximize profit:
```math
\begin{align*}
Z &= \text{Revenue} - \text{Costs} = \\
&= \text{Revenue} - \left(\text{Production Costs} + \text{Raw Material Costs} + \text{Packing Costs} + \text{Inventory Costs}\right) = \\
&= \sum_j \left(14 \cdot (x_{1j} + x_{2j}) - 10 \cdot (0.3x_{1j} + 0.32x_{2j}) - 6.2 \cdot (x_{1j} + x_{2j}) - 0.46 \cdot (x_{1j} + x_{2j}) - 0.20 \cdot \text{invX}_j\right) + \\
&\quad + \sum_j \left(18 \cdot (y_{1j} + y_{2j}) - 10 \cdot (0.24y_{1j} + 0.28y_{2j}) - 7.8 \cdot (y_{1j} + y_{2j}) - 0.46 \cdot (y_{1j} + y_{2j}) - 0.20 \cdot \text{invY}_j\right)
\end{align*}
```

### Subject to:

#### 1. Production capacity constraints:

$0.3x_{1,1} + 0.24y_{1,1} \leq 1400$ </br>
$0.3x_{1,2} + 0.24y_{1,2} \leq 600$ </br>
$0.3x_{1,3} + 0.24y_{1,3} \leq 2000$ </br>
$0.3(2x_{2,1}) + 0.28y_{2,1} \leq 3000$ </br>
$0.3(2x_{2,2}) + 0.28y_{2,2} \leq 800$ </br>
$0.3(2x_{2,3}) + 0.28y_{2,3} \leq 600$ </br>

#### 2. Monthly demand fulfilment:

$x_{1,1} + x_{2,1} \geq 8000$ </br>
$x_{1,2} + x_{2,2} + \text{inv}X_{1} \geq 16000$ </br>
$x_{1,3} + x_{2,3} + \text{inv}X_{2} \geq 6000$ </br>
$y_{1,1} + y_{2,1} \geq 2000$ </br>
$y_{1,2} + y_{2,2} + \text{inv}Y_{1} \geq 10000$ </br>
$y_{1,3} + y_{2,3} + \text{inv}Y_{2} \geq 10000$ </br>

#### 3. Inventory constraints:

$\text{inv}X_{1} = x_{1,1} + x_{2,1} - 8000$ </br>
$\text{inv}X_{2} = x_{1,2} + x_{2,2} + \text{inv}X_{1} - 16000$ </br>
$x_{1,3} + x_{2,3} + \text{inv}X_{2} = 6000$ (no inventory at the end of March) </br>
$\text{inv}Y_{1} = y_{1,1} + y_{2,1} - 2000$ </br>
$\text{inv}Y_{2} = y_{1,2} + y_{2,2} + \text{inv}Y_{1} - 10000$ </br>
$y_{1,3} + y_{2,3} + \text{inv}Y_{2} = 10000$ (no inventory at the end of March) </br>
