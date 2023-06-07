import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lms_app/auth_provider.dart';
import 'package:lms_app/components/item_card.dart';
import 'package:lms_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'components/my_appbar.dart';
import 'components/navigation_drawer.dart';
import 'item_model.dart';

class LendScreen extends StatefulWidget {
  const LendScreen({super.key});

  @override
  State<LendScreen> createState() => _LendScreenState();
}

class _LendScreenState extends State<LendScreen> {
  int currentStep = 0;
  List<bool> isSelected = [true, false];
  var itemIdController = TextEditingController();
  var readerIdController = TextEditingController();
  bool loading1 = false;
  bool loading3 = false;
  bool loading4 = false;
  Item? item;
  bool error1 = false;
  String? error;
  String readerName = '';
  bool isCompleted = false;
  String dueDate = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(const Duration(days: 14)));
  final dateController = TextEditingController();

  Future<void> checkItem(context) async {
    setState(() {
      loading1 = true;
    });
    if (itemIdController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an item ID'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        loading1 = false;
        error1 = true;
      });
      return;
    }
    print(itemIdController.text);
    final url = '$baseUrl/api/guest/items/${itemIdController.text}';
    final response = await http.get(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    });
    print(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        item = Item.fromJson(json);
        error1 = false;
      });
      print(item!.title);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item found: ${item!.title}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      final json = jsonDecode(response.body);
      setState(() {
        error1 = true;
        error = json['error'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error!),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      loading1 = false;
    });
  }

  Future<void> checkReader(context) async {
    setState(() {
      loading3 = true;
    });
    if (readerIdController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a reader ID'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        loading3 = false;
        error1 = true;
      });
      return;
    }
    final url = '$baseUrl/api/librarian/getReader/${readerIdController.text}';
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.getJwtToken();
    final response = await http.get(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        error1 = false;
        readerName = json['name'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reader found: $readerName'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      final json = jsonDecode(response.body);
      setState(() {
        error1 = true;
        error = json['error'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error!),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      loading3 = false;
    });
  }

  Future<void> confirmLend(context) async {
    setState(() {
      loading4 = true;
    });
    const url = '$baseUrl/api/librarian/setBorrowed';
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.getJwtToken();
    final body = {
      'itemId': itemIdController.text,
      'readerId': readerIdController.text,
      'returnDate': dueDate
    };
    final response = await http
        .put(Uri.parse(url), body: jsonEncode(body), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item successfully lent'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        isCompleted = true;
      });
    } else {
      final json = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(json['error']),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      loading4 = false;
    });
  }

  Future<void> confirmReturn(context) async {
    setState(() {
      loading4 = true;
    });
    const url = '$baseUrl/api/librarian/setReturned';
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.getJwtToken();
    final body = {
      'itemId': itemIdController.text,
      'readerId': readerIdController.text,
    };
    final response = await http
        .put(Uri.parse(url), body: jsonEncode(body), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item successfully returned'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        isCompleted = true;
      });
    } else {
      final json = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(json['error']),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      loading4 = false;
    });
  }

  @override
  void initState() {
    super.initState();
    dateController.text = dueDate.toString().substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: myAppBar(),
      drawer: const MyDrawer(),
      body: isCompleted
          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                isSelected[0]
                    ? const Text('Item successfully lent')
                    : const Text('Item successfully returned'),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 30,
                )
              ]),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCompleted = false;
                      isSelected = [true, false];
                      itemIdController.text = '';
                      readerIdController.text = '';
                      readerName = '';
                      currentStep = 0;
                      dueDate = DateFormat('yyyy-MM-dd')
                          .format(DateTime.now().add(const Duration(days: 14)));
                      dateController.text = dueDate.toString().substring(0, 10);
                      item = null;
                    });
                  },
                  child: const Text('RESET'))
            ])
          : Stepper(
              steps: getSteps(),
              currentStep: currentStep,
              onStepContinue: () async {
                final isLastStep = currentStep == getSteps().length - 1;
                if (currentStep == 0) {
                  await checkItem(context);
                } else if (currentStep == 2) {
                  await checkReader(context);
                }
                if (error1) return;
                if (isLastStep) {
                  if (isSelected[0]) {
                    await confirmLend(context);
                  } else {
                    await confirmReturn(context);
                  }
                  print('Completed');
                } else {
                  setState(() => currentStep += 1);
                }
              },
              onStepCancel: () {
                currentStep == 0 ? null : setState(() => currentStep -= 1);
              },
              controlsBuilder: (context, controls) {
                final isLastStep = currentStep == getSteps().length - 1;
                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: controls.onStepContinue,
                      child: Text(isLastStep ? 'CONFIRM' : 'NEXT'),
                    )),
                    const SizedBox(width: 12),
                    if (currentStep != 0)
                      Expanded(
                          child: ElevatedButton(
                        onPressed: controls.onStepCancel,
                        child: const Text('BACK'),
                      )),
                  ]),
                );
              }),
    );
  }

  List<Step> getSteps() => [
        Step(
          isActive: currentStep >= 0,
          title: const Text('Item'),
          content: Column(
            children: <Widget>[
              const Text('Please enter Item ID',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextFormField(
                controller: itemIdController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Item ID',
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),
              if (loading1) const LinearProgressIndicator(),
            ],
          ),
        ),
        Step(
          isActive: currentStep >= 1,
          title: const Text('Process type'),
          content: Column(
            children: [
              const Text('Please select the process type',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              ToggleButtons(
                isSelected: isSelected,
                onPressed: (int index) {
                  if (index == 0) {
                    setState(() {
                      isSelected[0] = true;
                      isSelected[1] = false;
                    });
                  } else {
                    setState(() {
                      isSelected[0] = false;
                      isSelected[1] = true;
                    });
                  }
                },
                renderBorder: false,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(children: const [
                      Icon(Icons.bookmark_add_outlined),
                      Text('Lend')
                    ]),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(children: const [
                        Icon(Icons.bookmark_added_outlined),
                        Text('Return')
                      ]))
                ],
              ),
            ],
          ),
        ),
        Step(
          isActive: currentStep >= 2,
          title: const Text('Reader'),
          content: Column(
            children: <Widget>[
              const Text('Please enter the Reader ID',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextFormField(
                controller: readerIdController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Reader ID',
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),
              isSelected[0]
                  ? TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: 'Due date',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.now().add(const Duration(days: 14)),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2050),
                        );
                        if (picked != null) {
                          setState(() {
                            dueDate = DateFormat('yyyy-MM-dd').format(picked);
                            dateController.text =
                                dueDate.toString().substring(0, 10);
                            print(dueDate);
                          });
                        }
                      },
                    )
                  : const SizedBox(height: 0),
              const SizedBox(height: 8),
              if (loading3) const LinearProgressIndicator(),
            ],
          ),
        ),
        Step(
          isActive: currentStep >= 3,
          title: const Text('Confirm'),
          content: SingleChildScrollView(
            child: Column(children: [
              (isSelected[0])
                  ? const Text('Lending the following item to',
                      style: TextStyle(fontSize: 18))
                  : const Text('Setting the following item as returned by',
                      style: TextStyle(fontSize: 18)),
              const SizedBox(height: 5),
              Text(readerName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              item != null ? buildItemCard(item!) : Container(),
            ]),
          ),
        ),
      ];
}
