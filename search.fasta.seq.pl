#!bin/perl -w
use Bio::SeqIO;

#use to see if sequence in fasta file contains a regex

$in = Bio::SeqIO->new(-file => "3UTRTranslateFrame3.fasta" , '-format' => 'Fasta');
$out = Bio::SeqIO->new(-file => ">frame3seqnostop.txt" , '-format' => 'Fasta');

while ( my $seqs = $in->next_seq() ) {	#reads in the sequences
	my $seq = $seqs->seq();
		if ($seq !~ m/\*/){				#if seq does not equal match to '*' 
	 		$out->write_seq($seqs);
		 }
}

