#!/usr/bin/env perl
#
use warnings;
use strict;


# my @list = (2.5, 9, 0.76, 11);
my @list = (1);

my $max = $list[0];
my $min = $list[0];

$#list >= 2 or die print "Number in list less than 2\n";

foreach my $number (@list) {
  $max = $max > $number ? $max : $number;
  $min = $min > $number ? $number : $min;
}

print "Max number in list : $max\n";
print "Min number in list : $min\n";
