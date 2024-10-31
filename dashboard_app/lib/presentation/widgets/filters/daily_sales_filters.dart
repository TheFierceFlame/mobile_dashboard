import 'package:dashboard_app/presentation/providers/analytics/filters_provider.dart';
import 'package:dashboard_app/presentation/providers/analytics/sales/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

TextEditingController _dateController = TextEditingController();

class DailySalesFilters extends ConsumerStatefulWidget {
  const DailySalesFilters({super.key});

  @override
  DailySalesFiltersState createState() => DailySalesFiltersState();
}

class DailySalesFiltersState extends ConsumerState<DailySalesFilters> {
  @override
  void initState() {
    super.initState();
    ref.read(dailySalesFiltersProvider.notifier);
  }

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
              Container(child: fromDate(context, _dateController)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    child: const Text("Aceptar"),
                    onPressed: () {
                      ref.read(dailySalesFiltersProvider.notifier).state = [_dateController.text.toString().split(" ")[0]];
                      ref.read(dailySalesProvider.notifier).loadData(ref.read(dailySalesFiltersProvider));
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