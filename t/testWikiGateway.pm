#!/usr/bin/perl


#TODO: add tests for conditions like "entry not found", etc
#TODO (maybe): add tests for calling the program locally with manual setting of the CGI environment (just to make things easier to debug). see testHTTPs.txt for examples.

#####################################################################
#####################################################################
package testWikiGateway;
use base qw(testReadableWriteableCollection);
#####################################################################
#####################################################################

use Wiki::Gateway;

use Data::Dumper;

$TESTWIKI_URL='http://interwiki.sourceforge.net/cgi-bin/wiki.pl';
$TESTWIKI_TYPE='usemod1';

$TESTPAGE_NAME='SandBox';  
$TESTPAGE_URL='http://interwiki.sourceforge.net/cgi-bin/wiki.pl?SandBox';  
#TODO: a "getLink" fn should be added to WikiGateway

$TESTPAGE_SOURCE_TEXT='This is a test of <nowiki>WikiGateway</nowiki>.';
$TESTPAGE_UPDATED_SOURCE_TEXT='This is a test of <nowiki>WikiGateway</nowiki>. Test 2.';

$TESTPAGE_RENDERED_TEXT='This is a test of WikiGateway.';
$TESTPAGE_UPDATED_RENDERED_TEXT='This is a test of WikiGateway. Test 2.';

sub setConfigVars {
    my $self = shift;

    $self->SUPER::setConfigVars();

    $self->{TESTWIKI_URL} = $TESTWIKI_URL;
    $self->{TESTWIKI_TYPE} = $TESTWIKI_TYPE;
    $self->{TESTPAGE_NAME} = $TESTPAGE_NAME;
    $self->{TESTPAGE_URL} = $TESTPAGE_URL;
    $self->{TESTPAGE_SOURCE_TEXT} = $TESTPAGE_SOURCE_TEXT;
    $self->{TESTPAGE_UPDATED_SOURCE_TEXT} = $TESTPAGE_UPDATED_SOURCE_TEXT;
    $self->{TESTPAGE_RENDERED_TEXT} = $TESTPAGE_RENDERED_TEXT;
    $self->{TESTPAGE_UPDATED_RENDERED_TEXT} = $TESTPAGE_UPDATED_RENDERED_TEXT;
}

sub set_up_actual {
    my $self = shift;

    $self->SUPER::set_up_actual();
}




sub createTestPage {
    my $self = shift;
    print "creating $self->{TESTPAGE_NAME} with text ' $self->{TESTPAGE_SOURCE_TEXT}'\n";	 

    my $result = Wiki::Gateway::putPage($self->{TESTWIKI_URL}, $self->{TESTWIKI_TYPE}, $self->{TESTPAGE_NAME}, $self->{TESTPAGE_SOURCE_TEXT});
    
    print "got result $result\n";
    return $self->{TESTPAGE_URL}
}


sub updateTestPage {
    my $self = shift;
    print "updating $self->{TESTPAGE_NAME} with text ' $self->{TESTPAGE_UPDATED_SOURCE_TEXT}'\n";	 
    
    my $result = Wiki::Gateway::putPage($self->{TESTWIKI_URL}, $self->{TESTWIKI_TYPE}, $self->{TESTPAGE_NAME}, $self->{TESTPAGE_UPDATED_SOURCE_TEXT});
    
    print "got result $result\n";
    return $self->{TESTPAGE_URL}
}

sub readTestPage {
    my $self = shift;
    print "reading $self->{TESTPAGE_NAME}\n";
    
    my $result = Wiki::Gateway::getPage($self->{TESTWIKI_URL}, $self->{TESTWIKI_TYPE}, $self->{TESTPAGE_NAME});
    return $result;
}

sub getTestFeed {
    my $self = shift;
    print "getting rc:\n";
    $timestamp = Wiki::Gateway::daysAgoToDate(1);
    my $res = Wiki::Gateway::getRecentChanges($self->{TESTWIKI_URL},$self->{TESTWIKI_TYPE}, $timestamp);
    my @result = @{$res};

    #print Dumper(@result)."\n";

    return @result;
}

# this fn is irrelevant currently...
sub getLink {
    my $self = shift;

    return $self->{TESTPAGE_URL}; 
}

sub entryTitle {
    my $self = shift;
    my ($entry) = @_;

    return $entry->{name};
}

sub test_createAndReadAndDelete {
    # NOT SUPPORTED YET...
}



##################################
##################################
##################################
##################################


1;

