import 'package:flutter/material.dart';

import '../domain/models/expense_category.dart';

final List<ExpenseCategory> initialExpenseCategories = [
  // Expense categories
  ExpenseCategory(
    id: 1,
    name: 'Food & Drinks',
    type: 'Expense',
    color: Color(0xFFF39C12),
    iconName: 'restaurant',
  ),
  ExpenseCategory(
    id: 2,
    name: 'Transportation',
    type: 'Expense',
    color: Color(0xFF2980B9),
    iconName: 'directions_car',
  ),
  ExpenseCategory(
    id: 3,
    name: 'Shopping',
    type: 'Expense',
    color: Color(0xFFC0392B),
    iconName: 'shopping_bag',
  ),
  ExpenseCategory(
    id: 4,
    name: 'Health',
    type: 'Expense',
    color: Color(0xFFE74C3C),
    iconName: 'local_hospital',
  ),
  ExpenseCategory(
    id: 5,
    name: 'Utilities',
    type: 'Expense',
    color: Color(0xFF8E44AD),
    iconName: 'lightbulb',
  ),
  ExpenseCategory(
    id: 6,
    name: 'Rent',
    type: 'Expense',
    color: Color(0xFF2C3E50),
    iconName: 'home',
  ),
  ExpenseCategory(
    id: 7,
    name: 'Entertainment',
    type: 'Expense',
    color: Color(0xFF9B59B6),
    iconName: 'movie',
  ),
  ExpenseCategory(
    id: 8,
    name: 'Travel',
    type: 'Expense',
    color: Color(0xFF1ABC9C),
    iconName: 'flight_takeoff',
  ),
  ExpenseCategory(
    id: 9,
    name: 'Education',
    type: 'Expense',
    color: Color(0xFF27AE60),
    iconName: 'school',
  ),
  ExpenseCategory(
    id: 10,
    name: 'Subscriptions',
    type: 'Expense',
    color: Color(0xFF34495E),
    iconName: 'subscriptions',
  ),

  // Income categories
  ExpenseCategory(
    id: 11,
    name: 'Salary',
    type: 'Income',
    color: Color(0xFF2ECC71),
    iconName: 'attach_money',
  ),
  ExpenseCategory(
    id: 12,
    name: 'Freelance',
    type: 'Income',
    color: Color(0xFF16A085),
    iconName: 'work',
  ),
  ExpenseCategory(
    id: 13,
    name: 'Investments',
    type: 'Income',
    color: Color(0xFF27AE60),
    iconName: 'trending_up',
  ),
  ExpenseCategory(
    id: 14,
    name: 'Gifts',
    type: 'Income',
    color: Color(0xFFF1C40F),
    iconName: 'card_giftcard',
  ),
  ExpenseCategory(
    id: 15,
    name: 'Other',
    type: 'Income',
    color: Color(0xFF7F8C8D),
    iconName: 'more_horiz',
  ),
];
