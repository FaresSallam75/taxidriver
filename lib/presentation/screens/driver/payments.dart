import 'package:chat/business_logic/payment/payment_cubit.dart';
import 'package:chat/business_logic/payment/payment_state.dart';
import 'package:chat/data/model/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Payments'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: FutureBuilder<List<PaymentModel>>(
          future: context.read<PaymentCubit>().viewPaymentData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final payment = snapshot.data;
            if (payment == null || payment.isEmpty) {
              return const Center(child: Text('No payments found.'));
            }
            return BlocBuilder<PaymentCubit, PaymentState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: payment.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text(payment[index].method!),
                      subtitle: Text(payment[index].status!),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(payment[index].time!),
                          Text(payment[index].amount!),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
