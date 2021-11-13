# Flutter CRUD
A simple todos list for practising Flutter CRUD operation on different databases.

Only the [lib](/lib) folder and [pubspec.yaml](/pubspec.yaml) file were uploaded. The other files will be created
by [Flutter SDK](https://flutter.dev/docs/get-started/install) on creating a new Flutter project.

## Databases/Data Providers used
Firebase, SQLite and HTTP requests.

### Firebase
To create a Flutter app with [Firebase](https://firebase.google.com/) as backend:
1. Create a [Google](https://www.google.com/) account.
2. Create a [Firebase](https://firebase.google.com/) project and add the app to it.
3. Add relevant [Flutter Firebase Plugins](https://firebase.flutter.dev/).

### SQLite
Refer to [Flutter Cookbook](https://flutter.dev/docs/cookbook/persistence/sqlite)
for an example of working with SQLite in a Flutter app.

### HTTP requests
[JSONPlaceholder fake api](https://jsonplaceholder.typicode.com/todos) was used
for this exercise.

Refer to [Flutter Cookbook](https://flutter.dev/docs/cookbook#networking) for
more details on working with HTTP requests in a Flutter app.

### Switching Databases/Data Providers
In [todos_repository.dart](/lib/models/todos_repository.dart), there are 3 factory constructor declaration.
Each declaration is an implementation of a database/data provider. Just
comment out the 2 implementation not to be used. The uncommented implementation
will be the active database/data provider.

Only [JSONPlaceholder fake api](https://jsonplaceholder.typicode.com/todos) has fake
data and a todos list will be shown on starting the app.

[Firebase Database](https://firebase.google.com/products/firestore) needs to be
set up in the [Firebase](https://firebase.google.com/) Console which requires a [Google](https://www.google.com/) account.
Set up the database as follows for the purpose of this exercise.
- collection name: 'todos'
- document fields:
    - 'title' for string values
    - 'isCompleted' for boolean values
    - 'userId' for number values 
  
  e.g.  
  {'title': 'Learn Flutter', 'isCompleted': false, 'userId': 1}  
  {'title': 'Drink water', 'isCompleted': false, 'userId': 1}  
  {'title': 'Buy some food', 'isCompleted': false, 'userId': 2}  
  {'title': 'Do something', 'isCompleted': false, 'userId': 1}  
  {'title': 'Go to school', 'isCompleted': false, 'userId': 2}  
- add at least 1 document to the collection to initialize the database.

SQLite has no initial data either. However, as it is an on-device database, initial data
can be added after starting the app.

## Dependencies
See [pubspec.yaml](/pubspec.yaml#L29).

