import 'package:flutter/material.dart';
import 'package:newtel_app_test/models/plan_model.dart';
import 'package:newtel_app_test/providers/plan_notifier.dart';
import 'package:provider/provider.dart';

class PlanesScreen extends StatefulWidget {
  @override
  _PlanesScreenState createState() => _PlanesScreenState();
}

class _PlanesScreenState extends State<PlanesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _costoController = TextEditingController();
  final _comentarioController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final planNotifier = Provider.of<PlanNotifier>(context);
    if (planNotifier.selectedPlan != null) {
      _nombreController.text = planNotifier.selectedPlan!.nombre;
      _costoController.text = planNotifier.selectedPlan!.costo.toString();
      _comentarioController.text = planNotifier.selectedPlan!.comentario;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _costoController.dispose();
    _comentarioController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    PlanNotifier planNotifier = Provider.of<PlanNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Planes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es requerido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _costoController,
                    decoration: InputDecoration(labelText: 'Costo'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El costo es requerido';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Ingrese un número válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _comentarioController,
                    decoration: InputDecoration(labelText: 'Comentario'),
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                          _nombreController.clear();
                          _costoController.clear();
                          _comentarioController.clear();
                          planNotifier.clearForm();
                        },
                        child: const Text('LIMPIAR'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final plan = Plan(
                              nombre: _nombreController.text,
                              costo: double.parse(_costoController.text),
                              comentario: _comentarioController.text,
                              createdAt: DateTime.now(),
                            );
                            planNotifier.savePlan(plan);
                          }
                        },
                        child: const Text('GUARDAR'),
                      ),
                      if (planNotifier.selectedPlan != null)
                        ElevatedButton(
                          onPressed: () {
                            if (planNotifier.selectedPlan != null) {
                              planNotifier.deletePlan(planNotifier.selectedPlan!.id!);
                            }
                          },
                          child: const Text('ELIMINAR')
                        )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              decoration: InputDecoration(
                labelText: 'Buscar por nombre',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                planNotifier.searchPlan(value);
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: planNotifier.planes.length,
                itemBuilder: (context, index) {
                  final plan = planNotifier.planes[index];
                  return ListTile(
                    title: Text(plan.nombre),
                    subtitle: Text('Costo: ${plan.costo}\nComentario: ${plan.comentario}'),
                    onTap: () {
                      planNotifier.selectPlan(plan);
                      _nombreController.text = plan.nombre;
                      _costoController.text = plan.costo.toString();
                      _comentarioController.text = plan.comentario;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
