import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:test_isar/provider.dart';

class BankInfoPage extends ConsumerWidget {
  const BankInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bankList = ref.watch(bankListProvider);

    final favorite = ref.watch(favoriteBankListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Info'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: bankList.length,
              itemBuilder: (context, index) {
                final bank = bankList[index];
                return InkWell(
                  onTap: () {
                    ref.read(bankListProvider.notifier).updateIsSelected(bank);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: (bank.isSelected ?? false)
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      leading: Image.asset(bank.imagePath ?? ''),
                      title: Text(bank.name ?? ''),
                      trailing: IconButton(
                        icon: Icon(
                          (bank.isFavorite ?? false)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: (bank.isFavorite ?? false) ? Colors.red : null,
                        ),
                        onPressed: () {
                          ref.read(bankListProvider.notifier).updateIsFavorite(
                                bank,
                                !(bank.isFavorite ?? false),
                              );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: favorite.length,
              itemBuilder: (context, index) {
                final bank = favorite[index];
                return InkWell(
                  onTap: () {
                    ref.read(bankListProvider.notifier).updateIsSelected(bank);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: (bank.isSelected ?? false)
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      leading: Image.asset(bank.imagePath ?? ''),
                      title: Text(bank.name ?? ''),
                      trailing: IconButton(
                        icon: Icon(
                          (bank.isFavorite ?? false)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: (bank.isFavorite ?? false) ? Colors.red : null,
                        ),
                        onPressed: () {
                          ref.read(bankListProvider.notifier).updateIsFavorite(
                                bank,
                                !(bank.isFavorite ?? false),
                              );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
