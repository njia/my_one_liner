#!/usr/bin/env perl

# use warnings;
# use strict;

# my @list_char = split(//, "ABC");
# my @final_result;

# sub str_per {
#   my @result;
#   my $char  ;

#   return @_ if scalar @_ == 1;

#   foreach $char (@_) {
#     my @new = grep ($_ ne $char, @_);
#     # print @new;
#     @result = &str_per(@new);
#     # print "Result is ", @result, "\n";
#   }

#   foreach my $item (@result) {
#     # print "Item is : $item\n";
#     push @final_result, $item;
#     # push @final_result, ($char.$item);
#   }
#   # return @result;
# }

# &str_per(@list_char);
# print @final_result;

use Algorithm::Permute;

my @array = 'a'..'d';

Algorithm::Permute::permute {
  print "next permutation: (@array)\n";
} @array;

