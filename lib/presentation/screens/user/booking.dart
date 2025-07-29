import 'package:chat/business_logic/orders/orders_cubit.dart';
import 'package:chat/business_logic/orders/orders_state.dart';
import 'package:chat/constant/class/routes.dart';
import 'package:chat/constant/functions/notifications.dart';
import 'package:chat/constant/styles.dart';
import 'package:chat/data/model/orders.dart';
import 'package:chat/presentation/widgets/booking/custombodycard.dart';
import 'package:chat/presentation/widgets/booking/customelevatedbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  double? price;
  String? carName;
  String? fromLocation;
  String? toLocation;
  String? distance;
  String? driverId;

  @override
  void initState() {
    startOnInital(context, "Booking");
    context.read<OrdersCubit>().listBookingOrders();
    context.read<OrdersCubit>().listOrderUsers();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    carName = args!["carName"];
    fromLocation = args["fromLocation"];
    toLocation = args["toLocation"];
    distance = args["distance"];
    driverId = args["driverId"];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Booking"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
          bottom: TabBar(
            labelStyle: meduimStyle,
            tabs: [
              Tab(text: "Upcoming"),
              Tab(text: "Completed"),
              Tab(text: "Cancelled"),
            ],
          ),
        ),

        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: BlocBuilder<OrdersCubit, OrdersState>(
            builder: (context, state) {
              if (state is OrdersStateLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OrdersStateError) {
                return Center(child: Text(state.errorMessage));
              }

              final cubit = context.read<OrdersCubit>();

              final upcomingOrders =
                  cubit.listjsonOrders
                      .where(
                        (order) => order.status == "0" || order.status == "1",
                      )
                      .toList();

              final completedOrders =
                  cubit.listjsonOrders
                      .where(
                        (order) => order.status == "2" || order.status == "4",
                      )
                      .toList();

              final cancelledOrders =
                  cubit.listjsonOrders
                      .where((order) => order.status == "3")
                      .toList();

              return TabBarView(
                controller: DefaultTabController.of(context),

                children: [
                  upcomingOrders.isNotEmpty
                      ? ListView(
                        children:
                            upcomingOrders
                                .map(
                                  (a) => customLoadedData(
                                    context,
                                    a,
                                    isCancelled: false,
                                  ),
                                )
                                .toList(),
                      )
                      : const Center(child: Text('No upcoming orders')),

                  completedOrders.isNotEmpty
                      ? ListView(
                        children:
                            completedOrders
                                .map(
                                  (a) => customLoadedData(
                                    context,
                                    a,
                                    isCancelled: false,
                                  ),
                                )
                                .toList(),
                      )
                      : const Center(child: Text('No completed orders')),

                  cancelledOrders.isNotEmpty
                      ? ListView(
                        children:
                            cancelledOrders
                                .map(
                                  (a) => customLoadedData(
                                    context,
                                    a,
                                    isCancelled: true,
                                  ),
                                )
                                .toList(),
                      )
                      : const Center(child: Text('No cancelled orders')),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget customLoadedData(
    BuildContext context,
    OrdersModel orders, {
    required bool isCancelled,
  }) {
    final cubit = context.read<OrdersCubit>();
    return InkWell(
      onTap: () {},
      child: CarInfoCard(
        carName: orders.carName ?? "", //widget.carName!,
        fromLocation: orders.fromLocation!, //widget.fromLocation!,
        targetLocation: orders.toLocation!, //widget.toLocation!,
        dateTime: orders.timestamp!,

        price:
            double.parse(orders.distance.toString()) < 20.00
                ? 120.00
                : double.parse(orders.distance.toString()) < 50.00
                ? 270.00
                : double.parse(orders.distance.toString()) < 90.00
                ? 580.00
                : 1100.00, //'\$120',
        distance: '${orders.distance.toString()} km',
        status:
            orders.status == "0"
                ? "Waiting approval"
                : orders.status == "1"
                ? "Approved"
                : orders.status == "2"
                ? "Completed"
                : orders.status == "3"
                ? "Cancelled"
                : "Completed",

        widget:
            isCancelled
                ? Container()
                : orders.status == "0" ||
                    orders.status == "1" ||
                    orders.status == "2" ||
                    orders.status == "3"
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    orders.status == "0"
                        ? Flexible(
                          child: CustomElevatedButton(
                            margin: EdgeInsets.only(
                              left: 50.0,
                              top: 0.0,
                              bottom: 0.0,
                            ),
                            text: "Cancel",
                            onPressed: () {
                              cubit.cancelOrder(
                                orders.userId.toString(),
                                orders.docId!,
                                //cubit.listjsonOrders[index]['docId'],
                              );
                            },
                          ),
                        )
                        : Flexible(
                          child: CustomElevatedButton(
                            margin: EdgeInsets.only(
                              left: 7.0,
                              right: 7.0,
                              top: 0.0,
                              bottom: 0.0,
                            ),
                            text: "pay",
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.paymobScreen,
                                arguments: {
                                  "price": double.parse(orders.price!),
                                  "driverId": driverId!,
                                  "docId": orders.docId!,
                                },
                              );
                            },
                          ),
                        ),

                    orders.status == "0"
                        ? Container()
                        : Flexible(
                          child: CustomElevatedButton(
                            margin: EdgeInsets.only(
                              left: 7.0,
                              right: 7.0,
                              top: 0.0,
                              bottom: 0.0,
                            ),
                            text: "Rate",

                            onPressed: () {},
                          ),
                        ),
                  ],
                )
                : Container(),
      ),
    );
  }
}
