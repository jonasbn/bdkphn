package Business::DK::Phonenumber;

# $Id$

use strict;
use warnings;
use vars qw($VERSION @EXPORT_OK);
use Carp qw(croak);
use base qw(Exporter);

$VERSION   = '0.01';
@EXPORT_OK = qw(validate render);

use constant TRUE             => 1;
use constant FALSE            => 0;
use constant DEFAULT_TEMPLATE => '+45 %8d';

sub new {
    my ( $class, $params ) = @_;

    my $self = bless {
        phonenumber => 0,
        template    => DEFAULT_TEMPLATE,
        prefix      => '+45',
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
        if ( $self->validate($phonenumber) ) {
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
        if ( $self->_template($template) ) {
            $self->{template} = $template;
            return TRUE;
        } else {
            return FALSE;
        }
    } else {
        return $self->{template};
    }
}

sub _template {
    my ( $self, $template ) = @_;

    my @digits = $template =~ m/%(\d)+d/xmg;

    my $sum = 0;
    foreach my $digit (@digits) {
        $sum += $digit;
    }

    if ( $sum == 8 ) {
        return TRUE;
    } else {
        return FALSE;
    }
}

sub validate {
    my ( $self, $phonenumber ) = @_;

    if ( not ref $self ) {
        $phonenumber = $self;
    }

    $phonenumber =~ s/\s//xmg;

    if ( $phonenumber =~ m/\A(
            (?:\+)(?:45)(?:\d{8})| #+4512345678
            (?:45)(?:\d{8})|       #4512345678
            (?:\d{8})              #12345678
        )\b/gmx ) {
        return 1;
    } else {
        return 0;
    }
}

sub render {
    my ( $self, $phonenumber, $template ) = @_;

    if ( not ref $self ) {
        $template    = $phonenumber;
        $phonenumber = $self;
    } else {
        $template = $self->{template};

        if ( not $phonenumber ) {
            $phonenumber = $self->{phonenumber};
        }
    }

    return sprintf $template, $phonenumber;

}

sub generate {
    my ( $self, $template, $amount ) = @_;

    if ( not $amount ) {
        $amount = 1;
    }

    if ( not $template ) {
        $template = DEFAULT_TEMPLATE;
    }

    my @phonenumbers;
    while ($amount) {
        if ( ref $self ) {
            push @phonenumbers, $self->_generate($template);
        } else {
            push @phonenumbers, _generate($template);
        }
        $amount--;
    }

    return @phonenumbers;
}

sub _generate {
    my ( $self, $template ) = @_;

    if ( ref $self ) {
        return $self->render( rand(99999999), $template );
    } else {
        $template = $self;
        return render( rand(99999999), $template );
    }
}

1;

__END__

=pod

=head1 NAME

Business::DK::Phonenumber - module to validate and format Danish telephonenumbers

=head1 VERSION

This documentation describes version 0.01

=head1 SYNOPSIS

    #Procedural interface
    use Business::DK::Phonenumber qw(validate render);
    
    #Validation
    if (Business::DK::Phonenumber->validate($phonenumber)) { ... }
    
    #Default format
    print Business::DK::Phonenumber->render($phonenum);
    # +45 12 34 56 78
    
    #Brief human readable Danish phonenumber format with international prefix
    print Business::DK::Phonenumber->render($phonenum, '+%d2 %d8');
    # +45 12345678
    
    #Brief human readable Danish phonenumber format
    print Business::DK::Phonenumber->render($phonenum, '%d8');
    # 12345678
    
    #Normal human readable Danish phonenumber format
    print Business::DK::Phonenumber->render($phonenum, '%d2 %d2 %d2 %d2');
    # 12 34 56 78
    
    #Long human readable Danish phonenumber format with international prefix
    print Business::DK::Phonenumber->render($phonenum, '+%d2 %d2 %d2 %d2 %d2');
    # +45 12 34 56 78, default format
    
    #OOP interface
    use Business::DK::Phonenumber;
    
    #Constructor
    my $phonenumber = Business::DK::Phonenumber->new('+45 12345678');
    
    #Brief human readable Danish phonenumber format with international prefix
    print Business::DK::Phonenumber->render('+%d2 %d8');
    
    #a brief form validating a stripping everything
    my $phonenum =
        Business::DK::Phonenumber->new('+45 12 34 56 78')->render('%d8');
    # 12345678
    
    #for MSISDN like representation with protocol prefix
    my $phonenum =
        Business::DK::Phonenumber->new('+45 12 34 56 78')->render('GSM%d10');
    # GSM4512345678
    
    #for dialing Denmark with international country prefix and international
    #calling code for calling outside Denmark 00
    my $phonenum =
        Business::DK::Phonenumber->new('12 34 56 78')->render('00%d10');
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

The following subroutines are to be used in a procedural manner.

=head2 validate($phonenumber)



=head2 render($phonenumber, $template)

=head2 generate($template)


The following methods are to be used in a OOP manner.

=head2 new({ phonenumber => $phonenumber, template => $template })

For validphonenumber formatting please refer to L</phonenumber>

=head2 phonenumber($phonenumber)

This is accessor to the phonenumber attribute for a Business::DK::Phonenumber
object. Provided with a valid phonenumber parameter the object's phonenumber
attribute is set.

If the accessor is not provided with a phonenumber parameter, the one defined is
in the object is returned.

See also: L</_phonenumber>, which is used internally to validate the phonenumber
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

See also: L</_template>, which is used internally to validate the template
parameter.

=head1 PRIVATE METHODS

=head2 _phonenumber()

=head2 _template()

=head1 DIAGNOSTICS

=over

=item * 

=back

=head1 CONFIGURATION AND ENVIRONMENT

Business::DK::Phonenumber attempts to meet requirements of both a procuderal and
object oriented interface.

=head1 DEPENDENCIES

=over

=item * L<Carp>

=item * L<Exporter>

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 TEST AND QUALITY

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

Business-DK-Phonenumber is (C) by Jonas B. Nielsen, (jonasbn) 2008

=head1 LICENSE

Business-DK-Phonenumber is released under the artistic license

The distribution is licensed under the Artistic License, as specified
by the Artistic file in the standard perl distribution
(http://www.perl.com/language/misc/Artistic.html).

=cut
