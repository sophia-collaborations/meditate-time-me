# meditate-time-me
A meditation timer


## Some Options

### -rev [intnum-X]
Reverse the process of increase-interval by approximately X steps.

### -rqf [file] [val]
Continue only so long as the file specified in the first argument is present
with the contents specified in the second argument.

This option is added in order to incorporate this command into time-management
scripts - and as such it is the duty of any calling program that uses this
option to assure that the file in question is present with the specified
contents to begin with.

### -adv [intnum-X]
Advance the process of increase-interval by approximately X steps.

### -chk
Check the current meditation duration

### -tb
Take Backsie on most recent meditation on record having started. (Of course, limited by how far back our records go, which is about five meditations.)
