# $Id$

use strict;
use Test::More qw(no_plan);

use Business::DK::Phonenumber;

my $phonenumber = '12345678';

is(Business::DK::Phonenumber::render($phonenumber, '%4d %4d'), '1234 5678');

is(Business::DK::Phonenumber->render($phonenumber, '%4d %4d'), '1234 5678');

is(Business::DK::Phonenumber::render($phonenumber, '%2d %2d %2d %2d'), '12 34 56 78');

is(Business::DK::Phonenumber->render($phonenumber, '%2d %2d %2d %2d'), '12 34 56 78');
