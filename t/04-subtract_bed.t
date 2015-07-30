use Test::More tests => 1;
use Test::Moose;
use Test::Exception;
use MooseX::ClassCompositor;
use Test::Files;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use File::Temp qw(tempfile tempdir);
use Data::Dumper;

# setup the class creation process
my $test_class_factory = MooseX::ClassCompositor->new(
    { class_basename => 'Test' }
    );

# create a temporary class based on the given Moose::Role package
my $test_class = $test_class_factory->class_for('NGS::Tools::BEDTools::Roles::SubtractBed');

# instantiate the test class based on the given role
my $bedtools;
lives_ok
    {
        $bedtools = $test_class->new();
        }
    'Class instantiated';

$subtract_bed = $bedtools->subtract_bed(
    fileA => 'A.vcf',
    fileB => 'B.vcf',
    remove_overlap => 'true',
    min_overlap => 0.000000001,
    same_strand => 'true'
    );
print Dumper($subtract_bed);
