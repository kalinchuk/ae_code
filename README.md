## Running

`ruby normalize.rb`

## Questions

1) When approaching this challenge what were some of the other ideas you came up with to address the problem, and why didn't you use them?

Normalizing vehicle data is more complicated than this challenge encomposes. There are many more vehicle makes and models to account for and data could be wrong in any of the attributes (for example, the trim could be invalid for a Ford Focus). Better validation would have been good, such as ensuring that only certain trims are allowed for the make and model.

I would have split up the normalization into separate services to handle each one in isolation. It wasn't implemented that way due to lack of time and the fear of making it too complicated.

2) If you had, had access to other resources, what would you have chosen to use and why?

I would have used an existing library that handles normalization that would offset the amount of work required to implement the edge cases on our side.

3) If you chose to use a storage solution (e.g. database) what structure (e.g. tables) would you create to address this problem?

It would be helpful to know how this solution will be used in the real world but without knowing that I would probably create a `vehicle_types` tables to store all vehicle types. A `makes` table for all possible makes and variants for each. A `models` table for all models of each make. The models table would probably have all the possible trims as well.

Having all of this in the database will allow us to change the values directly in the DB instead of having to modify code.