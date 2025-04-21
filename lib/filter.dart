import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterFirestore extends StatefulWidget {
  const FilterFirestore({super.key});

  @override
  State<FilterFirestore> createState() => _FilterFirestoreState();
}

class _FilterFirestoreState extends State<FilterFirestore> {
  //RealTime Database
  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  /*List<QueryDocumentSnapshot> data = [];
  initialData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot userdata =
        await users.orderBy("age", descending: false).get();
    /*
     //Filtering
     weherIn:[بنكتب مجموعة من الاعمار اللي بدنا نفلترها]
     whereNotIn:[بنكتب مجموعة من الاعمار اللي ما بدنا اياها]
     
     في حال ضفت حقل من نوع اري داخل الفايرستور بقدر اعمل فلتر  ع المستخدمين باستخدام:
     arrayContains:
     arrayContainsAny:[]

     //orderby
     ("age", descending: false):==default بترتبلي البيانات حسب العمر من الاصغر للاكبر
     ("age", ascending: true): بترتبلي البيانات حسب العمر من الاكبر للاصغر

     limt([عدد العناصر]):==بحدد عدد العناصر اللي بدي اياها من الفايرستور
     StartAt([بدي يبدا من العمر كزا]):==بحدد من وين بدي ابدأ
     //descending: true==بوجودها بينعكس عملها  

    StaertAfter([])==بعد العمر كزا

    endAt([])==اصغر او يساوي العمر كزا مثلا
    endBefore([])==اصغر من العمر كزا مثلا
    

   */

    //data = userdata.docs; بضيف البيانات مباشرة بدون استخدام حلقة
    userdata.docs.forEach((element) {
      data.add(element);
    });
    setState(() {});
  }
*/
  @override
  void initState() {
    super.initState();
    //initialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FilterFirestore')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance.collection('users');
          DocumentReference doc1 = FirebaseFirestore.instance
              .collection('users')
              .doc('1');
          DocumentReference doc2 = FirebaseFirestore.instance
              .collection('users')
              .doc('2');

          WriteBatch batch = FirebaseFirestore.instance.batch();
          batch.set(doc1, {'username': 'ahmad', 'age': 34, 'money': 10000});
          batch.set(doc2, {'username': 'NoNo', 'age': 26, 'money': 600000});
          batch.delete(doc1);
          batch.update(doc2, {'money': 1000});
          batch.commit();
        },
        backgroundColor: Colors.pink[200],
        child: Icon(Icons.add, color: Colors.blue),
      ),
      body: StreamBuilder(
        stream: usersStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Data'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  DocumentReference documentReference = FirebaseFirestore
                      .instance
                      .collection('users')
                      .doc(snapshot.data!.docs[index].id);

                  FirebaseFirestore.instance.runTransaction((
                    transaction,
                  ) async {
                    DocumentSnapshot snapshot = await transaction.get(
                      documentReference,
                    );

                    if (snapshot.exists) {
                      var snapshotData = snapshot.data();
                      if (snapshotData is Map<String, dynamic>) {
                        int money = snapshotData['money'] + 100;
                        transaction.update(documentReference, {'money': money});
                      }
                    }
                  });
                },
                child: Card(
                  child: ListTile(
                    title: Text(
                      snapshot.data!.docs[index]['username'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text("age :${snapshot.data!.docs[index]['age']}"),
                    trailing: Text(
                      "${snapshot.data!.docs[index]['money']}\$",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
