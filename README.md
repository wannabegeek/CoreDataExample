CoreDataExample
===============

Simple Example of CoreData Usage.
This is just a very quick rough project (written in about 2 hours) to demonstrate CoreData and some of it's basic features.
To implement this rapidly I have incorporated some file for provious projects

======

## Key Features:
- Using a CoreData store
- Will seed the store on initial creation using values stored in a plist file (TFAppDelegate.m:26)
- When seeding the store this is done on a separate thread (TFAppDelegate.m:32), if this was more complex/time consuming it would prevent the UI from being unusable.
- Also, when seeding the operations as done on a child context, so that if the import was to fail (& there was some error checking!) the changes can easily be rolled back by not merging the contexts via the save: call.
- Uses CoreData Transformable type to store URLs in an attribute (URLValueTransformer class)
- Observing CoreData update notifications (TFSymbolDetailsViewController.m:52) to update the UI when we receive an update to the manage object.
- Attempts to show detailed CoreData save errors (TFAppDelegate.m:117)
- Uses CoreData initialisers (awakeFromFetch: & awakeFromSnapshotEvent:) to initiate quote request (TFSymbol class).
- Uses:
	- Auto Layout (all done in InterfaceBuilder)
	- ARC
	- Blocks (e.g. TFAsynchronousURLLoader.m:21)

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
- Searching on the symbol list view isn't the most efficient, should really create a separate NSFetchedResultsController for searching with.
- No indicator to show the user that data is loading in details view
- No UnitTests implemented
- Rotation in Symbol details view is not pretty!