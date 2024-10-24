import 'package:dashboard_app/presentation/providers/analytics/filters_provider.dart';
import 'package:dashboard_app/presentation/providers/analytics/sales/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

TextEditingController _dateController = TextEditingController();

class WeeklySalesFilters extends ConsumerStatefulWidget {
  const WeeklySalesFilters({super.key});

  @override
  WeeklySalesFiltersState createState() => WeeklySalesFiltersState();
}

class WeeklySalesFiltersState extends ConsumerState<WeeklySalesFilters> {
  @override
  void initState() {
    super.initState();
    ref.read(weeklySalesFiltersProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = ref.watch(weeklySalesFiltersProvider).isNotEmpty ? ref.watch(weeklySalesFiltersProvider)[0].toString() : _dateController.text;
    
    _dateController.text = currentDate;

    return AlertDialog(
      backgroundColor: Colors.orange[900],
      content: SizedBox(
        height: 130,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(child: fromDate(context, _dateController)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    child: const Text("Aceptar"),
                    onPressed: () {
                      ref.read(weeklySalesFiltersProvider.notifier).state = [
                        _dateController.text.toString().split(" ")[0],
                        DateTime.parse(_dateController.text.toString().split(" ")[0]).add(const Duration(days: 6)).toString()
                      ];
                      ref.read(weeklySalesProvider.notifier).loadData(ref.read(weeklySalesFiltersProvider));
                      Navigator.pop(context);
                    },
                  ),
                  MaterialButton(
                    child: const Text("Cancelar"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ]
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