package Tie::Alias;

use 5.008;
use strict;
use warnings;

use Carp;
our $VERSION = '0.01';

sub isAlias { 1; };

sub TIESCALAR {

	my ( $class , $ref ) = @_ ;
	ref($ref) or croak "NOT A REFERENCE";
	if ( eval { tied($$ref) -> isAlias } ) {
		# we are re-aliasing something
		return tied ($$ref);
	}else{
		# $ref is already a pointer to the object
		bless $ref, $class;
	};
};

sub STORE {
	${$_[0]} = $_[1];
};


sub FETCH {
	${$_[0]};
};

sub TIEARRAY {
	require Tie::Alias::Array;
	$_[0] = 'Tie::Alias::Array';
	goto &Tie::Alias::Array::TIEARRAY;
};

sub TIEHASH {
	require Tie::Alias::Hash;
	$_[0] = 'Tie::Alias::Hash';
	goto &Tie::Alias::Hash::TIEHASH;
};

sub TIEHANDLE {
	require Tie::Alias::Handle;
	$_[0] = 'Tie::Alias::Handle';
	goto &Tie::Alias::Handle::TIEHANDLE;
};



1;
__END__

=head1 NAME

Tie::Alias - create aliases for lexicals in pure perl

=head1 SYNOPSIS

  use Tie::Alias;
  my $scalar = 'sad puppy';
  tie my $alias, Tie::Alias => \$scalar;  # just like local *alias = \$scalar
  $alias = 'happy puppy';
  print $scalar,"\n";	# prints happy puppy


=head1 ABSTRACT

 create aliases to lexicals thrugh a tie scalar interface

=head1 DESCRIPTION

  the Tie::Alias TIESCALAR function takes one argument, which is a reference
  to the scalar which is to be aliased.  In case the scalar is already tied
  using Tie::Alias or something else that has a defined C<isAlias> method
  that returns a true value, the target scalar will get tied to 

  Currently Tie::Alias only works for scalars.  Adding support for
  all tieable types will be trivial.  In fact, Tie::Alias has a rudimentary
  TIEARRAY, TIEHASH, and TIEHANDLE methods in it that want to delegate 
  to Tie::Alias::TIEinterface in case those classes ever spring into existence.

=head2 EXPORT

None.

=head1 SEE ALSO

	perltie

=head1 AUTHOR

   david nicol

=head1 COPYRIGHT AND LICENSE

Copyright 2002 by david nicol / tipjar LLC

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut

