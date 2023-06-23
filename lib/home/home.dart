import 'package:flutter/material.dart';

import '../db/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _allDates = [];
  bool _isloading = true;

  void _reloadData() async {
    final data = await SQLHelper.getAllData();
    _allDates = data;
    _isloading = false;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _reloadData();
    });
    print(".. number of items ${_allDates.length}");
  }

  // Add Items
  Future<void> _addItem() async {
    await SQLHelper.createData(
        _titleEditingController.text, _descriptionController.text);
    _reloadData();
  }

// Update Items
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateData(
        id, _titleEditingController.text, _descriptionController.text);
    _reloadData();
  }

  // Delete Items
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red, content: Text('Successfully deleted !!')));
    _reloadData();
  }

  void _showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
          _allDates.firstWhere((element) => element['id'] == id);
      _titleEditingController.text = existingData['title'];
      _descriptionController.text = existingData['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
            padding: EdgeInsets.only(
                top: 30,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _titleEditingController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Title', border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write Short Description'),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await _addItem();
                      }
                      if (id != null) {
                        await _updateItem(id);
                      }
                      _titleEditingController.text = ('');
                      _descriptionController.text = ('');
                      Navigator.of(context).pop();
                      print("Data Addd");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        id == null ? "Add Data" : "UpDate",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: const Text("My Daily Activities"),
      ),
      body:
        ListView.builder(
              itemCount: _allDates.length,
              itemBuilder: (context, index) => Card(
                  color: Colors.white70,
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    title: Text(_allDates[index]['title']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                _showBottomSheet(_allDates[index]['id']),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                              onPressed: () =>
                                  _deleteItem(_allDates[index]['id']),
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    ),
                    subtitle: Text(_allDates[index]['description']),
                  )),
            ),

      floatingActionButton: FloatingActionButton(
          onPressed: () => _showBottomSheet(null),
          child: const Icon(Icons.add))
    );


  }

}
