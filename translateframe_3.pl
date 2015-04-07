
#!bin/perl -w
use strict;
use warnings;
use diagnostics;
use Bio::SeqIO;

my $in = Bio::SeqIO->new(-file => "./UTRdb/temp4", -format => "fasta");
my $out3 = Bio::SeqIO->new(-file => ">3UTRTranslateFrame3.fasta", -format => "fasta");

while ( my $seq = $in->next_seq() ) {
	my $prot2 = $seq->translate(-frame =>2);
	$out3->write_seq($prot2);
}


