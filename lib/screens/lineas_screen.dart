import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/linea_notifier.dart';
import '../models/linea_model.dart';

class LineasScreen extends StatefulWidget {
  @override
  _LineasScreenState createState() => _LineasScreenState();
}

class _LineasScreenState extends State<LineasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _proveedorController = TextEditingController();
  final _velocidadController = TextEditingController();
  final _precioController = TextEditingController();
  final _tipoController = TextEditingController();
  final _titularController = TextEditingController();
  final _celularController = TextEditingController();
  final _comentarioController = TextEditingController();
  final _direccionController = TextEditingController();
  final _encargadoController = TextEditingController();

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    final lineaNotifier = Provider.of<LineaNotifier>(context);
    if(lineaNotifier.selectedLinea != null){
      _nombreController.text = lineaNotifier.selectedLinea!.nombre;
      _proveedorController.text = lineaNotifier.selectedLinea!.proveedor;
      _velocidadController.text = lineaNotifier.selectedLinea!.velocidad;
      _precioController.text = lineaNotifier.selectedLinea!.precio.toString();
      _tipoController.text = lineaNotifier.selectedLinea!.tipo;
      _titularController.text = lineaNotifier.selectedLinea!.titular;
      _celularController.text = lineaNotifier.selectedLinea!.celular;
      _comentarioController.text = lineaNotifier.selectedLinea!.comentario;
      _direccionController.text = lineaNotifier.selectedLinea!.direccion;
      _encargadoController.text = lineaNotifier.selectedLinea!.encargado;
    }
  }

  @override
  void dispose(){
    _nombreController.dispose();
    _proveedorController.dispose();
    _velocidadController.dispose();
    _precioController.dispose();
    _tipoController.dispose();
    _titularController.dispose();
    _celularController.dispose();
    _comentarioController.dispose();
    _direccionController.dispose();
    _encargadoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LineaNotifier lineaNotifier = Provider.of<LineaNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Líneas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildCard(
                    child: TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(labelText: 'Nombre'),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'El nombre es requerido';
                        }
                        return null;
                      },
                    ),
                  ),
                  _buildCard(
                    child: TextFormField(
                      controller: _proveedorController,
                      decoration: InputDecoration(labelText: 'Proveedor'),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'El proveedor es requerido';
                        }
                        return null;
                      },
                    ),
                  ),
                  _buildCard(
                    child: TextFormField(
                      controller: _velocidadController,
                      decoration: InputDecoration(labelText: 'Velocidad'),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'La velocidad es requerida';
                        }
                        return null;
                      },
                    ),
                  ),
                  _buildCard(
                    child: TextFormField(
                      controller: _precioController,
                      decoration: InputDecoration(labelText: 'Precio'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'El precio es requerido';
                        }
                        if(double.tryParse(value) == null){
                          return 'Ingrese un número válido';
                        }
                        return null;
                      },
                    ),
                  ),
                  _buildCard(
                    child: TextFormField(
                      controller: _tipoController,
                      decoration: InputDecoration(labelText: 'Tipo'),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'El tipo es requerido';
                        }
                        return null;
                      },
                    ),
                  ),
                  _buildCard(
                    child: TextFormField(
                      controller: _titularController,
                      decoration: InputDecoration(labelText: 'Titular'),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'El titular es requerido';
                        }
                        return null;
                      },
                    ),
                  ),
                  _buildCard(
                    child: TextFormField(
                      controller: _celularController,
                      decoration: InputDecoration(labelText: 'Celular'),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'El celular es requerido';
                        }
                        return null;
                      },
                    ),
                  ),
                  _buildCard(
                    child: TextFormField(
                      controller: _comentarioController,
                      decoration: InputDecoration(labelText: 'Comentario'),
                    ),
                  ),
                  _buildCard(
                    child: TextFormField(
                      controller: _direccionController,
                      decoration: InputDecoration(labelText: 'Dirección'),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'La dirección es requerida';
                        }
                        return null;
                      },
                    ),
                  ),
                  _buildCard(
                    child: TextFormField(
                      controller: _encargadoController,
                      decoration: InputDecoration(labelText: 'Encargado'),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'El encargado es requerido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                          _nombreController.clear();
                          _proveedorController.clear();
                          _velocidadController.clear();
                          _precioController.clear();
                          _tipoController.clear();
                          _titularController.clear();
                          _celularController.clear();
                          _comentarioController.clear();
                          _direccionController.clear();
                          _encargadoController.clear();
                          lineaNotifier.clearForm();
                        },
                        child: const Text('LIMPIAR'),
                      ),
                      ElevatedButton(
                        onPressed: (){
                          if(_formKey.currentState!.validate()){
                            final linea = Linea(
                              nombre: _nombreController.text, 
                              proveedor: _proveedorController.text, 
                              velocidad: _velocidadController.text, 
                              precio: double.parse(_precioController.text), 
                              tipo: _tipoController.text, 
                              titular: _titularController.text, 
                              celular: _celularController.text, 
                              comentario: _comentarioController.text, 
                              direccion: _direccionController.text, 
                              encargado: _encargadoController.text,
                              createdAt: DateTime.now(),
                            );
                            lineaNotifier.saveLinea(linea);
                          }
                        },
                        child: const Text('GUARDAR'),
                      ),
                      if(lineaNotifier.selectedLinea != null)
                        ElevatedButton(
                          onPressed
                          : (){
                           
                            if(lineaNotifier.selectedLinea != null){
                              lineaNotifier.deleteLinea(lineaNotifier.selectedLinea!.id!);
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
            _buildLineasList(lineaNotifier),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  Widget _buildLineasList(LineaNotifier lineaNotifier) {
    return Container(
      height: 500.0, // Ajusta esta altura según sea necesario
      child: ListView.builder(
        itemCount: lineaNotifier.lineas.length,
        itemBuilder: (context, index){
          final linea = lineaNotifier.lineas[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(linea.nombre),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Proveedor: ${linea.proveedor}'),
                    Text('Velocidad: ${linea.velocidad}'),
                    Text('Precio: ${linea.precio}'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    lineaNotifier.deleteLinea(linea.id!);
                  },
                ),
                onTap: (){
                  lineaNotifier.selectLinea(linea);
                  _nombreController.text = linea.nombre;
                  _proveedorController.text = linea.proveedor;
                  _velocidadController.text = linea.velocidad;
                  _precioController.text = linea.precio.toString();
                  _tipoController.text = linea.tipo;
                  _titularController.text = linea.titular;
                  _celularController.text = linea.celular;
                  _comentarioController.text = linea.comentario;
                  _direccionController.text = linea.direccion;
                  _encargadoController.text = linea.encargado;
                },
              ),
            ),
          );
        }
      ),
    );
  }
}
