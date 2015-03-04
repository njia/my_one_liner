#!/usr/bin/env perl

use warnings;
use strict;
use 5.010;
use File::ReadBackwards;

my $FILE_IN;
my $file;
my @files;

if (scalar @ARGV == 0) {
  say "Please input file names";
  my $input = <>;
  chomp($input) if defined $input;
  @files = split(" ", $input);
}else {
  @files = @ARGV;
}

# foreach $file (@files) {
#   my $bw = File::ReadBackwards->new($file) or die "Can't open file $file\n";
#   my $line;
#   while (defined ($line = $bw->readline)) {
#     chomp($line);
#     say "$line";
#     # say scalar reverse $line;
#   }
# }


my @lines;

foreach $file (@files) {
  open $FILE_IN, "<", $file or die "Can't open file $file\n";
  while (my $line = <$FILE_IN>) {
    unshift @lines, $line;
  }
  say "@lines";
}




