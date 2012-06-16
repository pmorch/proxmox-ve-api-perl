#!/bin/false

package Net::Proxmox::VE::Pools;

use strict;
use warnings;
use base 'Exporter';

=head1 NAME

Net::Proxmox::VE::Pools

=head1 SYNOPSIS

  @pools = $obj->pools();
  $pool  = $obj->get_pool('poolid');

  $ok = $obj->create_pool(%args);
  $ok = $obj->create_pool(\%args);

  $ok = $obj->delete_pool('poolid');

  $ok = $obj->update_pool('poolid', %args);
  $ok = $obj->update_pool('poolid', \%args);

=head1 DESCRIPTION

This module implements the 'pools' section of the Proxmox API for L<Net::Proxmox::VE>,
you should use the API via that module. This documentation is for detailed reference.

To be clear, this module isn't useful as a stand alone piece of software.

=head1 METHODS

=cut

our $VERSION = 0.2;
our @EXPORT  = qw( pools );

my $base = '/pools';

=head2 pools

Gets a list of pools (aka the a Pool Index)

  @pools = $obj->pools();

=cut

sub pools {

    my $self = shift or return;

    return $self->get($base);

}

=head2 get_pool

Gets a single pool's configuration details

  $pool = $obj->get_pool('poolid');

poolid is a string in pve-poolid format

=cut

sub get_pool {

    my $self = shift or return;

    my $a = shift or die 'No poolid for get_pool()';
    die 'poolid must be a scalar for get_pool()' if ref $a;

    return $self->get( $base, $a );

}

=head2 create_pool

Creates a new pool

  $ok = $obj->create_pool( %args );
  $ok = $obj->create_pool( \%args );

I<%args> may items contain from the following list

=over 4

=item poolid

String. The id of the pool you wish to access, this is required
(in pve-poolid format)

=item comment

String. This is a comment associated with the new pool, this is optional

=back

=cut

sub create_pool {

    my $self = shift or return;
    my @p = @_;

    die 'No arguments for create_pool()' unless @p;
    my %args;

    if ( @p == 1 ) {
        die 'Single argument not a hash for create_pool()'
          unless ref $a eq 'HASH';
        %args = %{ $p[0] };
    }
    else {
        die 'Odd number of arguments for create_pool()'
          if ( scalar @p % 2 != 0 );
        %args = @p;
    }

    return $self->post( $base, \%args )

}

=head2 delete_pool

Deletes a single pool

  $ok = $obj->delete_pool('poolid')

poolid is a string in pve-poolid format

=cut

sub delete_pool {

    my $self = shift or return;
    my $a    = shift or die 'No argument given for delete_pool()';

    return $self->delete( $base, $a );

}

=head2 update_pool

Updates (sets) a pool's data

  $ok = $obj->update_pool( 'poolid', %args );
  $ok = $obj->update_pool( 'poolid', \%args );

poolid is a string in pve-poolid format

I<%args> may items contain from the following list

=over 4

=item comment

String. This is a comment associated with the new pool, this is optional

=item delete

Boolean. Removes the vms/storage rather than adding it.

=item storage

String. List of storage ids (in pve-storage-id-list format)

=item vms

String. List of virtual machines (in pve-vmid-list format)

=back

=cut

sub update_pool {

    my $self   = shift or return;
    my $poolid = shift or die 'No poolid provided for update_pool()';
    die 'poolid must be a scalar for update_pool()' if ref $poolid;
    my @p = @_;

    die 'No arguments for update_pool()' unless @p;
    my %args;

    if ( @p == 1 ) {
        die 'Single argument not a hash for update_pool()'
          unless ref $a eq 'HASH';
        %args = %{ $p[0] };
    }
    else {
        die 'Odd number of arguments for update_pool()'
          if ( scalar @p % 2 != 0 );
        %args = @p;
    }

    return $self->put( $base, $poolid, \%args );

}

=head1 VERSION

  VERSION 0.2

=head1 AUTHORS

 Dean Hamstead L<<dean@fragfest.com.au>>

=cut

1;
