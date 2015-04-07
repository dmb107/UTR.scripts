#!/usr/bin/perl                                                  
#                                                                
# last change Time-stamp: <2010-02-25 22:05:40 alex>                                     
#                                                                
# WHAT THIS IS???  
# a small perl to create a given number of random dna or rna sequences
# with either the same length or a random length within two given
# borders; it also takes the percentages of the different nucleotides
# into account
#                                                                
# AUTHOR: alex <alex [the symbol] bioinf [dot] uni [minus] leipzig [dot] de>                                                     
                                                                 
use strict;                                                      
use warnings;                                                    
use Pod::Usage;                                                  
use Getopt::Long;                                                

## some global variables; some with default vaules
my ($h, $man, $verbose) = (0, 0, 0);
my ($seq_type, $seq_length, $set_size) = ('r', 100, 10);
my ($max, $min);
my ($a, $c, $g, $tu) = (0.25, 0.25, 0.25, 0.25);
my @random_seqs = ();


###################
## BEGIN OF MAIN ##
###################

## parse options and print usage if there is a syntax error,
## or if usage was explicitly requested.
&GetOptions('type=s' => \$seq_type, 
	    'l=i' => \$seq_length,
	    'min=i' => \$min, 
	    'max=i' => \$max, 
	    'n=i' => \$set_size,
	    'a=f' => \$a, 
	    'c=f' => \$c,
	    'g=f' => \$g, 
	    't|u=f' => \$tu,
	    'v' => \$verbose,
	    'h|help|?' => \$h, 
	    'man' => \$man) or pod2usage(2);
&pod2usage(-verbose => 0) if $h;
&pod2usage(-verbose => 3) if $man;

## check whether the requested parameters are legal
($seq_length,  $min, $max) = checkParameters($seq_type, $seq_length,  $min, $max, $set_size, $a, $c, $g, $tu);

## fill the array with the random RNA resp. DNA sequences
@random_seqs = &makeRandomXNAset($min, $max, $set_size);

## output of the created sequences
my $seq_no = 0;
foreach my $seq (@random_seqs) {

    $seq_no++;
    print STDOUT ">sequence_$seq_no\n";  #(".length($seq).")\n";
    print STDOUT "$seq\n"
}

exit;

#################
## END OF MAIN ##
#################

###################
## BEGIN OF SUBS ##
###################

## to check each parameter value, print them and print possible error
## messages
sub checkParameters {
    
    my ($seq_type, $seq_length, $min, $max, $set_size, $a, $c, $g, $tu) = @_;
        
    ## min and max value check
    ## if min and max values are given by the user...
    if (defined($max)) {
	$max = abs($max);
	if (defined($min)) {
	    $min = abs($min);
	} else { # min undefined
	    $min = ($seq_length >= $max) ? $max : $seq_length;
	}

    } else { # if max is undefined
	if (defined($min)) {
	    $min = abs($min);
	    $max = ($seq_length >= $min) ? $seq_length : $min;
	} else {
	    $min = abs($seq_length);
	    $max = $min;
	}
    }

    if($max < $min) {

	my $temp = $max;
	$max = $min;
	$min = $temp;
    }
     
    ## for control reasons
    if ($verbose == 1) {
	print STDERR "=====================\n";
	print STDERR "type:\t".uc($seq_type)."\n";
	print STDERR "min length:\t".$min."\n";
	print STDERR "max length:\t".$max."\n";
	print STDERR "# of seq.:\t".$set_size."\n";
	if (lc($seq_type) eq 'r' || lc($seq_type) eq 'd') {
	    print STDERR "% of A:\t".$a."\n";
	    print STDERR "% of C:\t".$c."\n";
	    print STDERR "% of G:\t".$g."\n";
	    print STDERR "% of T|U:\t".$tu."\n";
	}
	print STDERR "=====================\n";
    }
    
    ## check whether the percentages of the nucleotides can be
    ## summarized up to 1 if not: exit with error message
    if ($a+$c+$g+$tu != 1) {

	print STDERR "error: a+c+g+t=".($a+$c+$g+$tu)."\n";
	exit;
    }

    return ($seq_length, $min, $max);
}

## creates the sequence set of the requested size
sub makeRandomXNAset {
	
    my ($min, $max, $set_size) = @_;
    my ($length, $xna);
    my @set;

    for(my $i = 0; $i < $set_size; $i++) {
	
	if($min != $max) {

	    $length = &randomLength($min, $max);

	} else {

	    $length = $min;
	}

	$xna = &makeRandomXNA($length);
	push(@set, $xna);
    }
    
    return @set;
}

## chooses a length within the given min and max values
sub randomLength {
	
	my($min, $max) = @_;
	return (int(rand($max - $min + 1)) + $min);
}

## create a complete sequence with random nucleotides
sub makeRandomXNA {
	
    my ($length) = @_;
    my $xna;

    for (my $i = 0; $i < $length; $i++) {

	if(lc($seq_type) eq 'r' || lc($seq_type) eq 'd') {
	    
	    $xna .= &randomNucleotide();
	    
	} else {
	
	    $xna .= &randomAminoAcid();
	}
    }

    return $xna;
}

## chooses a random nucleotide
sub randomNucleotide {

    my $rand_nuc_prob = rand;
 
    if ($rand_nuc_prob < $a) {
	return "A";
    } elsif ($rand_nuc_prob >= $a && $rand_nuc_prob < ($a+$c)) {
	return "C";
    } elsif ($rand_nuc_prob >= ($a+$c) && $rand_nuc_prob < ($a+$c+$g)) {
	return "G";
    } elsif ($rand_nuc_prob >= ($a+$c+$g) && $rand_nuc_prob < 1) {
	return (lc($seq_type) eq 'r') ? "U" : "T";
    } else {
	print STDERR "error while creating nucleotide!\n";
	print STDERR "see 'sub randomNucleotide'\n";
    }
}

