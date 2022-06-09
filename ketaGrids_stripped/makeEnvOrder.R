# this script pre-generates the env order for each subject
# and saves it as a json. By these means we make sure that the first and second session
# do not use the same environments.
library(jsonlite)
n_envs=40
n_subs=100
env_idx=c(0:(n_envs-1))
n_trials=10
#mind javascript indexing at 0.
session_1=list()
session_2=list()
for (i in 1:n_subs){
  # randomly sample environment indices
  all_sessions=sample(env_idx,n_trials*2)
  
  # make order for session 1.
  session_1[[i]]<-tibble(
    all_sessions[1:n_trials],
    sub=i
  )
  
  # make order for session two
  session_2[[i]]<-tibble(
    all_sessions[(n_trials+1):n_trials*2],
    sub=i
  )
}

