# $Id$

use strict;
use Test::More qw(no_plan);

use_ok('Business::DK::Phonenumber');

ok(my $phonenumber = Business::DK::Phonenumber->new({ phonenumber => '12345678' }));

is($phonenumber->template(), '+45 %8d');

ok($phonenumber->template('%8d'));

is($phonenumber->template(), '%8d');

ok(! $phonenumber->template('d8'));

