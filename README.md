# RCSP (**R**adiomics-based **C**XCL9/**S**PP1 **P**olarization)

***

RCSP is a frendly-used radiomics tool based on R programming language. It encompasses essential functions including image format conversion, tumor section output, and radiomics feature extraction. Additionally, RCSP integrates a predictive model that estimates the CS polarization level in HCC patients based on extracted imaging features. Users can prepare CE-CT images, the package will automatically handle format conversion and feature extraction, and subsequently generate a concise report file.


![RCSP](https://github.com/YuGu-CN/RCSP/blob/main/RCSP_logo.png)

# Installing the package

***
 
To install RCSP,we recommed using devtools:  

    #install.packages("devtools")  
    devtools::install_github("YuGu-CN/RCSP")  

***

# Dependencies
- R version >= 3.5.0.
- R packages: Seurat, dplyr, reticulate, MASS, irlba, future, progress, parallel, glmnet, knitr, rmarkdown, devtools
- Python version >= 3.7.0.

# Guided Tutorials
In this tutorial, we apply CT data from human HCC patients to complete the entire process from image transformation, feature extraction, to predicting the CS polarization level of the patients.
