# Oscar - ASCII Art Drawning Service

Oscar is a web service providing the following drawing operations:

### Create a canvas:

    POST localhost:4000/api/canvas
         Content-Type: application/json"
         Data: {"canvas": { "width": <width>, "height": <height>, "fill": <fill>}}
         
with parameters:
- *width* and *height*
- an optional *fill* character (default: ' ')
 
##### Example:

    curl -X POST --data 'canvas: {"width": 5, "height": 4, "fill": "." }}' -H "Content-Type: application/json" localhost:4000/api/canvas

returns:

    {"data":{"content":"...\n...","id":42}}

where content is a string representing the canvas with *id*:

    .....
    .....
    .....
    .....
    .....



### Draw a rectangular:

    PUT localhost:4000/api/canvas/:id/rect
        Content-Type: application/json" 
        Data: {"canvas": { "x": <x>, "y>: <y>, "width": <width>, "height": <height>, "fill": <fill>, "outline": <outline>}}

with parameters:
- *id* of the canvas
- Coordinates *x* and *y* for the *upper-left corner*.
- an optional *fill* character.
- an optional *outline* character.
- One of either *fill* or *outline* should always be present.


##### Example:

    curl -X PUT --data '{"canvas": {"x": 0, "y": 0, "width": 3, "height": 3, "fill": "X", "outline": "O"}}'' -H "Content-Type: application/json" localhost:4000/api/canvas/42/rect

returns:

    {"data":{"content":"OOO..\nOXO..\nOXO..\nOOO..","id":42}}

where content is a string representing the canvas with *id*:

    OOO..
    OXO..
    OOO..
    .....



### A Flood Fill operation

    PUT localhost:4000/api/canvas/:id/fill
        Content-Type: application/json" 
        Data: {"canvas": { "x": <x>, "y>: <y>, "fill": <fill>}}


with parameters:

- the coordinates *x* and *y* from where to begin the flood fill.
- a *fill* character.

A flood fill operation draws the fill character to the start coordinate, 
and continues to attempt drawing the character around (up, down, left, right) 
in each direction from the position it was drawn at, 
as long as a different character, or a border of the canvas, is not reached.


##### Example:

     curl -X PUT --data '{"canvas": {"x": 0, "y": 0, "fill": "F"}}' -H "Content-Type: application/json" localhost:4000/api/canvas/42/fill
     
returns: 

     {"data":{"content":"FFF..\nFXF..\nFXF..\nFFF..","id":21}`

where content represents the canvas with *id*:

    FFF..
    FxF..
    FXF..
    FFF..


### Show a canvas:

    GET localhost:4000/api/canvas/:id


##### Example:

     curl localhost:4000/api/canvas/42
     
returns: 

     {"data":{"content":"FFF..\nFXF..\nFXF..\nFFF..","id":21}`

where content represents the canvas with *id*:

    FFF..
    FxF..
    FXF..
    FFF..


### List all canvases:

    GET localhost:4000/api/canvas


##### Example:

    curl localhost:4000/api/canvas

 
#### To start the server:

  * Install an start a Postgresql database
  * Clone this repository
  * Create and migrate your database with `mix ecto.setup`
  * Start the server with `mix phx.server` or inside IEx with `iex -S mix phx.server`
  

Now you can use [`localhost:4000/canvas/api`](http://localhost:4000/canvas/api) for the web service
or visit [`localhost:4000/canvas`](http://localhost:4000/canvas) in your browser.
