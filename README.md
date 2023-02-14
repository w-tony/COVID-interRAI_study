# Impact of the COVID-19 Delta-Omicron outbreak on the health and psychosocial wellbeing of New Zealanders living in aged residential care

COVID-19 related restrictions could lead to poorer health outcomes in older 
adults. This project will investigate the health and wellbeing impacts of the 
Delta-Omicron outbreak in aged residential care.

##  Table of Contents
 - <a href="#data-linkage">Data Selection</a>
 - Next section

##  Data Selection

```latex {cmd=true hide=true}
 \begin{tikzpicture}[every node/.style={fill=white,font=\sffamily},align=center]
				\node (interRAIRead)	[activityStarts]	{Total number of interRAI assessments between 17/08/2018 to 17/08/2022 ($n=289300$)};
				\node (discardEthnicities) [startstop,below of=interRAIRead,xshift=5.0cm,yshift=-0.5cm]	{Excluded assessments with the ethnicities categorised under "Refused to Answer", "Response Unidentifiable", "Not stated" \& "Don't know" ($n=70$)};
				\node (interRAIEthnicities)	[process,below of=interRAIRead,yshift=-1.9cm]	{interRAI assessments categorised under all other ethnicities ($n=289230$)};
				\node (discardAges) [startstop,below of=interRAIEthnicities,xshift=5.0cm,yshift=-0.5cm]	{Excluded assessments taken below 60 and above 105 $(n=5183)$};
				\node (interRAIAges) [process,below of=interRAIEthnicities,yshift=-2.0cm]	{interRAI assessments taken between the ages of 60 to 105 ($n=284047$)};
				\node (discardDates) [startstop,below of=interRAIAges,xshift=5.0cm,yshift=-0.5cm]	{Excluded assessments between 17/08/2019 to 16/08/2021 ($n=143923$)};
				\node (preCovid) [process,below of=interRAIAges,xshift=-5.0cm,yshift=-2.5cm]	{Number of interRAI assessments between 17/08/2018 to 16/08/2019 $(n=71527)$};
				\node (omicron) [process,below of=interRAIAges,xshift=5.0cm,yshift=-2.5cm]	{Number of interRAI assessments between 17/08/2021 to 16/08/2022 $(n=68597)$};
				\node (preCovidFinal) [process,below of=preCovid,yshift=-1.5cm]	{Final interRAI assessments from each unique individual during the pre-COVID-19 era $(n=39444)$};
				\node (omicronFinal) [process,below of=omicron,yshift=-1.5cm] {Final interRAI assessments from each unique individual throughout the Omicron wave $(n=39382)$};
				\node (preCovidDeaths) [report,below of=preCovidFinal,yshift=-1.5cm]	{Number of individuals who: \\
					\hspace{2pt}Survived ($n=30535, 77.41\%$) \\
					\hspace{2pt}Died ($n=8909, 23.59\%$)};
				\node (omicronCases) [report,left of=omicronFinal,xshift=-4.0cm,yshift=-3.1cm] {Total recorded COVID-19 cases: \\
					\hspace{2pt} None ($n=33773, 85.66\%$) \\
					\hspace{2pt} Once ($n=13434, 14.03\%$) \\
					\hspace{2pt} Twice ($n=80, 0.20\%$) \\
					\hspace{2pt} Three times ($n=4, 0.01\%$)};
				\node (omicronDoses) [report,below of=omicronFinal,yshift=-2.5cm] {Total vaccination doses attained: \\
					\hspace{2pt} None ($n=1524, 3.87\%$) \\
					\hspace{2pt} 1 dose ($n=354, 1.49\%$) \\
					\hspace{2pt} 2 doses ($n=7393, 18.77\%$) \\
					\hspace{2pt} 3 doses ($n=28403, 46.12\%$) \\
					\hspace{2pt} 4 doses ($n=1476, 3.75\%$) \\
					\hspace{2pt} 5 doses ($n=1, 2.54\times10^{-3}\%$)};
				\node (omicronDeaths) [report,right of=omicronFinal,yshift=-2.0cm,xshift=4.0cm,yshift=-0.5cm] {Number of individuals who: \\
					\hspace{2pt}Survived ($n=29704, 75.43\%$) \\
					\hspace{2pt}Died ($n=9678, 25.57\%$)};
				\draw[->]	(interRAIRead) -- (interRAIEthnicities);
				\draw[->]	(interRAIRead) |- (discardEthnicities);
				\draw[->]	(interRAIEthnicities) -- (interRAIAges);
				\draw[->]	(interRAIEthnicities) |- (discardAges);
				\draw[->]	(interRAIAges) |- (preCovid);
				\draw[->] 	(interRAIAges) |- (discardDates);
				\draw[->]	(interRAIAges) |- (omicron);
				\draw[->]	(preCovid) -- (preCovidFinal);
				\draw[->]	(omicron) -- (omicronFinal);
				\draw[->]	(preCovidFinal) -- (preCovidDeaths);
				\draw[->]	(omicronFinal) -| (omicronCases);
				\draw[->]	(omicronFinal) -- (omicronDoses);
				\draw[->]	(omicronFinal) -| (omicronDeaths);
			\end{tikzpicture}
```
