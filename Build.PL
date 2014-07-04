use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'NGS::Tools::BEDTools',
    license             => 'Artistic_2_0',
    dist_author         => q{Richard de Borja <richard.deborja@sickkids.ca>},
    dist_abstract       => 'Package for the BEDTools suite of tools',
    dist_version_from   => 'lib/NGS/Tools/BEDTools.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'Moose::Role'               => 0,
        'MooseX::Params::Validate'  => 0,
        'File::Basename'            => 0
    },
    add_to_cleanup     => [ 'NGS-Tools-BEDTools-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
