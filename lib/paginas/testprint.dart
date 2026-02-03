import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TestPrint {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final NumberFormat formato = NumberFormat('#,###');

  Future<void> sample2(String pathImage, String direccion, String elId) async {
    final res = await http.get(
      Uri.parse('https://impresora.xeler.io/api/obtenerFactura/$elId'),
    );
    if (res.statusCode != 200) return;

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final isConnected = await bluetooth.isConnected;

    if (isConnected == true) {
      try {
        await bluetooth.printImage(pathImage);
        await bluetooth.printCustom('', 0, 0); // reset
        await bluetooth.printCustom('Fecha: ${body['created_at']}', 12, 0, charset: 'iso-8859-1',);
        await bluetooth.printCustom('Punto: $direccion', 12, 0, charset: 'iso-8859-1',);
        await bluetooth.printCustom('No:  $elId', 12, 0, charset: 'iso-8859-1',);

        await bluetooth.printCustom(
          body['name'].toString(),
          14,
          1,
          charset: 'iso-8859-1',
        );

        final valor = int.tryParse(body['valor']?.toString() ?? '0') ?? 0;
        final currency = body['currency']?.toString() ?? 'COP';
        final valorLetras = body['valor_letras']?.toString() ?? '';

        await bluetooth.printCustom(
          'Valor:  \$ ${formato.format(valor).replaceAll(',', '.')}',
          14,
          1,
        );
        await bluetooth.printCustom(
          '($valorLetras $currency)',
          12,
          1,
          charset: 'iso-8859-1',
        );

        await bluetooth.printCustom(
          'PRIMEROS 3 CARACTERES DE LA WALLET Y ULTIMOS 3 CARACTERES DE LA WALLET',
          12,
          1,
        );
        await bluetooth.printCustom(
          '(${body['wallet_inicio']}) (${body['wallet_fin']})',
          14,
          1,
        );

        await bluetooth.printCustom(
          'Confirmo que los digitos o caracteres mencionados dentro de los parentesis '
          'mas arriba de este comprobante coinciden con los iniciales y finales '
          'de mi monedero o wallet, y que soy el Beneficiario final de la transaccion, '
          'a su vez entiendo que las transacciones en criptomonedas son irreversibles.',
          12,
          0,
          charset: 'iso-8859-1',
        );
        await bluetooth.printCustom(
          'Firma: _________________________________',
          12,
          0,
        );
        await bluetooth.printCustom(
          'Recibe: ________________________________',
          12,
          0,
        );
        await bluetooth.printCustom('>>>      Gracias      <<<', 14, 1);
        await bluetooth.printNewLine();
        await bluetooth.paperCut();
      } catch (error, stackTrace) {
        debugPrint('Error al imprimir factura: $error');
        debugPrint('$stackTrace');
      }
    }
  }

  Future<void> sample(String pathImage, String direccion) async {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd H:mm:ss');
    final String timestamp = formatter.format(now);
    final isConnected = await bluetooth.isConnected;

    if (isConnected == true) {
      try {
        await bluetooth.printImage(pathImage);
        await bluetooth.printCustom('', 0, 0); // reset
        await bluetooth.printCustom('Fecha: $timestamp', 12, 0, charset: 'iso-8859-1',);
        await bluetooth.printCustom('Punto: $direccion', 12, 0, charset: 'iso-8859-1',);
        await bluetooth.printCustom('No: 45345345', 12, 1, charset: 'iso-8859-1',);

        await bluetooth.printCustom(
          'Marcos Pinto nuevo 4',
          14,
          1,
          charset: 'iso-8859-1',
        );
        await bluetooth.printCustom(
          'Valor:  \$ 2.800.000',
          14,
          1,
        );
        await bluetooth.printCustom(
          "(dos millones ocho cientos mil)",
          12,
          1,
        );

        await bluetooth.printCustom(
          'PRIMEROS 3 CARACTERES DE LA WALLET Y ULTIMOS 3 CARACTERES DE LA WALLET',
          12,
          1,
        );
        await bluetooth.printCustom('(3ze) (254)', 14, 1);

        await bluetooth.printCustom(
          'Confirmo que los digitos o caracteres mencionados dentro de los parentesis '
          'mas arriba de este comprobante coinciden con los iniciales y finales '
          'de mi monedero o wallet, y que soy el Beneficiario final de la transaccion, '
          'a su vez entiendo que las transacciones en criptomonedas son irreversibles.',
          12,
          0,
          charset: 'iso-8859-1',
        );
        await bluetooth.printCustom(
          'Firma: _________________________________',
          12,
          0,
        );
        await bluetooth.printCustom(
          'Recibe: ________________________________',
          12,
          0,
        );
        await bluetooth.printCustom('>>>      Gracias      <<<', 14, 1);
        await bluetooth.printNewLine();
        await bluetooth.paperCut();
      } catch (error, stackTrace) {
        debugPrint('Error al imprimir prueba: $error');
        debugPrint('$stackTrace');
      }
    }
  }
}
