#!/usr/bin/env perl
#

use warnings;
use strict;

print "Please enter a string\n";

$_ = <>;

die "empty string detected\n" if ! defined $_;
chomp;

  my @char = $_ =~ /./g;
  printf "%s\n", join ",", @char;

