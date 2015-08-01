#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $number;

$number = 12345678;
printf("1: %8d\n",$number);

$number = 12345678;
printf("2: %8d\n",$number);

$number = 12345678;
printf("3: +45%8d\n",$number);

$number = 12345678;
printf("4: +45 %8d\n",$number);

my @numbers = '12345678' =~ m/\d{2}/g;

print STDERR Dumper \@numbers;

$number = 12345678;
printf("4: +45 %2d %2d %2d %2d\n", @numbers);
