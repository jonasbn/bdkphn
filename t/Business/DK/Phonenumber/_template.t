# $Id$

use strict;
use Test::More qw(no_plan);

use_ok('Class::Business::DK::Phonenumber');

ok(my $phonenumber = Class::Business::DK::Phonenumber->new({ phonenumber => '12345678' }));

ok(! $phonenumber->_validate_template('xxx'));

ok(! $phonenumber->_validate_template('8d'));

ok(! $phonenumber->_validate_template('d8'));

ok(! $phonenumber->_validate_template('d8%'));

ok(! $phonenumber->_validate_template('d%8'));

ok(! $phonenumber->_validate_template('%2d %2d %2d %1d'));

ok(! $phonenumber->_validate_template('%4d %3d'));

ok($phonenumber->_validate_template('%8d'));

ok($phonenumber->_validate_template('%2d %2d %2d %2d'));

ok($phonenumber->_validate_template('%4d %4d'));