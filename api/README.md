# How to use libkullo

## Global rules of the interface

### Async methods and listeners
Asynchronous stuff (basically everything that might take longer than a few ms)
runs asynchronously and has a name like `fooAsync()`. Asynchronous methods
take a listener which defines callbacks. These are used for reporting progress,
success and errors.

**Attention:** All async methods return an AsyncTask. It can be used to cancel
the task, but you must keep it as long as you want the task to run: If this
object is destroyed or garbage collected, the task will be canceled
automatically and no listener methods will be called.

### Thread safety
* Listener methods may be called from any thread, so they must be thread-safe.
* Non-listener methods are not guaranteed to be thread-safe and must only be
  called from the UI thread.

### Nullable types
All arguments and return values must be non-null, unless stated otherwise.


## A journey through the interface

### One-time init (Android)
* Call `LibKullo.init()` at least once before doing anything with the library.
  You don't need to prevent multiple calls: Only the first call does something.
  This initializes the LogListener and TaskRunner for you.
* Use `api.Client.create()` to get a client object which is the entry point to
  most of the other stuff.

### One-time init (direct use of the library)
* supply a LogListener implementation to Registry::setLogListener if you don't
  want log messages to go to stdout
* supply a TaskRunner implementation to Registry::setTaskRunner
* create a Client

### Creating a session for an existing account
* create a UserSettings object
* use Client.createSessionAsync with the UserSettings object
* get the session from the ClientCreateSessionListener.finished callback

### Retrieving and changing data
A Session object is the starting point for all queries of the available data.
Some examples:

* To get all conversation IDs, use
  `session.conversations().all()`.

* To get all message IDs for a given conversation ID, use
  `session.messages().allForConversation(convId)`.

* To add a new conversation, use `session.conversations().add(addresses)` with
  the set of addresses of the recipients.

* To save the contents of an attachment to disk, use
  `session.messageAttachments().saveToAsync(...)` with the attachment's message
  and attachment IDs, and the path where the attachment should be saved.

* To send and retrieve messages, or synchronize metadata, use
  `session.syncer().runAsync(...)`.

