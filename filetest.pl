#!/usr/bin/env perl
#
use warnings;
use strict;
use 5.010;

my @filelist;

sub checkfilemode() {
  my $result="";
  $result .= " readable" if (-r $_[0]);
  $result .= " writable" if (-w $_[0]);
  $result .= " executable" if (-x $_[0]);
  $result .= " owned by $ENV{USER}" if (-o $_[0]);
  printf "File %40s and it is $result\n", $_[0];
}

sub notmodified() {
  my $oldest = $_[0];
  my $current = -C $_[0];
  foreach my $file (@_) {
  if (-C $file > $current) {
    $oldest = $file;
    $current = -C $file;
  }
}
  say "Oldest file is $oldest and modified $current days ago";
}


die "Please enter file names, seperated by space\n" if ( scalar @ARGV == 0);
chomp @ARGV;
@filelist = @ARGV;

foreach my $file (@filelist) {
  &checkfilemode($file);
}

&notmodified(@filelist)

