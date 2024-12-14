import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modelstore/models/cart_item.dart';

class CartCard extends StatefulWidget {
  const CartCard({
    super.key,
    required this.cartItem,
    required this.removeItem,
    required this.incrementItem,
  });

  final CartItem cartItem;
  final Function removeItem;
  final Function incrementItem;

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              backgroundColor: Theme.of(context).canvasColor,
              icon: Icons.delete,
              label: 'Удалить',
              onPressed: (context) =>
                  widget.removeItem(widget.cartItem.item.productId),
            )
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).primaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    widget.cartItem.item.imageUrl,
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Flexible(
                    child: Text(
                      widget.cartItem.item.name,
                      style: const TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'Стоимость: ${widget.cartItem.item.price * widget.cartItem.amount}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => widget.incrementItem(
                                widget.cartItem.item.productId, true),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.cartItem.amount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () => widget.incrementItem(
                                widget.cartItem.item.productId, false),
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
