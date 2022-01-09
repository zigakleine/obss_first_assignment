#!/bin/bash
#Uncomment one of the following server lines to select the server
#See the list of available mirors at:  http://physionet.mit.edu/mirrors/
SERVER=http://www.physionet.org/physiobank/database/ltstdb/
#SERVER=http://lbcsi.fri.uni-lj.si/ltstdb/ltstdb/
#SERVER=http://physionet.cps.unizar.es/physiobank/database/ltstdb/

#The Long-Term ST Database contains 86 lengthy ECG recordings
RECORDS="
s20011 s20021 s20031 s20041 s20051 s20061 s20071 s20081 s20091 s20101
s20111 s20121 s20131 s20141 s20151 s20161 s20171 s20181 s20191 s20201
s20211 s20221 s20231 s20241 s20251 s20261 s20271 s20272 s20273 s20274
s20281 s20291 s20301 s20311 s20321 s20331 s20341 s20351 s20361 s20371
s20381 s20391 s20401 s20411 s20421 s20431 s20441 s20451 s20461 s20471
s20481 s20491 s20501 s20511 s20521 s20531 s20541 s20551 s20561 s20571
s20581 s20591 s20601 s20611 s20621 s20631 s20641 s20651 s30661 s30671
s30681 s30691 s30701 s30711 s30721 s30731 s30732 s30741 s30742 s30751
s30752 s30761 s30771 s30781 s30791 s30801"

for r in $RECORDS
do
#	Use these lines for download with progress indication
#	echo "Downloading .hea file for for record $r ..."
#	wget -c --progress=dot $SERVER$r".hea" 2>&1 | grep --line-buffered "%" | sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
#	echo "Downloading .atr file for for record $r ..."
#	wget -c --progress=dot $SERVER$r".atr" 2>&1 | grep --line-buffered "%" | sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
#	echo "Downloading .dat file for for record $r ..."
#	wget -c --progress=dot $SERVER$r".dat" 2>&1 | grep --line-buffered "%" | sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
#	Use these lines for quiet dowload
	echo "Downloading .hea file for for record $r ..."
	wget -q --progress=bar:force -c $SERVER$r".hea"
	echo "Downloading .atr file for for record $r ..."	
	wget -q --progress=bar:force -c $SERVER$r".atr"
	echo "Downloading .dat file for for record $r ..."	
	wget -q --progress=bar:force -c $SERVER$r".dat"



	echo "Converting recording $r to Matlab format ..."
	wfdb2mat -r $r 1>&- 2>&-

	rm -v $r".dat"

	echo "--------------------------------------------------"

done