## fills an array with all aminoacids and 
## returns a random acid
sub randomAminoAcid {
## A-Alanin, C-Cystein, D-Asparagins‰ure, E-Glutamins‰ure, F-Phenylalanin, 
## G-Glycin, H-Histidin, I-Iso-Leucin, K-Lysin, L-Leucin, M-Methionin, 
## N-Asparagin, P-Prolin, Q-Glutamin, R-Arginin, S-Serin, T-Threonin, V-Valin, 
## W-Tryptophan, Y-Tyrosin

    my(@amino_acids) = ('A','C','D','E','F','G','H','I','K','L','M','N','P','Q','R','S','T','V','W','Y');
    return randomElement(@amino_acids);
}

## chooses an element randomly out of a given array
sub randomElement {

#	my(@array) = @_;
	return $_[rand @_];
}

__END__



=head1 NAME

C<randr> - Creating user-specific sequences of either RNA, DNA or protein.

=head1 SYNOPSIS

C<randr [options]>

B<Options:>

    -type [d|r|p] : type of sequence

    -n [int] :      size of the set

    -l [int] :      length of the sequences

    -min [int] :    minimum sequence length

    -max [int] :    maximum sequence length

    -a [float] :    percentage of adenine nucleotides

    -c [float] :    percentage of cytosine nucleotides

    -g [float] :    percentage of guanine nucleotides

    -t [float] :    percentage of thymine nucleotides

    -u [float] :    percentage of uracil nucleotides

    -v :            informations about the sequence set

    -help|h|? :     print (this) brief help message

    -man :          full documentation

=head1 OPTIONS AND ARGUMENTS

=over 8

=item B<-type> [I<d|r|p>]	

The type of sequence to create (DNA, RNA, or protein). The protein
sequences will be composed using the single letter code for amino
acids. Default: RNA

=item B<-n> [integer]

The size of the set to create. Default: 10

=item B<-l> [integer]	

The length of the sequences to create. Default: 100

=item B<-min> [integer]	

The minimum length of the sequences to create. If set, sequences are
created with random lengths between MIN and the default sequence
length (100) or MAX, whatever is lower. If MIN > MAX or MIN > default
length, than all sequences in the set have the length of MIN.

=item B<-max> [integer]	

The maximum length of the sequences to create. If set, sequences are
created with random lengths between the default sequence length (100)
or MIN, whatever is higher, and MAX. If MAX < MIN, than the values are
swapped. If MAX > default length, than all sequences in the set have
the length of MAX.

=item B<-a> [float]

The percentage of adenine nucleotides in the sequence to create.
Default: 0.25

=item B<-c> [float]	

The percentage of cytosine nucleotides in the sequence to create.
Default: 0.25

=item B<-g> [float]	

The percentage of guanine nucleotides in the sequence to create.
Default: 0.25

=item B<-t>|B<u> [float]

The percentage of thymine|uracil nucleotides in the sequence to
create. Default: 0.25

=item B<-v>

Detailed informations about the created sequence set.

=item B<-help>|B<h>|B<?>

Prints a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<randr> will create a set of random sequences of either RNA, DNA,
or protein. The user can specify the number of sequences in the set,
the length of the sequences (or a minimum and maximum length), and, in
case of DNA or RNA, the percentage of the four different nucleotides
within the sequence. Remember that the sum of all percentages needs to
be exact 1.

=head1 EXAMPLES

=over 8

=item B<randr -type d -l 200>

Ten DNA sequences with the length 200.

=item B<randr -n 100 -min 150 -max 500>

A set of 100 RNA sequences. Each sequence has a random length between
150 and 500.

=item B<randr -type p -max 200>

Creates a set of 10 protein sequences. Each sequence has a random
length between (the default value) 100 and 200.

=back

=head1 SEE ALSO

There is nothing known you can consider so far. But for good laught
visit L<http://bash.org/?latest>.

=head1 DISCLAIMER

The author is not responsible for any loss of data, wrong research
results or anything else which may be caused by using this tool.

=head1 BUGS

This script does not, as far as known, obey Sturgeons law, which says:

B<C<90% of everything is crud.>>

But a known issue is the accuracy of the requested nucleotide
percentages. This is caused by the function which randomizes the
nucleotide sequences. In general, the accuracy is improved when large
sequence sets (>500 sequences) with long sequences (>200 nt) are
created. And the more accurate you specify the percentages the more
accurate will they be. This problem remains to be solved.

Another issue is the large amount of time needed to create very large
sequence sets (>10.000 sequences) with long sequences (>5.000 nt). On
my IBM Thinkpad with a 1.5GHz Intel Celeron (R) M and 1GB DDR2 RAM it
takes some 2 minutes and 50 seconds of user time to create such a
set. A future aim is to improve this via re-writing parts of the code.

=head1 UPDATES

Please visit L<http://www.bioinf.uni-leipzig.de/~alex> for possible
updates of this perl script.

=head1 AUTHOR

Alex Donath.

In case you've found any bugs, please report them to <alex [the
symbol] bioinf [dot] uni-leipzig [dot] de>.

=head1 VERSION

v0.5b (Bled/Slovenia, February 2010)

=cut

