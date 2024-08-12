import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:test_isar/bank.info.dart';

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError();
});

class BankListNotifier extends Notifier<List<BankInfo>> {
  late final Isar _isar;
  List<BankInfo> favoriteBankList = [];

  @override
  List<BankInfo> build() {
    _isar = ref.watch(isarProvider);
    _initializeData();
    return [];
  }

  Future<void> _initializeData() async {
    final bankList = await _isar.bankInfos.where().findAll();
    favoriteBankList =
        bankList.where((bank) => bank.isFavorite == true).toList();

    if (bankList.isEmpty) {
      final newBankList = [
        BankInfo(name: "Eastern Bank", imagePath: "assets/ebl.png"),
        BankInfo(name: "Al-Arafa Islami Bank", imagePath: "assets/aibl.png"),
        BankInfo(name: "Mercantile Bank", imagePath: "assets/mtbl.png"),
        BankInfo(name: "Janata Bank", imagePath: "assets/jb.png"),
        BankInfo(name: "Prime Bank", imagePath: "assets/pb.png"),
      ];

      await _isar.writeTxn(() async {
        await _isar.bankInfos.putAll(newBankList);
      });

      state = newBankList;
    } else {
      state = bankList;
    }
  }

  Future<void> updateIsSelected(BankInfo bank) async {
    await _isar.writeTxn(() async {
      // Deselect any previously selected bank
      for (final b in state) {
        if (b.isSelected == true && b.id != bank.id) {
          b.isSelected = false;
          await _isar.bankInfos.put(b);
        }
      }

      // Select the current bank
      bank.isSelected = true;
      await _isar.bankInfos.put(bank);
    });

    // Update the state
    state = [
      for (final b in state)
        if (b.id == bank.id) bank else b,
    ];
  }

  // Future<void> updateIsFavorite(BankInfo bank, bool isFavorite) async {
  //   await _isar.writeTxn(() async {
  //     bank.isFavorite = isFavorite;
  //     await _isar.bankInfos.put(bank);
  //   });

  //   state = [
  //     for (final b in state)
  //       if (b.id == bank.id) bank else b,
  //   ];
  // }
  Future<void> updateIsFavorite(BankInfo bank, bool isFavorite) async {
    await _isar.writeTxn(() async {
      bank.isFavorite = isFavorite;
      await _isar.bankInfos.put(bank);
    });

    if (isFavorite) {
      favoriteBankList = [...favoriteBankList, bank];
      state = state.where((b) => b.id != bank.id).toList();
    } else {
      state = [...state, bank];
      favoriteBankList =
          favoriteBankList.where((b) => b.id != bank.id).toList();
    }

    ref.notifyListeners();
  }
}

final bankListProvider =
    NotifierProvider<BankListNotifier, List<BankInfo>>(BankListNotifier.new);

class FavoriteBankListNotifier extends Notifier<List<BankInfo>> {
  late final Isar _isar;

  @override
  List<BankInfo> build() {
    _isar = ref.watch(isarProvider);
    _initializeData();
    return [];
  }

  Future<void> _initializeData() async {
    final favoriteBankList =
        await _isar.bankInfos.filter().isFavoriteEqualTo(true).findAll();
    state = favoriteBankList;
  }

  Future<void> addFavorite(BankInfo bank) async {
    await _isar.writeTxn(() async {
      bank.isFavorite = true;
      await _isar.bankInfos.put(bank);
    });

    state = [...state, bank];
  }

  Future<void> removeFavorite(BankInfo bank) async {
    await _isar.writeTxn(() async {
      bank.isFavorite = false;
      await _isar.bankInfos.put(bank);
    });

    state = state.where((b) => b.id != bank.id).toList();
  }
}

final favoriteBankListProvider =
    NotifierProvider<FavoriteBankListNotifier, List<BankInfo>>(
        FavoriteBankListNotifier.new);
