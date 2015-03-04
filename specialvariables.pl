#!/usr/bin/env perl

use warnings;
use strict;

my $var = "Larry has a little camel, little camel, little camel";
$_ = $var;

print 'Global default $_ is:', $_, "\n";
print 'my $var is :', $_, "\n";

for ($var) {         # for and foreach can be used interchangeably.
  $_ =~ s/Larry/Mary/;
  $_ =~ s/has/had/;
  $_ =~ s/camel/lamb/g;
  print '$_ inside for loop(localized) is:', $_, "\n";
}

print 'After subtitution Global $_ is: ', $_, "\n";
print 'After subtitution $var is:', $var, "\n";
