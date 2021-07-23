#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
    set -x
    env | sort
fi

cd $WEST_SIM_ROOT
echo 'I am here'
#cp ntl9.rst7 parent.rst7

WORK_DIR=`mktemp -d`

echo "west data ref: $WEST_STRUCT_DATA_REF" > $WORK_DIR/wsdata.txt
cp $WEST_STRUCT_DATA_REF $WORK_DIR/parent.rst7
function cleanup() {
    cd $WEST_SIM_ROOT
    rm -f $WORK_DIR/parent.rst7
   #rm -f phi.dat psi.dat
}

trap cleanup EXIT

# Get progress coordinate
cd $WORK_DIR
mkdir ref_files
cp $WEST_SIM_ROOT/ref_files/reference.pdb ref_files/reference.pdb

cpptraj $WEST_SIM_ROOT/ref_files/ntl9.prmtop < $WEST_SIM_ROOT/ref_files/ptraj_init.in || exit 1
gawk '{print $2}' rmsd.temp | tail -1 > pcoord.dat || exit 1
cat pcoord.dat > $WEST_PCOORD_RETURN
#rm -f rmsd.temp

#paste phi.dat psi.dat | sed -e 's/      1.00 //g' -e 's/      2.00 //g' > $WEST_PCOORD_RETURN || exit 1

if [ -n "$SEG_DEBUG" ] ; then
    head -v $WEST_PCOORD_RETURN
fi


