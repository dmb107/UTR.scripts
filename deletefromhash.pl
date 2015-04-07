#!/usr/bin/perl


####used to delete IDs in one file from another

open(FH,"<frame3genes.stringent.under50.txt");

#create hash of IDs that will check against
while(chomp($line = <FH>)){
	@list = split(/\s+/,$line);
	$hash{"$list[0]"}="huzah";			#key is the ID and value is huzah
}
close(FH);

#check if IDs in the second file are in the first hash
open(FH,"<../../nonstop/tempframe3");
open(OUT,">frame3.stringent.under50.removenonstop.txt");
while(chomp($line=<FH>)){
	@list=split(/\s+/,$line);
for ($i = 0; $i < @list; $i++) {
    if(exists($hash{$list[$i]})) {		
     delete($hash{$list[$i]})
    }
}
}

while(($key,$value)=each(%hash)){
	print OUT "$key is in frame 3 with stringent scores, under 50, and removed nonstop\n";
}

close(FH);

