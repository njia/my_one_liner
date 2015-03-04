#!/usr/bin/env perl
#

use warnings;
use strict;

my @many = ();
sub makeone {
  my @a = ( 1 .. 10 );
  return \@a;
}
for ( 1 .. 10 ) {
  push @many, makeone();
}
print $many[1][5], "\n";

warn __FILE__," : ", __LINE__, "\n";
my $var;
my @array;
my %hash;

sub code {
}

my @refArray = \($var, @array, %hash, &code);

foreach (@refArray) {print ref $_, "\n";}

