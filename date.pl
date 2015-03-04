#!/usr/bin/env perl

use warnings;
use strict;
use 5.018;

my $FirstMonday = int(rand(7)) + 1;
print "First Monday of this month is $FirstMonday\n";

print "Please input a date: \n";

my $input ;
$input = <>;
die "empty line detected\n" if ! defined $input;
chomp $input ;

die "Empty line detected\n" if ($input eq "\n");
die "Pleae input a single or two digit number,digits more than 2 will be ignored\n"
                      unless ( $input =~ /\d+/);

($input >=1 and $input <=31) or die "Date needs to be between 1 to 31\n";
if ($input >=28 and $input <=31) {
  print "Warning: this day may not be in the current month\n";
}

  my $date = $input - $FirstMonday;
# CHECKDATE: {
#   if ($date%7 == 0) {print "$input is Monday\n";    last CHECKDATE;}
#   if ($date%7 == 1) {print "$input is Tuesday\n";   last CHECKDATE;}
#   if ($date%7 == 2) {print "$input is Wednesday\n"; last CHECKDATE;}
#   if ($date%7 == 3) {print "$input is Thursday\n";  last CHECKDATE;}
#   if ($date%7 == 4) {print "$input is Friday\n";    last CHECKDATE;}
#   if ($date%7 == 5) {print "$input is Saturday\n";  last CHECKDATE;}
#   print "$input is Sunday\n";
# }
given ($date%7) {
  when (0) {print "$input is Monday\n"; break;}
  when (1) {print "$input is Tuesday\n"; break;}
  when (2) {print "$input is Wednesday\n"; break;}
  when (3) {print "$input is Thrusday\n"; break;}
  when (4) {print "$input is Friday\n"; break;}
  when (5) {print "$input is Saturday\n"; break;}
  default {print "$input is Sunday\n"; break;}
}
