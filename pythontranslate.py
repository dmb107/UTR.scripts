#!/bin/python

#translate dna to protein frame +2

from Bio import SeqIO
input = open("/Users/danabis/Documents/Miami/Zuchner/UTR/UTRdb/genes.not.in.analysis.dna.fasta", "rU")

for record in SeqIO.parse(input, "fasta") :
        protein_id = record.id
        print(">" + protein_id)
        print(record.seq.translate(to_stop=True))

input.close()
