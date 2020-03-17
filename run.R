#!/usr/bin/env Rscript
directories <- c( 'MWLS01',
                 'MWLS02',
                 'MWLS03',
                 'MWLS05',
                 'MWLS07')

for (the_dir in directories) {
  setwd(the_dir)
  for(file in list.files(path = ".", pattern = "R_script_[0-9]*_zuiver_noexo.R")) {
    print(file)
    source(file)
  }
  setwd('..')
}
