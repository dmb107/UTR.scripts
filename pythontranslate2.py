#!/bin/python

#translate dna to protein

from Bio import SeqIO
input = open("/Users/danabis/Documents/Miami/Zuchner/UTR/UTRdb/utr_20150124_000902.fasta", "rU")

for record in SeqIO.parse(input, "fasta") :
        protein_id = record.id
        print(">" + protein_id)
        print(record.seq[1:].translate(to_stop=True))

input.close()
