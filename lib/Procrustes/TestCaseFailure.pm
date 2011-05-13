
use MooseX::Declare;

class Procrustes::TestCaseFailure {

    use Method::Signatures::Simple name => 'action';

    has case   => (isa => 'Procrustes::TestCase', is => 'rw', required => 1);
    has error  => (isa => 'Any|Undef', is => 'rw', required => 0);
    has result => (isa => 'Any|Undef', is => 'rw', required => 0);

    action is_error() {
        return defined $self->error();
    }
 
    # TODO: to_s()
 
}
