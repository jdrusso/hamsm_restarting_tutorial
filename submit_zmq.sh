#!/bin/bash
#SBATCH --job-name=ntl9-1ns
#SBATCH --output=we.errout
#SBATCH --partition=gpu
#SBATCH --gres=gpu:3
##SBATCH --partition=exacloud
#SBATCH --nodes=1
#SBATCH --cpus-per-task 26
#SBATCH --time=7-24:00:00

module load mpi/mpich-x86_64
source /opt/installed/amber16/amber.sh


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/groups/ZuckermanLab/russojd/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/groups/ZuckermanLab/russojd/miniconda/etc/profile.d/conda.sh" ]; then
        . "/home/groups/ZuckermanLab/russojd/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/home/groups/ZuckermanLab/russojd/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

conda activate westpa_restarting

#source env.sh
#$WEST_ROOT/bin/w_run
#$WEST_ROOT/bin/w_run  "$@" &>> west.log

# w_init --tstate-file restart0/targetstates.txt --bstate-file restart0/basisstates.txt --sstate-file restart0/startstates.txt --segs-per-state 1

#./init.sh 

SERVER_INFO=west_zmq_info-$SLURM_JOBID.json

w_run --zmq-startup-timeout 360 --zmq-shutdown-timeout 360 --zmq-timeout-factor 240 --zmq-master-heartbeat 3 --zmq-worker-heartbeat 120 --work-manager=zmq --n-workers=0 --zmq-mode=master --zmq-write-host-info=$SERVER_INFO --zmq-comm-mode=ipc &> west-$SLURM_JOBID.out &

for ((n=0; n<60; n++)); do
    if [ -e $SERVER_INFO ] ; then
        echo "== server info file $SERVER_INFO =="
        cat $SERVER_INFO
        break
    fi
    sleep 1
done

# exit if host info file doesn't appear in one minute
if ! [ -e $SERVER_INFO ] ; then
    echo 'server failed to start'
    exit 1
fi

#./run.sh
w_run "$@" \
        --work-manager=zmq \
        --zmq-mode=client  \
        --n-workers=26      \
        --zmq-read-host-info=$SERVER_INFO \
        --zmq-comm-mode=ipc \
        --zmq-master-heartbeat 3 \
        --zmq-worker-heartbeat 120 \
        --zmq-startup-timeout 360 \
        --zmq-shutdown-timeout 360 \
        --zmq-timeout-factor 240
