#!/bin/python

from random import *

sequence = "fksdjflsdhfkjsdhflsjdlfsdkfjsdncjnsncdsjflekjflksdjfkjdsncjsdibdskjfsdcnkdjscnkjdsfhkjdsclkfsdclsndcjsdnkfjsdkcnskdjfhsdkjfhsdf"

def fifty_slice(sequence):
    i = randrange(0, len(sequence) - 50)
    return sequence[i:i+50]
