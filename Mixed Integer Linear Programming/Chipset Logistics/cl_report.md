## Task at hand:




## Formulation:
### Decision Variables

$x_{ij}$ = number of items shipped from node $i$ to node $j$

where $i, j \in \{(1, 2, 3, 4, 5, 6, 7\})$ represent the following nodes:
- $1$: fab1
- $2$: fab2
- $3$ : fab3
- $4$ : DC1
- $5$ : DC2
- $6$ : plant1
- $7$ : plant2

### Objective Function

The objective is to minimize the total cost, which is represented as:
```math
Z = \sum_{i} \sum_{j} \left(\text{cost matrix}_{ij} \cdot x_{ij}\right)
```
where $\text{cost matrix}_{ij}$ represents the cost of shipping one item from node $i$ to node $j$.

### Subject to
#### 1. Production Capacity Constraints
These constraints ensure that the fabs do not produce more items than their capacity:

$\sum_{j} x_{1j} - \sum_{i} x_{i1} \leq 400000$

$\sum_{j} x_{2j} - \sum_{i} x_{i2} \leq 600000$

$\sum_{j} x_{3j} - \sum_{i} x_{i3} \leq 200000$

#### 2. Distribution Centers Constraints

These constraints ensure that the number of items entering and leaving the distribution centers are equal:

$\sum_{j} x_{4j} = \sum_{i} x_{i4}$

$\sum_{j} x_{5j} = \sum_{i} x_{i5}$

#### 3. Plant Demand Constraints

These constraints ensure that plants receive the exact number of items they demand:

$\sum_{j} x_{6j} - \sum_{i} x_{i6} = -400000$

$\sum_{j} x_{7j} - \sum_{i} x_{i7} = -180000$

#### 4. Link Capacity Constraints

These constraints ensure that the number of items shipped between any pair of nodes does not exceed the maximum capacity:

$x_{ij} \leq 400000$

#### 5. Non-Negativity Constraints

These constraints ensure that the number of items shipped between nodes is always non-negative:

$x_{ij} \geq 0$
