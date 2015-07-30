#!/usr/bin/env perl

### get_bedtools_coverage.pl ######################################################################
# Generate a file containing BEDTools coverageBed output.

### HISTORY #######################################################################################
# Version       Date            Developer           Comments
# 0.01          2014-07-09      rdeborja            initial development
# 0.02          2015-07-30      rdeborja            updated POD, added PBS submission

### INCLUDES ######################################################################################
use warnings;
use strict;
use Carp;
use Getopt::Long;
use Pod::Usage;
use NGS::Tools::BEDTools;
use HPF::PBS;
use File::ShareDir ':ALL';

### COMMAND LINE DEFAULT ARGUMENTS ################################################################
# list of arguments and default values go here as hash key/value pairs
our %opts = (
	bam => undef,
	bed => undef,
	program => '/hpf/tools/centos6/BEDTools/2.16.2/bin/coverageBed',
    submit_to_cluster => 'true',
    memory => 24
    );

### MAIN CALLER ###################################################################################
my $result = main();
exit($result);

### FUNCTIONS #####################################################################################

### main ##########################################################################################
# Description:
#   Main subroutine for program
# Input Variables:
#   %opts = command line arguments
# Output Variables:
#   N/A

sub main {
    # get the command line arguments
    GetOptions(
        \%opts,
        "help|?",
        "man",
        "bam|b=s",
        "bed=s",
        "program=s",
        "submit_to_cluster:s",
        "memory:i"
        ) or pod2usage(64);
    
    pod2usage(1) if $opts{'help'};
    pod2usage(-exitstatus => 0, -verbose => 2) if $opts{'man'};

    while(my ($arg, $value) = each(%opts)) {
        if (!defined($value)) {
            print "ERROR: Missing argument $arg\n";
            pod2usage(128);
            }
        }

    my $bedtools = NGS::Tools::BEDTools->new();
    my $coverage_bed = $bedtools->coverage_bed(
    	bam => $opts{'bam'},
    	bed => $opts{'bed'},
    	program => $opts{'program'}
    	);

    my $pbs = HPF::PBS->new();
    my $template_dir = join('/',
        dist_dir('HPF'),
        'templates'
        );
    my $template = 'submit_to_pbs.template';
    my $coverage_bed_run = $pbs->create_cluster_shell_script(
        command => $coverage_bed->{'cmd'},
        jobname => 'coverage_bed',
        template_dir => $template_dir,
        template => $template,
        submit => $opts{'submit_to_cluster'},
        memory => $opts{'memory'}
        );
    return 0;
    }


__END__


=head1 NAME

get_bedtools_coverage.pl

=head1 SYNOPSIS

B<get_bedtools_coverage.pl> [options] [file ...]

    Options:
    --help              brief help message
    --man               full documentation
    --bam               BAM file to process
    --bed               BED file identifying the regions to calculate coverage
    --program           full path to BEDTools' coverageBed
    --submit_to_cluster submit to cluster, default: true
    --memory            memory to allocate to job, default: 24

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exit.

=item B<--man>

Print the manual page.

=item B<--bam>

Name of BAM file to process.

=item B<--bed>

Name of BED file to process.

=item B<--program>

Full path to the coverageBED BEDTools program.

=item B<--submit_to_cluster>

A true/false flag to determine whether to submit the job to the cluster (default: true).

=item B<--memory>

Amount of memory (in GB) to allocate for the job (default: 24).

=back

=head1 DESCRIPTION

B<get_bedtools_coverage.pl> Generate a file containing BEDTools coverageBed output.

=head1 EXAMPLE

get_bedtools_coverage.pl --bam test.bam --bed target.bed --program /usr/local/bin/coverageBed

=head1 AUTHOR

Richard de Borja -- The Hospital for Sick Children

=head1 ACKNOWLEDGEMENTS

Dr. Adam Shlien, PI -- The Hospital for Sick Children

=cut

