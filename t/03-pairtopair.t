use Test::More tests => 2;
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
my $test_class = $test_class_factory->class_for('NGS::Tools::BEDTools::Roles::PairToPair');

# instantiate the test class based on the given role
my $bedtools;
lives_ok
	{
		$bedtools = $test_class->new();
		}
	'Class instantiated';
my $bedpe1 = 'tumour.bedpe';
my $bedpe2 = 'normal.bedpe';
my $pair_run = $bedtools->pair_to_pair(
	bedpe1 => $bedpe1,
	bedpe2 => $bedpe2
	);
my $expected_cmd = 'pairToPair -a tumour.bedpe -b normal.bedpe -type neither -rdn > tumour.somatic.bedpe';
is($pair_run->{'cmd'}, $expected_cmd, 'pairToPair command matches expected');
