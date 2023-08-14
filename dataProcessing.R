#data cleaning
#Simon Ciranka 2023

library('jsonlite')
library('dplyr')
library('plyr')
library('dplyr')

#############################################################################################################################
# Behavioral Data
#############################################################################################################################
#############################################################################################################################
# Adolescent data
dataImport_Adolescent <- function(dataFile ="data/gridSearch1.1.json", writecsv = FALSE){
  #read in json
  myjson <- fromJSON(readLines(dataFile))
  all_opts = expand.grid(0:7, 0:7)
  dat<-data.frame()
  
  envs = data.frame()
  ids_age = c(51, 2, 6, 57)
  subdata <- myjson
  #x-y-z
  x<-as.vector(t(subdata$searchHistory$xcollect))
  y<-as.vector(t(subdata$searchHistory$ycollect))
  z<-as.vector(t(subdata$searchHistory$zcollect))
  chosen <- apply(cbind(x,y),MARGIN=1, FUN=function(row) which(row[1]==all_opts$Var1 & row[2]==all_opts$Var2))
  zscaled <- as.vector(t(subdata$searchHistory$zcollectScaled))
  #Color value
  #time
  time<- as.vector(t(subdata$searchHistory$tscollect))
  #condition; no conditions
  #id
  id<-rep(as.numeric(subdata$participantId), length(x))
  #age
  session<-rep(as.numeric(subdata$session), length(x))
  #trial number
  trial<-rep(0:25, 10)
  #round number
  round<-rep(1:10, each=26)
  
  #dummy data frame
  dat<-data.frame(id=id, session=session, x=x, y=y, chosen=chosen, z=z, zscaled=zscaled, time=time, trial=trial, round=round)
  #bind them
  ############################################
  # save environment order
  id_env = rep(as.numeric(subdata$participantId), 10)
  round_env = 1:10
  envOrder = subdata$envOrder
  envs = data.frame(id=id_env, round=round_env, env=envOrder,session=subdata$session)

  
  
  ##########################################
  # compute distance between choices ------
  ##########################################
  dat <- dat %>% 
    arrange(id, round, trial) %>% # make sure rounds, trials etc are in the correct order
    mutate(distance = NA)
  
  # compute (Manhattan) distance between consecutive choices
  for(i in 1:(dim(dat)[1]-1)){
    dat$distance[i+1] <- dist(rbind(c(dat$x[i], dat$y[i]), c(dat$x[i+1], dat$y[i+1])), method = "manhattan")
  }
  
  # set distance for initial trial (=randomly revealed tile) to NA and classify distances
  dat <- dat %>% 
    mutate(distance = ifelse(trial == 0, NA, distance),
           type_choice = case_when(
             distance == 0 ~ "Repeat",
             distance == 1 ~ "Near",
             distance >1   ~ "Far"
             #is.na() ~ "nope",
           )) %>% 
    mutate(type_choice = factor(type_choice, levels = c('Repeat', 'Near', 'Far')))
  
  # distance as function of reward on previous trial ------------------------
  dat$previous_reward <- NA
  
  # add column with reward obtained on previous step
  for(i in 1:nrow(dat)){
    if(dat$trial[i] != 0) {
      dat$previous_reward[i] <-  dat$z[i-1]
    }
  }
  
  if (writecsv==TRUE){
    write.table(dat, file="data/AdolescentGrid.csv", sep=",", row.names = F)
    write.table(envs, file="data/AdolescentEnvironments.csv", sep=",", row.names = F)  
  }
  return(dat)
}


cohensd.ci <- function(d, n1, n2, ci = 0.95) {
  t <- d * sqrt((n1 * n2)/(n1 + n2))
  capture.output(
    fit <- compute.es::tes(t = t, n.1 = n1, n.2 = n2, level = 100 * ci),
    file = "NUL"
  )
  c(lower.ci = fit$l.d, upper.ci = fit$u.d)
}
