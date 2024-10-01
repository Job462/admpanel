import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/zona_notifier.dart';
import '../models/linea_model.dart';
import '../models/zona_model.dart';

class ZonaScreen extends StatefulWidget {
  @override
  _ZonaScreenState createState() => _ZonaScreenState();
}

class _ZonaScreenState extends State<ZonaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _comentarioController = TextEditingController();
  int? _selectedLinea;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final zonaNotifier = Provider.of<ZonaNotifier>(context);
    if (zonaNotifier.selectedZona != null) {
      _nombreController.text = zonaNotifier.selectedZona!.nombre;
      _comentarioController.text = zonaNotifier.selectedZona!.comentario ?? '';
      _selectedLinea = zonaNotifier.selectedZona!.idLinea;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ZonaNotifier zonaNotifier = Provider.of<ZonaNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Zonas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                      if(value == null || value.isEmpty){
                        return 'El nombre es requerido';
                      }
                      return null;
                    },
                  ),
                  Consumer<ZonaNotifier>(
                    builder: (context, notifier, child){
                      return DropdownButtonFormField<int>(
                        value: _selectedLinea,
                        decoration: InputDecoration(labelText: 'Línea'),
                        items: notifier.lineas.map((linea) {
                          return DropdownMenuItem<int>(
                            value: linea.id,
                            child: Text(linea.nombre),
                          );
                        }).toList(),
                        onChanged: (value) {
                            _selectedLinea = value;
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Seleccione una línea';
                          }
                          return null;
                        },
                      );
                    },
                  ),                  
                  TextFormField(
                    controller: _comentarioController,
                    decoration: InputDecoration(labelText: 'Comentarios'),
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                          _nombreController.clear();
                          setState(() {
                            _selectedLinea = null;
                          });
                          _comentarioController.clear();
                          zonaNotifier.clearForm();
                        },
                        child: const Text('LIMPIAR'),
                      ),
                      ElevatedButton(
                        onPressed: (){
                          if(_formKey.currentState!.validate()){
                            if(_selectedLinea != null){
                              final zona = Zona( 
                                nombre: _nombreController.text, 
                                idLinea: _selectedLinea!,
                                comentario: _comentarioController.text, 
                                createdAt: DateTime.now()
                              );
                              zonaNotifier.saveZona(zona);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Seleccione una línea'),
                              )); 
                            }
                          }
                        },  
                        child: const Text('GUARDAR')
                      ),
                      if(zonaNotifier.selectedZona != null)
                        ElevatedButton(
                          onPressed: () {
                            if(zonaNotifier.selectedZona != null){
                              zonaNotifier.deleteZona(zonaNotifier.selectedZona!.id!);
                            }
                          },
                          child: const Text('ELIMINAR'),
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
                zonaNotifier.searchZona(value);
              },
            ),
            Expanded(
              child: Consumer<ZonaNotifier>(
                builder: (context, notifier, child) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Línea')),
                        DataColumn(label: Text('Comentarios')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: notifier.zonas.map((zona) {
                        final linea = notifier.lineas.firstWhere(
                          (linea) => linea.id == zona.idLinea,
                          orElse: () => Linea(
                            id: 0,
                            nombre: 'N/A',
                            proveedor: '',
                            velocidad: '',
                            precio: 0.0,
                            tipo: '',
                            titular: '',
                            celular: '',
                            comentario: '',
                            direccion: '',
                            encargado: '',
                            createdAt: DateTime.now(),
                          ),
                        );
                        return DataRow(cells: [
                          DataCell(Text(zona.nombre)),
                          DataCell(Text(linea.nombre)),
                          DataCell(Text(zona.comentario ?? '')),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    notifier.selectZona(zona);
                                    _nombreController.text = zona.nombre;
                                    _comentarioController.text = zona.comentario ?? '';
                                    setState(() {
                                      _selectedLinea = zona.idLinea;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    notifier.deleteZona(zona.id!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
    ); 
  }
}
