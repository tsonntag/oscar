# Oscar - an ASCII Art Drawning Service

Oscar is a web service providing the following drawing operations:

#### Create a new canvas parameterised with...

- *width* and *height*.
- an optional *fill* character (default: ' ')
 
.

    POST localhost:4000/api/canvas
         Content-Type: application/json"
         Data: {"canvas": { "width": *width*, "height": *height*, "fill": *fill*}

*Example*:

    curl -X POST --data 'canvas: {"width": 5, "height": 4, "fill": "." }}' -H "Content-Type: application/json" localhost:4000/api/canvas`

returns:

    {"data":{"content":"...\n...","id":19}}

where content is a string representing the canvas with *id*
    .....
    .....
    .....
    .....
    .....



#### Create a rectangular to canvas parameterised with…

- *id* of the canvas
- Coordinates *x* and *y* for the *upper-left corner*.
- *width* and *height*.
- an optional *fill* character.
- an optional *outline* character.
- One of either *fill* or *outline* should always be present.

    PUT localhost:4000/api/canvas/:id/rect
        Content-Type: application/json" 
        Data: {"canvas": { "x": *x*, "y": *y*, "width": *width*, "height": *height*, "fill": *fill*, "outline": *outline*}

##### Example:

    curl -X PUT --data '{"canvas": {"x": 0, "y": 0, "width": 3, "height": 3, "fill": "X", "outline": "O"}}'' -H "Content-Type: application/json" localhost:4000/api/canvas/19/rect

returns:

    {"data":{"content":"OOO..\nOXO..\nOXO..\nOOO..","id":19}}

where content is a string representing the canvas with *id*

    OOO..
    OXO..
    OOO..
    .....



#### A Flood Fill operation parameterised with…

- the coordinates *x* and *y* from where to begin the flood fill.
- a *fill* character.

A flood fill operation draws the fill character to the start coordinate, 

and continues to attempt drawing the character around (up, down, left, right) 

in each direction from the position it was drawn at, 

as long as a different character, or a border of the canvas, is not reached.


##### Example:

`curl -X PUT --data '{"canvas": {"x": 0, "y": 0, "fill": "F"}}'' -H "Content-Type: application/json" localhost:4000/api/canvas/19/fill`

`{"data":{"content":"FFF..\nFXF..\nFXF..\nFFF..","id":21}`

where content represents the canvas

  FFF..
  FxF..
  FXF..
  FFF..



To start your Phoenix server:

  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
  

Now you can visit [`localhost:4000/canvas`](http://localhost:4000/canvas) from your browser.
