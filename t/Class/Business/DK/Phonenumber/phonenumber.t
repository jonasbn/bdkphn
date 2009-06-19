# $Id$

use strict;
use Test::More qw(no_plan);

use_ok('Class::Business::DK::Phonenumber');

ok(my $phonenumber = Class::Business::DK::Phonenumber->new({ phonenumber => '12345678' }));

is($phonenumber->phonenumber(), '+45 12345678');

ok($phonenumber->phonenumber('12345679'));

is($phonenumber->phonenumber(), '+45 12345679');

ok($phonenumber->phonenumber('12345679', '%4d %4d'));

is($phonenumber->phonenumber(), '1234 5679');

ok(my $phn = $phonenumber->phonenumber(undef, '%2d %2d %2d %2d'));

is($phn, '12 34 56 79');