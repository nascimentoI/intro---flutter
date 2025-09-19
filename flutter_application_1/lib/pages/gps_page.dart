import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';


// --- Widget de tela GpsPage ---
class GpsPage extends StatefulWidget {
  const GpsPage({super.key});

  @override
  State<GpsPage> createState() => _GpsPageState();
}

class _GpsPageState extends State<GpsPage> {
  late GpsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GpsController();
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS / Localização'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Localização Atual',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _controller.isLoading ? null : _controller.getCurrentLocation,
                          icon: _controller.isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.location_on),
                          label: const Text('Obter Localização'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _controller.statusMessage,
                        style: TextStyle(
                          color: _controller.currentPosition != null
                              ? Colors.deepPurple
                              : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_controller.currentPosition != null) ...[
                // Mapa
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mapa da Localização',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FlutterMap(
                              mapController: _controller.mapController,
                              options: MapOptions(
                                initialCenter: LatLng(
                                  _controller.currentPosition!.latitude,
                                  _controller.currentPosition!.longitude,
                                ),
                                initialZoom: 16.0,
                                minZoom: 3.0,
                                maxZoom: 18.0,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName:
                                      'com.example.flutter_hardware_resources',
                                ),
                                MarkerLayer(markers: _controller.markers),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Informações de Endereço e CEP
                if (_controller.address != null || _controller.postalCode != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Endereço e CEP',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          if (_controller.address != null)
                            _buildInfoRow('Endereço:', _controller.address!),
                          if (_controller.postalCode != null)
                            _buildInfoRow('CEP:', _controller.postalCode!),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // Detalhes técnicos da localização
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detalhes Técnicos',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Latitude:',
                          '${_controller.currentPosition!.latitude.toStringAsFixed(6)}°',
                        ),
                        _buildInfoRow(
                          'Longitude:',
                          '${_controller.currentPosition!.longitude.toStringAsFixed(6)}°',
                        ),
                        _buildInfoRow(
                          'Altitude:',
                          '${_controller.currentPosition!.altitude.toStringAsFixed(2)} m',
                        ),
                        _buildInfoRow(
                          'Precisão:',
                          '${_controller.currentPosition!.accuracy.toStringAsFixed(2)} m',
                        ),
                        _buildInfoRow(
                          'Velocidade:',
                          '${_controller.currentPosition!.speed.toStringAsFixed(2)} m/s',
                        ),
                        _buildInfoRow(
                          'Direção:',
                          '${_controller.currentPosition!.heading.toStringAsFixed(2)}°',
                        ),
                        _buildInfoRow(
                          'Timestamp:',
                          DateTime.fromMillisecondsSinceEpoch(
                            _controller.currentPosition!.timestamp.millisecondsSinceEpoch,
                          ).toString(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}


class GpsController extends ChangeNotifier {
  Position? _currentPosition;
  bool _isLoading = false;
  String _statusMessage = 'Toque no botão para obter localização';
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  String? _address;
  String? _postalCode;

  // Getters
  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String get statusMessage => _statusMessage;
  MapController get mapController => _mapController;
  List<Marker> get markers => _markers;
  String? get address => _address;
  String? get postalCode => _postalCode;

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    _statusMessage = 'Obtendo localização...';
    notifyListeners();

    try {
      // Verificar permissões
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _statusMessage = 'Permissão de localização negada';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _statusMessage = 'Permissão de localização negada permanentemente';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Verificar se o serviço de localização está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _statusMessage = 'Serviço de localização desabilitado';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Obter localização atual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = position;
      _statusMessage = 'Localização obtida com sucesso!';
      _isLoading = false;
      notifyListeners();

      // Buscar endereço e CEP
      await _getAddressFromCoordinates(position.latitude, position.longitude);

      // Atualizar marcador no mapa
      _updateMapMarker(position.latitude, position.longitude);
    } catch (e) {
      _statusMessage = 'Erro ao obter localização: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _address =
            '${place.street}, ${place.subLocality}, ${place.locality} ${place.administrativeArea}, ${place.subAdministrativeArea}';
        _postalCode = place.postalCode;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar endereço: $e');
      }
      _address = 'Endereço não encontrado';
      _postalCode = 'CEP não encontrado';
      notifyListeners();
    }
  }

  void _updateMapMarker(double latitude, double longitude) {
    _markers = [
      Marker(
        point: LatLng(latitude, longitude),
        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
      ),
    ];
    notifyListeners();

    // Mover câmera para a localização atual de forma segura
    try {
      _mapController.move(LatLng(latitude, longitude), 16.0);
    } catch (e) {
      if (kDebugMode) {
        print('Mapa ainda não inicializado: $e');
      }
    }
  }
}