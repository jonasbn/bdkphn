# Build.PL for Business-DK-Phonenumber

# $Id: Build.PL,v 1.2 2006/02/20 21:50:41 jonasbn Exp $

use Module::Build;
my $build = Module::Build->new(
    dist_author       => 'Jonas B. Nielsen, (jonasbn) <jonasbn@cpan.org>',
    module_name       => 'Business::DK::Phonenumber',
    dist_version_from => 'lib/Business/DK/Phonenumber.pm',
    dist_abstract => 'Module to validate and format Danish telephonenumbers',
    license       => 'artistic',
    create_makefile_pl   => 'passthrough',
    create_readme        => 1,
    recursive_test_files => 1,
    build_requires       => {
        'Test::More'     => '0',    #core
        'Test::Taint'    => '0',
        'Taint::Runtime' => '0',
        'Data::FormValidator' => '0',
    },
    requires => {
        'Exporter' => '0',          #core
        'Carp'     => '0',          #core
    },
);
$build->create_build_script();
