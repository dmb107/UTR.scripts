#!bin/perl -w
use strict;
use warnings;
use Bio::SeqIO;


#script to translate nucleotide sequences to amino acid sequences in first three frames

my $in = Bio::SeqIO->new(-file => "./UTRdb/utr_20150124_000902.fasta", -format => "fasta");
my $out = Bio::SeqIO->new(-file => ">3UTRTranslateFrame1.fasta", -format => "fasta");
my $out2 = Bio::SeqIO->new(-file => ">3UTRTranslateFrame2.fasta", -format => "fasta");
my $out3 = Bio::SeqIO->new(-file => ">3UTRTranslateFrame3.fasta", -format => "fasta");

while ( my $seq = $in->next_seq() ) {
	my $prot = $seq->translate();
	$out->write_seq($prot);
	my $prot2 = $seq->translate(-frame => 1);
	$out2->write_seq($prot2);
	}
