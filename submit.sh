#!/bin/bash
#SBATCH --job-name=ntl-bench
#SBATCH --output=we.errout
#SBATCH --partition=gpu
#SBATCH --gres=gpu:2
#SBATCH --nodes=1
#SBATCH --cpus-per-task 20
#SBATCH --time=48:00:00

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

./run.sh
