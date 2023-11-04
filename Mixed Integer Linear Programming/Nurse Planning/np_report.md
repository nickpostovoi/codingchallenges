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

## Solution:

Decision variables:

\(f_i\) = number of full-time nurses starting a cycle in day of a week \(i\)
\(p_i\) = number of part-time nurses starting a cycle in day of a week \(i\)

where 
\(i \in \{1,2,3,4,5,6,7\}\)  (days of a week)


Minimize the weekly cost:
WC = ((f_1+f_4+f_5+f_6+f_7)*250 + (p_1+p_6+p_7)*150) + ((f_1+f_2+f_5+f_6+f_7)*250 + (p_1+p_2+p_7)*150) + ((f_1+f_2+f_3+f_6+f_7)*250 + (p_1+p_2+p_3)*150) + ((f_1+f_2+f_3+f_4+f_7)*250 + (p_2+p_3+p_4)*150) + ((f_1+f_2+f_3+f_4+f_5)*250 + (p_3+p_4+p_5)*150) + ((f_2+f_3+f_4+f_5+f_6)*315 + (p_4+p_5+p_6)*185) + ((f_3+f_4+f_5+f_6+f_7)*375 + (p_5+p_6+p_7)*225)
= 1250*f_1 + 1315*f_2 + 1375*f_7 + 1440*f_3 + 1440*f_4 + 1440*f_5 + 1440*f_6 + 450*p_1 + 450*p_2 + 450*p_3 + 485*p_4 + 525*p_7 + 560*p_5 + 560*p_6



