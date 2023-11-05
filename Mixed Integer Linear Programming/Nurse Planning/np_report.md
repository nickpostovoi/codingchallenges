## Task at hand:

<p>The infusion center at UMC Hospital provides (drug) administration services for various treatments, including cancer chemotherapy, immunotherapy, rheumatoid treatments, ferrotherapy, and blood transfusion. To ensure a reliable patient flow throughout the day, i.e., short waiting time for patients and little overtime for nurses, the center requires at least the following number of nurses to be scheduled to work at the center throughout the week:</p>

| Mon | Tue | Wed | Thu | Fri | Sat | Sun |
|-----|-----|-----|-----|-----|-----|-----|
| 17  | 13  | 15  | 19  | 14  | 16  | 11  |

<p>If a full-time nurse is employed, she is required to work five consecutive days followed by two days off. A part-time nurse is required to work three consecutive days followed by four days off. The cost of employing full-time and part-time nurses depends on the day of the week:

|           | Full-time | Part-time |
|-----------|-----------|-----------|
| Weekdays  | € 250/day | € 150/day |
| Saturdays | € 315/day | € 185/day |
| Sundays   | € 375/day | € 225/day |

The pay difference is because full-time nurses are specialized with extensive trainings and with permanent contracts (more costs), whereas part-time nurses are general nurses (e.g., not specialized in chemotherapy) with temporary contracts. However, according to labor regulations, at most 25% of the time can be covered by part-time employment.

Formulate and solve a mathematical program (MILP) to answer the following questions:

1. How many full-time and how many part-time nurses should the infusion center have on its payroll to minimize the total nursing cost, while meeting all requirements?
2. How much is the minimum total cost per week?

## Formulation:

### Decision variables:
```math
\begin{align*}
f_i & : \text{number of full-time nurses starting a cycle in day of the week } i \\
p_i & : \text{number of part-time nurses starting a cycle in day of the week } i
\end{align*}
```
```math
\text{where } i \in \{1,2,3,4,5,6,7\} \text{ (days of the week)}
```

### Objective function:

```math
\begin{align*}
WC &= ((f_1+f_4+f_5+f_6+f_7) \times 250 + (p_1+p_6+p_7) \times 150) \\
&+ ((f_1+f_2+f_5+f_6+f_7) \times 250 + (p_1+p_2+p_7) \times 150) \\
&+ ((f_1+f_2+f_3+f_6+f_7) \times 250 + (p_1+p_2+p_3) \times 150) \\
&+ ((f_1+f_2+f_3+f_4+f_7) \times 250 + (p_2+p_3+p_4) \times 150) \\
&+ ((f_1+f_2+f_3+f_4+f_5) \times 250 + (p_3+p_4+p_5) \times 150) \\
&+ ((f_2+f_3+f_4+f_5+f_6) \times 315 + (p_4+p_5+p_6) \times 185) \\
&+ ((f_3+f_4+f_5+f_6+f_7) \times 375 + (p_5+p_6+p_7) \times 225) \\
&= 1250 \times f_1 + 1315 \times f_2 + 1375 \times f_7 + 1440 \times f_3 \\
&+ 1440 \times f_4 + 1440 \times f_5 + 1440 \times f_6 + 450 \times p_1 \\
&+ 450 \times p_2 + 450 \times p_3 + 485 \times p_4 + 525 \times p_7 + 560 \times p_5 + 560 \times p_6
\end{align*}
```

### Subject to:

1. Part-time requirement:
```math
\begin{align*}
&\left( (p_{1}+p_{6}+p_{7})+ \right. \\
&\left. (p_{1}+p_{2}+p_{7})+ \right. \\
&\left. (p_{1}+p_{2}+p_{3})+ \right. \\
&\left. (p_{2}+p_{3}+p_{4})+ \right. \\
&\left. (p_{3}+p_{4}+p_{5})+ \right. \\
&\left. (p_{4}+p_{5}+p_{6})+ \right. \\
&\left. (p_{5}+p_{6}+p_{7}) \right) \\
&\leq \left( \right. \\
&\left( (p_{1}+p_{6}+p_{7})+ \right. \\
&\left. (p_{1}+p_{2}+p_{7})+ \right. \\
&\left. (p_{1}+p_{2}+p_{3})+ \right. \\
&\left. (p_{2}+p_{3}+p_{4})+ \right. \\
&\left. (p_{3}+p_{4}+p_{5})+ \right. \\
&\left. (p_{4}+p_{5}+p_{6})+ \right. \\
&\left. (p_{5}+p_{6}+p_{7}) \right) + \\
&\left( (f_{1}+f_{4}+f_{5}+f_{6}+f_{7})+ \right. \\
&\left. (f_{1}+f_{2}+f_{5}+f_{6}+f_{7})+ \right. \\
&\left. (f_{1}+f_{2}+f_{3}+f_{6}+f_{7})+ \right. \\
&\left. (f_{1}+f_{2}+f_{3}+f_{4}+f_{7})+ \right. \\
&\left. (f_{1}+f_{2}+f_{3}+f_{4}+f_{5})+ \right. \\
&\left. (f_{2}+f_{3}+f_{4}+f_{5}+f_{6})+ \right. \\
&\left. (f_{3}+f_{4}+f_{5}+f_{6}+f_{7}) \right) \times 0.25
\end{align*}
```

2. Minimal number of nurses requirement:

```math
\begin{align*}
&(f_{1}+f_{4}+f_{5}+f_{6}+f_{7})+(p_{1}+p_{6}+p_{7}) \geq 17 \\
&(f_{1}+f_{2}+f_{5}+f_{6}+f_{7})+(p_{1}+p_{2}+p_{7}) \geq 13 \\
&(f_{1}+f_{2}+f_{3}+f_{6}+f_{7})+(p_{1}+p_{2}+p_{3}) \geq 15 \\
&(f_{1}+f_{2}+f_{3}+f_{4}+f_{7})+(p_{2}+p_{3}+p_{4}) \geq 19 \\
&(f_{1}+f_{2}+f_{3}+f_{4}+f_{5})+(p_{3}+p_{4}+p_{5}) \geq 14 \\
&(f_{2}+f_{3}+f_{4}+f_{5}+f_{6})+(p_{4}+p_{5}+p_{6}) \geq 16 \\
&(f_{3}+f_{4}+f_{5}+f_{6}+f_{7})+(p_{5}+p_{6}+p_{7}) \geq 11
\end{align*}
```


## Solution

[Link to R code file](https://github.com/nickpostovoi/projects/blob/997eac779e8f51a7e248e6d837f3c9872bc50cec/Mixed%20Integer%20Linear%20Programming/Nurse%20Planning/np_code.r)

![Alt text](np_solution.png)

## Interpretation

The infusion centre should employ a total of 25 nurses, made up of 17 full-time nurses and 8 part-time nurses, to maximise staffing and reduce overall nursing costs while upholding all regulations. The following schema is proposed to be used for the full-time nurses: A total of 8 nurses begin their work week on Monday, followed by four on Tuesday, two on Wednesday, two on Thursday, and one on Sunday. The schedule for the part-time nursing staff should be two nurses starting their work week on Thursday and six nurses starting on Saturday. By using this solution, the infusion centre can provide patients with high-quality care while maintaining a minimum total cost of 26725 per week.
