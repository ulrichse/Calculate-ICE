# Calculate-ICE
R code to calculate the Index of Concentration of Extremes (ICE) using the 'tidycensus' package. 
This code creates an ICE score file for a selected geographic unit, state, and ACS survey year. 

## Index of Concentration at the Extremes (ICE)

The **Index of Concentration at the Extremes (ICE)** is a spatial metric used to quantify racial and economic inequality within geographic units such as ZIP Code Tabulation Areas (ZCTAs). ICE values range from **−1 to 1**, where:

- **−1** indicates complete concentration of a disadvantaged group (e.g., low-income or racially minoritized populations),
- **+1** indicates complete concentration of an advantaged group (e.g., high-income or non-Hispanic white populations),
- **0** indicates an equal distribution or no concentration of either group.

ICE has been used as a measure of **spatial social inequality** in both socioeconomic (Massey 1996, 2001) and racial contexts ([Krieger et al., 2015](https://pubmed.ncbi.nlm.nih.gov/26093080/); [Krieger et al., 2016](https://pmc.ncbi.nlm.nih.gov/articles/PMC4815605/)). It is commonly applied in studies examining the effects of structural racism and racialized economic inequality on health outcomes (e.g., [Chambers et al., 2019](https://pubmed.ncbi.nlm.nih.gov/29869317/); [Mitchell et al., 2022](https://geo.appstate.edu/sites/default/files/mitchelletal_2022.pdf); [Dyer et al., 2022](https://pmc.ncbi.nlm.nih.gov/articles/PMC8684557/); [Sonderlund et al., 2022](https://pmc.ncbi.nlm.nih.gov/articles/PMC8797220/)).

### Additional publications using ICE metrics: 
- [Ulrich et al. 2025](https://www.thelancet.com/journals/lanam/article/PIIS2667-193X(25)00008-0/fulltext), [2023](https://www.sciencedirect.com/science/article/pii/S2666560323000853)
- [Ryan et al. 2024](https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2023GH000959)
- [Runkle et al. 2022](https://www.medrxiv.org/content/10.1101/2022.06.11.22276277v1.full)
- [Sugg et al. 2023](https://www.jahonline.org/article/S1054-139X(22)00508-0/fulltext)

### Methodology

ICE is calculated using the following general formula:

ICE<sub>q</sub> = (T<sub>aq</sub> − T<sub>pq</sub>) / T<sub>q</sub>

Where:
- q is the geographic unit (e.g., ZCTA, census tract),
- T<sub>aq</sub> is the number of individuals in the advantaged group,
- T<sub>pq</sub> is the number of individuals in the disadvantaged group,
- T<sub>q</sub> is the total population (or total households) in that location.

The groups used in the numerator depend on whether ICE is measuring **income-based** or **race-based** concentration, as described below.

---

| ICE Metric | Equation                                | Variables |
|------------|------------------------------------------|-----------|
| **Income** | ICE<sub>q</sub> = (T<sub>aq</sub> − T<sub>pq</sub>) / T<sub>q</sub> | `q`: geographic location  <br> `T_aq`: Number of households with an annual income ≥ $100,000  <br> `T_pq`: Number of households with an annual income < $25,000  <br> `T_q`: Total number of households with income data |
| **Race**   | ICE<sub>q</sub> = (T<sub>aq</sub> − (T<sub>p1q</sub> + T<sub>p2q</sub>)) / T<sub>q</sub> | `q`: geographic location  <br> `T_aq`: Total number of non-Hispanic white persons  <br> `T_p1q`: Total number of Black persons  <br> `T_p2q`: Total number of non-white Hispanic persons  <br> `T_q`: Total number of persons with race/ethnicity data |
| **Income & Race**   | ICE<sub>q</sub> = (T<sub>aq</sub> − (T<sub>p1q</sub> + T<sub>p2q</sub>)) / T<sub>q</sub> | `q`: geographic location  <br> `T_aq`: Number of white households with an annual income ≥ $100,000  <br> `T_p1q`: Number of Black households with an annual income < $25,000  <br> `T_p2q`: Number of non-white Hispanic households with an annual income < $25,000  <br> `T_q`: Total number of households with income data |

