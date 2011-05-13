Procrustes
==========

From Greek mythology, Procrustes was an extreme tester.  In Perl land, I grew envious of RSpec and wanted
to do (somewhat less) extreme testing.   

I liked some of the descriptiveness of RSpec, but I also did not like some of the monkey-patched idioms.  This is an evolving
project and will gather more features over time.

Procrustes allows you to do simple and obvious things -- an exception fails a test, but continues to run
the other tests.  Returning false fails a test.  There's no silly usage of "is_ok" and so forth, unless you
want to use them.  

Usage
=====

     $self->describe("Another test suite...", [

            "Non zero return code should fail", sub {
                return 2 == 3;
            },

            "This will tell you why it is wrong", sub {
                return $self->is_equal(2,3);
            },

            "Inequality test will pass", sub {
                return $self->is_equal(2,3,0);
            },

            "This should work but takes 2 secs", sub {
                sleep(2);
                return 1;
            },

            "This will cause a traceback", sub {
                die "kaboom!\n"
            },

        ]);

setup() and teardown() capabilities are also supported.

Limitations
===========

Each TestPlugin defines exactly one "TestPlan", which has an English
name, with individual ordered tasks in it.  If you need to share things between one test to another,
you can.  See "AdvancedExample" in "examples_t".

Example Report Output
=====================

Each test prints a seperate summary of tests and failures, so you can see a full list of what cases
failed, in plain English.

    Success Summary
    ---------------
    0.000000 s | Something that returns true
    3.000000 s | Something that takes a while

    Failure Summary
    ---------------
    0.000000 s |  Here's something that returns false
    0.000000 s |  Something that raises an exception

    passed: (2/4) 50.00% 

Example Summary Output
======================

At the end of a test suite run, a summary is included showing which tests had successes and failures, intended
for integration with continuous integration systems like Jenkins or Cruise Control.

Tests can also be used as a lightweigt performance metric by comparing test times on multiple branches.
Benchmark module integration is a possible feature.

          time s | suite                                              |     passed |     failed |    %failed
      0.000000 s | Testing good stuff                                 |          2 |          0 |       0.00
      2.000000 s | Another test suite...                              |          1 |          2 |      66.67
      2.000000 s | TOTAL                                              |          3 |          2 |      40.00


License
=======

This project is MIT licensed, (C) 2011, Advanced Instructional Systems Inc.

Author
======

Michael DeHaan <michael.dehaan@gmail.com>


