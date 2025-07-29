import 'package:chat/business_logic/orders/orders_cubit.dart';
import 'package:chat/business_logic/orders/orders_state.dart';
import 'package:chat/data/model/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

class HistoryOrders extends StatefulWidget {
  const HistoryOrders({super.key});

  @override
  State<HistoryOrders> createState() => _HistoryOrdersState();
}

class _HistoryOrdersState extends State<HistoryOrders> {
  @override
  void initState() {
    context.read<OrdersCubit>().listBookingOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrdersCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        // bloc: OrdersCubit(),
        builder: (context, state) {
          if (state is OrdersStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersStateError) {
            return Center(child: Text(state.errorMessage));
          }

          final filterd = cubit.listjsonOrders.where((e) {
            return e.status == "3" || e.status == "4";
          });

          if (filterd.isEmpty) {
            return const Center(child: Text("No history found . "));
          }

          return ListView.builder(
            itemCount: filterd.length,
            itemBuilder: (context, index) {
              return HistoryListItem(ordersModel: filterd.toList()[index]);
            },
          );
        },
      ),
    );
  }
}

class HistoryListItem extends StatelessWidget {
  final OrdersModel ordersModel;
  const HistoryListItem({super.key, required this.ordersModel});

  @override
  Widget build(BuildContext context) {
    final jiffyDate = Jiffy.parse(
      ordersModel.timestamp!,
      pattern: "yyyy-MM-dd hh:mm a",
    );
    final jiffyDateNext = Jiffy.parse(
      ordersModel.timestamp!,
      pattern: "yyyy-MM-dd hh:mm a",
    ).add(minutes: 35);
    final formattedDate = jiffyDate.format(pattern: "d MMMM yyyy, HH:mm");
    final formatDateToTime = jiffyDate.format(pattern: "HH:mm");
    final formatDateToTimeNext = jiffyDateNext.format(pattern: "HH:mm");

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  ordersModel.status == "2" || ordersModel.status == "4"
                      ? "COMPLETED"
                      : 'CANCELLED',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(formatDateToTime),
                    SizedBox(height: 40),
                    Text(formatDateToTimeNext),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    const Icon(Icons.location_searching),
                    Container(height: 40, width: 1, color: Colors.grey),
                    const Icon(Icons.location_on),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${ordersModel.fromLocation}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 40),
                      Text(
                        '${ordersModel.toLocation}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
