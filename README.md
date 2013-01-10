CoreDataExample
===============

Simple Example of CoreData Usage.
This is just a very quick rough project (written in about 2 hours) to demonstrate CoreData and some of it's basic features.

======

## Key Features:
- Using a CoreData store
- Will seed the store on initial creation using values stores in a plist file (TFAppDelegate.m:93)
- When seeding the store this is done on a separate thread (TFAppDelegate.m:100), if this was more complex it wouldn't prevent the UI from being usable.
- Also, when seeding the operations as done on a child context, so that if the import was to fail (& there was some error checking!) the changes can easily be rolled back by not merging the contexts via the save: call.
- Uses CoreData Transformable type to store URLs in an attribute (URLValueTransformer class)
- Observing CoreData update notifications (TFSymbolDetailsViewController.m:53) to update the UI when we receive an update to the manage object.
- Attempts to show details CoreData save errors (TFAppDelegate.m:85)

=====

## Known Issues:
- Code requires a tidy-up.
- Currently no iPad support.
- User interface doesn't "look nice".
- When editing symbol list, cell doesn't indent content.
	This is a known issue when using AutoLayout for custom UITableViewCells, to solve this we manually need to move all the constrains to the cell.contentView from the cell.
- Uses a private Google Finance API.
- Code isn't properly commented.
- Error checking is rare & not handled properly.
- XML parsing of URLConnection response is very rough and make assumptions on data format, which if change will not fail gracefully.
- No validation for invalid symbols.
- Searching on the symbol list view isn't the most efficient, should real create a separate NSFetchedResultsController for searching with.
- No indicator to show the user that data is loading
- No UnitTests implemented
- Rotation in Symbol details view is not pretty!