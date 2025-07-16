import 'package:flood_monitoring/dao/mysql_dao/sql_subscribers_dao.dart';
import 'package:flood_monitoring/models/subscriber.dart';
import 'package:flood_monitoring/utils/encrypt_util.dart';

class SqlSubscriberService {
  final SqlSubscribersDAO _subscribersDao = SqlSubscribersDAO();

  Future<void> syncSubscriberFromFirebase(Subscriber subscriber) async {
    final mappedSubscriber = Subscriber(
      id: subscriber.id,
      name: subscriber.name,
      age: subscriber.age,
      gender: subscriber.gender,
      address: subscriber.address,
      phone: subscriber.phone,
      registeredDate: subscriber.registeredDate,
      viaSMS: subscriber.viaSMS,
    );

    await _subscribersDao.insertToMySQL(mappedSubscriber);
  }

  Future<void> addSubscriber(Subscriber subscriber) async {
    final encryptedSubscriber = Subscriber(
      id: subscriber.id,
      name: Encryption.encryptText(subscriber.name),
      age: Encryption.encryptText(subscriber.age),
      gender: Encryption.encryptText(subscriber.gender),
      phone: Encryption.encryptText(subscriber.phone),
      address: Encryption.encryptText(subscriber.address),
      registeredDate: subscriber.registeredDate,
      viaSMS: subscriber.viaSMS,
    );
    await _subscribersDao.addSubscriber(encryptedSubscriber);
  }

  Future<void> deleteSubscriber(String id) async {
    await _subscribersDao.deleteSubscriber(id);
  }

  Future<int> countSubscribers() async {
    return await _subscribersDao.countSubscribers();
  }

  Future<List<Subscriber>> getAllSubscribers() async {
    final list = await _subscribersDao.fetchSubscribers();
    return list
        .map(
          (data) => Subscriber.fromMap({
            'id': data['id'] ?? '',
            'fullName': Encryption.decryptText(data['fullName'] ?? ''),
            'age': Encryption.decryptText(data['age'] ?? ''),
            'gender': Encryption.decryptText(data['gender'] ?? ''),
            'address': Encryption.decryptText(data['address'] ?? ''),
            'phoneNumber': Encryption.decryptText(data['phoneNumber'] ?? ''),
            'registeredDate': data['registeredDate'] ?? '',
            'viaSMS': data['viaSMS'],
          }),
        )
        .toList();
  }
}
