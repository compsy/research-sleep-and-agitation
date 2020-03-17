#!/usr/bin/env Rscript
getwd()
#setwd("C:/Users/riann/OneDrive/Documenten/Slaapproblemen en Agitatie/LindeStede/MWLS03")
source('../R_script_run_VAR.R')

data_file <- file.path('data','MWLS03 (dagelijks_geknipt).sav')
imputed_data_file_name <- file.path('output', 'nonimputed_003_geknipt.csv')
autovar_output_file_name <- file.path('output','sink_SA_003_geknipt.txt')
irf_output_file_name <- file.path('output', 'sink_SA_003_geknipt_irf.txt')
irf_output_pdf_file_name <- file.path('output', 'SA_003_geknipt_irf.pdf')
te_imputeren_variabelen <- NULL

niet_geimputeerde_variabelen <- c('Tijdsvariabele', 'Agitatie.MW.geknipt', 'Actualsleeptime.hours', 'Bewolkingsgraad.KNMI', 'Hypromellose.SOlogboek', 'Pijn.Logboek', 'ZN.Psychofarmaca.Logboek')
exogene_variabelen <- c('Bewolkingsgraad.KNMI', 'Hypromellose.SOlogboek', 'Pijn.Logboek', 'ZN.Psychofarmaca.Logboek')

run_var(data_file = data_file, 
        imputed_data_file_name = imputed_data_file_name, 
        autovar_output_file_name = autovar_output_file_name, 
        irf_output_file_name = irf_output_file_name, 
        irf_output_pdf_file_name = irf_output_pdf_file_name,
        te_imputeren_variabelen = te_imputeren_variabelen,
        niet_geimputeerde_variabelen = niet_geimputeerde_variabelen,
        exogene_variabelen = exogene_variabelen)

