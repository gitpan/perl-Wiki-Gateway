package Wiki::Gateway;
$VERSION = 0.00199;


#BEGIN {
#use Inline Python => 'DATA',
#    NAME => 'Wiki::Gateway';

use Inline::Python qw(py_study_package py_bind_func py_call_function);
#}

#use Data::Dumper;



###############################
# "new"
#  this is how you make an object constructor in Perl
###############################

sub new {
    # first, ugly Perl OOP stuff
    my $proto = shift;
#    my $class = ref($proto) || $proto;
#    my $self  = {};


    my ($wikiURL, $wikiType) = @_;

    # now, initialize some variables
  #  $self->{pythonWikiGatewayObj} = WikiGatewayConstructor($wikiURL, $wikiType);
  $obj = WikiGatewayConstructor($wikiURL, $wikiType);
 hook_obj($obj);

   # hook_obj($self->{pythonWikiGatewayObj});

#    import_methods_into_global_namespace($self->{pythonWikiGatewayObj});
    


#    print Dumper(make_list_of_methods($self->{pythonWikiGatewayObj}));
    
#    @methodList = make_list_of_methods($self->{pythonWikiGatewayObj});
#    foreach $method (@methodList) {
#	py_bind_func("Wiki::Gateway::" . $method, "__main__", $method);
#	py_bind_func('$self->{' . $method . '}', "__main__", $method);
        
#    }


#    #$self->{threshold}  = undef;
#    #$self->{timeunits}   = 1;
 #   #$self->{v}    = undef;
 #   #$self->{spikelist}  = undef;

    # finally, more ugly Perl OOP stuff
 #   bless ($self, $class);
    #return $self;
return $obj;
}

sub test_namespace {

    print "******\n";
}

###########################################################################
###########################################################################
###########################################################################
# misc packaging stuff
###########################################################################
###########################################################################


BEGIN {
    use Exporter   ();
    our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);

    my @LIST_OF_ALL_WIKIGATEWAY_API_SUBROUTINES = qw(&getRecentChanges &getRPCVersionSupported &getPage &getPageHTML &getPageHTMLVersion &getAllPages &getPageInfo &getPageInfoVersion &listLinks &putPage &daysAgoToDate &daysSinceDate);

    # set the version for version checking
    @ISA         = qw(Exporter);
    @EXPORT      = qw();
    %EXPORT_TAGS = ( 
                     ALL => 
                       \@LIST_OF_ALL_WIKIGATEWAY_API_SUBROUTINES
                     );    

    # your exported package globals go here,
    # as well as any optionally exported functions
    @EXPORT_OK   = @LIST_OF_ALL_WIKIGATEWAY_API_SUBROUTINES;
}
our @EXPORT_OK;


1;

#   __DATA__
#   __Python__

use Inline Python => <<'END_OF_PYTHON_CODE';

from WikiGateway import WikiGateway as WikiGatewayConstructor 
import WikiGateway as WikiGatewayModule
from WikiGateway import *
import sys

def test_namespace2():
    print "--------\n";


class lastExceptionClass:
    def __init__(self):
      self.info = None
    pass

lastException = lastExceptionClass()


#def hook_exception_handling(obj):
#    for fn in dir(obj):


def _method_substitute(method, *args, **keywords):
    lastException.info = None
    try:
      #print 'ENTRY'
#      return method(*args, **keywords)
      result = method(*args, **keywords)
      #print 'result:'
      #print `result`
      return deUnicodeRecursive(result)  # workaround for a bug 
                                         # in Inline::Python
    except:
      lastException.info = sys.exc_info()
      #print lastException.info[1]
      return -1
      #raise sys.exc_info()[1] 
 



def _method_substitute_factory(method):
    def m(*args, **keywords):
      return _method_substitute(method, *args, **keywords)
    return m
 
def call_method(obj, methodName, args, keywords):
    method = getattr(obj, methodName)
    #print obj
    #print method
    #print args
    #print keywords
    return _method_substitute(method, *args, **keywords)



def getattr(*args, **keywords):
    return __builtins__.getattr(*args, **keywords)

def getLastExceptionType():
    if lastException.info:
      return lastException.info[0]

def make_list_of_methods(obj):
    import types
    #print [  (itemName, type(getattr(obj, itemName)))  for itemName in dir(obj) ]
    return [itemName for itemName in dir(obj) if type(getattr(obj, itemName)) == types.UnboundMethodType or type(getattr(obj, itemName)) == types.FunctionType]



def hook_obj(classobj):
    fnList = make_list_of_methods(classobj)
    for fnName in fnList: 
#      def method_substitute(*args, **keywords):
#        call_method(
      method = getattr(classobj, fnName)
      setattr(classobj, fnName, _method_substitute_factory(method))
      

def import_methods_into_global_namespace(obj):
    fnList = make_list_of_methods(obj)
    for fnName in  fnList:
      cmd = 'global %s\n' % fnName
      cmd += '%s = obj.%s' % (fnName, fnName)
      exec(cmd)




def recursiveMap_sequences_dicts(data, baseCasePredicate, operation):
    '''
NOTE: if the structure has cycles (aside from sequences whose
subsequences are themselves, such as single-character strings), 
this will not halt
    '''
    if baseCasePredicate(data):
      #print "hit base case at " + `data`
      return operation(data)

    import types
    if type(data) == types.DictType:
      for key in data.keys():
        item = data[key]

        newItem = recursiveMap_sequences_dicts(item, baseCasePredicate, operation)
        #data[key] = newItem

        newKey = recursiveMap_sequences_dicts(key, baseCasePredicate, operation) 
        #print "new key, item: " + `newKey` + ' ' + `newItem`

        # "if newKey != key:" doesn't catch unicode difference; 
        #instead of introducing new predicate, let's just always change the key
        del data[key]
        data[newKey] = newItem

    else:
      try:
        for index, item in enumerate(data):
          if item == data:
            return data
          #print 'about to recurse on ' + `data[index]`
          #print 'which has type ' + `type(data[index])`
          data[index] = recursiveMap_sequences_dicts(item,  baseCasePredicate, operation)        
      
      except TypeError:
        return data

    return data

def deUnicode(data):
    import types
    if type(data) == types.UnicodeType:
      return data.encode('ascii','replace')
    else:
      return data

def deUnicodeRecursive(data):
    '''
    De-unicodes recursive structures involving only lists and dicts
    '''
    import types

    return recursiveMap_sequences_dicts(
					data, 
					lambda data: (type(data) == types.UnicodeType),
					deUnicode)





### "hook_obj" for globals from WikiGateway package
import types
fnList = [itemName for itemName in globals().keys() if type(globals()[itemName]) == types.UnboundMethodType or type(globals()[itemName]) == types.FunctionType]
#print `[type(globals()[i]) for i in fnList]`

#print dir(WikiGatewayModule)
fnList = filter(lambda x: x in dir(WikiGatewayModule), fnList)


for fnName in fnList: 
    #print 'hooking ' + fnName
    method = globals()[fnName]
    globals()[fnName] = _method_substitute_factory(method)

END_OF_PYTHON_CODE
