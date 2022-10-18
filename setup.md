--- 
title: Setup 
--- 

## Project organization

1. Create a new project in your Desktop called `ml-biomed`. 
- Click the `File` menu button, then `New Project`.
- Click `New Directory`. 
- Click `New Project`.
- Type `ml-biomed` as the directory name. Browse to your Desktop to create the project there.
- Click the `Create Project` button.

2. Use the `Files` tab to create  a `data` folder to hold the data, a `scripts` folder to 
house your scripts, and a `results` folder to hold results. Alternatively, you can use the 
R console to run the following commands for step 2 only. You still need to create a 
project with step 1.

~~~
dir.create("./data")
dir.create("./scripts")
dir.create("./results")
~~~
{: .r}

## Package installation and data access

1. Start RStudio. 
2. Install R packages and load the libraries. You might already have some of these 
installed. Search for their names in the `Packages` tab in RStudio. There is no need to 
install them again if you find them there.

    ~~~
   install.packages("devtools", "rafalib", "RColorBrewer", "gplots", "UsingR", "class", "caret")
   library(devtools)
   library(rafalib)
   library(RColorBrewer)
   library(gplots)
   library(UsingR)
   library(class)
   library(caret)
   ~~~
{: .r}

3. Install the tissue gene expression data from Github then load the library and data.
If you were successful installing and loading `devtools` above, you should be able to 
install from Github.

   ~~~
   install_github("genomicsclass/tissuesGeneExpression") 
   library(tissuesGeneExpression) 
   data(tissuesGeneExpression)
   ~~~
{: .r}

The data represent RNA expression levels for eight tissues, each with several individuals.

Alternatively, 
[download the data directly from Github](https://github.com/genomicsclass/tissuesGeneExpression/blob/master/data/tissuesGeneExpression.rda) 
and place them in your new `data` directory. Do this if installing `devtools` or 
installing from Github gave you difficulty.

4. Load packages from Bioconductor.

~~~
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install(c("genefilter", "Biobase", "SpikeIn", "hgu95acdf")
library(genefilter)
library(Biobase)
library(SpikeIn)
library(hgu95acdf)
data(SpikeIn95)
~~~
{: .r}


{% include links.md %}
