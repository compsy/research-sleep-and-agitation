
packages <- c('ggplot2', 'reshape2')
lapply(packages, function(pkg)  {
         if (!(pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
         library(pkg, character.only=TRUE)
})

plot.irf <- function(irf_output, reverse_order) {
  result <- list()
  for(impulse in names(irf_output$irf)){
    #impulse <- names(irf_output$irf)[1]
    current_irf <- irf_output$irf[[impulse]]
    current_lower <- irf_output$Lower[[impulse]]
    current_upper <- irf_output$Upper[[impulse]]

    for(response in colnames(current_irf)){
      #response <- names(irf_output$irf)[1]
      current_response <- current_irf[, response]
      current_response_lower <- current_lower[, response]
      current_response_upper <- current_upper[, response]
      current_df <- list(from = impulse,
                         to = response,
                         df = data.frame(time = seq(0, length(current_response) - 1),
                                         irf = current_response,
                                         upper = current_response_upper,
                                         lower = current_response_lower
                                         ))
      result <- append(result, list(current_df))
    }
  }


  order <- ifelse(reverse_order, '2', '1')
  transform_name <- function(name) {
    if (startsWith(name, 'Actualsleeptime.hours')) {
      return('Sleep')
    }
    if (startsWith(name, 'Agitatie.MW') || startsWith(name, 'InAgitatie')) {
      return('Agitation')
    }
    return(name)
  }
  min_val = -40
  max_val = 40

  lapply(result, function(entry) {
    the_title <- paste(transform_name(entry$from), ' -> ', transform_name(entry$to), ', Order ', order, sep ='')
    ggplot(entry$df, aes(time, irf))+
      geom_hline(yintercept=0, colour="red")+
      geom_line(colour='black')+
      theme( axis.line = element_line(colour = "black", size = 0.5, linetype = "solid")) +
      #geom_ribbon(aes(ymin=lower,ymax=upper),alpha=0.3) +
      geom_ribbon(aes(ymin = lower, ymax = upper), fill = "steelblue2", alpha = 0.2) +
      labs(title = the_title) +
      theme(plot.title = element_text(hjust = 0.5)) +
      xlab('Step')+
      ylab('') +
      theme(panel.background = element_rect(fill = 'transparent', size=0)) +
      scale_x_continuous(breaks = seq(0,10)) + 
      scale_y_continuous(breaks = round(seq(min_val, max_val, by = 0.5),1)) +
      #ylim(min_val,max_val) + 
      theme(axis.text.x = element_text(colour='black') )+
      theme(axis.text.y = element_text(colour='black') )+
      theme(panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank()) +
      theme(panel.grid.major.y = element_line(colour="#CCCCCC"), panel.grid.minor.y = element_blank()) +
      theme(panel.border = element_blank()) +
      #theme(axis.line = element_blank())+
      theme(legend.background = element_rect(colour="white"))+
      theme(legend.key = element_rect(fill = "white", colour = "white"))+
      theme(legend.position="bottom", legend.box = "horizontal")+
      theme(legend.title=element_blank())
  })
}
