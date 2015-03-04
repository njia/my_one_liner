#!/usr/bin/env perl

use warnings;
use strict;
use 5.010;

my $home = "/home/a/aaron/";
print "Home directory\n" if $home =~ m#/home/a/aaron/#;

my $lamb = 100;
my $llama = 200;

$_ = "Larry has a little Camel, little cAMel, little caMEL";
s{camel}{ $lamb > $llama ? "lamb" : "llama" }gie;

print;
print "\n";

$_ = "Larry has a little Camel, little cAMel, little caMEL";
tr/camel/C/;
print;
print "\n";

$_ = "Larry has a little little little camel";
print "--$`--$&--$'--\n" if / (little ){1,3}?/;
print "--$`--$&--$'--\n" if / (little ){2}?/;

$_ = "Larry !@ # \$ \% has a little little little camel";
for ($_) {
  print $&, "\n" if /[^\w\s]+/;
# (print $&, "\n") if /\W*/;
}

$_ = "Larry has a little little little camel";
print qq/Found repeating word "$1"\n/ if /(\w+) \1/;

$_ = "Hello there, neighbor";
if (/\s([a-zA-Z]+),/) { # capture the word between space and comma
  print "the word was $1\n"; # the word was there 
}


my $original = 'Fred ate 1 rib'; 
my $copy = $original;
$copy =~ s/\d+ ribs?/10 ribs/;
say "$copy";

if ($copy = m/ate/) {
say "$copy";
}

my @bindirs = qw( /usr/bin /bin /usr/local/bin );
my @libdirs;
for (@libdirs = @bindirs) { s/bin/lib/ };
print "@libdirs\n";

$_ = "Hello there, neighbor!";
my($first, $second, $third) = /(\S+) (\S+) (\S+)/;
print "$second is my $third\n";

$_="fred and barney went bowling last night";
print /fred.+barney/,"$_\n";
print /fred.+?barney/, "$_\n";

