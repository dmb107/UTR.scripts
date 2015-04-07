#!/usr/bin/perl

#make hash
open(FH,"<frame1nonstop.ids.txt");	#file with two words on each line separated by white space

while(chomp($line = <FH>)){
	@list = split(/\s+/,$line);
	$hash{"$list[0]"}="huzah";
}

close(FH);

#loop through it
while(($key, $value) = each(%hash)){
	print "$key $value \n";
}