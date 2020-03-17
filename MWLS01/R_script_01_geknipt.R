#!/usr/bin/env Rscript
getwd()
#setwd("C:/Users/riann/OneDrive/Documenten/Slaapproblemen en Agitatie/LindeStede/MWLS01")
source('../R_script_run_VAR.R')

data_file <- file.path('data','MWLS01 (dagelijks_geknipt).sav')
imputed_data_file_name <- file.path('output', 'imputed_001_geknipt.csv')
autovar_output_file_name <- file.path('output','sink_SA_001_geknipt.txt')
irf_output_file_name <- file.path('output', 'sink_SA_001_geknipt_irf.txt')
irf_output_pdf_file_name <- file.path('output', 'SA_001_geknipt_irf.pdf')
te_imputeren_variabelen <- c('Tijdsvariabele', 'Agitatie.MW.geknipt', 'Actualsleeptime.hours', 'Bewolkingsgraad.KNMI')

niet_geimputeerde_variabelen <- c('Pijn.SOlogboek', 'ZN.Psychofarmaca.SOlogboek', 'Buiten.VPlogboek')
exogene_variabelen <- c('Bewolkingsgraad.KNMI', 'Pijn.SOlogboek', 'ZN.Psychofarmaca.SOlogboek', 'Buiten.VPlogboek')

agitatie_variabele = 'Agitatie.MW.geknipt'

run_var(data_file = data_file, 
        imputed_data_file_name = imputed_data_file_name, 
        autovar_output_file_name = autovar_output_file_name, 
        irf_output_file_name = irf_output_file_name, 
        irf_output_pdf_file_name = irf_output_pdf_file_name,
        te_imputeren_variabelen = te_imputeren_variabelen,
        niet_geimputeerde_variabelen = niet_geimputeerde_variabelen,
        exogene_variabelen = exogene_variabelen,
        agitatie_variabele = agitatie_variabele)

