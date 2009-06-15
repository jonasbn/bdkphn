package Class::Business::DK::Phonenumber;

# $Id$

use strict;
use warnings;
use vars qw($VERSION);
use Carp qw(croak);
use Business::DK::Phonenumber qw(validate render);

$VERSION = '0.01';

## no critic (ValuesAndExpressions::ProhibitEmptyQuotes, ValuesAndExpressions::ProhibitInterpolationOfLiterals])
use overload "" => \&render;

use constant DK_PREFIX        => '+45';
use constant DIGITS           => 8;
use constant DEFAULT_TEMPLATE => DK_PREFIX . ' %' . DIGITS . 'd';
use constant TRUE             => 1;
use constant FALSE            => 0;

sub new {
    my ( $class, $params ) = @_;

    my $self = bless {
        phonenumber => 0,
        template    => DEFAULT_TEMPLATE,
        prefix      => DK_PREFIX,
        },
        $class || ref $class;

    if ( $params->{phonenumber} ) {
        $self->phonenumber( $params->{phonenumber} )
            or croak 'phonenumber not in recognisable format';
    } else {
        croak 'phonenumber parameter is mandatory';
    }

    if ( $params->{template} ) {
        $self->template( $params->{template} )
            or croak 'template not in recognisable format';
    }

    $self->{prefix} = $params->{prefix};

    return $self;
}

sub phonenumber {
    my ( $self, $phonenumber, $template ) = @_;

    if ($phonenumber) {
        if ( validate($phonenumber) ) {
            $self->{phonenumber} = $phonenumber;
            return TRUE;
        } else {
            return FALSE;
        }
    } else {
        if ($template) {
            if ( $self->_template($template) ) {
                return $self->render($template);
            } else {
                croak 'template not in recognisable format';
            }
        } else {
            return $self->render();
        }
    }
}

sub template {
    my ( $self, $template ) = @_;

    if ($template) {
        if ( $self->_validate_template($template) ) {
            $self->{template} = $template;
            return TRUE;
        } else {
            return FALSE;
        }
    } else {
        return $self->{template};
    }
}

sub _validate_template {
    my ( $self, $template ) = @_;

    my @digits = $template =~ m/%(\d)+d/sxmg;

    my $sum = 0;
    foreach my $digit (@digits) {
        $sum += $digit;
    }

    if ( $sum == DIGITS ) {
        return TRUE;
    } else {
        return FALSE;
    }
}

1;

__END__

=pod

=head1 NAME

Class::Business::DK::Phonenumber - class to model, validate and format Danish telephonenumbers

=head1 VERSION

This documentation describes version 0.01

=head1 SYNOPSIS

    #OOP
    use Class::Business::DK::Phonenumber;
    
    #Constructor
    my $phonenumber = Class::Business::DK::Phonenumber->new('+45 12345678');
    
    #Brief human readable Danish phonenumber format with international prefix
    print Class::Business::DK::Phonenumber->render('+%d2 %d8');
    
    #a brief form validating a stripping everything
    my $phonenum =
        Class::Business::DK::Phonenumber->new('+45 12 34 56 78')->render('%d8');
    # 12345678
    
    #for MSISDN like representation with protocol prefix
    my $phonenum =
        Class::Business::DK::Phonenumber->new('+45 12 34 56 78')->render('GSM%d10');
    # GSM4512345678
    
    #for dialing Denmark with international country prefix and international
    #calling code for calling outside Denmark 00
    my $phonenum =
        Class::Business::DK::Phonenumber->new('12 34 56 78')->render('00%d10');
    # 004512345678

=head1 DESCRIPTION

This module offers functionality to validate, format and generate Danish
phonenumbers.

The validation can recognise telephone numbers is the following formats as
Danish phonenumbers.

=over

=item * 12345678

=item * 4512345678

=item * +4512345678

=back

White space characters are ignored. See also L</phonenumber>.

In addition to validation the module offers generation of valid danish
phonenumbers. The purpose of using generated phonenumber is up to the user, but
the original intent is generation of varied sets of test data.

