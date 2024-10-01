import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cliente_model.dart';
import '../models/plan_model.dart';
import '../models/zona_model.dart';
import '../providers/cliente_notifier.dart';
import '../services/cliente_service.dart';
import '../services/api_service.dart';



class ClientesScreen extends StatelessWidget {
  ClientesScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ciController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _contactoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _activacionController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Clientes'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => ClienteNotifier(
          Provider.of<ClienteService>(context, listen: false),
          Provider.of<ApiService>(context, listen: false),
        ),
        child: Consumer<ClienteNotifier>(
          builder: (context, clienteNotifier, child) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          buildTextField(_ciController, 'C.I.'),
                          buildTextField(_nombreController, 'Nombre'),
                          buildTextField(_celularController, 'Celular'),
                          buildTextField(_contactoController, 'Contacto'),
                          buildTextField(_direccionController, 'Dirección'),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              labelText: 'ID de Zona',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            value: clienteNotifier.selectedCliente?.id_zona,
                            onChanged: (int? newValue) {
                              clienteNotifier.selectClienteZona(newValue!);
                            },
                            items: clienteNotifier.zonas.map<DropdownMenuItem<int>>((Zona zona) {
                              return DropdownMenuItem<int>(
                                value: zona.id,
                                child: Text(zona.nombre),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Por favor seleccione una Zona';
                              }
                              return null;
                            },
                          ),
                          buildTextField(_ipController, 'IP'),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              labelText: 'ID de Plan',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            value: clienteNotifier.selectedCliente?.id_plan,
                            onChanged: (int? newValue) {
                              clienteNotifier.selectClientePlan(newValue!);
                            },
                            items: clienteNotifier.planes.map<DropdownMenuItem<int>>((Plan plan) {
                              return DropdownMenuItem<int>(
                                value: plan.id,
                                child: Text(plan.nombre),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Por favor seleccione un Plan';
                              }
                              return null;
                            },
                          ),
                          buildTextField(_activacionController, 'Activación'),
                          buildTextField(_estadoController, 'Estado'),
                          buildTextField(_comentarioController, 'Comentario'),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Buscar cliente',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onChanged: (value) => clienteNotifier.searchCliente(value),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: _clearFields,
                                child: const Text('Limpiar'),
                              ),
                              ElevatedButton(
                                onPressed: () => _saveOrUpdateCliente(context, clienteNotifier),
                                child: Text(clienteNotifier.selectedCliente == null ? 'Guardar' : 'Actualizar'),
                              ),
                              if (clienteNotifier.selectedCliente != null)
                                ElevatedButton(
                                  onPressed: () => _deleteCliente(context, clienteNotifier),
                                  child: const Text('Eliminar'),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildClienteList(context, clienteNotifier),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  TextFormField buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumeric ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        return null;
      },
    );
  }

  void _clearFields() {
    _formKey.currentState!.reset();
    _ciController.clear();
    _nombreController.clear();
    _celularController.clear();
    _contactoController.clear();
    _direccionController.clear();
    _ipController.clear();
    _activacionController.clear();
    _estadoController.clear();
    _comentarioController.clear();
    _searchController.clear();
  }

  Future<void> _deleteCliente(BuildContext context, ClienteNotifier clienteNotifier) async {
    if (clienteNotifier.selectedCliente != null && clienteNotifier.selectedCliente!.id != null) {
      await clienteNotifier.deleteCliente(clienteNotifier.selectedCliente!.id!);
      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente eliminado con éxito')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el cliente')));
    }
  }

  Future<void> _saveOrUpdateCliente(BuildContext context, ClienteNotifier clienteNotifier) async {
    if (_formKey.currentState!.validate()) {
    final idZona = clienteNotifier.selectedZona?.id ?? 0; // Obtener el id de la zona seleccionada
    final idPlan = clienteNotifier.selectedPlan?.id ?? 0; // Obtener el id del plan seleccionado

    final cliente = Cliente(
      id: clienteNotifier.selectedCliente?.id,
      ci: _ciController.text,
      nombre: _nombreController.text,
      celular: _celularController.text,
      contacto: _contactoController.text,
      direccion: _direccionController.text,
      id_zona: idZona,
      ip: _ipController.text,
      id_plan: idPlan,
      activacion: _activacionController.text,
      estado: _estadoController.text,
      comentario: _comentarioController.text,
      created_at: clienteNotifier.selectedCliente?.created_at ?? DateTime.now(),
    );
      try {
        if (clienteNotifier.selectedCliente == null) {
          await clienteNotifier.saveCliente(cliente);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cliente agregado con éxito')));
        } else {
          await clienteNotifier.saveCliente(cliente);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cliente actualizado con éxito')));
        }
        _clearFields();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al guardar el cliente: $e')));
      }
    }
  }

  Widget _buildClienteList(BuildContext context, ClienteNotifier clienteNotifier) {
    final List<Cliente> clientes = clienteNotifier.clientes;
    if (clientes.isEmpty) {
      return const Center(child: Text("No hay clientes disponibles."));
    }
    return InteractiveViewer(
      constrained: false,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('C.I.')),
          DataColumn(label: Text('Celular')),
          DataColumn(label: Text('Contacto')),
          DataColumn(label: Text('Dirección')),
          DataColumn(label: Text('Nombre Zona')),
          DataColumn(label: Text('IP')),
          DataColumn(label: Text('Nombre Plan')),
          DataColumn(label: Text('Activación')),
          DataColumn(label: Text('Estado')),
          DataColumn(label: Text('Comentario')),
        ],
        rows: clientes.map(
          (cliente) => DataRow(
            cells: [
              DataCell(Text(cliente.nombre), onTap: () => clienteNotifier.selectCliente(cliente)),
              DataCell(Text(cliente.ci)),
              DataCell(Text(cliente.celular)),
              DataCell(Text(cliente.contacto)),
              DataCell(Text(cliente.direccion)),
              DataCell(Text(clienteNotifier.getZonaNombre(cliente.id_zona))),
              DataCell(Text(cliente.ip)),
              DataCell(Text(clienteNotifier.getPlanNombre(cliente.id_plan))),
              DataCell(Text(cliente.activacion)),
              DataCell(Text(cliente.estado)),
              DataCell(Text(cliente.comentario)),
            ],
          ),
        ).toList(),
      ),
    );
  }
}
