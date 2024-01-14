
import 'package:flutter/material.dart';

class SetGoalWidget extends StatelessWidget {
  SetGoalWidget({required this.saveToFirebase, super.key});

  final void Function(int) saveToFirebase;
  final formKey = GlobalKey<FormState>();
  String? enteredSteps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Steps',
                ),
                validator: (steps) {
                  if (steps!.trim().isEmpty) {
                    return 'Please enter your goal';
                  }
                  return null;
                },
                onSaved: (steps) {
                  enteredSteps = steps;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(formKey.currentState!.validate())
                        {
                          formKey.currentState?.save();
                          saveToFirebase(int.parse(enteredSteps!));
                          Navigator.pop(context);
                        }
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
