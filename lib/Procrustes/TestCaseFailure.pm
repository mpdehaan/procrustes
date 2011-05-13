# object to keep track of failed test case results -- could either be a non-zero return or a traceback

use MooseX::Declare;

class Procrustes::TestCaseFailure {

    use Method::Signatures::Simple name => 'action';

    has case   => (isa => 'Object', is => 'rw', required => 1);
    has error  => (isa => 'Any', is => 'rw', required => 0);
    has result => (isa => 'Any', is => 'rw', required => 0);

    action is_error() {
        return defined $self->error();
    }
 
    # TODO: to_s()
 
}
