cp restart_initialization.json{.BAK,}
echo '{"restarts_completed": 0, "runs_completed": 2}' > restart.dat
cp restart0/run3/west.h5 west.h5

rm pcoord.log pcoord.dat rmsd.temp wsdata.txt
