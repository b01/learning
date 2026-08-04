# Return Multiple Values

Python had this first, beating Go by roughly two decades.

In Python, you can return multiple values from a function by separating the
values with commas in your return statement. [1]

Technically, Python packages these comma-separated values into a single tuple
object, which you can then easily unpack into separate variables when calling
the function. [2, 3, 4, 5]

Here is a guide to the most common ways to handle multiple return values.

## The Standard Way: Tuples & Unpacking

This is the default and most Pythonic method. You omit parentheses in the
return statement, and catch the values in order. [1, 3]

```python
def get_user_data():
    name = "Alice"
    age = 30
    role = "Engineer"
    return name, age, role  # Python automatically wraps this in a tuple
# Unpacking into separate variablesuser_name, user_age, user_role = get_user_data()

print(user_name)  # Output: Alice
print(user_age)   # Output: 30
```

## Ignoring Unwanted Values
If you only need some of the returned values, use an underscore (_) as a placeholder to drop the ones you do not want: [6, 7] 

```python
# Only care about name and role
user_name, _, user_role = get_user_data()
```

## The Readable Way: Dictionaries

When returning more than 3 values, positional tuples can become confusing.
Returning a dictionary allows you to access values by descriptive keys instead
of their positions. [2, 3, 8]

```python
def calculate_metrics(numbers):
    return {
        "sum": sum(numbers),
        "average": sum(numbers) / len(numbers),
        "count": len(numbers)
    }
results = calculate_metrics([10, 20, 30])
print(results["average"])  # Output: 20.0
```

## The Structured Way: Data Classes

This is my preferred way, since the other methods to not supporting typing. I
even use this for simple code bases.

For complex codebases, returning a dataclass provides type safety,
autocompletion in code editors, and dot-notation access (object.attribute).
[2, 3]

```python
from dataclasses import dataclass

@dataclassclass CarDetails:
    make: str
    model: str
    year: int

def get_car_info():
    return CarDetails(make="Toyota", model="Corolla", year=2024)

car = get_car_info()
print(car.make)   # Output: Toyota
print(car.year)   # Output: 2024
```

---

[1] [https://note.nkmk.me](https://note.nkmk.me/en/python-function-return-multiple-values/)
[2] [https://www.geeksforgeeks.org](https://www.geeksforgeeks.org/python/g-fact-41-multiple-return-values-in-python/)
[3] [https://roadmap.sh](https://roadmap.sh/python/return-multiple-values)
[4] [https://stackoverflow.com](https://stackoverflow.com/questions/39345995/how-does-python-return-multiple-values-from-a-function)
[5] [https://coddy.tech](https://coddy.tech/learn/python/logic_and_flow/returning_multiple_values)
[6] [https://www.youtube.com](https://www.youtube.com/watch?v=Si4RQQLzSMo&vl=en&t=8)
[7] [https://www.vervecopilot.com](https://www.vervecopilot.com/interview-questions/why-mastering-python-return-multiple-values-is-your-secret-weapon-in-technical-interviews)
[8] [https://stackoverflow.com](https://stackoverflow.com/questions/354883/alternatives-for-returning-multiple-values-from-a-python-function)
[9] [https://labex.io](https://labex.io/tutorials/python-how-to-document-a-python-function-using-docstrings-417961)
[10] [https://news.ycombinator.com](https://news.ycombinator.com/item?id=6948807)
