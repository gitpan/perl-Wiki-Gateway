#!/usr/bin/perl

package testOnInterwikiSoftware;
use base qw(testWikiGateway);

$TESTWIKI_URL='http://interwiki.sourceforge.net/cgi-bin/wiki.pl';
$TESTWIKI_TYPE='oddmuse1';

$TESTPAGE_NAME='SandBox';  
$TESTPAGE_URL='http://interwiki.sourceforge.net/cgi-bin/wiki.pl?SandBox';  


$TESTPAGE_SOURCE_TEXT='This is a test of <nowiki>WikiGateway</nowiki>.';
$TESTPAGE_UPDATED_SOURCE_TEXT='This is a test of <nowiki>WikiGateway</nowiki>. Test 2.';

$TESTPAGE_RENDERED_TEXT='This is a test of WikiGateway.';
$TESTPAGE_UPDATED_RENDERED_TEXT='This is a test of WikiGateway. Test 2.';

#sub test_tester {
#    print "test!";
#}

#    print "test2!";

sub setConfigVars {
    my $self = shift;
		 
    $self->{TESTWIKI_URL} = $TESTWIKI_URL;
    $self->{TESTWIKI_TYPE} = $TESTWIKI_TYPE;
    $self->{TESTPAGE_NAME} = $TESTPAGE_NAME;
    $self->{TESTPAGE_URL} = $TESTPAGE_URL;
    $self->{TESTPAGE_SOURCE_TEXT} = $TESTPAGE_SOURCE_TEXT;
    $self->{TESTPAGE_UPDATED_SOURCE_TEXT} = $TESTPAGE_UPDATED_SOURCE_TEXT;
    $self->{TESTPAGE_RENDERED_TEXT} = $TESTPAGE_RENDERED_TEXT;
    $self->{TESTPAGE_UPDATED_RENDERED_TEXT} = $TESTPAGE_UPDATED_RENDERED_TEXT;
    $self->{PAUSE} = 11;
}



####################
####################
####################


#TODO: these tests really should be ordered, b/c if the text hasn't been modified at least once, the page won't show up on RecentChanges

1;
