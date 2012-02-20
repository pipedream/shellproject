#!/bin/bash

# by Jan Groenewald, jan@aims.ac.za
# script to sanitize data/.../file.ext into cleaned_data.d/._./file.txt

##############################################################################################
# This script assumes all data files contain two digits in a row, and non-data files don't ! #
##############################################################################################

# check data directory is specified as input
if [ -z $1 ] ; then
	echo "No data directory specified";
	exit;
fi

# print files not transferred as it doesn't contain two digits in a row
CLEANTMP=`echo $1 | sed -e 's,/*$,,'`
echo "Not sanitizing these files (only sanitizing files with two digits in the name):"
find ${CLEANTMP} -type f -a ! -name '*[0-9][0-9]*' -print
echo 

# transfer files to cleanned_data/dir1_dir2_filename{%strip}.txt
# strip trailing slashes
CLEANDIR="cleaned_${CLEANTMP}.d"
mkdir -p ${CLEANDIR}
NUMFILES=`find ${CLEANTMP} -type f -a -name '*[0-9][0-9]*' -print | wc -l`
echo "Moving ${NUMFILES} data files into ${CLEANDIR}..."
# rename: e.g. data/dir1/dir2/file.dat -> data_dir1_dir2_file.txt 
find $CLEANTMP -type f -a -name '*[0-9][0-9]*' -exec bash -c \
	"cp -f {} ${CLEANDIR}/\`echo {} | sed -e 's,/,_,g;s/.txt//'\`.txt" \;
