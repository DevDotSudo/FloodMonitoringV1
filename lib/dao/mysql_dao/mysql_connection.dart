import 'package:mysql_client/mysql_client.dart';

class MySQLService {
  static Future<MySQLConnection> getConnection() async {
    final conn = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: '_sudo',
      password: 'sudo15',
      databaseName: 'flood_monitoring',
    );
    await conn.connect();
    return conn;
  }
}
