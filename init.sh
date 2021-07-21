#!/bin/bash
#source env.sh



#SFX=.d$$
#mv traj_segs{,$SFX}
#mv seg_logs{,$SFX}
#rm -Rf traj_segs$SFX seg_logs$SFX & disown %1
#rm -f system.h5 west.h5 seg_logs.tar
rm -rf seg_logs traj_segs
rm -f west.h5
mkdir seg_logs traj_segs 

BSTATE_ARGS="--bstate start,1,istates/ntl9.rst7"
#BSTATE_ARGS="--bstate-file bstates.txt"
#BSTATE_ARGS="--bstates-from ref_files/initialstates.dat"
TSTATE_ARGS="--tstate folded,0.99"
w_init $BSTATE_ARGS $TSTATE_ARGS --segs-per-state 4 "$@" | tee init.log
