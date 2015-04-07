#!/usr/bin/perl


####used to see if IDs from one file were in another file

open(FH,"<./genes/200_4/frame1stringentgenes.txt");

#create hash of IDs that will check against
while(chomp($line = <FH>)){
	@list = split(/\s+/,$line);
	$hash{"$list[0]"}="huzah";			#key is the ID and value is huzah
}
close(FH);

#check if IDs in the second file are in the first hash
open(FH,"<evs.stoplost.tac.lessthan1.txt");
open(OUT,">temp");
while(chomp($line=<FH>)){
	@list=split(/\s+/,$line);
    if(exists($hash{$list[0]})) {		
     print OUT "$list[0] has stringent scores in frame 1 and occur once in total evs\n"; 		#then print that row
	}
}

close(FH);

