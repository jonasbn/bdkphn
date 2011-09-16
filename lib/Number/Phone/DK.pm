package Number::Phone::DK;

 # $Id$

use strict;
use warnings;
use Business::DK::Phonenumber qw(validate render);
use Carp qw(croak);

## no critic (Subroutines::ProhibitExplicitReturnUndef)

sub new {
    my ($class) = shift;
	
	my $number = join('', @_);
   
	if (not $number) {
    	croak ("Need to specify a number for ".__PACKAGE__."->new()\n");
    }

	if (not validate($number)) {
		croak ('Unable to validate number');
	}

	my $self = bless {}, $class || ref $class;
	$self->{number} = $number;
	
	return $self;
}

sub is_valid {}

#not allocated 17, 19, 67, 68, 83, 84, 85, 92, 93, 94, 95 and 290
sub is_allocated { return undef;  } 

sub is_in_use { return undef; }

sub is_geographic { return undef; }

sub is_fixed_line { return undef; }

sub is_mobile { return undef; }

sub is_pager { return undef; }

sub is_ipphone { return undef; }

sub is_isdn { return undef; }

#80
sub is_tollfree { return undef; }

#90
sub is_specialrate { return undef; }

sub is_adult { return undef; }

sub is_personal { return undef; }

sub is_corporate { return undef; }

sub is_government { return undef; }

sub is_international { return undef; }

sub is_network_service { return undef; }

sub country_code { return '45'; };

sub regulator { return undef; }

sub areacode { return undef; }

sub areaname { return undef; }

sub location { return undef; }

sub subscriber { return undef; }

sub operator { return undef; }

sub type { return undef; }

sub format { 
	my $self = shift;
	
	#default pattern: +45 XX XX XX XX (see Business::DK::Phonenumber)
	return render($self->{number}); 
}

sub country { return 'DK'; }

sub translates_to { return undef; }

1;

__END__

=pod

=head1 SEE ALSO

=over

=item * L<http://www.itst.dk/>

=item * L<http://www.itst.dk/tele-og-internetregulering/nummerforhold/nummerplanen-1>

=item * L<http://www.itst.dk/tele-og-internetregulering/nummerforhold/nummerfiler-privat/Nummerplanen%202008-10.pdf>

=back

=cut

