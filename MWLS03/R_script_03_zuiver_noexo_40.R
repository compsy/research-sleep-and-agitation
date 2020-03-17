#!/usr/bin/env Rscript
getwd()
#setwd("C:/Users/riann/OneDrive/Documenten/Slaapproblemen en Agitatie/LindeStede/MWLS03")
source('../R_script_run_VAR.R')

data_file <- file.path('data','MWLS03 (dagelijks_zuiver_noexo_40).sav')
imputed_data_file_name <- file.path('output', 'nonimputed_003_zuiver_noexo_40.csv')
autovar_output_file_name <- file.path('output','sink_SA_003_zuiver_noexo_40.txt')
irf_output_file_name <- file.path('output', 'sink_SA_003_zuiver_noexo_40_irf.txt')
irf_output_pdf_file_name <- file.path('output', 'SA_003_zuiver_noexo_40_irf.pdf')
te_imputeren_variabelen <- NULL

niet_geimputeerde_variabelen <- c('Tijdsvariabele', 'Agitatie.MW', 'Actualsleeptime.hours')
exogene_variabelen <- NULL

run_var(data_file = data_file, 
        imputed_data_file_name = imputed_data_file_name, 
        autovar_output_file_name = autovar_output_file_name, 
        irf_output_file_name = irf_output_file_name, 
        irf_output_pdf_file_name = irf_output_pdf_file_name,
        te_imputeren_variabelen = te_imputeren_variabelen,
        niet_geimputeerde_variabelen = niet_geimputeerde_variabelen,
        exogene_variabelen = exogene_variabelen)

