#!/usr/bin/perl

#######################################################

#  Author: Hamid Ashrafi                              #
# email: ashrafi@ucdavis.edu
# Pupose: It reads the fasta file and another file with
# the IDs that you want to extract from the FASTA file
# then print the IDs and seqencing that are matched in
# the FASTA file.
#
#Requirement. Bio Perl
######################################################



use strict;
use warnings;
use diagnostics;
use Bio::DB::Fasta;

my $database;
my $fasta_library;
my %records;
open IDFILE, "sequences_too_short.fas" or die $!;
open OUTPUT, ">out.faa" or die $!;
#  name of the library file - (here it is hardcoded)
$fasta_library = '3UTRHuman.fasta';

# creates the database of the library, based on the file
$database = Bio::DB::Fasta->new("$fasta_library") or die "Failed to creat Fasta DP object on fasta library\n";


# now, it parses the file with the fasta headers you want to get
while (<IDFILE>) {



      my ($id) = (/^>*(\S+)/);  # capture the id string (without the initial ">")
      my $header = $database->header($id);
      #print "$header\n";
      print ">$header\n", $database->seq( $id ), "\n";
      print OUTPUT  ">$header\n", $database->seq( $id ), "\n";
}

exit;
