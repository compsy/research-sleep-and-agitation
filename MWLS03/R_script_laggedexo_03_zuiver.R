#!/usr/bin/env Rscript
getwd()
#setwd("C:/Users/riann/OneDrive/Documenten/Slaapproblemen en Agitatie/LindeStede/MWLS03")
source('../R_script_run_VAR.R')

data_file <- file.path('data','MWLS03 (dagelijks laggedexo_zuiver).sav')
imputed_data_file_name <- file.path('output', 'nonimputed_laggedexo_003_zuiver.csv')
autovar_output_file_name <- file.path('output','sink_SA_laggedexo_003_zuiver.txt')
irf_output_file_name <- file.path('output', 'sink_SA_laggedexo_003_zuiver_irf.txt')
irf_output_pdf_file_name <- file.path('output', 'SA_laggedexo_003_zuiver_irf.pdf')
te_imputeren_variabelen <- NULL

niet_geimputeerde_variabelen <- c('Laggedexo.Tijdsvariabele', 'Agitatie.MW', 'Actualsleeptime.hours', 'Laggedbewolkingsgraad.KNMI', 'Laggedhypromellose.SOlogboek', 'Laggedpijn.Logboek', 'LaggedZN.Psychofarmaca.Logboek')
exogene_variabelen <- c('Laggedbewolkingsgraad.KNMI', 'Laggedhypromellose.SOlogboek', 'Laggedpijn.Logboek', 'LaggedZN.Psychofarmaca.Logboek')

tijdsvariabele_naam = 'Laggedexo.Tijdsvariabele'
run_var(data_file = data_file, 
        imputed_data_file_name = imputed_data_file_name, 
        autovar_output_file_name = autovar_output_file_name, 
        irf_output_file_name = irf_output_file_name, 
        irf_output_pdf_file_name = irf_output_pdf_file_name,
        te_imputeren_variabelen = te_imputeren_variabelen,
        niet_geimputeerde_variabelen = niet_geimputeerde_variabelen,
        exogene_variabelen = exogene_variabelen,
        tijdsvariabele_naam = tijdsvariabele_naam)

