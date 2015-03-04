#!/usr/bin/env perl -w




foreach $file (@ARGV) {
  open my $FH, "<", $file;
    while (<$FH>) {
    }
  print "$file has $. line\n";
}
