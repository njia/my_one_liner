#!/usr/bin/env perl

use warnings;
use strict;
use diagnostics;

my $line ;
my @lines;

while (chomp ($line = <>)) {
  if (! defined $line) {
    last
  }
  push @lines, $line;
}

for $line (@lines) {
  print scalar reverse $line."\n";
}
