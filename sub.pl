#!/usr/bin/env perl

use warnings;
use strict;
sub maxnumber(@) {
  if (scalar @_ == 0) {
    print "empty list.\n";
    exit;
  }
  my @sorted = sort { $a <=> $b} @_;
  ${sorted}[-1];
}

sub totalvalue(@) {
  if (scalar @_ == 0) {
    print "Empty list.\n";
    exit;
  }
  my $total = eval (join ("+", @_));
}

print "Please input numbers you want to sort, one on each line\n";

my @numbers;
my $num;
my @sorted;

while (my $num = <> ) {
  if (defined $num) {
    chomp $num;
    push @numbers, $num;
  }
}

@sorted = sort { $a <=> $b } @numbers;
print "sorted numbers are: @sorted", "\n";
my $max = &maxnumber(@numbers);
my $total = &totalvalue(@numbers);
print "Biggest number is:",  $max, "\n";
print "the total value is: ", $total, "\n";
# print "Smallest number is:", ${sorted}[0], "\n";

print "Please enter numbers you want to sort, all in one line\n";

chomp(my $input = <>);
my @list = split (" ", $input);
@sorted = sort {$a <=> $b} @list;
$num = @sorted;

print "You entered ", scalar @sorted, " numbers\n";
print "Here is a sorted list @sorted\n";

$max = &maxnumber(@numbers);
$total = &totalvalue(@numbers);
print "Biggest number is:",  $max, "\n";
print "the total value is: ", $total, "\n";
