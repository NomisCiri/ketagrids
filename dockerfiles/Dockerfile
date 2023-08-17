FROM rocker/r-ver:4.1.2
ARG BUILD_DATE=2023-08-17
WORKDIR /home/rstudio
RUN install2.r --error --skipinstalled \ 
  furrr \ 
  future \
  future.batchtools \ 
  future.apply \
  remotes \
  sessioninfo \
  DEOptim \
  brms
  
