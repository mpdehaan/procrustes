Procrustes
==========

From Greek mythology, Procrustes was an extreme tester.  In Perl land, I grew envious of RSpec and wanted
to do extreme testing.   

I liked some of the descriptiveness of RSpec, but I also did not like some of the idioms.  This is an evolving
project and will gather more features over time.

Procrustes allows you to do simple and obvious things -- an exception fails a test, but continues to run
the other tests.  Returning false fails a test.  There's no silly usage of "is_ok" and so forth, so you
can bring whatever comparison tools you want to the table.

Better reporting, including benchmarks for each test, and easier profiling/coverage are planned.

Usage
=====

use Procrustes;

    my $tester = Procrustes->new();
    $tester->test([

        "Here's something that returns false", sub {
            return 2 == 3;
        },

        "Something that returns true", sub {
            return 1;
        },

        "Something that takes a while", sub {
            sleep(3);
            return 1;
        },

        "Something that raises an exception", sub {
            die "boom";
        },

    ])->report();

Example Report Output
=====================

    Success Summary
    ---------------
    0.000000 s | Something that returns true
    3.000000 s | Something that takes a while

    Failure Summary
    ---------------
    0.000000 s |  Here's something that returns false
    0.000000 s |  Something that raises an exception

    passed: (2/4) 50.00% 

License
=======

This project is MIT licensed, (C) 2011, Advanced Instructional Systems Inc.

Author
======

Michael DeHaan <michael.dehaan@gmail.com>


