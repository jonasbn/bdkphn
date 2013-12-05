# Build.PL for Business-DK-Phonenumber

# $Id$

use Module::Build;
my $build = Module::Build->new(
    dist_author       => 'Jonas B. Nielsen, (jonasbn) <jonasbn@cpan.org>',
    module_name       => 'Business::DK::Phonenumber',
    dist_version_from => 'lib/Business/DK/Phonenumber.pm',
    dist_abstract => 'Module to validate and format Danish telephonenumbers',
    license       => 'artistic',
    create_makefile_pl   => 'traditional',
    create_readme        => 1,
    recursive_test_files => 1,
    build_requires       => {
        'Test::More'          => '0',    #core
        'Test::Taint'         => '0',
        'Taint::Runtime'      => '0',
        'Data::FormValidator' => '0',
        'Test::Exception'     => '0',
		'Test::Kwalitee'     => '0',
		'Test::Perl::Critic'     => '0',
		'Test::Prereq::Build'     => '0',
    },
    requires => {
        'Exporter' => '0',               #core
        'Carp'     => '0',               #core
    },
    meta_merge => {
        resources => {
            homepage => 'http://logicLAB.jira.com/browse/BDKPHN',
            bugtracker =>
                'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Business-DK-Phonenumber',
            repository => 'https://github.com/jonasbn/bdkphn',
            ProjectChangelog =>
                'http://logiclab.jira.com/browse/BDKPHN#selectedTab=com.atlassian.jira.plugin.system.project%3Achangelog-panel',
            ProjectSite => 'http://logicLAB.jira.com/browse/BDKPHN',
            ProjectWiki => 'http://logiclab.jira.com/wiki/display/BDKPHN/Home',

        }
    },
);
$build->create_build_script();
