package NGS::Tools::BEDTools::PairToPair;
use Moose::Role;
use MooseX::Params::Validate;

use strict;
use warnings FATAL => 'all';
use namespace::autoclean;
use autodie;
use File::Basename;

=head1 NAME

NGS::Tools::BEDTools::PairToPair

=head1 SYNOPSIS

A Perl Moose role that wraps the BEDTools pairToPair program.

=head1 ATTRIBUTES AND DELEGATES

=head2 $obj->pairToPair

Full path to BEDTools' pairToPair program.  Default is to assume pairToPair
is in the $PATH.

=cut

has 'pairToPair' => (
    is          => 'rw',
    isa         => 'Str',
    required    => 0,
    default     => 'pairToPair',
    reader      => 'get_pairToPair',
    writer      => 'set_pairToPair'
    );


=head1 SUBROUTINES/METHODS

=head2 $obj->pair_to_pair()

A method wrapper the BEDTools pairToPair program.

=head3 Arguments:

=over 2

=item * bedpe1: first BEDPE file to analyze

=item * bedpe2: second BEDPE file to analyze

=item * type: type of analysis to perform, can be neither, either, both, or notboth

=item * padding: also referred to as "slop" in the BEDTools documentation

=item * require_different_names: set to "true" if you require different read names to ensure no self overlaps (default: false)

=item * program: full path to the pairToPair program

=back

=cut

sub pair_to_pair {
    my $self = shift;
    my %args = validated_hash(
        \@_,
        bedpe1 => {
            isa         => 'Str',
            required    => 1
            },
        bedpe2 => {
            isa         => 'Str',
            required    => 1
            },
        type => {
            isa         => 'Str',
            required    => 0,
            default     => 'neither'
            },
        padding => {
            isa         => 'Int',
            required    => 0,
            default     => 0
            },
        program => {
            isa         => 'Str',
            required    => 0,
            default     => $self->get_pairToPair()
            },
        require_different_names => {
            isa         => 'Str',
            required    => 0,
            default     => 'true'
            },
        output => {
            isa         => 'Str',
            required    => 0,
            default     => ''
            }
        );

    my $output;
    if ($args{'output'} eq '') {
        $output = join('.',
            basename($args{'bedpe1'}, qw( .bedpe .bed )),
            'somatic',
            'bedpe'
            );
        }
    else {
        $output = $args{'output'};
        }

    my $options = join(' ',
        '-a', $args{'bedpe1'},
        '-b', $args{'bedpe2'},
        '-type', $args{'type'}
        );

    if ($args{'require_different_names'} eq 'true') {
        $options = join(' ',
            $options,
            '-rdn'
            );
        }
    elsif ($args{'require_different_names'} eq 'false') {
        # do nothing, this is really a hack for a place holder
        }
    else {
        die "Invalid option for \'require_different_names\'";
        }

    my $cmd = join(' ',
        $args{'program'},
        $options,
        '>',
        $output        
        );
    

    my %return_values = (
        cmd => $cmd,
        output => $output,
        );

    return(\%return_values);
    }

=head1 AUTHOR

Richard de Borja, C<< <richard.deborja at sickkids.ca> >>

=head1 ACKNOWLEDGEMENT

Dr. Adam Shlien, PI -- The Hospital for Sick Children

Dr. Roland Arnold -- The Hospital for Sick Children

Dr. Matthew Anaka -- The Hospital for Sick Children / The University of Toronto

Andrej Rosic -- The Hospital for Sick Children / Waterloo University

=head1 BUGS

Please report any bugs or feature requests to C<bug-test-test at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=test-test>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc NGS::Tools::BEDTools::PairToPair

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=test-test>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/test-test>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/test-test>

=item * Search CPAN

L<http://search.cpan.org/dist/test-test/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Richard de Borja.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

no Moose::Role;

1; # End of NGS::Tools::BEDTools::PairToPair
