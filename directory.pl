#!/usr/bin/env perl

use warnings;
use strict;
use 5.010;

say "Please enter a directory you want to go to (entry for your home) $ENV{HOME}";

my $dir = <>;
die "End of file detected\n" if (! defined $dir);
chomp $dir;
if ($dir eq "") {
  $dir = $ENV{HOME};
}

opendir my $dir_fh, $dir or die "Can't read $dir\n";
my @filelist = readdir $dir_fh;
closedir $dir_fh;

if (scalar @filelist == 2 ) {
  say "Directory $dir is empty";
  exit;
}

my @nodotlist = grep { $_ =~ /\A[^.]/} @filelist;
my @sorted_filelist = sort {$b cmp $a} @nodotlist;

foreach my $file (@sorted_filelist) {
say "$file";
}




