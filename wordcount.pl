#!/usr/bin/env perl
#
use warnings;
use strict;
use 5.010;

my $input;
my @files;

sub countWordsinFile {
  my %wordslist;
  open my $IN_FILE, "<", $_[0]or die "Can't open file $_[0]\n";
  while (<$IN_FILE>) {
    chomp ;
    foreach my $word (split) {
      $word =~ s/[\W]//g;
      $wordslist{$word}++ if $word;
    }
  }
  my @keys = sort { $wordslist{$b} <=> $wordslist{$a} or "\L$a" cmp "\L$b" } keys %wordslist;
  foreach (@keys) {
  printf "%-20s ----> %8s\n", $_, $wordslist{$_};
  }
}


if (scalar @ARGV == 0 ) {
  say "Please input a file name";
  $input = <>;
  die "empty line detected\n" if (! defined $input);
  chomp $input;
  @files = split(" ", $input);
} else {
  @files = @ARGV;
}

  &countWordsinFile(@files);
