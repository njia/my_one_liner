#!/usr/bin/env perl

use warnings;
use strict;

my @c = (1,3,5,6,7,8);
my @d = (2,3,5,7,9);
my %union;
my %isect;

foreach my $e (@c, @d) {print $e, "\n"; $union{$e}++ && $isect{$e}++}

print "union keys are", keys %union;
print "\n";
print "intersection keys are: ", keys %isect;
