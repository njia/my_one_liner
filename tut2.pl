#!/usr/bin/env perl
use warnings;
use strict;
my %hash;
$hash{"key"} = "value";
$hash{"key2"} = "value2";
$hash{"key3"} = "value3";
$hash{"key4"} = "value3";
$hash{"key5"} = "value3";
$hash{"key6"} = "value3";
$hash{"key7"} = "value3";
$hash{"key8"} = "value3";
$hash{"key9"} = "value3";
print %hash."\n";


my %data = ('John Paul' => 45, 'Lisa' => 30, 'Kumar' => 40);

my @keys = keys %data;
my $size = @keys;
print "1 - Hash size:  is $size\n";



my @values = values %data;
$size = @values;



print "2 - Hash size:  is $size\n";
print %data."\n";




$_ = "Larry has a little little little camel";


print "--$`__$&__$'--\n" if / (little ){1,3}?/;
