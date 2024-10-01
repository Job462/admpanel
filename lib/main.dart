import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/plan_notifier.dart';
import '../services/api_service.dart';
import '../screens/clients_screen.dart';
import '../screens/cobranza_screen.dart';
import '../screens/actividades_screen.dart';
import '../screens/planes_screen.dart';
import '../screens/lineas_screen.dart';
import '../screens/reportes_screen.dart';
import '../screens/zonas_screen.dart';
import '../providers/zona_notifier.dart';
import '../providers/linea_notifier.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider( // = 'http://192.168.100.15:8000/'
      providers: [
        ChangeNotifierProvider(create: (_) => ZonaNotifier(ApiService('http://192.168.100.15:8000/api'))),
        ChangeNotifierProvider(create: (_) => LineaNotifier(ApiService('http://192.168.100.15:8000/api'))),
        ChangeNotifierProvider(create: (_) => PlanNotifier(ApiService('http://192.168.100.15:8000/api'))),
      ],
      child: MaterialApp(
        title: 'Newtel App',
        theme: ThemeData(
          primaryColor: Colors.blue,
          hintColor: Colors.blueAccent,
          fontFamily: 'Roboto Mono sample', // o cualquier otra fuente que prefieras
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 16.0),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Newtel App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Newtel App', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Clientes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Cobranza'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CobranzaScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Actividades'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ActividadesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Planes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlanesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Zonas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ZonaScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Líneas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LineasScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Reportes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportesScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: [
            InfoCard(
              title: 'Clientes',
              value: clienteCount.toString(),
              details: 'ACTIVOS: $activoCliente\nINACTIVOS: $inactivoCliente',
              backgroundColor: Colors.yellow.shade100,
            ),
            InfoCard(
              title: 'Zonas',
              value: zonaCount.toString(),
              backgroundColor: Colors.cyan.shade100,
            ),
            InfoCard(
              title: 'Planes',
              value: planCount.toString(),
              backgroundColor: Colors.orange.shade100,
            ),
            InfoCard(
              title: 'Líneas',
              value: lineCount.toString(),
              details: 'MONTO Bs: $totalMonto',
              backgroundColor: Colors.purple.shade100,
            ),
            InfoCard(
              title: 'Flujo de Caja',
              value: '',
              details: 'I: $ingreso\nE: $totalMonto\nU: $beneficio',
              backgroundColor: Colors.green.shade100,
              valueStyle: TextStyle(fontSize: 0), // Hide the value text
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String details;
  final Color backgroundColor;
  final TextStyle? valueStyle;

  const InfoCard({
    Key? key,
    required this.title,
    required this.value,
    this.details = '',
    required this.backgroundColor,
    this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            value,
            style: valueStyle ??
                TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 36.0,
                ),
          ),
          if (details.isNotEmpty) ...[
            SizedBox(height: 8.0),
            Text(
              details,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14.0,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
