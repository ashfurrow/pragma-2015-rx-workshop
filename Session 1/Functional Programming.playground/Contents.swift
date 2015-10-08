/*:

# Session 1: Functional Fundamentals

---

Functional programming is a programming paradigm with a long and complicated history. We don't really have time to go into it all, so for the purposes of _this_ workshop, we'll define it as follows. 

> Functional programming treats functions as data types and avoids mutability.

Let's break that down. 

### Functions as Data Types

This means that functions are values which can be assigned to variables, passed as parameters, etc. Pretty much anything you can do to another data type, like an integer, say. Swift supports this natively. For example, let's consider the following.

*/

func doSomething() {
    print("hi!")
}

let someVariable = doSomething

/*:

The _type_ of `someVariable` is well-known to us – it is the same type as the function's signature. So the above line is really shorthand syntax for `var someVariable: () -> () = doSomething`. 

Once a function is assigned to a variable, it can be invoked as you normally would invoke a function.

*/

someVariable()

/*:

This line calls through to the original function. Let's see what else we can do. 

Image our function also has a parameter. What would that look like?

*/

func doSomethingWithString(string: String) {
    print("hi, \(string)!")
}

let otherVariable = doSomethingWithString

/*:

Again, we can predict the type of `otherVariable` will be `String -> ()`. And we can invoke the original fucntion with the same syntax as before.

*/

otherVariable("Ash")

/*:

Multiple parameters can also be used, and even invoked using Swift's tuple syntax.

*/

func doSomethingWithOneString(string: String, andOtherString otherString: String) {
    print("hi, \(string) and \(otherString)!")
}

let aFurtherDifferentVariable = doSomethingWithOneString
let parameters = ("Ash", andOtherString: "Orta")
aFurtherDifferentVariable(parameters)

/*:

Note that the type of `doSomethingWithOneString` is (String, andOtherString: String) -> ()`. This looks a bit weird, eh? There are a few things that are weird. 

The first thing is that the parameter label is actually a part of the type. This is really important, because the type signature of the parameters has to match the type signature of the function if we want to invoke it. With tuples, the labels actually change the type. So `(String, String)` is a valid tuple type, but it's not the same as `(String, andOtherString: String)`. If you try to use the wrong type, the compielr will yell at you.

Finally, we need to be able to access the return value of an invoked function. This is pretty straightforward.

*/

func somethingThatReturns() -> String {
    return "Hi, Ash!"
}

let returnFunction = somethingThatReturns
let returnValue = returnFunction()
print(returnValue)

/*:

### Avoiding Mutability

Mutability and state are commonly used arguments for functional programming. However, state exists in the real world and, when writing applications, is an unavoidable problem. We'll see after coffee how this can be solved using FRP.

The key to mutability is to _avoid_ it, but understand that it's not always possible. Pick your battles. Try to avoid code that changes state, especially global state. Don't do this:

*/

var x = 0
for var i = 0; i < 10; i++ {
    x++
}
print("x is \(x)")

//: That's a very small example that doesn't really highlight the problem. You often don't write code like this, do you? Well, what about finding the sum of all the numbers in an array?

let numbers = [4, 6, 88, 47, 99, 7]
x = 0
for var i = 0; i < numbers.count; i++ {
    x += numbers[i]
}
print("x is \(x)")

/*: 

Functional programming calls this a bad approach, and I agree with it. However, I recognize that sometimes writing this kind of code is unavoidable, or not possible in the time constraints you work in. (We'll see shortly how to change this to be more functional.)

## Functional Examples

We've seen how to store functions in variables. Swift also lets us pass functions into other functions as parameters. You may have already used this.

*/

numbers.map { (number) -> Int in
    return number * 2
}

/*

`map` is called with a closure that is applied to each member in the array, which returns another number. What is nice about Swift is that functions and closures are interchangeable.

*/

func double(number: Int) -> Int {
    return number * 2
}
numbers.map(double)

/*:

This is semantically identical to the first example – it produces the same results.

In addition to `map`, you may have seen some other functions called `filter`, `sort`, and `reduce`. They're both _super_ interesting – let's see `filter` first.

As it's name suggestions, `filter` produces a new array that has all of the original elements _if_ the closure returns `true` when invoked on that element. Let's get all of our odd numbers.

*/

numbers.filter { (number) -> Bool in
    return number % 2 == 1
}

func isOdd(number: Int) -> Bool {
    return number % 2 == 1
}
numbers.filter(isOdd)

/*:

Did you know that operators in Swift are also functions? It's true! Think about customer operator overloading and it makes sense. 

Sorting an array into ascending order can be accomplished by using `sort` and passing in a closure that returns `true` if the first parameter is less than the second operator.

*/

numbers.sort { (first, second) -> Bool in
    return first < second
}

//: But there is an operator in Swift that also returns `true` with the same behaviour. It is the `<` operator, so we can invoke `sort` as follows.

numbers.sort(<)

/*:

`filter` and `sort` seem pretty easy, but `reduce` is where people begin to have problems.

`reduce` is useful for when you have a collection of things that you need to reduce down to a single value. The internals of how it works are a little difficult to understand. 

Also called a _fold_, `reduce` takes two parameters: an initial value and a closure. Let's discuss the closure first. 

The closure is invoked on each member of the array. It passes in two parameters: the member its currently operating on, and the return value from the last time the closure was invoked. 

What if it's the first time the closure was invoked? Well that's when the initial value comes in. 

Let's take a look at an example. The following code looks for the largest value in the array.

*/

