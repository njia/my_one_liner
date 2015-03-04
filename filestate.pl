#!/usr/bin/env perl

use warnings;
use strict;

my @files = <*.pl>;

foreach (@files) {
  my @statinfo = stat $_;
    while (<@statinfo>) {
      print $_, "\n";
    }
  }
