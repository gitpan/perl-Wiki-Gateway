#!/usr/bin/perl

###########################################################################
#
# Copyright 2004 Bayle Shanks
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details, published at 
# http://www.gnu.org/copyleft/gpl.html
#
# You may also redistribute or modify it under the terms of Perl's Artistic
# License, at your option. 
#
###########################################################################


#TODO: add tests for conditions like "entry not found", etc
#TODO (maybe): add tests for calling the program locally with manual setting of the CGI environment (just to make things easier to debug). see testHTTPs.txt for examples.

#####################################################################
#####################################################################
package testReadableWriteableCollection;
use base qw(Test::Unit::TestCase);
#####################################################################
#####################################################################


# an abstract package to use in building unit tests for things 
# that hold collections of pages that can be read from/written to


#use Test::Unit;
use Data::Dumper;

$TESTPAGE_NAME='SandBox';  

$TESTPAGE_SOURCE_TEXT='This is a test of something.';
$TESTPAGE_UPDATED_SOURCE_TEXT='This is a test of something. Test 2.';

#$TESTPAGE_RENDERED_TEXT=
#$TESTPAGE_UPDATED_RENDERED_TEXT=

$EXACT_MATCH = 1;


sub setConfigVars {
    my $self = shift;
		 
    $self->{TESTPAGE_NAME} = $TESTPAGE_NAME;
    $self->{TESTPAGE_SOURCE_TEXT} = $TESTPAGE_SOURCE_TEXT;
    $self->{TESTPAGE_UPDATED_SOURCE_TEXT} = $TESTPAGE_UPDATED_SOURCE_TEXT;
    $self->{username} = $USERNAME;
    $self->{password} = $PASSWORD;

    $self->{TESTPAGE_RENDERED_TEXT} = $TESTPAGE_RENDERED_TEXT;
    $self->{TESTPAGE_UPDATED_RENDERED_TEXT} = $TESTPAGE_UPDATED_RENDERED_TEXT;

    $self->{exact_match} = $EXACT_MATCH;
    $self->{PAUSE} = 0;
}


sub set_up {
    my $self = shift;
    
    $self->setConfigVars();
    $self->set_up_actual(@_);
}

sub set_up_actual {
    my $self = shift;

    if (! defined($self->{TESTPAGE_RENDERED_TEXT})) {	
	$self->{TESTPAGE_RENDERED_TEXT} = $self->{TESTPAGE_SOURCE_TEXT};
    }

    if (! defined($self->{TESTPAGE_UPDATED_RENDERED_TEXT})) {
	$self->{TESTPAGE_UPDATED_RENDERED_TEXT} = $self->{TESTPAGE_UPDATED_SOURCE_TEXT};
    }

    $self->{TESTPAGE_RENDERED_TEXT_QUOTED} = quotemeta($self->{TESTPAGE_RENDERED_TEXT});
    
}


sub new {
    my $self = shift()->SUPER::new(@_);
    # your state for fixture here
    return $self;
}



sub createTestPage {
    # should return the URL of the test page
       }


sub updateTestPage {
    # should return the URL of the test page
}

sub readTestPage {
    # should return the body of the test page
}

sub getTestFeed {
    #should return a @list of pages containing the test page as one item
}

sub getLink {
    #should return the URL of the test page
}

sub deleteTestPage {
}



##################################
##################################
##################################
##################################


sub test_createAndRead {
    my $self = shift;
    sleep($self->{PAUSE});
    print "\n--- test_createAndRead --\n";
    $res = $self->createTestPage();
    print $res."\n";
#    #$self->assert ($res eq "$URL_PREFIX$SANDBOX_NAME");

    $res = $self->readTestPage();
    print $res."\n";
    
    print "\n";

    if ($self->{exact_match}) {
	$self->assert ($res eq $self->{TESTPAGE_SOURCE_TEXT});
    }
    else {
	$self->assert ($res =~  /^\s*$self->{TESTPAGE_SOURCE_TEXT}\s*$/);
    }
}

#TODO: add test for bad names; try to create/update entry with name "i'm a bad title".

sub test_createUpdateAndRead {
                 my $self = shift;
    sleep($self->{PAUSE});
    print "\n--- test_createUpdateAndRead --\n";
    $res = $self->createTestPage();
    print $res."\n";
    sleep($self->{PAUSE});
    $res = $self->updateTestPage();
    print $res."\n";
#    #$self->assert ($res eq "$URL_PREFIX$SANDBOX_NAME");

    $res = $self->readTestPage();
    print $res."\n";
    print "\n";

    if ($self->{exact_match}) {
	$self->assert ($res eq $self->{TESTPAGE_UPDATED_SOURCE_TEXT});
    }
    else {
	$self->assert ($res =~  /^\s*$self->{TESTPAGE_UPDATED_SOURCE_TEXT}\s*$/);
    }
}

sub test_createAndGetFeed {
    my $self = shift;
    my $title;
    sleep($self->{PAUSE});

    print "\n--- test_createAndGetFeed --\n";
    $res = $self->createTestPage();
    print $res."\n";
#    #$self->assert ($res eq "$URL_PREFIX$SANDBOX_NAME");


    my @entries = $self->getTestFeed();
    print Dumper(@entries)."\n";

    print "\nEntries:\n";
    my $found = 0;
    foreach $entry (@entries) {
	$title = $self->entryTitle($entry);    
	$self->assert(defined($title));
	print "  ".$title."\n";
	if ($title eq $self->{TESTPAGE_NAME}) {$found = 1;}
    }
		 
    print "\n---\n";
    print "\n";

    $self->assert($found);
}


sub test_createAndGetLinkAndView {
    my $self = shift;

    my $link;
    sleep($self->{PAUSE});

    print "\n--- test_createAndGetLinkAndView --\n";
    $res = $self->createTestPage();
    print $res."\n";

    $link = $self->getLink();

    print "Going to get link: $link\n";
    $webPage = `wget --output-document=- '$link'`;
    print "Page:\n---$webPage\n---\n\n";
    
    print "\n";
		 
    if ($self->{exact_match}) {
	$self->assert($webPage eq $self->{TESTPAGE_RENDERED_TEXT});
    }
    else {
	print STDERR "(about to assert (\$webPage =~  /$self->{TESTPAGE_RENDERED_TEXT_QUOTED})...";
	$self->assert ($webPage =~  /$self->{TESTPAGE_RENDERED_TEXT_QUOTED}/);
	print "succeeded\n";
    }


}

sub test_createAndReadAndDelete {
                 my $self = shift;
    sleep($self->{PAUSE});

    print "\n--- test_createAndReadAndDelete --\n";
    $res = $self->createTestPage();
    print $res."\n";

    $res = $self->readTestPage();
    print $res."\n";

    sleep($self->{PAUSE});
    $res = $self->deleteTestPage();
    print $res->status_line."\n";

    print "GETing $self->{testPageEditURI} (expecting a 404 error)\n";
    $entry = $self->{api}->getEntry($self->{testPageEditURI});
    $self->assert(! defined($entry));
    print $self->{api}->errstr();
}




sub tear_down { 
#print "tear_down tests called\n"; 
}



