#!/usr/bin/env perl

use warnings;
use strict;
use bigint;

sub jiecheng {
  my $number = shift;
  return 1 if $number < 2;
  $number * jiecheng($number -1);
}

sub quick_sort {
  my @a = @_;
  return @a if @a < 2;
  my $p = pop @a;
  quick_sort(grep $_ < $p, @a), $p, quick_sort(grep $_ >= $p, @a);
}

sub merge_sort {
  my @x = @_;
  return @x if @x < 2;
  my $m = int @x / 2;
  my @a = merge_sort(@x[0 .. $m - 1]);
  my @b = merge_sort(@x[$m .. $#x]);
  for (@x) {
    $_ = !@a            ? shift @b
       : !@b            ? shift @a
       : $a[0] <= $b[0] ? shift @a
       :                  shift @b;
  }
  @x;
}

my @a = (4, 65, 2, -31, 0, 99, 83, 782, 1);
@a = merge_sort @a;
print "@a\n";

# my $list_numbers = <>;
# my @unsorted_numbers = split " ", $list_numbers;
# my @a = quick_sort @unsorted_numbers;
# print "@a\n";
#
# my $i = <>;
# my bigint $result = jiecheng($i);
# print $result;
