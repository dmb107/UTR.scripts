#!/usr/bin/perl

# function defintion

sub Average{
	#get total number of arguments
	$n = scalar(@_);	
	$sum = 0;

	foreach $item (@_) {
		$sum += $item;
	}
	$average = $sum / $n;

	print "average for the given numbers: $average\n";
}

# function call
&Average($ARGV[0], $ARGV[1]);
