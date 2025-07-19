import 'package:flood_monitoring/dao/mysql_dao/mysql_connection.dart';
import 'package:flood_monitoring/models/subscriber.dart';

class SqlSubscribersDAO {
  Future<void> insertToMySQL(Subscriber subscriberData) async {
    final conn = await MySQLService.getConnection();

    try {
      final result = await conn.execute(
        'SELECT id FROM subscribers WHERE id = :id',
        {'id': subscriberData.id},
      );

      if (result.rows.isNotEmpty) {
        return; 
      }

      await conn.execute(
        'INSERT INTO subscribers (id, fullName, age, gender, phoneNumber, address, registeredDate, viaSMS) '
        'VALUES (:id, :fullName, :age, :gender, :phoneNumber, :address, :registeredDate, :viaSMS)',
        {
          'id': subscriberData.id,
          'fullName': subscriberData.name,
          'age': subscriberData.age,
          'gender': subscriberData.gender,
          'phoneNumber': subscriberData.phone,
          'address': subscriberData.address,
          'registeredDate': subscriberData.registeredDate,
          'viaSMS': subscriberData.viaSMS,
        },
      );
    } catch (e) {
      print('Error inserting subscriber: $e');
      throw Exception(
        'There is an error while registering subscriber. Try again later.',
      );
    } finally {
      await conn.close();
    }
  }

  Future<void> addSubscriber(Subscriber subscriberData) async {
    final conn = await MySQLService.getConnection();
    try {
      await conn.execute(
        'INSERT INTO subscribers (id, fullName, age, gender, phoneNumber, address, registeredDate, viaSMS) VALUES (:id, :fullName, :age, :gender, :phoneNumber, :address, :registeredDate, :viaSMS)',
        {
          'id': subscriberData.id,
          'fullName': subscriberData.name,
          'age': subscriberData.age,
          'gender': subscriberData.gender,
          'phoneNumber': subscriberData.phone,
          'address': subscriberData.address,
          'registeredDate': subscriberData.registeredDate,
          'viaSMS': 1,
        },
      );
    } catch (e) {
      print('Error inserting subscriber: $e');
      throw ('There is an error while registering subscriber, Try again later.');
    } finally {
      await conn.close();
    }
  }

  Future<void> deleteSubscriber(String id) async {
    final conn = await MySQLService.getConnection();

    try {
      await conn.execute('DELETE FROM subscribers WHERE id = :id', {'id': id});
    } catch (e) {
      print('Error deleting subscriber: $e');
    } finally {
      await conn.close();
    }
  }

  Future<int> countSubscribers() async {
    final conn = await MySQLService.getConnection();
    try {
      final result = await conn.execute('SELECT * FROM subscribers');
      int count = result.rows.length;
      return count;
    } catch (e) {
      print('Error counting subscribers: $e');
    } finally {
      await conn.close();
    }
    return 0;
  }

  Future<List<Map<String, String?>>> fetchSubscribers() async {
    final conn = await MySQLService.getConnection();
    try {
      final result = await conn.execute('SELECT * FROM subscribers');

      List<Map<String, String?>> subscribers = result.rows.map((row) {
        return {
          'id': row.colByName('id')?.toString(),
          'fullName': row.colByName('fullName')?.toString(),
          'age': row.colByName('age')?.toString(),
          'gender': row.colByName('gender')?.toString(),
          'address': row.colByName('address')?.toString(),
          'phoneNumber': row.colByName('phoneNumber')?.toString(),
          'registeredDate': row.colByName('registeredDate')?.toString(),
        };
      }).toList();
      return subscribers;
    } catch (e) {
      print('Error fetching subscribers : $e');
      rethrow;
    } finally {
      await conn.close();
    }
  }
}
