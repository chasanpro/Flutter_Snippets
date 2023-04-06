//In Dart, you can pass a model to a list by simply creating a list of that model type and then adding instances of the model to the list. Here is an example:

//Suppose you have a model class called Person with properties name and age:


class Person {
  String name;
  int age;
  
  Person({required this.name, required this.age});
}
//You can create a list of Person objects and add instances of the Person class to the list as follows:


List<Person> people = [];

// Add two instances of Person to the list
Person john = Person(name: 'John', age: 25);
Person mary = Person(name: 'Mary', age: 30);

people.add(john);
people.add(mary);
//Now the people list contains two instances of the Person class.

//Alternatively, you can create the list with initial values like this:


List<Person> people = [john, mary];
//This creates a new list with the john and mary instances already added to it.





//how can access john name from the above list people
//To access john's name from the people list, you can use the index operator ([]) to get the Person instance at index 0, and then access its name property. Here is an example:


// Get the first Person instance from the people list
Person firstPerson = people[0];

// Access the name property of the firstPerson instance
String johnName = firstPerson.name;

print(johnName); // Output: John
//Alternatively, you can directly access john's name using the following one-liner:


String johnName = people[0].name;
//This will also output John.
