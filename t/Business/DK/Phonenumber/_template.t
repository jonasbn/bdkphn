# $Id$

use strict;
use Test::More qw(no_plan);

use_ok('Business::DK::Phonenumber');

ok(my $phonenumber = Business::DK::Phonenumber->new({ phonenumber => '12345678' }));

ok(! $phonenumber->_template('xxx'));

ok(! $phonenumber->_template('8d'));

ok(! $phonenumber->_template('d8'));

ok(! $phonenumber->_template('d8%'));

ok(! $phonenumber->_template('d%8'));

ok(! $phonenumber->_template('%2d %2d %2d %1d'));

ok(! $phonenumber->_template('%4d %3d'));

ok($phonenumber->_template('%8d'));

ok($phonenumber->_template('%2d %2d %2d %2d'));

ok($phonenumber->_template('%4d %4d'));