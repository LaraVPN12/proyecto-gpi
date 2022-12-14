import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import 'package:proyecto_visitas/components/modal.dart';
import 'package:proyecto_visitas/controller/data_controller.dart';
import 'package:proyecto_visitas/model/Visita.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddRegister extends StatefulWidget {
  const AddRegister({super.key});

  @override
  State<AddRegister> createState() => _AddRegisterState();
}

class _AddRegisterState extends State<AddRegister> {
  List<Visita> visitas = [];
  SharedPreferences? preferences;
  static String email = "";
  DataController dataController = DataController();

  @override
  void initState() {
    super.initState();
    loadPreferences();
    getVisitas();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  loadPreferences() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences!.getString("email")!;
    });
  }

  Future getVisitas() async {
    final connection = PostgreSQLConnection(
      'proyecto-visitas.cssse3lhtwmj.us-east-2.rds.amazonaws.com',
      5432,
      'proyecto_gpi',
      username: 'kevin_eli',
      password: 'GPIProj3ct.',
    );
    await connection.open();
    var results = await connection.query(
        ''' SELECT nombre_escuela, fecha FROM visita vv INNER JOIN escuela ee ON vv.id_escuela = ee.id_escuela ''');
    for (var row in results) {
      setState(() {
        visitas.add(Visita(row[0], row[1]));
      });
    }
    await connection.close();
  }

  Modal dialog = Modal();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff152534),
        title: const Text("Visitas del Mes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialog.openInputDialog(
            context,
            "Nueva Visita",
            "Ingrese nombre del Centro Escolar",
            email,
            dataController,
          );
        },
        focusElevation: 5,
        backgroundColor: const Color(0xff55CADB),
        child: const Icon(
          Icons.add,
          size: 25,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: visitas.length,
        itemBuilder: (context, index) {
          Visita visita = visitas[index];
          DateTime dbDate = visita.fecha;
          String formattedDate = DateFormat('dd-MM-yyyy').format(dbDate);
          return Card(
            child: ListTile(
              title: Text(
                visita.nombreEscuela,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(formattedDate),
            ),
          );
        },
      ),
    );
  }
}
