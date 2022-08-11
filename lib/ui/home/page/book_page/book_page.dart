import 'package:flutter/material.dart';
class BookPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('다만 이뿐 아니라 우리가 환난 중에도 즐거워하나니 환난은 인내를, 인내는 연단을, 연단은 소망을 이루는 줄 앎이로다.',
            style: TextStyle(
                height: 1.4,
              fontSize: 16,
            ),
            ),
            SizedBox(height: 20,),
            Center(
              child: Text('로마서 5:3-4',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.black54
                ),),
            )
          ],
        ),
      )
    );
  }
}
