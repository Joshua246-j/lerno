class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctIndex,
  });
}

// Hardcoded bank for fast local performance
const List<QuizQuestion> dummyQuestionBank = [
  QuizQuestion(
    questionText: 'What is 5 + 7?',
    options: ['10', '11', '12', '13'],
    correctIndex: 2,
  ),
  QuizQuestion(
    questionText: 'Which animal is known as man\'s best friend?',
    options: ['Cat', 'Dog', 'Elephant', 'Bird'],
    correctIndex: 1,
  ),
  QuizQuestion(
    questionText: 'What color is the sky on a clear day?',
    options: ['Green', 'Red', 'Blue', 'Yellow'],
    correctIndex: 2,
  ),
  QuizQuestion(
    questionText: 'How many legs does a spider have?',
    options: ['6', '8', '10', '4'],
    correctIndex: 1,
  ),
  QuizQuestion(
    questionText: 'What is the opposite of "Hot"?',
    options: ['Warm', 'Cold', 'Boiling', 'Dry'],
    correctIndex: 1,
  ),
  QuizQuestion(
    questionText: 'What shape is a pizza?',
    options: ['Square', 'Triangle', 'Circle', 'Rectangle'],
    correctIndex: 2,
  ),
  QuizQuestion(
    questionText: 'What do bees make?',
    options: ['Milk', 'Honey', 'Water', 'Juice'],
    correctIndex: 1,
  ),
  QuizQuestion(
    questionText: 'How many colors are in a rainbow?',
    options: ['5', '6', '7', '8'],
    correctIndex: 2,
  ),
  QuizQuestion(
    questionText: 'Which planet is known as the Red Planet?',
    options: ['Earth', 'Mars', 'Jupiter', 'Venus'],
    correctIndex: 1,
  ),
  QuizQuestion(
    questionText: 'What do you use to write on a blackboard?',
    options: ['Pen', 'Pencil', 'Chalk', 'Marker'],
    correctIndex: 2,
  ),
];
