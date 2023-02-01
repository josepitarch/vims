import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vims/enums/orders.dart';
import 'package:vims/providers/top_movies_provider.dart';

class OrderByDialog extends StatefulWidget {
  const OrderByDialog({super.key});

  @override
  State<OrderByDialog> createState() => _OrderByDialogState();
}

class _OrderByDialogState extends State<OrderByDialog> {
  late OrderBy orderBy;
  @override
  void initState() {
    orderBy = context.read<TopMoviesProvider>().orderBy;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final Map<String, String> options = {
      'average': i18n.order_by_average,
      'year': i18n.order_by_year,
      'shuffle': i18n.order_by_shuffle,
    };

    return Dialog(
      child: SizedBox(
        height: 170,
        width: 120,
        child: Column(
          children: OrderBy.values.map((order) {
            return ListTile(
              title: Text(options[order.value]!),
              leading: Radio<OrderBy>(
                activeColor: Theme.of(context).colorScheme.primary,
                value: order,
                groupValue: orderBy,
                onChanged: (OrderBy? value) {
                  setState(() {
                    orderBy = value!;
                    context.read<TopMoviesProvider>().setOrderBy(value);
                    Navigator.pop(context);
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
