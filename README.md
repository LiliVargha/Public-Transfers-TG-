# Public Transfer (TG) Age Profiles in 50 countries and Public Transfer Clusters

This repository contains the replication file for clustering Public Transfer (TG) age profiles and visualizing the results using line plots and heatmaps for 50 countries.

### FIGURE 1: Public transfer age profile clusters (N=50, 2002-2016)
![Image](https://user-images.githubusercontent.com/68189671/217647319-f69bb149-8f31-4e6b-b0da-546720cd6ed4.jpg)
### FIGURE 2: Public transfers by age and clusters in 50 countries (2002-2016)
![Image](https://user-images.githubusercontent.com/68189671/217647508-ee6cad5b-1d2d-465d-9f33-a14c6cab9b5f.jpg)

[Download FIGURE 1](https://github.com/LiliVargha/Public-Transfers_TG/blob/main/ClusterTG.jpg)
[Download FIGURE 2](https://github.com/LiliVargha/Public-Transfers_TG/blob/main/ClusterTGtiles.jpg)

The public transfers in these figures are the age specific differences between public transfer inflows (benefits) and outflows (contributions) that are mediated by the public sector. The most important public transfer inflows are pensions, education, health services and general public services. The outflows consist mainly of taxes and social contributions registered in National Accounts. The figure shows which generations are beneficiaries and contributors of public transfers from age 0 till 85+. The values are averages calculated using  National Accounts, administrative and survey data in the different countries. The values at each age are normalized using the average labour income of age 30-49. Data is from 2002-2016, the most recent country estimations. Clustering is done using a data driven way: using Ward's clustering. For more details on this see the presentation on the typology of economic lifecycles [References below] and the replication files. For more details on the data see documentation of the data sources.

## Data source
1. [Global NTA results](https://www.ntaccounts.org/web/nta/show/Browse%20database) (Lee and Mason 2011)
2. [European AGENTA Project](http://dataexplorer.wittgensteincentre.org/nta/) (Istenič et al. 2019)

## Replication files
The file for replication is [VIZTG.R](https://github.com/LiliVargha/Public-Transfers_TG/blob/main/VIZTG.R). The file contains explanations, all the different visualizations and the clustering.

## Other versions of visualizing Public Transfer age profiles

### FIGURE 3: Public transfers in 50 countries (2002-2016) ordered according to the age of becoming net contributor

![Image](https://user-images.githubusercontent.com/68189671/217633434-0c633b40-b66e-4968-b10b-1bb50b30f145.jpg)

[Download FIGURE 3](https://github.com/LiliVargha/Public-Transfers_TG/blob/main/VizTG.jpg)

## References
Lili Vargha, Tanja Istenič: Towards a Typology of Economic Lifecycle Patterns. [Presentation at NTA14 Paris](https://ntaccounts.org/web/nta/show/Documents/Meetings/NTA14%20Abstracts) /
Lili Vargha, Bernhard Binder-Hammer, Gretchen Donehower, and Tanja Istenič: [Intergenerational transfers around the world: introducing a new visualization tool](https://www.ntaccounts.org/web/nta/show/Working%20Papers) NTA Working Papers, 2022. /
Lili Vargha, Bernhard Binder-Hammer, Gretchen Donehower, and Tanja Istenič: Visualizing Economic Lifecycles. European NTA Meeting, 15 November 2022.

## Future versions will
- Include newest NTA data.
- Use different ordering (for example by continents).
