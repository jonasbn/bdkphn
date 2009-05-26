# $Id$

use strict;
use Test::More qw(no_plan);

use_ok('Business::DK::Phonenumber');

ok(my @phonenumbers = Business::DK::Phonenumber->generate());

foreach my $phonenumber (@phonenumbers) {
    like($phonenumber, qr/^\+45 \d{8}$/);
}
