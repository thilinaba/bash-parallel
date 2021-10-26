#!/bin/bash

# This is the concurrency limit
MAX_POOL_SIZE=5

# Jobs will be loaded from this file
JOB_LIST=job-list.txt

# Output file
OUTPUT=output.txt

# This is used within the program. Do not change.
CURRENT_POOL_SIZE=0


# This is a just a function to print the output as a log with timestamp
_log() {
        echo " $(date +'[%F %T]') - $1"
}

# This is the custom function to process each job read from the file
process_job() {
  # customize your job function as required
  # in our example, we just "ping" each hostname read from the file
  ping $1 -c $2 -q | tee -a $OUTPUT
}



# ------ This is the main program code --------

# Starting the timer
T1=$(date +%s)

# Reading the $JOB_LIST file, line by line
while IFS= read -r line; do
  
  # This is the blocking loop where it makes the program to wait if the job pool is full
  while [ $CURRENT_POOL_SIZE -ge $MAX_POOL_SIZE ]; do
    _log "Pool is full. waiting for jobs to exit..."
    sleep 1
    
    # The above "echo" and "sleep" is for demo purposes only.
    # In a real usecase, remove those two and keep only the following line
    # It will drastically increase the performance of the script
    CURRENT_POOL_SIZE=$(jobs | wc -l)
  done
  
  
  # This is a custom function to process each job read from the file
  # It calls the custom function with each line read by the $JOB_LIST and send it to background for processing
  _log "Starting job $line"  
  process_job $line &
  
  # When a new job is created, the program updates the $CURRENT_POOL_SIZE variable before next iteration
  CURRENT_POOL_SIZE=$(jobs | wc -l)
  _log "Current pool size = $CURRENT_POOL_SIZE"
  
  
done < $JOB_LIST # this is where we feed the $JOB_LIST file for the read operation

# wait for all background jobs (forks) to exit before exitting the parent process
wait

# Ending the timer
T2=$(date +%s)

_log "All jobs completed in $((T2-T1)) seconds. Parent process exiting."
_log "Final output is written in $OUTPUT"
exit 0
