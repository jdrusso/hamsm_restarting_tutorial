#!/bin/bash
#SBATCH --job-name=ntl9-lf-rep1
#SBATCH --output=we.errout
#SBATCH --partition=gpu
#SBATCH --gres=gpu:3
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

conda activate py38WEenv

rm -rf traj_segs seg_logs
mkdir traj_segs  seg_logs

rm restart.dat doing_extension

BSTATE_ARGS="--bstate start,1,istates/ntl9.rst7"
TSTATE_ARGS="--tstate folded,0.99"
w_init $BSTATE_ARGS $TSTATE_ARGS --segs-per-state 4 | tee init.log



SERVER_INFO=west_zmq_info-$SLURM_JOBID.json

w_run --zmq-startup-timeout 3600 --zmq-shutdown-timeout 360 --zmq-timeout-factor 240 --zmq-master-heartbeat 3 --zmq-worker-heartbeat 120 --work-manager=zmq --n-workers=0 --zmq-mode=master --zmq-write-host-info=$SERVER_INFO --zmq-comm-mode=ipc &> west-$SLURM_JOBID.out &

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
        --zmq-startup-timeout 3600 \
        --zmq-shutdown-timeout 360 \
        --zmq-timeout-factor 240
