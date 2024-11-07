import 'package:flutter/material.dart';

TextEditingController _dateController = TextEditingController();

class ProductsTrackingFilters extends StatefulWidget {
  final Function callBack;

  const ProductsTrackingFilters({
    super.key,
    required this.callBack
  });

  @override
  State<ProductsTrackingFilters> createState() => _ProductsTrackingFiltersState();
}

class _ProductsTrackingFiltersState extends State<ProductsTrackingFilters> {
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
                      if(_dateController.text.isEmpty) return;
                      
                      widget.callBack(_dateController.text);
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
        labelText: 'Fecha',
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