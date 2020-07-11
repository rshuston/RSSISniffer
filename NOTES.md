## Bluetooth Development

Make sure you set the following background modes:
* `Uses Bluetooth LE accessories` (bluetooth-central)
* `Acts as a Bluetooth LE accessory` (bluetooth-peripheral)

Make sure you add the following items to your `Info.plist` file:

* `Privacy - Bluetooth Always Usage Description` (NSBluetoothAlwaysUsageDescription)  
  String: This app needs Bluetooth to discover and interact with nearby devices
* `Privacy - Bluetooth Peripheral Usage Description` (NSBluetoothPeripheralUsageDescription)
  String: This app needs Bluetooth to discover and interact with nearby devices

Basic Bluetooth Central-Peripheral connection cycle:

1. Use `CBCentralManager.scanForPeripherals(withServices:options:)` to initiate scanning.
1. Use `CBCentralManagerDelegate.centralManager(_:didDiscover:advertisementData:rssi:)` to acquire new devices.
1. For each discovered `CBPeripheral`,  use `CBCentralManager.connect(_:options:)` to connect to the peripheral, and use `CBCentralManagerDelegate.centralManager(_:didConnect:)` to confirm the connection, or `CBCentralManagerDelegate.centralManager(_:didFailToConnect:error:)` to detect the failure.
1. For each connected peripheral, use `CBCentralManagerDelegate.centralManager(_:didDisconnectPeripheral:error:)` to detect a disconnection.
1. To update the RSSI value of a connected peripheral, use `CBPeripheral.readValue(for:)` to trigger a new read operation, and use `CBPeripheralDelegate.peripheral(_:didReadRSSI:error:)` to retrieve the value.
