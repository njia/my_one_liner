#!/usr/bin/env perl
#
use warnings;
use strict;
use feature 'say';

my $PASSFILE = "/etc/passwd";
my $pwfile;

open ($pwfile, "<", $PASSFILE) or die "Can't read $PASSFILE \n";

while (<$pwfile>) {
  # chomp;

  my @fields = split ":", $_;
  my $loop = $#fields;

    print "Account  : ".$fields[0]."\t" if $fields[0];
    print "Password : ".$fields[1]."\t" if $fields[1];
    print "User ID  : ".$fields[2]."\t" if $fields[2];
    print "Group ID : ".$fields[3]."\t" if $fields[3];
    print "User name: ".$fields[4]."\t" if $fields[4];
    print "Home     : ".$fields[5]."\t" if $fields[5];
    print "Shell    : ".$fields[6]."\n" if $fields[6];
}


while (<>) {
  chomp;
  print join("\t", (split /:/)[0, 2, 1, 5] ), "\n"; 
}


