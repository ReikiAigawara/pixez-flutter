/*
 * Copyright (C) 2020. by perol_notsf, All rights reserved
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>.
 *
 */

import 'package:mobx/mobx.dart';
import 'package:pixez/models/ban_illust_id.dart';
import 'package:pixez/models/ban_tag.dart';
import 'package:pixez/models/ban_user_id.dart';

part 'mute_store.g.dart';

class MuteStore = _MuteStoreBase with _$MuteStore;

abstract class _MuteStoreBase with Store {
  BanIllustIdProvider banIllustIdProvider = BanIllustIdProvider();
  BanUserIdProvider banUserIdProvider = BanUserIdProvider();
  BanTagProvider banTagProvider = BanTagProvider();
  ObservableList<BanUserIdPersist> banUserIds = ObservableList();
  ObservableList<BanTagPersist> banTags = ObservableList();
  ObservableList<BanIllustIdPersist> banillusts = ObservableList();

  _MuteStoreBase() {
  }

  @action
  Future<void> fetchBanUserIds() async {
    await banUserIdProvider.open();
    List<BanUserIdPersist> userids = await banUserIdProvider.getAllAccount();
    banUserIds.clear();
    banUserIds.addAll(userids);
  }

  @action
  Future<void> insertBanUserId(String id, String name) async {
    await banUserIdProvider.open();
    await banUserIdProvider.insert(BanUserIdPersist()
      ..userId = id
      ..name = name);
    await fetchBanUserIds();
  }

  @action
  Future<void> deleteBanUserId(int id) async {
    await banUserIdProvider.open();
    await banUserIdProvider.delete(id);
    await fetchBanUserIds();
  }

  @action
  fetchBanTags() async {
    await banTagProvider.open();
    var results = await banTagProvider.getAllAccount();
    banTags.clear();
    banTags.addAll(results);
  }

  @action
  insertBanTag(BanTagPersist banTagsPersist) async {
    await banTagProvider.open();
    await banTagProvider.insert(banTagsPersist);
    await fetchBanTags();
  }

  @action
  deleteBanTag(int id) async {
    await banTagProvider.open();
    await banTagProvider.delete(id);
    await fetchBanTags();
  }

  @action
  fetchBanIllusts() async {
    await banIllustIdProvider.open();
    var results = await banIllustIdProvider.getAllAccount();
    banillusts.clear();
    banillusts.addAll(results);
  }

  @action
  insertBanIllusts(BanIllustIdPersist banIllustIdPersist) async {
    await banIllustIdProvider.open();
    await banIllustIdProvider.insert(banIllustIdPersist);
    await fetchBanIllusts();
  }

  @action
  deleteBanIllusts(int id) async {
    await banIllustIdProvider.open();
    await banIllustIdProvider.delete(id);
    await fetchBanIllusts();
  }
}