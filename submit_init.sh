#!/bin/bash
#SBATCH --job-name=ntl9-1ns-init
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

./init.sh 

