# bash-parallel
This is a simple example of parallel processing in Bash with limited number of concurrent forks.
This allows us to run multiple time consuming tasks in parallel, yet avoid forkbombs by executing too many taks at once.

<br />

Refer to the [Blog Post](https://medium.com/cloud-life/parallel-processing-bash-with-limited-concurrency-e5d32c70269f) for the beginer's guide

<br /><br /><br />

### Variable definition

| Variable | Description |
|---|---|
| MAX_POOL_SIZE | Defines how many maximum number of background jobs we need to be running at a given time. |
| JOB_LIST | Holds the path to a text file which contains the tasks we need to process. |
| OUTPUT | Holds the file path to the output file, which will be written by the "process_job()" function |
| CURRENT_POOL_SIZE | Keep track how many jobs are currently running during the program runtime. This is used to decide whether to stop creating new background jobs and wait for the running jobs to finish. |
