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
          return InkWell(
            onTap: () {
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('users')
                  .doc(data[i].id);

              FirebaseFirestore.instance
                  .runTransaction((transaction) async {
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
                  })
                  .then((value) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      "filterfirestore",
                      (route) => false,
                    );
                  });
            },

            child: Card(
              child: ListTile(
                trailing: Text(
                  "${data[i]['money']}\$",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                title: Text(
                  data[i]['username'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text("${data[i]['age']}"),
              ),
            ),
          );
        },
      ),
    );
  }
}
