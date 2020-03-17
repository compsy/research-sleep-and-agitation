#!/usr/bin/env Rscript
set.seed(12345)

# Load (and install) the packages
packages <- c('vars', 'Rcpp', 'devtools', 'stringi', "Amelia", "foreign", "Hmisc", "testthat", "digest", "igraph", "norm")
lapply(packages, function(pkg)  {
  if (!(pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
  library(pkg, character.only=TRUE)
})
install_github('frbl/vars', force = TRUE, ref='master')
install_github('roqua/autovar', force = TRUE, ref='fb-tryout-using-p-for-globals')
source('../R_script_01_perform_IRF.R')

library('autovar')


run_var <- function(data_file, imputed_data_file_name, autovar_output_file_name, irf_output_file_name, irf_output_pdf_file_name, te_imputeren_variabelen, niet_geimputeerde_variabelen = NULL, exogene_variabelen = NULL, use_cache=TRUE, agitatie_variabele = 'Agitatie.MW', tijdsvariabele_naam = 'Tijdsvariabele') {
  set.seed(12345)
  dir.create(file.path('output'), showWarnings = FALSE)

  Nonimputed <- spss.get(data_file, to.data.frame=TRUE)

  # If we don't have anything to impute, just store the other variables
  if (is.null(te_imputeren_variabelen)) {
    write.csv(Nonimputed, file = imputed_data_file_name)
  }
  
  if (!file.exists(imputed_data_file_name) || !use_cache) {
    
    #maak nieuw object genaamd selectie
    #dit is het bestand om te imputeren
    #hierin zitten je endogene variabelen
    selectie <- subset(Nonimputed, select=te_imputeren_variabelen)
    summary(selectie)
    
    
    # Inspect the missings
    missings_actual_sleep_time <- sum(is.na(selectie$Actualsleeptime.hours))
    missings_agitation <- sum(is.na(selectie[[agitatie_variabele]]))
    
    message('Missings in sleep time data: ', missings_actual_sleep_time)
    message('Missings in agitation data: ', missings_agitation)
    
    # Show a plot the missings in the selection only if there are missings
    if(missings_actual_sleep_time > 0 && missings_agitation > 0) {
      missmap(selectie)
    }
    
    # Perform imputation
    a_out <- amelia(selectie,
                    m=100,                    # ik laat R 100 imputaties doen
                    tol=0.1,                  # hogere tolerantie om sneller/makkelijker tot convergentie te komen
                    ts=tijdsvariabele_naam,      # Specify the variable used to denote the time
                    lags=2:3,                 # voor alle variabelen behalve time wil ik een lag 1 gebruiken in de imputatie
                    # noms="xxx",             # als je aan wilt geven of een variabele nominaal is, maar nu hebben we de dummies eruit gelaten dus uitgezet
                    polytime=2,               # ik gebruik een 2e orde polynoom van time (kwadratische trend)
                    p2s=1,                    # 0 voor geen output naar het scherm. 1 voor "normale" output, 2 voor uitgebreide output
                    empri=.01*nrow(selectie), # empirical ridge prior
                    autopri=1                 # stelt empri automatisch bij als deze niet tot gewenste oplossing leidt
    )
    
    
    
    #------ je kunt wat diagnostics doen om de imputaties te checken:--------
    
    
    # Bekijk de chain lengths:
    a_out
    # unstabiele modellen kun je herkennen aan lange en erg verschillende chain lengths
    # check histogrammen
    
    # hier zie je in red de geimputeerde waarden en in zwart de geobserveerde waarden.
    # het moet er een beetje op lijken. De geimputeerde waarden een beetje in het midden.
    # je kunt hier ook kijken of de geimputeerde waarden niet buiten de bounds (= grenzen)
    # van de geobserveerde waarden vallen.
    # (de handleiding raadt het namelijk af om bounds te zetten, want daar zou je predictiemodel slechter van worden)
    # als je dit wilt doen per variabele:
    result = tryCatch({
      compare.density(a_out, var = "Actualsleeptime.hours")
      compare.density(a_out, var = agitatie_variabele)
    }, error = function(e) {
      warning('Skipping density comparison, this is probably due to the fact that only 1 observation needs to be imputed')
    })
    
    # met overimpute kun je kijken hoe goed de fit van het imputatiemodel is:
    overimpute(a_out, var = "Actualsleeptime.hours")
    overimpute(a_out, var = agitatie_variabele)
    
    
    # als y=x dan is de imputatie perfect
    # By checking how many of the confidence intervals cover the y = x line,
    # we can tell how often the imputation model can confidently predict the true value of the observation.
    # The color of the line (as coded in the legend) represents the
    # fraction of missing observations in the pattern of missingness for that observation.
    
    #kijk of startpunt uitmaakt:
    disperse(a_out, dims = 1, m = 50)
    #ze moeten allemaal naar dezelfde waarde (zwarte lijn) convergeren
    
    
    #nb wij imputeren alleen datasets die maximaal 25% missings hebben. (eigenlijk 15%, maar later zijn we iets coulanter geworden)
    #tot 15% zagen de imputaties er redelijk uit.
    #nb als er aan het eind of begin een heel leeg stuk zat, imputeerden wij dat niet (je krijgt dan rare imputaties)
    #die series werden dan dus gewoon wat korter
    
    
    #------Het middelen van de 100 geimputeerde datasets------
    
    a_out_imps <- a_out$imputations
    mean_imp <- Reduce('+',a_out_imps) / a_out$m #gemiddelde imputatie dataset berekenen
    
    if(!is.null(niet_geimputeerde_variabelen)) {
      mean_imp <- cbind(mean_imp, Nonimputed[, niet_geimputeerde_variabelen, drop=FALSE])
    }
    
    
    #View(mean_imp)
    
    plot(mean_imp$Actualsleeptime.hours, type="b")
    plot(mean_imp[[agitatie_variabele]], type="b")
    
    # Store the imputed data
    write.csv(mean_imp, file = imputed_data_file_name)


    #Je hoeft maar een keer te imputeren. Wanneer je na de imputatie de VAR analyses nogmaals
    #wilt draaien, kun je beginnen bij #AutoVAR (zie hieronder).
  }
  
  #AutoVAR
  #help(package= 'autovar')
  
  set.seed(12345)
  dataFile <- read.csv(imputed_data_file_name)
  #View(dataFile)
  
  result = tryCatch({
    plot(dataFile$Actualsleeptime.hours, type="b")
    plot(dataFile[[agitatie_variabele]], type="b")
  }, error = function(e) {
    warning('Het genereren van een plog ging niet goed!')
  })
  
  d_1 <- load_file(imputed_data_file_name, file_type="CSV", log_level=3)
  
  # Add square and linear trends
  d_1 <- add_trend(d_1)
  d_1$data[[1]]
  
  
  sink(file=autovar_output_file_name, split=TRUE)
  for (order in c(1,2)) {
    reverse_order = order == 2
    vars = c("Actualsleeptime.hours", agitatie_variabele)

    if (reverse_order) {
     vars = rev(vars)
    }

    var_model <- var_main(d_1,
                          vars=vars,
                          simple_models=TRUE,
                          lag_max=2,
                          criterion="BIC",
                          exclude_almost=TRUE,
                          exogenous_variables = exogene_variabelen,
                          log_level=3,
                          split_up_outliers=TRUE,
                          exogenous_max_iterations=3)
    print_best_models(var_model)
    sink()
    
    message('There are ', length(var_model$accepted_models), ' accepted models, using the first one')
    
    if (length(var_model$accepted_models) < 1) {
      message('Er zijn geen var modellen  gevonden!')
      quit(status=1)
    }
    
    var_model <- var_model$accepted_models[[1]]$varest
    perform_full_irf(var_model, 
                     reverse_order = reverse_order,
                     file_name = irf_output_file_name, 
                     pdf_name = irf_output_pdf_file_name)
  }
}
