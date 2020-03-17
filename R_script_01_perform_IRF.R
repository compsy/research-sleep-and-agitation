source('../R_script_01_plot_IRF.R')

perform_full_irf <- function(var_model, file_name, pdf_name, reverse_order) {
  temp_name <- file_name
  temp_pdf_name <- pdf_name
  if (reverse_order) {
    # Remove the extension
    temp_name <- substr(temp_name, 1, nchar(temp_name) - 4)
    temp_name <- paste(temp_name, "order_2.txt", sep = "_")

    # Remove the extension
    temp_pdf_name <- substr(temp_pdf_name, 1, nchar(temp_pdf_name) - 4)
    temp_pdf_name <- paste(temp_pdf_name, "order_2.pdf", sep = "_")
  }

  # Record output
  var_model
  sink(file = temp_name, split = TRUE)
  plots <- perform_irf(var_model, reverse_order)
  sink()

  # Plot to pdfs
  print(temp_pdf_name)
  pdf(file = temp_pdf_name, reverse_order)
  lapply(plots, plot)
  dev.off()
}


perform_irf <- function(var_model, reverse_order, seed= 1234, horizon = 10, orthogonalize = TRUE, bootstrap_iterations = 2000, ci = .95) {
  set.seed(seed)
  #unloadNamespace('autovar')
  #devtools::load_all('../../vars')
  #reverse_order <<- TRUE

  # Calculate the actual IRF calculation,
  if (reverse_order) {
    message('Running order 2 regular IRF')
  } else {
    message('Running order 1 IRF')
  }

  irf_output <- irf(seed = seed,                   # Use a seed so we get the same result every time
                    var_model,                     # Specify the var model to use
                    n.ahead = horizon,             # Specify the horizon / number of steps we'd like to predict
                    boot = TRUE,                   # use bootstrapping
                    runs = bootstrap_iterations,   # and use the bootstrapping for x iterations
                    cumulative = FALSE,            # Don't compute the cumulative irf
                    ortho = orthogonalize)         # And include orthogonality

  print('IRF coefficients')
  print(irf_output)

  # Generate some nice irf plots
  plots <- plot.irf(irf_output, reverse_order)

  if (reverse_order) {
    message('Running order 2 cumulative IRF')
  } else {
    message('Running order 1 cumulative IRF')
  }
  irf_output <- irf(seed = seed,                   # Use a seed so we get the same result every time
                    var_model,                     # Specify the var model to use
                    n.ahead = horizon,             # Specify the horizon / number of steps we'd like to predict
                    boot = TRUE,                   # use bootstrapping
                    runs = bootstrap_iterations,   # and use the bootstrapping for x iterations
                    cumulative = TRUE,             # Don't compute the cumulative irf
                    ortho = orthogonalize)         # And include orthogonality

  print('Cumulative IRF coefficients')
  print(irf_output)

  message('Running forcast error variance decomposition')

  if (reverse_order) {
    print('Forecast error variance decomposition results (order 2)')
  } else {
    print('Forecast error variance decomposition results (order 1)')
  }
  fevd_output <- fevd(var_model, n.ahead=horizon, reverse_order = reverse_order, seed = seed)
  print(fevd_output)

  # TODO: Change the direction of the expected effect (if using orthogonalization)
  plots
}