numbers.reduce(Int.min) { (memo, value) -> Int in
    if value > memo {
        return value
    } else {
        return memo
    }
}
numbers

/*:

`Int.min` is a good initial value since it represents the smallest possible integer, which will never be returned from the closure. Part of using `reduce` effectively is being able to pick a good initial value (the initial value must be the same type as the array).

The first parameter is called `memo`, it's the return value from last time (or the initial value). Sometimes `memo` is called an `accumulator`. Let's see the parameters and return values from each of the 6 invocations.

    (Int.min, 4) -> 4
    (4, 6) -> 6
    (6, 88) -> 88
    (47, 88) -> 88
    (88, 47) -> 88
    (88, 99) -> 99
    (99, 7) -> 99

The return value from the final closure invocation is the return value of the `reduce` function call.


*/

//: The above code can further be simplified using the `max` function.

numbers.reduce(Int.min) { (memo, value) -> Int in
    return max(memo, value)
}

//: What else can `reduce` do? Well, remember the example earlier with the mutable `x`? We can use `reduce` here, too.

numbers.reduce(0) { (memo, number) -> Int in
    return memo + number
}

//: And of course, since the closure is just adding the two numbers, we can simplify our use of `reduce`.

numbers.reduce(0, combine: +)

/*: 

Reduce is really great whenever you have a bunch of things and need them turned into only one thing.

## Currying

Currying, sometimes called "partial application" is where you call a function, and it returns a function. That's really it. A simple concept with a funny name. Let's see an example.

*/

let names = ["Ash", "Orta", "Jory", "Sarah", "Eloy"]
names.map { (name) -> String in
    return "Hi, \(name)!"
}

func sayHi(name: String) -> String {
    return "Hi, \(name)!"
}
names.map(sayHi)

func say(greeting: String) -> ( String -> String ) {
    return { name -> String in
        return "\(greeting), \(name)!"
    }
}
names.map(say("Hi"))

//: All of these are the same, and show the progression from a simple closure, to a reusable function, to a curried function return for `map`. Currying is so important in Swift that it has its own syntax. 

func betterSay(greeting: String)(name: String) -> String {
    return "\(greeting), \(name)!"
}

names.map(betterSay("Hi"))

//: Here we passed the return value into `map` directly, but we can also store it in a variable.

func divide(top: Float)(_ bottom: Float) -> Float {
    return top / bottom
}
divide(15)(5)

let inverse = divide(1)
inverse(5)

numbers.map{
    return Float($0) // Turn from [Int] to [Float]
}.map(inverse)

/*:

Hold onto your hats, because things are about to get even weirder. 

Instance methods in Swift are actually class functions that are invoked with an instance, called `self`, and return the instance method to be invoked. 

Let me repeat. 

Instance methods are actually class methods that accept a single parameter, `self`. This class function returns the actual function we declare. So we can do some cool things.

*/

class Person {
    let name: String

    init(name: String) {
        self.name = name
    }

    func getName() -> String {
        return name
    }
}

let people = names.map { name -> Person in
    return Person(name: name)
}


//: This takes our `names` array and turns it into an array of `[Person]`. Then, the following two lines are semantically identical:

people.map { $0.getName }
people.map(Person.getName)

//: They both map _to functions_, so they're not incredibly useful. However, if you want to use them later on in another, chained map, that would work well.

people.map(Person.getName).map { $0().lowercaseString }

/*:

The first takes each instance and asks for the function called `getName` (but it doesn't invoke that function). The second accesses the class method `getName` on the `Person` type, and applies that function to each member of the `people` array. This returns the instance method `getName` for each individal instance.

Very cool.

We can use this with `reduce`, too. Say we want the longest name from our `[Person]` array.

*/

people.map(Person.getName).reduce("") { (memo, value) -> String in
    let name = value()
    if name.characters.count > memo.characters.count {
        return name
    } else {
        return memo
    }
}

func longerString(first: String, _ secondClosure: () -> String) -> String {
    let second = secondClosure()
    if first.characters.count > second.characters.count {
        return first
    } else {
        return second
    }
}

people.map(Person.getName).reduce("", combine: longerString)

/*: 

The point isn't that you _should_ write this exact code, but rather to start thinking _functionally_, which is a much more powerful point. Who cares about mutability if you can think in terms of functios, enabled by the awesome Swift type system.

Let's see another example. Say we want to filter out email addresses.

*/

extension String {
    // Turns property into a function
    func toLower() -> String {
        return self.lowercaseString
    }
}

// Generate emails array
let emails = names.map(String.toLower).map { name -> String in
    return "\(name())@artsy.net"
}

emails.filter { (address) -> Bool in
    return address.characters.contains("@")
}

func containsAtSign(address: String) -> Bool {
    return address.characters.contains("@")
}
emails.filter(containsAtSign)

func contains(target: Character)(inside: String) -> Bool {
    return inside.characters.contains(target)
}
emails.filter(contains("@"))

//: Not that useful, but what if we wanted to sort by other characters?

emails.filter(contains("o"))

/*:

What I'm trying to convince you is to start a small library of functions you can re-use throughout your project. They can refer to internal types and do amazing things with them. This lets you write shorter, expressive code.

## Next steps

So what now? Well, we want to look through your code for places that you're mutating state, even within a function. Are you finding the sum of anything, or turning an array of one thing into an array of another? Maybe taking an array and finding the biggest, or smallest thing? Or sorting? Is there any sorting code that could use a function defined once, and used over and over? Are you sorting a common data type based on a slightly different sort order?

If you have state throughout your app, try to put it inside new objects. Contain the state in one places so it doesn't leak out.

*/
