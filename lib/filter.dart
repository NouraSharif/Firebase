import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterFirestore extends StatefulWidget {
  const FilterFirestore({super.key});

  @override
  State<FilterFirestore> createState() => _FilterFirestoreState();
}

class _FilterFirestoreState extends State<FilterFirestore> {
  List<QueryDocumentSnapshot> data = [];

  initialData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot userdata = await users.where("age", isGreaterThan: 20).get();
    /*
     //Filtering
     weherIn:[بنكتب مجموعة من الاعمار اللي بدنا نفلترها]
     whereNotIn:[بنكتب مجموعة من الاعمار اللي ما بدنا اياها]
     
     في حال ضفت حقل من نوع اري داخل الفايرستور بقدر اعمل فلتر  ع المستخدمين باستخدام:
     arrayContains:
     arrayContainsAny:[]
   */

    //data = userdata.docs; بضيف البيانات مباشرة بدون استخدام حلقة
    userdata.docs.forEach((element) {
      data.add(element);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FilterFirestore')),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, i) {
          return Card(
            child: ListTile(
              title: Text(data[i]['username']),
              subtitle: Text("${data[i]['age']}"),
            ),
          );
        },
      ),
    );
  }
}
