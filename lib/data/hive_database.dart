import 'package:hive_flutter/hive_flutter.dart';

import '../models/expense_items.dart';

class HiveDataBase {
  // reference our box that we created
  final _myBox = Hive.box("expense_database");

  // write data
  void saveData(List<ExpenseItem> allExpense) {
/*

Hive can only store primitive data and not custom objects like ExpenseItem.
we'll convert our ExpenseItem objects into types that can be stored in our hive database

allExpense = 
[

  ExpensItem(name/ amount/ dateTime)
  ..



]

 ->
 [

  [name, amount, dateTime]

 ]

*/

    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpense) {
      // convert each ExpenseItem into list of storable type (string, dateTime)
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

// finally lets store in our database
    _myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }

  // read the data
  List<ExpenseItem> readData() {
    /* 
    
    data is stored in Hive as list of Strings + database. Lets convert 
    our saved data into ExpenseItem objects

    savedData = 
    [
      [name, amount, dateTime] i in the savedExpenses loop is for an ExnpenseItem while 0,1,2 are the items inside it
      ..

    ]

    ->
    [

    ExpenseItem (name, amount, dateTime),
    ..

    ]

    */

    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      // collect individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      // create expense Item
      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      // add expense to overAll list of expense
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}
