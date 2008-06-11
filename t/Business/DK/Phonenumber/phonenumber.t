# $Id$

use strict;
use Test::More qw(no_plan);

use_ok('Business::DK::Phonenumber');

ok(my $phonenumber = Business::DK::Phonenumber->new({ phonenumber => '12345678' }));

is($phonenumber->phonenumber(), '+45 12345678');