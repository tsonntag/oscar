## Remarks

### General
I know that my written English is a mess.

### Test fixture 1

There is an error in the specification:
The rectangle at [3,2] should be lower case 'x', but the example shows am upper case 'X'
If used the update case 'X'.

### Test fixture 2

There is an error in the specification:
The rectangle at [15,0] should either be [14,0] or the canvas has to be fixed.


### Trailing spaces
The given test fixtures imply that trailing spaces have to be dropped.
I implemented it like that even if fixed canvas size is assumed.


### Flood
I implemented the 'flood' such that it also works to non empty points.
See test case "flood on non empty point"
This is how it usually works in common drawing tools.


### Outside/Inside
I decided to 'ignore' points and sizes which would place a rectangle or flood
outside the canvas.
If a rectangle doesn't fit completedly in the canvas it will be cut.

### Negative arguments
Negative coordinates and lengths are ignored (are noop).
This is a design decision.


### Database
For such a trivial project a database like DETS would have been sufficient.
However I decided to use postgresql since it is part of a typical stack.

### Globally unique identifier
I assumed that there is only one database instance in production.
In this case the unique primary key 'id' of the canvases table can be used
as globally unique identifier.
In case of more instances I would add another string column containing an UUID 
to the canvases table
