import 'dart:async';
import 'dart:convert' show JsonEncoder, jsonEncode, utf8;
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_test_ble/screen/page1.dart';
import 'package:flutter_test_ble/screen/page2.dart';
import 'package:flutter_test_ble/screen/page3.dart';

class DeviceScreen extends StatefulWidget {
  DeviceScreen({Key? key, required this.device}) : super(key: key);
  // 장치 정보 전달 받기
  final BluetoothDevice device;

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  // flutterBlue
  FlutterBlue flutterBlue = FlutterBlue.instance;
  // 연결 상태 표시 문자열
  String stateText = 'Connecting';

  // 연결 버튼 문자열
  String connectButtonText = 'Disconnect';

  // 현재 연결 상태 저장용
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;

  // 연결 상태 리스너 핸들 화면 종료시 리스너 해제를 위함
  StreamSubscription<BluetoothDeviceState>? _stateListener;
  final String SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50EBBBBB000";
  final String CHARACTERISTIC_UUID = "6E400003-B5A3-F393-E0A9-E50EBBBBB000";
  late bool isReady;
  List<int>? _valueNotify;
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  final _writeController = TextEditingController();
  BluetoothCharacteristic? _characteristic;
  @override
  initState() {
    super.initState();
    // 상태 연결 리스너 등록
    _stateListener = widget.device.state.listen((event) {
      debugPrint('event :  $event');
      if (deviceState == event) {
        // 상태가 동일하다면 무시
        return;
      }
      // 연결 상태 정보 변경
      setBleConnectionState(event);
    });
    isReady = false;
    // 연결 시작
    connect();
  }

  @override
  void dispose() {
    // 상태 리스터 해제
    _stateListener?.cancel();
    // 연결 해제
    disconnect();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      // 화면이 mounted 되었을때만 업데이트 되게 함
      super.setState(fn);
    }
  }

  /* 연결 상태 갱신 */
  setBleConnectionState(BluetoothDeviceState event) {
    switch (event) {
      case BluetoothDeviceState.disconnected:
        stateText = 'Disconnected';
        // 버튼 상태 변경
        connectButtonText = 'Connect';
        break;
      case BluetoothDeviceState.disconnecting:
        stateText = 'Disconnecting';
        break;
      case BluetoothDeviceState.connected:
        stateText = 'Connected';
        // 버튼 상태 변경
        connectButtonText = 'Disconnect';
        break;
      case BluetoothDeviceState.connecting:
        stateText = 'Connecting';
        break;
    }
    //이전 상태 이벤트 저장
    deviceState = event;
    setState(() {});
  }

  /* 연결 시작 */
  Future<bool> connect() async {
    Future<bool>? returnValue;
    setState(() {
      /* 상태 표시를 Connecting으로 변경 */
      stateText = 'Connecting';
    });

    /* 
      타임아웃을 10초(10000ms)로 설정 및 autoconnect 해제
       참고로 autoconnect가 true되어있으면 연결이 지연되는 경우가 있음.
     */
    await widget.device
        .connect(autoConnect: false)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      //타임아웃 발생
      //returnValue를 false로 설정
      returnValue = Future.value(false);
      debugPrint('timeout failed');

      //연결 상태 disconnected로 변경
      setBleConnectionState(BluetoothDeviceState.disconnected);
    }).then((data) async {
      if (returnValue == null) {
        //returnValue가 null이면 timeout이 발생한 것이 아니므로 연결 성공
        debugPrint('connection successful');
        returnValue = Future.value(true);
        print('widget.device = ${widget.device}');
      }
      print('widget.device = ${widget.device}');
      if (widget.device == null) {
        _Pop();
      }
      List<BluetoothService> services = await widget.device.discoverServices();
      print("success discovered");
      services.map((e) => print(e));
      services.forEach((service) async {
        if (service.uuid.toString() == SERVICE_UUID.toString().toLowerCase()) {
          print('##########service.uuid == SERVICE_UUID ################');
          service.characteristics.forEach((characteristic) async {
            _characteristic = characteristic;
            print('_characteristic = ${_characteristic}');
            if (characteristic.uuid.toString() ==
                '6e400003-b5a3-f393-e0a9-e50ebbbbb000'.toLowerCase()) {
              if (characteristic.properties.notify) {
                characteristic.value.listen((value) {
                  if (value != null) {
                    print(_dataParser(value));
                    setState(() {
                      _valueNotify = value;
                    });

                    if (_dataParser(value).toString() == 'RX00#') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => page1_screen(
                                    valueTx: value,
                                  )));
                      print('gotopage1');
                    } else if (_dataParser(value).toString() == 'RX0101#') {
                      print('gotopage2');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => page2_screen(
                                    valueTx: value,
                                    characteristic: _characteristic!,
                                  )));
                    } else if (_dataParser(value).toString() == 'RX0299#') {
                      print('gotopage3');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => page3_screen(
                                    valueTx: value,
                                    characteristic: _characteristic!,
                                  )));
                    }
                    print('_valueNotify ${_valueNotify}');
                  }
                });
                await characteristic
                    .setNotifyValue(!characteristic.isNotifying);
              }
              // // stream = characteristic.value;
              // //  characteristic.setNotifyValue(!characteristic.isNotifying);
              // stream = characteristic.value;
              setState(() {
                isReady = true;
              });
            } else {
              print('no characteristic');
            }
          });
        } else {
          print('No !!!!!!!!! service.uuid');
        }
      });
    });

    return returnValue ?? Future.value(false);
  }

  /* 연결 해제 */
  void disconnect() {
    try {
      setState(() {
        stateText = 'Disconnecting';
      });
      widget.device.disconnect();
    } catch (e) {}
  }

  _Pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /* 장치명 */
        title: Text(widget.device.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /* 연결 상태 */
            Text('$stateText'),
            /* 연결 및 해제 버튼 */
            OutlinedButton(
              onPressed: () {
                if (deviceState == BluetoothDeviceState.connected) {
                  /* 연결된 상태라면 연결 해제 */
                  disconnect();
                } else if (deviceState == BluetoothDeviceState.disconnected) {
                  /* 연결 해재된 상태라면 연결 */
                  connect();
                } else {}
              },
              child: Text(connectButtonText),
            ),
            _valueNotify == null
                ? Text('loadding ..')
                : Text('_valueNotify ${_dataParser(_valueNotify!)}'),
            TextField(
              controller: _writeController,
            ),
            FlatButton(
              child: Text("Send"),
              onPressed: () {
                if (_characteristic == null) {
                  print('!!!!!!!! _characteristic NULL !!!!');
                } else {
                  _characteristic!
                      .write(utf8.encode(_writeController.value.text));
                  print('characteristic.write');
                }
              },
            ),
            FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => page1_screen(
                                valueTx: _valueNotify!,
                              )));
                },
                child: Text('gotopage1'))
          ],
        ),
      ),
    );
  }
}
