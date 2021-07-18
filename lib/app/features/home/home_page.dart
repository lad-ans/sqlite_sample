import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/utils/db.dart';
import '../data/data_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _db = DB();
  Stream<List<DataModel>> _data;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  @override
  void initState() {
    _db.initializeDatabase().then((value) async {
      // await _db.deleteData();
      _data = _db.getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            StreamBuilder<Object>(
              stream: _data,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DataModel> data = snapshot.data;
                  if (data.length > 0)
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Nome: ${data[index].name}'),
                              Text('Apelido: ${data[index].surname}'),
                              Text('Idade: ${data[index].age}')
                            ],
                          ),
                        );
                      },
                    );
                }
                return Text('No data');
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nome..',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _surnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Apelido..',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Idade..',
                ),
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          DataModel _model = DataModel(
            name: _nameController.text,
            surname: _surnameController.text,
            age: int.parse(_ageController.text),
            createdAt: DateTime.now().toIso8601String(),
          );
          try {
            await _db.insertData(_model);
          } catch (e) {}
        },
      ),
    );
  }
}
