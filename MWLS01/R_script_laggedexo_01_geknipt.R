#!/usr/bin/env Rscript
getwd()
#setwd("C:/Users/riann/OneDrive/Documenten/Slaapproblemen en Agitatie/LindeStede/MWLS01")
source('../R_script_run_VAR.R')

data_file <- file.path('data','MWLS01 (dagelijks laggedexo_geknipt).sav')
imputed_data_file_name <- file.path('output', 'imputed_laggedexo_001_geknipt.csv')
autovar_output_file_name <- file.path('output','sink_SA_laggedexo_001_geknipt.txt')
irf_output_file_name <- file.path('output', 'sink_SA_laggedexo_001_geknipt_irf.txt')
irf_output_pdf_file_name <- file.path('output', 'SA_laggedexo_001_geknipt_irf.pdf')
te_imputeren_variabelen <- c('Laggedexo.Tijdsvariabele', 'Agitatie.MW.geknipt', 'Actualsleeptime.hours', 'Laggedbewolkingsgraad.KNMI')

niet_geimputeerde_variabelen <- c('Laggedpijn.SOlogboek', 'LaggedZN.Psychofarmaca.SOlogboek', 'Laggedbuiten.VPlogboek')
exogene_variabelen <- c('Laggedbewolkingsgraad.KNMI', 'Laggedpijn.SOlogboek', 'LaggedZN.Psychofarmaca.SOlogboek', 'Laggedbuiten.VPlogboek')

agitatie_variabele = 'Agitatie.MW.geknipt'
tijdsvariabele_naam = 'Laggedexo.Tijdsvariabele'

run_var(data_file = data_file, 
        imputed_data_file_name = imputed_data_file_name, 
        autovar_output_file_name = autovar_output_file_name, 
        irf_output_file_name = irf_output_file_name, 
        irf_output_pdf_file_name = irf_output_pdf_file_name,
        te_imputeren_variabelen = te_imputeren_variabelen,
        niet_geimputeerde_variabelen = niet_geimputeerde_variabelen,
        exogene_variabelen = exogene_variabelen,
        agitatie_variabele = agitatie_variabele,
        tijdsvariabele_naam = tijdsvariabele_naam)
