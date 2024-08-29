# pac:package name
get_pacpath = function(pac){
  data.frame(installed.packages(.Library)) -> ll
  ll[ll[,'Package']==pac,'LibPath'] -> path_
  return(paste0(path_,'/',pac))
}
