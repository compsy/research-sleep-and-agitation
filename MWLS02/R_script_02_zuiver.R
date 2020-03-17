#!/usr/bin/env Rscript
getwd()
#setwd("C:/Users/riann/OneDrive/Documenten/Slaapproblemen en Agitatie/LindeStede/MWLS02")
source('../R_script_run_VAR.R')

data_file <- file.path('data','MWLS02 (dagelijks_zuiver).sav')
imputed_data_file_name <- file.path('output', 'imputed_002_dagelijks_zuiver.csv')
autovar_output_file_name <- file.path('output','sink_SA_002_dagelijks_zuiver.txt')
irf_output_file_name <- file.path('output', 'sink_SA_002_dagelijks_zuiver_irf.txt')
irf_output_pdf_file_name <- file.path('output', 'SA_002_dagelijks_zuiver_irf.pdf')
te_imputeren_variabelen <- c('Tijdsvariabele', 'Agitatie.MW', 'Actualsleeptime.hours', 'Bewolkingsgraad.KNMI')
  
niet_geimputeerde_variabelen <- c('Wondje.SOlogboek')
exogene_variabelen <- c('Bewolkingsgraad.KNMI', 'Wondje.SOlogboek')

run_var(data_file = data_file, 
        imputed_data_file_name = imputed_data_file_name, 
        autovar_output_file_name = autovar_output_file_name, 
        irf_output_file_name = irf_output_file_name, 
        irf_output_pdf_file_name = irf_output_pdf_file_name,
        te_imputeren_variabelen = te_imputeren_variabelen,
        niet_geimputeerde_variabelen = niet_geimputeerde_variabelen,
        exogene_variabelen = exogene_variabelen)

