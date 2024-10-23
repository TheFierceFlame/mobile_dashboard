import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomFilters extends ConsumerStatefulWidget {
  const CustomFilters({super.key});

  @override
  CustomFiltersState createState() => CustomFiltersState();
}

class CustomFiltersState extends ConsumerState<CustomFilters> {
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.orange[900],
      content: SizedBox(
        height: 130,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(child: fromDate(context, dateController)),
              MaterialButton(
                child: const Text("Aceptar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget fromDate(BuildContext context, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Fecha inicial',
        prefixIcon: Icon(Icons.calendar_today),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2
          )
        )
      ),
      onTap: () => _showDatePicker(controller),
    );
  }

  Widget fromDateRange() {
    return DateRangePickerDialog(firstDate: DateTime.now(), lastDate: DateTime.now());
  }

  Future<void> _showDatePicker(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100)
    );

    if(picked != null) {
      setState(() {
        controller.text = picked.toString().split(" ")[0];
      }); 
    }
  }
}