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
my $test_class = $test_class_factory->class_for('NGS::Tools::BEDTools::Roles::CoverageBed');

# instantiate the test class based on the given role
my $coverage;
lives_ok
	{
		$coverage = $test_class->new();
		}
	'Class instantiated';

my $bam = 'test.bam';
my $bed = 'target.bed';
my $coverage_run = $coverage->coverage_bed(
	bam => $bam,
	bed => $bed
	);

my $expected_cmd = join(' ',
	'coverageBed',
	'-abam test.bam',
	'-b target.bed',
	'-hist -d',
	'> test.coverage.txt'
	);

is($coverage_run->{'cmd'}, $expected_cmd, 'Command matches expected');
