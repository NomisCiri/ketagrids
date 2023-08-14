# this script pre-generates the env order for each subject
# and saves it as a json. By these means we make sure that the first and second session
# do not use the same environments.
pacman::p_load(dplyr,jsonlite)
setwd("/Volumes/CirankaSimon/Projects/Ketagrids/ketaGrids_stripped/")
#specs
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
    envOrder=all_sessions[1:n_trials],
    sub=i
  )
  
  # make order for session two
  session_2[[i]]<-tibble(
    envOrder=all_sessions[(n_trials+1):(n_trials*2)],
    sub=i
  )
}

# make jsons
session_1_json=session_1%>%toJSON(dataframe = 'columns')
session_2_json=session_2%>%toJSON(dataframe = 'columns')

cat("env_shuffled_1 = ",session_1_json,
    sep = ' ',
    file = "environment1_idx_shuffled.json"
)

cat("env_shuffled_2 = ",session_2_json,
    sep = ' ',
    file = "environment2_idx_shuffled.json"
)