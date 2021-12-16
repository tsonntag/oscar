## Remarks

### General
I know that my written English is a mess.

### TDD
If I applied 'pure' TDD I would implement in a way that 
the given test cases would work.
However I also added test cases for the many other things that could happen.


### Size of a canvas

The specification does not define whether the canvas has a fixed size, i.e.
if is given when the canvas is created (Canvas.new(size))
or if it implicitely given by the 'extend' of the rectangles on the canvas.
However the size of the canvas has to be known for the flood function.
So either 
1. we have to give the size when the canvas is created (Canvas.new(size))
or
2. we have to provide the size to the flood function (Canvas.flood(point, size, fill_charactor))
I decided to implement 1.


### Test fixture 1

There is an error in the specification:
The rectangle at [3,2] should be lower case 'x', but the example shows am upper case 'X'
If used the update case 'X'.

### Test fixture 2

There is an error in the specification:
The rectangle at [15,0] should either be [14,0] or the canvas has to be fixed.


### Trailing spaces

The given test fixtures imply that trailing spaces have to be dropped.
I implemented it like even if I assumed a fixed canvas size


### Flood
I implemented the 'flood' such that it also works to non empty points.
See test case "flood on non empty point"
This is how it works in common drawing tools.


### Outside/Inside
I decided to 'ignore' points and sizes which would place a rectangle or flood
outside the canvas.
If a rectangle doesn't fit completedly in the canvas it will be cut.