The module can be utilized in both procedural and object-oriented manner.

=head1 SUBROUTINES AND METHODS

=head2 new({ phonenumber => $phonenumber, template => $template })

For validphonenumber formatting please refer to L</phonenumber>.

=head2 phonenumber($phonenumber, $template)

This is accessor to the phonenumber attribute for a Business::DK::Phonenumber
object. Provided with a valid phonenumber parameter the object's phonenumber
attribute is set.

If the accessor is not provided with a phonenumber parameter, the one defined is
in the object is returned.

See also: L<Business::DK::Phonenumber/validate>, which is used internally to validate the phonenumber
parameter.

Valid phonenumbers have to abide to the following formatting:

=over

=item * +<international prefix><8 digit phonenumber> 

=item * <international prefix><8 digit phonenumber>

=item * <8 digit phonenumber>

=back

The prefixed plus sign and space used as separator are optional as are the
international dialing code.

The phonenumber can be formatted in anyway separated using whitespace characters.

=head2 template($template)

This is accessor to the template attribute for a Business::DK::Phonenumber
object. Provided with a valid template parameter the object's template attribute
is set.

If the accessor is not provided with a template parameter, the one defined is in
the object is returned.

See also: L</_validate_template>, which is used internally to validate the
template parameter.

=head1 PRIVATE METHODS

=head2 _validate_template

This method is used internally to validate template parameters. Please refer to
Perl's sprintf for documentation.

=head1 DIAGNOSTICS

=over

=item * phonenumber not in recognisable format, the phone number provided to
the constructor is not parsable. Please evaluate what you are attempting to
feed to the constructor.

=item * phonenumber parameter is mandatory for the constructor, please specify
the phonenumber parameter to the constructor in order to continue.

=item * template not in recognisable format, the template provided to the
constructor is not in a parsable format, please evaluate what you attempting to
feed to the constructor.

=back

=head1 CONFIGURATION AND ENVIRONMENT

Business::DK::Phonenumber attempts to meet requirements of both a procuderal and
object oriented interface.

=head1 DEPENDENCIES

=over

=item * L<Carp>

=item * L<Exporter>

=item * L<Business::DK::Phonenumber>

=back

=head1 INCOMPATIBILITIES

No known incompatibilities at this time.

=head1 BUGS AND LIMITATIONS

No known bugs or limitations at this time.

=head1 TEST AND QUALITY

=over

=item * The L<Perl::Critic::Policy::ValuesAndExpressions::RequireNumberSeparators>
policy has been disabled. We are working with phonenumbers, strings consisting primarily of number, so not special interpretation or calculative behaviour is needed.

=item * L<Perl::Critic::Policy::ValuesAndExpressions::ProhibitConstantPragma> policy has been disabled. I like constants.

=item * L<Perl::Critic::Policy::InputOutput::RequireBracedFileHandleWithPrint> policy has been disabled for now should be revisited at some point.

=back

=head1 TODO

=over

=item * Please refer to the distribution TODO file

=back

=head1 SEE ALSO

=over

=item L<sprintf>

Business::DK::Phonenumber utilizes sprintf to as templating system for
formatting telephonenumbers. This is a well specified and tested interface
which is easy to use.

=back

=head1 BUG REPORTING

Please report issues via CPAN RT:

http://rt.cpan.org/NoAuth/Bugs.html?Dist=Business-DK-Phonenumber

or by sending mail to

bug-Business-DK-Phonenumber@rt.cpan.org

=head1 AUTHOR

Jonas B. Nielsen, (jonasbn) - C<< <jonasbn@cpan.org> >>

=head1 COPYRIGHT

Business-DK-Phonenumber is (C) by Jonas B. Nielsen, (jonasbn) 2008-2009

=head1 LICENSE

Business-DK-Phonenumber is released under the artistic license

The distribution is licensed under the Artistic License, as specified
by the Artistic file in the standard perl distribution
(http://www.perl.com/language/misc/Artistic.html).

=cut
